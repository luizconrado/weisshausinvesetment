trigger TaxIdentificationTrigger on Tax_Identification__c (after update,after Insert) {
    //tracking service
    if(!System.Label.Track_History_Exclusion.contains(Userinfo.getUserName()))    
	TrackHistory.publishChanges('Tax_Identification__c');
}