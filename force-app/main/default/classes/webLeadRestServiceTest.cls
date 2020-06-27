@IsTest
public class webLeadRestServiceTest {
    
    @IsTest
    static void testGet(){
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
        req.headers.put('User-Agent', 'crome;https://weisshausinve0.wpengine.com');
        
        RestContext.request = req;
        webLeadRestService.doPost();        
      
        List<Lead> l=[Select id from Lead ];
        System.assert(l.size()>0);
        Test.stopTest();   
    }
    @IsTest
    static void testDublicateGet(){
        Test.startTest();
        Lead dupLead=TestDataFactory.getWebLead(true);
        
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        
        req.requestURI = baseUrl+'/services/apexrest/generate/lead/'; 
        req.httpMethod = 'GET';
        req.addHeader('Content-Type', 'application/json');
        
        req.params.put('fields[email][value]',dupLead.Email);
        req.params.put('fields[productInterested][value]', 'Newsletter');
        req.headers.put('User-Agent', 'crome;https://weisshausinve0.wpengine.com');
        
        RestContext.request = req;
        webLeadRestService.doPost();        
      
        List<Lead> l=[Select id from Lead ];
        System.assert(l.size()>0);
        Test.stopTest();   
    }
    
    @IsTest
    static void testGetNegative(){
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        req.requestURI = baseUrl+'/services/apexrest/generate/lead/'; 
        req.httpMethod = 'GET';
        req.addHeader('Content-Type', 'application/json');
        
        req.params.put('fields[email][value]', '');
        req.params.put('fields[websiteSource][value]', '');
        req.headers.put('User-Agent', 'crome;https://weisshausinve0.wpengine.com');
        
        RestContext.request = req;
        webLeadRestService.doPost();        
       
        
        List<Lead> l=[Select id,Email from Lead ];
        System.assert(String.isBlank(l.get(0).Email));
        Test.stopTest();   
    }
   
    
}