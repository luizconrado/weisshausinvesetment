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
        
        List<Lead> l=[Select id from Lead ];
        System.assert(l.size()>0);
        
        Test.stopTest();   
    }
   
    @isTest
    static void doPostUpdateLead(){
        Lead l=TestDataFactory.getWebLead(false);
        l.Lead_origin__c='weisshause';
        insert l;
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        req.requestURI = baseUrl+'/services/apexrest/generate/lead/'; 
        req.httpMethod = 'GET';
        req.addHeader('Content-Type', 'application/json');
        req.params.put('fields[email][value]', l.Email);
        req.params.put('fields[productInterested][value]', 'Product A');
        req.headers.put('User-Agent', 'crome;https://weisshaus1.com');
        
        RestContext.request = req;
        webLeadRestService.doPost();    
        
        Lead conformLeadUpdate=[Select id,ProductInterest__c from Lead LIMIT 1 ];
        System.assert(conformLeadUpdate.ProductInterest__c=='Product A');
        Test.stopTest();
    }
    
    @isTest
    static void doPostUpdateAccount(){
        Account a=TestDataFactory.getPersonAccount(false);
        a.Origin__pc='weisshaus';
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
        Account conformAccount=[SELECT ProductInterest__pc FROM Account LIMIT 1];
        System.assert(conformAccount.ProductInterest__pc=='Newsletter');
     
        Test.stopTest();
    }
    
}