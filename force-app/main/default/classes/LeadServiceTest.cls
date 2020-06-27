@isTest
public class LeadServiceTest {
    
    @testSetup
    static void setupdata(){
        Lead l=TestDataFactory.getWebLead(true);
    }

    @isTest
    static void convertLeadTest(){
        Test.startTest();
        Lead l=[SELECT Id,Email FROM Lead limit 1];
        LeadService.convertLeadToPersonAccount(l.Id,l.Email);
        
        Test.stopTest();
    }    
    @isTest 
    static void updateLeadWithConfirmationTest(){
        Test.startTest();
        Lead l=[SELECT Id,Email FROM Lead limit 1];
		LeadService.updateLeadWithConfirmation(Util.randomString(6),'Newsletter','Mr'
                                               ,Util.randomString(6),Util.randomString(6),true
                                               ,'123456789',l.id);
        Test.stopTest();
    }
    @isTest
    static void updateWithRandomNumberTest(){
        Test.startTest();
        LeadService.updateWithRandomNumber([SELECT Id,LeadSource,Activation_Number__c FROM lead]);
        
        Test.stopTest();
    }
    
    @isTest
    static void leadDupeMergeTest(){
        Test.startTest();
        Lead l=[select id,Email,ProductInterest__c from lead Limit 1] ;
        Lead dupLead=TestDataFactory.getWebLead(false);
        dupLead.Email=l.Email;
        dupLead.ProductInterest__c='Product B';
        insert dupLead;
        Test.stopTest();
    }
    @isTest
    static void resendMailTest(){
        Test.startTest();
        
        Lead l=[select id,Email,ProductInterest__c from lead Limit 1] ;
        Lead dupLead=TestDataFactory.getWebLead(false);
        dupLead.Email=l.Email;
        dupLead.ProductInterest__c='Product B';
        insert dupLead;
        Lead dupLead1=TestDataFactory.getWebLead(false);
        dupLead1.Email=l.Email;
        dupLead1.ProductInterest__c='Product B';
        insert dupLead1;
       
        Test.stopTest();
        
    }
    
    @isTest
    static void checkAndUpdateLeadOnloadTest(){
        Test.startTest();
        Lead l=[SELECT id,Email FROM Lead LIMIT 1];
        LeadService.checkAndUpdateLeadOnload(l.Email, 'Newsletter');
        Test.stopTest();
    }
   
}