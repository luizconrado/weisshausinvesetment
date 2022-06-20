trigger ContentVersionTrigger on ContentVersion (after insert,after update) {
    List<Trigger_Setting__mdt> triggerSetting=[SELECT Id FROM Trigger_Setting__mdt WHERE MasterLabel='ContentVersionTrigger' AND Active__c=True];
    if(triggerSetting.size()>0) new ContentVersionTriggerHandler().run();
     
}