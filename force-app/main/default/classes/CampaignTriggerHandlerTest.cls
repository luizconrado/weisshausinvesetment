@isTest
private class CampaignTriggerHandlerTest {
    
    @isTest
    static void genrateLog(){
        Test.startTest();
        Campaign c=TestDataFactory.getStandardCampaign(true);
        c.Name='Newsletter';
        update c;
        Test.stopTest();
        
    }

}