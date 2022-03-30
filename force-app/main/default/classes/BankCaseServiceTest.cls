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
        Bank_Case_Item__c cardBankCaseDetails=TestDataFactory.getCardBankCase(caseDetails.Id,false);
        cardBankCaseDetails.Card__c=cardDetails.Id;
        insert cardBankCaseDetails;
        Bank_Case_Item__c bcase=BankCaseOverrideControler.getBankCaseDetails(cardBankCaseDetails.Id);
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
        Bank_Case_Item__c cardBankCaseDetails=TestDataFactory.getCardBankCase(caseDetails.Id,false);
        cardBankCaseDetails.Card__c=cardDetails.Id;
        insert cardBankCaseDetails;
        Bank_Case_Item__c bcase=BankCaseOverrideControler.getBankCaseDetails(cardBankCaseDetails.Id);
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
        Bank_Case_Item__c cardBankCaseDetails=TestDataFactory.getCardBankCase(caseDetails.Id,false);
        cardBankCaseDetails.Card__c=cardDetails.Id;
        insert cardBankCaseDetails;
        Bank_Case_Item__c bcase=BankCaseOverrideControler.getBankCaseDetails(cardBankCaseDetails.Id);
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
        Bank_Case_Item__c cardBankCaseDetails=TestDataFactory.getTimedOrderBankCase(caseDetails.Id,false);
        cardBankCaseDetails.Scheduled_Order__c=tOrder.Id;
        insert cardBankCaseDetails;
        Bank_Case_Item__c bcase=BankCaseOverrideControler.getBankCaseDetails(cardBankCaseDetails.Id);
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
        Bank_Case_Item__c cardBankCaseDetails=TestDataFactory.getTimedOrderBankCase(caseDetails.Id,false);
        cardBankCaseDetails.Scheduled_Order__c=tOrder.Id;
        insert cardBankCaseDetails;
        Bank_Case_Item__c bcase=BankCaseOverrideControler.getBankCaseDetails(cardBankCaseDetails.Id);
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
        KYC_Detail__c ident=TestDataFactory.getKYCVideoIdentification(accountDetails.Id,True);
        Case caseDetails=TestDataFactory.getBankCase(accountDetails.Id,true);
        Statement__c state=New Statement__c();
        state.Bank_Account__c=bankAccountDetails.id;
        state.Solarisbank_Id__c='0652225cebcd3bec2c95ea8c461fe146cacc';
        insert state;
        Test.startTest();
        BankCaseOverrideControler.createBankCases(caseDetails.Id,caseDetails.Type,caseDetails.Type_II__c,caseDetails.Description, 
                                                  bankAccountDetails.Id,cardDetails.Id,accountDetails.Id,
                                                  new List<String>{booking.Id},new List<String>{res.Id},
                                                  new List<String>{tOrder.Id},new List<String>{sOrder.Id},state.id,new List<String>{ident.Id});
         BankCaseOverrideControler.createBankCases(caseDetails.Id,caseDetails.Type,caseDetails.Type_II__c,caseDetails.Description, 
                                                  bankAccountDetails.Id,cardDetails.Id,accountDetails.Id,
                                                  new List<String>{booking.Id},new List<String>{res.Id},
                                                  new List<String>{tOrder.Id},new List<String>{sOrder.Id},state.Id,new List<String>{ident.Id});
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
        KYC_Detail__c ident=TestDataFactory.getKYCVideoIdentification(accountDetails.Id,True);
        
        Case caseDetails=TestDataFactory.getBankCase(accountDetails.Id,true);
        Test.startTest();
        try{
        BankCaseOverrideControler.createBankCases(caseDetails.Id,caseDetails.Type,caseDetails.Type_II__c,caseDetails.Description, 
                                                  bankAccountDetails.Id,cardDetails.Id,accountDetails.Id,
                                                 
                                                  new List<String>{tOrder.Id}, new List<String>{booking.Id},new List<String>{res.Id},
                                                  new List<String>{sOrder.Id},'',new List<String>{ident.Id});
        }catch(Exception e){}
        Test.stopTest();
    } 
    @isTest
    static void testcreateNewIdentification(){
        Test.setMock(HttpCalloutMock.class, new SolarisBankIdentificationWrapper.MockResponse());
        Account a=TestDataFactory.getPersonAccount(true);
        Case c=TestDataFactory.getBankCase(a.Id,true);
        Bank_Case_Item__c bci=TestDataFactory.getAccountBankCase(c.Id,false);
        bci.Account__c=a.Id;
        insert bci;
        Test.startTest();
        BankCaseService.createNewIdentification(bci.id,'EN');
        Test.stopTest();
        BankCaseOverrideControler.createNewIdentification(bci.id,'EN');
    }
    @isTest
    static void testcreateNewIdentificationException(){
        Test.setMock(HttpCalloutMock.class, new SolarisBankIdentificationWrapper.MockResponse());
        Account a=TestDataFactory.getPersonAccount(true);
        Case c=TestDataFactory.getBankCase(a.Id,true);
        Bank_Case_Item__c bci=TestDataFactory.getAccountBankCase(c.Id,false);
        bci.Account__c=a.Id;
         Test.startTest();
        try{
        BankCaseService.createNewIdentification(bci.id,'EN');
        }catch(Exception e){}
        Test.stopTest();
        
    }

    @isTest
    static void testintitatePersonDetailsChangeTanRequest(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCRPRequestWrapper.MockResponse());
        Account a=TestDataFactory.getPersonAccount(true);
        Case c=TestDataFactory.getBankCase(a.Id,true);
        Bank_Case_Item__c bci=TestDataFactory.getAccountBankCase(c.Id,false);
        bci.Account__c=a.Id;
        insert bci;
        Test.startTest();
        BankCaseService.intitatePersonDetailsChangeTanRequest(bci.id,'{}');
        
        Test.stopTest();
        BankCaseOverrideControler.intitatePersonDetailsChangeTanRequest(bci.id,'EN');
    }
    @isTest
    static void testintitatePersonDetailsChangeTanRequestFailed(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCRPRequestWrapper.MockResponse(true));
        Account a=TestDataFactory.getPersonAccount(true);  
        Case c=TestDataFactory.getBankCase(a.Id,true);
        Bank_Case_Item__c bci=TestDataFactory.getAccountBankCase(c.Id,false);
        bci.Account__c=a.Id;
        insert bci;
        try{
        Test.startTest();
        BankCaseService.intitatePersonDetailsChangeTanRequest(bci.id,'{}');
        
        Test.stopTest();
        BankCaseOverrideControler.intitatePersonDetailsChangeTanRequest(bci.id,'EN');
        }Catch(Exception e){}
    }
     @isTest
    static void testintitatePersonDetailsChangeTanRequestException(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCRPRequestWrapper.MockResponse(true));
        Account a=TestDataFactory.getPersonAccount(true);  
        Case c=TestDataFactory.getBankCase(a.Id,true);
        Bank_Case_Item__c bci=TestDataFactory.getAccountBankCase(c.Id,false);
        Test.startTest();
        try{
        BankCaseService.intitatePersonDetailsChangeTanRequest(bci.id,'{}');
        }catch(Exception e){}
        Test.stopTest();
    }
    
    @isTest
    static void confirmPersonDetailsChangeTanRequestTest(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCRPRequestWrapper.MockResponse());
        Account a=TestDataFactory.getPersonAccount(true);  
        Case c=TestDataFactory.getBankCase(a.Id,true);
        Bank_Case_Item__c bci=TestDataFactory.getAccountBankCase(c.Id,false);
        bci.Account__c=a.Id;
        insert bci;
        Test.startTest();
        BankCaseService.confirmPersonDetailsChangeTanRequest(bci.id,'/confirm','12212');
        
        Test.stopTest();
        BankCaseOverrideControler.confirmPersonDetailsChangeTanRequest(bci.id,'/confirm','12212');
    }
    @isTest
    static void confirmPersonDetailsChangeTanRequestFailed(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCRPRequestWrapper.MockResponse(true));
        Account a=TestDataFactory.getPersonAccount(true);  
        Case c=TestDataFactory.getBankCase(a.Id,true);
        Bank_Case_Item__c bci=TestDataFactory.getAccountBankCase(c.Id,false);
        bci.Account__c=a.Id;
        insert bci;
        try{
        Test.startTest();
        BankCaseService.confirmPersonDetailsChangeTanRequest(bci.id,'/confirm','12212');
        
        Test.stopTest();
        BankCaseOverrideControler.confirmPersonDetailsChangeTanRequest(bci.id,'/confirm','12212');
        }
        catch(Exception e){}
    }
    @isTest
    static void confirmPersonDetailsChangeTanRequestException(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCRPRequestWrapper.MockResponse(true));
        Account a=TestDataFactory.getPersonAccount(true);  
        Case c=TestDataFactory.getBankCase(a.Id,true);
        Bank_Case_Item__c bci=TestDataFactory.getAccountBankCase(c.Id,false);
        Test.startTest();
        Try{
        BankCaseService.confirmPersonDetailsChangeTanRequest(bci.id,'/confirm','12212');
        }catch(Exception e){}
        Test.stopTest();
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
        BankCaseService.requestCreateNewCard(bci.id,'{"reference":"123","type":"VISA_DEBIT","line_1":"name on card"}');
        
        Test.stopTest();
     }
     @isTest
    static void requestCreateNewCardTestFailed(){
        Test.setMock(HttpCalloutMock.class, new BankCaseServiceTest.MockCardResponse(true));
        
        Account a=TestDataFactory.getPersonAccount(true);
        Bank_Account__c ba=TestDataFactory.getBankAccount(a.id,true);
        Case c=TestDataFactory.getBankCase(a.Id,true);
        Bank_Case_Item__c bci=TestDataFactory.getBankAccountBankCase(c.id, false);
        bci.Bank_Account__c=ba.id;
        insert bci;
           
        Test.startTest();
        BankCaseService.requestCreateNewCard(bci.id,'{"reference":"123","type":"VISA_DEBIT","line_1":"name on card"}');
        
        Test.stopTest();
    }
     @isTest
    static void requestCreateNewCardTestException(){
        Test.setMock(HttpCalloutMock.class, new BankCaseServiceTest.MockCardResponse(true));
        
        Account a=TestDataFactory.getPersonAccount(true);
        Bank_Account__c ba=TestDataFactory.getBankAccount(a.id,true);
        Case c=TestDataFactory.getBankCase(a.Id,true);
        Bank_Case_Item__c bci=TestDataFactory.getBankAccountBankCase(c.id, false);
        bci.Bank_Account__c=ba.id;
            
        Test.startTest();
        try{
        BankCaseService.requestCreateNewCard(bci.id,'{"reference":"123","type":"VISA_DEBIT","line_1":"name on card"}');
        }catch(Exception e){}
        Test.stopTest();
     }
    
    public class MockCardResponse implements HttpCalloutMock { 
         Boolean isError=false;
         public MockCardResponse(){} 
         public MockCardResponse(Boolean isError){
             this.isError=isError;
         }
         
        public HTTPResponse respond(HTTPRequest req) { 
            SolarisbankService.CardResponse data=new SolarisbankService.CardResponse();
            data.id='asdasd';
            data.status='ACTIVE';
            data.detail='www.google.com';

         
            if(isError){
                SolarisbankService.CardResponse  error=new SolarisbankService.CardResponse ();
                error.id='asdasd';
                error.status='CLOSED';
                error.detail='www.google.com';
                data.errors=new List<SolarisbankService.CardResponse>{error};
            }
            
                         
            HttpResponse resp = new HttpResponse(); 
            
            resp.setStatusCode(200); 
            
            resp.setStatus('success'); 
            resp.setBody(JSON.serialize(data)); 
            return resp; 
        }
    }
}