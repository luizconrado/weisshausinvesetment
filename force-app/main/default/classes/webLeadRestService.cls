@RestResource(UrlMapping='/generate/lead/*')
global without sharing  class webLeadRestService {

    @HttpPost
    global static void doPost() {
        RestResponse res = RestContext.response;

        RestRequest req = RestContext.request;

        Map<String, String> headersMap = req.headers;

        String userAgent =(headersMap.get('User-Agent')!=null) ? headersMap.get('User-Agent') : '';
        String productInterest = req.params.get('fields[productInterested][value]');
        String email = req.params.get('fields[email][value]');
        String company = req.params.get('fields[websiteSource][value]');
        String website = (String.isNotEmpty(userAgent) && userAgent.contains(';')) ? userAgent.split(';').get(1):'';
        System.debug('headersMap '+headersMap);
        System.debug('req.params '+req.params);
        
        Account accountLead=new Account();
        accountLead.PersonEmail = email;
        accountLead.ProductInterest__pc=productInterest.replace('+',' ');
        accountLead.LastName = '[Not Provided]';
        accountLead.Type ='Prospect';
        accountLead.Website=website;
        accountLead.RecordTypeId=Constant.PERSON_ACCOUNT_RECORDTYPEID;
        
        if(accountLead.Website!=null && String.isNotEmpty(accountLead.Website) && website.contains('www.')) accountLead.Origin__pc=website.substringBetween('://www.', '.');
           
        else if(accountLead.Website!=null && String.isNotEmpty(accountLead.Website) ) accountLead.Origin__pc=website.substringBetween('://', '.');
          
        
        accountDupeMerge(accountLead);
        
        res.statusCode = 200;
    }
    
    /*
     * Description: called from webhook to check and update exsisting accounts
     * email:sends verify account email as external user
	*/
    private static void accountDupeMerge(Account accountLeadRec) {
        Map<String, String> productCodeAPIMap = Constant.PRODUCT_CONFIGURATION;
        List<String> personAccountFields=new List<String>();
        for(String apiName:productCodeAPIMap.values()) personAccountFields.add(apiname.replace('__c','__pc'));
        String email=accountLeadRec.PersonEmail;
        String accountQuery = 'SELECT Id,Phone ,LastName, FirstName, MiddleName, Suffix ,Last_Email_Sent_Date__pc,Origin__pc,PersonEmail,Gender__pc,ProductInterest__pc,'+String.join(personAccountFields,',')+' FROM Account WHERE PersonEmail =:email';
        List<Account> existingAccounts = Database.query(accountQuery);
        
        //Update Account
        if(existingAccounts.size()>0){
            Account accountMaster=existingAccounts.get(0);
            String fieldApi=productCodeAPIMap.get(accountLeadRec.ProductInterest__pc).replace('__c','__pc');
            //updataing product status on person account account 
            if (accountMaster.get(fieldApi) == null 
                || accountMaster.get(fieldApi) == 'Not Subscribed'  || accountMaster.get(fieldApi) == 'Unsubscribed'   || accountMaster.get(fieldApi) == 'Confirmation Resent') {
                    accountMaster.put(fieldApi, 'Awaiting Confirmation');
                    accountMaster.Last_Email_Sent_Date__pc=Date.today();
            } 
            accountMaster.put('ProductInterest__pc', accountLeadRec.ProductInterest__pc);
            update accountMaster;
            sendVerificationEmail(accountMaster.Id);
        }
        //New Account
        else{
            
            //updatating product status 
            if (accountLeadRec.get(productCodeAPIMap.get(accountLeadRec.ProductInterest__pc).replace('__c','__pc')) == null  || accountLeadRec.get(productCodeAPIMap.get(accountLeadRec.ProductInterest__pc).replace('__c','__pc')) == 'Not Subscribed'   || accountLeadRec.get(productCodeAPIMap.get(accountLeadRec.ProductInterest__pc).replace('__c','__pc')) == 'Unsubscribed'  || accountLeadRec.get(productCodeAPIMap.get(accountLeadRec.ProductInterest__pc).replace('__c','__pc')) == 'Confirmation Resent') {
                accountLeadRec.put(productCodeAPIMap.get(accountLeadRec.ProductInterest__pc).replace('__c','__pc'), 'Awaiting Confirmation');
                accountLeadRec.Last_Email_Sent_Date__pc=Date.today();
            }
            insert accountLeadRec;
            sendVerificationEmail(accountLeadRec.Id);

        }
        
    }
    
    //helpers
    private static void sendVerificationEmail(String accountId){
        Contact personContact=[SELECT id,Email FROM Contact WHERE AccountId=:accountId AND Account.ispersonaccount=true];
        MailUtility.sendAccountHtmlEmail(personContact.Id, accountId, Constant.ACCOUNT_VERIFY_EMAIL_TEMPLATE, personContact.Email);
    }
    
}