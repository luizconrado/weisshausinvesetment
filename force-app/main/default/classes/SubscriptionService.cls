/***************
* @group Service Class
* @description all subscription related logic is writen here
*/
public without sharing class SubscriptionService {

    
    /***************
    * @description checkes if customer exsists and updates is subsription status to subsribed
    * @param email email of customer
    * @param product subsription type
    * @return leadWrapper
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
                subscription.Subscribed_Date__c=DateTime.now();
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
    /***************
    * @description updates customer account details and updates subsription status to subscribed
    * @param leadId account id of customer
    * @param email
    * @param product
    * @param salutation
    * @param lastName
    * @param firstName
    * @param termsAndConditions
    * @param phoneNumber
    * @return true of false
    */
    @AuraEnabled
    public static Boolean updateSubscriptionWithConfirmation(String email, String product, String salutation, String lastName, String firstName,
     Boolean termsAndConditions, String phoneNumber, String leadId) {
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
                subscription.Subscribed_Date__c=DateTime.now();
                update subscription;
            }
           
            update accountRec;
            showForm=false;
        }
        return showForm;
    }
    

    
 
    /***************
    * @description checks subsripiton status is unsubscribed
    * @param email
    * @param product
    * @return true / false
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
    /***************
    * @description checks subsripiton status is unsubscribed for lead
    * @param email
    * @param product
    * @return true / false
    */
   @AuraEnabled
   public static Boolean checkUnsubscribedLeadStatus(String email,String product){
    product=product.replace('+',' ');
       Boolean showForm = true;
       
       List<Lead> accountList=[SELECT id,FirstName,Salutation,LastName,Phone,(Select id,Subscription_Terms_and_Conditions__c,Source__c,Type__c,Subscription_Status__c from Subscriptions__r WHERE Type__c=:product AND RecordTypeId=:Constant.SUBSCRIPTION_LEAD_RECORDTYPEID LIMIT 1) 
                                  FROM Lead WHERE Email=:email AND RecordTypeId=:Constant.SUBSCRIPTION_DEFAULT_RECORDTYPEID];
       if(accountList.size()>0){
           Lead accountRec = accountList.get(0);
           if(accountRec.Subscriptions__r.size()>0){
               Subscription__c subscription=accountRec.Subscriptions__r.get(0);
               showForm = (subscription.Subscription_Status__c=='Unsubscribed')?false:true;
           }
       }
       
       
       return showForm;
   }
   
   /***************
    * @description updates subsripiton status for unsubscribed
    * @param email
    * @param product
    * @param reason
    * @return true / false
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
                subscription.Unsubscribed_Date__c=DateTime.now();
                subscription.Send_Mail__c=true;
                update subscription;
            }
        }
        
       
 
        
        List<CampaignMember> campaignMember=[select id from CampaignMember where Campaign.Product__c=:product AND LeadOrContactId IN:leadAndContactId];
        if(campaignMember.size()>0)   delete campaignMember;
        return true;
    }
    /***************
    * @description updates subsripiton status to unsubscribed for lead
    * @param email
    * @param product
    * @param reason
    * @return true / false
    */
   @AuraEnabled
   public static Boolean updateLeadSubscriptionToUnSubscribed(String email,String product,String reason){
        product=product.replace('+',' ');
       List<String> leadAndContactId=new List<String>();

       List<Lead> accountList=[SELECT id,FirstName,Salutation,LastName,Phone,(Select id,Send_Mail__c,Subscription_Terms_and_Conditions__c,Source__c,Type__c,Subscription_Status__c from Subscriptions__r WHERE Type__c=:product AND RecordTypeId=:Constant.SUBSCRIPTION_LEAD_RECORDTYPEID LIMIT 1) 
                                  FROM Lead WHERE Email=:email AND RecordTypeId=:Constant.DEFAULT_LEAD_RECORDTYPEID];
       if(accountList.size()>0){
           Lead accountRec = accountList.get(0);
           if(accountRec.Subscriptions__r.size()>0){
            leadAndContactId.add(accountRec.Id);
               Subscription__c subscription=accountRec.Subscriptions__r.get(0);
               subscription.Subscription_Status__c='Unsubscribed'; 
               subscription.Reason_For_Unsubscribing__c=reason;
               subscription.Unsubscribed_Date__c=DateTime.now();
               subscription.Send_Mail__c=true;
               update subscription;
           }
       }
       
      

       
       List<CampaignMember> campaignMember=[select id from CampaignMember where Campaign.Product__c=:product AND LeadOrContactId IN:leadAndContactId];
       if(campaignMember.size()>0)   delete campaignMember;
       return true;
   }
    
     
    @AuraEnabled(cacheable=true)
    public static Map<String,String> getUnsubscribeOptions(){
        Map<String,PicklistEntry[]> allPicklistValues=SchemaUtil.getObjectPicklistFileds(SchemaUtil.getSobjectType('Subscription__c'));
        Map<String,String> values=new Map<String,String>();
        for(PicklistEntry entry:allPicklistValues.get('Reason_For_Unsubscribing__c')){
            values.put(entry.getValue(),entry.getLabel());
        }
        return values;
    }
    
    /***************
    * @description querys  History_Tracker__c object and retrives all history records when send mail was checked
    * @param subscriptionId id of subsription record
    */
    @AuraEnabled
    public static List<History_Tracker__c> getLastEmailSentInfo(String subscriptionId){
        return [SELECT id,User__r.Name,Field__c,New_Value__c,CreatedDate FROM History_Tracker__c WHERE Object__c='Subscription__c' AND  Field__c='Send_Mail__c' AND Record_Id__c=:subscriptionId ORDER BY CreatedDate Desc];
    }
    
    
    /***************
    * @description creates acccount and subscripiton record
    * @param objectName the name of the object to look up
    */
    @AuraEnabled
    public static void registerSubscription(String email,String productName,String origin,String website,Map<String,String> utmParameters){
        
        try{
            AccountService.service service=new AccountService.service();
            service.createAccountAndNewsletter(email, productName, origin, website, utmParameters, Constant.ACCOUNT_PERSON_INVESTMENT_RECORDTYPEID);
        }
        catch(Exception e){
            logError(e,null,'Account','waitinglist_subscription','waitinglist_subscription','Subscribe');
        	throw new AuraHandledException(e.getMessage());
        }
        
        
    }
     /***************
    * @description creates lead and subscripiton record
    * @param objectName the name of the object to look up
    */
   @AuraEnabled
   public static void createLeadAndSubscription(String firstName,String lastName,String email,String productName,String origin,String website,Map<String,String> utmParameters){
       
       try{
        LeadService.service service=new LeadService.service();
        List<String> leadIds=service.createLead(null,firstName,lastName,email,website,true,origin,utmParameters,Constant.DEFAULT_LEAD_RECORDTYPEID);
        service.createSubscription(leadIds,productName,utmParameters,website);
           
       }
       catch(Exception e){
           logError(e,null,'Lead','waitinglist_leadsubscription','waitinglist_leadsubscription','Subscribe');
           throw new AuraHandledException(e.getMessage());
       }
       
       
   }

    /***************
    * @description subscription status to subscribed
    * @param email 
    * @param product 
    */
    @AuraEnabled
    public static void confirmSubscriptionOfUser(String email,String product){
        List<Account> accountDetails=new List<Account>();
        try {
            product = EncodingUtil.urlDecode(product,'utf-8');
            accountDetails=[SELECT id,FirstName,Salutation,LastName,Phone,
                                          (Select id,Send_Mail__c,Subscription_Terms_and_Conditions__c,Source__c,Type__c,Subscription_Status__c from Subscriptions__r WHERE Type__c=:product AND RecordTypeId=:Constant.SUBSCRIPTION_DEFAULT_RECORDTYPEID LIMIT 1) 
                                          FROM Account WHERE PersonEmail=:email AND isPersonAccount=true];
            
            if(accountDetails.size()>0){
                if(accountDetails.get(0).Subscriptions__r.size()>0){
                    Subscription__c subscription=accountDetails.get(0).Subscriptions__r.get(0);
                    subscription.Subscription_Status__c='Subscribed';
                    subscription.Send_Mail__c=true;
                    subscription.Subscribed_Date__c=DateTime.now();
                    subscription.Subscription_Terms_and_Conditions__c=true;
                    update subscription;
                }
            }
        } catch (Exception e) {
            String recordId=(accountDetails.size()>0)?accountDetails.get(0).Id:null;
            logError(e,recordId,'Account','registerWaitingListSubscriptionUser','waitingList_confirmEmail','Confirm Subscribe');
        }
    }
    /***************
    * @description lead subscription status to subscribed
    * @param email 
    * @param product 
    */
   @AuraEnabled
   public static void confirmSubscriptionOfLead(String email,String product){
       List<Lead> accountDetails=new List<Lead>();
       try {
           product = EncodingUtil.urlDecode(product,'utf-8');
           accountDetails=[SELECT id,FirstName,Salutation,LastName,Phone,
                                         (Select id,Send_Mail__c,Subscription_Terms_and_Conditions__c,Source__c,Type__c,Subscription_Status__c from Subscriptions__r WHERE Type__c=:product AND RecordTypeId=:Constant.SUBSCRIPTION_LEAD_RECORDTYPEID LIMIT 1) 
                                         FROM Lead WHERE Email=:email AND RecordTypeId=:Constant.DEFAULT_LEAD_RECORDTYPEID];
           
           if(accountDetails.size()>0){
               if(accountDetails.get(0).Subscriptions__r.size()>0){
                   Subscription__c subscription=accountDetails.get(0).Subscriptions__r.get(0);
                   subscription.Subscription_Status__c='Subscribed';
                   subscription.Send_Mail__c=true;
                   subscription.Subscribed_Date__c=DateTime.now();
                   subscription.Subscription_Terms_and_Conditions__c=true;
                   update subscription;
               }
           }
       } catch (Exception e) {
           String recordId=(accountDetails.size()>0)?accountDetails.get(0).Id:null;
           logError(e,recordId,'Lead','registerWaitingListSubscriptionLeadUser','waitinglist_verifyLead','Confirm Lead Subscribe');
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