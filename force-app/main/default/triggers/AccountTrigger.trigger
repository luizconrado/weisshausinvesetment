trigger AccountTrigger on Account (after update,after Insert) {
    List<Trigger_Setting__mdt> triggerSetting=[SELECT Id FROM Trigger_Setting__mdt WHERE MasterLabel='AccountTrigger' AND Active__c=True];
    if(triggerSetting.size()>0)  TriggerHandlerFactory.executeHandler(AccountTriggerHandler.class, Trigger.operationType, Trigger.new,Trigger.newMap, Trigger.oldMap);
}