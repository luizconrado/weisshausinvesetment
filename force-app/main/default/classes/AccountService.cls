public with sharing  class AccountService {
	 //Buttons
     /*
     * Description: resends verification email to Account
     * email:sends verify account email as intenral user
	*/
    @AuraEnabled
    public static void sendEmailToAccount(String accountId,String emailToProducts){
        List<Account> acclist=[Select id,Newsletter__pc,ProductInterest__pc,Last_Email_Sent_Date__pc,(Select id,Email FROM Contacts) FROM Account where id=:accountId];
        Map<String,Object> emailProductMap=(Map<String,Object>)JSON.deserializeUntyped(emailToProducts);
        if(acclist.size()>0){
            Account accRec=acclist.get(0);
            if(((Boolean)emailProductMap.get('newsletter'))==true){
                accRec.Newsletter__pc='Confirmation Resent';
                accRec.ProductInterest__pc='Newsletter';
                accRec.Last_Email_Sent_Date__pc=Date.today();
                update accRec;
                MailUtility.sendAccountHtmlEmail(accRec.Contacts.get(0).Id,accRec.Id, Constant.ACCOUNT_VERIFY_EMAIL_TEMPLATE, accRec.Contacts.get(0).Email);
            }
            if(((Boolean)emailProductMap.get('productA'))==true){
                accRec.Product_A__pc='Confirmation Resent';
                accRec.ProductInterest__pc='Product A';
                accRec.Last_Email_Sent_Date__pc=Date.today();
                update accRec;
                MailUtility.sendAccountHtmlEmail(accRec.Contacts.get(0).Id,accRec.Id,Constant.ACCOUNT_VERIFY_EMAIL_TEMPLATE, accRec.Contacts.get(0).Email);
            }
        }
        
        
    }
    
    @AuraEnabled
    public static List<History_Tracker__c> getLastEmailToAccountInfo(String accountId){
        return [SELECT id,User__r.Name,Field__c,New_Value__c,CreatedDate FROM History_Tracker__c WHERE Object__c='Account' AND  Field__c='ProductInterest__pc' AND Record_Id__c=:accountId ORDER BY CreatedDate Desc];
    }
    
}