/***************
* @group Queueable Class
* @description Class Responsible for deleting cases of anonimizing data of account and related records based on configuration settings Scramble_Configuration__c
*/
public without sharing class AccountArchiveCase implements Queueable {
    List<String> accountIdList=new List<String>();
    
    public AccountArchiveCase(List<String> accountIds){
        accountIdList=accountIds;
    }
    public void execute(QueueableContext context) {
        try{
        Map<String,List<Case>> accountIdAndCaseListMap=new Map<String,List<Case>>();
        Map<String,String> accountIdAndCaseCsvMap=new Map<String,String>();
        
 		List<Case> allAccountRelatedCases=[SELECT Account.Auth0_ID__c,Account.EVSM_Auth0_Id__c,id,Owner.Name,AccountId,CaseNumber,Type_II__c,RecordType.Name,SuppliedEmail,CreatedDate, SuppliedName, Type, Status, Reason, Origin, Subject, Priority, Description, ContactPhone, ContactMobile, ContactEmail, ContactFax 
                                           FROM Case WHERE AccountId=:accountIdList];  
        
        
        String csvHeader='CaseNumber,RecordType,Status,Origin,Reason,Type,Type 2,Priority,Subject,Description,SuppliedEmail,SuppliedName,Case Owner,CreatedDate';
        for(Case record:allAccountRelatedCases){
            if(accountIdAndCaseListMap.get(record.accountId)==null) accountIdAndCaseListMap.put(record.accountId,new List<Case>());
            accountIdAndCaseListMap.get(record.accountId).add(record);
        }
        
        
        
        for(String accountId:accountIdAndCaseListMap.keySet()){
            String csvFileData=csvHeader+'\n';
            for(Case c:accountIdAndCaseListMap.get(accountId)){
                csvFileData+=c.CaseNumber+',';
                csvFileData+=c.RecordType.Name+',';
                csvFileData+=c.Status+',';
                csvFileData+=c.Origin+',';
                csvFileData+=((c.Reason!=null)?c.Reason:'')+',';
                csvFileData+=((c.Type!=null)?c.Type:'')+','; 
                csvFileData+=((c.Type_II__c!=null)?c.Type_II__c:'')+','; 
                csvFileData+=c.Priority+',';
                csvFileData+=c.Subject+',';
                csvFileData+=((c.Description!=null)?c.Description:'')+',';
                csvFileData+=((c.SuppliedEmail!=null)?c.SuppliedEmail:'')+',';
                csvFileData+=((c.SuppliedName!=null)?c.SuppliedName:'')+',';
                csvFileData+=c.Owner.Name+',';
                csvFileData+=c.CreatedDate+'\n';
                
            }
            accountIdAndCaseCsvMap.put(accountId,csvFileData);
        }
        List<ContentVersion> toInsert = New List<ContentVersion>();
        for(String accountId:accountIdAndCaseCsvMap.keySet()){
            Zippex sampleZip = new Zippex();
            Blob fileData = Blob.valueOf(accountIdAndCaseCsvMap.get(accountid));
            sampleZip.addFile(accountId+'.csv', fileData, null);
            Blob zipData = sampleZip.getZipArchive();
            ContentVersion cv=new ContentVersion();
            cv.FirstPublishLocationId=accountId;
            cv.VersionData=zipData;
            cv.Title=accountId+'.zip';
            cv.PathOnClient=accountId;
            cv.Type__c='Case Archive';
            toInsert.add(cv);
        }
        
         
        if(toInsert.size()>0) logInsertRecordError(Database.insert(toInsert,false));
        
        if(allAccountRelatedCases.size()>0) logDeleteRecordError(Database.delete(allAccountRelatedCases,false));
        }
        catch(Exception e){logError(null,null,'execute',e);}
    }
    
    
    
    @testVisible
    private void logInsertRecordError(List<Database.SaveResult> updateResult){
        for (Database.SaveResult r : updateResult)
        {
            if (!r.isSuccess())    for (Database.Error e : r.getErrors()) logError(r.getId(), e.getMessage()+' : '+e.getFields(),'logInsertRecordError',null);
        }
    }
    
    @testVisible
    private void logDeleteRecordError(List<Database.DeleteResult> updateResult){
        for (Database.DeleteResult r : updateResult)
        {
            if (!r.isSuccess())    for (Database.Error e : r.getErrors()) logError(r.getId(), e.getMessage()+' : '+e.getFields(),'logDeleteRecordError',null);
        }
    }
    
    @testVisible
    private void logError(String errorMessage,String stacktrace,String method,Exception error){
        LogService.LogMetadata metadata=new LogService.LogMetadata();
        metadata.addMetadataInfo(userinfo.getUserId(), 'AccountArchiveCase',method,'Trigger','Delete Account Case');
        metadata.addComment(String.join(accountIdList, ','));
        if(error!=null)metadata.addError(error);
        else metadata.addErrorString(errorMessage,stacktrace);
        LogService.logError(metadata);
        
    }
}