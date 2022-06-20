@RestResource(UrlMapping='/Asset/RealEstate/*')
global without sharing class RestServiceRealEstate {
    @HttpGet
    global static void doGet(){
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        String realEstateId=req.requestURI.substringAfterLast('/');
         //check for asset id
        if(String.isBlank(realEstateId)){
            res.statusCode = 400;
            res.responseBody=RestResponseWrapper.setError(res.statusCode,new List<String>{'Blank Real Estate Id'});
            return;
        }
        List<Asset> realEstateList=[SELECT Id,
                                    Name,PurchaseDate,House_Number__c,Plot_Size__c,Property_Type__c,Construction_Type__c,Flat_Type__c,Build_Year__c,Number_Of_Floors__c,Living_Space__c,Balcony_Available__c,
                                    Elevator_Available__c,Garage_Available__c,Price,Quantity,Last_Known_Price__c,Last_Known_Price_Date__c,Street__c,City__c,Post_Code__c,Country__c,
                                    (Select id,Image_Url__c FROM Asset_Links__r WHERE RecordTypeId=:Constant.ASSET_LINK_IMAGE_RECORDTYPEID),
                                    (SELECT Id,Date__c,Value__c FROM Evaluations__r) from Asset WHERE Asset_id__c=:realEstateId AND Is_Deleted_By_Customer__c=false];
        
        //check if asset id is present in system
        if(realEstateList.size()==0){
            res.statusCode = 404;
            res.responseBody=RestResponseWrapper.setError(res.statusCode,new List<String>{'Real Estate Id Not Found :'+realEstateId});
            return;
        }
        
        res.statusCode=200;
        res.responseBody=RestResponseWrapper.setSuccess(res.statusCode,realEstateList);
    }
    @HttpDelete
    global static void doDelete(){
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        
        String realEstateId=req.requestURI.substringAfterLast('/');
        
        //check for asset id
        if(String.isBlank(realEstateId)){
            res.statusCode = 400;
            res.responseBody=RestResponseWrapper.setError(res.statusCode,new List<String>{'Blank Real Estate Id'});
            return;
        }
        List<Asset> realEstateList=[SELECT Id,Is_Deleted_By_Customer__c,
                                    Name,PurchaseDate,House_Number__c,Plot_Size__c,Property_Type__c,Construction_Type__c,Flat_Type__c,Build_Year__c,Number_Of_Floors__c,Living_Space__c,Balcony_Available__c,
                                    Elevator_Available__c,Garage_Available__c,Price,Quantity,Last_Known_Price__c,Last_Known_Price_Date__c,Street__c,City__c,Post_Code__c,Country__c,
                                    (Select id,Image_Url__c FROM Asset_Links__r WHERE RecordTypeId=:Constant.ASSET_LINK_IMAGE_RECORDTYPEID),
                                    (SELECT Id,Date__c,Value__c FROM Evaluations__r) from Asset WHERE Asset_id__c=:realEstateId];
        
        //check if asset id is present in system
        if(realEstateList.size()==0){
            res.statusCode = 404;
            res.responseBody=RestResponseWrapper.setError(res.statusCode,new List<String>{'Real Estate Id Not Found : '+realEstateId});
            return;
        }
        Asset assetName=realEstateList.get(0);
        assetName.Is_Deleted_By_Customer__c=true;
        update assetName;
        res.statusCode=204;
        res.responseBody=RestResponseWrapper.setSuccess(res.statusCode,new List<String>{assetName.Name,realEstateId});
        
        
        
    }
    @HttpPost
    global static void doPost() {
        List<String> successMessage=new List<String>();
        List<String> errorMessage=new List<String>();
        
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        Map<String, String> headersMap = req.headers;
        String body = req.requestBody.toString();
        if(String.isBlank(body)){
            res.statusCode = 400;
            res.responseBody=RestResponseWrapper.setError(res.statusCode,new List<String>{'Empty Body'});
            return;
        }
        
        Map<String,Object> assetJsonMap=( Map<String,Object>) JSON.deserializeUntyped(body);
        List<Asset_Link__c> assetLinksList=new List<Asset_Link__c>();
        List<Evaluation__c> assetEvaluationsList=new List<Evaluation__c>();
        
        //check if Asset_Links__r request is correct
        if(assetJsonMap.containsKey('Asset_Links__r')){
            Map<String,Object> recordsList=(Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(assetJsonMap.get('Asset_Links__r')));
            if(!recordsList.containsKey('records')){
                res.statusCode = 406;
                res.responseBody=RestResponseWrapper.setError(res.statusCode,new List<String>{'Invalid Asset_Links__r Body : missing records'});
                return;
            }
            assetLinksList=(List<Asset_Link__c>) JSON.deserialize(JSON.serialize(recordsList.get('records')), List<Asset_Link__c>.class);
        }
        
        //check if Evaluations__r request is correct
        if(assetJsonMap.containsKey('Evaluations__r')){
            Map<String,Object> recordsList=(Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(assetJsonMap.get('Evaluations__r')));
            if(!recordsList.containsKey('records')){
                res.statusCode = 406;
                res.responseBody=RestResponseWrapper.setError(res.statusCode,new List<String>{'Invalid Evaluations__r Body : missing records'});
                return;
            }
            assetEvaluationsList=(List<Evaluation__c>) JSON.deserialize(JSON.serialize(recordsList.get('records')), List<Evaluation__c>.class);
        }  
        String contactId=null;
        if(assetJsonMap.containsKey('Account')){
            Map<String,Object> accountRecord=(Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(assetJsonMap.get('Account')));
            if(!accountRecord.containsKey('Auth0_ID__c')){
                res.statusCode = 406;
                res.responseBody=RestResponseWrapper.setError(res.statusCode,new List<String>{'Invalid Account Body : missing Auth0_ID__c'});
                return;
            }
            String auth0Id=(String)accountRecord.get('Auth0_ID__c');
            List<Account> accountList=[SELECT id,(Select id FROM Contacts WHERE isPersonAccount=true) from Account WHERE Auth0_ID__c=:auth0Id];
            if(accountList.size()==0){
                
                res.statusCode = 404;
                res.responseBody=RestResponseWrapper.setError(404,new List<String>{'Account not found for id : '+auth0Id});
                return;
            }
            if(accountList.get(0).Contacts.size()>0) contactId=accountList.get(0).Contacts.get(0).Id;
        }
        
        if(!assetJsonMap.containsKey('Asset_Id__c')){
            res.statusCode = 404;
            res.responseBody=RestResponseWrapper.setError(res.statusCode,new List<String>{'Asset_Id__c Id Missing'});
            return;
        }
        else{
            String assetid=(string) assetJsonMap.get('Asset_Id__c');
            if(String.isBlank(assetid)){
                res.statusCode = 404;
                res.responseBody=RestResponseWrapper.setError(res.statusCode,new List<String>{'Asset_Id__c Id Missing '});
                return;
            }
        }
        
        Asset assetObject=(Asset) JSON.deserialize(body, Asset.class);
        assetObject.Is_Deleted_By_Customer__c=false;
        assetObject.contactId=contactId;
        assetObject.RecordTypeId=Constant.ASSET_REAL_ESTATE_RECORDTYPEID;
		//getting price of latest evaluationdate        
        Date latestEvalDate=null;
        Decimal latestEvalPrice=null;
        for(Evaluation__c evaluation:assetEvaluationsList){
            if(latestEvalDate==null) latestEvalDate=evaluation.Date__c;
            if(evaluation.Date__c.month()==Date.Today().Month()-1 && evaluation.Date__c.year()==Date.Today().Year()){
                latestEvalDate=evaluation.Date__c;
                latestEvalPrice=evaluation.Value__c;
            }
            
        }
        
        try{
            assetObject.Latest_Evaluation_Date__c=latestEvalDate;
            assetObject.Latest_Evaluation_Price__c=latestEvalPrice;
            insert assetObject;
            for(Asset_Link__c link:assetLinksList){
                link.RecordTypeId=Constant.ASSET_LINK_IMAGE_RECORDTYPEID;
                link.Asset__c=assetObject.id;
                link.Image_Url__c=getAssetImageBaseUrl()+EncodingUtil.urlEncode(link.Image_Url__c, 'UTF-8');
            }
            insert assetLinksList;
            for(Evaluation__c evaluation:assetEvaluationsList){
                evaluation.Asset__c=assetObject.id;
            }
            insert assetEvaluationsList;
            successMessage.add(assetObject.id);
            res.statusCode = 201;
            res.responseBody=RestResponseWrapper.setSuccess(res.statusCode,successMessage);
        }
        catch(Exception e){
            System.debug(e.getMessage()+' '+e.getCause());
            errorMessage.add(e.getMessage()+' '+e.getCause());
            errorMessage.add(e.getStackTraceString());
            logError(e,'POST',body);
            res.statusCode = 500;
            res.responseBody=RestResponseWrapper.setError(res.statusCode,errorMessage);
        }
        
        
        
    }
    @HttpPut
    global static void doPut() {
        List<String> successMessage=new List<String>();
        List<String> errorMessage=new List<String>();
        
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        Map<String, String> headersMap = req.headers;
        String body = req.requestBody.toString();
        if(String.isBlank(body)){
            res.statusCode = 400;
            res.responseBody=RestResponseWrapper.setError(res.statusCode,new List<String>{'Empty Body'});
            return;
        }
        
        Map<String,Object> assetJsonMap=( Map<String,Object>) JSON.deserializeUntyped(body);
        List<Asset_Link__c> assetLinksList=new List<Asset_Link__c>();
        List<Evaluation__c> assetEvaluationsList=new List<Evaluation__c>();
        
        //check if Asset_Links__r request is correct
        if(assetJsonMap.containsKey('Asset_Links__r')){
            Map<String,Object> recordsList=(Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(assetJsonMap.get('Asset_Links__r')));
            if(!recordsList.containsKey('records')){
                res.statusCode = 406;
                res.responseBody=RestResponseWrapper.setError(res.statusCode,new List<String>{'Invalid Asset_Links__r Body missing : records'});
                return;
            }
            assetLinksList=(List<Asset_Link__c>) JSON.deserialize(JSON.serialize(recordsList.get('records')), List<Asset_Link__c>.class);
        }
        
        //check if Evaluations__r request is correct
        if(assetJsonMap.containsKey('Evaluations__r')){
            Map<String,Object> recordsList=(Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(assetJsonMap.get('Evaluations__r')));
            if(!recordsList.containsKey('records')){
                res.statusCode = 406;
                res.responseBody=RestResponseWrapper.setError(res.statusCode,new List<String>{'Invalid Evaluations__r Body missing : records'});
                return;
            }
            assetEvaluationsList=(List<Evaluation__c>) JSON.deserialize(JSON.serialize(recordsList.get('records')), List<Evaluation__c>.class);
        }  
        
        
        
        if(!assetJsonMap.containsKey('Asset_Id__c')){
            res.statusCode = 404;
            res.responseBody=RestResponseWrapper.setError(res.statusCode,new List<String>{'Asset_Id__c Id Missing'});
            return;
        }
        
        String assetid=(string) assetJsonMap.get('Asset_Id__c');
        
        if(String.isBlank(assetid)){
            res.statusCode = 400;
            res.responseBody=RestResponseWrapper.setError(res.statusCode,new List<String>{'Asset_Id__c Id Missing'});
            return;
        }
        
        Asset assetObject=(Asset) JSON.deserialize(body, Asset.class);
        
        
        List<Asset> realEstateList=[SELECT Id,
                                    Name,PurchaseDate,House_Number__c,Plot_Size__c,Property_Type__c,Construction_Type__c,Flat_Type__c,Build_Year__c,Number_Of_Floors__c,Living_Space__c,Balcony_Available__c,
                                    Elevator_Available__c,Garage_Available__c,Price,Quantity,Last_Known_Price__c,Last_Known_Price_Date__c,Street__c,City__c,Post_Code__c,Country__c,
                                    (Select id,Image_Url__c FROM Asset_Links__r WHERE RecordTypeId=:Constant.ASSET_LINK_IMAGE_RECORDTYPEID LIMIT 1),
                                    (SELECT Id,Date__c,Value__c FROM Evaluations__r) from Asset WHERE Asset_id__c=:assetid AND Is_Deleted_By_Customer__c=false];
        List<Asset_Link__c> toUpdateAssetLinks=new List<Asset_Link__c>();
        List<Evaluation__c> toUpdateEvaluationLinks=new List<Evaluation__c>();
        if(realEstateList.size()==0){
            res.statusCode = 404;
            res.responseBody=RestResponseWrapper.setError(res.statusCode,new List<String>{'Real Estate not found for : '+assetid});
            return;
        }
        
        Asset realEstate=realEstateList.get(0);
        //getting price of latest evaluationdate
        Date latestEvalDate=null;
        Decimal latestEvalPrice=null;
        for(Evaluation__c evaluation:assetEvaluationsList){
            if(latestEvalDate==null) latestEvalDate=evaluation.Date__c;
            if(evaluation.Date__c.month()==Date.Today().Month()){
                latestEvalDate=evaluation.Date__c;
                latestEvalPrice=evaluation.Value__c;
            }
        }
        try{
            assetObject.Latest_Evaluation_Date__c=latestEvalDate;
            assetObject.Latest_Evaluation_Price__c=latestEvalPrice;
            assetObject.Id=realEstate.Id;
            update assetObject;
            for(Asset_Link__c link:assetLinksList){
                link.RecordTypeId=Constant.ASSET_LINK_IMAGE_RECORDTYPEID;
                link.asset__c=realEstate.Id;
                link.Image_Url__c=getAssetImageBaseUrl()+ EncodingUtil.urlEncode(link.Image_Url__c, 'UTF-8');
            }
            for(Evaluation__c eval:assetEvaluationsList){
                eval.asset__c=realEstate.Id;
            }
            if(assetLinksList.size()>0) {
                if(realEstate.Asset_Links__r.size()>0) delete realEstate.Asset_Links__r;
                insert assetLinksList;
            }
            if(assetEvaluationsList.size()>0) {
                if(realEstate.Evaluations__r.size()>0) delete realEstate.Evaluations__r;
                insert assetEvaluationsList;
            }
             
            successMessage.add(realEstate.Id);
            res.statusCode = 201;
            res.responseBody=RestResponseWrapper.setSuccess(res.statusCode,successMessage);
        }
        catch(Exception e){
            System.debug(e.getMessage()+' '+e.getCause());
            errorMessage.add(e.getMessage()+' '+e.getCause());
            errorMessage.add(e.getStackTraceString());
            logError(e,'PUT',body);
            res.statusCode = 500;
            res.responseBody=RestResponseWrapper.setError(res.statusCode,errorMessage);
        }
         
        
        
    }
    
    private static void logError(Exception e,String method,string body){
        LogService.LogMetadata elog=new LogService.LogMetadata(); 
        elog.addMetadataInfo(userinfo.getUserId(),'RestServiceRealEstate',method,'',method+' /Asset/RealEstate/');
        elog.addComment(body);
        elog.addError(e);
        LogService.logError(elog);
    }
    
    
    private static String getAssetImageBaseUrl(){
        
        String urlVariable=(Salesforce.isSandbox)?'RealEstateAssetDevImageLinkUrl':'RealEstateAssetProdImageLinkUrl';
        String baseUrl='';
        List<Constant__mdt> value=[SELECT id,Value__c FROM Constant__mdt WHERE DeveloperName=:urlVariable];
        if(value.size()>0) baseUrl=value.get(0).Value__c;
        return baseUrl;
    }
    
    
}