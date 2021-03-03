@isTest
public class DigibankCaseServiceTest {

    @isTest
    static void prepareBugInfoBodyTest(){
        Account a=TestDataFactory.getPersonAccount(true);
        Case c=TestDataFactory.getEVKontoCase(a.Id,true);
        Test.startTest();
        DigibankCaseService.prepareBugInfoBody(c.Id);
        Test.stopTest();
        Case result=[SELECT id,Internal_Description__c FROM Case where id=:c.Id];
        System.assert(result.Internal_Description__c!=null);
    }
}