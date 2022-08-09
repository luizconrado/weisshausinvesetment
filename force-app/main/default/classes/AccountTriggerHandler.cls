/***************
* @group Handler Class
* @description account trigger router
*/
public class AccountTriggerHandler  extends TriggerHandler {
    
    
    
    protected  override void beforeUpdate() {
        
        for(String accountId:Trigger.newMap.keySet()){
            Account acc=(Account)Trigger.newMap.get(accountId);
            
            
            //calcuate age
            if(acc.PersonBirthdate!=null) acc.Age__pc=AccountTriggerHelper.calucateAgeBracker(acc.PersonBirthdate);
	         
            //Change record type if type is E&V Broker
            if(acc.Type=='E&V Broker' && acc.RecordTypeId!=Constant.PERSON_PARTNER_ACCOUNT_RECORDTYPEID) acc.RecordTypeId=Constant.PERSON_PARTNER_ACCOUNT_RECORDTYPEID;
            
        }

    }
    
    protected  override void afterUpdate() {
        List<String> accountsForUnsubscribing=new List<String>();
        List<String> toAnonymize=new List<String>();
        for(String accountId:Trigger.newMap.keySet()){
            Account acc=(Account)Trigger.newMap.get(accountId);
            Account oldAccount=(Account)Trigger.oldMap.get(accountId);
            
            //check marketing opt out and unsbscribe all subscription
            if(acc.Marketing_Opt_In__pc==false && oldAccount.Marketing_Opt_In__pc!=acc.Marketing_Opt_In__pc) accountsForUnsubscribing.add(accountId);
            
            
            //check if scramble requested
            if(acc.Deletion_Request__c==true && oldAccount.Deletion_Request__c!=acc.Deletion_Request__c) toAnonymize.add(acc.Id);
        }
        
        //call funtion to mass unsubscribe
        if(accountsForUnsubscribing.size()>0) AccountTriggerHelper.unsubscribeAllSubscriptions(accountsForUnsubscribing);
        
        //call function to anaonymize
        if(toAnonymize.size()>0) System.enqueueJob(new AccountScrambleData(toAnonymize));
    }
    
    
    
}