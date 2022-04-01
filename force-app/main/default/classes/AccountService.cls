public with Sharing class AccountService {
    
    @AuraEnabled
    public static List<Account> getRecordDetails(String recordId){
        return [SELECT id,Preferred_Language__pc FROM Account WHERE id=:recordId];
    }
    
    @AuraEnabled
    public static String createNewIdentification(String recordId,String languageCode){
        
         List<Account> accountDetailList= [SELECT Id, Name, Solarisbank_Id__c,Solarisbank_Tenent__c
                                          FROM Account
                                          WHERE id=:recordId];
        if(accountDetailList.size()==0) return null;
        Account accountDetals=accountDetailList.get(0);
        LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(recordId,'Account',accountDetals.Solarisbank_Tenent__c);
        String requestBody='{"method": "idnow","language": "'+languageCode+'"}';
        String res=SolarisbankService.createNewIdentificationAttempt(accountDetals.Solarisbank_Id__c,requestBody,apiCallDetails);
        SolarisBankIdentificationWrapper response=SolarisBankIdentificationWrapper.parse(res);
        if(String.isNotEmpty(response.id)){
            LogService.ApiCallDetails apiCallDetailsForIdent =  new LogService.ApiCallDetails(recordId,'Account',accountDetals.Solarisbank_Tenent__c);
            String responseString=SolarisbankService.fetchIdentificationRequestDetails(accountDetals.Solarisbank_Id__c,response.id,apiCallDetailsForIdent);
            SolarisBankIdentificationWrapper identResponse=SolarisBankIdentificationWrapper.parse(responseString);
            
            KYC_Detail__c newIdentification=new KYC_Detail__c();
            newIdentification.Solarisbank_Id__c=identResponse.id;      
            newIdentification.Method__c='IDnow';
            newIdentification.Account__c=accountDetals.id;
            newIdentification.RecordTypeId=Constant.KYC_VIDEO_IDENTIFICATION_RECORDTYPEID;
            if(String.isNotEmpty(identResponse.url)) newIdentification.URL__c=identResponse.url;
            if(String.isNotEmpty(identResponse.reference)) newIdentification.Reference__c=identResponse.reference;
            insert newIdentification; 
        }
        
        return String.isNotEmpty(response.id)?response.id:response.failure_reason;
        
    } 
    
    @AuraEnabled
    public static void syncPersonDetailsWithSB(String sfAccountId){
        Account sfAccount=[SELECT Id,LastName,Salutation,Gender__pc,FirstName,Solarisbank_Tenent__c,Solarisbank_Id__c,
                           PersonTitle,PersonEmail,PersonMobilePhone,PersonBirthdate,
                           ShippingState,ShippingCountry,ShippingCity,ShippingPostalCode,ShippingStreet,BillingState,BillingStreet,BillingPostalCode,BillingCity,BillingCountry,
                           (SELECT Id, 
                            Name,Email__c,Term_Deposit_Enabled_At__c,Solarisbank_Id__c,Is_Term_Deposit_Enabled__c ,
                            Account__c , Phone__c, Industry_Key__c, Title__c, Salutation__c, First_Name__c, Postal_Code__c, Street__c, Birth_Name__c, Birth_Date__c, Last_Name__c, 
                            Birth_City__c, Job_Title__c, Fatca_Relevant__c, Fatca_Crs_Confirmed_at__c, Business_Purpose__c, Terms_conditions_Signed_At__c,
                            Own_Economic_Interest_Signed_At__c, Aml_Follow_Up_Date__c, Aml_Confirmed_On__c, Flagged_By_Compliance__c, Vat_Number__c, Nace_Code__c,
                            Business_Street__c, Business_Postal_Code__c, Country__c, City__c, State__c, Nationality__c, Birth_Country__c, Employment_Status__c, Tax_Assessment__c,
                            Marital_Status__c, Industry__c, Business_City__c, Business_Country__c, Screening_Progress__c, Risk_Classification_Status__c, Customer_Vetting_Status__c 
                            
                            FROM Banks__r WHERE  RecordTypeId=:Constant.BANK_SOLARISBANK_RECORDTYPEID) 
                           FROM Account WHERE id=:sfAccountId LIMIT 1];
    
        
        LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(sfAccount.Id,'Account',sfAccount.Solarisbank_Tenent__c);
        //checking if solaribank id exsisitngs
        if(String.isNotEmpty(sfAccount.Solarisbank_Id__c)){
            Bank__c sbBankDetails=new Bank__c();
            if(sfAccount.Banks__r.size()>0) sbBankDetails=sfAccount.Banks__r.get(0);
            if(sbBankDetails.Account__c==null) {
                sbBankDetails.Account__c=sfAccount.id;
                sbBankDetails.RecordTypeId=Constant.BANK_SOLARISBANK_RECORDTYPEID;
                sbBankDetails.Solarisbank_Id__c=sfAccount.Solarisbank_Id__c;
            }
            //fetching person account details
            String personJson=SolarisbankService.fetchPersonDetails(sfAccount.Solarisbank_Id__c,apiCallDetails);
            SolarisbankPersonWrapper personDetails=SolarisbankPersonWrapper.parse(personJson);
            if(personDetails.last_name == null) return ;
            
            //operation
            if(sfAccount.Salutation==null || sfAccount.Salutation!=personDetails.salutation)sfAccount.Salutation = personDetails.salutation;
            sfAccount.Gender__pc=(personDetails.salutation=='MR')?'Male':'Female';
            if(sfAccount.FirstName==null)sfAccount.FirstName = personDetails.first_name;
            if( sfAccount.PersonTitle != personDetails.title) sfAccount.PersonTitle = personDetails.title;
            if(sfAccount.LastName==null)sfAccount.LastName = personDetails.last_name;
         
            if(personDetails.address != null && sfAccount.BillingStreet !=  personDetails.address.line_1)  sfAccount.BillingStreet =  personDetails.address.line_1;
            if(personDetails.address != null && sfAccount.BillingPostalCode != personDetails.address.postal_code) sfAccount.BillingPostalCode = personDetails.address.postal_code;
            if(personDetails.address != null && sfAccount.BillingCity != personDetails.address.city) sfAccount.BillingCity = personDetails.address.city;
            if(personDetails.address != null && sfAccount.BillingCountry !=  personDetails.address.country) sfAccount.BillingCountry =  personDetails.address.country;
            if(personDetails.address != null && sfAccount.BillingState !=  personDetails.address.state) sfAccount.BillingState =  personDetails.address.state;
            if(personDetails.contact_address != null && sfAccount.ShippingStreet !=  personDetails.contact_address.line_1) sfAccount.ShippingStreet =  personDetails.contact_address.line_1;
            if(personDetails.contact_address != null && sfAccount.ShippingPostalCode != personDetails.contact_address.postal_code) sfAccount.ShippingPostalCode = personDetails.contact_address.postal_code;
            if(personDetails.contact_address != null && sfAccount.ShippingCity != personDetails.contact_address.city) sfAccount.ShippingCity = personDetails.contact_address.city;
            if(personDetails.contact_address != null && sfAccount.ShippingCountry !=  personDetails.contact_address.country) sfAccount.ShippingCountry =  personDetails.contact_address.country;
            if(personDetails.contact_address != null && sfAccount.ShippingState !=  personDetails.contact_address.state) sfAccount.ShippingState =  personDetails.contact_address.state;
            
            if(personDetails.email != null && sfAccount.PersonEmail !=  personDetails.email)sfAccount.PersonEmail=personDetails.email;
            if(personDetails.mobile_number!=null && sfAccount.PersonMobilePhone  != personDetails.mobile_number) sfAccount.PersonMobilePhone  = personDetails.mobile_number;
             
            if(personDetails.mobile_number!=null && sbBankDetails.Phone__c==null)  sbBankDetails.Phone__c  = personDetails.mobile_number;
            if(personDetails.birth_date!=null ) sbBankDetails.Birth_Date__c = Date.valueOf(personDetails.birth_date);
            sbBankDetails.First_Name__c = personDetails.first_name;
            sbBankDetails.Last_Name__c = personDetails.last_name;
            sbBankDetails.Birth_Name__c= personDetails.birth_name;
            sbBankDetails.Birth_City__c=personDetails.birth_city;
            sbBankDetails.Birth_Country__c =personDetails.birth_country;
            sbBankDetails.Employment_Status__c = personDetails.employment_status;
            if(personDetails.tax_information!=null) sbBankDetails.Tax_Assessment__c= personDetails.tax_information.tax_assessment;
            if(personDetails.tax_information!=null) sbBankDetails.Marital_Status__c=  personDetails.tax_information.marital_status;
            if(personDetails.fatca_relevant!=null) sbBankDetails.Fatca_Relevant__c =personDetails.fatca_relevant;
            if(String.isNotBlank(personDetails.fatca_crs_confirmed_at)) sbBankDetails.Fatca_Crs_Confirmed_At__c=  Date.valueOf(personDetails.fatca_crs_confirmed_at.replace('T',' '));
            sbBankDetails.Business_Purpose__c = personDetails.business_purpose;
            sbBankDetails.Industry__c = personDetails.industry;
            sbBankDetails.Industry_Key__c = personDetails.industry_key;
            if(personDetails?.terms_conditions_signed_at!=null) sbBankDetails.Terms_conditions_Signed_At__c =DateTime.valueOf(personDetails.terms_conditions_signed_at.replace('T',' '));
            if(personDetails?.flagged_by_compliance!=null)sbBankDetails.Flagged_By_Compliance__c =personDetails.flagged_by_compliance;
            if(personDetails?.own_economic_interest_signed_at!=null) sbBankDetails.Own_Economic_Interest_Signed_At__c  =DateTime.valueOf(personDetails.own_economic_interest_signed_at.replace('T',' '));
            if(personDetails.salutation==null)sbBankDetails.Salutation__c = personDetails.salutation;
            if(personDetails.email==null && sbBankDetails.Email__c==null) sbBankDetails.Email__c=personDetails.email;
            if(personDetails.title!=null) sbBankDetails.Title__c = personDetails.title;
            sbBankDetails.Nationality__c  = personDetails.nationality;
            if(personDetails.address != null)  sbBankDetails.Street__c =  personDetails.address.line_1 + personDetails.address.line_2;
            if(personDetails.address != null) sbBankDetails.Postal_Code__c = personDetails.address.postal_code;
            if(personDetails.address != null) sbBankDetails.City__c = personDetails.address.city;
            if(personDetails.address != null) sbBankDetails.Country__c =  personDetails.address.country;
            if(personDetails.address != null) sbBankDetails.State__c =  personDetails.address.state;
            if(personDetails.job_title != null) sbBankDetails.Job_Title__c =  personDetails.job_title;
            if(personDetails.aml_follow_up_date != null) sbBankDetails.Aml_Follow_Up_Date__c =  Date.valueOf(personDetails.aml_follow_up_date);
            if(personDetails.aml_confirmed_on != null) sbBankDetails.Aml_Confirmed_On__c =  Date.valueOf(personDetails.aml_confirmed_on);
            if(personDetails.vat_number != null) sbBankDetails.Vat_Number__c =  personDetails.vat_number;
            if(personDetails.nace_code != null) sbBankDetails.Nace_Code__c =  personDetails.nace_code;
            if(personDetails.customer_vetting_status != null) sbBankDetails.Customer_Vetting_Status__c =  personDetails.customer_vetting_status;
            if(personDetails.risk_classification_status != null) sbBankDetails.Risk_Classification_Status__c =  personDetails.risk_classification_status;
            if(personDetails.business_address_line_1 != null) sbBankDetails.Business_Street__c =  personDetails.business_address_line_1+personDetails.business_address_line_2;
            if(personDetails.business_postal_code != null) sbBankDetails.Business_Postal_Code__c =  personDetails.business_postal_code;
            if(personDetails.business_city != null) sbBankDetails.Business_City__c =  personDetails.business_city;
            if(personDetails.business_country != null) sbBankDetails.Business_Country__c =  personDetails.business_country;
            
            update sfAccount;
            
            upsert sbBankDetails;
        }
        
    }
    
    public static void createAccountAndNewsletter(String email,String subProductName,String origin,String website,String accountRecordTypeId){
        List<Account> accountDetails=[SELECT id,Origin__pc,(Select id,Source__c,Type__c,Subscription_Status__c from Subscriptions__r WHERE Type__c=:subProductName AND RecordTypeId=:Constant.SUBSCRIPTION_DEFAULT_RECORDTYPEID LIMIT 1) 
                                      FROM Account WHERE PersonEmail=:email AND isPersonAccount=true];
        //exsisitng account
        if(accountDetails.size()>0){
            
            Account accDetails=accountDetails.get(0);
            if(accDetails.Origin__pc!=null)accDetails.Origin__pc+=';'+origin;
            else accDetails.Origin__pc=origin;
            update accDetails;
            
            
            //already subscribed
            if(accountDetails.get(0).Subscriptions__r.size()>0){
                
                Subscription__c subscriptionProduct=accountDetails.get(0).Subscriptions__r.get(0);
                //if subscribed not sending mail
                if(subscriptionProduct.Subscription_Status__c=='Subscribed'){}
                else{
                    subscriptionProduct.Subscription_Status__c='Awaiting Confirmation';   
                    subscriptionProduct.Send_Mail__c=true;
                    update subscriptionProduct;
                }
                
                
            }
            //new subscription
            else{
                List<Contact> c=[SELECT id,LastName FROM Contact WHERE  AccountId=:accountDetails.get(0).Id AND Account.ispersonaccount=true];
                Subscription__c newSubscriptionProduct=new Subscription__c();
                newSubscriptionProduct.Subscription_Status__c='Awaiting Confirmation';
                newSubscriptionProduct.Type__c=subProductName;
                newSubscriptionProduct.Account__c=accountDetails.get(0).Id;
                newSubscriptionProduct.Source__c=website;
                newSubscriptionProduct.Send_Mail__c=true;
                newSubscriptionProduct.recordTypeId=Constant.SUBSCRIPTION_DEFAULT_RECORDTYPEID;
                newSubscriptionProduct.Contact__c=(c.size()>0)?c.get(0).Id:'';
                insert newSubscriptionProduct;
            }
            
            
        }
        //new account
        else{
            Account accountLead=new Account();
            accountLead.PersonEmail = email;
            accountLead.LastName = '[Not Provided]';
            accountLead.Type ='Prospect';
            accountLead.AccountSource='Website';
            accountLead.RecordTypeId=accountRecordTypeId;
            accountLead.Origin__pc=origin;
            insert accountLead;
            List<Contact> c=[SELECT id,LastName FROM Contact WHERE AccountId=:accountLead.Id AND Account.ispersonaccount=true];
            Subscription__c newSubscriptionProduct=new Subscription__c();
            newSubscriptionProduct.Subscription_Status__c='Awaiting Confirmation';
            newSubscriptionProduct.Type__c=subProductName;
            newSubscriptionProduct.Source__c=website;
            newSubscriptionProduct.Account__c=accountLead.Id;
            newSubscriptionProduct.Contact__c=(c.size()>0)?c.get(0).Id:'';
            newSubscriptionProduct.Send_Mail__c=true;
            insert newSubscriptionProduct;
        }
    }
}