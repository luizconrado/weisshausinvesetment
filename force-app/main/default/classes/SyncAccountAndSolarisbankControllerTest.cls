@isTest
public class SyncAccountAndSolarisbankControllerTest {
    
    @isTest
    static void coverTestClass(){
         SyncAccountAndSolarisbankController.coverTestclass();
         SyncAccountAndSolarisbankController.convertCentsToEuro(1000);
    }
    @isTest
    static void teststartSyncWithBank(){
        Account a=TestDataFactory.getPersonAccount(true);
        Test.setMock(HttpCalloutMock.class, new MockResponse(a.Solarisbank_Id__c));
       
        Test.startTest();
       
        SyncAccountAndSolarisbankController.startSyncWithBank(a.Id);
        Test.stopTest();
        SyncAccountAndSolarisbankController.startSyncWithBank(a.Id);
    }

    @isTest
    static void teststartSyncWithBankAccount(){
        Test.setMock(HttpCalloutMock.class, new MockResponse());
        Account a=TestDataFactory.getPersonAccount(true);
        Bank_Account__c b= TestDataFactory.getBankAccount(a.Id, true);
        Test.startTest();
        SyncAccountAndSolarisbankController.startSyncWithBankAccount(b.Id);
       
        Test.stopTest();
     }
    @isTest
    static void startSyncWithAuthOTest(){
        Test.setMock(HttpCalloutMock.class, new Auth0Wrapper.MockResponse());
        Account a=TestDataFactory.getPersonAccount(true);
        Test.startTest();
        SyncAccountAndSolarisbankController.startSyncWithAuthO(a.Id);
        Test.stopTest();
         
    }

    public class MockResponse implements HttpCalloutMock { 
        string sbId='0652225cebcd3bec2c95ea8c461fe146cacc';
        public MockResponse(){}
        public MockResponse(String solarisbankId){
            sbId=solarisbankId;
        }
        public HTTPResponse respond(HTTPRequest req) { 
      
            String endpoint=req.getEndpoint();
            String body='[{"id":"'+sbId+'"}]';
            
            HttpResponse resp = new HttpResponse(); 
            
            resp.setStatusCode(200); 
            
            resp.setStatus('success'); 
            
            if(endpoint.endsWith(sbId)){
                body = '{"last_name":"apiname"}';
            }
            else if(endpoint.endsWith('/mobile_number')){
                body = '{}';
            }
           
            resp.setBody(body); 
            
            return resp; 
            
        }
    }
}