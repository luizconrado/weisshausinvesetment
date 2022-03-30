public class ContentVersionTriggerHandler extends TriggerHandler {
    protected override void afterInsert(final List<SObject> newObjects) {
        
        List<String> cvIdList=new List<String>();
        for(ContentVersion cv:(List<ContentVersion>)newObjects){
            if(cv.Type__c !=null && cv.isLatest){
                cvIdList.add(cv.id);
            }
        }
        if(cvIdList.size()>0) ContentVersionService.sendDocumentInfoToEV(cvIdList);
    }
    protected override void afterUpdate(final Map<Id, SObject> newObjects, final Map<Id, SObject> oldObjects) {
        List<String> cvIdList=new List<String>();
        for(ContentVersion cv:(List<ContentVersion>)newObjects.values()){
            if(cv.Type__c !=null && cv.isLatest){
                cvIdList.add(cv.id);
            }
        }
        if(cvIdList.size()>0) ContentVersionService.sendDocumentInfoToEV(cvIdList);
    }
}