/***************
* @group Test Class
* @description test class for RestServiceRealEstate 
*/
@isTest
public class RestServiceRealEstateTest {
  
    @isTest
    static void doGetSuccess(){
        Account a=TestDataFactory.getPersonAccount(true);
        Contact c=[SELECT id FROM Contact LIMIT 1];
        Asset asset=TestDataFactory.getAssetRealEstate(a.Id,c.Id,true);
        
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        req.requestURI = baseUrl+'/services/apexrest/Asset/RealEstate/'+asset.Asset_Id__c; 
        req.httpMethod = 'GET';
        req.addHeader('Content-Type', 'application/json');
        
        RestContext.request = req;
        RestServiceRealEstate.doGet();    
        System.assertEquals(200,res.statusCode);
        Test.stopTest();   
    }
    @isTest
    static void doGetInvalidId(){
        Account a=TestDataFactory.getPersonAccount(true);
        Contact c=[SELECT id FROM Contact LIMIT 1];
        Asset asset=TestDataFactory.getAssetRealEstate(a.Id,c.Id,true);
        
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        req.requestURI = baseUrl+'/services/apexrest/Asset/RealEstate/'+asset.Id; 
        req.httpMethod = 'GET';
        req.addHeader('Content-Type', 'application/json');
        
        RestContext.request = req;
        RestServiceRealEstate.doGet();    
        System.assertEquals(404,res.statusCode);
        Test.stopTest();   
    }
    @isTest
    static void doGetNullId(){
        Account a=TestDataFactory.getPersonAccount(true);
        Contact c=[SELECT id FROM Contact LIMIT 1];
        Asset asset=TestDataFactory.getAssetRealEstate(a.Id,c.Id,true);
        
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        req.requestURI = baseUrl+'/services/apexrest/Asset/RealEstate/'; 
        req.httpMethod = 'GET';
        req.addHeader('Content-Type', 'application/json');
        
        RestContext.request = req;
        RestServiceRealEstate.doGet();    
        System.assertEquals(400,res.statusCode);
        Test.stopTest();   
    }
    @isTest
    static void doDeleteSuccess(){
        Account a=TestDataFactory.getPersonAccount(true);
        Contact c=[SELECT id FROM Contact LIMIT 1];
        Asset asset=TestDataFactory.getAssetRealEstate(a.Id,c.Id,true);
        
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        req.requestURI = baseUrl+'/services/apexrest/Asset/RealEstate/'+asset.Asset_Id__c; 
        req.httpMethod = 'DELETE';
        req.addHeader('Content-Type', 'application/json');
        
        RestContext.request = req;
        RestServiceRealEstate.doDelete();    
        System.assertEquals(true,[SELECT id,Is_Deleted_By_Customer__c FROM Asset WHERE id=:asset.id].Is_Deleted_By_Customer__c);
        Test.stopTest();   
    }
     @isTest
    static void doDeleteInvalidId(){
        Account a=TestDataFactory.getPersonAccount(true);
        Contact c=[SELECT id FROM Contact LIMIT 1];
        Asset asset=TestDataFactory.getAssetRealEstate(a.Id,c.Id,true);
        
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        req.requestURI = baseUrl+'/services/apexrest/Asset/RealEstate/'+asset.Id; 
        req.httpMethod = 'DELETE';
        req.addHeader('Content-Type', 'application/json');
        
        RestContext.request = req;
        RestServiceRealEstate.doDelete();    
        System.assertEquals(404,res.statusCode);
        Test.stopTest();   
    }
    @isTest
    static void doDeleteNullId(){
        Account a=TestDataFactory.getPersonAccount(true);
        Contact c=[SELECT id FROM Contact LIMIT 1];
        Asset asset=TestDataFactory.getAssetRealEstate(a.Id,c.Id,true);
        
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        req.requestURI = baseUrl+'/services/apexrest/Asset/RealEstate/'; 
        req.httpMethod = 'DELETE';
        req.addHeader('Content-Type', 'application/json');
        
        RestContext.request = req;
        RestServiceRealEstate.doDelete();    
        System.assertEquals(400,res.statusCode);
        Test.stopTest();   
    }
 
