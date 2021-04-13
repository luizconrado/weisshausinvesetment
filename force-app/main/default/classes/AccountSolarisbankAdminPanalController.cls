public class AccountSolarisbankAdminPanalController {
    
    @AuraEnabled
    public static SolarisbankCRPRequestWrapper intitatePersonDetailsChangeTanRequest(String recordId,String requestChangebody){
        List<Change_Request_Log__c> changeRequestList=new List<Change_Request_Log__c>();
        Account bankAccountDetails=[SELECT Id,Solarisbank_Id__c,Solarisbank_Tenent__c FROM Account WHERE id=:recordId];
        LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(recordId,'Account',bankAccountDetails.Solarisbank_Tenent__c);
        
        String responseString= SolarisbankService.updateCustomerData(bankAccountDetails.Solarisbank_Id__c,requestChangebody,apiCallDetails);
        
        SolarisbankCRPRequestWrapper tanUrlResponse=SolarisbankCRPRequestWrapper.parse(responseString);
        
        if(tanUrlResponse.errors!=null && tanUrlResponse.errors.size()>0){
            Change_Request_Log__c changeRequestLog=new Change_Request_Log__c();
            changeRequestLog.Solarisbank_Id__c=tanUrlResponse.id;
            changeRequestLog.Object_Name__c='Account';
            changeRequestLog.Record_Id__c=recordId;
            changeRequestLog.Status__c='FAILED';
            changeRequestLog.Description__c=tanUrlResponse.errors.get(0).title +' : '+tanUrlResponse.errors.get(0).detail;
            changeRequestList.add(changeRequestLog);
            insert changeRequestList;
            return tanUrlResponse;
        }
        else{
            Change_Request_Log__c changeRequestLog=new Change_Request_Log__c();
            changeRequestLog.Solarisbank_Id__c=tanUrlResponse.id;
            changeRequestLog.Object_Name__c='Account';
            changeRequestLog.Record_Id__c=recordId;
            changeRequestLog.Status__c=tanUrlResponse.status;
            changeRequestLog.Updated_At__c=tanUrlResponse.updated_at;
            changeRequestLog.URL__c=tanUrlResponse.url;
            changeRequestList.add(changeRequestLog);
        }
        
        
        String crpResponseString = SolarisbankService.initiateCRPRequest(tanUrlResponse.url,bankAccountDetails.Solarisbank_Id__c,apiCallDetails);
        SolarisbankCRPRequestWrapper crpResponse=SolarisbankCRPRequestWrapper.parse(crpResponseString);
        
        Change_Request_Log__c crpRequestLog=new Change_Request_Log__c();
        crpRequestLog.Solarisbank_Id__c=crpResponse.id;
        crpRequestLog.Object_Name__c='Account';
        crpRequestLog.Record_Id__c=recordId;
        crpRequestLog.Status__c=crpResponse.status;
        crpRequestLog.Updated_At__c=crpResponse.updated_at;
        crpRequestLog.URL__c=tanUrlResponse.url.replace('/authorize', '/confirm');
        changeRequestList.add(crpRequestLog);
        
        insert changeRequestList;
        return tanUrlResponse;  
    }
    
    @AuraEnabled
    public static String confirmPersonDetailsChangeTanRequest(String recordId,String tanurl,String otp){
        List<Change_Request_Log__c> changeRequestList=new List<Change_Request_Log__c>();
        Account bankAccountDetails=[SELECT Id,Solarisbank_Id__c,Solarisbank_Tenent__c FROM Account WHERE id=:recordId];
        LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(recordId,'Account',bankAccountDetails.Solarisbank_Tenent__c);
        String responseString = SolarisbankService.confirmCRPRequest(tanurl,bankAccountDetails.Solarisbank_Id__c,otp,apiCallDetails);
        SolarisbankCRPRequestWrapper tanUrlResponse=SolarisbankCRPRequestWrapper.parse(responseString);
        
        Change_Request_Log__c crpRequestLog=new Change_Request_Log__c();
        if(tanUrlResponse.errors!=null && tanUrlResponse.errors.size()>0){
            crpRequestLog.Solarisbank_Id__c=tanUrlResponse.errors.get(0).id;
            crpRequestLog.Object_Name__c='Account';
            crpRequestLog.Record_Id__c=recordId;
            crpRequestLog.Status__c='FAILED';
            crpRequestLog.Description__c=tanUrlResponse.errors.get(0).title +' : '+tanUrlResponse.errors.get(0).detail;
            
        }
        else{
            crpRequestLog.Solarisbank_Id__c=tanUrlResponse.id;
            crpRequestLog.Object_Name__c='Account';
            crpRequestLog.Record_Id__c=recordId;
            crpRequestLog.Status__c=tanUrlResponse.status;
            crpRequestLog.Updated_At__c=tanUrlResponse.updated_at;
            crpRequestLog.URL__c=tanUrlResponse.url;
            AccountService.syncPersonDetailsWithSB(bankAccountDetails.id);
        }
        
        
        
        insert crpRequestLog;
        return responseString;
    }
    
    @AuraEnabled
    public static Boolean checkIsCompactLayout() {
        return Salesforce.isCompactLayout;
    }
    
    @auraEnabled(cacheable=true)
    public static Map<String,Map<String,String>> getBankAccountPicklistValues(){
       
 
            Map<String,PicklistEntry[]> picklistValues = SchemaUtil.getObjectPicklistFileds(SchemaUtil.getSobjectType('Bank_Account__c'));
            Map<String,Map<String,String>> fieldAndValuesMap=new Map<String,Map<String,String>>();
            for(String field:picklistValues.keySet()){
                if(!fieldAndValuesMap.containsKey(field)) fieldAndValuesMap.put(field,new Map<String,String>());
                for(PicklistEntry entry:picklistValues.get(field)){
                    if(entry.isActive()) {
                        fieldAndValuesMap.get(field).put(entry.getValue(),entry.getLabel());
                    }
                }
            }
            return fieldAndValuesMap;
        
    }
    
    @auraEnabled(cacheable=true)
    public static Map<String,Map<String,String>> getAccountPicklistValues(){
        return BankCaseOverrideControler.getAccountPicklistValues();
    }
    
    @AuraEnabled
    public static List<sObject> getRecordDetails(Id recordId){
        
        if(recordId.getSobjectType()== Schema.Account.SObjectType)
            return [SELECT id,Marital_Status__c,BillingCountry,BillingPostalCode,BillingCity,BillingStreet,PersonTitle,Salutation,FirstName,LastName,Preferred_Language__pc  FROM ACCOUNT WHERE Id=:recordId];
        else if(recordId.getSobjectType()==Schema.Bank_Account__c.SObjectType)
            return [SELECT id,Person_Account__c,Person_Account__r.Employment_Status__c,Person_Account__r.FirstName,Person_Account__r.LastName FROM Bank_Account__c WHERE Id=:recordId];
        else if(recordId.getSobjectType()==Schema.Card__c.SObjectType)
            return [SELECT id,Status__c FROM Card__c WHERE Id=:recordId];
        
        return null;
    }
    
    @AuraEnabled
    public static String reqeustNewIdentification(String recordId,String languageCode){
        return AccountService.createNewIdentification(recordId,languageCode);
    }
    
    @AuraEnabled 
    public static String requestNewBankCard(String recordId,String body){
        Map<String,Object> cardRequestBody=(Map<String,Object>) JSON.deserializeUntyped(body);
        Bank_Account__c bankAccountDetails=[SELECT Id,Person_Account__c,Solarisbank_Id__c,Person_Account__r.Solarisbank_Id__c,Person_Account__r.FirstName,Person_Account__r.LastName,Person_Account__r.Solarisbank_Tenent__c
                                            FROM Bank_Account__c 
                                            WHERE Id=:recordId];
        LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(recordId,'Bank_Account__c',bankAccountDetails.Person_Account__r.Solarisbank_Tenent__c);
        String res=SolarisbankService.requestNewCard(bankAccountDetails.Person_Account__r.Solarisbank_Id__c, bankAccountDetails.Solarisbank_Id__c, body,apiCallDetails);
        SolarisbankService.CardResponse bankAccount=(SolarisbankService.CardResponse) JSON.deserialize(res, SolarisbankService.CardResponse.class);
        if(bankAccount.errors!=null){
            return res;
        }
        
        Card__c newCard=new Card__c();
        newCard.Status__c=bankAccount.status;
        newCard.Type__c=(String) cardRequestBody.get('type');
        newCard.Name_On_Card__c =(String) cardRequestBody.get('line_1');
        newCard.Person_Account__c=bankAccountDetails.Person_Account__c;
        newCard.Bank_Account__c=bankAccountDetails.Id;
        newCard.Solarisbank_Id__c=bankAccount.id;
        
        insert newCard;
        
        
        
        
        return '{"id":"newCard.id"}';
    }
    
    @AuraEnabled
    public static String changeCardStatus(String recordId,String newStatus,String reason){
        String errorDetails='';
        Card__c cardDetails=[SELECT id,Status__c,Solarisbank_Id__c,Person_Account__r.Solarisbank_Tenent__c FROM Card__c WHERE id=:recordId];
        LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(recordId,'Card__c',cardDetails.Person_Account__r.Solarisbank_Tenent__c);
        
        String apiResponseJSON = '';
        if(newStatus=='Block') apiResponseJSON = SolarisbankService.blockAccountCard(cardDetails.Solarisbank_Id__c,apiCallDetails);    
        if(newStatus=='Close') apiResponseJSON = SolarisbankService.closeAccountCard(cardDetails.Solarisbank_Id__c,apiCallDetails);    
        if(newStatus=='Unblock') apiResponseJSON = SolarisbankService.unblockAccountCard(cardDetails.Solarisbank_Id__c,apiCallDetails);       
        SolarisbankService.CardResponse apiResponse=(SolarisbankService.CardResponse) JSON.deserialize(apiResponseJSON, SolarisbankService.CardResponse.class);
        String responseStatus = apiResponse.status;
        if(apiResponse.errors!=null){
            errorDetails = apiResponse.errors.get(0).detail;
            String newResponseJSON = SolarisbankService.fetchAccountCard(cardDetails.Solarisbank_Id__c,apiCallDetails);
            SolarisbankService.CardResponse newStatusResponse= (SolarisbankService.CardResponse) JSON.deserialize(newResponseJSON, SolarisbankService.CardResponse.class);
            responseStatus = newStatusResponse.status;
        }
        
        cardDetails.Status__c=responseStatus;
        update cardDetails;
        return errorDetails;
    }
    
    @AuraEnabled
    public static String callGoogleMapSearchApi(String searchText,String sessionToken){
        return BankCaseOverrideControler.callGoogleMapSearchApi(searchText,sessionToken);
     }
    
    @AuraEnabled
    public static String callGoogleMapsDetailsApi(String placeId,String sessionToken){
        return BankCaseOverrideControler.callGoogleMapsDetailsApi(placeId,sessionToken);
    }
    
    @AuraEnabled
    public static SolarisbankBankAccountWrapper.Errors requestAccountCloser(String recordId,String reason){
        Bank_Account__c bankAccountDetails=[SELECT id,Status__c,Technical_Closure_Date__c,Legal_Closure_Date__c,Closure_Reasons__c,Person_Account__c,Person_Account__r.Solarisbank_Tenent__c,Solarisbank_Id__c FROM Bank_Account__c WHERE id=:recordId];
        LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(recordId,'Bank_Account__c',bankAccountDetails.Person_Account__r.Solarisbank_Tenent__c);
        String body='{"account_id":"'+bankAccountDetails.Solarisbank_Id__c+'","closure_reason":"'+reason+'"}';
        String responseJson=SolarisbankService.requestCloseAccount(body,apiCallDetails);
        System.debug('responseJson'+responseJson);
        SolarisbankBankAccountWrapper sbDetails=SolarisbankBankAccountWrapper.parse(responseJson);
        if(sbDetails.error==null){
            
            
            bankAccountDetails.Status__c=sbDetails.status;
            bankAccountDetails.Technical_Closure_Date__c=sbDetails.technical_closure_date;
            bankAccountDetails.Legal_Closure_Date__c=sbDetails.legal_closure_date;
            bankAccountDetails.Closure_Reasons__c=reason;
            
            update bankAccountDetails;
        }
        return (sbDetails.error)?SolarisbankBankAccountWrapper.parseError(responseJson):null;
    }
    
}