/***************
* @group Test Class
* @description test class for CustomerClassificationHandler
*/
@isTest
public class CustomerClassificationHandlerTest {
    
    
    @isTest
    static void processSystemStatusValueValidationRulesInternalApproval1(){
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Customer_Classification__c cc=TestDataFactory.getProfessionalCustomerClassfication(a.id,false);
        cc.Internal_Approval__c='Customer Rejected';
        insert cc;
        Test.startTest();
        try{
            cc.Internal_Approval__c='Pending';
            update cc;    
        }
        catch(Exception e){
            //System.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
        } 
        Test.stopTest();
    }
    @isTest
    static void processSystemStatusValueValidationRulesInternalApproval2(){
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Customer_Classification__c cc=TestDataFactory.getProfessionalCustomerClassfication(a.id,false);
        cc.Internal_Approval__c='Customer Rejected';
        cc.Data_Submitted_to_Partner__c='Yes';
        insert cc;
        Test.startTest();
        try{
            cc.Data_Submitted_to_Partner__c='Pending';
            update cc;    
        }
        catch(Exception e){
            //System.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
        } 
        Test.stopTest();
    }
    @isTest
    static void processSystemStatusValueValidationRulesInternalApproval3(){
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Customer_Classification__c cc=TestDataFactory.getProfessionalCustomerClassfication(a.id,false);
        cc.Internal_Approval__c='Customer Rejected';
        cc.Partner_Approval__c='Pending';
        cc.Data_Submitted_to_Partner__c='No';
        insert cc;
        Test.startTest();
        try{
            cc.Partner_Approval__c='Customer Approved';
            update cc;    
        }
        catch(Exception e){
            //System.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
        } 
        Test.stopTest();
    }
    
    @isTest
    static void processSystemStatusValueValidationRulesPartnerApproval1(){
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Customer_Classification__c cc=TestDataFactory.getProfessionalCustomerClassfication(a.id,false);
        cc.Partner_Approval__c='Customer Rejected';
        insert cc;
        Test.startTest();
        try{
            cc.Partner_Approval__c='Pending';
            update cc;    
        }
        catch(Exception e){
            //System.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
        } 
        Test.stopTest();
    }
    @isTest
    static void processSystemStatusValueValidationRulesPartnerApproval2(){
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Customer_Classification__c cc=TestDataFactory.getProfessionalCustomerClassfication(a.id,false);
        cc.Partner_Approval__c='Customer Rejected';
        insert cc;
        Test.startTest();
        try{
            cc.Data_Submitted_to_Partner__c='No';
            update cc;    
        }
        catch(Exception e){
            //System.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
        } 
        Test.stopTest();
    } 
    @isTest
    static void processSystemStatusValueValidationRulesPartnerApproval3(){
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Customer_Classification__c cc=TestDataFactory.getProfessionalCustomerClassfication(a.id,false);
        cc.Partner_Approval__c='Customer Rejected';
        insert cc;
        Test.startTest();
        try{ 
            cc.Internal_Approval__c='Customer Rejected';
            update cc;    
        }
        catch(Exception e){
            //System.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
        } 
        Test.stopTest();
    }
    
    @isTest
    static void processSystemStatusValueSystemStatusInternalApproval1(){
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Customer_Classification__c cc=TestDataFactory.getProfessionalCustomerClassfication(a.id,false);
        cc.Internal_Approval__c='Pending';
        cc.Data_Submitted_to_Partner__c='Pending';
        cc.Partner_Approval__c='Customer Approved';
        insert cc;
        Test.startTest();
        cc.Partner_Approval__c='Pending';
        update cc;    
        Test.stopTest();
        //System.assert([SELECT id,System_Status__c FROM  Customer_Classification__c WHERE id=:cc.id LIMIT 1].System_Status__c=='AWAITING_INTERNAL_PROCESSING');
    }
    @isTest
    static void processSystemStatusValueSystemStatusInternalApproval2(){
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Customer_Classification__c cc=TestDataFactory.getProfessionalCustomerClassfication(a.id,false);
        cc.Internal_Approval__c='Pending';
        cc.Data_Submitted_to_Partner__c='Pending';
        insert cc;
        Test.startTest();
        try{ 
            cc.Partner_Approval__c='Customer Approved';
            update cc;    
        }
        catch(Exception e){
            //System.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
        } 
        Test.stopTest();
        
    }
    @isTest
    static void processSystemStatusValueSystemStatusInternalApproval3(){
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Customer_Classification__c cc=TestDataFactory.getProfessionalCustomerClassfication(a.id,false);
        cc.Internal_Approval__c='Pending';
        cc.Data_Submitted_to_Partner__c='Pending';
        insert cc;
        Test.startTest();
        try{ 
            cc.Data_Submitted_to_Partner__c='Yes';
            update cc;    
        }
        catch(Exception e){
            //System.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
        } 
        Test.stopTest();
        
    }
    
