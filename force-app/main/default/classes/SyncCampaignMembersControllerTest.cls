/***************
* @group Test Class
* @description test class for SyncCampaignMembersController
*/
@isTest
public class SyncCampaignMembersControllerTest {

    @testSetup
    static void testData(){
        Account acc=TestDataFactory.getPersonAccount(true);
        List<Contact> contact=[SELECT id,LastName FROM Contact WHERE  AccountId=:acc.Id AND Account.ispersonaccount=true];
        Subscription__c newSubscriptionProduct=TestDataFactory.getNewsletterSubscription(acc.Id,contact.get(0).Id,true); 
        Campaign c=TestDataFactory.getStandardCampaign(true);
        Contact con=TestDataFactory.getContact(true);
        Account acc2=TestDataFactory.getPersonAccount(true);
        Lead le=TestDataFactory.getWebLead(true);
        TestDataFactory.getLeadCampaignMember(c.Id,le.Id,true);
        List<Contact> contact2=[SELECT id,LastName FROM Contact WHERE  AccountId=:acc2.Id AND Account.ispersonaccount=true];
        
        Subscription__c newSubscriptionProduct2=TestDataFactory.getNewsletterSubscription(acc.Id,contact2.get(0).Id,true);
        
        CampaignMember cm2=TestDataFactory.getContactCampaignMember(c.Id,con.Id,true);
        CampaignMember cm3=TestDataFactory.getContactCampaignMember(c.Id,contact.get(0).Id,true);
    }
    @isTest 
    static void syncTest(){
       
        Campaign c=[Select id from Campaign LIMIT 1];
        Contact con2=TestDataFactory.getContact(true);
        Test.startTest(); 
        SyncCampaignMembersController.startSync(c.Id);
  
		Test.stopTest();
    }

}