/***************
* @group Handler Class
* @description case trigger router
*/
public class CaseTriggerHandler extends TriggerHandler {
   
    protected override void beforeInsert() {
        List<Case> newCaseList=(List<Case>) Trigger.new;
        List<String> personAccountExternalIds=new List<String>();
        Map<String,Account> externalIdAndAccountMap=new  Map<String,Account>(); 
        //pre process 
        for(Case newCase:newCaseList){
            //getting customer id
            if(newCase.Customer_Id__c!=null && (newCase.ContactId==null && newCase.AccountId==null)){
                personAccountExternalIds.add(newCase.Customer_Id__c);
            }    
        }
        
        if(personAccountExternalIds.size()>0) externalIdAndAccountMap=getPersonAccountMap(personAccountExternalIds);
        System.debug('KING '+externalIdAndAccountMap);
        attachAccountAndContactToCase(newCaseList,externalIdAndAccountMap);
        
    }
    
    
    
    
    //retrive account details
    private static  Map<String,Account>  getPersonAccountMap(List<String> personAccountExternalIds){
        Map<String,Account> externalIdAndAccountMap=new Map<String,Account>();
        List<Account> personAccountList=[SELECT id,Auth0_ID__c,EVSM_Auth0_ID__c,PersonContactId FROM ACCOUNT WHERE IsPersonAccount =true AND (Auth0_ID__c IN:personAccountExternalIds OR EVSM_Auth0_ID__c IN:personAccountExternalIds)];
        for(Account personAccount:personAccountList){
            if(personAccount.EVSM_Auth0_ID__c!=null) externalIdAndAccountMap.put(personAccount.EVSM_Auth0_ID__c,personAccount);
            if(personAccount.Auth0_ID__c!=null) externalIdAndAccountMap.put(personAccount.Auth0_ID__c,personAccount);
        }
        return externalIdAndAccountMap;
    }
    
    //add account and contact to case
    private static void attachAccountAndContactToCase(List<Case> newCaseList,Map<String,Account> externalIdAndAccountMap){
        //process
        for(Case newCase:newCaseList){
            //seting account info
            if(newCase.Customer_Id__c!=null && (newCase.ContactId==null && newCase.AccountId==null)){
                if(externalIdAndAccountMap.containsKey(newCase.Customer_Id__c)){
                    Account personAccount=externalIdAndAccountMap.get(newCase.Customer_Id__c);
                    newCase.AccountId=personAccount.id;
                    newCase.ContactId=personAccount.PersonContactId;
                }
            }    
            
        }
    }

}