    @isTest
    static void doPutSuccess(){
        Account a=TestDataFactory.getPersonAccount(true);
        Contact c=[SELECT id FROM Contact LIMIT 1];
        Asset asset=TestDataFactory.getAssetRealEstate(a.Id,c.Id,true);
        Asset_Link__c link=TestDataFactory.getAssetLink(asset.id,true);
        Evaluation__c eval=TestDataFactory.getAssetEvaluation(asset.id,true);
        
        
        String assetJSON='{';
        assetJSON+='"Name":"'+asset.Name+'",';
        assetJSON+='"Asset_Id__c":"'+asset.Asset_Id__c+'",';
        assetJSON+='"Asset_Links__r":{';
        assetJSON+='"records":[{';
        assetJSON+='"Image_Url__c":"'+link.Image_Url__c+'"';
        assetJSON+='}]';
        assetJSON+='},';
        
        assetJSON+='"Evaluations__r":{';
         assetJSON+='"records":[';
        assetJSON+='{';
        assetJSON+='"Date__c":"2021-07-08",';
        assetJSON+='"Value__c":"'+eval.Value__c+'"},';
        assetJSON+='{';
        assetJSON+='"Date__c":"2022-07-08",';
        assetJSON+='"Value__c":"'+eval.Value__c+'"}';
        assetJSON+=']';
        assetJSON+='}';
        assetJSON+='}';
        
        
      
    
      
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        req.requestURI = baseUrl+'/services/apexrest/Asset/RealEstate/'; 
        req.httpMethod = 'PUT';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody=Blob.valueOf(assetJSON);
        RestContext.request = req;
        RestServiceRealEstate.doPut();    
        System.assertEquals(201, res.statusCode);
        Test.stopTest();   
    }
    @isTest
    static void doPutInvalidBody(){
        Account a=TestDataFactory.getPersonAccount(true);
        Contact c=[SELECT id FROM Contact LIMIT 1];
        Asset asset=TestDataFactory.getAssetRealEstate(a.Id,c.Id,true);
        Asset_Link__c link=TestDataFactory.getAssetLink(asset.id,true);
        Evaluation__c eval=TestDataFactory.getAssetEvaluation(asset.id,true);
        
        
        String assetJSON='{';
        assetJSON+='"Name":"'+asset.Name+'",';
        assetJSON+='"Asset_Id__c":"'+asset.Asset_Id__c+'",';
        assetJSON+='"Asset_Links__r":{';
        assetJSON+='"records":[{';
        assetJSON+='"Image_Url__c":"'+link.Image_Url__c+'"';
        assetJSON+='}]';
        assetJSON+='},';
        
        assetJSON+='"Evaluations__r":{';
        assetJSON+='"records":[{';
        assetJSON+='"Date__c":"2021-07-08",';
        assetJSON+='"Value__c":"'+eval.Value__c+'"';
        assetJSON+='}]';
        assetJSON+='}';
        assetJSON+='}';
        
        
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
        req.requestBody=Blob.valueOf('');
        req.requestURI = baseUrl+'/services/apexrest/Asset/RealEstate/'; 
        req.httpMethod = 'PUT';
        req.addHeader('Content-Type', 'application/json');
        
        RestContext.request = req;
        RestServiceRealEstate.doPut();    
        System.assertEquals(400, res.statusCode);
        Test.stopTest();   
    }
    @isTest
    static void doPutInvalidEvaluation(){
        Account a=TestDataFactory.getPersonAccount(true);
        Contact c=[SELECT id FROM Contact LIMIT 1];
        Asset asset=TestDataFactory.getAssetRealEstate(a.Id,c.Id,true);
        Asset_Link__c link=TestDataFactory.getAssetLink(asset.id,true);
        Evaluation__c eval=TestDataFactory.getAssetEvaluation(asset.id,true);
        
        
        String assetJSON='{';
        assetJSON+='"Name":"'+asset.Name+'",';
        assetJSON+='"Asset_Id__c":"'+asset.Asset_Id__c+'",';
        assetJSON+='"Asset_Links__r":{';
        assetJSON+='"records":[{';
        assetJSON+='"Image_Url__c":"'+link.Image_Url__c+'"';
        assetJSON+='}]';
        assetJSON+='},';
        
        assetJSON+='"Evaluations__r":{';
     
        assetJSON+='}';
        assetJSON+='}';
      
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        req.requestURI = baseUrl+'/services/apexrest/Asset/RealEstate/'; 
        req.httpMethod = 'PUT';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody=Blob.valueOf(assetJSON);
        RestContext.request = req;
        RestServiceRealEstate.doPut();    
        System.assertEquals(406, res.statusCode);
        Test.stopTest();   
    }
    @isTest
    static void doPutInvalidLinks(){
        Account a=TestDataFactory.getPersonAccount(true);
        Contact c=[SELECT id FROM Contact LIMIT 1];
        Asset asset=TestDataFactory.getAssetRealEstate(a.Id,c.Id,true);
        Asset_Link__c link=TestDataFactory.getAssetLink(asset.id,true);
        Evaluation__c eval=TestDataFactory.getAssetEvaluation(asset.id,true);
        
        
        String assetJSON='{';
        assetJSON+='"Name":"'+asset.Name+'",';
        assetJSON+='"Asset_Id__c":"'+asset.Asset_Id__c+'",';
        assetJSON+='"Asset_Links__r":{';
       
        assetJSON+='},';
        
        assetJSON+='"Evaluations__r":{';
        assetJSON+='"records":[{';
        assetJSON+='"Date__c":"2021-07-08",';
        assetJSON+='"Value__c":"'+eval.Value__c+'"';
        assetJSON+='}]';
        assetJSON+='}';
        assetJSON+='}';
      
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        req.requestURI = baseUrl+'/services/apexrest/Asset/RealEstate/'; 
        req.httpMethod = 'PUT';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody=Blob.valueOf(assetJSON);
        RestContext.request = req;
        RestServiceRealEstate.doPut();    
        System.assertEquals(406, res.statusCode);
        Test.stopTest();   
    }
    @isTest
    static void doPutInvalidAssetId(){
        Account a=TestDataFactory.getPersonAccount(true);
        Contact c=[SELECT id FROM Contact LIMIT 1];
        Asset asset=TestDataFactory.getAssetRealEstate(a.Id,c.Id,true);
        Asset_Link__c link=TestDataFactory.getAssetLink(asset.id,true);
        Evaluation__c eval=TestDataFactory.getAssetEvaluation(asset.id,true);
        
        
        String assetJSON='{';
        assetJSON+='"Name":"'+asset.Name+'",';
        assetJSON+='"Asset_Links__r":{';
        assetJSON+='"records":[{';
        assetJSON+='"Image_Url__c":"'+link.Image_Url__c+'"';
        assetJSON+='}]';
        assetJSON+='},';
        
        assetJSON+='"Evaluations__r":{';
        assetJSON+='"records":[{';
        assetJSON+='"Date__c":"2021-07-08",';
        assetJSON+='"Value__c":"'+eval.Value__c+'"';
        assetJSON+='}]';
        assetJSON+='}';
        assetJSON+='}';
      
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        req.requestURI = baseUrl+'/services/apexrest/Asset/RealEstate/'; 
        req.httpMethod = 'PUT';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody=Blob.valueOf(assetJSON);
        RestContext.request = req;
        RestServiceRealEstate.doPut();    
        System.assertEquals(404, res.statusCode);
        Test.stopTest();   
    }
      
