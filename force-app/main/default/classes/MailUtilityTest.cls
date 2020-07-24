@isTest
private class MailUtilityTest {

    @isTest
    static void sendMailsTest(){
        Email_Configuration__c config = new Email_Configuration__c();
        config.Send_Subscribed_Email__c=true;
        insert config;
        Lead l=TestDataFactory.getWebLead(true);
        Account a=TestDataFactory.getPersonAccount(true);
        MailUtility.sendLeadHtmlEmail(l.Id, Constant.LEAD_SUBSCRIBED_EMAIL_TEMPLATE, l.Email);
        Contact c=[Select id FROM Contact];
        MailUtility.sendAccountHtmlEmail(c.id,a.id, Constant.ACCOUNT_SUBSCRIBED_EMAIL_TEMPLATE,a.PersonEmail);
    }
}