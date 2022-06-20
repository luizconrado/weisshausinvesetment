public without sharing class TaxExemptionFormController {
    
    
    @AuraEnabled(cacheable=true)
    public static String getPersonAccountRecordTypeId(){
        return Constant.PERSON_ACCOUNT_RECORDTYPEID;
    }
    
    
    @AuraEnabled (cacheable=true) 
    public static Map<String,List<sObject>> getCustomerDetails(String sbId,String authId,String sfId){
        if(string.isBlank(sbId)) return new Map<String,List<sObject>>();
        List<Account> accountDetails=[SELECT Id, LastName, Solarisbank_Id__c,
                                      (SELECT id,Name,Marital_Status__c FROM Banks__r WHERE  RecordTypeId=:Constant.BANK_SOLARISBANK_RECORDTYPEID),
                                      (SELECT id,Country__c,Identification_Number__c,Name FROM Tax_Identifications__r WHERE Primary__c=true),
                                      (SELECT Id,Name,CreatedDate FROM Bank_Accounts__r  WHERE Type__c='TERM_DEPOSIT' AND Id=:sfId AND Status__c='NO_BLOCK') 
                                      FROM Account 
                                      WHERE Solarisbank_Id__c=:sbId  AND Auth0_ID__c=:authId];
        List<Booking__c> bookings=[SELECT Id,Booking_Date__c FROM Booking__c where Bank_Account__c=:sfId LIMIT 10];
        return new Map<String,List<sObject>>{
        	'Account'=>accountDetails,
                'Booking'=>bookings
        };
    }
    
    @AuraEnabled
    public static String initiateMFARequest(String sbId,String sfId){
        Account accountDetails=[SELECT id,Solarisbank_Id__c,Solarisbank_Tenent__c FROM Account WHERE id=:sfId];
        LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(accountDetails.Id,'Account',accountDetails.Solarisbank_Tenent__c);
        String response=SolarisbankService.startMFA(sbId, apiCallDetails);
        
        SolarisbankCRPRequestWrapper request=SolarisbankCRPRequestWrapper.parse(response);
        
        insert generateChangeLog(sbId, accountDetails.Id, 'Term Deposit From', 'AUTHORIZATION_REQUIRED', null, '/v1/mfa/challenges/sms', request.created_at);
        
        return response;
    }
    
    @AuraEnabled
    public static SolarisbankCRPRequestWrapper initiateCRPRequest(String sfId,String requestChangebody){
        
        List<Change_Request_Log__c> changeRequestList=new List<Change_Request_Log__c>();
        Account bankAccountDetails=[SELECT Id,Solarisbank_Id__c,Solarisbank_Tenent__c FROM Account WHERE id=:sfId];
        LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(sfId,'Account',bankAccountDetails.Solarisbank_Tenent__c);
        
        String responseString = SolarisbankService.updateCustomerData(bankAccountDetails.Solarisbank_Id__c,requestChangebody,apiCallDetails);
        
        SolarisbankCRPRequestWrapper tanUrlResponse=SolarisbankCRPRequestWrapper.parse(responseString);
        
        if(tanUrlResponse.errors!=null && tanUrlResponse.errors.size()>0){
            changeRequestList.add(generateChangeLog(tanUrlResponse.id, sfId, 'Update Account Details', 'FAILED', tanUrlResponse.errors.get(0).title +' : '+tanUrlResponse.errors.get(0).detail, null, null));
            insert changeRequestList;
            return tanUrlResponse;
        }
        else{
            changeRequestList.add(generateChangeLog(tanUrlResponse.id, sfId, 'Update Account Details', tanUrlResponse.status, null, tanUrlResponse.url, tanUrlResponse.updated_at));
        }
        
        
        String crpResponseString = SolarisbankService.initiateCRPRequest(tanUrlResponse.url,bankAccountDetails.Solarisbank_Id__c,apiCallDetails);
        SolarisbankCRPRequestWrapper crpResponse=SolarisbankCRPRequestWrapper.parse(crpResponseString);
        changeRequestList.add(generateChangeLog(crpResponse.id, sfId, 'Update Account Details', crpResponse.status, null, tanUrlResponse.url.replace('/authorize', '/confirm'), crpResponse.updated_at));
        
        insert changeRequestList;
       
        return tanUrlResponse;  
        
    }
    
    @AuraEnabled
    public static String closeMFARequest(String mfaId,String otp,String sfId){
        Account accountDetails=[SELECT id,Solarisbank_Id__c,Solarisbank_Tenent__c FROM Account WHERE id=:sfId];
        LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(accountDetails.Id,'Account',accountDetails.Solarisbank_Tenent__c);
        String response=SolarisbankService.stopMFA(mfaId,otp, apiCallDetails);
        SolarisbankCRPRequestWrapper request=SolarisbankCRPRequestWrapper.parse(response);
        
        insert generateChangeLog(accountDetails.Solarisbank_Id__c, accountDetails.Id, 'Term Deposit From', (request.status=='success')?'COMPLETED':'FAILED', null, '/v1/mfa/challenges/sms/'+mfaId, request.created_at);
        
        return response;
    }
    
    @AuraEnabled
    public static String closeCRPFRequest(String sfId,String tanurl,String otp,String martialStatus){
        List<Change_Request_Log__c> changeRequestList=new List<Change_Request_Log__c>();
        Account bankAccountDetails=[SELECT Id,Solarisbank_Id__c,Solarisbank_Tenent__c FROM Account WHERE id=:sfId];
        
        List<Bank__c> kycDetails=[SELECT id,Marital_Status__c FROM Bank__c WHERE Account__c=:sfId  AND RecordTypeId=:Constant.BANK_SOLARISBANK_RECORDTYPEID];
        LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(sfId,'Account',bankAccountDetails.Solarisbank_Tenent__c);
        String responseString = SolarisbankService.confirmCRPRequest(tanurl,bankAccountDetails.Solarisbank_Id__c,otp,apiCallDetails);
        SolarisbankCRPRequestWrapper tanUrlResponse=SolarisbankCRPRequestWrapper.parse(responseString);
        
        Change_Request_Log__c crpRequestLog=new Change_Request_Log__c();
        if(tanUrlResponse.errors!=null && tanUrlResponse.errors.size()>0){
            crpRequestLog.Solarisbank_Id__c=tanUrlResponse.errors.get(0).id;
            crpRequestLog.Object_Name__c='Account';
            crpRequestLog.Record_Id__c=sfId;
            crpRequestLog.Status__c='FAILED';
            crpRequestLog.Operation__c='Update Account Details';
            crpRequestLog.Description__c=tanUrlResponse.errors.get(0).title +' : '+tanUrlResponse.errors.get(0).detail;
            
        }
        else{
            crpRequestLog.Solarisbank_Id__c=tanUrlResponse.id;
            crpRequestLog.Object_Name__c='Account';
            crpRequestLog.Record_Id__c=sfId;
            crpRequestLog.Operation__c='Update Account Details';
            crpRequestLog.Status__c=tanUrlResponse.status;
            crpRequestLog.Updated_At__c=tanUrlResponse.updated_at;
            crpRequestLog.URL__c=tanUrlResponse.url;
            if(kycDetails.size()>0){
                kycDetails.get(0).Marital_Status__c=martialStatus;
                update kycDetails;
            }
             
            
        }
        
        insert crpRequestLog;
        return responseString;
    }
    
    @AuraEnabled
    public static void createTaxExemptionCase(String accountId,String bankAccountId,String subject,String description,String reason){
        List<Contact> contact=[SELECT id FROM Contact WHERE isPersonAccount=true and AccountId=:accountId LIMIT 1];
        List<Bank_Case_Item__c> bankCaseItems=new List<Bank_Case_Item__c>();
        Case newBankingCase=new Case();
        newBankingCase.recordTypeId=Constant.INVESTMENTCASE_CASE_RECORDTYPEID;
        newBankingCase.Status='NEW';
        newBankingCase.AccountId=accountId;
        newBankingCase.Origin='Web';
        newBankingCase.Priority='Low';
        newBankingCase.Type='Term Deposit';
        newBankingCase.Type_II__c=reason;
        newBankingCase.Reason=reason;
        newBankingCase.Subject=subject; 
        newBankingCase.Description=description;
        if(contact.size()>0) newBankingCase.ContactId=contact.get(0).Id;
        Database.DMLOptions dlo = new Database.DMLOptions();
        dlo.EmailHeader.triggerAutoResponseEmail = true;
        database.insert(newBankingCase, dlo);
         
        
        insert bankCaseItems;
        
        
    }
    
    private static Change_Request_Log__c generateChangeLog(String sbId,String sfId,String operation,String status,String details,String url,DateTime updateAt){
        Change_Request_Log__c changeRequestLog=new Change_Request_Log__c();
        changeRequestLog.Solarisbank_Id__c=sbId;
        changeRequestLog.Operation__c=operation;
        changeRequestLog.Object_Name__c='Account';
        changeRequestLog.Record_Id__c=sfId;
        changeRequestLog.Status__c=status;
        if(details!=null)changeRequestLog.Description__c=details;
        if(updateAt!=null)changeRequestLog.Updated_At__c=updateAt;
        if(url!=null)changeRequestLog.URL__c=url;
        return changeRequestLog;
    }
    
    
}