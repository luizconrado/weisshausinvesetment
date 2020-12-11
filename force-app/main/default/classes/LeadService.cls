public without sharing class LeadService {

   	//LWC Component
      /*
     * Description: on load of verification from update terms and condition and subscribe status
     * email:sends product subscribed email
     * //1
	*/
    @AuraEnabled
    public static leadWrapper checkAndUpdateLeadOnload(String email, String product) {
        product=product.replace('+',' ');
        leadWrapper respWrapper = new leadWrapper();

        Boolean showForm = true;
        if (checkProductConfiguration(product, email)) {
            Map<String, String> productCodeAPIMap = Constant.PRODUCT_CONFIGURATION;
            String fieldToUpdate = productCodeAPIMap.get(product);
            List<Account> accountList=Database.query('SELECT id,Subscription_Terms_and_Conditions__pc,FirstName,Salutation,LastName,Phone,'+productCodeAPIMap.get(product).replace('__c','__pc')+' FROM Account WHERE PersonEmail=:email');
            //update account with product status
            if(accountList.size()>0){
                Account accountRec = accountList.get(0);
                respWrapper.leadId = accountRec.Id;
                if(accountRec.Phone!=null && accountRec.FirstName!=null) showForm = false;
                accountRec.put(productCodeAPIMap.get(product).replace('__c','__pc'), 'Subscribed');
                accountRec.Subscription_Terms_and_Conditions__pc=true;
                update accountRec;
                //TODO : confirm with luiz
                if(!showForm){
                    Contact personContact=[SELECT id,Email FROM Contact WHERE accountId=:accountRec.id AND account.IsPersonAccount=true];
                    MailUtility.sendAccountHtmlEmail(personContact.id, accountRec.id, Constant.ACCOUNT_SUBSCRIBED_EMAIL_TEMPLATE, personContact.Email);    
                }
            }
        }
        respWrapper.showForm = showForm;
        return respWrapper;
    }
    
     /*
     * Description: saves lead details when filled in verification form
     * //2
	*/
    @AuraEnabled
    public static Boolean updateLeadWithConfirmation(String email, String product, String salutation, String lastName, String firstName, Boolean termsAndConditions, String phoneNumber, String leadId) {
        Boolean showForm = true;
        if (checkProductConfiguration(product, email)) {
            Map<String, String> productCodeAPIMap = Constant.PRODUCT_CONFIGURATION;
            String fieldToUpdate = productCodeAPIMap.get(product);
            List<Account> accountList=Database.query('SELECT id,Subscription_Terms_and_Conditions__pc,FirstName,Salutation,LastName,Phone,'+productCodeAPIMap.get(product).replace('__c','__pc')+' FROM Account WHERE PersonEmail=:email');
            //update account with product status
            if(accountList.size()>0){
                Account accountRec = accountList.get(0);
                if(salutation!=null || String.isNotEmpty(salutation)){
                    accountRec.Salutation = salutation;
                    accountRec.Gender__pc=(salutation.contains('Herr'))?'Male':'Female';
                }
                accountRec.LastName = lastName;
                accountRec.FirstName = firstName;
                accountRec.Phone = phoneNumber;
                accountRec.put(productCodeAPIMap.get(product).replace('__c','__pc'), 'Subscribed');
                accountRec.Subscription_Terms_and_Conditions__pc=true;
              	update accountRec;
                showForm=false;
                Contact personContact=[SELECT id,Email FROM Contact WHERE accountId=:accountRec.id AND account.IsPersonAccount=true];
                MailUtility.sendAccountHtmlEmail(personContact.id, accountRec.id, Constant.ACCOUNT_SUBSCRIBED_EMAIL_TEMPLATE, personContact.Email);
            }
            
        }
        return showForm;
    }

    
     /*
     * Description: on load of unsubscribe check if its already unsubscribed
     * email:sends successfuly unsubscribed email
     * //3
	*/
    @AuraEnabled
    public static Boolean checkUnsubscribedStatus(String email,String product){
        product=product.replace('+',' ');
        Boolean showForm = true;
        if (checkProductConfiguration(product, email)) {
            Map<String, String> productCodeAPIMap = Constant.PRODUCT_CONFIGURATION;
            String fieldToUpdate = productCodeAPIMap.get(product);
            List<Account> accountList=Database.query('SELECT id,Salutation,LastName,Phone,'+productCodeAPIMap.get(product).replace('__c','__pc')+' FROM Account WHERE PersonEmail=:email');
            //check account with product status
            if(accountList.size()>0){
                Account accountRec = accountList.get(0);
                showForm = (accountRec.get(productCodeAPIMap.get(product).replace('__c','__pc'))=='Unsubscribed')?false:true;
                if(showForm==false){
                    Contact personContact=[SELECT id,Email FROM Contact WHERE accountId=:accountRec.id AND account.IsPersonAccount=true];
                    MailUtility.sendAccountHtmlEmail(personContact.id, accountRec.id, Constant.ACCOUNT_UNSUBSCRIBE_EMAIL_TEMPLATE, personContact.Email);   
                }
            }
        }
        return showForm;
    }
    
   
    /*
     * Description: on load of unsubscribe page product is updateted to unsubscribe
     * email:sends product unsubscribed email
     * //4
	*/
    @AuraEnabled
    public static Boolean updateLeadToUnSubscribed(String email,String product,String reason){
        product=product.replace('+',' ');
        Map<String, String> productCodeAPIMap = Constant.PRODUCT_CONFIGURATION;
        if(!productCodeAPIMap.containsKey(product)) return true;
        String accountQuery = 'SELECT Id,PersonEmail,ProductInterest__pc,Reason_For_Unsubscribing__pc,' + productCodeAPIMap.get(product).replace('__c','__pc')  + ' FROM Account WHERE PersonEmail =:email';
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
        
        
        List<CampaignMember> campaignMember=[select id from CampaignMember where Campaign.Product__c=:product AND LeadOrContactId IN:leadAndContactId];
        if(campaignMember.size()>0)   delete campaignMember;
        return true;
    }
    
     /*
     * Description: on load of unsubscribe page reasons are loaded
     * //5
	*/
    @AuraEnabled(cacheable=true)
    public static Map<String,String> getUnsubscribeOptions(){
        Map<String,PicklistEntry[]> allPicklistValues=SchemaUtil.getObjectPicklistFileds(SchemaUtil.getSobjectType('Contact'));
        Map<String,String> values=new Map<String,String>();
        for(PicklistEntry entry:allPicklistValues.get('Reason_For_Unsubscribing__c')){
            values.put(entry.getValue(),entry.getLabel());
        }
        return values;
    }

    //helpers
    private static Boolean checkProductConfiguration(String product, String email) {
        if (product.contains('+'))product = product.replace('+', ' ');
        Map<String, String> productCodeAPIMap = Constant.PRODUCT_CONFIGURATION;
        if (String.isNotBlank(email) && String.isNotBlank(product) && productCodeAPIMap.containsKey(product)) return true;
        return false;
    }
	
    public class leadWrapper{
        @AuraEnabled
        public Boolean showForm;
        @AuraEnabled
        public Id leadId;
    }

}