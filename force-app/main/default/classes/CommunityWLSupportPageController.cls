/***************
* @group Controller Class
* @description business logic for lwc component waitingList_supportPage
*/
public without sharing class CommunityWLSupportPageController {
    
    /***************
    * @description create case based on record type passed and links to email if present in system
    * @param subject case subject
    * @param description description of case
    * @param email supplied email or email of person account
    * @param recordTypeName case record type developer name
    */
    @AuraEnabled
    public static void createCase(String subject,String description,String email,String recordTypeName){
        try {
            List<Account> exsistingAccounts = [SELECT Id,PersonContactId FROM Account WHERE PersonEmail =:email and isPersonAccount=true];

            Case newCase=new Case();
            newCase.subject = subject;
            newCase.description = description;
            newCase.Status='New';
            newCase.Origin='Web';
            newCase.Type='Other';
            newCase.SuppliedEmail=email;
            if(exsistingAccounts.size()>0){
                newCase.AccountId=exsistingAccounts.get(0).Id;
                newCase.ContactId=exsistingAccounts.get(0).PersonContactId;
            }

            if(String.isNotBlank(recordTypeName)){
                newCase.recordTypeId=SchemaUtil.getRecordTypeId(recordTypeName,'Case');
            }
            Database.DMLOptions autoResponseOptions = new Database.DMLOptions(); 
            autoResponseOptions.EmailHeader.triggerAutoResponseEmail = true;
            
            Database.SaveResult saveResult  = Database.insert(newCase, autoResponseOptions); 
            
            for(Database.Error err : saveResult.getErrors()) {
                throw new EVException(err.getStatusCode() + ': ' + err.getMessage() +' : '+err.getFields());
                
            }
             
        } catch (Exception e) {
            String index=logError(e,null,'Case','waitingList_supportPage','createCase','insert');
            throw new AuraHandledException('Please contact your support@ev-smartmoney.com And provide '+index+' id to resolve issue.');
        }
    }

    private static String logError(Exception e,String recordID,String objectName,String componentName,String methodName,String operation){
        LogService.LogMetadata details=new LogService.LogMetadata();
        details.addError(e);
        details.addRecordInfo(objectName,recordId);
        
        details.addMetadataInfo(userinfo.getUserId(),'CommunitySupportPageController', methodName, componentName, operation);
        return LogService.logError(details);
    }
}