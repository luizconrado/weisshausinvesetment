public class EmailMessageTriggerHandler  extends TriggerHandler {
    
    private static String solarisbankSupportEmailAddress=Label.Case_Jira_SupportEmail;
    
    protected override void beforeInsert() {
        try{
            List<String> solaribankSupportCaseIds=new List<String>();
            List<EmailMessage> msgList=Trigger.new;
            Map<String,EmailMessage> caseIdAndEmailMap=new Map<String,EmailMessage>();
            for(EmailMessage email:msgList){
                if(email.Incoming && email.FromAddress==solarisbankSupportEmailAddress && email.ParentId!=null){
                    if(String.valueOf(email.ParentId.getSobjectType())=='Case'){
                        solaribankSupportCaseIds.add(email.ParentId);
                        caseIdAndEmailMap.put(email.ParentId,email);
                    }
                }
            }
            
            
            
            
            if(solaribankSupportCaseIds.size()>=0) mapEmailToSameSubjectCase(solaribankSupportCaseIds,caseIdAndEmailMap);
        }
        Catch(Exception e){
            logError(e,'beforeInsert');
        }
    }
    
    @testvisible
    private static void logError(Exception e,String methodName){
        LogService.LogMetadata errorDetails=new LogService.LogMetadata();
        errorDetails.addError(e);
        errorDetails.addMetadataInfo(userinfo.getUserId(), 'EmailMessageTriggerHandler', methodName, 'EmailMessageTrigger','Trigger Operation');
        LogService.logError(errorDetails);
    }
    
    private static void mapEmailToSameSubjectCase(List<String> caseIds,Map<String,EmailMessage> caseIdAndEmailMap){
        //new case created List
        List<Case> newCaseCreatedList=[SELECT Id,CaseNumber,Subject FROM Case WHERE id IN:caseIds];
        Map<String,Case> newCaseSubjectAndCaseMap=new Map<String,Case>();
        for(Case newCases:newCaseCreatedList){
            newCaseSubjectAndCaseMap.put(newCases.subject,newCases);
        }
        
        //exsisting case with same subject
        List<Case> exsitingCaseList=[SELECT Id,Subject,RecordTypeId,Status From Case WHERE Subject IN:newCaseSubjectAndCaseMap.keySet() AND Subject!=null AND ID NOT IN:caseIds ];
        Map<String,Case> exsistingCaseSubjectAndCaseMap=new Map<String,Case>();
        for(Case exstingsCases:exsitingCaseList){
            exsistingCaseSubjectAndCaseMap.put(exstingsCases.subject,exstingsCases);
        }
        
        List<Case> toDeleteCase=new List<Case>();
        List<Case> toUpdateCase=new List<Case>();
        for(Case newCases:newCaseCreatedList){
            if(exsistingCaseSubjectAndCaseMap.containsKey(newCases.Subject)){
                Case exsistingCase = exsistingCaseSubjectAndCaseMap.get(newCases.Subject);
                Case newCase = newCaseSubjectAndCaseMap.get(newCases.Subject);
                caseIdAndEmailMap.get(newCase.Id).ParentId=exsistingCase.Id;
                if(exsistingCase.RecordTypeId==Constant.BANKINGCASE_CASE_RECORDTYPEID) exsistingCase.Status='Incoming Reply'; 
                toUpdateCase.add(exsistingCase);
                toDeleteCase.add(newCase);
            }
            
        }
        //deleting newly created case
        if(toDeleteCase.size()>0) delete toDeleteCase;
        //change status of case
        if(toUpdateCase.size()>0) update toUpdateCase;
    }
}