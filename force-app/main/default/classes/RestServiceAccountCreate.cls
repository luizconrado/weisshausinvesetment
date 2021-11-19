@RestResource(UrlMapping='/Account/Create/*')
global class RestServiceAccountCreate {

	@HttpPatch
    global static void doPatch(){
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
        
        Account newAccount=null;
        
        Account newPersonAccount=(Account)  JSON.deserialize(body, Account.class);
        
        if(newPersonAccount.Auth0_Id__c==null && newPersonAccount.PersonEmail==null){
            res.statusCode = 404;
            res.responseBody=RestResponseWrapper.setError(res.statusCode,new List<String>{'Auth0 Id or Email not found : '+newPersonAccount.LastName});
            return;
        }
        
        
        
        List<Account> personAccountList=[SELECT id,Invitation_Code__pc,Auth0_Id__c,FirstName,Solarisbank_Id__c,LastName,PersonEmail,Origin__pc FROM Account
                                         WHERE 
                                         (Auth0_Id__c=:newPersonAccount.Auth0_Id__c 
                                         OR PersonEmail=:newPersonAccount.PersonEmail )
                                         AND RecordTypeId  =: Constant.PERSON_ACCOUNT_RECORDTYPEID
                                        ];
       
        
        
        newAccount=(personAccountList.size()>0)?personAccountList.get(0):new Account();
        //upsert values
        if(newPersonAccount.FirstName!=null)newAccount.FirstName=newPersonAccount.FirstName;
        if(newPersonAccount.LastName!=null)newAccount.LastName=newPersonAccount.LastName;
        if(newPersonAccount.PersonEmail!=null)newAccount.PersonEmail=newPersonAccount.PersonEmail;
        if(newPersonAccount.Origin__pc!=null)newAccount.Origin__pc=newPersonAccount.Origin__pc;
        if(newPersonAccount.Solarisbank_Id__c!=null) newAccount.Solarisbank_Id__c=newPersonAccount.Solarisbank_Id__c;
        if(newPersonAccount.Auth0_Id__c!=null && newAccount.Auth0_Id__c==null)newAccount.Auth0_Id__c=newPersonAccount.Auth0_Id__c;
        if(newPersonAccount.Invitation_Code__pc!=null && newAccount.Invitation_Code__pc==null )newAccount.Invitation_Code__pc=newPersonAccount.Invitation_Code__pc;
        
        if(personAccountList.size()==0) newAccount.RecordTypeId=Constant.PERSON_ACCOUNT_RECORDTYPEID;
        
        
        
        
        try{
                  System.debug('newAccount '+newAccount);

            upsert newAccount;
            successMessage.add(newAccount.id);
            res.statusCode = 201;
            res.responseBody=RestResponseWrapper.setSuccess(res.statusCode,successMessage);
        }
        catch(Exception e){
            System.debug(e.getMessage()+' '+e.getCause());
            errorMessage.add(e.getMessage()+' '+e.getCause());
            errorMessage.add(e.getStackTraceString());
            logError(e,'PATCH');
            res.statusCode = 500;
            res.responseBody=RestResponseWrapper.setError(res.statusCode,errorMessage);
        }
        
     } 
    	
    private static void logError(Exception e,String method){
        LogService.LogMetadata elog=new LogService.LogMetadata(); 
        elog.addMetadataInfo(userinfo.getUserId(),'RestServiceAccountCreate',method,'',method+' /Account/*');
        
        elog.addError(e);
        LogService.logError(elog);
    }
}