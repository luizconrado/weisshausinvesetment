@IsTest
public class webLeadRestServiceTest {
     
    @isTest
    static void doPostNewLead(){
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
        
        RestContext.request = req;
        webLeadRestService.doPost();    
        
        List<Account> l=[Select id from Account ];
        System.assert(l.size()>0);
        
        Test.stopTest();   
    }
   
    @isTest
    static void doPostUpdateLead(){
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
        
        RestContext.request = req;
        webLeadRestService.doPost();    
        
        Account conformLeadUpdate=[Select id,(Select id,Source__c,Type__c,Subscription_Status__c from Subscriptions__r) from Account LIMIT 1 ];
        System.assert(conformLeadUpdate.Subscriptions__r.size()>0);
        Test.stopTest();
    }
    
    @isTest
    static void doPostUpdateAccount(){
        Account a=TestDataFactory.getPersonAccount(false);
        a.Origin__pc='weisshaus';
        insert a;
         List<Contact> c=[SELECT id,LastName FROM Contact WHERE  AccountId=:a.Id AND Account.ispersonaccount=true];
        Subscription__c newSubscriptionProduct=TestDataFactory.getNewsletterSubscription(a.Id,c.get(0).Id,true); 
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
        
        RestContext.request = req;
        webLeadRestService.doPost();    
        
        Account conformLeadUpdate=[Select id,(Select id,Source__c,Type__c,Subscription_Status__c from Subscriptions__r) from Account LIMIT 1 ];
        System.assert(conformLeadUpdate.Subscriptions__r.size()>0);
        Test.stopTest();
    }
    
}