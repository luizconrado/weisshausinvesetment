trigger CaseTrigger on Case (before insert,after insert,after update) {
    List<Trigger_Setting__mdt> triggerSetting=[SELECT Id FROM Trigger_Setting__mdt WHERE MasterLabel='CaseTrigger' AND Active__c=True];
    if(triggerSetting.size()>0) new CaseTriggerHandler().run();
        
    //tracking service
    if(!System.Label.Track_History_Exclusion.contains(Userinfo.getUserName()))    
    TrackHistory.publishChanges('Case');
}