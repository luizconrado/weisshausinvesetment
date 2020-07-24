@isTest
private class OpportuntiyTriggerHandlerTest {
    
	@isTest
    static void genrateLog(){
        Test.startTest();
        Account a=TestDataFactory.getPersonAccount(true);
        Opportunity o=TestDataFactory.getStandardOpportunity(a.Id,true);
        o.Name='Test';
        update o;
        Test.stopTest();
    }
}