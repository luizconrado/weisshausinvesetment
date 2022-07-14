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
        sub.Subscription_Status__c='Awaiting Confirmation';
        sub.Send_Mail__c=true;
        update sub;
         
        
    }
    
    @isTest
    static void KYC_Detail_Insert_Send_Notification_to_group(){
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        KYC_Detail__c kyc=TestDataFactory.getKYCVideoIdentification(a.id,true);
        
    }
    
    @isTest
    static void Opportunity_Update_Send_Stage_Status(){
      
        Test.setMock(HttpCalloutMock.class, new EVExternalServiceTest.EVMockResponse());
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Opportunity o=TestDataFactory.getOpportunityInvestment(a.id,true);
      
        o.StageName='ACTIVE';
        update o;
       
    }
    
    @isTest
    static void Product2_Insert_Send_data_to_external_system(){
        Test.setMock(HttpCalloutMock.class, new Product2ServiceTest.ProductMockResponse());
        
        Product2 prod=TestDataFactory.getInvesetmentProduct('Flow product',false);
        prod.Update_Website__c=true;
        insert prod;
       
    }
    @isTest
    static void Product2_Update_Send_data_to_external_system(){
        Test.setMock(HttpCalloutMock.class, new Product2ServiceTest.ProductMockResponse());
        Product2 prod=TestDataFactory.getInvesetmentProduct('Flow product',true);
       
        prod.Update_Website__c=true;
        update prod;
    
    }
    @isTest
    static void Customer_Classification_Update_Set_System_Status(){
        Test.setMock(HttpCalloutMock.class, new EVExternalServiceTest.EVMockResponse());
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Customer_Classification__c cc=TestDataFactory.getProfessionalCustomerClassfication(a.Id,false);
        cc.System_Status__c='ONGOING';
        insert cc;
        Test.startTest();
        cc.Internal_Approval__c='Customer Rejected';
        update cc;
        Test.stopTest();
        System.debug([SELECT id,System_Status__c From Customer_Classification__c]);
       
    }



}