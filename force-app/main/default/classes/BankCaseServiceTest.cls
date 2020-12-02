@isTest
public class BankCaseServiceTest {
    @isTest
    static void testchangeCardStatusToJira(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCardWrapper.MockResponse());
        Account accountDetails=TestDataFactory.getPersonAccount(true);
        Bank_Account__c bankAccountDetails = TestDataFactory.getBankAccount(accountDetails.Id,true);
        Card__c cardDetails=TestDataFactory.getCard(accountDetails.Id,bankAccountDetails.Id,true);
        Booking__c booking=TestDataFactory.getBooking(bankAccountDetails.Id,true);
        Scheduled_Order__c tOrder=TestDataFactory.getTimedOrder(bankAccountDetails.Id,true);
        Scheduled_Order__c sOrder=TestDataFactory.getStandingOrder(bankAccountDetails.Id,true);
        Reservation__c res=TestDataFactory.getReservation(bankAccountDetails.Id,true);
        
        Case caseDetails=TestDataFactory.getBankCase(accountDetails.Id,true);
        Bank_Case__c cardBankCaseDetails=TestDataFactory.getCardBankCase(caseDetails.Id,false);
        cardBankCaseDetails.Card__c=cardDetails.Id;
        insert cardBankCaseDetails;
        Bank_Case__c bcase=BankCaseOverrideControler.getBankCaseDetails(cardBankCaseDetails.Id);
        Test.startTest();
        
