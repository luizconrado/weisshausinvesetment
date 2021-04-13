public with Sharing class AccountService {
    
    
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
            
            Identification__c newIdentification=new Identification__c();
            newIdentification.Solarisbank_Id__c=identResponse.id;      
            newIdentification.Method__c='IDnow';
            newIdentification.Account__c=accountDetals.id;
            newIdentification.RecordTypeId=Constant.IDENTIFIACTION_VIDEO_IDENTIFICATION_RECORDTYPEID;
            if(String.isNotEmpty(identResponse.url)) newIdentification.URL__c=identResponse.url;
            if(String.isNotEmpty(identResponse.reference)) newIdentification.Reference__c=identResponse.reference;
            insert newIdentification; 
        }
        
        return String.isNotEmpty(response.id)?response.id:response.failure_reason;
        
    } 
    
    @AuraEnabled
    public static void syncPersonDetailsWithSB(String sfAccountId){
        Account sfAccount=[SELECT Id,LastName,Salutation,Gender__pc,FirstName,Legal_Name__c,
                           Own_Economic_Interest_Signed_At__c,Flagged_By_Compliance__c,
                           Terms_Conditions_Signed_At__c,Industry_Key__c,Industry,Solarisbank_Tenent__c,Solarisbank_Id__c,
                           Business_Purpose__c,Fatca_Crs_Confirmed_At__c,Fatca_Relevant__c,Marital_Status__c,Tax_Assessment__c,PersonTitle,Birth_Country__c,Nationality__c,Employment_Status__c,
                           PersonEmail,PersonMobilePhone,PersonBirthdate,Birth_Name__c,Birth_City__c,
                           ShippingState,ShippingCountry,ShippingCity,ShippingPostalCode,ShippingStreet,BillingState,BillingStreet,BillingPostalCode,BillingCity,BillingCountry
                           FROM Account WHERE id=:sfAccountId LIMIT 1];
        LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(sfAccount.Id,'Account',sfAccount.Solarisbank_Tenent__c);
        //checking if solaribank id exsisitngs
        if(String.isNotEmpty(sfAccount.Solarisbank_Id__c)){
            //fetching person account details
            String personJson=SolarisbankService.fetchPersonDetails(sfAccount.Solarisbank_Id__c,apiCallDetails);
            SolarisbankPersonWrapper personDetails=SolarisbankPersonWrapper.parse(personJson);
            if(personDetails.last_name == null) return ;
            //fetching phone number
            String phoneJson=SolarisbankService.fetchPersonPhoneNumber(sfAccount.Solarisbank_Id__c,apiCallDetails);
            Map<String,Object> phoneJsonMap=(Map<String,Object>) JSON.deserializeUntyped(phoneJson);
            //operation
            if(sfAccount.Salutation==null || sfAccount.Salutation!=personDetails.salutation)sfAccount.Salutation = personDetails.salutation;
            sfAccount.Gender__pc=(personDetails.salutation=='MR')?'Male':'Female';
            if(sfAccount.FirstName==null)sfAccount.FirstName = personDetails.first_name;
            
            if(sfAccount.LastName==null)sfAccount.LastName = personDetails.last_name;
            sfAccount.Legal_Name__c = personDetails.first_name+' '+ personDetails.last_name;
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
            if(phoneJsonMap.containsKey('number'))  sfAccount.Phone=(String)phoneJsonMap.get('number'); 
             if(personDetails.birth_name!=null && sfAccount.Birth_Name__c  != personDetails.birth_name) sfAccount.Birth_Name__c= personDetails.birth_name;
            if(personDetails.birth_city!=null && sfAccount.Birth_City__c  != personDetails.birth_city) sfAccount.Birth_City__c=personDetails.birth_city;
            if(personDetails.birth_country!=null && sfAccount.Birth_Country__c  != personDetails.birth_country) sfAccount.Birth_Country__c =personDetails.birth_country;
            if(personDetails.nationality!=null && sfAccount.Nationality__c  != personDetails.nationality)sfAccount.Nationality__c  = personDetails.nationality;
            if(personDetails.employment_status!=null && sfAccount.Employment_Status__c  != personDetails.employment_status)sfAccount.Employment_Status__c = personDetails.employment_status;
            if(personDetails.title!=null && sfAccount.PersonTitle != personDetails.title) sfAccount.PersonTitle = personDetails.title;
            if(personDetails.tax_information!=null && sfAccount.Tax_Assessment__c!= personDetails.tax_information.tax_assessment) sfAccount.Tax_Assessment__c= personDetails.tax_information.tax_assessment;
            if(personDetails.tax_information!=null && sfAccount.Marital_Status__c!=  personDetails.tax_information.marital_status) sfAccount.Marital_Status__c=  personDetails.tax_information.marital_status;
            if(personDetails.fatca_relevant!=null && sfAccount.Fatca_Relevant__c !=personDetails.fatca_relevant) sfAccount.Fatca_Relevant__c =personDetails.fatca_relevant;
             if(personDetails.business_purpose!=null && sfAccount.Business_Purpose__c !=personDetails.business_purpose)sfAccount.Business_Purpose__c = personDetails.business_purpose;
            if(personDetails.industry!=null && sfAccount.Industry !=personDetails.industry)sfAccount.Industry = personDetails.industry;
            if(personDetails.industry_key!=null && sfAccount.Industry_Key__c !=personDetails.industry_key)sfAccount.Industry_Key__c = personDetails.industry_key;
             if(personDetails.flagged_by_compliance!=null)sfAccount.Flagged_By_Compliance__c =personDetails.flagged_by_compliance;
             update sfAccount;
        }
        
    }
}