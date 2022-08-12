/***************
* @group Test Class
* @description test class for ContentVersionService
*/
@isTest
public class ContentVersionServiceTest {
    
    @testSetup
    static void setupData(){
        User u=TestDataFactory.getUser('Integration');
    
    }
     
    @isTest 
    static void sendDocumentInfoToEVTest(){
        Test.setMock(HttpCalloutMock.class, new EVExternalServiceTest.EVMockResponse());
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Opportunity opp=TestDataFactory.getOpportunityInvestment(a.Id,true);
        ContentVersion cv=TestDataFactory.getContentVersion(false);
        cv.FirstPublishLocationId=opp.id;
        insert cv;
        User u=[SELECT id FROM User WHERE Profile.Name='Integration' LIMIT 1];
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
        ContentVersion cv=TestDataFactory.getContentVersion(false);
        cv.FirstPublishLocationId=opp.id;
        insert cv;
        User u=[SELECT id FROM User WHERE Profile.Name='Integration' LIMIT 1];
        System.runAs(u){
            Test.startTest();
            ContentVersionService.sendDocumentInfoToEV(new List<String>{cv.id});
            Test.stopTest();
        
        }
        
    }
    
    @isTest
    static void sendCaseArchiveZipToEvTest(){
        Test.setMock(HttpCalloutMock.class, new EVExternalServiceTest.EVMockResponse(true));
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Case c=TestDataFactory.getCaseInvestment(a.Id,true);
        ContentVersion cv=TestDataFactory.getContentVersion(false);
        cv.FirstPublishLocationId=a.id;
        insert cv;
        User u=[SELECT id FROM User WHERE Profile.Name='Integration' LIMIT 1];
    
        System.runAs(u){
            Test.startTest();
            ContentVersionService.sendCaseArchiveZipToEv(new List<String>{cv.id});
            Test.stopTest();
        
        }
        
    }

}