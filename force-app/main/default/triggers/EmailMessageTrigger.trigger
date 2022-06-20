trigger EmailMessageTrigger on EmailMessage (before insert) {
    List<Trigger_Setting__mdt> triggerSetting=[SELECT Id FROM Trigger_Setting__mdt WHERE MasterLabel='EmailMessage' AND Active__c=True];
    
        if(triggerSetting.size()>0)  new EmailMessageTriggerHandler().run(); 
   
    
    
  

}