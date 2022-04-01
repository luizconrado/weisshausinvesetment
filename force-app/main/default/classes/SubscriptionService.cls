public without sharing class SubscriptionService {

   	//LWC Component
      /*
     * Description: on load of verification from update terms and condition and subscribe status
     * email:sends product subscribed email
     * //1
	*/ 
    @AuraEnabled
    public static leadWrapper checkAndUpdateSubscriptionOnload(String email, String product) {
        product=product.replace('+',' ');
        leadWrapper respWrapper = new leadWrapper();
        Boolean showForm = true;
         
        
        List<Account> accountDetails=[SELECT id,FirstName,Salutation,LastName,Phone,(Select id,Send_Mail__c,Subscription_Terms_and_Conditions__c,Source__c,Type__c,Subscription_Status__c from Subscriptions__r WHERE Type__c=:product AND RecordTypeId=:Constant.SUBSCRIPTION_DEFAULT_RECORDTYPEID LIMIT 1) 
                                      FROM Account WHERE PersonEmail=:email AND isPersonAccount=true];
        if(accountDetails.size()>0){
            Account accountRec = accountDetails.get(0);
            respWrapper.leadId = accountRec.Id;
            if(accountRec.Phone!=null || accountRec.FirstName!=null) showForm = false;
            if(String.isBlank(accountRec.Phone) || String.isBlank(accountRec.FirstName)) showForm = true;
            if(accountRec.Subscriptions__r.size()>0){
                Subscription__c subscription=accountRec.Subscriptions__r.get(0);
                subscription.Subscription_Terms_and_Conditions__c=true;
                subscription.Subscription_Status__c='Subscribed';
                update subscription;
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
    public static Boolean updateSubscriptionWithConfirmation(String email, String product, String salutation, String lastName, String firstName, Boolean termsAndConditions, String phoneNumber, String leadId) {
        Boolean showForm = true;
        
        List<Account> accountDetails=[SELECT id,FirstName,Salutation,LastName,Phone,(Select id,Send_Mail__c,Subscription_Terms_and_Conditions__c,Source__c,Type__c,Subscription_Status__c from Subscriptions__r WHERE Type__c=:product AND RecordTypeId=:Constant.SUBSCRIPTION_DEFAULT_RECORDTYPEID LIMIT 1) 
                                      FROM Account WHERE id=:leadId];
        if(accountDetails.size()>0){
            Account accountRec = accountDetails.get(0);
            if(String.isNotEmpty(salutation?.trim())) accountRec.Salutation = salutation;
            if(String.isNotEmpty(salutation?.trim()) && salutation.contains('Herr')) accountRec.Gender__pc='Male';
            else if(String.isNotEmpty(salutation?.trim()) && salutation.contains('Frau')) accountRec.Gender__pc='Female';
            if(String.isNotEmpty(lastName?.trim())) accountRec.LastName = lastName;
            if(String.isNotEmpty(firstName?.trim()))accountRec.FirstName = firstName;
            if(String.isNotEmpty(phoneNumber?.trim()))accountRec.Phone = phoneNumber;
            if(accountRec.Subscriptions__r.size()>0){
                Subscription__c subscription=accountRec.Subscriptions__r.get(0);
                subscription.Send_Mail__c=true;
                subscription.Subscription_Terms_and_Conditions__c=true;
                subscription.Subscription_Status__c='Subscribed';
                update subscription;
            }
           
            update accountRec;
            showForm=false;
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
        
        List<Account> accountList=[SELECT id,FirstName,Salutation,LastName,Phone,(Select id,Subscription_Terms_and_Conditions__c,Source__c,Type__c,Subscription_Status__c from Subscriptions__r WHERE Type__c=:product AND RecordTypeId=:Constant.SUBSCRIPTION_DEFAULT_RECORDTYPEID LIMIT 1) 
                                   FROM Account WHERE PersonEmail=:email AND isPersonAccount=true];
        if(accountList.size()>0){
            Account accountRec = accountList.get(0);
            if(accountRec.Subscriptions__r.size()>0){
                Subscription__c subscription=accountRec.Subscriptions__r.get(0);
                showForm = (subscription.Subscription_Status__c=='Unsubscribed')?false:true;
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
    public static Boolean updateSubscriptionToUnSubscribed(String email,String product,String reason){
        product=product.replace('+',' ');
        List<String> leadAndContactId=new List<String>();

        List<Account> accountList=[SELECT id,FirstName,Salutation,LastName,Phone,(Select id,Send_Mail__c,Subscription_Terms_and_Conditions__c,Source__c,Type__c,Subscription_Status__c from Subscriptions__r WHERE Type__c=:product AND RecordTypeId=:Constant.SUBSCRIPTION_DEFAULT_RECORDTYPEID LIMIT 1) 
                                   FROM Account WHERE PersonEmail=:email AND isPersonAccount=true];
        if(accountList.size()>0){
            Account accountRec = accountList.get(0);
            if(accountRec.Subscriptions__r.size()>0){
                List<Contact> personContact=[SELECT id,Email,Preferred_Language__c FROM Contact WHERE accountId=:accountRec.id AND Account.ispersonaccount=true];
                leadAndContactId.add(personContact.get(0).Id);
                Subscription__c subscription=accountRec.Subscriptions__r.get(0);
                subscription.Subscription_Status__c='Unsubscribed'; 
                subscription.Reason_For_Unsubscribing__c=reason;
                subscription.Send_Mail__c=true;
                update subscription;
            }
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
        Map<String,PicklistEntry[]> allPicklistValues=SchemaUtil.getObjectPicklistFileds(SchemaUtil.getSobjectType('Subscription__c'));
        Map<String,String> values=new Map<String,String>();
        for(PicklistEntry entry:allPicklistValues.get('Reason_For_Unsubscribing__c')){
            values.put(entry.getValue(),entry.getLabel());
        }
        return values;
    }
    
    @AuraEnabled
    public static List<History_Tracker__c> getLastEmailSentInfo(String subscriptionId){
        return [SELECT id,User__r.Name,Field__c,New_Value__c,CreatedDate FROM History_Tracker__c WHERE Object__c='Subscription__c' AND  Field__c='Send_Mail__c' AND Record_Id__c=:subscriptionId ORDER BY CreatedDate Desc];
    }
    
    
    @AuraEnabled
    public static boolean registerSubscription(String email,String productName,String origin,String website){
        try{
            AccountService.createAccountAndNewsletter(email, productName, origin, website, Constant.ACCOUNT_PERSON_INVESTMENT_RECORDTYPEID);
        	return true;
        }
        catch(Exception e){
            logError(e,null,'Account','waitinglist_subscription','waitinglist_subscription','Subscribe');
            return false;
        }
        
    }

    @AuraEnabled
    public static void registerWaitingListSubscriptionUser(String email,String product){
        product = EncodingUtil.urlDecode(product,'utf-8');
        List<Account> accountDetails=[SELECT id,FirstName,Salutation,LastName,Phone,
        (Select id,Send_Mail__c,Subscription_Terms_and_Conditions__c,Source__c,Type__c,Subscription_Status__c from Subscriptions__r WHERE Type__c=:product AND RecordTypeId=:Constant.SUBSCRIPTION_DEFAULT_RECORDTYPEID LIMIT 1) 
        FROM Account WHERE PersonEmail=:email AND isPersonAccount=true];
        try {
          
            System.debug('accountDetails'+accountDetails.size());
            if(accountDetails.size()>0){
                if(accountDetails.get(0).Subscriptions__r.size()>0){
                    System.debug('Subscriptions__r'+accountDetails.get(0).Subscriptions__r.size());
                    Subscription__c subscription=accountDetails.get(0).Subscriptions__r.get(0);
                    subscription.Subscription_Status__c='Subscribed';
                    subscription.Send_Mail__c=true;
                    subscription.Subscription_Terms_and_Conditions__c=true;
                    update subscription;
                }
            }
        } catch (Exception e) {
            String recordId=(accountDetails.size()>0)?accountDetails.get(0).Id:null;
            logError(e,recordId,'Account','registerWaitingListSubscriptionUser','waitingList_confirmEmail','Confirm Subscribe');
        }
    }
    
     //helper
    @testVisible
    private static String logError(Exception e,String recordID,String objectName,String componentName,String methodName,String operation){
        LogService.LogMetadata details=new LogService.LogMetadata();
        details.addError(e);
        details.addRecordInfo(objectName,recordId);
        details.addMetadataInfo(userinfo.getUserId(),'SubscriptionService', methodName, componentName, operation);
        return LogService.logError(details);
    }

    public class leadWrapper{
        @AuraEnabled
        public Boolean showForm;
        @AuraEnabled
        public Id leadId;
        
    }

}