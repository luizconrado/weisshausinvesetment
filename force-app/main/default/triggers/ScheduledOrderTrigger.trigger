trigger ScheduledOrderTrigger on Scheduled_Order__c (after update,after Insert) {
   
    //tracking service
    if(!System.Label.Track_History_Exclusion.contains(Userinfo.getUserName()))    
	TrackHistory.publishChanges('Scheduled_Order__c');
}