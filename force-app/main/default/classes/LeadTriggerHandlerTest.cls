@isTest
public class LeadTriggerHandlerTest {

    @isTest
    static void generateLog(){
        Test.startTest();
        Lead l=TestDataFactory.getWebLead(true);
        l.Newsletter__c='Unsubscribed';
        update l;
        Test.stopTest();
    }
}