/***************
* @group Test Class
* @description test class for OpportuntiyInvestmentService 
*/
@isTest
public class OpportuntiyInvestmentServiceTest {
    
    @isTest 
    static void sendInvestmentMoneyTransferdStatusTest(){
        Test.setMock(HttpCalloutMock.class, new EVExternalServiceTest.EVMockResponse());
        Account a=TestDataFactory.getPersonAccount(true);
        Opportunity opp=TestDataFactory.getOpportunityInvestment(a.Id,true);
        Test.startTest();
        OpportuntiyInvestmentService.sendMoneyTransferConformation(opp.id);
        Test.stopTest();
    }
     @isTest
    static void sendInvestmentMoneyTransferdStatusExceptionTest(){
        Test.setMock(HttpCalloutMock.class, new EVExternalServiceTest.EVMockResponse());
        Account a=TestDataFactory.getPersonAccount(true);
        Opportunity opp=TestDataFactory.getOpportunityInvestment(a.Id,false);
        opp.External_Id__c=null;
        Test.startTest();
        try{
        OpportuntiyInvestmentService.sendMoneyTransferConformation(opp.id);
        }Catch(Exception e){}
        Test.stopTest();
    }

}