        BankCaseOverrideControler.changeCardStatus(bcase,'Block','Test It',true);
        Test.stopTest();
    }
    @isTest
    static void testchangeCardStatusBlock(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCardWrapper.MockResponse());
        Account accountDetails=TestDataFactory.getPersonAccount(true);
        Bank_Account__c bankAccountDetails = TestDataFactory.getBankAccount(accountDetails.Id,true);
        Card__c cardDetails=TestDataFactory.getCard(accountDetails.Id,bankAccountDetails.Id,true);
        Booking__c booking=TestDataFactory.getBooking(bankAccountDetails.Id,true);
        Scheduled_Order__c tOrder=TestDataFactory.getTimedOrder(bankAccountDetails.Id,true);
        Scheduled_Order__c sOrder=TestDataFactory.getStandingOrder(bankAccountDetails.Id,true);
        Reservation__c res=TestDataFactory.getReservation(bankAccountDetails.Id,true);
        
        Case caseDetails=TestDataFactory.getBankCase(accountDetails.Id,true);
        Bank_Case__c cardBankCaseDetails=TestDataFactory.getCardBankCase(caseDetails.Id,false);
        cardBankCaseDetails.Card__c=cardDetails.Id;
        insert cardBankCaseDetails;
        Bank_Case__c bcase=BankCaseOverrideControler.getBankCaseDetails(cardBankCaseDetails.Id);
        Test.startTest();
        
        BankCaseOverrideControler.changeCardStatus(bcase,'Block','Test It',false);
        Test.stopTest();
    }
    @isTest
    static void testchangeCardStatusClose(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCardWrapper.MockResponse());
        Account accountDetails=TestDataFactory.getPersonAccount(true);
        Bank_Account__c bankAccountDetails = TestDataFactory.getBankAccount(accountDetails.Id,true);
        Card__c cardDetails=TestDataFactory.getCard(accountDetails.Id,bankAccountDetails.Id,true);
        Booking__c booking=TestDataFactory.getBooking(bankAccountDetails.Id,true);
        Scheduled_Order__c tOrder=TestDataFactory.getTimedOrder(bankAccountDetails.Id,true);
        Scheduled_Order__c sOrder=TestDataFactory.getStandingOrder(bankAccountDetails.Id,true);
        Reservation__c res=TestDataFactory.getReservation(bankAccountDetails.Id,true);
        
        Case caseDetails=TestDataFactory.getBankCase(accountDetails.Id,true);
        Bank_Case__c cardBankCaseDetails=TestDataFactory.getCardBankCase(caseDetails.Id,false);
        cardBankCaseDetails.Card__c=cardDetails.Id;
        insert cardBankCaseDetails;
        Bank_Case__c bcase=BankCaseOverrideControler.getBankCaseDetails(cardBankCaseDetails.Id);
        Test.startTest();
        try{
            BankCaseOverrideControler.changeCardStatus(bcase,'Unblock','Test It',false);
            BankCaseOverrideControler.changeCardStatus(bcase,'Close','Test It',false);
        }catch(exception e){}
        Test.stopTest();
    }
    @isTest 
    static void initiateTimedOrderCancelationNegative(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCardWrapper.MockResponse());
        Account accountDetails=TestDataFactory.getPersonAccount(true);
        Bank_Account__c bankAccountDetails = TestDataFactory.getBankAccount(accountDetails.Id,true);
        Card__c cardDetails=TestDataFactory.getCard(accountDetails.Id,bankAccountDetails.Id,true);
        Booking__c booking=TestDataFactory.getBooking(bankAccountDetails.Id,true);
        Scheduled_Order__c tOrder=TestDataFactory.getTimedOrder(bankAccountDetails.Id,true);
        Scheduled_Order__c sOrder=TestDataFactory.getStandingOrder(bankAccountDetails.Id,true);
        Reservation__c res=TestDataFactory.getReservation(bankAccountDetails.Id,true);
        
        Case caseDetails=TestDataFactory.getBankCase(accountDetails.Id,true);
        Bank_Case__c cardBankCaseDetails=TestDataFactory.getTimedOrderBankCase(caseDetails.Id,false);
        cardBankCaseDetails.Scheduled_Order__c=tOrder.Id;
        insert cardBankCaseDetails;
        Bank_Case__c bcase=BankCaseOverrideControler.getBankCaseDetails(cardBankCaseDetails.Id);
        Test.startTest();
        try{
        BankCaseOverrideControler.requestCancleTimedOrder(bcase,'Test It');
        }catch(exception e){}
        Test.stopTest();
    }
    @isTest 
    static void initiateTimedOrderCancelation(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankTimedOrderWrapper.MockResponse());
        Account accountDetails=TestDataFactory.getPersonAccount(true);
        Bank_Account__c bankAccountDetails = TestDataFactory.getBankAccount(accountDetails.Id,true);
        Card__c cardDetails=TestDataFactory.getCard(accountDetails.Id,bankAccountDetails.Id,true);
        Booking__c booking=TestDataFactory.getBooking(bankAccountDetails.Id,true);
        Scheduled_Order__c tOrder=TestDataFactory.getTimedOrder(bankAccountDetails.Id,true);
        Scheduled_Order__c sOrder=TestDataFactory.getStandingOrder(bankAccountDetails.Id,true);
        Reservation__c res=TestDataFactory.getReservation(bankAccountDetails.Id,true);
        
        Case caseDetails=TestDataFactory.getBankCase(accountDetails.Id,true);
        Bank_Case__c cardBankCaseDetails=TestDataFactory.getTimedOrderBankCase(caseDetails.Id,false);
        cardBankCaseDetails.Scheduled_Order__c=tOrder.Id;
        insert cardBankCaseDetails;
        Bank_Case__c bcase=BankCaseOverrideControler.getBankCaseDetails(cardBankCaseDetails.Id);
        Test.startTest();
        BankCaseOverrideControler.requestCancleTimedOrder(bcase,'Test It');
        
        Test.stopTest();
    }
    
    @isTest
    static void testcreateBankCasesRecords(){
        Account accountDetails=TestDataFactory.getPersonAccount(true);
        Bank_Account__c bankAccountDetails = TestDataFactory.getBankAccount(accountDetails.Id,true);
        Card__c cardDetails=TestDataFactory.getCard(accountDetails.Id,bankAccountDetails.Id,true);
        Booking__c booking=TestDataFactory.getBooking(bankAccountDetails.Id,true);
        Scheduled_Order__c tOrder=TestDataFactory.getTimedOrder(bankAccountDetails.Id,true);
        Scheduled_Order__c sOrder=TestDataFactory.getStandingOrder(bankAccountDetails.Id,true);
        Reservation__c res=TestDataFactory.getReservation(bankAccountDetails.Id,true);
        
        Case caseDetails=TestDataFactory.getBankCase(accountDetails.Id,true);
        Statement__c state=New Statement__c();
        state.Bank_Account__c=bankAccountDetails.id;
        state.Solarisbank_Id__c='0652225cebcd3bec2c95ea8c461fe146cacc';
        insert state;
        Test.startTest();
        BankCaseOverrideControler.createBankCases(caseDetails.Id,caseDetails.Type,caseDetails.Type_II__c,caseDetails.Description, 
                                                  bankAccountDetails.Id,cardDetails.Id,accountDetails.Id,
                                                  new List<String>{booking.Id},new List<String>{res.Id},
                                                  new List<String>{tOrder.Id},new List<String>{sOrder.Id},state.id);
         BankCaseOverrideControler.createBankCases(caseDetails.Id,caseDetails.Type,caseDetails.Type_II__c,caseDetails.Description, 
                                                  bankAccountDetails.Id,cardDetails.Id,accountDetails.Id,
                                                  new List<String>{booking.Id},new List<String>{res.Id},
                                                  new List<String>{tOrder.Id},new List<String>{sOrder.Id},state.Id);
        Test.stopTest();
    }
    @isTest
    static void testcreateBankCasesRecordsNegetive(){
        Account accountDetails=TestDataFactory.getPersonAccount(true);
        Bank_Account__c bankAccountDetails = TestDataFactory.getBankAccount(accountDetails.Id,true);
        Card__c cardDetails=TestDataFactory.getCard(accountDetails.Id,bankAccountDetails.Id,true);
        Booking__c booking=TestDataFactory.getBooking(bankAccountDetails.Id,true);
        Scheduled_Order__c tOrder=TestDataFactory.getTimedOrder(bankAccountDetails.Id,true);
        Scheduled_Order__c sOrder=TestDataFactory.getStandingOrder(bankAccountDetails.Id,true);
        Reservation__c res=TestDataFactory.getReservation(bankAccountDetails.Id,true);
        
        Case caseDetails=TestDataFactory.getBankCase(accountDetails.Id,true);
        Test.startTest();
        try{
        BankCaseOverrideControler.createBankCases(caseDetails.Id,caseDetails.Type,caseDetails.Type_II__c,caseDetails.Description, 
                                                  bankAccountDetails.Id,cardDetails.Id,accountDetails.Id,
                                                 
                                                  new List<String>{tOrder.Id}, new List<String>{booking.Id},new List<String>{res.Id},
                                                  new List<String>{sOrder.Id},'');
        }catch(Exception e){}
        Test.stopTest();
    }
}