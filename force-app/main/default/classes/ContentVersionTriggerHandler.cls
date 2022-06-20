/***************
* @group Handler Class
* @description Content Version  trigger router
*/
public class ContentVersionTriggerHandler extends TriggerHandler {
     
    protected override void afterInsert() {
        
        List<String> cvIdList=new List<String>();
        for(ContentVersion cv:(List<ContentVersion>)Trigger.new){
            if(cv.Type__c !=null && cv.isLatest){
                cvIdList.add(cv.id);
            }
        }
        if(cvIdList.size()>0) ContentVersionService.sendDocumentInfoToEV(cvIdList);
    }
    protected override void afterUpdate() {
        List<String> cvIdList=new List<String>();
        for(ContentVersion cv:(List<ContentVersion>)Trigger.newMap.values()){
            if(cv.Type__c !=null && cv.isLatest){
                cvIdList.add(cv.id);
            }
        }
        if(cvIdList.size()>0) ContentVersionService.sendDocumentInfoToEV(cvIdList);
    }
}