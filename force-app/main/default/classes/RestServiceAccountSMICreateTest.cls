@isTest
public class RestServiceAccountSMICreateTest {
    
    @isTest
    static void emptyBodyTest(){
        User u=TestDataFactory.getUser('Integration');
        Test.startTest();
        System.runAs(u){
            RestResponse res = new RestResponse();
            RestContext.response = res;
            RestRequest req=TestDataFactory.setRestRequest(URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexrest/Account/SMI/Create/','PATCH');
            req.requestBody=Blob.valueOf('');
            RestContext.request = req;
            RestServiceAccountSMICreate.doPatch();
            System.assertEquals(400, res.statusCode);
        }
        Test.stopTest();
    }
    @isTest
    static void emptyEVSMAuth0IdTest(){
        User u=TestDataFactory.getUser('Integration');
        Test.startTest();
        System.runAs(u){
            RestResponse res = new RestResponse();
            RestContext.response = res;
            RestRequest req=TestDataFactory.setRestRequest(URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexrest/Account/SMI/Create/','PATCH');
            req.requestBody=Blob.valueOf('{"EVSM_Auth0_ID__c":""}');
            RestContext.request = req;
            RestServiceAccountSMICreate.doPatch();
            System.assertEquals(404, res.statusCode);
        }
        Test.stopTest();
    }
    
    @isTest
    static void doPatchSuccessTest(){
        User u=TestDataFactory.getUser('Integration');
        Test.startTest();
        System.runAs(u){
            RestResponse res = new RestResponse();
            RestContext.response = res;
            RestRequest req=TestDataFactory.setRestRequest(URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexrest/Account/SMI/Create/','PATCH');
            req.requestBody=Blob.valueOf('{"Marketing_Opt_In__pc":true,"FirstName":"FirstName","LastName":"LastName","EVSM_Auth0_ID__c":"evcomcom","Origin__pc":"lightOnboarding"}');
            RestContext.request = req;
            RestServiceAccountSMICreate.doPatch();
            
            
            System.assertEquals(201, res.statusCode);
          
        }
        Test.stopTest();
    }
    @isTest
    static void doPatchExceptionTest(){
        User u=TestDataFactory.getUser('Integration');
        Test.startTest();
        System.runAs(u){
            RestResponse res = new RestResponse();
            RestContext.response = res;
            RestRequest req=TestDataFactory.setRestRequest(URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexrest/Account/SMI/Create/','PATCH');
            req.requestBody=Blob.valueOf('{"Marketing_Opt_In__pc":true,"FirstName":"FirstName","EVSM_Auth0_ID__c":"evcomcom","Origin__pc":"lightOnboarding"}');
            RestContext.request = req;
            RestServiceAccountSMICreate.doPatch();
            
            
            System.assertEquals(500, res.statusCode);
          
        }
        Test.stopTest();
    }
    @isTest
    static void doPatchSuccessExsistingTest(){
        Account a=TestDataFactory.getPersonInvestmentAccount(false);
        a.Origin__pc='TESTING';
        insert a;
        Contact c=[SELECT id FROM Contact WHERE AccountId=:a.id];
        Subscription__c sub=TestDataFactory.getInvestmentNewsletterSubscription(a.id,c.id,true);
        User u=TestDataFactory.getUser('Integration');
        Test.startTest();
        System.runAs(u){
            RestResponse res = new RestResponse();
            RestContext.response = res;
            RestRequest req=TestDataFactory.setRestRequest(URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexrest/Account/SMI/Create/','PATCH');
            req.requestBody=Blob.valueOf('{"Marketing_Opt_In__pc":true,"FirstName":"FirstName","LastName":"LastName","EVSM_Auth0_ID__c":"'+a.EVSM_Auth0_ID__c+'","Origin__pc":"lightOnboarding"}');
            RestContext.request = req;
            RestServiceAccountSMICreate.doPatch();
            
            
            System.assertEquals(201, res.statusCode);
          
        }
        Test.stopTest();
    }

}