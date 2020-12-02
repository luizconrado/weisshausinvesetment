@isTest
public class SyncAccountAndSolarisbankControllerTest {
    
    @isTest
    static void teststartSyncWithBank(){
        
        Test.setMock(HttpCalloutMock.class, new MockResponse());
        Account a=TestDataFactory.getPersonAccount(true);
        Test.startTest();
        SyncAccountAndSolarisbankController.coverTestclass();
        SyncAccountAndSolarisbankController.startSyncWithBank(a.Id);
        Test.stopTest();
    }

    @isTest
    static void teststartSyncWithBankAccount(){
        Test.setMock(HttpCalloutMock.class, new MockResponse());
        Account a=TestDataFactory.getPersonAccount(true);
        Bank_Account__c b= TestDataFactory.getBankAccount(a.Id, true);
        Test.startTest();
        SyncAccountAndSolarisbankController.coverTestclass();
        SyncAccountAndSolarisbankController.startSyncWithBankAccount(b.Id);
        
        Test.stopTest();
    }

    public class MockResponse implements HttpCalloutMock { 
        
        public HTTPResponse respond(HTTPRequest req) { 
      
            String endpoint=req.getEndpoint();
            String body='[{"id":"0652225cebcd3bec2c95ea8c461fe146cacc"}]';
            
            HttpResponse resp = new HttpResponse(); 
            
            resp.setStatusCode(200); 
            
            resp.setStatus('success'); 
            
            if(endpoint=='https://api.solaris-sandbox.de/v1/persons/0652225cebcd3bec2c95ea8c461fe146cacc'){
                body = '{"last_name":"apiname"}';
            }
            else if(endpoint=='https://api.solaris-sandbox.de/v1/persons/0652225cebcd3bec2c95ea8c461fe146cacc/mobile_number'){
                body = '{}';
            }
           
            resp.setBody(body); 
            
            return resp; 
            
        }
    }
}