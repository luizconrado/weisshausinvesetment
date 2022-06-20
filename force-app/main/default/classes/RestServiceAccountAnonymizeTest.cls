@isTest
public class RestServiceAccountAnonymizeTest {

   
    @isTest
    static void doDeleteAccountErrorTest(){
        User u=TestDataFactory.getUser('Integration');
        Test.startTest();
        System.runAs(u){
            RestResponse res = new RestResponse();
            RestContext.response = res;
            RestRequest req=TestDataFactory.setRestRequest(URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexrest/Account/Anonymize/auth0','DELETE');
            RestContext.request = req;
            RestServiceAccountAnonymize.doDelete();
            System.assertEquals(404,res.statusCode);
        }
        Test.stopTest();
    } 
    @isTest
    static void doDeleteErrorTest(){
        User u=TestDataFactory.getUser('Integration');
        Test.startTest();
        System.runAs(u){
            RestResponse res = new RestResponse();
            RestContext.response = res;
            RestRequest req=TestDataFactory.setRestRequest(URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexrest/Account/Anonymize/','DELETE');
            RestContext.request = req;
            RestServiceAccountAnonymize.doDelete();
            System.assertEquals(400,res.statusCode);
        }
        Test.stopTest();
    }
    @isTest
    static void doDeleteSuccessTest(){
        User u=TestDataFactory.getUser('Integration');
        Account a=TestDataFactory.getPersonAccount(true);
        Test.startTest();
        System.runAs(u){
            RestResponse res = new RestResponse();
            RestContext.response = res;
            RestRequest req=TestDataFactory.setRestRequest(URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexrest/Account/Anonymize/'+a.Auth0_ID__c,'DELETE');
            RestContext.request = req;
            RestServiceAccountAnonymize.doDelete();
            System.assertEquals(204,res.statusCode);
        }
        Test.stopTest();
    }
    
    @isTest
    static void logErrorTest(){
        try{
            Integer i=1/0;
        }
        catch(Exception e){
            RestServiceAccountAnonymize.logError(e,'Delete','{}');
        }
    }
    
    
}