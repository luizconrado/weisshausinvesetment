@isTest
public class KYCDetailTriggerHandlerTest {

    @isTest
    static void setAccountNameTest(){
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
         KYC_Detail__c kyc=TestDataFactory.getKYCVideoIdentification(a.Id,true);
     }
}