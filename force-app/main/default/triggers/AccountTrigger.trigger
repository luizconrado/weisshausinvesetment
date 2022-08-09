trigger AccountTrigger on Account (after update,after Insert,before update,before Insert) {
    List<Trigger_Setting__mdt> triggerSetting=[SELECT Id FROM Trigger_Setting__mdt WHERE MasterLabel='AccountTrigger' AND Active__c=True];
    if(triggerSetting.size()>0) new AccountTriggerHandler().run();
    
    //slack alert service
    SlackAlertService.invokeAlert('Account');
    	
     //tracking service
     if(!System.Label.Track_History_Exclusion.contains(Userinfo.getUserName()))    
     	TrackHistory.publishChanges('Account');
}