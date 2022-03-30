@isTest
public class TaxExemptionFormControllerTest {
    
    @isTest
    static void getPersonAccountRecordTypeIdTest(){
        TaxExemptionFormController.getPersonAccountRecordTypeId();
    }
    
    @isTest
    static void getCustomerDetailsTest(){
        Account a=TestDataFactory.getPersonAccount(true);
        Bank_Account__c ba=TestDataFactory.getBankAccount(a.id,false);
        ba.Type__c='TERM_DEPOSIT';
        insert ba;
        Booking__c booking=TestDataFactory.getBooking(ba.Id,true);
        Test.startTest();
        TaxExemptionFormController.getCustomerDetails(a.Solarisbank_Id__c, a.Auth0_ID__c,ba.id);
        Test.stopTest();
    }
    
    @isTest
    static void initiateMFARequestTest(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCRPRequestWrapper.MockResponse());
        Account a=TestDataFactory.getPersonAccount(true);
        Bank_Account__c ba=TestDataFactory.getBankAccount(a.id,false);
        ba.Type__c='TERM_DEPOSIT';
        insert ba;
        Test.startTest();
        TaxExemptionFormController.initiateMFARequest(a.Solarisbank_Id__c, a.id);
        Test.stopTest();
    }
    
    @isTest
    static void initiateCRPRequestTestSuccess(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCRPRequestWrapper.MockResponse());
        Account a=TestDataFactory.getPersonAccount(true);
        Bank_Account__c ba=TestDataFactory.getBankAccount(a.id,false);
        ba.Type__c='TERM_DEPOSIT';
        insert ba;
        Test.startTest();
        TaxExemptionFormController.initiateCRPRequest(a.id, '{}');
        Test.stopTest();
    }
    @isTest
    static void initiateCRPRequestTestError(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCRPRequestWrapper.MockResponse(true));
        Account a=TestDataFactory.getPersonAccount(true);
        Bank_Account__c ba=TestDataFactory.getBankAccount(a.id,false);
        ba.Type__c='TERM_DEPOSIT';
        insert ba;
        Test.startTest();
        try{
        TaxExemptionFormController.initiateCRPRequest(a.id, '{}');
        }catch(Exception e){}
        Test.stopTest();
    }
    
    @isTest
    static void closeMFARequestTest(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCRPRequestWrapper.MockResponse(true));
        Account a=TestDataFactory.getPersonAccount(true);
        Bank_Account__c ba=TestDataFactory.getBankAccount(a.id,false);
        ba.Type__c='TERM_DEPOSIT';
        insert ba;
        Test.startTest();
        try{
        TaxExemptionFormController.closeMFARequest(a.Solarisbank_Id__c,'123', a.id);
        }catch(Exception e){}
        Test.stopTest();
    }
    
    @isTest
    static void closeCRPFRequestSuccess(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCRPRequestWrapper.MockResponse());
        Account a=TestDataFactory.getPersonAccount(true);
        Bank__c b=TestDataFactory.getBankSolarisBank(a.id, true);
        Bank_Account__c ba=TestDataFactory.getBankAccount(a.id,false);
        ba.Type__c='TERM_DEPOSIT';
        insert ba;
        Test.startTest();
        TaxExemptionFormController.closeCRPFRequest(a.Id, 'https://ev-smartmoney.coom', '123', 'MARRIED');
        Test.stopTest();
    }
    @isTest
    static void closeCRPFRequestError(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCRPRequestWrapper.MockResponse(true));
        Account a=TestDataFactory.getPersonAccount(true);
        Bank_Account__c ba=TestDataFactory.getBankAccount(a.id,false);
        ba.Type__c='TERM_DEPOSIT';
        insert ba;
        Test.startTest();
        try{
        TaxExemptionFormController.closeCRPFRequest(a.Id, 'https://ev-smartmoney.coom', '123', 'MARRIED');
        }catch(Exception e){}
        Test.stopTest();
    }
    
    @isTest
    static void createTaxExemptionCaseTest(){
        Account a=TestDataFactory.getPersonAccount(true);
        Bank_Account__c ba=TestDataFactory.getBankAccount(a.id,false);
        ba.Type__c='TERM_DEPOSIT';
        insert ba;
        Test.startTest();
        TaxExemptionFormController.createTaxExemptionCase(a.Id, ba.Id, 'TaxExemption','Remove','Early Termination');
        Test.stopTest();
    }
}