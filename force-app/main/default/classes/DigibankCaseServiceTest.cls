@isTest
public class DigibankCaseServiceTest { 
    @isTest
    static void constantsTest(){
        DigibankCaseService.retriveDefaultTemplatHtml();
        DigibankCaseService.checkIsCompactLayout();
    }
    @isTest
    static void fetchBugBodyTest(){
        Account a=TestDataFactory.getPersonAccount(true);
        Case c=TestDataFactory.getEVKontoCase(a.Id,true);
        Test.startTest();
        DigibankCaseService.fetchBugBody(c.Id);
        
        Test.stopTest();
        
    }
    
    @isTest
    static void prepareBugInfoBodyTest(){
        Account a=TestDataFactory.getPersonAccount(true);
        Case c=TestDataFactory.getEVKontoCase(a.Id,true);
        Contentversion  cv=TestDataFactory.getContentVersion(true);
        ContentDocumentLink cdl=new ContentDocumentLink();
        Contentversion cvv=[SELECT id,ContentDocumentId FROM Contentversion WHERE id=:cv.id];
        cdl.ContentDocumentId=cvv.ContentDocumentId;
        cdl.LinkedEntityId=c.id;
        insert cdl;
        Test.startTest();
        Boolean b=DigibankCaseService.prepareBugInfoBody(c.Id,'Hi','Subject');
        System.assert(b);
        Test.stopTest();
    }
    
   
}