trigger BookingTrigger on Booking__c (after update,after Insert) {
    List<Trigger_Setting__mdt> triggerSetting=[SELECT Id FROM Trigger_Setting__mdt WHERE MasterLabel='BookingTrigger' AND Active__c=True];
    if(triggerSetting.size()>0)  if(!System.Label.Track_History_Exclusion.contains(Userinfo.getUserName())) TrackHistory.publishChanges('Booking__c');

}