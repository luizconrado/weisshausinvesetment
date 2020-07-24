public without sharing class LeadService {

   
    //Rest api
    /*
     * Description: called from webhook to check and update exsisting lead and accounts
     * email:sends verify account email as external user
	*/
    public static void leadDupeMerge(Lead ldRec) {
        Map<String, String> productCodeAPIMap = Constant.PRODUCT_CONFIGURATION;
        List<String> personAccountFields=new List<String>();
        for(String apiName:productCodeAPIMap.values()) personAccountFields.add(apiname.replace('__c','__pc'));
        String email=ldRec.Email;
        String leadQuery = 'SELECT Id,Phone ,LastName, FirstName, MiddleName, Suffix ,Last_Email_Sent_Date__c,Lead_Origin__c,Email,Gender__c,Accepted_Terms_and_Conditions__c,ProductInterest__c,'+String.join(productCodeAPIMap.values(),',')+' FROM Lead WHERE Email =:email  AND IsConverted = false';
        String accountQuery = 'SELECT Id,Phone ,LastName, FirstName, MiddleName, Suffix ,Last_Email_Sent_Date__pc,Origin__pc,PersonEmail,Gender__pc,Accepted_Terms_and_Conditions__pc,ProductInterest__pc,'+String.join(personAccountFields,',')+' FROM Account WHERE PersonEmail =:email';
        List<Lead> existingLeads = Database.query(leadQuery);
        List<Account> existingAccounts = Database.query(accountQuery);
       
        //updataing account
        if(existingAccounts.size()>0){
            Account accountMaster=existingAccounts.get(0);
            String fieldApi=productCodeAPIMap.get(ldRec.ProductInterest__c).replace('__c','__pc');
            //merging lead origin
            if(ldRec.Lead_Origin__c!=null && accountMaster.Origin__pc!=null && !accountMaster.Origin__pc.contains(ldRec.Lead_Origin__c))
                accountMaster.Origin__pc = (accountMaster.Origin__pc !=null)?accountMaster.Origin__pc +';'+ldRec.Lead_Origin__c:ldRec.Lead_Origin__c;
                        
            //updataing product status on person account account 
            if (accountMaster.get(fieldApi) == null || accountMaster.get(fieldApi) == 'Not Subscribed' || accountMaster.get(fieldApi) == 'Unsubscribed'  || accountMaster.get(fieldApi) == 'Confirmation Resent') {
                    accountMaster.put(fieldApi, 'Awaiting Confirmation');
                    accountMaster.Last_Email_Sent_Date__pc=Date.today();
            } 
            accountMaster.put('ProductInterest__pc', ldRec.ProductInterest__c);
            update accountMaster;
            sendVerificationEmail(accountMaster.Id);
            
        }
        //updataing lead
        else if(existingLeads.size()>0){
            Lead leadMaster=existingLeads.get(0);
            //merging lead origin
            if(ldRec.Lead_Origin__c!=null && leadMaster.Lead_Origin__c!=null && !leadMaster.Lead_Origin__c.contains(ldRec.Lead_Origin__c))
                leadMaster.Lead_Origin__c = (leadMaster.Lead_Origin__c !=null)?leadMaster.Lead_Origin__c +';'+ldRec.Lead_Origin__c:ldRec.Lead_Origin__c;
            //update product status 
            if (leadMaster.get(productCodeAPIMap.get(ldRec.ProductInterest__c)) == null || leadMaster.get(productCodeAPIMap.get(ldRec.ProductInterest__c)) == 'Not Subscribed' || leadMaster.get(productCodeAPIMap.get(ldRec.ProductInterest__c)) == 'Unsubscribed'|| leadMaster.get(productCodeAPIMap.get(ldRec.ProductInterest__c)) == 'Confirmation Resent') { 
                    leadMaster.put(productCodeAPIMap.get(ldRec.ProductInterest__c), 'Awaiting Confirmation');
                    leadMaster.Last_Email_Sent_Date__c=Date.today();
                }
            //updating latest product intrest
            leadMaster.put('ProductInterest__c', ldRec.ProductInterest__c);
            ldRec=leadMaster;
        }
        //create new lead
        else{
            //updatating product status for new lead
            if (ldRec.get(productCodeAPIMap.get(ldRec.ProductInterest__c)) == null || ldRec.get(productCodeAPIMap.get(ldRec.ProductInterest__c)) == 'Not Subscribed' || ldRec.get(productCodeAPIMap.get(ldRec.ProductInterest__c)) == 'Unsubscribed' || ldRec.get(productCodeAPIMap.get(ldRec.ProductInterest__c)) == 'Confirmation Resent') {
                	ldRec.put(productCodeAPIMap.get(ldRec.ProductInterest__c), 'Awaiting Confirmation');
                    ldRec.Last_Email_Sent_Date__c=Date.today();
                }
                
        }
        if(existingAccounts.size()==0) {
            upsert ldRec;
            sendVerificationEmail(ldRec.Id,ldRec.Email);
        }
        
    }

    //LC Button
    /*
     * Description: converts lead to exsisting person account. If no account is present creates new
	*/
    @AuraEnabled
    public static String convertLeadToPersonAccount(String leadId,String leadEmail){
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        List<Account> personAccount=[SELECT Id FROM Account WHERE PersonEmail =:leadEmail AND recordTypeId=:Constant.PERSON_ACCOUNT_RECORDTYPEID];
        Database.LeadConvert lc = new database.LeadConvert();
        if(personAccount.size()>0) lc.setAccountId(personAccount.get(0).Id);
       
        lc.setLeadId(leadId);
        lc.setDoNotCreateOpportunity(True);
        lc.setOwnerId(Userinfo.getUserId());
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        return lcr.getAccountId();
       
    }
     /*
     * Description: resends verification email to lead
     * email:sends verify account email as intenral user
	*/
    @AuraEnabled
    public static void sendEmailToLead(String leadId,String emailToProducts){
        List<Lead> leadlist=getLeadList('','',leadId);
        Map<String,Object> emailProductMap=(Map<String,Object>)JSON.deserializeUntyped(emailToProducts);
        if(leadlist.size()>0){
            Lead ldRec=leadlist.get(0);
            if(((Boolean)emailProductMap.get('newsletter'))==true){
                ldRec.Newsletter__c='Confirmation Resent';
                ldRec.ProductInterest__c='Newsletter';
                ldRec.Last_Email_Sent_Date__c=Date.today();
                update ldRec;
                sendVerificationEmail(ldRec.Id, ldRec.Email);
            }
            if(((Boolean)emailProductMap.get('productA'))==true){
                ldRec.Product_A__c='Confirmation Resent';
                ldRec.ProductInterest__c='Product A';
                ldRec.Last_Email_Sent_Date__c=Date.today();
                update ldRec;
                sendVerificationEmail(ldRec.Id,  ldRec.Email);
            }
        }
        
        
    }
    
    @AuraEnabled
    public static List<History_Tracker__c> getLastEmailToLeadInfo(String leadId){
        return [SELECT id,User__r.Name,Field__c,New_Value__c,CreatedDate FROM History_Tracker__c WHERE Object__c='Lead' AND  Field__c='ProductInterest__c' AND Record_Id__c=:leadId ORDER BY CreatedDate Desc];
    }
    

    //LWC Component
    /*
     * Description: saves lead details when filled in verification form
	*/
    @AuraEnabled
    public static Boolean updateLeadWithConfirmation(String email, String product, String salutation, String lastName, String firstName, Boolean termsAndConditions, String phoneNumber, String leadId) {
        Map<String, String> productCodeAPIMap = Constant.PRODUCT_CONFIGURATION;
        Boolean showForm = true;
        if (checkProductConfiguration(product, email)) {
            String fieldToUpdate = productCodeAPIMap.get(product);
            List<Lead> leadList = getLeadList(email, fieldToUpdate,leadId);
            //update lead with entered details
            if (leadList.size() > 0) {
                Lead LeadRec = leadList.get(0);
                if(salutation!=null || String.isNotEmpty(salutation)){
                    LeadRec.Salutation = salutation;
                    LeadRec.Gender__c=(salutation.contains('Herr'))?'Male':'Female';
                }
                LeadRec.LastName = lastName;
                LeadRec.FirstName = firstName;
                LeadRec.Phone = phoneNumber;
                LeadRec.put(productCodeAPIMap.get(product), 'Subscribed');
                showForm = updateLeadDML(LeadRec, showForm);
                MailUtility.sendLeadHtmlEmail(LeadRec.id, Constant.LEAD_SUBSCRIBED_EMAIL_TEMPLATE, LeadRec.Email);
            }
            
        }
        return showForm;
    }

    /*
     * Description: on load of unsubscribe page product is updateted to unsubscribe
     * email:sends product unsubscribed email
	*/
    @AuraEnabled
    public static Boolean updateLeadToUnSubscribed(String email,String product,String reason){
        product=product.replace('+',' ');
        Map<String, String> productCodeAPIMap = Constant.PRODUCT_CONFIGURATION;
        if(!productCodeAPIMap.containsKey(product)) return true;
        String leadQuery = 'SELECT Id,Email,Reason_For_Unsubscribing__c,' + productCodeAPIMap.get(product) + ' FROM Lead WHERE Email =:email  AND IsConverted = false';
        String accountQuery = 'SELECT Id,PersonEmail,ProductInterest__pc,Reason_For_Unsubscribing__pc,' + productCodeAPIMap.get(product).replace('__c','__pc')  + ' FROM Account WHERE PersonEmail =:email';
        List<Lead> existingLeads = Database.query(leadQuery);
        List<Account> existingAccounts = Database.query(accountQuery);
        List<String> leadAndContactId=new List<String>();
        if(existingAccounts.size()>0){
            Account accountMaster=existingAccounts.get(0);
            accountMaster.put(productCodeAPIMap.get(product).replace('__c','__pc'), 'UnSubscribed');
            accountMaster.ProductInterest__pc=product;
            accountMaster.Reason_For_Unsubscribing__pc=reason;
            List<Contact> personContact=[SELECT id,Email FROM Contact WHERE accountId=:accountMaster.id AND Account.ispersonaccount=true];
            leadAndContactId.add(personContact.get(0).Id);
            update accountMaster;
            MailUtility.sendAccountHtmlEmail(personContact.get(0).Id, accountMaster.id, Constant.ACCOUNT_UNSUBSCRIBE_EMAIL_TEMPLATE, personContact.get(0).Email);
        }
        else if(existingLeads.size()>0){
            Lead leadMaster=existingLeads.get(0);
            leadMaster.put(productCodeAPIMap.get(product), 'UnSubscribed');
            leadMaster.Reason_For_Unsubscribing__c=reason;
            leadMaster.ProductInterest__c=product;
            leadAndContactId.add(leadMaster.id);
            update leadMaster;
            MailUtility.sendLeadHtmlEmail(leadMaster.Id, Constant.LEAD_UNSUBSCRIBE_EMAIL_TEMPLATE, leadMaster.Email);
        }
        
        
        List<CampaignMember> campaignMember=[select id from CampaignMember where Campaign.Product__c=:product AND LeadOrContactId IN:leadAndContactId];
        if(campaignMember.size()>0)   delete campaignMember;
        return true;
    }
    
    @AuraEnabled(cacheable=true)
    public static Map<String,String> getUnsubscribeOptions(){
        Map<String,PicklistEntry[]> allPicklistValues=SchemaUtil.getObjectPicklistFileds(SchemaUtil.getSobjectType('Lead'));
        Map<String,String> values=new Map<String,String>();
        for(PicklistEntry entry:allPicklistValues.get('Reason_For_Unsubscribing__c')){
            values.put(entry.getValue(),entry.getLabel());
        }
        return values;
    }
    
    /*
     * Description: on load of verification from update terms and condition and subscribe status
     * email:sends product subscribed email
	*/
    @AuraEnabled
    public static leadWrapper checkAndUpdateLeadOnload(String email, String product) {
        product=product.replace('+',' ');
        leadWrapper respWrapper = new leadWrapper();

        Boolean showForm = true;
        if (checkProductConfiguration(product, email)) {
            Map<String, String> productCodeAPIMap = Constant.PRODUCT_CONFIGURATION;
            String fieldToUpdate = productCodeAPIMap.get(product);
            List<Account> accountList=Database.query('SELECT id,Accepted_Terms_and_Conditions__pc,Salutation,LastName,Phone,'+productCodeAPIMap.get(product).replace('__c','__pc')+' FROM Account WHERE PersonEmail=:email');
            List<Lead> leadList = getLeadList(email, fieldToUpdate,'');
            //update account with product status
            if(accountList.size()>0){
                Account accountRec = accountList.get(0);
                showForm = false;
                accountRec.put(productCodeAPIMap.get(product).replace('__c','__pc'), 'Subscribed');
                accountRec.Accepted_Terms_and_Conditions__pc=true;
                update accountRec;
                Contact personContact=[SELECT id,Email FROM Contact WHERE accountId=:accountRec.id AND account.IsPersonAccount=true];
                MailUtility.sendAccountHtmlEmail(personContact.id, accountRec.id, Constant.ACCOUNT_SUBSCRIBED_EMAIL_TEMPLATE, personContact.Email);
            }
            //update lead with product status
            else if (leadList.size() > 0) {
                Lead LeadRec = leadList.get(0);
                if(String.isBlank(LeadRec.Salutation) || String.isBlank(LeadRec.LastName) || String.isBlank(LeadRec.Phone)) showForm = true;
                else showForm = false;
                LeadRec.put(productCodeAPIMap.get(product), 'Subscribed');
                LeadRec.Accepted_Terms_and_Conditions__c=true;
                respWrapper.leadId = LeadRec.Id;
                updateLeadDML(LeadRec, showForm);
               
            }
        }
        respWrapper.showForm = showForm;
        return respWrapper;
    }
    
    /*
     * Description: on load of unsubscribe check if its already unsubscribed
     * email:sends successfuly unsubscribed email
	*/
    @AuraEnabled
    public static Boolean checkUnsubscribedStatus(String email,String product){
        product=product.replace('+',' ');
        Boolean showForm = true;
        if (checkProductConfiguration(product, email)) {
            Map<String, String> productCodeAPIMap = Constant.PRODUCT_CONFIGURATION;
            String fieldToUpdate = productCodeAPIMap.get(product);
            List<Account> accountList=Database.query('SELECT id,Accepted_Terms_and_Conditions__pc,Salutation,LastName,Phone,'+productCodeAPIMap.get(product).replace('__c','__pc')+' FROM Account WHERE PersonEmail=:email');
            List<Lead> leadList = getLeadList(email, fieldToUpdate,'');
            //check account with product status
            if(accountList.size()>0){
                Account accountRec = accountList.get(0);
                showForm = (accountRec.get(productCodeAPIMap.get(product).replace('__c','__pc'))=='Unsubscribed')?false:true;
                if(showForm==false){
                    Contact personContact=[SELECT id,Email FROM Contact WHERE accountId=:accountRec.id AND account.IsPersonAccount=true];
                    MailUtility.sendAccountHtmlEmail(personContact.id, accountRec.id, Constant.ACCOUNT_UNSUBSCRIBE_EMAIL_TEMPLATE, personContact.Email);   
                }
            }
            //check lead with product status
            else if (leadList.size() > 0) {
                Lead LeadRec = leadList.get(0);
                showForm = (LeadRec.get(productCodeAPIMap.get(product))=='Unsubscribed')?false:true;
                 if(showForm==false) MailUtility.sendLeadHtmlEmail(LeadRec.id, Constant.LEAD_UNSUBSCRIBE_EMAIL_TEMPLATE, LeadRec.Email);
            }
        }
        return showForm;
    }
    
    //helpers
    private static void sendVerificationEmail(String accountId){
        Contact personContact=[SELECT id,Email FROM Contact WHERE AccountId=:accountId AND Account.ispersonaccount=true];
        MailUtility.sendAccountHtmlEmail(personContact.Id, accountId, Constant.ACCOUNT_VERIFY_EMAIL_TEMPLATE, personContact.Email);
    }
    
    private static void sendVerificationEmail(String leadId,String leadEmail){
        MailUtility.sendLeadHtmlEmail(leadId,Constant.LEAD_VERIFY_EMAIL_TEMPLATE,leadEmail);
    }
    
    private static Boolean checkProductConfiguration(String product, String email) {
        if (product.contains('+'))product = product.replace('+', ' ');
        Map<String, String> productCodeAPIMap = Constant.PRODUCT_CONFIGURATION;
        if (String.isNotBlank(email) && String.isNotBlank(product) && productCodeAPIMap.containsKey(product)) return true;
        return false;
    }
	
    private static Boolean updateLeadDML(Lead LeadRec, Boolean showForm) {
        try {
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
            queryStr += 'Email =:email AND IsConverted = false AND LeadSource = \'Website\'  FOR UPDATE';
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