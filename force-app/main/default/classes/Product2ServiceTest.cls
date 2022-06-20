/***************
* @group Test Class
* @description test class for Product2Service
*/
@isTest
public class Product2ServiceTest {
    @isTest
    static void invesemtentDateValidationInsertTest(){
        Account a=TestDataFactory.getPersonAccount(true);
        Test.startTest();
        try{
        Product2 prod=TestDataFactory.getInvesetmentProduct('TestProd',false); 
         
        insert prod;
        }Catch(Exception e){}
        Test.stopTest();
    }
    @isTest
    static void invesemtentDateValidationUpdateTest(){
        Account a=TestDataFactory.getPersonAccount(true);
        Product2 prod=TestDataFactory.getInvesetmentProduct('TestProd',false); 
         insert prod;
        Test.startTest();
        try{
        
         update prod;
        }Catch(Exception e){}
        Test.stopTest();
    }
    @isTest
    static void sendProductsInfoTest(){
        Test.setMock(HttpCalloutMock.class, new ProductMockResponse());
        Account a=TestDataFactory.getPersonAccount(true);
        Test.startTest();
        Product2 prod=TestDataFactory.getInvesetmentProduct('TestProd',false); 
        prod.Update_Website__c=true;
        insert prod;
        Test.stopTest();
        
    }
    @isTest
    static void updateProductsInfoTest(){
        Test.setMock(HttpCalloutMock.class, new ProductMockResponse());
        Account a=TestDataFactory.getPersonAccount(true);
        Product2 prod=TestDataFactory.getInvesetmentProduct('TestProd',true);
        Test.startTest();
         update prod;
        Test.stopTest();
    }
    @isTest
    static void sendProductsInfoNegetiveTest(){
        Test.setMock(HttpCalloutMock.class, new ProductMockResponse());
        Account a=TestDataFactory.getPersonAccount(true);
        Test.startTest();
        Product2 prod=TestDataFactory.getInvesetmentProduct('TestProd',false); 
        prod.Update_Website__c=true;
        insert prod;
        FlowSendProductDetailsToBE.sendProductDataToExternalSystem(new List<Product2>{prod});
        Test.stopTest();
        
    }
    @isTest
    static void updateProductsInfoNegetiveTest(){
        Test.setMock(HttpCalloutMock.class, new ProductMockResponse());
        Account a=TestDataFactory.getPersonAccount(true);
        Product2 prod=TestDataFactory.getInvesetmentProduct('TestProd',true);
        Test.startTest();
        prod.Update_Website__c=true;
        update prod;
        FlowUpdateProductDetailsToBE.updatedProductDataToExternalSystem(new List<Product2>{prod});
        Test.stopTest();
    }
    
    public class ProductMockResponse implements HttpCalloutMock { 
        Boolean isError{set;get;}
        public ProductMockResponse(){
            this.isError=false;
        }
        public ProductMockResponse(Boolean isError){
            this.isError=isError;
        }
        
        public HTTPResponse respond(HTTPRequest req) { 
            String data='{}';
            HttpResponse resp = new HttpResponse(); 
            resp.setStatusCode(200); 
            resp.setStatus('success');  
            data='{"id":"asd123kcdicdc"}'; 
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