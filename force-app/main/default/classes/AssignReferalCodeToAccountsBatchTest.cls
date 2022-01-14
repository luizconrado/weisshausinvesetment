@isTest
public class AssignReferalCodeToAccountsBatchTest {

    @isTest
    static void assignInveterCode(){
        Account a=TestDataFactory.getPersonAccount(true);
        Account a1=TestDataFactory.getPersonAccount(true);
        a1.Origin__pc='Referral Code Website';
        update a1;
        Referral_Codes__c code=new Referral_Codes__c();
        code.Name=RandomUtil.randomString(6);
        insert code;
        Referral_Codes__c code2=new Referral_Codes__c();
        code2.Name=RandomUtil.randomString(6);
        insert code2;
        Test.startTest();
        Database.executeBatch(new AssignReferalCodeToAccountsBatch());
        Test.stopTest();
        List<Referral_Codes__c> remaingCodes=[SELECT id FROM Referral_Codes__c WHERE Used__c=false];
        System.assert(remaingCodes.size()==0);
    }
}