@RestResource(UrlMapping='/Account/Create/*')
global without sharing class RestServiceAccountCreate {

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
        
        if(newPersonAccount.Auth0_Id__c==null || String.isEmpty(newPersonAccount.Auth0_Id__c)){
            res.statusCode = 404;
            res.responseBody=RestResponseWrapper.setError(res.statusCode,new List<String>{'Auth0 Id  not found : '+newPersonAccount.LastName});
            return;
        }
        
        
        //check if account exsits
        List<Account> personAccountList=new List<Account>();
            
        personAccountList=[SELECT id,UTM_Content__c,UTM_Term__c,UTM_Source__c,UTM_Campaign__c,UTM_Medium__c,Invitation_Code__pc,Email_Verified__pc,FirstName,Solarisbank_Id__c,LastName,PersonEmail,Origin__pc,
                                         Auth0_ID__c,EVSM_Auth0_ID__c,RecordTypeId
                                         FROM Account
                                         WHERE 
                                         Auth0_Id__c=:newPersonAccount.Auth0_Id__c
                                         AND 
                                         Auth0_Id__c!=null                                         
                                         AND 
                                         IsPersonAccount = true
                                         LIMIT 1
                                        ];
        //adding this as we where getting exceptions for duplicate accounts based on email, even after adding email search query in above soql
        if(personAccountList.size()==0){
            personAccountList=[SELECT id,UTM_Content__c,UTM_Term__c,UTM_Source__c,UTM_Campaign__c,UTM_Medium__c,Invitation_Code__pc,Email_Verified__pc,FirstName,Solarisbank_Id__c,LastName,PersonEmail,Origin__pc,
                               Auth0_ID__c,EVSM_Auth0_ID__c,RecordTypeId
                               FROM Account
                               WHERE 
                               PersonEmail=:newPersonAccount.PersonEmail
                               AND 
                               PersonEmail!=null                                         
                               AND 
                               IsPersonAccount = true
                               LIMIT 1
                              ];
        }
       
        
 
        newAccount=(personAccountList.size()>0)?personAccountList.get(0):new Account();
        //upsert values
        if(newPersonAccount.FirstName!=null)newAccount.FirstName=newPersonAccount.FirstName;
        if(newPersonAccount.LastName!=null)newAccount.LastName=newPersonAccount.LastName;
        if(newPersonAccount.PersonEmail!=null)newAccount.PersonEmail=newPersonAccount.PersonEmail;
        if(newPersonAccount.Origin__pc!=null){
            if(newAccount.Origin__pc==null) newAccount.Origin__pc=newPersonAccount.Origin__pc;   
            else if(newAccount.Origin__pc!=null && !newAccount.Origin__pc.contains(newPersonAccount.Origin__pc)) newAccount.Origin__pc+=';'+newPersonAccount.Origin__pc; 
        }
        if(newPersonAccount.Invitation_Code__pc!=null && newAccount.Invitation_Code__pc==null )newAccount.Invitation_Code__pc=newPersonAccount.Invitation_Code__pc;
        //External Ids
        if(newPersonAccount.Solarisbank_Id__c!=null && newAccount.Solarisbank_Id__c==null) newAccount.Solarisbank_Id__c=newPersonAccount.Solarisbank_Id__c;
        if(newPersonAccount.Auth0_Id__c!=null && newAccount.Auth0_Id__c==null)newAccount.Auth0_Id__c=newPersonAccount.Auth0_Id__c;
        //Campaing Values
        if(newPersonAccount.UTM_Campaign__c!=null)newAccount.UTM_Campaign__c=newPersonAccount.UTM_Campaign__c;
        if(newPersonAccount.UTM_Medium__c!=null)newAccount.UTM_Medium__c=newPersonAccount.UTM_Medium__c;
        if(newPersonAccount.UTM_Source__c!=null)newAccount.UTM_Source__c=newPersonAccount.UTM_Source__c;
        if(newPersonAccount.UTM_Term__c!=null)newAccount.UTM_Term__c=newPersonAccount.UTM_Term__c;
        if(newPersonAccount.UTM_Content__c!=null) newAccount.UTM_Content__c=newPersonAccount.UTM_Content__c;
        if(newPersonAccount.Email_Verified__pc!=null && newPersonAccount.Email_Verified__pc==true)newAccount.Email_Verified__pc=newPersonAccount.Email_Verified__pc;
        
        if(newPersonAccount.UTM_Term__c!=null && newAccount.Invitation_Code__pc==null)newAccount.Invitation_Code__pc=newPersonAccount.UTM_Term__c;
	
        if(personAccountList.size()==0) newAccount.RecordTypeId=Constant.PERSON_ACCOUNT_RECORDTYPEID;
        else if(personAccountList.size()>0 && personAccountList.get(0).EVSM_Auth0_ID__c!=null && personAccountList.get(0).RecordTypeId!=Constant.ACCOUNT_INVESTMENT_BANKING_RECORDTYPEID) newAccount.RecordTypeId=Constant.ACCOUNT_INVESTMENT_BANKING_RECORDTYPEID; 
       
        if(Salesforce.isSandbox && personAccountList.size()==0) newAccount.Solarisbank_Tenent__c='Mobile';
        
        
        try{
                  

            upsert newAccount;
            successMessage.add(newAccount.id);
            res.statusCode = 201;
            res.responseBody=RestResponseWrapper.setSuccess(res.statusCode,successMessage);
        }
        catch(Exception e){
            System.debug(e.getMessage()+' '+e.getCause());
            errorMessage.add(e.getMessage()+' '+e.getCause());
            errorMessage.add(e.getStackTraceString());
            
            logError(e,'PATCH',body);
            res.statusCode = 500;
            res.responseBody=RestResponseWrapper.setError(res.statusCode,errorMessage);
        }
        
     } 
    	
    private static void logError(Exception e,String method,String body){
        LogService.LogMetadata elog=new LogService.LogMetadata(); 
        elog.addComment(body);
        elog.addMetadataInfo(userinfo.getUserId(),'RestServiceAccountCreate',method,'',method+' /Account/Create/*');
        
        elog.addError(e);
        LogService.logError(elog);
    }
}