    @isTest
    static void doPutBlankAssetId(){
        Account a=TestDataFactory.getPersonAccount(true);
        Contact c=[SELECT id FROM Contact LIMIT 1];
        Asset asset=TestDataFactory.getAssetRealEstate(a.Id,c.Id,true);
        Asset_Link__c link=TestDataFactory.getAssetLink(asset.id,true);
        Evaluation__c eval=TestDataFactory.getAssetEvaluation(asset.id,true);
        
        
        String assetJSON='{';
        assetJSON+='"Name":"'+asset.Name+'",';
        assetJSON+='"Asset_Id__c":"",';
        assetJSON+='"Asset_Links__r":{';
        assetJSON+='"records":[{';
        assetJSON+='"Image_Url__c":"'+link.Image_Url__c+'"';
        assetJSON+='}]';
        assetJSON+='},';
        
        assetJSON+='"Evaluations__r":{';
        assetJSON+='"records":[{';
        assetJSON+='"Date__c":"2021-07-08",';
        assetJSON+='"Value__c":"'+eval.Value__c+'"';
        assetJSON+='}]';
        assetJSON+='}';
        assetJSON+='}';
      
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        req.requestURI = baseUrl+'/services/apexrest/Asset/RealEstate/'; 
        req.httpMethod = 'PUT';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody=Blob.valueOf(assetJSON);
        RestContext.request = req;
        RestServiceRealEstate.doPut();    
        System.assertEquals(400, res.statusCode);
        Test.stopTest();   
    }
     
