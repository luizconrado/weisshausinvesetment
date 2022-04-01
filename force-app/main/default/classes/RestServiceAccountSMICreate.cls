@RestResource(UrlMapping='/Account/SMI/Create/*')
global class RestServiceAccountSMICreate { 

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
        Subscription__c subscriptionRecord=null;
        Account newPersonAccount=(Account)  JSON.deserialize(body, Account.class);
        
        if(newPersonAccount.EVSM_Auth0_ID__c==null || String.isEmpty(newPersonAccount.EVSM_Auth0_ID__c)){
            res.statusCode = 404;
            res.responseBody=RestResponseWrapper.setError(res.statusCode,new List<String>{'EVSM Auth0 Id  not found : '+newPersonAccount.LastName});
            return;
        }
        
        
        //check if account exsits// 
        List<Account> personAccountList=[SELECT id,Gender__pc,PersonContactId  ,T_C_Accepted_Date__c ,PersonMobilePhone ,Invitation_Code__pc,Email_Verified__pc,EVSM_Auth0_ID__c,FirstName,Solarisbank_Id__c,LastName,PersonEmail,Origin__pc,
                                         UTM_Content__c,UTM_Term__c,UTM_Source__c,UTM_Campaign__c,UTM_Medium__c,Auth0_ID__c,
                                         (SELECT id ,Account__c, Subscription_Terms_and_Conditions__c,Subscription_Status__c,Source__c FROM Subscriptions__r WHERE Type__c ='Newsletter')
                                         FROM Account
                                         WHERE 
                                         (EVSM_Auth0_ID__c=:newPersonAccount.EVSM_Auth0_ID__c OR PersonEmail=:newPersonAccount.PersonEmail)
                                         AND 
										 PersonEmail!=null                                         
                                         AND 
                                         IsPersonAccount = true
                                         LIMIT 1
                                        ];
       
        
 
        newAccount=(personAccountList.size()>0)?personAccountList.get(0):new Account();
       
        
        //External Ids
        if(newPersonAccount.EVSM_Auth0_ID__c!=null && newAccount.EVSM_Auth0_ID__c==null)newAccount.EVSM_Auth0_ID__c=newPersonAccount.EVSM_Auth0_ID__c;
        
        //upsert values
        if(newPersonAccount.FirstName!=null)newAccount.FirstName=newPersonAccount.FirstName;
        if(newPersonAccount.LastName!=null)newAccount.LastName=newPersonAccount.LastName;
        if(newPersonAccount.Gender__pc!=null)newAccount.Gender__pc=newPersonAccount.Gender__pc;
        
        if(newPersonAccount.PersonEmail!=null)newAccount.PersonEmail=newPersonAccount.PersonEmail;
        if(newPersonAccount.PersonMobilePhone!=null)newAccount.PersonMobilePhone=newPersonAccount.PersonMobilePhone;
        
        if(newPersonAccount.Invitation_Code__pc!=null && newAccount.Invitation_Code__pc==null )newAccount.Invitation_Code__pc=newPersonAccount.Invitation_Code__pc;
        
        if(newPersonAccount.Origin__pc!=null){
            if(newAccount.Origin__pc==null) newAccount.Origin__pc=newPersonAccount.Origin__pc;   
            else if(newAccount.Origin__pc!=null && !newAccount.Origin__pc.contains(newPersonAccount.Origin__pc)) newAccount.Origin__pc+=';'+newPersonAccount.Origin__pc; 
        }
        
        //Booleans
        if(newPersonAccount.Email_Verified__pc!=null)newAccount.Email_Verified__pc=newPersonAccount.Email_Verified__pc;
        if(newPersonAccount.T_C_Accepted_Date__c!=null) newAccount.T_C_Accepted_Date__c = newPersonAccount.T_C_Accepted_Date__c;
        if(newPersonAccount.Marketing_Opt_In__pc!=null )newAccount.Marketing_Opt_In__pc=newPersonAccount.Marketing_Opt_In__pc;
        
         //Campaing Values
        if(newPersonAccount.UTM_Campaign__c!=null)newAccount.UTM_Campaign__c=newPersonAccount.UTM_Campaign__c;
        if(newPersonAccount.UTM_Medium__c!=null)newAccount.UTM_Medium__c=newPersonAccount.UTM_Medium__c;
        if(newPersonAccount.UTM_Source__c!=null)newAccount.UTM_Source__c=newPersonAccount.UTM_Source__c;
        if(newPersonAccount.UTM_Term__c!=null)newAccount.UTM_Term__c=newPersonAccount.UTM_Term__c;
        if(newPersonAccount.UTM_Content__c!=null) newAccount.UTM_Content__c=newPersonAccount.UTM_Content__c;
        
        if(personAccountList.size()==0) newAccount.RecordTypeId=Constant.ACCOUNT_PERSON_INVESTMENT_RECORDTYPEID;
        else if(personAccountList.size()>0 && personAccountList.get(0).Auth0_ID__c!=null && personAccountList.get(0).RecordTypeId!=Constant.ACCOUNT_INVESTMENT_BANKING_RECORDTYPEID) newAccount.RecordTypeId=Constant.ACCOUNT_INVESTMENT_BANKING_RECORDTYPEID; 
       
        
        if(newPersonAccount.Marketing_Opt_In__pc==true){
            subscriptionRecord = new Subscription__c();
            if(personAccountList.size()>0){
                if(personAccountList.get(0).Subscriptions__r.size()>0){
                    subscriptionRecord=personAccountList.get(0).Subscriptions__r.get(0);
                }
            }            
            subscriptionRecord.Type__c='Newsletter';
            subscriptionRecord.Subscription_Terms_and_Conditions__c=true;
            subscriptionRecord.Subscription_Status__c='Subscribed';
            subscriptionRecord.Source__c='www.ev-smartmoney.com';
                
        }
        
        try{
            

            upsert newAccount;
            if(subscriptionRecord!=null){
                if(subscriptionRecord.Account__c==null ) subscriptionRecord.Account__c=newAccount.id;
                if(subscriptionRecord.Contact__c==null ){
                    List<Contact> contactAccountList=[SELECT id FROM Contact WHERE accountId=:newAccount.id AND isPersonAccount=true];
                    if(contactAccountList.size()>0){
                    	subscriptionRecord.Contact__c=contactAccountList.get(0).Id;        
                    }
                }
                
                upsert subscriptionRecord;
            } 
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
        elog.addMetadataInfo(userinfo.getUserId(),'RestServiceAccountSMICreate',method,'',method+' /Account/SMI/Create/*');
        elog.addComment(body);
        elog.addError(e);
        LogService.logError(elog);
    }
}