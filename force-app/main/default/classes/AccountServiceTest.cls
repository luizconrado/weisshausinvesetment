/***************
* @group Test Class
* @description test class for AccountService
*/
@isTest
public class AccountServiceTest {
    
    @isTest
    static void testcreateNewIdentification(){
        Test.setMock(HttpCalloutMock.class, new SolarisBankIdentificationWrapper.MockResponse());
        Account a=TestDataFactory.getPersonAccount(true); 
       	AccountService.getRecordDetails(a.Id);
        Test.startTest();
        AccountService.createNewIdentification(a.id,'EN');
        Test.stopTest();
    }
   
    @isTest
    static void testsyncPersonDetailsWithSB(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankPersonWrapper.MockResponse());
        Account a=TestDataFactory.getPersonAccount(true);
        Test.startTest();
        AccountService.syncPersonDetailsWithSB(a.Id);
        Test.stopTest();
    }
    
    @isTest 
    static void createAccountAndNewsletterNewUserTest(){
        AccountService.service service=new AccountService.service();
        Test.startTest();
        service.createAccountAndNewsletter('test@ev.com','TESTING','APEX','www.ev-smartmoney.com',new Map<String,String>{'utm_medium'=>'utm_medium'},Constant.ACCOUNT_PERSON_INVESTMENT_RECORDTYPEID);
        Test.stopTest();
    }
    @isTest 
    static void createAccountAndNewsletterExsistingUserTest(){
        Account a=TestDataFactory.getPersonInvestmentAccount(true); 
        AccountService.service service=new AccountService.service();
        Test.startTest();
        service.createAccountAndNewsletter(a.PersonEmail,'TESTING','APEX','www.ev-smartmoney.com',new Map<String,String>{'utm_medium'=>'utm_medium'},Constant.ACCOUNT_PERSON_INVESTMENT_RECORDTYPEID);
        Test.stopTest();
    }
    @isTest 
    static void createAccountAndNewsletterExsistingAllTest(){
        Account a=TestDataFactory.getPersonInvestmentAccount(false);
        a.Origin__pc='Investment Landing Page';
        insert a;
        Contact c=[SELECT id FROM Contact WHERE accountId=:a.Id];
        Subscription__c sub=TestDataFactory.getNewsletterSubscription(a.id, c.Id, false);
        sub.Subscription_Status__c='Awaiting Confirmation';
        insert sub;
        AccountService.service service=new AccountService.service();
        Test.startTest();
        service.createAccountAndNewsletter(a.PersonEmail,sub.Type__c,'APEX','www.ev-smartmoney.com',new Map<String,String>{'utm_medium'=>'utm_medium'},Constant.ACCOUNT_PERSON_INVESTMENT_RECORDTYPEID);
        Test.stopTest();
    }
    
    @isTest
    static void triggerMarketingOutTest(){
        Account a=TestDataFactory.getPersonInvestmentAccount(false);
        a.Marketing_Opt_In__pc=true;
        insert a;
        Contact c=[SELECT id FROM Contact WHERE accountid=:a.id];
        Subscription__c sub=TestDataFactory.getInvestmentNewsletterSubscription(a.id,c.id,true);
        Test.startTest();
        a.Marketing_Opt_In__pc=false;
        update a;
        Test.stopTest();
    }
    
}