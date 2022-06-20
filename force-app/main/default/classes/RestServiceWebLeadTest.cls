/***************
* @group Test Class
* @description test class for RestServiceWebLead
*/
@IsTest
public class RestServiceWebLeadTest { 
     
    @isTest
    static void doPostNewAccount(){
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
		        
        req.requestURI = baseUrl+'/services/apexrest/generate/lead/'; 
        req.httpMethod = 'GET';
        req.addHeader('Content-Type', 'application/json');
        req.params.put('fields[email][value]', 'test@test.com');
        req.params.put('fields[productInterested][value]', 'Newsletter');
        req.headers.put('User-Agent', 'crome;https://www.weisshause.com');
        String body='';
        body+='{';
        body+='"email": "email@test.com",';
        body+='"subscriptionProduct": "TESTING"';
        body+='}';
        req.requestBody=Blob.valueOf(body);
        RestContext.request = req;
        RestServiceWebLead.doPost();    
         
        List<Account> l=[Select id from Account ];
        System.assert(l.size()>0);
        
        Test.stopTest();   
    }
      @isTest
    static void doPostError(){
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
		        
        req.requestURI = baseUrl+'/services/apexrest/generate/lead/'; 
        req.httpMethod = 'GET';
        req.addHeader('Content-Type', 'application/json');
        req.params.put('fields[email][value]', 'test@test.com');
        req.params.put('fields[productInterested][value]', 'Newsletter');
        req.headers.put('User-Agent', 'crome;https://www.weisshause.com');
        String body='';
        body+='{';
        body+='"email": "email@test.com",';
        body+='"subscriptionProduct": "TESTING",';
        body+='"utm_term": "a realy loooooong utm teeeeeeeeeeeeeermmmmmm probabliyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy tooooooooo cause filed limit exceptionnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn"';
        
        body+='}';
        req.requestBody=Blob.valueOf(body);
        RestContext.request = req;
        try{
        RestServiceWebLead.doPost();    
        }Catch(Exception e){}
     
        Test.stopTest();   
    }
   
   
    @isTest
    static void doPostExsistingAccount(){
        Account a=TestDataFactory.getPersonAccount(false);
        a.LastName='test';
        a.PersonEmail='weisshause@test.com';
        insert a;
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        req.requestURI = baseUrl+'/services/apexrest/generate/lead/'; 
        req.httpMethod = 'GET';
        req.addHeader('Content-Type', 'application/json');
        req.params.put('fields[email][value]', a.PersonEmail);
        req.params.put('fields[productInterested][value]', 'Newsletter');
        req.headers.put('User-Agent', 'crome;https://weisshaus1.com');
        String body='';
        body+='{';
        body+='"email": "'+a.PersonEmail+'",';
        body+='"subscriptionProduct": "TESTING"';
        body+='}';
        req.requestBody=Blob.valueOf(body);
        
        RestContext.request = req;
        RestServiceWebLead.doPost();    
        
        Account conformLeadUpdate=[Select id,(Select id,Source__c,Type__c,Subscription_Status__c from Subscriptions__r) from Account LIMIT 1 ];
        System.assert(conformLeadUpdate.Subscriptions__r.size()>0);
        Test.stopTest();
    }
    
    @isTest
    static void doPostEmptyBody(){
        Account a=TestDataFactory.getPersonAccount(false);
        
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        req.requestURI = baseUrl+'/services/apexrest/generate/lead/'; 
        req.httpMethod = 'GET';
        req.addHeader('Content-Type', 'application/json');
        req.params.put('fields[productInterested][value]', 'Newsletter');
        req.headers.put('User-Agent', 'crome;https://weisshaus1.com');
        req.requestBody=Blob.valueOf('');
        RestContext.request = req;
        RestServiceWebLead.doPost();    
        
       
        Test.stopTest();
    }
    @isTest
    static void doPostEmptySubscription(){
        Account a=TestDataFactory.getPersonAccount(false);
        
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        req.requestURI = baseUrl+'/services/apexrest/generate/lead/'; 
        req.httpMethod = 'GET';
        req.addHeader('Content-Type', 'application/json');
        req.params.put('fields[productInterested][value]', 'Newsletter');
        req.headers.put('User-Agent', 'crome;https://weisshaus1.com');
         String body='';
        body+='{';
        body+='"email": "test@ev.com"';
        body+='}';
        req.requestBody=Blob.valueOf(body);
        RestContext.request = req;
        RestServiceWebLead.doPost();    
        
       
        Test.stopTest();
    }
     @isTest
    static void doPostEmptyEmail(){
        Account a=TestDataFactory.getPersonAccount(false);
        
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        req.requestURI = baseUrl+'/services/apexrest/generate/lead/'; 
        req.httpMethod = 'GET';
        req.addHeader('Content-Type', 'application/json');
        req.params.put('fields[productInterested][value]', 'Newsletter');
        req.headers.put('User-Agent', 'crome;https://weisshaus1.com');
         String body='';
        body+='{';
        body+='}';
        req.requestBody=Blob.valueOf(body);
        RestContext.request = req;
        RestServiceWebLead.doPost();    
        
       
        Test.stopTest();
    }
    @isTest
    static void logErrorTest(){
        try{
            Integer i=1/0;
        }
        Catch(Exception e){
            RestServiceWebLead.logError(e,'logErrorTest','');
        }
    }
}