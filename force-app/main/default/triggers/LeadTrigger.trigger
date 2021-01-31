trigger LeadTrigger on Lead (after update,after insert) {
     //tracking service
    if(!System.Label.Track_History_Exclusion.contains(Userinfo.getUserName()))    
    TrackHistory.publishChanges('Lead');
}