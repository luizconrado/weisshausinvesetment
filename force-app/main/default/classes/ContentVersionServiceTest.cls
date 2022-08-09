/***************
* @group Test Class
* @description test class for ContentVersionService
*/
@isTest
public class ContentVersionServiceTest {
     
    @isTest 
    static void sendDocumentInfoToEVTest(){
        Test.setMock(HttpCalloutMock.class, new EVExternalServiceTest.EVMockResponse());
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Opportunity opp=TestDataFactory.getOpportunityInvestment(a.Id,true);
        ContentVersion cv=TestDataFactory.getContentVersion(true);
        TestDataFactory.linkContentDocumentToRecord(cv.id,opp.id);
        User u=TestDataFactory.getUser('Integration');
    
        System.runAs(u){
            Test.startTest();
            ContentVersionService.sendDocumentInfoToEV(new List<String>{cv.id});
            Test.stopTest();
        
        }
        
    }
    @isTest
    static void sendDocumentInfoToEVNegetiveTest(){
        Test.setMock(HttpCalloutMock.class, new EVExternalServiceTest.EVMockResponse(true));
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Opportunity opp=TestDataFactory.getOpportunityInvestment(a.Id,true);
        ContentVersion cv=TestDataFactory.getContentVersion(true);
        TestDataFactory.linkContentDocumentToRecord(cv.id,opp.id);
        User u=TestDataFactory.getUser('Integration');
    
        System.runAs(u){
            Test.startTest();
            ContentVersionService.sendDocumentInfoToEV(new List<String>{cv.id});
            Test.stopTest();
        
        }
        
    }

}