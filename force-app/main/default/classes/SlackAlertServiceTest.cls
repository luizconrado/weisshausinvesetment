/***************
* @group Test Class
* @description test class for SlackAlertService
*/
@isTest
public class SlackAlertServiceTest { 
    
    @isTest
    static void slackSupportedObjectsTest(){
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Opportunity o=TestDataFactory.getOpportunityInvestment(a.Id,true);
        KYC_Detail__c kyc=TestDataFactory.getKYCVideoIdentification(a.Id,true);
        Customer_Classification__c c=TestDataFactory.getProfessionalCustomerClassfication(a.Id,true);
    }

    @isTest
    static void invokeAlertInsertTest(){
        Test.startTest();
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Test.stopTest();
    }
    @isTest
    static void invokeAlertUpdateTest(){
        Account a=TestDataFactory.getPersonInvestmentAccount(true);

        Test.startTest();
        a.PersonEmail='test@test.com';
        update a;
        Test.stopTest();
    }
    
    
}