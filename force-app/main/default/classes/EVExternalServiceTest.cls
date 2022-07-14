/***************
* @group Test Class
* @description test class for EVExternalService
*/
@isTest
public class EVExternalServiceTest {
  
    
    @isTest
    static void testFetchDocumentUrl(){ 
        Test.setMock(HttpCalloutMock.class, new EVMockResponse());
        Account a=TestDataFactory.getPersonAccount(true);
        Document__c doc=TestDataFactory.getDocumentForAccount(a.Id,true);
        Document__c document=[SELECT Read_At__c,Last_Viewed_User__c, Status__c, Requested_At__c, Ticket_Number__c, Id,Account__r.Auth0_Id__c, Account__c,Account__r.Solarisbank_Tenent__c FROM Document__c Limit 1];
        User u=TestDataFactory.getUser('Integration');
        Test.startTest();
        System.runAs(u){
            LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(document.Id,'Document__c',document.Account__r.Solarisbank_Tenent__c);
            EVExternalService.fetchDocumentUrl(document.Account__r.Auth0_Id__c, document.Ticket_Number__c, apiCallDetails);
        }
        Test.stopTest();
    }
    
    @isTest
    static void requestDocumentUrlTest(){
        Test.setMock(HttpCalloutMock.class, new EVMockResponse());
        Account a=TestDataFactory.getPersonAccount(true);
        Document__c doc=TestDataFactory.getDocumentForAccount(a.Id,true);
        User u=TestDataFactory.getUser('Integration');
        
        Test.startTest();
        System.runAs(u){
            DocumentReadControler.requestDocumentUrl(doc.id);
        }
        Test.stopTest();
        
    }
    
    @isTest
    static void requestInvestmentDocumentUrlTest(){
        Test.setMock(HttpCalloutMock.class, new EVMockResponse());
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Opportunity o=TestDataFactory.getOpportunityInvestment(a.id, true);
        
        Document__c doc=TestDataFactory.getDocumentForInvestmentOpportuntiy(o.Id,true);
        User u=TestDataFactory.getUser('Integration');
        
        Test.startTest();
        System.runAs(u){
            try{
            DocumentReadControler.requestDocumentUrl(doc.id);
            }
            Catch(Exception e){
            	System.debug('Error '+e.getMessage());    
            }
        }
        Test.stopTest();
        
    }
    
    @isTest
    static void sendProductsInfoTest(){
        Test.setMock(HttpCalloutMock.class, new Product2ServiceTest.ProductMockResponse());
        Account a=TestDataFactory.getPersonAccount(true);
        Product2 prod=TestDataFactory.getInvesetmentProduct('TestProd',true); 
        User u=TestDataFactory.getUser('Integration');
        Test.startTest();
        System.runAs(u){
            LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(prod.Id,'Product2','Sandbox');
            EVExternalService.sendProductsInfo('{"id":'+prod.Id+'}', apiCallDetails);
        }
        Test.stopTest();
    }
    
    @isTest
    static void requestDocumentUrlErrorTest(){
        Test.setMock(HttpCalloutMock.class, new EVMockResponse(true));
        Account a=TestDataFactory.getPersonAccount(true);
        Document__c doc=TestDataFactory.getDocumentForAccount(a.Id,true);
        User u=TestDataFactory.getUser('Integration');
        Test.startTest();
        System.runAs(u){
            try{
                DocumentReadControler.requestDocumentUrl(doc.id);
            }Catch(Exception e){}
        }
        Test.stopTest();
        
    }
    

    @isTest
    static void updateProductsInfoTest(){
        Test.setMock(HttpCalloutMock.class, new Product2ServiceTest.ProductMockResponse());
        Account a=TestDataFactory.getPersonAccount(true);
        Product2 prod=TestDataFactory.getInvesetmentProduct('TestProd',true);
        User u=TestDataFactory.getUser('Integration');
        Test.startTest();
        System.runAs(u){
            LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(prod.Id,'Product2','Mobile');
            EVExternalService.updateProductsInfo('{"id":'+prod.id+'}',prod.Id, apiCallDetails);
        }
        Test.stopTest();
    }
    
    @isTest
    static void sendInvestmentMoneyTransferdStatusTest(){
        Test.setMock(HttpCalloutMock.class, new EVMockResponse());
        Account a=TestDataFactory.getPersonAccount(true);
        Opportunity opp=TestDataFactory.getOpportunityInvestment(a.Id,true);
        User u=TestDataFactory.getUser('Integration');
        Test.startTest();
        System.runAs(u){
            LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(opp.Id,'Opportunity','Mobile');
            EVExternalService.updateInvestmentUpdate(opp.External_Id__c,a.EVSM_Auth0_Id__c, '{"moneyTransferred":true}', apiCallDetails);
        }
        Test.stopTest();
    }
    @isTest
    static void sendInvestmentDocumentInformationTest(){
        Test.setMock(HttpCalloutMock.class, new EVMockResponse());
        Account a=TestDataFactory.getPersonAccount(true);
        Opportunity opp=TestDataFactory.getOpportunityInvestment(a.Id,true);
        User u=TestDataFactory.getUser('Integration');
        Test.startTest();
        System.runAs(u){
            LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(opp.Id,'Opportunity','Mobile');
            EVExternalService.sendInvestmentDocumentInformation(opp.Id,'{"status":true}', apiCallDetails);
        }
        Test.stopTest();
    }
    
    @isTest
    static void updateCustomerClassificationUpdateTest(){
        Test.setMock(HttpCalloutMock.class, new EVMockResponse());
        Account a=TestDataFactory.getPersonAccount(true);
        Opportunity opp=TestDataFactory.getOpportunityInvestment(a.Id,true);
        User u=TestDataFactory.getUser('Integration');
        Test.startTest();
        System.runAs(u){
            LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(opp.Id,'Opportunity','Mobile');
            EVExternalService.updateCustomerClassificationUpdate(opp.Id,a.Id,'{"status":"ONGOING" , "type":"Professional"}', apiCallDetails);
        }
        Test.stopTest();
    }
    
    
    public class EVMockResponse implements HttpCalloutMock { 
        Boolean isError{set;get;}
        public EVMockResponse(){
            this.isError=false;
        }
        public EVMockResponse(Boolean isError){
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
            else if(req.getMethod()!='GET'){
                data=req.getBody(); 
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