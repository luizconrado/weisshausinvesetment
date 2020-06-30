public without sharing class LeadService {

    private static Map<String, String> getProductMetaDataConfiguration() {
        Map<String, String> productCodeAPIMap = new Map<String, String>();
        List<Subscription_Product_Configuration__mdt> productConfigList = [SELECT Id, Label, Field_API__c FROM Subscription_Product_Configuration__mdt];
        for (Subscription_Product_Configuration__mdt productConfigRec : productConfigList) {
            productCodeAPIMap.put(productConfigRec.Label, productConfigRec.Field_API__c);
        }
        return productCodeAPIMap;
    }
    //Rest api
    /*
     * Description: called from webhook to check and update exsisting lead and accounts
	*/
    public static Lead leadDupeMerge(Lead ldRec) {
        Map<String, String> productCodeAPIMap = getProductMetaDataConfiguration();
        if(!productCodeAPIMap.containsKey(ldRec.ProductInterest__c)) return ldRec;
        String email=ldRec.Email;
        String leadQuery = 'SELECT Id,Phone ,LastName, FirstName, MiddleName, Suffix ,Lead_Origin__c,Email,Gender__c,Accepted_Terms_and_Conditions__c,Newsletter__c,Product_A__c,Product_B__c,Product_C__c,Product_D__c,ProductInterest__c FROM Lead WHERE Email =:email  AND IsConverted = false';
        String accountQuery = 'SELECT Id,Phone ,LastName, FirstName, MiddleName, Suffix ,PersonEmail,Gender__pc,Accepted_Terms_and_Conditions__pc,Newsletter__pc,Product_D__pc,Product_C__pc,Product_A__pc,Product_B__pc,ProductInterest__pc FROM Account WHERE PersonEmail =:email';
        List<Lead> existingLeads = Database.query(leadQuery);
        List<Account> existingAccounts = Database.query(accountQuery);

       
        //updataing lead
        if(existingLeads.size()>0){
            Lead leadMaster=existingLeads.get(0);
            //merging lead origin
            if(ldRec.Lead_Origin__c!=null && leadMaster.Lead_Origin__c!=null && !leadMaster.Lead_Origin__c.contains(ldRec.Lead_Origin__c))
                leadMaster.Lead_Origin__c = (leadMaster.Lead_Origin__c !=null)?leadMaster.Lead_Origin__c +';'+ldRec.Lead_Origin__c:ldRec.Lead_Origin__c;
            
            
            //update product status 
            if (leadMaster.get(productCodeAPIMap.get(ldRec.ProductInterest__c)) == null 
                || leadMaster.get(productCodeAPIMap.get(ldRec.ProductInterest__c)) == 'Not Subscribed'
                || leadMaster.get(productCodeAPIMap.get(ldRec.ProductInterest__c)) == 'Unsubscribed') { 
                    leadMaster.put(productCodeAPIMap.get(ldRec.ProductInterest__c), 'Awaiting Confirmation');
                }
            else if (leadMaster.get(productCodeAPIMap.get(ldRec.ProductInterest__c)) == 'Awaiting Confirmation') {
                leadMaster.put(productCodeAPIMap.get(ldRec.ProductInterest__c), 'Resend Confirmation');
            }
            //updating latest product intrest
            leadMaster.put('ProductInterest__c', ldRec.ProductInterest__c);
            ldRec=leadMaster;
        }
        else{
            //updatating product status for new lead
            if (ldRec.get(productCodeAPIMap.get(ldRec.ProductInterest__c)) == null 
                || ldRec.get(productCodeAPIMap.get(ldRec.ProductInterest__c)) == 'Not Subscribed' || ldRec.get(productCodeAPIMap.get(ldRec.ProductInterest__c)) == 'Unsubscribed') 
                ldRec.put(productCodeAPIMap.get(ldRec.ProductInterest__c), 'Awaiting Confirmation');
            else if (ldRec.get(productCodeAPIMap.get(ldRec.ProductInterest__c)) == 'Awaiting Confirmation')
                ldRec.put(productCodeAPIMap.get(ldRec.ProductInterest__c), 'Resend Confirmation');
        }
        //updataing account
        if(existingAccounts.size()>0){
            Account accountMaster=existingAccounts.get(0);
            String fieldApi=productCodeAPIMap.get(ldRec.ProductInterest__c).replace('__c','__pc');
            //updataing product status on person account account 
            if (accountMaster.get(fieldApi) == null || accountMaster.get(fieldApi) == 'Not Subscribed' || accountMaster.get(fieldApi) == 'Unsubscribed') {
                accountMaster.put(fieldApi, 'Awaiting Confirmation');
            } else if (accountMaster.get(fieldApi) == 'Awaiting Confirmation') {
                accountMaster.put(fieldApi, 'Resend Confirmation');
            }
            accountMaster.put('ProductInterest__pc', ldRec.ProductInterest__c);
            if(existingLeads.size()==0){
                //copying exsisting data from person account
                ldRec.Accepted_Terms_and_Conditions__c=accountMaster.Accepted_Terms_and_Conditions__pc;
                ldRec.Gender__c=accountMaster.Gender__pc;
                if(productCodeAPIMap.get(ldRec.ProductInterest__c)!='Newsletter__c')ldRec.Newsletter__c=accountMaster.Newsletter__pc;
             	if(productCodeAPIMap.get(ldRec.ProductInterest__c)!='Product_A__c')ldRec.Product_A__c=accountMaster.Product_A__pc;
                if(productCodeAPIMap.get(ldRec.ProductInterest__c)!='Product_B__c')ldRec.Product_B__c=accountMaster.Product_B__pc;
                if(productCodeAPIMap.get(ldRec.ProductInterest__c)!='Product_C__c')ldRec.Product_C__c=accountMaster.Product_C__pc;
                if(productCodeAPIMap.get(ldRec.ProductInterest__c)!='Product_D__c')ldRec.Product_D__c=accountMaster.Product_D__pc;
                ldRec.Phone=accountMaster.Phone;
                ldRec.FirstName=accountMaster.FirstName;
                ldRec.MiddleName=accountMaster.MiddleName;
                ldRec.LastName=accountMaster.LastName;
                ldRec.Suffix=accountMaster.Suffix;
            
            }
            
            update accountMaster;
        }
        
        
        return ldRec;
         
    }

    //LC Button
    /*
     * Description: converts lead to exsisting person account. If no account is present creates new
	*/
    @AuraEnabled
    public static String convertLeadToPersonAccount(String leadId,String leadEmail){
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        List<Account> personAccount=[SELECT Id FROM Account WHERE PersonEmail =:leadEmail];
        
        Id personAccountRecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        Database.LeadConvert lc = new database.LeadConvert();
        if(personAccount.size()>0) lc.setAccountId(personAccount.get(0).Id);
       
        lc.setLeadId(leadId);
        lc.setDoNotCreateOpportunity(True);
        lc.setOwnerId(Userinfo.getUserId());
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        return lcr.getAccountId();
       
    }
    

    //LWC Component
    @AuraEnabled
    public static Boolean updateLeadWithConfirmation(String email, String product, String salutation, String lastName, String firstName, Boolean termsAndConditions, String phoneNumber, String leadId) {

        Boolean showForm = true;
        if (checkProductConfiguration(product, email)) {
            showForm = updateLead(email, product, salutation, lastName, firstName, termsAndConditions, phoneNumber,leadId);
        }
        return showForm;
    }

    /*
     * Description: on load of unsubscribe page product is updateted to unsubscribe
	*/
    @AuraEnabled
    public static Boolean updateLeadToUnSubscribed(String email,String product,String reason){
        Map<String, String> productCodeAPIMap = getProductMetaDataConfiguration();
        if(!productCodeAPIMap.containsKey(product)) return true;
        String leadQuery = 'SELECT Id,Email,' + productCodeAPIMap.get(product) + ' FROM Lead WHERE Email =:email  AND IsConverted = false';
        String accountQuery = 'SELECT Id,PersonEmail,' + productCodeAPIMap.get(product).replace('__c','__pc')  + ' FROM Account WHERE PersonEmail =:email';
        List<Lead> existingLeads = Database.query(leadQuery);
        List<Account> existingAccounts = Database.query(accountQuery);
        List<String> leadAndContactId=new List<String>();
        if(existingLeads.size()>0){
            Lead leadMaster=existingLeads.get(0);
            leadMaster.put(productCodeAPIMap.get(product), 'UnSubscribed');
            leadAndContactId.add(leadMaster.id);
            update leadMaster;
        }
        if(existingAccounts.size()>0){
            Account accountMaster=existingAccounts.get(0);
            accountMaster.put(productCodeAPIMap.get(product).replace('__c','__pc'), 'UnSubscribed');
            List<Contact> personContact=[SELECT id FROM Contact WHERE accountId=:accountMaster.id AND Account.ispersonaccount=true];
            if(personContact.size()>0) leadAndContactId.add(personContact.get(0).Id);
            update accountMaster;
        }
        
        List<CampaignMember> campaignMember=[select id from CampaignMember where Campaign.Products__c=:product AND LeadOrContactId IN:leadAndContactId];
        if(campaignMember.size()>0){
            delete campaignMember;
        }
        return true;
    }
    
    
    /*
     * Description: on load of verification from update terms and condition and subscribe status
	*/
    @AuraEnabled
    public static leadWrapper checkAndUpdateLeadOnload(String email, String product) {
        leadWrapper respWrapper = new leadWrapper();

        Boolean showForm = true;
        if (checkProductConfiguration(product, email)) {
            Map<String, String> productCodeAPIMap = getProductMetaDataConfiguration();
            String fieldToUpdate = productCodeAPIMap.get(product);
            List<Lead> leadList = getLeadList(email, fieldToUpdate,'');
            if (leadList.size() > 0) {
                Lead LeadRec = leadList.get(0);
                if(String.isBlank(LeadRec.Salutation) || String.isBlank(LeadRec.LastName) || String.isBlank(LeadRec.Phone)){
                    showForm = true;
                }else{
                    showForm = false;
                }

                LeadRec.put(productCodeAPIMap.get(product), 'Subscribed');
                LeadRec.Accepted_Terms_and_Conditions__c=true;
                respWrapper.leadId = LeadRec.Id;
                updateLeadDML(LeadRec, showForm);
            }
        }
        respWrapper.showForm = showForm;
        return respWrapper;
    }
    
    private static Boolean checkProductConfiguration(String product, String email) {
        if (product.contains('+'))product = product.replace('+', ' ');
        Map<String, String> productCodeAPIMap = getProductMetaDataConfiguration();
        if (String.isNotBlank(email) && String.isNotBlank(product) && productCodeAPIMap.containsKey(product)) {

            return true;
        }
        return false;
    }

    private static Boolean updateLead(String email, String product, String salutation, String lastName, String firstName, Boolean termsAndConditions, String phoneNumber, String leadId) {
        Map<String, String> productCodeAPIMap = getProductMetaDataConfiguration();
        Boolean showForm = true;
        String fieldToUpdate = productCodeAPIMap.get(product);
        List<Lead> leadList = getLeadList(email, fieldToUpdate,leadId); //Database.query('SELECT Id FROM Lead WHERE Email =:email AND IsConverted = false AND LeadSource = \'Website\' AND ' + fieldToUpdate + ' = \'Awaiting Confirmation\' FOR UPDATE');
        System.debug('leadList ' + leadList);
        if (leadList.size() > 0) {
            Lead LeadRec = leadList.get(0);
            if(salutation!=null || String.isNotEmpty(salutation)){
                LeadRec.Salutation = salutation;
                LeadRec.Gender__c=(salutation.contains('Herr'))?'Male':'Female';
            }
            
            LeadRec.LastName = lastName;
            LeadRec.FirstName = firstName;
            LeadRec.Accepted_Terms_and_Conditions__c = termsAndConditions;
            LeadRec.Phone = phoneNumber;
            LeadRec.put(productCodeAPIMap.get(product), 'Subscribed');

            showForm = updateLeadDML(LeadRec, showForm);
        }
        return showForm;
    }

    private static Boolean updateLeadDML(Lead LeadRec, Boolean showForm) {
        try {
            System.debug('LeadRec ' + LeadRec);
            update LeadRec;
            showForm = false;
        } catch (Exception ex) {
            AuraHandledException e = new AuraHandledException(ex.getMessage());
            e.setMessage(ex.getMessage());
            System.debug('Exception ' + ex.getMessage());
            throw e;
        }
        return showForm;
    }

    private static List<Lead> getLeadList(String email, String fieldToUpdate, String leadId) {
        List<String> queryFieldAPIs = getLeadFieldNames();
        String queryStr = 'SELECT '+String.join(queryFieldAPIs, ',') +' FROM Lead WHERE ';
        if(String.isNotEmpty(leadId)){
            queryStr += 'Id =: leadId';
        }else{
            queryStr += 'Email =:email AND IsConverted = false AND LeadSource = \'Website\' AND ' + fieldToUpdate + ' IN (\'Awaiting Confirmation\',\'Resend Confirmation\',\'Subscribed\') FOR UPDATE';
        }
        List<Lead> leadList = Database.query(queryStr);
        return leadList;
    }

    private static List<String> getLeadFieldNames() {
        Map<String, Schema.SObjectField> fieldMap = Lead.SObjectType.getDescribe().fields.getMap();
        return new List<String>(fieldMap.keySet());
    }
     
    public class leadWrapper{
        @AuraEnabled
        public Boolean showForm;
        @AuraEnabled
        public Id leadId;
    }

}