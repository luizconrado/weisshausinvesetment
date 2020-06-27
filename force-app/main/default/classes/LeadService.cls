public without sharing class LeadService {

    //Trigger
    public static void checkDuplicateAfterInsert(final List<Lead> newLeads) {
        Set<String> emails = new Set<String>();
        Map<String, Lead> masters = new Map<String, Lead>();
        for (Lead ld : newLeads) {
            emails.add(ld.Email);
        }
        emails.remove(null);
        for (Lead ld : [SELECT Email FROM Lead WHERE Email = :emails AND Id NOT IN :newLeads AND IsConverted = FALSE]) {
            masters.put(ld.Email, ld);
        }
        for (Lead ld : newLeads) {
            Lead master = masters.get(ld.Email);
            if (master != null) {
                merge master ld;
            }
        }
    }



    public static void updateActualProductInterested(final List<Lead> newLeads) {
        Map<String, String> productCodeAPIMap = getProductMetaDataConfiguration();
        for (Lead leadRec : newLeads) {
            if (leadRec.LeadSource == 'Website') {
                if (productCodeAPIMap.containsKey(leadRec.ProductInterest__c)) {
                    leadRec.put(productCodeAPIMap.get(leadRec.ProductInterest__c), 'Awaiting Confirmation');
                    productCodeAPIMap.remove(leadRec.ProductInterest__c);
                }

                for (String fieldLabel : productCodeAPIMap.keySet()) {
                    leadRec.put(productCodeAPIMap.get(fieldLabel), 'Not Subscribed');
                }
            }
        }
    }

    public static void updateWithRandomNumber(final List<Lead> newLeads) {
        Map<String, Lead> emailsLeadMap = new Map<String, Lead>();
        for (Lead leadRec : newLeads) {
            if (leadRec.LeadSource == 'Website') {
                String randomNumber = Util.getUUID();
                leadRec.Activation_Number__c = randomNumber;
            }
        }
    }

    

    public static Map<String, String> getProductMetaDataConfiguration() {
        Map<String, String> productCodeAPIMap = new Map<String, String>();
        List<Subscription_Product_Configuration__mdt> productConfigList = [SELECT Id, Label, Field_API__c FROM Subscription_Product_Configuration__mdt];
        for (Subscription_Product_Configuration__mdt productConfigRec : productConfigList) {
            productCodeAPIMap.put(productConfigRec.Label, productConfigRec.Field_API__c);
        }
        return productCodeAPIMap;
    }

    public static List<Contact> checkDuplicatesInContact(final List<Lead> newLeads, Set<String> emails, List<String> productFieldsTobeQueriedToList) {
        String contactQuery = 'SELECT ' + String.join(productFieldsTobeQueriedToList, ' , ') + ' FROM Contact WHERE Email IN :emails';
        List<Contact> existingContacts = Database.query(contactQuery);
        return existingContacts;
    }
    
    public static void leadDupeMerge(final List<Lead> newLeads) {

        if (Label.performLeadDuplicateCheck == 'true') {
            Set<String> emails = new Set<String>();
            Set<String> productFieldsTobeQueried = new Set<String>();

            Map<String, Lead> masters = new Map<String, Lead>();
            Map<String, Lead> existingLeadsMap = new Map<String, Lead>();
            Map<String, Contact> existingContactsMap = new Map<String, Contact>();

            Map<String, String> emailProductMap = new Map<String, String>();
            Map<String, String> productCodeAPIMap = getProductMetaDataConfiguration();

            for (Lead ldRec : newLeads) {
                if (ldRec.LeadSource == 'Website') {
                    emails.add(ldRec.Email);
                    if (productCodeAPIMap.containsKey(ldRec.ProductInterest__c)) {
                        emailProductMap.put(ldRec.Email, productCodeAPIMap.get(ldRec.ProductInterest__c));
                        productFieldsTobeQueried.add(productCodeAPIMap.get(ldRec.ProductInterest__c));
                    }
                }
            }


            emails.remove(null);

            List<String> productFieldsTobeQueriedToList = new List<String>();
            productFieldsTobeQueriedToList.addAll(productFieldsTobeQueried);
            productFieldsTobeQueriedToList.add('Id');
            productFieldsTobeQueriedToList.add('Email');

            String leadQuery = 'SELECT Lead_Origin__c,' + String.join(productFieldsTobeQueriedToList, ' , ') + ' FROM Lead WHERE Email IN: emails  AND IsConverted = false';//AND Id NOT IN :newLeads
            List<Lead> existingLeads = Database.query(leadQuery);


            List<Contact> existingContacts = new List<Contact>();
            if (existingLeads.isEmpty()) {
                existingContacts = checkDuplicatesInContact(newLeads, emails, productFieldsTobeQueriedToList);
            }


            for (Lead led : existingLeads) existingLeadsMap.put(led.Email, led);

            for (Contact con : existingContacts) existingContactsMap.put(con.Email, con);

            List<Lead> leadsToBeUpdated = new List<Lead>();
            List<Lead> leadsToBeInsert = new List<Lead>();
            List<Contact> contactsToBeUpdated = new List<Contact>();

            for (Lead ld : newLeads) {
                if (existingLeadsMap.containsKey(ld.Email)) {
                    Lead master = existingLeadsMap.get(ld.Email);
  					//merging lead origin
                    if(master.Lead_Origin__c!=null && !master.Lead_Origin__c.contains(ld.Lead_Origin__c)){
                        master.Lead_Origin__c = (master.Lead_Origin__c !=null)?master.Lead_Origin__c +';'+ld.Lead_Origin__c:ld.Lead_Origin__c;
                    }

                    if (master.get(emailProductMap.get(ld.Email)) == null || master.get(emailProductMap.get(ld.Email)) == 'Not Subscribed') {
                        master.put(emailProductMap.get(ld.Email), 'Awaiting Confirmation');
                    } else if (master.get(emailProductMap.get(ld.Email)) == 'Awaiting Confirmation') {
                        master.put(emailProductMap.get(ld.Email), 'Resend Confirmation');
                    }

                    master.put('ProductInterest__c', ld.ProductInterest__c);
                    leadsToBeUpdated.add(master);

                } else if (existingContactsMap.containsKey(ld.Email)) {
                    Contact master = existingContactsMap.get(ld.Email);


                    if (master.get(emailProductMap.get(ld.Email)) == null || master.get(emailProductMap.get(ld.Email)) == 'Not Subscribed') {
                        master.put(emailProductMap.get(ld.Email), 'Awaiting Confirmation');
                    } else if (master.get(emailProductMap.get(ld.Email)) == 'Awaiting Confirmation') {
                        master.put(emailProductMap.get(ld.Email), 'Resend Confirmation');
                    }

                    master.put('ProductInterest__c', ld.ProductInterest__c);
                    contactsToBeUpdated.add(master);
                } else {
                    leadsToBeInsert.add(ld);
                }
            }

            if (leadsToBeUpdated.size() > 0) update leadsToBeUpdated;

            if (contactsToBeUpdated.size() > 0) update contactsToBeUpdated;

            if (leadsToBeInsert.size() > 0) updateActualProductInterested(leadsToBeInsert);
        } 
        else {
            updateActualProductInterested(newLeads);
        }
    }
    
    //Rest api
    public static Lead leadDupeMerge(Lead ldRec) {
        Map<String, String> productCodeAPIMap = getProductMetaDataConfiguration();
        if(!productCodeAPIMap.containsKey(ldRec.ProductInterest__c)) return ldRec;
		List<Account> existingAccounts=new List<Account>();
        String email=ldRec.Email;
        String leadQuery = 'SELECT Lead_Origin__c,Id,Email,' + productCodeAPIMap.get(ldRec.ProductInterest__c) + ' FROM Lead WHERE Email =:email  AND IsConverted = false';
        
        List<Account> toUpdateAccount=new List<Account>();
        
        List<Lead> existingLeads = Database.query(leadQuery);
        if(existingLeads.size()<=0){
            String accountQuery = 'SELECT Id,PersonEmail,ProductInterest__pc,' + productCodeAPIMap.get(ldRec.ProductInterest__c).replace('__c','__pc')  + ' FROM Account WHERE PersonEmail =:email';
            existingAccounts = Database.query(accountQuery);
        }
        
        if(existingLeads.size()>0){
            Lead leadMaster=existingLeads.get(0);
            //merging lead origin
            if(leadMaster.Lead_Origin__c!=null && !leadMaster.Lead_Origin__c.contains(ldRec.Lead_Origin__c)){
                leadMaster.Lead_Origin__c = (leadMaster.Lead_Origin__c !=null)?leadMaster.Lead_Origin__c +';'+ldRec.Lead_Origin__c:ldRec.Lead_Origin__c;
            }
            
            //update product status
            if (leadMaster.get(productCodeAPIMap.get(ldRec.ProductInterest__c)) == null 
                || leadMaster.get(productCodeAPIMap.get(ldRec.ProductInterest__c)) == 'Not Subscribed') {
                    leadMaster.put(productCodeAPIMap.get(ldRec.ProductInterest__c), 'Awaiting Confirmation');
                }
            else if (leadMaster.get(productCodeAPIMap.get(ldRec.ProductInterest__c)) == 'Awaiting Confirmation') {
                leadMaster.put(productCodeAPIMap.get(ldRec.ProductInterest__c), 'Resend Confirmation');
            }
            
            leadMaster.put('ProductInterest__c', ldRec.ProductInterest__c);
            return leadMaster;
        }
        else{
            //updatating product status
            if (ldRec.get(productCodeAPIMap.get(ldRec.ProductInterest__c)) == null 
                || ldRec.get(productCodeAPIMap.get(ldRec.ProductInterest__c)) == 'Not Subscribed') 
                ldRec.put(productCodeAPIMap.get(ldRec.ProductInterest__c), 'Awaiting Confirmation');
            else if (ldRec.get(productCodeAPIMap.get(ldRec.ProductInterest__c)) == 'Awaiting Confirmation')
                ldRec.put(productCodeAPIMap.get(ldRec.ProductInterest__c), 'Resend Confirmation');
        }
        
        if(existingAccounts.size()>0){
            Account accountMaster=existingAccounts.get(0);
            String fieldApi=productCodeAPIMap.get(ldRec.ProductInterest__c).replace('__c','__pc');
            //updatating product status
            if (accountMaster.get(fieldApi) == null || accountMaster.get(fieldApi) == 'Not Subscribed') {
                accountMaster.put(fieldApi, 'Awaiting Confirmation');
            } else if (accountMaster.get(fieldApi) == 'Awaiting Confirmation') {
                accountMaster.put(fieldApi, 'Resend Confirmation');
            }
            accountMaster.put('ProductInterest__pc', ldRec.ProductInterest__c);
            toUpdateAccount.add(accountMaster);
        }
        
        if(toUpdateAccount.size()>0) update toUpdateAccount;
        
        return ldRec;
         
    }

    //LC Button
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

    @AuraEnabled
    public static Boolean updateLeadToUnSubscribed(String email,String product,String reason){
        Map<String, String> productCodeAPIMap = getProductMetaDataConfiguration();
        if(!productCodeAPIMap.containsKey(product)) return true;
        String leadQuery = 'SELECT Id,Email,' + productCodeAPIMap.get(product) + ' FROM Lead WHERE Email =:email  AND IsConverted = false';
        String accountQuery = 'SELECT Id,PersonEmail,' + productCodeAPIMap.get(product).replace('__c','__pc')  + ' FROM Account WHERE PersonEmail =:email';
        List<Lead> existingLeads = Database.query(leadQuery);
        List<Account> existingAccounts = Database.query(accountQuery);
        if(existingLeads.size()>0){
            Lead leadMaster=existingLeads.get(0);
            leadMaster.put(productCodeAPIMap.get(product), 'Not Subscribed');
            update leadMaster;
        }
        if(existingAccounts.size()>0){
            Account accountMaster=existingAccounts.get(0);
            accountMaster.put(productCodeAPIMap.get(product).replace('__c','__pc'), 'Not Subscribed');
            update accountMaster;
        }
        return true;
    }
    
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
                showForm = updateLeadDML(LeadRec, showForm);
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

    public static Boolean updateLead(String email, String product, String salutation, String lastName, String firstName, Boolean termsAndConditions, String phoneNumber, String leadId) {
        Map<String, String> productCodeAPIMap = getProductMetaDataConfiguration();
        Boolean showForm = true;
        String fieldToUpdate = productCodeAPIMap.get(product);
        List<Lead> leadList = getLeadList(email, fieldToUpdate,leadId); //Database.query('SELECT Id FROM Lead WHERE Email =:email AND IsConverted = false AND LeadSource = \'Website\' AND ' + fieldToUpdate + ' = \'Awaiting Confirmation\' FOR UPDATE');
        System.debug('leadList ' + leadList);
        if (leadList.size() > 0) {
            Lead LeadRec = leadList.get(0);
            LeadRec.Salutation = salutation;
            LeadRec.Gender__c=(salutation.contains('Herr'))?'Male':'Female';
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
            queryStr += 'Email =:email AND IsConverted = false AND LeadSource = \'Website\' AND ' + fieldToUpdate + ' IN (\'Awaiting Confirmation\',\'Resend Confirmation\') FOR UPDATE';
        }
        List<Lead> leadList = Database.query(queryStr);
        return leadList;
    }

    public static List<String> getLeadFieldNames() {
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