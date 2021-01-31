trigger SubscriptionTrigger on Subscription__c (after insert,after update) {

    //tracking logic
    if(!System.Label.Track_History_Exclusion.contains(Userinfo.getUserName()))    
	TrackHistory.publishChanges('Subscription__c');
}