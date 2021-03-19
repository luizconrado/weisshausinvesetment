public with sharing class DigibankCaseService {

    @AuraEnabled
    public static void prepareBugInfoBody(String caseId){
        List<Case> casesDetails=[SELECT Internal_Description__c ,Id,Subject,Description,Occurrence_Of_Issue__c,Expected_Result__c,Actual_Result__c,
                                 Phone_OS__c,Phone_Model__c,App_Version__c
                                 FROM Case WHERE Id=:caseId];
        System.debug(casesDetails.size());
        if(casesDetails.size()>0){
            String emailBody='';
            Case caseDetails=casesDetails.get(0);
            emailBody += 'Subject';
            emailBody += '\n';
            if(caseDetails.Subject!=null) emailBody += caseDetails.Subject;
            emailBody += '\n';
            emailBody += '\n';
            emailBody += 'Description';
            emailBody += '\n';
            if(caseDetails.Description!=null) emailBody += caseDetails.Description;
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
            caseDetails.Internal_Description__c=emailBody;
            update caseDetails;
        }
    }
}