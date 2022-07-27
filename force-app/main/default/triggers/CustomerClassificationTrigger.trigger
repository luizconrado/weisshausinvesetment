trigger CustomerClassificationTrigger on Customer_Classification__c (before update) {
    List<Trigger_Setting__mdt> triggerSetting=[SELECT Id FROM Trigger_Setting__mdt WHERE MasterLabel='CustomerClassificationTrigger' AND Active__c=True];
    if(triggerSetting.size()>0) new CustomerClassificationHandler().run();


    SlackAlertService.invokeAlert('Customer_Classification__c');
    
    //tracking service
    if(!System.Label.Track_History_Exclusion.contains(Userinfo.getUserName()))    
        TrackHistory.publishChanges('Customer_Classification__c');
}