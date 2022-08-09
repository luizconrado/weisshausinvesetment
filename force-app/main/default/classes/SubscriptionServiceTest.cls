/***************
* @group Test Class
* @description test class for SubscriptionService
*/
@isTest
private class SubscriptionServiceTest {
    
    @isTest 
    static void testSubscription(){
        Account a=TestDataFactory.getPersonAccount(true);
        Subscription__c sub=TestDataFactory.getNewsletterSubscription(a.Id,[SELECT id FROM Contact LIMIT 1].Id ,true);
        Test.startTest();
        Boolean b=SubscriptionService.checkAndUpdateSubscriptionOnload(a.PersonEmail,'Newsletter').showForm;
        SubscriptionService.updateSubscriptionWithConfirmation(a.PersonEmail, 'Newsletter', '', '','',true, '', a.Id);
        System.assert(b);
        Test.stopTest();
    }
     @isTest
    static void testUnSubscription(){
        Account a=TestDataFactory.getPersonAccount(true);
        Subscription__c sub=TestDataFactory.getNewsletterSubscription(a.Id,[SELECT id FROM Contact LIMIT 1].Id ,false);
        sub.Subscription_Status__c='Unsubscribed'; 
        insert sub;
        Test.startTest();
        SubscriptionService.checkUnsubscribedStatus(a.PersonEmail,'Newsletter');
        SubscriptionService.updateSubscriptionToUnSubscribed(a.PersonEmail,'Newsletter','');
        SubscriptionService.getUnsubscribeOptions();
        SubscriptionService.getLastEmailSentInfo(sub.Id);
        Test.stopTest();
    
    }

    
    @isTest
    static void registerSubscriptionTest(){
        User u=TestDataFactory.getUser('Integration');
        Test.startTest();
        SubscriptionService.registerSubscription('test@ev.com','Newsletter','','www.evsmartmoeny.com',new Map<String,String>());
        Test.stopTest();
        
    }
    @isTest
    static void confirmSubscriptionOfUserTest(){
        User u=TestDataFactory.getUser('Integration');
        Account a=TestDataFactory.getPersonAccount(true);
        Contact c=[SELECT id FROM Contact WHERE accountId=:a.Id];
        Subscription__c sub=TestDataFactory.getNewsletterSubscription(a.Id, c.Id, true);
        System.runAs(u){
            Test.startTest();
            SubscriptionService.confirmSubscriptionOfUser(a.PersonEmail,sub.Type__c);
            Test.stopTest();
        }
    }
    @isTest
    static void confirmSubscriptionOfUserError(){
        Test.startTest();
        SubscriptionService.confirmSubscriptionOfUser(null,null);
        Test.stopTest();
    }
    @isTest
    static void logErrorTest(){
        try{
            Integer i=1/0;
        }catch(Exception e){
            SubscriptionService.logError(e,'recordID','objectName','componentName','logErrorTest','operation');
        }
    }
    @isTest
    static void registerSubscriptionErrorTest(){
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Test.startTest();
        try{
        SubscriptionService.registerSubscription(a.PersonEmail,'TESTING','TEST',null,null);
        }Catch(Exception e){}
        Test.stopTest();
    }
    
    @isTest
    static void checkUnsubscribedLeadStatusTest(){
        Lead l=TestDataFactory.getWebLead(true);
        Subscription__c sub=TestDataFactory.getLeadWebinarSubscription(l.Id,true);
        System.debug([SELECT NAME FROM LEAD]);
        System.debug([SELECT NAME FROM Subscription__c]);
        SubscriptionService.checkUnsubscribedLeadStatus(l.Email,sub.Type__c);
    }
    
    @isTest
    static void updateLeadSubscriptionToUnSubscribedTest(){
        Lead l=TestDataFactory.getWebLead(true);
        Subscription__c sub=TestDataFactory.getLeadWebinarSubscription(l.Id,true);
        SubscriptionService.updateLeadSubscriptionToUnSubscribed(l.Email,sub.Type__c,'');
    }
    
    @isTest
    static void confirmSubscriptionOfLeadTest(){
        Lead l=TestDataFactory.getWebLead(true);
        Subscription__c sub=TestDataFactory.getLeadWebinarSubscription(l.Id,true);
        SubscriptionService.confirmSubscriptionOfLead(l.Email,sub.Type__c);
    }
    
    @isTest
    static void createLeadAndSubscriptionTest(){
        SubscriptionService.createLeadAndSubscription('firstName', 'lastName', 'email@ev.com', 'productName', 'origin', 'website', new Map<String,String>());
    }

}