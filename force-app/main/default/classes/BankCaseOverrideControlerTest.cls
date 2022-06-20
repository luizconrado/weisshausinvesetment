/***************
* @group Test Class
* @description test class for BankCaseOverrideControler
*/
@isTest
public class BankCaseOverrideControlerTest {

    
    
    @isTest
    static void testConstants(){ 
        BankCaseOverrideControler.getBankCaseTypes();
        BankCaseOverrideControler.getCaseIITypes();
        BankCaseOverrideControler.getCardStatusTypes();
        BankCaseOverrideControler.getScheludedOrderTypes();
        BankCaseOverrideControler.checkIsCompactLayout();
        BankCaseOverrideControler.getKYCPicklistValues();
    }
    
    @isTest
    static void testQuerys(){
        Account accountDetails=TestDataFactory.getPersonAccount(true);
        Bank_Account__c bankAccountDetails = TestDataFactory.getBankAccount(accountDetails.Id,true);
        Card__c cardDetails=TestDataFactory.getCard(accountDetails.Id,bankAccountDetails.Id,true);
     	Booking__c booking=TestDataFactory.getBooking(bankAccountDetails.Id,true);
        Scheduled_Order__c tOrder=TestDataFactory.getTimedOrder(bankAccountDetails.Id,true);
        Scheduled_Order__c sOrder=TestDataFactory.getStandingOrder(bankAccountDetails.Id,true);
        Reservation__c res=TestDataFactory.getReservation(bankAccountDetails.Id,true);
        
        Case caseDetails=TestDataFactory.getBankCase(accountDetails.Id,true);
        Bank_Case_Item__c cardBankCaseDetails=TestDataFactory.getCardBankCase(caseDetails.Id,false);
        cardBankCaseDetails.Card__c=cardDetails.Id;
        insert cardBankCaseDetails;
        
        BankCaseOverrideControler.getCaseDetails(caseDetails.Id);
        BankCaseOverrideControler.fetchExsistingBankCases(caseDetails.Id);
        BankCaseOverrideControler.getBankCaseDetails(cardBankCaseDetails.Id);
        BankCaseOverrideControler.getBankAccounts(bankAccountDetails.Id);
        BankCaseOverrideControler.getAllBankCards(bankAccountDetails.Id);
        BankCaseOverrideControler.retriveBookings(bankAccountDetails.Id,null,null,null);
        BankCaseOverrideControler.retriveTimedOrders(bankAccountDetails.Id,null,null,null);
        BankCaseOverrideControler.retriveStandingOrders(bankAccountDetails.Id,null,null,null);
        BankCaseOverrideControler.retriveReservations(bankAccountDetails.Id,null,null,null);
        BankCaseOverrideControler.getAllIdentifications(accountDetails.Id);
        BankCaseOverrideControler.getSuccessKYCIdentificationRecord(accountDetails.id);
        
    }
    
