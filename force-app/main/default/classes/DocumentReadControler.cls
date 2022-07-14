/***************
* @group Controller Class
* @description business logic for aura component documentReadRequest
*/
public with sharing class DocumentReadControler {
    
    
    /***************
    * @description request temprory link from ev to privew fiel for 5 min
    * @param documentId record id of document object
    */
    @AuraEnabled
    public static String requestDocumentUrl(String documentId){
        Try{
           
            Document__c document=[SELECT Opportunity__r.External_id__c,Opportunity__r.Account.Solarisbank_Tenent__c,Opportunity__r.Account.EVSM_Auth0_Id__c,RecordTypeId,Read_At__c,Last_Viewed_User__c, Status__c, Requested_At__c, Ticket_Number__c, Id,Account__r.Auth0_Id__c, Account__c,Account__r.Solarisbank_Tenent__c FROM Document__c WHERE Id=:documentId];
            String accountAuthoId='';
            String tenent='';
            if(document.RecordTypeId==Constant.DOCUMENT_ACCOUNT_RECORDTYPEID) accountAuthoId = document.Account__r.Auth0_Id__c;
            else if(document.RecordTypeId==Constant.DOCUMENT_OPPORTUNTIY_RECORDTYPEID) accountAuthoId = document.Opportunity__r.Account.EVSM_Auth0_Id__c;
            
            if(document.RecordTypeId==Constant.DOCUMENT_ACCOUNT_RECORDTYPEID) tenent = document.Account__r.Solarisbank_Tenent__c;
            else if(document.RecordTypeId==Constant.DOCUMENT_OPPORTUNTIY_RECORDTYPEID) tenent = document.Opportunity__r.Account.Solarisbank_Tenent__c;
            
            
            
           
            
            LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(documentId,'Document__c',tenent);
            
            
            
            String documentResponseBody = '';
            
            if(document.RecordTypeId==Constant.DOCUMENT_ACCOUNT_RECORDTYPEID) documentResponseBody= EVExternalService.fetchDocumentUrl(accountAuthoId, document.Ticket_Number__c, apiCallDetails);    
            else if(document.RecordTypeId==Constant.DOCUMENT_OPPORTUNTIY_RECORDTYPEID) documentResponseBody = EVExternalService.fetchInvestmentDocumentUrl(document.Opportunity__r.External_id__c,accountAuthoId, document.Ticket_Number__c, apiCallDetails); 
            
            
            
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