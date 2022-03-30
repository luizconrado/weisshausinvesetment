@isTest
public class BankingServiceTest {

    
    @isTest
    static void testStaticValues(){
        BankingService.checkIsCompactLayout();
        BankingService.getBankCaseTypes();
        BankingService.getCaseIITypes();
        BankingService.retriveDefaultTemplatHtml();
    }
    @isTest
    static void testupdateJiraInformationNegative(){
        Account a=TestDataFactory.getPersonAccount(true);
        Case c=TestDataFactory.getBankCase(a.id,true);
        try{
            Test.startTest();
            BankingService.updateJiraInformation('c.Id','String subject','String discription',new List<String>{});
            
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
        BankingService.updateJiraInformation(c.Id,'String subject','String discription',new List<String>{});
        BankingService.retriveContentVersionList(c.Id);
        Case cc=[SELECT JIRA_Description__c  FROM CASE LIMIT 1];
        System.assert(cc.JIRA_Description__c !=null);
 		Test.stopTest();
    }
    @isTest
    static void testretriveBankBalanceDetails(){
        Test.setMock(HttpCalloutMock.class, new SolarisBankTaxIdentificationWrapper.MockResponse());

        Account a=TestDataFactory.getPersonAccount(true);
        Bank_Account__c bc=TestDataFactory.getBankAccount(a.id,true);
        Test.startTest();
        
        BankingService.retriveBankBalanceDetails(bc.Id);
        Test.stopTest();
    }
  
    @isTest
    static void testretriveIdentificationDetailsAndUpdate(){
        Test.setMock(HttpCalloutMock.class, new SolarisBankIdentificationWrapper.MockResponse());
        Account a=TestDataFactory.getPersonAccount(true);
        KYC_Detail__c ident=TestDataFactory.getKYCVideoIdentification(a.Id,true);
        Test.startTest();
        BankingService.retriveIdentificationDetailsAndUpdate(ident.id);
        Test.stopTest();

    }
 
}