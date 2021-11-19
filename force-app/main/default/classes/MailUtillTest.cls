@isTest
public class MailUtillTest {
    
    @isTest
    static void sendEmailWithAttachmentTest(){
        Account a=TestDataFactory.getPersonAccount(true);
        Case c=TestDataFactory.getBankCase(a.id,true);
        Test.startTest();
        Boolean emailSet= MailUtill.sendEmailWithAttachment('Test Subject', 'Test Email',new List<String>{},Userinfo.getUserEmail(),Constant.EV_SUPPORT_OWD_EMAIL,c.Id);
        System.assert(emailSet);
        Test.stopTest();
        
    }
     @isTest
    static void sendEmailWithAttachmentTestNegative(){
        Account a=TestDataFactory.getPersonAccount(true);
        Case c=TestDataFactory.getBankCase(a.id,true);
        Test.startTest();
        MailUtill.logEmailError(c.id, 'errorMsg', 'sendEmailWithAttachmentTestNegative');
        Test.stopTest();
        
    }
    @istest
    static void proccessEmailTemplateTest(){
        Account a=TestDataFactory.getPersonAccount(true);
        Case c=TestDataFactory.getBankCase(a.id, true);
        Case ic=TestDataFactory.getCaseInvestment(a.Id,false);
        ic.AccountId=null;
        ic.ContactId=null;
        ic.Customer_Id__c=a.Auth0_ID__c;
        insert ic;
        String accountBody=Constant.DEFAULT_EV_TEMPLATE_START+'{!Account.LastName}'+Constant.DEFAULT_EV_TEMPLATE_END;
        String formatedBody=MailUtill.proccessEmailTemplate(accountBody, true, 'Case', c.Id);
        System.assert(formatedBody.contains(a.LastName));
         Test.startTest();
        MailUtill.sendPlainHtmlEmail('Subject', formatedBody, 'test@user.con',Constant.EV_SUPPORT_OWD_EMAIL, a.id);
        Test.stopTest();
    }
    @isTest
    static void sendTemplateEmailtest(){
        Account a=TestDataFactory.getPersonAccount(true);
        Contact c=[SELECT id fROM Contact LIMIT 1];
        MailUtill.sendTemplateEmail('user@ev.com', c.Id,a.Id,Constant.ACCOUNT_REFREAL_NEW_USER_EMAILTEMPLATE, Constant.EV_SUPPORT_OWD_EMAIL);
    }
    
    
}