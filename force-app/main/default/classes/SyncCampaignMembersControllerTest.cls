@isTest
public class SyncCampaignMembersControllerTest {

    @testSetup
    static void testData(){
        Campaign c=TestDataFactory.getStandardCampaign(true);
        Lead l=TestDataFactory.getWebLead(true);
        Contact con=TestDataFactory.getContact(true);
        CampaignMember cm=TestDataFactory.getLeadCampaignMember(c.Id,l.Id,true);
        CampaignMember cm2=TestDataFactory.getContactCampaignMember(c.Id,con.Id,true);
        
    }
    @isTest 
    static void syncTest(){
       
        Campaign c=[Select id from Campaign LIMIT 1];
        Lead l2=TestDataFactory.getWebLead(true);
        l2.Newsletter__c='Subscribed';
        update l2;
        Contact con2=TestDataFactory.getContact(true);
        Test.startTest();
        SyncCampaignMembersController.startSync(c.Id);
        List<CampaignMember> campaignMemberList=[SELECT Id from CampaignMember WHERE CampaignId=:c.Id];
        System.assert(campaignMemberList.size()==3);
		Test.stopTest();
    }

}