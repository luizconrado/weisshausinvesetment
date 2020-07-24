trigger CaseTrigger on Case (after update) {
    List<Trigger_Setting__mdt> triggerSetting=[SELECT Id FROM Trigger_Setting__mdt WHERE MasterLabel='CaseTrigger' AND Active__c=True];
    if(triggerSetting.size()>0)  TriggerHandlerFactory.executeHandler(CaseTriggerHandler.class, Trigger.operationType, Trigger.new,Trigger.newMap, Trigger.oldMap);
}