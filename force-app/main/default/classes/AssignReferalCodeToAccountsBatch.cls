public class AssignReferalCodeToAccountsBatch implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT Id,Origin__pc,Inviter_Code__pc, Inviter_Code_T_C_Date__pc FROM Account WHERE Auth0_ID__C!=null and IsPersonAccount=true AND is_Test__c=false and Inviter_Code__pc=null');
    }
    
    public void execute(Database.BatchableContext BC, List<Account> scope){
        List<Referral_Codes__c> referalCodes = [SELECT Account_Id__c, Used__c, Name, Id FROM Referral_Codes__c WHERE Used__c=false];
        
        for(Integer i=0;i<scope.size();i++){
            
            if(referalCodes.size()>i){
                System.debug(scope.get(i).Id);
                scope.get(i).Inviter_Code_T_C_Date__pc = DateTime.now();
                scope.get(i).Inviter_Code__pc = referalCodes.get(i).name;
                if(scope.get(i).Origin__pc==null)scope.get(i).Origin__pc+=';Auto-Generated Referral Code';
                else if(scope.get(i).Origin__pc!=null)scope.get(i).Origin__pc='Auto-Generated Referral Code';
                referalCodes.get(i).Used__c = true;
                referalCodes.get(i).Account_Id__c= scope.get(i).Id;
            }
        }
        update referalCodes;
        update scope;
    }
    
    public void finish(Database.BatchableContext BC){
        
    }
}