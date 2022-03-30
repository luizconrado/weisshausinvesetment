@isTest
public class RestServiceAccountCreateTest {

    
    @isTest
    static void doPatchErrorTest(){
        User u=TestDataFactory.getUser('Integration');
        Test.startTest();
        System.runAs(u){
            RestResponse res = new RestResponse();
            RestContext.response = res;
            RestRequest req=TestDataFactory.setRestRequest(URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexrest/Account/Create/','PATCH');
            req.requestBody=Blob.valueOf('');
            RestContext.request = req;
            RestServiceAccountCreate.doPatch();
            System.assertEquals(400, res.statusCode);
        }
        Test.stopTest();
    }
    @isTest
    static void doPatchNoAccountTest(){
        User u=TestDataFactory.getUser('Integration');
        Test.startTest();
        System.runAs(u){
            RestResponse res = new RestResponse();
            RestContext.response = res;
            RestRequest req=TestDataFactory.setRestRequest(URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexrest/Account/Create/','PATCH');
            req.requestBody=Blob.valueOf('{"Auth0_Id__c":""}');
            RestContext.request = req;
            RestServiceAccountCreate.doPatch();
            System.assertEquals(404, res.statusCode);
        }
        Test.stopTest();
    }
    @isTest
    static void doPatchSystemErrorTest(){
        User u=TestDataFactory.getUser('Integration');
        Account a=TestDataFactory.getPersonAccount(false);
        Test.startTest();
        System.runAs(u){
            RestResponse res = new RestResponse();
            RestContext.response = res;
            RestRequest req=TestDataFactory.setRestRequest(URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexrest/Account/Create/','PATCH');
            req.requestBody=Blob.valueOf('{"PersonEmail":null,"Auth0_Id__c":"'+a.Auth0_ID__c+'"}');
            RestContext.request = req;
            RestServiceAccountCreate.doPatch();
            System.assertEquals(500, res.statusCode);
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
            RestRequest req=TestDataFactory.setRestRequest(URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexrest/Account/Create/','PATCH');
            req.requestBody=Blob.valueOf('{"FirstName":"FirstName","LastName":"LastName","Auth0_Id__c":"evcomcom","Origin__pc":"lightOnboarding"}');
            RestContext.request = req;
            RestServiceAccountCreate.doPatch();
            System.assertEquals(201, res.statusCode);
        }
        Test.stopTest();
    }
    @isTest
    static void doPatchSuccessExsistingAccountTest(){
        Account a=TestDataFactory.getPersonAccount(false);
        a.Origin__pc='integration_test';
        insert a; 
        User u=TestDataFactory.getUser('Integration');
        Test.startTest();
        System.runAs(u){
            RestResponse res = new RestResponse();
            RestContext.response = res;
            RestRequest req=TestDataFactory.setRestRequest(URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexrest/Account/Create/','PATCH');
            req.requestBody=Blob.valueOf('{"FirstName":"FirstName","LastName":"LastName","Auth0_Id__c":"'+a.Auth0_Id__c+'","Origin__pc":"lightOnboarding"}');
            RestContext.request = req;
            RestServiceAccountCreate.doPatch();
            System.assertEquals(201, res.statusCode);
        }
        Test.stopTest();
    }
}