    @isTest
    static void doPutInvalidAsset(){
        Account a=TestDataFactory.getPersonAccount(true);
        Contact c=[SELECT id FROM Contact LIMIT 1];
        Asset asset=TestDataFactory.getAssetRealEstate(a.Id,c.Id,false);
        Asset_Link__c link=TestDataFactory.getAssetLink(asset.id,false);
        Evaluation__c eval=TestDataFactory.getAssetEvaluation(asset.id,false);
        
        
        String assetJSON='{';
        assetJSON+='"Name":"'+asset.Name+'",';
        assetJSON+='"Asset_Id__c":"'+asset.Asset_Id__c+'",';
        assetJSON+='"Asset_Links__r":{';
        assetJSON+='"records":[{';
        assetJSON+='"Image_Url__c":"'+link.Image_Url__c+'"';
        assetJSON+='}]';
        assetJSON+='},';
        
        assetJSON+='"Evaluations__r":{';
        assetJSON+='"records":[{';
        assetJSON+='"Date__c":"2021-07-08",';
        assetJSON+='"Value__c":"'+eval.Value__c+'"';
        assetJSON+='}]';
        assetJSON+='}';
        assetJSON+='}';
      
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        req.requestURI = baseUrl+'/services/apexrest/Asset/RealEstate/'; 
        req.httpMethod = 'PUT';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody=Blob.valueOf(assetJSON);
        RestContext.request = req;
        RestServiceRealEstate.doPut();    
        System.assertEquals(404, res.statusCode);
        Test.stopTest();   
    }
 
     @isTest
    static void doPutException(){
        Account a=TestDataFactory.getPersonAccount(true);
        Contact c=[SELECT id FROM Contact LIMIT 1];
        Asset asset=TestDataFactory.getAssetRealEstate(a.Id,c.Id,true);
        Asset_Link__c link=TestDataFactory.getAssetLink(asset.id,true);
        Evaluation__c eval=TestDataFactory.getAssetEvaluation(asset.id,true);
        
         List<Asset> realEstateList=[SELECT Id,
                                    Name,PurchaseDate,Asset_Id__c,House_Number__c,Plot_Size__c,Property_Type__c,Construction_Type__c,Flat_Type__c,Build_Year__c,Number_Of_Floors__c,Living_Space__c,Balcony_Available__c,
                                    Elevator_Available__c,Garage_Available__c,Price,Quantity,Last_Known_Price__c,Last_Known_Price_Date__c,Street__c,City__c,Post_Code__c,Country__c,
                                    (Select id,Image_Url__c FROM Asset_Links__r WHERE RecordTypeId=:Constant.ASSET_LINK_IMAGE_RECORDTYPEID LIMIT 1),
                                    (SELECT Id,Date__c,Value__c FROM Evaluations__r) from Asset WHERE id=:asset.Id AND Is_Deleted_By_Customer__c=false];
        String assetJSON= JSON.serialize(realEstateList.get(0));
      
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        req.requestURI = baseUrl+'/services/apexrest/Asset/RealEstate/'; 
        req.httpMethod = 'PUT';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody=Blob.valueOf(assetJSON);
        RestContext.request = req;
        RestServiceRealEstate.doPut();    
        System.assertEquals(500, res.statusCode);
        Test.stopTest();   
    }

