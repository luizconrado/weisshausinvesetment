@isTest
private class AccountTriggerHandlerTest {

    @isTest
    static void generateLog(){
        Test.startTest();
        Account a=TestDataFactory.getPersonAccount(true);
        a.LastName='Test';
        update a;
        Test.stopTest();
    }
}