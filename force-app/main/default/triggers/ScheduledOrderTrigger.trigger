trigger ScheduledOrderTrigger on Scheduled_Order__c (after update,after Insert) {
    List<Trigger_Setting__mdt> triggerSetting=[SELECT Id FROM Trigger_Setting__mdt WHERE MasterLabel='ScheduledOrderTrigger' AND Active__c=True];
    if(triggerSetting.size()>0)  if(!System.Label.Track_History_Exclusion.contains(Userinfo.getUserName())) TrackHistory.publishChanges('Scheduled_Order__c');


}