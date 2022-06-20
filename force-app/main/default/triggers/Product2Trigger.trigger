trigger Product2Trigger on Product2 (before insert,after insert,before update) {
    List<Trigger_Setting__mdt> triggerSetting=[SELECT Id FROM Trigger_Setting__mdt WHERE MasterLabel='Product2Trigger' AND Active__c=True];
    
    if(triggerSetting.size()>0) new Product2TriggerHandler().run();
    
}