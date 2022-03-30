public class SolarisbankAdminPanal {

    @AuraEnabled
    public static Boolean getTermDepositeStatus(String recordId){
      
        List<Bank__c> sbList=[SELECT id,Name,Email__c,Solarisbank_Id__c,Is_Term_Deposit_Enabled__c FROM Bank__c WHERE Id=:recordId AND RecordTypeId=:Constant.BANK_SOLARISBANK_RECORDTYPEID];
        return sbList.get(0).Is_Term_Deposit_Enabled__c;
 
     }
    
    //AIM : toggle term deposit tag on auth0 user
    @AuraEnabled
    public static Boolean toggleTermDepostForUser(String recordId,Boolean status,String termDepositReason){
        Boolean changedstatus=false;
        List<Bank__c> sbList=[SELECT id,Name,Email__c,Solarisbank_Id__c,Is_Term_Deposit_Enabled__c,Account__r.Auth0_ID__c,Account__r.Solarisbank_Tenent__c FROM Bank__c WHERE Id=:recordId  AND RecordTypeId=:Constant.BANK_SOLARISBANK_RECORDTYPEID];
      
        
        LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(sbList.get(0).Id,'Bank__c',sbList.get(0).Account__r.Solarisbank_Tenent__c);
        apiCallDetails.requestBody=termDepositReason;
        String responseJson= Auth0Service.updateUserDetails(sbList.get(0).Account__r.Auth0_ID__c,'{ "user_metadata": { "term_deposit_enabled":'+status+' } }',apiCallDetails);
        Auth0Wrapper userDetails=Auth0Wrapper.parse(responseJson);
        
        if(userDetails.user_metadata.term_deposit_enabled==status){
            sbList.get(0).Is_Term_Deposit_Enabled__c=status;
            update sbList;
            changedstatus=true;
        }
        
        return changedstatus;
 
         
    }
}