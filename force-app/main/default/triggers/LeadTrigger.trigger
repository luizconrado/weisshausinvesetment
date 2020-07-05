trigger LeadTrigger on Lead (after update,after insert) {
    List<Trigger_Setting__mdt> triggerSetting=[SELECT Id FROM Trigger_Setting__mdt WHERE MasterLabel='LeadTrigger' AND Active__c=True];
    if(triggerSetting.size()>0)  TriggerHandlerFactory.executeHandler(LeadTriggerHandler.class, Trigger.operationType, Trigger.new,Trigger.newMap, Trigger.oldMap);
}