    @isTest
    static void doPostSuccess(){
        Account a=TestDataFactory.getPersonAccount(true);
        Contact c=[SELECT id FROM Contact LIMIT 1];
        Asset asset=TestDataFactory.getAssetRealEstate(a.Id,c.Id,false);
        Asset_Link__c link=TestDataFactory.getAssetLink(null,false);
        Evaluation__c eval=TestDataFactory.getAssetEvaluation(null,false);
        
        DateTime dt=Date.Today();
        String assetJSON='{';
        assetJSON+='"Name":"'+asset.Name+'",';
        assetJSON+='"Asset_Id__c":"'+asset.Asset_Id__c+'",';
        assetJSON+='"Asset_Links__r":{';
        assetJSON+='"records":[{';
        assetJSON+='"Image_Url__c":"'+link.Image_Url__c+'"';
        assetJSON+='}]';
        assetJSON+='},';
        
        assetJSON+='"Evaluations__r":{';
        assetJSON+='"records":[';
        assetJSON+='{';
        assetJSON+='"Date__c":"2021-07-08",';
        assetJSON+='"Value__c":"'+eval.Value__c+'"},';
        assetJSON+='{';
        assetJSON+='"Date__c":"'+dt.year()+'-'+(dt.month()-1)+'-08",';
        assetJSON+='"Value__c":"'+eval.Value__c+'"}';
        assetJSON+=']';
        assetJSON+='},';
        assetJSON+='"Account":{';
        assetJSON+='"Auth0_ID__c":"'+a.Auth0_ID__c+'"';
        
        assetJSON+='}';
        assetJSON+='}';
      
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        req.requestURI = baseUrl+'/services/apexrest/Asset/RealEstate/'; 
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody=Blob.valueOf(assetJSON);
        RestContext.request = req;
        RestServiceRealEstate.doPost();    
        System.assertEquals(201, res.statusCode);
        Test.stopTest();   
    }
   @isTest
    static void doPostInvalidBody(){
        Account a=TestDataFactory.getPersonAccount(true);
        Contact c=[SELECT id FROM Contact LIMIT 1];
        Asset asset=TestDataFactory.getAssetRealEstate(a.Id,c.Id,false);
        Asset_Link__c link=TestDataFactory.getAssetLink(null,false);
        Evaluation__c eval=TestDataFactory.getAssetEvaluation(null,false);
        
        
        String assetJSON='{';
        assetJSON+='"Name":"'+asset.Name+'",';
        assetJSON+='"Asset_Id__c":"'+asset.Asset_Id__c+'",';
        assetJSON+='"Asset_Links__r":{';
        assetJSON+='"records":[{';
        assetJSON+='"Image_Url__c":"'+link.Image_Url__c+'"';
        assetJSON+='}]';
        assetJSON+='},';
        
        assetJSON+='"Evaluations__r":{';
        assetJSON+='"records":[{';
        assetJSON+='"Date__c":"2021-07-08",';
        assetJSON+='"Value__c":"'+eval.Value__c+'"';
        assetJSON+='}]';
        assetJSON+='},';
        assetJSON+='"Account":{';
        assetJSON+='"Auth0_ID__c":"'+a.Auth0_ID__c+'"';
        
        assetJSON+='}';
        assetJSON+='}';
      
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        req.requestURI = baseUrl+'/services/apexrest/Asset/RealEstate/'; 
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody=Blob.valueOf('');
        RestContext.request = req;
        RestServiceRealEstate.doPost();    
        System.assertEquals(400, res.statusCode);
        Test.stopTest(); 
    }
    @isTest
    static void doPostInvalidEvaluation(){
        Account a=TestDataFactory.getPersonAccount(true);
        Contact c=[SELECT id FROM Contact LIMIT 1];
        Asset asset=TestDataFactory.getAssetRealEstate(a.Id,c.Id,false);
        Asset_Link__c link=TestDataFactory.getAssetLink(null,false);
        Evaluation__c eval=TestDataFactory.getAssetEvaluation(null,false);
        
        
        String assetJSON='{';
        assetJSON+='"Name":"'+asset.Name+'",';
        assetJSON+='"Asset_Id__c":"'+asset.Asset_Id__c+'",';
        assetJSON+='"Asset_Links__r":{';
        assetJSON+='"records":[{';
        assetJSON+='"Image_Url__c":"'+link.Image_Url__c+'"';
        assetJSON+='}]';
        assetJSON+='},';
        
        assetJSON+='"Evaluations__r":{';
       
        assetJSON+='},';
        assetJSON+='"Account":{';
        assetJSON+='"Auth0_ID__c":"'+a.Auth0_ID__c+'"';
        
        assetJSON+='}';
        assetJSON+='}';
      
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        req.requestURI = baseUrl+'/services/apexrest/Asset/RealEstate/'; 
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody=Blob.valueOf(assetJSON);
        RestContext.request = req;
        RestServiceRealEstate.doPost();    
        System.assertEquals(406, res.statusCode);
        Test.stopTest();   
    }
    @isTest
    static void doPostInvalidLinks(){
         Account a=TestDataFactory.getPersonAccount(true);
        Contact c=[SELECT id FROM Contact LIMIT 1];
        Asset asset=TestDataFactory.getAssetRealEstate(a.Id,c.Id,false);
        Asset_Link__c link=TestDataFactory.getAssetLink(null,false);
        Evaluation__c eval=TestDataFactory.getAssetEvaluation(null,false);
        
        
        String assetJSON='{';
        assetJSON+='"Name":"'+asset.Name+'",';
        assetJSON+='"Asset_Id__c":"'+asset.Asset_Id__c+'",';
        assetJSON+='"Asset_Links__r":{';
     
        assetJSON+='},';
        
        assetJSON+='"Evaluations__r":{';
        assetJSON+='"records":[{';
        assetJSON+='"Date__c":"2021-07-08",';
        assetJSON+='"Value__c":"'+eval.Value__c+'"';
        assetJSON+='}]';
        assetJSON+='},';
        assetJSON+='"Account":{';
        assetJSON+='"Auth0_ID__c":"'+a.Auth0_ID__c+'"';
        
        assetJSON+='}';
        assetJSON+='}';
      
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        req.requestURI = baseUrl+'/services/apexrest/Asset/RealEstate/'; 
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody=Blob.valueOf(assetJSON);
        RestContext.request = req;
        RestServiceRealEstate.doPost();    
        System.assertEquals(406, res.statusCode);
        Test.stopTest();   
    }
    @isTest
    static void doPostInvalidAccountId(){
        Account a=TestDataFactory.getPersonAccount(true);
        Contact c=[SELECT id FROM Contact LIMIT 1];
        Asset asset=TestDataFactory.getAssetRealEstate(a.Id,c.Id,false);
        Asset_Link__c link=TestDataFactory.getAssetLink(null,false);
        Evaluation__c eval=TestDataFactory.getAssetEvaluation(null,false);
        
        
        String assetJSON='{';
        assetJSON+='"Name":"'+asset.Name+'",';
        assetJSON+='"Asset_Id__c":"'+asset.Asset_Id__c+'",';
        assetJSON+='"Asset_Links__r":{';
        assetJSON+='"records":[{';
        assetJSON+='"Image_Url__c":"'+link.Image_Url__c+'"';
        assetJSON+='}]';
        assetJSON+='},';
        
        assetJSON+='"Evaluations__r":{';
        assetJSON+='"records":[{';
        assetJSON+='"Date__c":"2021-07-08",';
        assetJSON+='"Value__c":"'+eval.Value__c+'"';
        assetJSON+='}]';
        assetJSON+='},';
        assetJSON+='"Account":{';
         
        assetJSON+='}';
        assetJSON+='}';
      
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        req.requestURI = baseUrl+'/services/apexrest/Asset/RealEstate/'; 
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody=Blob.valueOf(assetJSON);
        RestContext.request = req;
        RestServiceRealEstate.doPost();    
        System.assertEquals(406, res.statusCode);
        Test.stopTest();    
    }
      @isTest
    static void doPostNonExsitingAccountId(){
        Account a=TestDataFactory.getPersonAccount(true);
        Contact c=[SELECT id FROM Contact LIMIT 1];
        Asset asset=TestDataFactory.getAssetRealEstate(a.Id,c.Id,false);
        Asset_Link__c link=TestDataFactory.getAssetLink(null,false);
        Evaluation__c eval=TestDataFactory.getAssetEvaluation(null,false);
        
        
        String assetJSON='{';
        assetJSON+='"Name":"'+asset.Name+'",';
        assetJSON+='"Asset_Id__c":"'+asset.Asset_Id__c+'",';
        assetJSON+='"Asset_Links__r":{';
        assetJSON+='"records":[{';
        assetJSON+='"Image_Url__c":"'+link.Image_Url__c+'"';
        assetJSON+='}]';
        assetJSON+='},';
        
        assetJSON+='"Evaluations__r":{';
        assetJSON+='"records":[{';
        assetJSON+='"Date__c":"2021-07-08",';
        assetJSON+='"Value__c":"'+eval.Value__c+'"';
        assetJSON+='}]';
        assetJSON+='},';
        assetJSON+='"Account":{';
        assetJSON+='"Auth0_ID__c":"auth0|id"';
        assetJSON+='}';
        assetJSON+='}';
      
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        req.requestURI = baseUrl+'/services/apexrest/Asset/RealEstate/'; 
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody=Blob.valueOf(assetJSON);
        RestContext.request = req;
        RestServiceRealEstate.doPost();    
        System.assertEquals(404, res.statusCode);
        Test.stopTest();    
    }
    @isTest
    static void doPostBlankAssetId(){
        Account a=TestDataFactory.getPersonAccount(true);
        Contact c=[SELECT id FROM Contact LIMIT 1];
        Asset asset=TestDataFactory.getAssetRealEstate(a.Id,c.Id,false);
        Asset_Link__c link=TestDataFactory.getAssetLink(null,false);
        Evaluation__c eval=TestDataFactory.getAssetEvaluation(null,false);
        
        
        String assetJSON='{';
        assetJSON+='"Name":"'+asset.Name+'",';
         assetJSON+='"Asset_Links__r":{';
        assetJSON+='"records":[{';
        assetJSON+='"Image_Url__c":"'+link.Image_Url__c+'"';
        assetJSON+='}]';
        assetJSON+='},';
        
        assetJSON+='"Evaluations__r":{';
        assetJSON+='"records":[{';
        assetJSON+='"Date__c":"2021-07-08",';
        assetJSON+='"Value__c":"'+eval.Value__c+'"';
        assetJSON+='}]';
        assetJSON+='},';
        assetJSON+='"Account":{';
        assetJSON+='"Auth0_ID__c":"'+a.Auth0_ID__c+'"';
        
        assetJSON+='}';
        assetJSON+='}';
      
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        req.requestURI = baseUrl+'/services/apexrest/Asset/RealEstate/'; 
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody=Blob.valueOf(assetJSON);
        RestContext.request = req;
        RestServiceRealEstate.doPost();    
        System.assertEquals(404, res.statusCode);
        Test.stopTest();   
    }
     
