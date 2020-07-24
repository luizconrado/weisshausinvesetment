@isTest
public class LeadServiceTest {
     
       
   
    
    @isTest
    static void getLastEmailToLeadInfoTest(){
        
        Test.startTest();
        LeadService.leadWrapper x=new LeadService.leadWrapper();

        x.leadId=null;
        x.showForm=true;
        Lead l=TestDataFactory.getWebLead(true);
        List<History_Tracker__c> history=LeadService.getLastEmailToLeadInfo(l.Email);
        Test.stopTest();
    }
   
    
    @isTest
    static void convertLeadToPersonAccountTest(){
        Lead l=TestDataFactory.getWebLead(true);
        Test.startTest();
        LeadService.convertLeadToPersonAccount(l.Id,l.Email);
        Test.stopTest();
    }
    @isTest 
    static void sendEmailToLeadTest(){
        Lead l=TestDataFactory.getWebLead(true);
        Test.startTest();
        LeadService.sendEmailToLead(l.Id,JSON.serialize(New Map<String,Boolean>{
            'newsletter'=>true,
                'productA'=>true
                }));
        Test.stopTest();
    }
    
    @isTest 
    static void subscribeLeadTest(){
        Lead l=TestDataFactory.getWebLead(false);
        l.Newsletter__c='Awaiting Confirmation';
        insert l;
        Lead l2=TestDataFactory.getWebLead(false);
        l2.Phone='';
        l2.Salutation='';
        l2.Newsletter__c='Awaiting Confirmation';
        insert l2;
        Test.startTest();
        LeadService.checkAndUpdateLeadOnload(l2.Email,'Newsletter');
        LeadService.updateLeadWithConfirmation(l2.Email, 'Newsletter', 'Herr', 'Test', 'User', true, '+498756321', l2.id);
        LeadService.checkAndUpdateLeadOnload(l.Email,'Newsletter');
        Lead conformLead=[select id,Newsletter__c from lead where email=:l.Email limit 1];
        System.assert(conformLead.Newsletter__c=='Subscribed');
      
        Test.stopTest();        
    }
    @isTest 
    static void subscribeAccountTest(){
        Account a=TestDataFactory.getPersonAccount(true);
        Test.startTest();
        LeadService.checkAndUpdateLeadOnload(a.PersonEmail,'Newsletter');
        Account conformAccount=[select id,Newsletter__pc from Account limit 1];
        System.assert(conformAccount.Newsletter__pc=='Subscribed');
        Test.stopTest();
    }
    
    @isTest
    static void unsubscribeLeadTest(){
        Map<String,String> options= LeadService.getUnsubscribeOptions();
        Lead l=TestDataFactory.getWebLead(true);
        Lead l2=TestDataFactory.getWebLead(false);
        l2.Newsletter__c='Unsubscribed';
        insert l2;
        Test.startTest();
        LeadService.checkUnsubscribedStatus(l.Email,'Newsletter');
        LeadService.updateLeadToUnSubscribed(l.Email,'Newsletter',options.values().get(0));
        LeadService.checkUnsubscribedStatus(l2.Email,'Newsletter');
        Lead conformLead=[SELECT Newsletter__c FROM Lead WHERE email=:l.Email LIMIT 1];
        System.assert(conformLead.Newsletter__c=='Unsubscribed');
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