@isTest
public class FlowCoverageTest {

    @isTest
    static void Seizure_NotificationTest(){
        Account a=TestDataFactory.getPersonAccount(true);
        Seizure__c sei=TestDataFactory.getSeziure(a.Id,True);
    }
}