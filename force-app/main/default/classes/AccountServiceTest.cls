@isTest
public class AccountServiceTest {
    
    @isTest
    static void testcreateNewIdentification(){
        Test.setMock(HttpCalloutMock.class, new SolarisBankIdentificationWrapper.MockResponse());
        Account a=TestDataFactory.getPersonAccount(true); 
       	AccountService.getRecordDetails(a.Id);
        Test.startTest();
        AccountService.createNewIdentification(a.id,'EN');
        Test.stopTest();
    }
   
    @isTest
    static void testsyncPersonDetailsWithSB(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankPersonWrapper.MockResponse());
        Account a=TestDataFactory.getPersonAccount(true);
        Test.startTest();
        AccountService.syncPersonDetailsWithSB(a.Id);
        Test.stopTest();
    }
}