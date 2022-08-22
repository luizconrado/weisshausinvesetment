/***************
* @group Service Class
* @description all digi bank case record type logic iois here
*/
public with sharing class DigibankCaseService { 
    
      @AuraEnabled
    public static Boolean checkIsCompactLayout() {
        return Salesforce.isCompactLayout;
    }
    
    @AuraEnabled(cacheable=true) 
    public static Map<String,String> retriveDefaultTemplatHtml() {
        return new Map<String,String>{
            'START'=>'',/*Constant.DEFAULT_EV_TEMPLATE_START,*/
                'END'=>''/*Constant.DEFAULT_EV_TEMPLATE_END*/
                };
    }
    
    /***************
    * @description prepares body that is defined by digi bank to rase a case
    * @param caseId record id of case
    */
    @AuraEnabled
    public static Map<String,String> fetchBugBody(String caseId){
        String emailBody='';
        String threadId='';
        List<Case> casesDetails=[SELECT Thread_Id__c,Internal_Description__c ,Id,Subject,Description,Occurrence_Of_Issue__c,Expected_Result__c,Actual_Result__c,
                                 Phone_OS__c,Phone_Model__c,App_Version__c
                                 FROM Case WHERE Id=:caseId];
        if(casesDetails.size()>0){
            Case caseDetails=casesDetails.get(0);
            threadId=caseDetails.Thread_Id__c;
            emailBody += 'Description';
            emailBody += '\n';
            emailBody += '\n';
            if(caseDetails.Description!=null) emailBody += caseDetails.Description;
            emailBody += '\n';
            emailBody += '\n';
            emailBody += 'Expected Result';
            emailBody += '\n';
            if(caseDetails.Expected_Result__c!=null) emailBody += caseDetails.Expected_Result__c;
            emailBody += '\n';
            emailBody += '\n';
            emailBody += 'Actual Result';
            emailBody += '\n';
            if(caseDetails.Actual_Result__c!=null) emailBody += caseDetails.Actual_Result__c;
            emailBody += '\n';
            emailBody += '\n';
            emailBody += 'Occurrence of issue (time and date)';
            emailBody += '\n';
            if(caseDetails.Occurrence_Of_Issue__c!=null) emailBody += caseDetails.Occurrence_Of_Issue__c?.format();
            emailBody += '\n';
            emailBody += '\n';
            emailBody += 'Phone Model';
            emailBody += '\n';
            if(caseDetails.Phone_Model__c!=null) emailBody += caseDetails.Phone_Model__c;
            emailBody += '\n';
            emailBody += '\n';
            emailBody += 'Phone OS';
            emailBody += '\n';
            if(caseDetails.Phone_OS__c!=null) emailBody += caseDetails.Phone_OS__c;
            emailBody += '\n';
            emailBody += '\n';
            emailBody += 'App Version';
            emailBody += '\n';
            if(caseDetails.App_Version__c!=null) emailBody += caseDetails.App_Version__c;
            emailBody += '\n';
            
        }
        return new Map<String,String>{'body'=>emailBody,'threadid'=>threadId};
    }
    
     /***************
    * @description updates case description with body and subject of email that needs to send to digibank and send mail 
    * @param caseId record id of case
    * @param bugBody body of email
    * @param bugSubject subject of email
    */
    @AuraEnabled
    public static Boolean prepareBugInfoBody(String caseId,String bugBody,String bugSubject){
        Boolean success=false;
        List<Case> casesDetails=[SELECT Thread_Id__c,Internal_Description__c ,Id,Subject,Description,Occurrence_Of_Issue__c,Expected_Result__c,Actual_Result__c,
                                 Phone_OS__c,Phone_Model__c,App_Version__c
                                 FROM Case WHERE Id=:caseId];
        if(casesDetails.size()>0){
            Case caseDetails=casesDetails.get(0);
            String description='Subject';
            description+='\n';
            description+=bugSubject;
            description+='\n';
            description+='\n';
            description+='Body';
            description+='\n';
            caseDetails.Internal_Description__c=description;
            caseDetails.Submitted_FLC_Date__c=DateTime.now();
            caseDetails.Status='Ticket Reported';
            List<ContentVersion> cvFiles=getAttachedFileIds(caseId);
            List<String> cvIds=new List<String>();
            for(ContentVersion cv:cvFiles) cvIds.add(cv.Id);
            success = MailUtill.sendEmailWithAttachment(bugSubject+'  '+caseDetails.Thread_Id__c,bugBody.replaceAll('\n','<br>'), cvIds,System.label.DigibankSupport_Email, Constant.EV_SUPPORT_OWD_EMAIL, caseDetails.id);
            update caseDetails;
        }
        return success;
    }
    
    private static List<ContentVersion> getAttachedFileIds(String recordId){
        List<ContentDocumentLink> cdlList=[SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId=:recordId];
        List<String> cdIds=new List<String>();
        for(ContentDocumentLink cdl:cdlList)cdIds.add(cdl.ContentDocumentId);
        List<ContentVersion> filesList=[SELECT id FROM ContentVersion WHERE ContentDocumentId IN:cdIds AND Type__c LIke '%Digibank'];
        return filesList;
    }
    
    
}