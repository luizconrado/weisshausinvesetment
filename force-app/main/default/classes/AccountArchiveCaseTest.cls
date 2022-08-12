/***************
* @group Test Class
* @description Test Class for AccountArchiveCase
*/
@isTest
public class AccountArchiveCaseTest {
    
    @isTest
    static void inserRecord(){
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Contentversion cv=TestDataFactory.getContentVersion(false);
        cv.FirstPublishLocationId=a.Id;
        insert cv;
        Case ic=TestDataFactory.getCaseInvestment(a.id,true);
        case bc=TestDataFactory.getBankCase(a.id,true);
        Test.startTest();
        a.Deletion_Request__c=true;
        update a;
        
        Test.stopTest();
    }

    @isTest
    static void logRecordErrorTest(){
          
        Test.startTest();
        AccountArchiveCase scrable=new AccountArchiveCase(new List<String>{});
        scrable.logError('','','',null);
        Test.stopTest();
            
            
    }
}