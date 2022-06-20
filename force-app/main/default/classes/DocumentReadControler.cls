public with sharing class DocumentReadControler {
    
    
    @AuraEnabled
    public static String requestDocumentUrl(String documentId){
        Try{
           
            Document__c document=[SELECT RecordTypeId,Read_At__c,Last_Viewed_User__c, Status__c, Requested_At__c, Ticket_Number__c, Id,Account__r.Auth0_Id__c, Account__c,Account__r.Solarisbank_Tenent__c FROM Document__c WHERE Id=:documentId];
            
            LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(documentId,'Document__c',document.Account__r.Solarisbank_Tenent__c);
            String documentResponseBody = EVExternalService.fetchDocumentUrl(document.Account__r.Auth0_Id__c, document.Ticket_Number__c, apiCallDetails);
            
            document.Requested_At__c=DateTime.now();
            document.Status__c='REQUESTED';
            document.Read_At__c=DateTime.now();
            document.Last_Viewed_User__c=UserInfo.getUserId();
            
            update document;
            
            return documentResponseBody;
            
            
        }Catch(Exception e){
            
            String index = logError(e,documentId,'Document__c','DocumentReadRequest','requestDocumentUrl','Request Document Url');
            throw new AuraHandledException('Please contact your System admin.And provide '+index+' id to resolve issue.'); 
        }
        
        
    }
    
    //helper
    @testVisible
    private static String logError(Exception e,String recordID,String objectName,String componentName,String methodName,String operation){
        LogService.LogMetadata details=new LogService.LogMetadata();
        details.addError(e);
        details.addRecordInfo(objectName,recordId);
        details.addMetadataInfo(userinfo.getUserId(),'DocumentReadControler', methodName, componentName, operation);
        return LogService.logError(details);
    }
    
}