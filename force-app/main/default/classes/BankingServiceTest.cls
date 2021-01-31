@isTest
public class BankingServiceTest {

    
    @isTest
    static void testStaticValues(){
        BankingService.checkIsCompactLayout();
        BankingService.getBankCaseTypes();
        BankingService.getCaseIITypes();
    }
    @isTest
    static void testupdateJiraInformationNegative(){
        Account a=TestDataFactory.getPersonAccount(true);
        Case c=TestDataFactory.getBankCase(a.id,true);
        try{
            Test.startTest();
            BankingService.updateJiraInformation('c.Id','String subject','String discription');
            
            Test.stopTest();
        }catch(Exception e){}
    }
    @isTest
    static void testupdateJiraInformation(){
        Account a=TestDataFactory.getPersonAccount(true);
        Case c=TestDataFactory.getBankCase(a.id,true);
        BankingService.retriveCaseDetails(a.Id);
        BankingService.retriveProcessKnowlodge('MDM','ACS');
         
		Test.startTest();
        BankingService.updateJiraInformation(c.Id,'String subject','String discription');
        BankingService.retriveContentVersionList(c.Id);
        Case cc=[SELECT JIRA_Description__c  FROM CASE LIMIT 1];
        System.assert(cc.JIRA_Description__c !=null);
 		Test.stopTest();
    }
}