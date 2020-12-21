trigger TaxIdentificationTrigger on Tax_Identification__c (after update,after Insert) {
    List<Trigger_Setting__mdt> triggerSetting=[SELECT Id FROM Trigger_Setting__mdt WHERE MasterLabel='TaxIdentificationTrigger' AND Active__c=True];
    if(triggerSetting.size()>0)  if(!System.Label.Track_History_Exclusion.contains(Userinfo.getUserName())) TrackHistory.publishChanges('Tax_Identification__c');
}