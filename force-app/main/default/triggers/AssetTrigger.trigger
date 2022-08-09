trigger AssetTrigger on Asset(before insert,after insert,after update) {
   //tracking service
    if(!System.Label.Track_History_Exclusion.contains(Userinfo.getUserName()))    
    TrackHistory.publishChanges('Asset');

}