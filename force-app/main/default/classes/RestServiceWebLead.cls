@RestResource(UrlMapping='/generate/lead/*')
global without sharing  class RestServiceWebLead {

    @HttpPost
    global static void doPost() {
        RestResponse res = RestContext.response;

        RestRequest req = RestContext.request;

        Map<String, String> headersMap = req.headers;

        String userAgent =(headersMap.get('User-Agent')!=null) ? headersMap.get('User-Agent') : '';
        String productInterest = req.params.get('fields[productInterested][value]').replace('+',' ');
        String email = req.params.get('fields[email][value]');
        String company = req.params.get('fields[websiteSource][value]');
        String website = (String.isNotEmpty(userAgent) && userAgent.contains(';')) ? userAgent.split(';').get(1):'';
        String origin=company;
        if(website!=null && String.isNotEmpty(website) && website.contains('www.')) origin=website.substringBetween('://www.', '.');
        else if(website!=null && String.isNotEmpty(website) ) origin=website.substringBetween('://', '.');
        
      
          
        verifyAndCreateAccount(email,productInterest,origin,website);
        
        
        res.statusCode = 200;
    }
    
    
    public static void verifyAndCreateAccount(String email,String subProductName,String origin,String website){
        List<Account> accountDetails=[SELECT id,(Select id,Source__c,Type__c,Subscription_Status__c from Subscriptions__r WHERE Type__c=:subProductName AND RecordTypeId=:Constant.SUBSCRIPTION_DEFAULT_RECORDTYPEID LIMIT 1) 
                                      FROM Account WHERE PersonEmail=:email AND isPersonAccount=true];
        //exsisitng account
        if(accountDetails.size()>0){
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
            accountLead.RecordTypeId=Constant.PERSON_ACCOUNT_RECORDTYPEID;
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