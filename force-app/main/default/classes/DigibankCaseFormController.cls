/***************
* @group Controller Class
* @description all case object with ev konto record type logic is here
*/
public without sharing class DigibankCaseFormController {
    
    @AuraEnabled(Cacheable=true)
    public static String getEVKONTOCaseRecordTypeId(){
        return Constant.EVKONTOAPPCASE_CASE_RECORDTYPEID;
    }
    
    /***************
    * @description creates new ev konto case
    * @param newCase case details 
    */
    @AuraEnabled
    public static String createNewEVKnotoCase(Case newCase){
        try{
            List<Account> personAccount=[SELECT id,(Select id FROM Contacts WHERE isPersonAccount=true) FROM ACCOUNT WHERE PersonEmail=:newCase.SuppliedEmail];
            if(personAccount.size()>0) {
                newCase.AccountId=personAccount.get(0).Id;
                if(personAccount.get(0).Contacts.size()>0) newCase.ContactId=personAccount.get(0).Contacts.get(0).Id;
            }
            Database.DMLOptions dlo = new Database.DMLOptions();
            dlo.EmailHeader.triggerAutoResponseEmail = true;
            database.insert(newCase, dlo);
            return newCase.id;
        }
        catch(Exception e){throw processError('DigibankCaseFormController','createNewEVKnotoCase','digibankCaseForm','Create EV Konto Case',e);}
    }
    
    /***************
    * @description attach file to case
    * @param caseId case record id
    * @param contentVersionIds list of cv ids
    */
    @AuraEnabled
    public static void attachFilesToCase(String caseId,List<String> contentVersionIds){
        try{
            List<ContentVersion> files=[SELECT Id, ContentDocumentId,Title,ContentSize,Type__c,ContentModifiedDate,FileExtension,VersionNumber,ContentModifiedBy.Name FROM ContentVersion 
                                        WHERE  Id IN: contentVersionIds ORDER BY ContentModifiedDate DESC];
            List<ContentDocumentLink> links=new List<ContentDocumentLink>();
            List<Case> caseDetails=[SELECT id,CaseNumber FROM Case WHERE id=:caseId];
            String caseNumber='';
            if(caseDetails.size()>0) caseNumber=caseDetails.get(0).CaseNumber;
            for(ContentVersion file:files){
                file.Title=caseNumber+ ' - Digibank' +' - '+file.Title;
                file.Type__c=caseNumber +' - Digibank';
                ContentDocumentLink newLink=new ContentDocumentLink();
                newLink.ContentDocumentId=file.ContentDocumentId;
                newLink.LinkedEntityId=caseId;
                newLink.ShareType='V';
                
                links.add(newLink);
            }
            update files;
            insert links;
        }
        catch(Exception e){throw processError('DigibankCaseFormController','attachFilesToCase','digibankCaseForm','Attach file to EV Konto Case',e);}
    }
    
    @testVisible
    private static AuraHandledException processError(String className,String MethodName,String ComponentName,String Operation,Exception Error){
        LogService.LogMetadata data=new LogService.LogMetadata();
        data.addMetadataInfo(userinfo.getUserId(),className,MethodName,ComponentName,Operation);
        data.addError(Error);
        String errorId=LogService.logError(data); 
        return new AuraHandledException('Please contact support@ev-smartmoney.com. And provide '+errorId+' id to resolve issue.');
    }
}