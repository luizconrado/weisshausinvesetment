trigger AccountTrigger on Account (after update,after Insert,before update,before Insert) {
    List<Trigger_Setting__mdt> triggerSetting=[SELECT Id FROM Trigger_Setting__mdt WHERE MasterLabel='AccountTrigger' AND Active__c=True];
    if(triggerSetting.size()>0) TriggerHandlerFactory.executeHandler(AccountTriggerHandler.class, Trigger.operationType, Trigger.new,Trigger.newMap, Trigger.oldMap);
    
     //tracking service
     if(!System.Label.Track_History_Exclusion.contains(Userinfo.getUserName()))    
     TrackHistory.publishChanges('Account');
}