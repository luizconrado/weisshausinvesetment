@isTest
public class DocumentServiceTest {
  
    
    @isTest
    static void testFetchDocumentUrl(){
        Test.setMock(HttpCalloutMock.class, new DocumentMockResponse());
        Account a=TestDataFactory.getPersonAccount(true);
        Document__c doc=TestDataFactory.getDocumentForAccount(a.Id,true);
        Document__c document=[SELECT Read_At__c,Last_Viewed_User__c, Status__c, Requested_At__c, Ticket_Number__c, Id,Account__r.Auth0_Id__c, Account__c,Account__r.Solarisbank_Tenent__c FROM Document__c Limit 1];
        Test.startTest();
        LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(document.Id,'Document__c',document.Account__r.Solarisbank_Tenent__c);
        DocumentService.fetchDocumentUrl(document.Account__r.Auth0_Id__c, document.Ticket_Number__c, apiCallDetails);
        Test.stopTest();
    }
    
    @isTest
    static void requestDocumentUrlTest(){
        Test.setMock(HttpCalloutMock.class, new DocumentMockResponse());
        Account a=TestDataFactory.getPersonAccount(true);
        Document__c doc=TestDataFactory.getDocumentForAccount(a.Id,true);
        Test.startTest();
        DocumentReadControler.requestDocumentUrl(doc.id);
        Test.stopTest();
        
    }
    @isTest
    static void requestDocumentUrlErrorTest(){
        Test.setMock(HttpCalloutMock.class, new DocumentMockResponse(true));
        Account a=TestDataFactory.getPersonAccount(true);
        Document__c doc=TestDataFactory.getDocumentForAccount(a.Id,true);
        Test.startTest();
        try{
        DocumentReadControler.requestDocumentUrl(doc.id);
        }Catch(Exception e){}
        Test.stopTest();
        
    }
    
      public class DocumentMockResponse implements HttpCalloutMock { 
        Boolean isError{set;get;}
        public DocumentMockResponse(){
            this.isError=false;
        }
        public DocumentMockResponse(Boolean isError){
            this.isError=isError;
        }
        
        public HTTPResponse respond(HTTPRequest req) { 
            String data='{}';
            HttpResponse resp = new HttpResponse(); 
            resp.setStatusCode(200); 
            resp.setStatus('success');  
            if(req.getEndpoint().contains('customers') && req.getEndpoint().contains('documents')){
                data='{"pdfUrlBase64":"https://salesforce-api.dev.ev-smartmoney.com/"}'; 
            } 
            
            if(isError){
                resp.setStatusCode(400); 
                resp.setStatus('error');   
                data='{"error":"failed"}';
            }
            
            resp.setBody(data); 
            return resp; 
            
        }
    }
}