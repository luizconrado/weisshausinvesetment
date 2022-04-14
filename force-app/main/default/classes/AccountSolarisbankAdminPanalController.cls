/***************
* @group Controller
* @description controller class for AccountSolarisbankAdminPanal, porovides suport for all Solarisbank oprations that are done via admin panal on account,bank account,card object
*/
public class AccountSolarisbankAdminPanalController {
    
    /***************
    * @description sends a request to solarisbank to change user details of customer
    * @param recordId account Id of user
    * @param requestChangebody details that are required to change
    * @return SolarisbankCRPRequestWrapper
    * @example
    * AccountSolarisbankAdminPanalController.intitatePersonDetailsChangeTanRequest(accountid,{
                "address":{
                    "line_1":"line_1",
                    "line_2":"line_2"   
                },
                "title":"title",
                "salutation":"salutation",
                "address":"address",
                "tax_information":"tax_information"
            });
    */
    @AuraEnabled
    public static SolarisbankCRPRequestWrapper intitatePersonDetailsChangeTanRequest(String recordId,String requestChangebody){
        List<Change_Request_Log__c> changeRequestList=new List<Change_Request_Log__c>();
        Account bankAccountDetails=[SELECT Id,Solarisbank_Id__c,Solarisbank_Tenent__c FROM Account WHERE id=:recordId];
        LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(recordId,'Account',bankAccountDetails.Solarisbank_Tenent__c);
        
        //creating request to update changes
        String responseString= SolarisbankService.updateCustomerData(bankAccountDetails.Solarisbank_Id__c,requestChangebody,apiCallDetails);
        
        SolarisbankCRPRequestWrapper tanUrlResponse=SolarisbankCRPRequestWrapper.parse(responseString);
        
        if(tanUrlResponse.errors!=null && tanUrlResponse.errors.size()>0){
            Change_Request_Log__c changeRequestLog=new Change_Request_Log__c();
            changeRequestLog.Solarisbank_Id__c=tanUrlResponse.id;
            changeRequestLog.Operation__c='Update Account Details';
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
            changeRequestLog.Operation__c='Update Account Details';

            changeRequestLog.Record_Id__c=recordId;
            changeRequestLog.Status__c=tanUrlResponse.status;
            changeRequestLog.Updated_At__c=tanUrlResponse.updated_at;
            changeRequestLog.URL__c=tanUrlResponse.url;
            changeRequestList.add(changeRequestLog);
        }
        
        //creating tan conformation request 
        String crpResponseString = SolarisbankService.initiateCRPRequest(tanUrlResponse.url,bankAccountDetails.Solarisbank_Id__c,apiCallDetails);
        SolarisbankCRPRequestWrapper crpResponse=SolarisbankCRPRequestWrapper.parse(crpResponseString);
        
        Change_Request_Log__c crpRequestLog=new Change_Request_Log__c();
        crpRequestLog.Solarisbank_Id__c=crpResponse.id;
        crpRequestLog.Object_Name__c='Account';
        crpRequestLog.Operation__c='Update Account Details';

        crpRequestLog.Record_Id__c=recordId;
        crpRequestLog.Status__c=crpResponse.status;
        crpRequestLog.Updated_At__c=crpResponse.updated_at;
        crpRequestLog.URL__c=tanUrlResponse.url.replace('/authorize', '/confirm');
        changeRequestList.add(crpRequestLog);
        
        insert changeRequestList;
        return tanUrlResponse;  
    }
    
