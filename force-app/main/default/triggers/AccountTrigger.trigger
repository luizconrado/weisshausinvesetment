trigger AccountTrigger on Account (after update,after Insert) {
    
     //tracking service
     if(!System.Label.Track_History_Exclusion.contains(Userinfo.getUserName()))    
     TrackHistory.publishChanges('Account');
}