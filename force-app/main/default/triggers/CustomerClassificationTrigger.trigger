trigger CustomerClassificationTrigger on Customer_Classification__c (before insert,before update,after update,after insert) {
    List<Trigger_Setting__mdt> triggerSetting=[SELECT Id FROM Trigger_Setting__mdt WHERE MasterLabel='CustomerClassificationTrigger' AND Active__c=True];
    if(triggerSetting.size()>0) new CustomerClassificationHandler().run();


    
    //Slack Service
    if(trigger.isAfter && trigger.isInsert || trigger.isAfter && trigger.isUpdate || trigger.isBefore && trigger.isDelete) {
		SlackAlertService.invokeAlert('Customer_Classification__c');
        slackv2__.utilities.startSubscriptionQueue(trigger.newMap, trigger.oldMap, trigger.operationType, 'Customer_Classification__c');
    }
    
    //tracking service
    if(!System.Label.Track_History_Exclusion.contains(Userinfo.getUserName()))    
        TrackHistory.publishChanges('Customer_Classification__c');
}