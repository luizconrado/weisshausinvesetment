trigger DocumentTrigger on Document__c (after update,after Insert,before update) {
    //tracking service
     if(!System.Label.Track_History_Exclusion.contains(Userinfo.getUserName()))    
     TrackHistory.publishChanges('Document__c');

}