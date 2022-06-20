/***************
* @group Test Class
* @description test class for RestServiceTranslation 
*/
@isTest
public class RestServiceTranslationTest {
    @isTest
    static void doGetSuccess(){
        
        
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        req.requestURI = baseUrl+'/services/apexrest/Translation/PickList/Knowledge__kav/Type__c'; 
        req.httpMethod = 'GET';
        req.addHeader('Content-Type', 'application/json');
        
        RestContext.request = req;
        RestServiceTranslation.doGet();    
        System.assertEquals(200,res.statusCode);
        Test.stopTest();   
    }
    @isTest
    static void doGetInvlaidMetadata(){
        
        
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        req.requestURI = baseUrl+'/services/apexrest/Translation/Label/Knowledge__kav/Type__c'; 
        req.httpMethod = 'GET';
        req.addHeader('Content-Type', 'application/json');
        
        RestContext.request = req;
        RestServiceTranslation.doGet();    
        System.assertEquals(400,res.statusCode);
        Test.stopTest();   
    }
    @isTest
    static void doGetInvlaidObject(){
        
        
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        req.requestURI = baseUrl+'/services/apexrest/Translation/PickList/Knowledge/Type__c'; 
        req.httpMethod = 'GET';
        req.addHeader('Content-Type', 'application/json');
        
        RestContext.request = req;
        RestServiceTranslation.doGet();    
        System.assertEquals(400,res.statusCode);
        Test.stopTest();   
    }
     @isTest
    static void doGetInvalidField(){
        
        
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        req.requestURI = baseUrl+'/services/apexrest/Translation/PickList/Knowledge__kav/Name__c'; 
        req.httpMethod = 'GET';
        req.addHeader('Content-Type', 'application/json');
        
        RestContext.request = req;
        RestServiceTranslation.doGet();    
        System.assertEquals(400,res.statusCode);
        Test.stopTest();   
    }
    
@isTest
    static void logErrorTest(){
        Test.startTest();
        try{
            Integer i=1/0;
        }
        Catch(Exception e){
            RestServiceTranslation.logError(e,'Test');
        }
        Test.stopTest();
    }
}