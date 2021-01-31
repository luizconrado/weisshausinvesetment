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

}