    @isTest
    static void doPostInvalidAsset(){
        Account a=TestDataFactory.getPersonAccount(true);
        Contact c=[SELECT id FROM Contact LIMIT 1];
        Asset asset=TestDataFactory.getAssetRealEstate(a.Id,c.Id,false);
        Asset_Link__c link=TestDataFactory.getAssetLink(null,false);
        Evaluation__c eval=TestDataFactory.getAssetEvaluation(null,false);
        
        
        String assetJSON='{';
        assetJSON+='"Name":"'+asset.Name+'",';
        assetJSON+='"Asset_Id__c":"",';
        assetJSON+='"Asset_Links__r":{';
        assetJSON+='"records":[{';
        assetJSON+='"Image_Url__c":"'+link.Image_Url__c+'"';
        assetJSON+='}]';
        assetJSON+='},';
        
        assetJSON+='"Evaluations__r":{';
        assetJSON+='"records":[{';
        assetJSON+='"Date__c":"2021-07-08",';
        assetJSON+='"Value__c":"'+eval.Value__c+'"';
        assetJSON+='}]';
        assetJSON+='},';
        assetJSON+='"Account":{';
        assetJSON+='"Auth0_ID__c":"'+a.Auth0_ID__c+'"';
        
        assetJSON+='}';
        assetJSON+='}';
      
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        req.requestURI = baseUrl+'/services/apexrest/Asset/RealEstate/'; 
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody=Blob.valueOf(assetJSON);
        RestContext.request = req;
        RestServiceRealEstate.doPost();    
        System.assertEquals(404, res.statusCode);
        Test.stopTest();   
    }
 
