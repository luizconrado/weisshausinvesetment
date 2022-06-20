@isTest
public class EmailMessageTriggerHandlerTest {

    @isTest
    static void testEmailAttachmentToExsistingCase(){
        Account acc=TestDataFactory.getPersonAccount(true);
        Case oldCase=TestDataFactory.getBankCase(acc.id,true);
        Case newCase=TestDataFactory.getBankCase(acc.id,false);
        newCase.Subject=oldCase.Subject;
        insert newCase;
        Test.startTest();
        
        
        //Insert emailmessage for case
        EmailMessage email = new EmailMessage();
        email.FromAddress = Label.Case_Jira_SupportEmail;
        email.Incoming = True;
        email.ToAddress= 'test@xyz.org';
        email.Subject = oldCase.Subject;
        email.HtmlBody = 'Test email body';
        email.ParentId=newCase.Id;
        insert email;
        
        Test.stopTest();
        System.assertEquals(1, [SELECT id FROM Case].size());
        
    }
    @isTest
    static void logErrorTest(){
        try{
            Integer i=1/0;
        }
        Catch(Exception e){
            EmailMessageTriggerHandler.logError(e,'logErrorTest');
        }
    }
}