@isTest
public class BankingServiceTest {

    @isTest
    static void testcheckIsCompactLayout(){
        BankingService.checkIsCompactLayout();
    }
    @isTest
    static void testretriveBankBalanceDetails(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCardWrapper.MockResponse());
        Account a=TestDataFactory.getPersonAccount(true);
        Bank_Account__c bc=TestDataFactory.getBankAccount(a.Id,true);
        Test.startTest();
        BankingService.retriveBankBalanceDetails(bc.Id);
        Test.stopTest();
    }
}