    /***************
    * @description sends conformation request to solarisbank to accept changes
    * @param recordId account id of customer record
    * @param tanurl conformation url returend by intitatePersonDetailsChangeTanRequest
    * @param otp key sent to customers registerd monbile number
    * @return reponse body 
    * @example
    * AccountSolarisbankAdminPanalController.confirmPersonDetailsChangeTanRequest(accountid,url,securitycode);
    */
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
            crpRequestLog.Operation__c='Update Account Details';
            crpRequestLog.Description__c=tanUrlResponse.errors.get(0).title +' : '+tanUrlResponse.errors.get(0).detail;
            
        }
        else{
            crpRequestLog.Solarisbank_Id__c=tanUrlResponse.id;
            crpRequestLog.Object_Name__c='Account';
            crpRequestLog.Record_Id__c=recordId;
            crpRequestLog.Operation__c='Update Account Details';
            crpRequestLog.Status__c=tanUrlResponse.status;
            crpRequestLog.Updated_At__c=tanUrlResponse.updated_at;
            crpRequestLog.URL__c=tanUrlResponse.url;
            //sync new details 
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
    public static Map<String,Map<String,String>> getKYCPicklistValues(){
        return BankCaseOverrideControler.getKYCPicklistValues();
    }
    
    
    /***************
    * @description returns record details based on record id
    * @param recordId record id 
    * @return map of object and record
    */
    @AuraEnabled
    public static Map<String,List<sObject>> getRecordDetails(Id recordId){
        
        if(recordId.getSobjectType()== Schema.Account.SObjectType){
            return new Map<String,List<sObject>>{
                'Record'=>[SELECT id,Marital_Status__c,BillingCountry,BillingPostalCode,BillingCity,BillingStreet,PersonTitle,Salutation,FirstName,LastName,Preferred_Language__pc,
                           (SELECT Id, Marital_Status__c  FROM Banks__r WHERE  RecordTypeId=:Constant.BANK_SOLARISBANK_RECORDTYPEID)  FROM ACCOUNT WHERE Id=:recordId]
                    };
                        }
        else if(recordId.getSobjectType()==Schema.Bank_Account__c.SObjectType){
            List<Bank_Account__c> bankAccount=[SELECT id,Person_Account__c,Person_Account__r.FirstName,Person_Account__r.LastName FROM Bank_Account__c WHERE Id=:recordId];
            String accountId=bankAccount.get(0).Person_Account__c;
            List<Bank__c> kycData=[SELECT Id, Employment_Status__c  FROM Bank__c WHERE Account__c=:accountId AND RecordTypeId=:Constant.BANK_SOLARISBANK_RECORDTYPEID];

             return new Map<String,List<sObject>>{
                'Record'=>bankAccount,
                    'Employment_Status'=>kycData
                    }; 
                        }
        else if(recordId.getSobjectType()==Schema.Card__c.SObjectType){
            return new Map<String,List<sObject>>{ 
                'Record'=>[SELECT id,Status__c FROM Card__c WHERE Id=:recordId] 
                    };
                        }
        return null;
    }
    
    /***************
    * @description creates new kyc identification request with solaribank
    * @param recordId account id of customer 
    * @param languageCode lang code in which identification is to be done
    * @return returns identification url
    */
    @AuraEnabled
    public static String reqeustNewIdentification(String recordId,String languageCode){
        return AccountService.createNewIdentification(recordId,languageCode);
    }
    
    /***************
    * @description request new card for customer
    * @param recordId bank account record id of customer to whihc card is to be linked
    * @param body card details 
    * @return new card id
    * @example
    * requestNewBankCard(bankAccountId,{
            type:'debit',
            line_1:cardfName+'/'+cardlName,
            reference:randomString
        });
    */
    @AuraEnabled 
    public static String requestNewBankCard(String recordId,String body){
        Map<String,Object> cardRequestBody=(Map<String,Object>) JSON.deserializeUntyped(body);
        Bank_Account__c bankAccountDetails=[SELECT Id,Person_Account__c,Solarisbank_Id__c,Person_Account__r.Solarisbank_Id__c,Person_Account__r.FirstName,Person_Account__r.LastName,Person_Account__r.Solarisbank_Tenent__c
                                            FROM Bank_Account__c 
                                            WHERE Id=:recordId];
        List<Bank__c> sbBankDetails=[SELECT id FROM Bank__c WHERE Account__c=:bankAccountDetails.Person_Account__c AND RecordTypeId=:Constant.BANK_SOLARISBANK_RECORDTYPEID];
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
        if(sbBankDetails.size()>0)newCard.Bank__c=sbBankDetails.get(0).Id;
        insert newCard;
        
        
        
        
        return '{"id":"newCard.id"}';
    }
    
    /***************
    * @description change card status
    * @param recordId card record id
    * @param newStatus status to whihc it needs to be chagned Block\Close\Unblock
    * @param reason reason for change
    * 
    */
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
    
    /***************
    * @description close bank account of customer
    * @param recordId bank account record id 
    * @param reason reson for closing account
    * @return returns null on success or error message
    */
    @AuraEnabled
    public static SolarisbankBankAccountWrapper.Errors requestAccountCloser(String recordId,String reason){
        Bank_Account__c bankAccountDetails=[SELECT id,Status__c,Technical_Closure_Date__c,Legal_Closure_Date__c,Closure_Reasons__c,Person_Account__c,Person_Account__r.Solarisbank_Tenent__c,Solarisbank_Id__c FROM Bank_Account__c WHERE id=:recordId];
        LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(recordId,'Bank_Account__c',bankAccountDetails.Person_Account__r.Solarisbank_Tenent__c);
        String body='{"account_id":"'+bankAccountDetails.Solarisbank_Id__c+'","closure_reason":"'+reason+'"}';
        String responseJson=SolarisbankService.requestCloseAccount(body,apiCallDetails);
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