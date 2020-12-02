trigger LogEventsTrigger on Log_Event__e (after insert) {
    List<Trigger_Setting__mdt> triggerSetting=[SELECT Id FROM Trigger_Setting__mdt WHERE MasterLabel='LogEventsTrigger' AND Active__c=True];
    if(triggerSetting.size()>0) TriggerHandlerFactory.executeHandler(LogEventsHandler.class, Trigger.operationType, Trigger.new,Trigger.newMap, Trigger.oldMap);

}