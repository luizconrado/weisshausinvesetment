public class CaseTriggerHandler extends TriggerHandler {
   
    protected override void beforeInsert(final List<SObject> newObjects) {
        List<Case> newCaseList=(List<Case>) newObjects;
        List<String> personAccountExternalIds=new List<String>();
        Map<String,Account> externalIdAndAccountMap=new  Map<String,Account>(); 
        //pre process 
        for(Case newCase:newCaseList){
            if(newCase.recordTypeId == Constant.INVESTMENTCASE_CASE_RECORDTYPEID || newCase.recordTypeId == Constant.STANDARD_CASE_RECORDTYPEID){
                //getting customer id
                if(newCase.Customer_Id__c!=null && (newCase.ContactId==null && newCase.AccountId==null)){
                    personAccountExternalIds.add(newCase.Customer_Id__c);
                }    
            }
        }
        
        if(personAccountExternalIds.size()>0) externalIdAndAccountMap=getPersonAccountMap(personAccountExternalIds);
        
        attachAccountAndContactToCase(newCaseList,externalIdAndAccountMap);
        
    }
    
    //retrive account details
    private static  Map<String,Account>  getPersonAccountMap(List<String> personAccountExternalIds){
        Map<String,Account> externalIdAndAccountMap=new Map<String,Account>();
        List<Account> personAccountList=[SELECT id,Auth0_ID__c,(SELECT id FROM Contacts WHERE IsPersonAccount =true) FROM ACCOUNT WHERE IsPersonAccount =true AND Auth0_ID__c IN:personAccountExternalIds];
        for(Account personAccount:personAccountList){
            externalIdAndAccountMap.put(personAccount.Auth0_ID__c,personAccount);
        }
        return externalIdAndAccountMap;
    }
    
    //add account and contact to case
    private static void attachAccountAndContactToCase(List<Case> newCaseList,Map<String,Account> externalIdAndAccountMap){
        //process
        for(Case newCase:newCaseList){
            if(newCase.recordTypeId == Constant.INVESTMENTCASE_CASE_RECORDTYPEID || newCase.recordTypeId == Constant.STANDARD_CASE_RECORDTYPEID){
                //seting account info
                if(newCase.Customer_Id__c!=null && (newCase.ContactId==null && newCase.AccountId==null)){
                    if(externalIdAndAccountMap.containsKey(newCase.Customer_Id__c)){
                        Account personAccount=externalIdAndAccountMap.get(newCase.Customer_Id__c);
                        newCase.AccountId=personAccount.id;
                        if(personAccount.contacts.size()>0) newCase.ContactId=personAccount.contacts.get(0).id;
                    }
                }    
            }
        }
    }

}