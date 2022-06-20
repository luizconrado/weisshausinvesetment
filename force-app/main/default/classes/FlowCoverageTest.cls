/***************
* @group Test Class
* @description test class for all flows in system
*/
@isTest
public class FlowCoverageTest {

    @isTest
    static void Seizure_Insert_Create_Notification(){
        Account a=TestDataFactory.getPersonAccount(true);
        Seizure__c sei=TestDataFactory.getSeziure(a.Id,True);
    }
    
    @isTest
    static void Subscription_Insert_Update_Send_Email(){
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Contact c=[SELECT id FROM Contact WHERE accountId=:a.Id];
        Subscription__c sub=TestDataFactory.getNewsletterSubscription(a.Id, c.Id,true);
        Test.startTest();
        sub.Subscription_Status__c='Awaiting Confirmation';
        sub.Send_Mail__c=true;
        update sub;
        Test.stopTest();
        
    }
    
    @isTest
    static void Opportunity_Update_Send_Stage_Status(){
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Opportunity o=TestDataFactory.getOpportunityInvestment(a.id,true);
        Test.startTest();
        o.StageName='ACTIVE';
        update o;
        Test.stopTest();
    }
    
    @isTest
    static void Product2_Insert_Send_data_to_external_system(){
        Test.startTest();
        Product2 prod=TestDataFactory.getInvesetmentProduct('Flow product',false);
        prod.Update_Website__c=true;
        insert prod;
        Test.stopTest();
    }
    @isTest
    static void Product2_Update_Send_data_to_external_system(){
        Product2 prod=TestDataFactory.getInvesetmentProduct('Flow product',true);
        Test.startTest();
        prod.Update_Website__c=true;
        update prod;
        Test.stopTest();
    }
    @isTest
    static void Customer_Classification_Update_Set_System_Status(){
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Customer_Classification__c cc=TestDataFactory.getProfessionalCustomerClassfication(a.Id,true);
        Test.startTest();
        cc.Internal_Approval__c='Customer Approved';
        update cc;
        Test.stopTest();
    }



}