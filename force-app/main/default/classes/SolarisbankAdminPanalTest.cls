@isTest
public class SolarisbankAdminPanalTest {

    
    @isTest
    static void getTermDepositeStatusTest(){
        Account a=TestDataFactory.getPersonAccount(true);
        Solarisbank__c sb=TestDataFactory.getSolarisBank(a.Id,true);
        Test.startTest();
        SolarisbankAdminPanal.getTermDepositeStatus(sb.Id);
        Test.stopTest();
        
    }
    @isTest
    static void toggleTermDepostForUserTest(){
         Test.setMock(HttpCalloutMock.class, new Auth0Wrapper.MockResponse());
        Account a=TestDataFactory.getPersonAccount(true);
        Solarisbank__c sb=TestDataFactory.getSolarisBank(a.Id,true);
        
        Test.startTest();
        SolarisbankAdminPanal.toggleTermDepostForUser(sb.Id, true, 'termDepositReason');
        Test.stopTest();
    }
}