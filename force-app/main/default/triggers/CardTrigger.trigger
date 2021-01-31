trigger CardTrigger on Card__c (after update,after Insert) {
    
    //tracking service
    if(!System.Label.Track_History_Exclusion.contains(Userinfo.getUserName()))    
    TrackHistory.publishChanges('Card__c');
    
}