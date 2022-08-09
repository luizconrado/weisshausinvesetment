/***************
* @group Test Class
* @description test class for CommunitySupportBankingLead
*/@isTest
public class CommunitySupportBankingLeadTest {

    @isTest
    static void createBankingLeadSuccessTest(){
        Test.startTest();
        User u=TestDataFactory.getUser('Integration');
        System.runAs(u){
            CommunitySupportBankingLeadController.createBankingLead('Herr', 'firstName', 'lastName', 'emailAddress@ev.com', new Map<String,String>{'utm_term'=>'testclass'});
        }
        Test.stopTest();
        Lead l=[select id,UTM_Term__c FROM Lead];
        System.assert(l.UTM_Term__c=='testclass');
    }
    @isTest
    static void createBankingLeadExceptionTest(){
        Test.startTest();
        User u=TestDataFactory.getUser('Integration');
        System.runAs(u){
            Boolean success=CommunitySupportBankingLeadController.createBankingLead('Herr', '', '', 'emailAddress@ev.com', new Map<String,String>{'utm_term'=>'testclass'});
            System.assert(success==false);
        }
        Test.stopTest();
         
    }
}