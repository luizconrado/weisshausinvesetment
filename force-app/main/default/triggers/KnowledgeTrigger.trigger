trigger KnowledgeTrigger on Knowledge__kav (before insert) {
    List<Trigger_Setting__mdt> triggerSetting=[SELECT Id FROM Trigger_Setting__mdt WHERE MasterLabel='KnowledgeTrigger' AND Active__c=True];
    if(triggerSetting.size()>0) new KnowledgeTriggerHandler().run();
 
    

}