trigger OpportuntiyTrigger on Opportunity (after update) {
    List<Trigger_Setting__mdt> triggerSetting=[SELECT Id FROM Trigger_Setting__mdt WHERE MasterLabel='OpportuntiyTrigger' AND Active__c=True];
    if(triggerSetting.size()>0)  TriggerHandlerFactory.executeHandler(OpportuntiyTriggerHandler.class, Trigger.operationType, Trigger.new,Trigger.newMap, Trigger.oldMap);
}