@isTest
public class LeadServiceTest {
     
       
   
    
       
    
  
    @isTest 
    static void subscribeLeadTest(){
        Account l=TestDataFactory.getPersonAccount(false);
        l.Newsletter__pc='Awaiting Confirmation';
        insert l;
        Account l2=TestDataFactory.getPersonAccount(false);
        l2.Phone='';
        l2.Salutation='';
        l2.Newsletter__pc='Awaiting Confirmation';
        insert l2;
        Test.startTest();
        LeadService.checkAndUpdateLeadOnload(l2.PersonEmail,'Newsletter');
        LeadService.updateLeadWithConfirmation(l2.PersonEmail, 'Newsletter', 'Herr', 'Test', 'User', true, '+498756321', l2.id);
        LeadService.checkAndUpdateLeadOnload(l.PersonEmail,'Newsletter');
        Account conformLead=[select id,Newsletter__pc  from Account where personEmail=:l.PersonEmail limit 1];
        System.assert(conformLead.Newsletter__pc =='Subscribed');
      
        Test.stopTest();        
    }
    @isTest 
    static void subscribeAccountTest(){
        Account a=TestDataFactory.getPersonAccount(true);
        a.FirstName='Test';
        a.Phone='123456';
        Test.startTest();
        LeadService.checkAndUpdateLeadOnload(a.PersonEmail,'Newsletter');
        Account conformAccount=[select id,Newsletter__pc from Account limit 1];
        System.assert(conformAccount.Newsletter__pc=='Subscribed');
        Test.stopTest();
    }
    
    @isTest
    static void unsubscribeLeadTest(){
        Map<String,String> options= LeadService.getUnsubscribeOptions();
        Account l=TestDataFactory.getPersonAccount(true);
        Account l2=TestDataFactory.getPersonAccount(false);
        l2.Newsletter__pc='Unsubscribed';
        insert l2;
        Test.startTest();
        LeadService.checkUnsubscribedStatus(l.PersonEmail,'Newsletter');
        LeadService.updateLeadToUnSubscribed(l.PersonEmail,'Newsletter',options.values().get(0));
        LeadService.checkUnsubscribedStatus(l2.PersonEmail,'Newsletter');
        Account conformLead=[SELECT Newsletter__pc FROM Account WHERE PersonEmail=:l.PersonEmail LIMIT 1];
        System.assert(conformLead.Newsletter__pc=='Unsubscribed');
        Test.stopTest();
    }
    @isTest
    static void unsubscribeAccountTest(){
        Map<String,String> options= LeadService.getUnsubscribeOptions();
        Account a=TestDataFactory.getPersonAccount(true);
        Account a2=TestDataFactory.getPersonAccount(false);
        a2.Newsletter__pc='Unsubscribed';
        insert a2;
        Test.startTest();
        LeadService.checkUnsubscribedStatus(a.PersonEmail,'Newsletter');
        LeadService.updateLeadToUnSubscribed(a.PersonEmail,'Newsletter',options.values().get(0));
        LeadService.checkUnsubscribedStatus(a2.PersonEmail,'Newsletter');
        Account conformAccount=[SELECT Newsletter__pc FROM Account WHERE PersonEmail=:a.PersonEmail LIMIT 1];
        System.assert(conformAccount.Newsletter__pc=='Unsubscribed');
        Test.stopTest();
    }
    
   
}