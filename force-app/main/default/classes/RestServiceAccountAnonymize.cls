/***************
* @group Rest Api
* @description Randomize data on record
*/
@RestResource(UrlMapping='/Account/Anonymize/*')
global class RestServiceAccountAnonymize {

    /***************
    * @description updates user record Deletion_Request__c as true
    * @example
    * /Account/Anonymize/001asdasd41Cdsvfv
    */
	@Httpdelete
    global static void doDelete(){
        List<String> successMessage=new List<String>();
        List<String> errorMessage=new List<String>();
        
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        
        List<String> requestParam=req.requestURI.split('/');  
        
        String accountAuth0Id=requestParam.get(requestParam.size()-1);
      
        accountAuth0Id=EncodingUtil.urlDecode(accountAuth0Id,'UTF-8');
        List<Account> personAccountList=[SELECT id,Deletion_Request__c,LastName, Deletion_Request_Source__c FROM Account WHERE Auth0_Id__c=:accountAuth0Id OR EVSM_Auth0_Id__c=:accountAuth0Id];
        
        if(personAccountList.size()==0){
            res.statusCode = 404;
            res.responseBody=RestResponseWrapper.setError(res.statusCode,new List<String>{'Account Id not found : '+accountAuth0Id});
            return;
        }
        
    
        
        try{
            Account personAccount=personAccountList.get(0);
            if(personAccount.Deletion_Request__c==false){
                personAccount.Deletion_Request__c=true;
                personAccount.Deletion_Request_Source__c='Backend';
                update personAccount;
                
            }
            res.statusCode=204;
            successMessage.add(personAccount.id);
            successMessage.add(personAccount.LastName);
            successMessage.add(accountAuth0Id);
            res.responseBody=RestResponseWrapper.setSuccess(res.statusCode,successMessage);
        }
        catch(Exception e){
            System.debug(e.getMessage()+' '+e.getCause());
            errorMessage.add(e.getMessage()+' '+e.getCause());
            errorMessage.add(e.getStackTraceString());
            logError(e,'DELETE',req.requestURI);
            res.statusCode = 500;
            res.responseBody=RestResponseWrapper.setError(res.statusCode,errorMessage);
        }
        
     
     } 
	
    @testvisible    
    private static void logError(Exception e,String method,String params){
        LogService.LogMetadata elog=new LogService.LogMetadata(); 
        elog.addComment(params);
        elog.addMetadataInfo(userinfo.getUserId(),'RestServiceAccountAnonymize',method,'',method+' /Account/Anonymize/*');
        
        elog.addError(e);
        LogService.logError(elog);
    }
    	
}