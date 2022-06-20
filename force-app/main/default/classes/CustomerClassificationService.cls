public with sharing class CustomerClassificationService {

    @AuraEnabled
    public static void updateSystemStatusToExternalSystem(String customerClassificationId){
        try{
            Customer_Classification__c classification=[SELECT Id,RecordType.DeveloperName,Account__r.EVSM_Auth0_ID__c,Account__r.Solarisbank_Tenent__c, Account__c, External_Id__c, System_Status__c FROM Customer_Classification__c WHERE id=:customerClassificationId];
            if(String.isNotEmpty(classification.External_Id__c) && classification.External_Id__c!=null){
                LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(classification.Id,'Customer_Classification__c',classification.Account__r.Solarisbank_Tenent__c);
                
                String body='{"status":"'+classification.System_Status__c+'"}';
                String statusResponse=EVExternalService.updateCustomerClassificationUpdate(classification.External_Id__c,classification.Account__r.EVSM_Auth0_ID__c,body,apiCallDetails);
            }
             

        }
        Catch(Exception e){
           logError('Customer_Classification__c',customerClassificationId,e,'updateSystemStatusToExternalSystem','Customer Classification - Update - Set System Status','Send Customer Classification Data To BE');
        }
        
    }
    
    @testVisible
    private static void logError(String objectName,String recordId,Exception e,String methodName,String componentName,String operation){
        LogService.LogMetadata errorDetails=new LogService.LogMetadata();
        errorDetails.addError(e);
        errorDetails.addRecordInfo(objectName,recordId);
        errorDetails.addMetadataInfo(userinfo.getUserId(), 'CustomerClassificationService', methodName, componentName,operation);
        LogService.logError(errorDetails);
    }
}