trigger BankCaseItemTrigger on Bank_Case_Item__c (after update,after Insert) {
   
    //tracking service
    if(!System.Label.Track_History_Exclusion.contains(Userinfo.getUserName()))    
	TrackHistory.publishChanges('Bank_Case_Item__c');

}