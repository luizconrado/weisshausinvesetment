trigger CampaignTrigger on Campaign (after update) {
  
    //tracking service
    if(!System.Label.Track_History_Exclusion.contains(Userinfo.getUserName()))    
    TrackHistory.publishChanges('Campaign');
}