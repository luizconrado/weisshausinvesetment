@isTest
public class AccountSolarisbankAdminPanalTest {
    
    @isTest
    static void staticValuesTest(){
        AccountSolarisbankAdminPanalController.checkIsCompactLayout();
        AccountSolarisbankAdminPanalController.getBankAccountPicklistValues();
        AccountSolarisbankAdminPanalController.getKYCPicklistValues();
        Account a=TestDataFactory.getPersonAccount(true);
        Bank_Account__c bc=TestDataFactory.getBankAccount(a.id,true); 
        Card__c c=TestDataFactory.getCard(a.id,bc.id,true);
        Case ca=TestDataFactory.getBankCase(a.id,true);
        AccountSolarisbankAdminPanalController.getRecordDetails(a.id);
        AccountSolarisbankAdminPanalController.getRecordDetails(bc.id);
        AccountSolarisbankAdminPanalController.getRecordDetails(c.id);
        AccountSolarisbankAdminPanalController.getRecordDetails(ca.id);
     }
    
    @isTest
    static void intitatePersonDetailsChangeTanRequestTest(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCRPRequestWrapper.MockResponse());
        Account a=TestDataFactory.getPersonAccount(true);
        Test.startTest();
        AccountSolarisbankAdminPanalController.intitatePersonDetailsChangeTanRequest(a.id,'{}');
        Test.stopTest();
    }
    @isTest
    static void intitatePersonDetailsChangeTanRequestTestFailed(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCRPRequestWrapper.MockResponse(true));
        Account a=TestDataFactory.getPersonAccount(true);
        Test.startTest();
        try{
            AccountSolarisbankAdminPanalController.intitatePersonDetailsChangeTanRequest(a.id,'{}');
        }
        catch(Exception e){}
        Test.stopTest();
    }
    
    @isTest
    static void confirmPersonDetailsChangeTanRequestTest(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCRPRequestWrapper.MockResponse());
        Account a=TestDataFactory.getPersonAccount(true);  
        Test.startTest();
        AccountSolarisbankAdminPanalController.confirmPersonDetailsChangeTanRequest(a.id,'/confirm','12212');
        Test.stopTest();
    }
     @isTest
    static void confirmPersonDetailsChangeTanRequestTestFailed(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCRPRequestWrapper.MockResponse(true));
        Account a=TestDataFactory.getPersonAccount(true);  
        Test.startTest();
        try{
            AccountSolarisbankAdminPanalController.confirmPersonDetailsChangeTanRequest(a.id,'/confirm','12212');
        }
        catch(Exception e){
            
        }
        Test.stopTest();
    }

    @isTest
    static void callGoogleMapSearchApiTest(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCRPRequestWrapper.MockResponse());
        AccountSolarisbankAdminPanalController.callGoogleMapSearchApi('searchText','sessionToken');
    }
    
    @isTest
    static void callGoogleMapsDetailsApiTest(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCRPRequestWrapper.MockResponse());
        AccountSolarisbankAdminPanalController.callGoogleMapsDetailsApi('placeId','sessionToken');
    }
    
    @isTest
    static void testreqeustNewIdentification(){
        Test.setMock(HttpCalloutMock.class, new SolarisBankIdentificationWrapper.MockResponse());
        Account a=TestDataFactory.getPersonAccount(true);
        
        Test.startTest();
        AccountSolarisbankAdminPanalController.reqeustNewIdentification(a.id,'EN');
        Test.stopTest();
    }  
    
     @isTest
    static void requestCreateNewCardTest(){
        Test.setMock(HttpCalloutMock.class, new BankCaseServiceTest.MockCardResponse());
        
        Account a=TestDataFactory.getPersonAccount(true);
     Bank_Account__c ba=TestDataFactory.getBankAccount(a.id,true);
            
        Test.startTest();
        AccountSolarisbankAdminPanalController.requestNewBankCard(ba.id,'{"reference":"123","type":"VISA_DEBIT","line_1":"name on card"}');
        
        Test.stopTest();
     }
     @isTest
    static void requestCreateNewCardTestFailed(){
        Test.setMock(HttpCalloutMock.class, new BankCaseServiceTest.MockCardResponse(true));
        
        Account a=TestDataFactory.getPersonAccount(true);
     Bank_Account__c ba=TestDataFactory.getBankAccount(a.id,true);
            
        Test.startTest();
        AccountSolarisbankAdminPanalController.requestNewBankCard(ba.id,'{"reference":"123","type":"VISA_DEBIT","line_1":"name on card"}');
        
        Test.stopTest();
     }
    
    @isTest
    static void testchangeCardStatusClose(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCardWrapper.MockResponse());
        Account accountDetails=TestDataFactory.getPersonAccount(true);
        Bank_Account__c bankAccountDetails = TestDataFactory.getBankAccount(accountDetails.Id,true);
        Card__c cardDetails=TestDataFactory.getCard(accountDetails.Id,bankAccountDetails.Id,true);
         
        Test.startTest();
        try{
            AccountSolarisbankAdminPanalController.changeCardStatus(cardDetails.id,'Block','Test It');
         }catch(exception e){}
        Test.stopTest();
    }
    
    @isTest
    static void testchangeCardStatusFailed(){
      
        Test.setMock(HttpCalloutMock.class, new SolarisbankCardWrapper.MockResponse(true)); 
        
        Account accountDetails=TestDataFactory.getPersonAccount(true);
        Bank_Account__c bankAccountDetails = TestDataFactory.getBankAccount(accountDetails.Id,true);
        Card__c cardDetails=TestDataFactory.getCard(accountDetails.Id,bankAccountDetails.Id,true);
        
        Test.startTest();
         try{
            AccountSolarisbankAdminPanalController.changeCardStatus(cardDetails.id,'Unblock','Test It');
          }catch(exception e){}
        Test.stopTest();
    }
    @isTest
    static void testchangeCardStatusException(){
      
        Test.setMock(HttpCalloutMock.class, new SolarisbankCardWrapper.MockResponse()); 
        
        Account accountDetails=TestDataFactory.getPersonAccount(true);
        Bank_Account__c bankAccountDetails = TestDataFactory.getBankAccount(accountDetails.Id,true);
        Card__c cardDetails=TestDataFactory.getCard(accountDetails.Id,bankAccountDetails.Id,true);
        
        Test.startTest();
         try{
            AccountSolarisbankAdminPanalController.changeCardStatus(cardDetails.id,'Unblock','Test It');
          }catch(exception e){}
        Test.stopTest();
    }
    
    @isTest
    static void requestAccountCloserTest(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankBankAccountWrapper.MockResponse());
        Account accountDetails=TestDataFactory.getPersonAccount(true);
        Bank_Account__c bankAccountDetails = TestDataFactory.getBankAccount(accountDetails.Id,true);
        Test.startTest();
        try{
            AccountSolarisbankAdminPanalController.requestAccountCloser(bankAccountDetails.id,'Test It');
        }catch(exception e){}
        Test.stopTest();
    }
}