trigger OpportuntiyTrigger on Opportunity (after insert,after update) {
    //slack alert service
    SlackAlertService.invokeAlert('Opportunity');
    
     //tracking service
    if(!System.Label.Track_History_Exclusion.contains(Userinfo.getUserName()))    
    TrackHistory.publishChanges('Opportunity');
}