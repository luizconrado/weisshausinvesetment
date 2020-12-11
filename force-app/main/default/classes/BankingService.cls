public with sharing class BankingService {
    
      @AuraEnabled
    public static Boolean checkIsCompactLayout() {
        return Salesforce.isCompactLayout;
    }
    
    @AuraEnabled
    public static string retriveBankBalanceDetails(string bankAccountId){
        Bank_Account__c bankAccount=[SELECT id,Person_Account__c,Solarisbank_Id__c,Person_Account__r.Solarisbank_Tenent__c  FROM Bank_Account__c WHERE Id=:bankAccountId];
        
        LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(bankAccount.Id,'Bank_Account__c',bankAccount.Person_Account__r.Solarisbank_Tenent__c);
        
        return SolarisbankService.fetchAccountBalance(bankAccount.Solarisbank_Id__c,apiCallDetails);
    }

    
}