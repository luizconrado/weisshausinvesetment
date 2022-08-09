trigger KYCDetailTrigger on KYC_Detail__c (before insert,after insert,after update) {
    List<Trigger_Setting__mdt> triggerSetting=[SELECT Id FROM Trigger_Setting__mdt WHERE MasterLabel='KYCDetailTrigger' AND Active__c=True];
    if(triggerSetting.size()>0) new KYCDetailTriggerHandler().run();
    
    //Slack Service
    if(trigger.isAfter && trigger.isInsert || trigger.isAfter && trigger.isUpdate || trigger.isBefore && trigger.isDelete) {
		SlackAlertService.invokeAlert('KYC_Detail__c');
        slackv2__.utilities.startSubscriptionQueue(trigger.newMap, trigger.oldMap, trigger.operationType, 'KYC_Detail__c');
    }
    
    
}