    @isTest
    static void testGoogleApi(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCardWrapper.MockResponse());
        BankCaseOverrideControler.callGoogleMapSearchApi('Just So You Know','test');
        BankCaseOverrideControler.callGoogleMapsDetailsApi('Furqan Wrote this all','test');
    }
    
    @isTest
    static void testfetchTrasnsactionDetails(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCardWrapper.MockResponse());
        Account accountDetails=TestDataFactory.getPersonAccount(true);
        Bank_Account__c bankAccountDetails = TestDataFactory.getBankAccount(accountDetails.Id,true);
        Card__c cardDetails=TestDataFactory.getCard(accountDetails.Id,bankAccountDetails.Id,true);
        Booking__c booking=TestDataFactory.getBooking(bankAccountDetails.Id,true);
        Scheduled_Order__c tOrder=TestDataFactory.getTimedOrder(bankAccountDetails.Id,true);
        Scheduled_Order__c sOrder=TestDataFactory.getStandingOrder(bankAccountDetails.Id,true);
        Reservation__c res=TestDataFactory.getReservation(bankAccountDetails.Id,true);
        
        Case caseDetails=TestDataFactory.getBankCase(accountDetails.Id,true);
        Bank_Case_Item__c cardBankCaseDetails=TestDataFactory.getBookingBankCase(caseDetails.Id,false);
        cardBankCaseDetails.Booking__c=booking.id;
        insert cardBankCaseDetails;
        Test.startTest();
        BankCaseOverrideControler.fetchTrasnsactionDetails(cardBankCaseDetails.Id);
        Test.stopTest();
    }
    
    @isTest
    static void testretriveBalanceDetails(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCardWrapper.MockResponse());
        Account accountDetails=TestDataFactory.getPersonAccount(true);
        Bank_Account__c bankAccountDetails = TestDataFactory.getBankAccount(accountDetails.Id,true);
        Card__c cardDetails=TestDataFactory.getCard(accountDetails.Id,bankAccountDetails.Id,true);
        Booking__c booking=TestDataFactory.getBooking(bankAccountDetails.Id,true);
        Scheduled_Order__c tOrder=TestDataFactory.getTimedOrder(bankAccountDetails.Id,true);
        Scheduled_Order__c sOrder=TestDataFactory.getStandingOrder(bankAccountDetails.Id,true);
        Reservation__c res=TestDataFactory.getReservation(bankAccountDetails.Id,true);
        
        Case caseDetails=TestDataFactory.getBankCase(accountDetails.Id,true);
        Bank_Case_Item__c cardBankCaseDetails=TestDataFactory.getBankAccountBankCase(caseDetails.Id,false);
        cardBankCaseDetails.Bank_Account__c=bankAccountDetails.id;
        insert cardBankCaseDetails;
        Test.startTest();
        BankCaseOverrideControler.retriveBalanceDetails(cardBankCaseDetails.Id);
        Test.stopTest();
    }
    
    @isTest
    static void testStatmentRange(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCardWrapper.MockResponse());
        Account accountDetails=TestDataFactory.getPersonAccount(true);
        Bank_Account__c bankAccountDetails = TestDataFactory.getBankAccount(accountDetails.Id,true);
        Card__c cardDetails=TestDataFactory.getCard(accountDetails.Id,bankAccountDetails.Id,true);
        Booking__c booking=TestDataFactory.getBooking(bankAccountDetails.Id,true);
        Scheduled_Order__c tOrder=TestDataFactory.getTimedOrder(bankAccountDetails.Id,true);
        Scheduled_Order__c sOrder=TestDataFactory.getStandingOrder(bankAccountDetails.Id,true);
        Reservation__c res=TestDataFactory.getReservation(bankAccountDetails.Id,true);
        
        Case caseDetails=TestDataFactory.getBankCase(accountDetails.Id,true);
        Bank_Case_Item__c cardBankCaseDetails=TestDataFactory.getBankAccountBankCase(caseDetails.Id,false);
        cardBankCaseDetails.Bank_Account__c=bankAccountDetails.id;
        insert cardBankCaseDetails;
        
        Statement__c state=New Statement__c();
        state.Bank_Account__c=bankAccountDetails.id;
        state.Solarisbank_Id__c='0652225cebcd3bec2c95ea8c461fe146cacc';
        Test.startTest();
        List<Bank_Account__c> baccounts=BankCaseOverrideControler.getBankAccounts(accountDetails.Id);
        BankCaseOverrideControler.createStatment(caseDetails.Id,baccounts.get(0),false,baccounts.get(0).Solarisbank_Id__c,'{}');
        BankCaseOverrideControler.fetchBankStatement(caseDetails.Id,baccounts.get(0),false,baccounts.get(0).Solarisbank_Id__c,state);

        Test.stopTest();

    }
    @isTest
    static void testStatmentPeriod(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCardWrapper.MockResponse());
        Account accountDetails=TestDataFactory.getPersonAccount(true);
        Bank_Account__c bankAccountDetails = TestDataFactory.getBankAccount(accountDetails.Id,true);
        Card__c cardDetails=TestDataFactory.getCard(accountDetails.Id,bankAccountDetails.Id,true);
        Booking__c booking=TestDataFactory.getBooking(bankAccountDetails.Id,true);
        Scheduled_Order__c tOrder=TestDataFactory.getTimedOrder(bankAccountDetails.Id,true);
        Scheduled_Order__c sOrder=TestDataFactory.getStandingOrder(bankAccountDetails.Id,true);
        Reservation__c res=TestDataFactory.getReservation(bankAccountDetails.Id,true);
        
        Case caseDetails=TestDataFactory.getBankCase(accountDetails.Id,true);
        Bank_Case_Item__c cardBankCaseDetails=TestDataFactory.getBankAccountBankCase(caseDetails.Id,false);
        cardBankCaseDetails.Bank_Account__c=bankAccountDetails.id;
        insert cardBankCaseDetails;
        
        Statement__c state=New Statement__c();
        state.Bank_Account__c=bankAccountDetails.id;
        state.Solarisbank_Id__c='0652225cebcd3bec2c95ea8c461fe146cacc';
        Test.startTest();
        List<Bank_Account__c> baccounts=BankCaseOverrideControler.getBankAccounts(accountDetails.Id);
        BankCaseOverrideControler.createStatment(caseDetails.Id,baccounts.get(0),true,baccounts.get(0).Solarisbank_Id__c,'{}');
        BankCaseOverrideControler.fetchBankStatement(caseDetails.Id,baccounts.get(0),true,baccounts.get(0).Solarisbank_Id__c,state);
        Test.stopTest();

    }
    
    @isTest
    static void testrequestTransactionDetails(){
         Test.setMock(HttpCalloutMock.class, new SolarisbankBookingsWrapper.MockResponse());
        Account accountDetails=TestDataFactory.getPersonAccount(true);
        Bank_Account__c bankAccountDetails = TestDataFactory.getBankAccount(accountDetails.Id,true);
        Card__c cardDetails=TestDataFactory.getCard(accountDetails.Id,bankAccountDetails.Id,true);
        Booking__c booking=TestDataFactory.getBooking(bankAccountDetails.Id,true);
        Scheduled_Order__c tOrder=TestDataFactory.getTimedOrder(bankAccountDetails.Id,true);
        Scheduled_Order__c sOrder=TestDataFactory.getStandingOrder(bankAccountDetails.Id,true);
        Reservation__c res=TestDataFactory.getReservation(bankAccountDetails.Id,true);
        
        Case caseDetails=TestDataFactory.getBankCase(accountDetails.Id,true);
        Bank_Case_Item__c cardBankCaseDetails=TestDataFactory.getBookingBankCase(caseDetails.Id,false);
        cardBankCaseDetails.Booking__c=booking.id;
        insert cardBankCaseDetails;
        
        
        Test.startTest();
        List<Bank_Account__c> baccounts=BankCaseOverrideControler.getBankAccounts(accountDetails.Id);
        BankCaseOverrideControler.requestTransactionDetails(caseDetails.Id,baccounts.get(0),'false');
        BankCaseOverrideControler.retriveTransactionDetails(cardBankCaseDetails.Id);
        Test.stopTest();
    }
    
    @isTest
    static void testlogVarification(){
         Account accountDetails=TestDataFactory.getPersonAccount(true);
        Bank_Account__c bankAccountDetails = TestDataFactory.getBankAccount(accountDetails.Id,true);
        Card__c cardDetails=TestDataFactory.getCard(accountDetails.Id,bankAccountDetails.Id,true);
        Booking__c booking=TestDataFactory.getBooking(bankAccountDetails.Id,true);
        Scheduled_Order__c tOrder=TestDataFactory.getTimedOrder(bankAccountDetails.Id,true);
        Scheduled_Order__c sOrder=TestDataFactory.getStandingOrder(bankAccountDetails.Id,true);
        Reservation__c res=TestDataFactory.getReservation(bankAccountDetails.Id,true);
        
        Case caseDetails=TestDataFactory.getBankCase(accountDetails.Id,true);
        Case_Verification__c cv=new Case_Verification__c();
        cv.Case__c=caseDetails.Id;
        BankCaseOverrideControler.logVarification(cv);
    }
   
   @isTest
    static void requestCreateNewCardTest(){
        Test.setMock(HttpCalloutMock.class, new BankCaseServiceTest.MockCardResponse());
        
        Account a=TestDataFactory.getPersonAccount(true);
        Bank_Account__c ba=TestDataFactory.getBankAccount(a.id,true);
        Case c=TestDataFactory.getBankCase(a.Id,true);
        Bank_Case_Item__c bci=TestDataFactory.getBankAccountBankCase(c.id, false);
        bci.Bank_Account__c=ba.id;
        insert bci;
        
        Test.startTest();
        BankCaseOverrideControler.requestCreateNewCard(bci.id,'{"reference":"123","type":"VISA_DEBIT","line_1":"name on card"}');
        
        Test.stopTest();
     }
    
   
    
}