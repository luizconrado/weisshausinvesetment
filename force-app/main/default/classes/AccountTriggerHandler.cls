/***************
* @group Trigger Handler
* @description Handles routing of trigger context
*/
public class AccountTriggerHandler  extends TriggerHandler {
    
    
    /***************
    * @description Responseble for
    * a. caluatle person agentname
    * b. change record type to Person partner customer
    */
    protected  override void beforeUpdate(final Map<Id, SObject> newObjects, final Map<Id, SObject> oldObjects) {
        
        for(String accountId:newObjects.keySet()){
            Account acc=(Account)newObjects.get(accountId);
            
            
            
            //calcuate age
            if(acc.PersonBirthdate!=null) acc.Age__pc=AccountTriggerHelper.calucateAgeBracket(acc.PersonBirthdate);
	         
            //Change record type if type is E&V Broker
            if(acc.Type=='E&V Broker' && acc.RecordTypeId!=Constant.PERSON_PARTNER_ACCOUNT_RECORDTYPEID) acc.RecordTypeId=Constant.PERSON_PARTNER_ACCOUNT_RECORDTYPEID;
            
        }

    }

    /***************
    * @description Responseble for
    * a. initate scrambeling data of account
    */
    protected  override void afterUpdate(final Map<Id, SObject> newObjects, final Map<Id, SObject> oldObjects) {
        List<String> toAnonymize=new List<String>();
        for(String accountId:newObjects.keySet()){
            Account acc=(Account)newObjects.get(accountId);
            
            //check if scramble requested
            if(acc.Deletion_Request__c==true && ((Account)oldObjects.get(accountId)).Deletion_Request__c!=acc.Deletion_Request__c) toAnonymize.add(acc.Id);
        }
        
        
        //call function to anaonymize
        if(toAnonymize.size()>0) System.enqueueJob(new AccountScrambleData(toAnonymize));
    }
    
    
    
}