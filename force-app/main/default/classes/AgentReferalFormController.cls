public without sharing class AgentReferalFormController {
 
    @AuraEnabled(cacheable=true)
    public static List<Account> getBuninessAccountName(String accName){
        String keywords = '%' +  accName + '%';
        return [Select Id, Name From Account Where Name like:keywords AND RecordTypeId=:Constant.ACCOUNT_BUSINESS_ACCOUNT_RECORDTYPEID AND Type='E&V Licensed Partner' ORDER BY Name ASC LIMIT 5];
    }    
    
     @AuraEnabled
    public static String fetchCustomerReferalCode(String payload){
        Map<String,Object> payloadData=(Map<String,Object>) JSON.deserializeUntyped(payload);
        Boolean createPersonAccount=(Boolean) payloadData.get('isPersonAccount');
        String refralCode=null;
        Referral_Codes__c newReferalCode=null;
        Account accountDetails=null;
        //check if business account or person account
        
        if(createPersonAccount){
            //get exsisting details
            Account personAccount=getPersonDetails((String)payloadData.get('email'));
            String exsistingPersonReferalCode=checkRefealCode(personAccount,createPersonAccount);
            Account businessAccount;
            if((String)payloadData.get('companyId')!=null){
                //get exsisting business details
                businessAccount=getBusinessDetails((String)payloadData.get('companyId'),(String) payloadData.get('bankIban'));
            }
            // creating business account
            if(businessAccount==null && (String)payloadData.get('accountName')!=null && String.isNotEmpty((String)payloadData.get('accountName'))) businessAccount=createBusinessAccount((String)payloadData.get('accountName'),(String) payloadData.get('bankName'),(String) payloadData.get('bankIban'));
                
            
            
            //code already assigned stop execution
            if(exsistingPersonReferalCode!=null){
                refralCode = exsistingPersonReferalCode;
                if(businessAccount!=null) attachPersonToBusiness(businessAccount.id,personAccount.Id);
                sendReferalCodeEmail(personAccount.Id,(Boolean)payloadData.get('isExsistingCustomer'),(Boolean)payloadData.get('isPersonAccount'));
                updateAccountOrigin(personAccount);
                return refralCode;
            }
            
            if(exsistingPersonReferalCode==null) newReferalCode=getNewRefralCode();
          
             
            //all codes exausted stop
            if(newReferalCode==null) return null;
            // creating person account
            if(personAccount==null) personAccount=createPersonAccount((String)payloadData.get('firstname'),(String)payloadData.get('lastname'),(String) payloadData.get('email'),(String) payloadData.get('salutation'),(String) payloadData.get('phone'));
            
            refralCode=newReferalCode.Name;
            personAccount.Inviter_Code__pc=newReferalCode.Name;
            personAccount.Inviter_Code_T_C_Date__pc=DateTime.now();
            newReferalCode.Account_Id__c=personAccount.Id;
            newReferalCode.Used__c=true;
            
            
            //attach person account to business account
            if(businessAccount!=null) attachPersonToBusiness(businessAccount.id,personAccount.Id);
            
            update personAccount;
            update newReferalCode;
            
            //account to whihc email is sent
            accountDetails=personAccount;
        }
        else{
            //get exsisting business details
            Account businessAccount=getBusinessDetails((String)payloadData.get('companyId'),(String) payloadData.get('bankIban'));
            //get exsisting personAccount
            Account busineePersonAccount=getPersonDetails((String)payloadData.get('email'));
            //get business account referal code
            String exsistingBusinessReferalCode=checkRefealCode(businessAccount,createPersonAccount);
            //code already assigned stop execution
            if(exsistingBusinessReferalCode!=null){
                refralCode = exsistingBusinessReferalCode;
                //create new user if not present
                if(busineePersonAccount == null) busineePersonAccount= createPersonAccount((String)payloadData.get('firstname'),(String)payloadData.get('lastname'),(String)payloadData.get('email'),(String)payloadData.get('salutation'),(String)payloadData.get('phone'));
                   
                //update code used by person account
                busineePersonAccount.Invitation_Code__pc=businessAccount.Inviter_Code__c;
                if(businessAccount.Business_Bank__c!=null) businessAccount.Business_Bank__c=(String) payloadData.get('bankName');
                if(businessAccount.Business_IBAN__c!=null) businessAccount.Business_IBAN__c=(String) payloadData.get('bankIban');
                businessAccount.AccountSource='Intranet Website';
                businessAccount.Account_Source_Detail__c='Referral Code Website';
                update busineePersonAccount;
                
                //attach person account to business account
                attachPersonToBusiness(businessAccount.id,busineePersonAccount.Id);
                //send email
                sendReferalCodeEmail(busineePersonAccount.Id,(Boolean)payloadData.get('isExsistingCustomer'),(Boolean)payloadData.get('isPersonAccount'));
                updateAccountOrigin(busineePersonAccount);
                return refralCode;
            }
            
            
            
            
            //get new code
            if(exsistingBusinessReferalCode==null) newReferalCode=getNewRefralCode();  
            
            //all codes exausted stop
            if(newReferalCode==null) return null;
            
            // creating business account
            if(businessAccount==null) businessAccount=createBusinessAccount((String)payloadData.get('accountName'),(String) payloadData.get('bankName'),(String) payloadData.get('bankIban'));
            refralCode=newReferalCode.Name;
            businessAccount.Inviter_Code__c=newReferalCode.Name;
            businessAccount.Inviter_Code_T_C_Date__c=DateTime.now();
            //update business account with bank details
            if(businessAccount.Business_Bank__c!=null) businessAccount.Business_Bank__c=(String) payloadData.get('bankName');
            if(businessAccount.Business_IBAN__c!=null) businessAccount.Business_IBAN__c=(String) payloadData.get('bankIban');
              
            newReferalCode.Account_Id__c=businessAccount.Id;
            newReferalCode.Used__c=true;
            
            update businessAccount;
            update newReferalCode;
            
            
            
            //creating person account
            if(busineePersonAccount==null) 
            {
                busineePersonAccount= createPersonAccount((String)payloadData.get('firstname'),(String)payloadData.get('lastname'),(String)payloadData.get('email'),(String)payloadData.get('salutation'),(String)payloadData.get('phone'));
                busineePersonAccount.Invitation_Code__pc=businessAccount.Inviter_Code__c;
                update busineePersonAccount;
            }
            attachPersonToBusiness(businessAccount.id,busineePersonAccount.Id);
            updateAccountOrigin(busineePersonAccount);
             
            //account to whihc email is sent
            accountDetails=busineePersonAccount; 
             
        }
        
        if(refralCode!=null) sendReferalCodeEmail(accountDetails.Id,(Boolean)payloadData.get('isExsistingCustomer'),(Boolean)payloadData.get('isPersonAccount'));
        return refralCode;
    }
    
     
    
    //retrive person details
    private static Account getPersonDetails(String email){
        List<Account> accountDetails=[SELECT Id,Origin__pc ,Gender__pc,Invitation_Code__pc,Inviter_Code_T_C_Date__pc,Type,Phone,Salutation,PersonEmail,LastName,FirstName,Inviter_Code__pc FROM Account WHERE personEmail=:email AND isPersonAccount=true];
		if(accountDetails.size()>0) return accountDetails.get(0);
        return null;
    }
	//retrive businees account    
    private static Account getBusinessDetails(String sfId,String iban){
        if(iban!=null) iban=iban.replaceAll(' ','');
        String businessAccountRecordTypeId=Constant.ACCOUNT_BUSINESS_ACCOUNT_RECORDTYPEID;
        String query='SELECT Id,Name,Inviter_Code__c,Inviter_Code_T_C_Date__c,Business_Bank__c,Business_IBAN__c FROM Account WHERE (Id=:sfId OR Business_IBAN__c=:iban)  AND RecordTypeId=:businessAccountRecordTypeId';
        if(iban==null || String.isEmpty(iban)) query='SELECT Id,Name,Inviter_Code__c,Inviter_Code_T_C_Date__c,Business_Bank__c,Business_IBAN__c FROM Account WHERE Id=:sfId  AND RecordTypeId=:businessAccountRecordTypeId'; 
        List<Account> busineesAccountList=Database.query(query);
        if(busineesAccountList.size()>0) return busineesAccountList.get(0);
        return null;
    }
	//create business acount    
    private static Account createBusinessAccount(String accountName,String bankName,String customerIban){
        Account businessAccount=new Account();
        businessAccount.Name=accountName;
        if(bankName!=null && String.isNotBlank(bankName)) businessAccount.Business_Bank__c=bankName;
        if(customerIban!=null && String.isNotBlank(customerIban))businessAccount.Business_IBAN__c=customerIban.replaceAll(' ','');
        businessAccount.Type='E&V Licensed Partner';
        businessAccount.AccountSource='Intranet Website';
        businessAccount.Account_Source_Detail__c='Referral Code Website';
        businessAccount.RecordTypeId=Constant.ACCOUNT_BUSINESS_ACCOUNT_RECORDTYPEID;
        insert businessAccount;
        return businessAccount;
    }
    //create person account
    private static Account createPersonAccount(String firstName,String lastName,String email,String salutation,String phone){
        Account personAccountAccount=new Account();
        personAccountAccount.FirstName=firstName;
        personAccountAccount.LastName=lastName;
        personAccountAccount.PersonEmail=email;
        if(salutation!=null && String.isNotBlank(salutation))personAccountAccount.Salutation=salutation;
        if(String.isNotEmpty(salutation?.trim()) && salutation.contains('Herr')) personAccountAccount.Gender__pc='Male';
        else if(String.isNotEmpty(salutation?.trim()) && salutation.contains('Frau')) personAccountAccount.Gender__pc='Female';
        if(phone!=null && String.isNotBlank(phone))personAccountAccount.Phone=phone;
        personAccountAccount.RecordTypeId=Constant.PERSON_PARTNER_ACCOUNT_RECORDTYPEID;
        personAccountAccount.Type='E&V Broker';
        personAccountAccount.AccountSource='Intranet Website';
        personAccountAccount.Account_Source_Detail__c='E&V Brokers';
        personAccountAccount.Origin__pc='Referral Code Website';
        personAccountAccount.Inviter_Code__pc='';
        insert personAccountAccount;
        return personAccountAccount;
    }
    //checkReferalCode Code
    private static String  checkRefealCode(Account accoutnDetails,Boolean isPersonAccount){
        if(isPersonAccount && accoutnDetails!=null && accoutnDetails.Inviter_Code__pc!=null && String.isNotBlank(accoutnDetails.Inviter_Code__pc)) return accoutnDetails.Inviter_Code__pc;
        else if(!isPersonAccount && accoutnDetails!=null && accoutnDetails.Inviter_Code__c!=null && String.isNotBlank(accoutnDetails.Inviter_Code__c)) return accoutnDetails.Inviter_Code__c;
        return null;
    }
    //get new referal code
    private static Referral_Codes__c getNewRefralCode(){
        List<Referral_Codes__c> newCode=[SELECT Used__c, Account_Id__c, Name, Id FROM Referral_Codes__c WHERE Used__c=false];
        if(newCode.size()>0) return newCode.get(0);
        return null;
    }
    //attach contact to account 
    private static void attachPersonToBusiness(String bussinessId,String personId){
        //try catch to ignor duplciates
        try{
            String personContactId=[SELECT id FROM Contact WHERE AccountId=:personId AND IsPersonAccount=true].Id;
            //attach business account and person account
            AccountContactRelation linkAccountToBusiness=new AccountContactRelation();
            linkAccountToBusiness.AccountId=bussinessId;
            linkAccountToBusiness.ContactId=personContactId;
            linkAccountToBusiness.Roles ='Business User';
            insert linkAccountToBusiness;
        }catch(Exception e){}
    }
    //update origin 
    private static void updateAccountOrigin(Account personAccount){
        Boolean updateSource=false;
        if(personAccount.Origin__pc!=null && !personAccount.Origin__pc.contains('Referral Code Website')){
            personAccount.Origin__pc+=';Referral Code Website';
            updateSource=true;
        }
        else if(personAccount.Origin__pc==null){
            personAccount.Origin__pc='Referral Code Website';
            updateSource=true;
        }
        if(updateSource) update personAccount;
    }
    @future
    private static void sendReferalCodeEmail(String accountId,Boolean isExsistingCustomer,Boolean isPersonAccount){
        
        List<Contact> personContact=[SELECT id,Account.PersonEmail,AccountId FROM Contact WHERE isPersonAccount=true AND AccountId=:accountId ];
        if(personContact.size()==0) return;
        String emailTempalteId=(isExsistingCustomer)?Constant.ACCOUNT_REFREAL_EXSISTING_USER_EMAILTEMPLATE:Constant.ACCOUNT_REFREAL_NEW_USER_EMAILTEMPLATE;
        if(!isPersonAccount)emailTempalteId=Constant.ACCOUNT_REFREAL_BUSINESSE_USER_EMAILTEMPLATE;
        MailUtill.sendTemplateEmail(personContact.get(0).Account.personEmail,personContact.get(0).Id,personContact.get(0).AccountId,emailTempalteId,Constant.EV_SUPPORT_OWD_EMAIL);
    }
    
    
}