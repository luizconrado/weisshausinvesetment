trigger CampaignTrigger on Campaign (after update) {
    List<Trigger_Setting__mdt> triggerSetting=[SELECT Id FROM Trigger_Setting__mdt WHERE MasterLabel='CampaignTrigger' AND Active__c=True];
    if(triggerSetting.size()>0)  TriggerHandlerFactory.executeHandler(CampaignTriggerHandler.class, Trigger.operationType, Trigger.new,Trigger.newMap, Trigger.oldMap);
}