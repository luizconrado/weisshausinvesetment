trigger LeadTrigger on Lead (before insert, after insert, before update, after update) {
    TriggerHandlerFactory.executeHandler(LeadTriggerHandler.class, Trigger.operationType, Trigger.new,Trigger.newMap, Trigger.oldMap);
}