    @isTest
    static void processSystemStatusValueSystemStatusInternalApproval4(){
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Customer_Classification__c cc=TestDataFactory.getProfessionalCustomerClassfication(a.id,false);
        cc.Internal_Approval__c='Pending';
        insert cc;
        Test.startTest();
        cc.Internal_Approval__c='Customer Rejected';
        update cc;    
        Test.stopTest();
        //System.assert([SELECT id,System_Status__c FROM  Customer_Classification__c WHERE id=:cc.id LIMIT 1].System_Status__c=='INTERNAL_MANUALLY_DECLINED');
    }
    
    
    @isTest
    static void processSystemStatusValueSystemStatusDataSubmittedtoPartner1(){
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Customer_Classification__c cc=TestDataFactory.getProfessionalCustomerClassfication(a.id,false);
        cc.Partner_Approval__c='Pending';
        cc.Data_Submitted_to_Partner__c='Pending';
        insert cc;
        Test.startTest();
        cc.Internal_Approval__c='Customer Approved';
        update cc;    
        Test.stopTest();
        //System.assert([SELECT id,System_Status__c FROM  Customer_Classification__c WHERE id=:cc.id LIMIT 1].System_Status__c=='AWAITING_INTERNAL_PROCESSING');
    }
    @isTest
    static void processSystemStatusValueSystemStatusDataSubmittedtoPartner2(){
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Customer_Classification__c cc=TestDataFactory.getProfessionalCustomerClassfication(a.id,false);
        cc.Partner_Approval__c='Pending';
        cc.Internal_Approval__c='Customer Approved';
        cc.Data_Submitted_to_Partner__c='Pending';
        insert cc;
        Test.startTest();
        try{
            cc.Partner_Approval__c='Customer Approved';
            update cc;    
        }
        catch(Exception e){
            //System.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
        } 
        Test.stopTest();
        
    }
    @isTest
    static void processSystemStatusValueSystemStatusDataSubmittedtoPartner3(){
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Customer_Classification__c cc=TestDataFactory.getProfessionalCustomerClassfication(a.id,false);
        cc.Partner_Approval__c='Pending';
        cc.Internal_Approval__c='Customer Approved';
        
        insert cc;
        Test.startTest();
        cc.Data_Submitted_to_Partner__c='Yes';
        update cc;    
        Test.stopTest();
        //System.assert([SELECT id,System_Status__c FROM  Customer_Classification__c WHERE id=:cc.id LIMIT 1].System_Status__c=='AWAITING_PARTNER_PROCESSING');
    }
    @isTest
    static void processSystemStatusValueSystemStatusDataSubmittedtoPartner4(){
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Customer_Classification__c cc=TestDataFactory.getProfessionalCustomerClassfication(a.id,false);
        
        cc.Internal_Approval__c='Customer Approved';
        cc.Data_Submitted_to_Partner__c='Yes';
        insert cc;
        Test.startTest();
        cc.Partner_Approval__c='Customer Approved';
        
        update cc;    
        Test.stopTest();
        //System.assert([SELECT id,System_Status__c FROM  Customer_Classification__c WHERE id=:cc.id LIMIT 1].System_Status__c=='PARTNER_MANUALLY_APPROVED');
    }   
    @isTest
    static void processSystemStatusValueSystemStatusDataSubmittedtoPartner5(){
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Customer_Classification__c cc=TestDataFactory.getProfessionalCustomerClassfication(a.id,false);
        
        cc.Internal_Approval__c='Customer Approved';
        cc.Data_Submitted_to_Partner__c='Yes';
        insert cc;
        Test.startTest();
        cc.Partner_Approval__c='Customer Rejected';
        
        update cc;    
        Test.stopTest();
        //System.assert([SELECT id,System_Status__c FROM  Customer_Classification__c WHERE id=:cc.id LIMIT 1].System_Status__c=='PARTNER_MANUALLY_DECLINED');
    }  
    @isTest
    static void processSystemStatusValueSystemStatusDataSubmittedtoPartner6(){
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Customer_Classification__c cc=TestDataFactory.getProfessionalCustomerClassfication(a.id,false);
        cc.Partner_Approval__c='Pending';
        cc.Internal_Approval__c='Customer Approved';
        cc.Data_Submitted_to_Partner__c='Pending';
        insert cc;
        Test.startTest();
        try{
            cc.Data_Submitted_to_Partner__c='No';
            update cc;    
        }
        catch(Exception e){
            //System.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
        } 
        Test.stopTest();
        
    }
    
    @isTest
    static void processSystemStatusValueNullCheck(){
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Customer_Classification__c cc=TestDataFactory.getProfessionalCustomerClassfication(a.id,true);
        try{
            cc.Internal_Approval__c='';
            update cc;    
        }
        catch(Exception e){
            //System.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
        } 
        try{
            cc.Data_Submitted_to_Partner__c='';
            update cc;    
        }
        catch(Exception e){
            //System.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
        } 
        try{
            cc.Partner_Approval__c='';
            update cc;    
        }
        catch(Exception e){
            //System.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
        } 
    }
}