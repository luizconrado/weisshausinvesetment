/***************
* @group Test Class
* @description test class for AgentReferalFormController
*/
@isTest
public class AgentReferalFormControllerTest {
    
    @testSetup
    static void generateCodes(){
        Referral_Codes__c code1=new Referral_Codes__c();
        code1.name=RandomUtil.randomString(8);
        insert code1;
        Referral_Codes__c code2=new Referral_Codes__c();
        code2.name=RandomUtil.randomString(8);
        insert code2;
    }
    
    @isTest
    static void getBuninessAccountNameTest(){
        Account a=TestDataFactory.getBusinessAccount(true);
        AgentReferalFormController.getBuninessAccountName(a.Name);
    } 
    @isTest
    static void getNewRefralCodeEmpty(){
        List<Referral_Codes__c> codes=[SELECT Id,Used__c FROM Referral_Codes__c];
        for(Referral_Codes__c rf:codes){
            rf.Used__c=true;
        }
        update codes;
        AgentReferalFormController.getNewRefralCode();
    }
    @isTest
    static void attachPersonToBusinessException(){
        try{
        AgentReferalFormController.attachPersonToBusiness(null,null);
        }catch(Exception e){}
    }
    @isTest
    static void getNewPersonAccountCode(){
        User integrationUser=TestDataFactory.getUser('Integration');
        Test.startTest();
        System.runAs(integrationUser){
            String payload='{';
            payload+='"email":"user@ev.com",';
            payload+='"isPersonAccount":true,';
            payload+='"isExsistingCustomer":true,';
            payload+='"firstname":"test",';
            payload+='"lastname":"user",';
            payload+='"salutation":"Herr",';
            payload+='"phone":"+4912345678"';
            payload+='}';
            AgentReferalFormController.fetchCustomerReferalCode(payload);
        }
        
        Test.stopTest();
        
        
    }
    @isTest
    static void getExstingPersonAccountCode(){
        Account a=TestDataFactory.getPersonAccount(false);
        a.Origin__pc='integration_test';
        a.Inviter_Code__pc=RandomUtil.randomString(8);
        insert a;
        User integrationUser=TestDataFactory.getUser('Integration');
        Test.startTest();
        System.runAs(integrationUser){
            String payload='{';
            payload+='"email":"'+a.PersonEmail+'",';
            payload+='"isPersonAccount":true,';
            payload+='"isExsistingCustomer":true,';
            payload+='"firstname":"test",';
            payload+='"lastname":"user",';
            payload+='"salutation":"Herr",';
            payload+='"phone":"+4912345678"';
            payload+='}';
            AgentReferalFormController.fetchCustomerReferalCode(payload);
        }
        
        Test.stopTest();
        
        
    }
    @isTest
    static void getNewPersonAccountWithBusinessAccountCode(){
        Account businessAccount=TestDataFactory.getBusinessAccount(True);
        User integrationUser=TestDataFactory.getUser('Integration');
        Test.startTest();
        System.runAs(integrationUser){
            String payload='{';
            payload+='"email":"user@ev.com",';
            payload+='"isPersonAccount":true,'; 
            payload+='"isExsistingCustomer":true,';
            payload+='"firstname":"test",';
            payload+='"lastname":"user",';
            payload+='"salutation":"Herr",'; 
            payload+='"phone":"+4912345678",';
            payload+='"companyId":"'+businessAccount.Id+'"';
            
            payload+='}';
            AgentReferalFormController.fetchCustomerReferalCode(payload);
        }
        
        Test.stopTest();
        
        
    }
    @isTest
    static void getExsisitngPersonAccountCode(){
        User integrationUser=TestDataFactory.getUser('Integration');
        Account personAccount=TestDataFactory.getPersonAccount(true);
        Referral_Codes__c rc=[SELECT id,NAME FROM Referral_Codes__c LIMIT 1];
        personAccount.Inviter_Code__pc=rc.Name;
        personAccount.Inviter_Code_T_C_Date__pc=DateTime.now();
        update personAccount;
        Test.startTest();
        System.runAs(integrationUser){
            String payload='{';
            payload+='"email":"'+personAccount.PersonEmail+'",';
            payload+='"isPersonAccount":true,';
            payload+='"isExsistingCustomer":true,';
            payload+='"firstname":"test",';
            payload+='"lastname":"user",';
            payload+='"salutation":"Herr",';
            payload+='"phone":"+4912345678"';
            payload+='}';
            String referalCode=AgentReferalFormController.fetchCustomerReferalCode(payload);
            System.assertEquals(rc.Name, referalCode);
        }
        
        Test.stopTest();
        
        
    }
    @isTest
    static void getNewBusinessAccount(){
        User integrationUser=TestDataFactory.getUser('Integration');
        Test.startTest();
        System.runAs(integrationUser){
            String payload='{';
            payload+='"email":"user@ev.com",';
            payload+='"isPersonAccount":false,';
            payload+='"isExsistingCustomer":true,';
            payload+='"firstname":"test",';
            payload+='"accountName":"testCompany",';
            payload+='"bankName":"testCompany",';
            payload+='"bankIban":"DE1234",';
            payload+='"lastname":"user",';
            payload+='"salutation":"Frau",';
            payload+='"phone":"+4912345678"';
            payload+='}';
            AgentReferalFormController.fetchCustomerReferalCode(payload);
        }
        
        Test.stopTest();
    }
    @isTest
    static void getExsistingBusinessAccount(){
        User integrationUser=TestDataFactory.getUser('Integration');
        Account a=TestDataFactory.getBusinessAccount(true);
        Referral_Codes__c rc=[SELECT id,NAME FROM Referral_Codes__c LIMIT 1];
        a.Inviter_Code__c=rc.Name;
        a.Inviter_Code_T_C_Date__c=DateTime.now();
        a.Business_IBAN__c='DE1234';
        update a;
        Test.startTest();
        System.runAs(integrationUser){
            String payload='{';
            payload+='"email":"user@ev.com",';
            payload+='"isPersonAccount":false,';
            payload+='"isExsistingCustomer":true,';
            payload+='"firstname":"test",';
            payload+='"accountName":"testCompany",';
            payload+='"bankName":"testCompany",';
            payload+='"bankIban":"'+a.Business_IBAN__c+'",';
            payload+='"lastname":"user",';
            payload+='"salutation":"Herr",';
            payload+='"phone":"+4912345678"';
            payload+='}';
            String referalCode=AgentReferalFormController.fetchCustomerReferalCode(payload);
            System.assertEquals(rc.Name,referalCode);
        }
        
        Test.stopTest();
    }
}