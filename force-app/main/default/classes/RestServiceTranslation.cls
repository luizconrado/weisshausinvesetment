/***************
* @group Rest Api
* @description translates picklist text to DE
*/
@Res
@RestResource(UrlMapping='/Translation/*/*/*')
global class RestServiceTranslation {

    /***************
    * @description returns json of picklist value in translated to de
    
    * @example
    * /services/apexrest/Translation/PickList/Knowledge__kav/Type__c
    */
    @HttpGet
    global static void doGet(){
        List<String> errorMessage=new List<String>();
        List<String> supportedMetdata=new List<String>{'picklist'};
            
            RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        
        List<String> translationRequest=req.requestURI.split('/');
        String metadata=translationRequest.get(translationRequest.size()-3);
        String objectName=translationRequest.get(translationRequest.size()-2);
        String fieldName=translationRequest.get(translationRequest.size()-1);
        
        if(supportedMetdata.indexOf(metadata.toLowerCase())==-1){
            res.statusCode = 400;
            res.responseBody=RestResponseWrapper.setError(res.statusCode,new List<String>{'Not supported metadata: '+metadata});
            return;
        }
        
        if(SchemaUtil.getSobjectType(objectName)==null){
            res.statusCode = 400;
            res.responseBody=RestResponseWrapper.setError(res.statusCode,new List<String>{'Not supported object: '+objectName});
            return;
        }
        
        if(!SchemaUtil.getObjectPicklistFileds(SchemaUtil.getSobjectType(objectName)).containsKey(fieldName)){
            res.statusCode = 400;
            res.responseBody=RestResponseWrapper.setError(res.statusCode,new List<String>{'Invalid Field: '+fieldName});
            return;
        }
        try{ 
            String responseValue='[]';
            if(metadata.toLowerCase()==supportedMetdata.get(0)){
                responseValue=Translate.getTranslatedPickListValues(objectName,fieldName);   
            }
            res.statusCode=200;
            res.responseBody=RestResponseWrapper.setSuccess(res.statusCode,( List<Object>) JSON.deserializeUntyped(responseValue));
        }catch(Exception e){
            logError(e,'GET');
            System.debug(e.getMessage()+' '+e.getCause());
            errorMessage.add(e.getMessage()+' '+e.getCause());
            errorMessage.add(e.getStackTraceString());
            res.statusCode = 500;
            res.responseBody=RestResponseWrapper.setError(res.statusCode,errorMessage);
        }
        
    }
    
    @testVisible
    private static void logError(Exception e,String method){
        LogService.LogMetadata elog=new LogService.LogMetadata(); 
        elog.addMetadataInfo(userinfo.getUserId(),'RestServiceTranslation',method,'',method+' /Translation/*/*/*');
        
        elog.addError(e);
        LogService.logError(elog);
    }
}