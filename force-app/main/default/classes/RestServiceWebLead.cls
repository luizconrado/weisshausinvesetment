/***************
* @group Rest Api
* @description Creates Banking Customer Record and subscription to investment 
*/
@RestResource(UrlMapping='/generate/subscription/*')
global without sharing  class RestServiceWebLead {

    /***************
    * @description creates/updates customer based on email address and creates new subscripiton for investment
    * @example
      {
        "email": "",
        "website": "",
        "subscriptionProduct": "",
        "origin": "",
        "utm_term": "",
        "utm_medium": "",
        "utm_source": "",
        "utm_content": "",
        "utm_campaign": "",
        "type": ""
      }
    */
    @HttpPost
    global static void doPost() {
      List<String> successMessage=new List<String>();
      List<String> errorMessage=new List<String>();
      
        RestResponse res = RestContext.response;

        RestRequest req = RestContext.request;

        Map<String, String> headersMap = req.headers;

        String body = req.requestBody.toString();

        if(body==null || String.isBlank(body)){
          res.statusCode = 400;
          res.responseBody=RestResponseWrapper.setError(res.statusCode,new List<String>{'Empty Body'});
          return;
        }

        Map<String,Object> requestBody=(Map<String,Object>) JSON.deserializeUntyped(body);
 
        if(body==null || String.isBlank((String)requestBody.get('email'))){
          res.statusCode = 404;
          res.responseBody=RestResponseWrapper.setError(res.statusCode,new List<String>{'Email Not Found'});
          return;
        }

        if(body==null || String.isBlank((String)requestBody.get('subscriptionProduct'))){
          res.statusCode = 404;
          res.responseBody=RestResponseWrapper.setError(res.statusCode,new List<String>{'Subscription Product Not Found'});
          return;
        }

      try{
        String email=(String)requestBody.get('email');
        String website=(String)requestBody.get('website');
        String subscriptionProduct=(String)requestBody.get('subscriptionProduct');
        String origin=(String)requestBody.get('origin');
        String utm_term=(String)requestBody.get('utm_term');
        String utm_medium=(String)requestBody.get('utm_medium');
        String utm_source=(String)requestBody.get('utm_source');
        String utm_content=(String)requestBody.get('utm_content');
        String utm_campaign=(String)requestBody.get('utm_campaign');
        String type=(String)requestBody.get('type');
        String recordTypeId=Constant.PERSON_ACCOUNT_RECORDTYPEID;
        if(type=='Investment') recordTypeId=Constant.ACCOUNT_PERSON_INVESTMENT_RECORDTYPEID;
      
        AccountService.service service=new AccountService.service();
        String accountId=service.createAccountAndNewsletter(email, subscriptionProduct, origin, website,new Map<String,String>{
          'utm_term'=>utm_term,
          'utm_medium'=>utm_medium,
          'utm_source'=>utm_source,
          'utm_content'=>utm_content,
          'utm_campaign'=>utm_campaign
        }, recordTypeId);
        
        successMessage.add(accountId);
        res.statusCode = 200;
        res.responseBody=RestResponseWrapper.setSuccess(res.statusCode,successMessage);
      }catch(Exception e){
          System.debug(e.getMessage()+' '+e.getCause());
          errorMessage.add(e.getMessage()+' '+e.getCause());
          errorMessage.add(e.getStackTraceString());
          logError(e,'POST',body);
          res.statusCode = 500;
          res.responseBody=RestResponseWrapper.setError(res.statusCode,errorMessage);
      }
      
   } 
    
  private static void logError(Exception e,String method,String body){
      LogService.LogMetadata elog=new LogService.LogMetadata(); 
      elog.addMetadataInfo(userinfo.getUserId(),'RestServiceWebLead',method,'',method+' /generate/subscription/*');
      elog.addComment(body);
      elog.addError(e);
      LogService.logError(elog);
  }
    
  
}