     @isTest
    static void doPostException(){
         Account a=TestDataFactory.getPersonAccount(true);
        Contact c=[SELECT id FROM Contact LIMIT 1];
        Asset asset=TestDataFactory.getAssetRealEstate(a.Id,c.Id,false);
        Asset_Link__c link=TestDataFactory.getAssetLink(null,false);
        Evaluation__c eval=TestDataFactory.getAssetEvaluation(null,false);
        
        
        String assetJSON='{';
        assetJSON+='"Name":"'+asset.Name+'",';
        assetJSON+='"Asset_Id__c":"'+asset.Asset_Id__c+'",';
        assetJSON+='"Asset_Links__r":{';
        assetJSON+='"records":[{';
        assetJSON+='"Image_Url__c":"'+link.Image_Url__c+'"';
        assetJSON+='}]';
        assetJSON+='},';
        
        assetJSON+='"Evaluations__r":{';
        assetJSON+='"records":[{';
        assetJSON+='"Date__c":"2021-07-08",';
        assetJSON+='"Value__c":"'+eval.Value__c+'"';
        assetJSON+='}]';
        assetJSON+='}';
         
        assetJSON+='}';
      
        Test.startTest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        req.requestURI = baseUrl+'/services/apexrest/Asset/RealEstate/'; 
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody=Blob.valueOf(assetJSON);
        RestContext.request = req;
        RestServiceRealEstate.doPost();    
        System.assertEquals(500, res.statusCode);
        Test.stopTest();     
    }
    
}