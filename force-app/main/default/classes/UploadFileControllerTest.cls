@isTest
public class UploadFileControllerTest {
    @testSetup
    static void testSetup(){
        insert new Contentversion(Title = 'ABC',Type__c='Draft', PathOnClient = 'test', VersionData = EncodingUtil.base64Decode('Unit Test Attachment Body'));
    }
    
    @isTest
    static void testgetOptions(){
        Account a=TestDataFactory.getPersonAccount(true);
        Case c=TestDataFactory.getBankCase(a.Id,true);
        ContentVersion file=[SELECT Id, ContentDocumentId FROM ContentVersion LIMIT 1];
        Test.startTest();
        UploadFileController.getOptions('Case',c.Id);
        UploadFileController.retriveTagedVersions('Case',c.Id,'Tag');
        UploadFileController.tagVersionFiles('Case',c.Id,'Tag',new List<String> {file.ContentDocumentId});
        Test.stopTest();
    }

}