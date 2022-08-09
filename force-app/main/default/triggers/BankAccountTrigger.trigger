trigger BankAccountTrigger on Bank_Account__c (after update,after Insert) {
   
     //tracking service
     if(!System.Label.Track_History_Exclusion.contains(Userinfo.getUserName()))    
     TrackHistory.publishChanges('Bank_Account__c');
     

}