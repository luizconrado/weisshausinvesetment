/***************
* @group Handler Class
* @description Content Version  trigger router
*/
public class ContentVersionTriggerHandler extends TriggerHandler {
     
    protected override void afterInsert() {
        
        List<String> cvIdList=new List<String>();
        List<String> cvIdListForAccountCaseArchive=new List<String>();
        for(ContentVersion cv:(List<ContentVersion>)Trigger.new){
            Id ObjectId = cv.FirstPublishLocationId;
            String sObjName = ObjectId.getSObjectType().getDescribe().getName();
            if(cv.Type__c !=null && cv.isLatest && sObjName=='Opportunity'){
                cvIdList.add(cv.id);
            }
            else if(cv.Type__c=='Case Archive' && cv.isLatest && sObjName=='Account'){
                cvIdListForAccountCaseArchive.add(cv.Id);
            }
        }
        if(cvIdList.size()>0) ContentVersionService.sendDocumentInfoToEV(cvIdList);  
        if(cvIdListForAccountCaseArchive.size()>0) ContentVersionService.sendCaseArchiveZipToEv(cvIdListForAccountCaseArchive);
    }
    protected override void afterUpdate() {
        List<String> cvIdList=new List<String>();
        for(ContentVersion cv:(List<ContentVersion>)Trigger.newMap.values()){
            Id ObjectId = cv.FirstPublishLocationId;
            String sObjName = ObjectId.getSObjectType().getDescribe().getName();
            if(cv.Type__c !=null && cv.isLatest  && sObjName=='Opportunity'){
                cvIdList.add(cv.id);
            }
        }
        if(cvIdList.size()>0) ContentVersionService.sendDocumentInfoToEV(cvIdList);
    }
}