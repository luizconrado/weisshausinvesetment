/***************
* @group Test Class
* @description test class for SolarisbankService
*/
@isTest
public class SolarisbankServiceTest {
    
    @isTest
    static void testfetchBankAccountBookings(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankBookingsWrapper.MockResponse());
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Booking__c','Sandbox');
        String response=SolarisbankService.fetchBankAccountBookings('bankAccountId','pageNumber','bookingDateStart','bookingDateEnd','recepientIban',details);
        SolarisbankBookingsWrapper.parseList(response);
    }
    
    @isTest
    static void testfetchBankAccountReservations(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankReservationWrapper.MockResponse());
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Reservation__c','Sandbox');
        String response=SolarisbankService.fetchBankAccountReservations('bankAccountId','pageNumber','bookingDateStart','bookingDateEnd','recepientIban',details);
        SolarisbankReservationWrapper.parseList(response);
    }
    
    @isTest
    static void testfetchAccountCard(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCardWrapper.MockResponse());
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Card__c','Sandbox');
        String response=SolarisbankService.fetchAccountCard('cardid',details);
        SolarisbankCardWrapper.parseList(response);
    }
    
    @isTest
    static void testfetchSepaDirectDebit(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCardWrapper.MockResponse());
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Bookings__c','Sandbox');
        String response=SolarisbankService.fetchSepaDirectDebit('solarisPersonAccountId','solarisBankAccountId','transactionId',details);
    }
    
    @isTest
    static void testfetchSepaCreditTransfer(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCardWrapper.MockResponse());
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Bookings__c','Sandbox');
        String response=SolarisbankService.fetchSepaCreditTransfer('solarisPersonAccountId','solarisBankAccountId','transactionId',details);
    }
    
    @isTest
    static void testfetchBankTimedOrders(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankTimedOrderWrapper.MockResponse());
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Scheduled_Order__c','Sandbox');
        String response=SolarisbankService.fetchBankTimedOrders('solarisPersonAccountId','solarisBankAccountId',details);
        SolarisbankTimedOrderWrapper.parseObject(response);
    }
    
    @isTest
    static void testfetchBankStandingOrders(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankStandingOrderWrapper.MockResponse());
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Scheduled_Order__c','Sandbox');
        String response=SolarisbankService.fetchBankStandingOrders('solarisPersonAccountId','solarisBankAccountId',details);
        SolarisbankStandingOrderWrapper.parseList(response);
    }
    
    @isTest 
    static void testfetchPersonDetails(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankPersonWrapper.MockResponse());
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Account','Sandbox');
        String response=SolarisbankService.fetchPersonDetails('solarisPersonAccountId',details);
        SolarisbankPersonWrapper.parse(response);
    }
    
    @isTest
    static void testfetchAllBankAccounts(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankBankAccountWrapper.MockResponse());
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Bank_Account__c','Sandbox');
        String response=SolarisbankService.fetchAllBankAccounts('solarisPersonAccountId',details);
        SolarisbankBankAccountWrapper.parseList(response);
        
    }
    
    @isTest
    static void testfetchAllCards(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCardWrapper.MockResponse());
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Card__c','Sandbox');
        String response=SolarisbankService.fetchAllCards('solarisPersonAccountId',details);
        SolarisbankCardWrapper.parseList(response);
    }
    
    @isTest
    static void testfetchAllIdentificationAttempts(){
        Test.setMock(HttpCalloutMock.class, new SolarisBankIdentificationWrapper.MockResponse());
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Identification__C','Sandbox');
        String response=SolarisbankService.fetchAllIdentificationAttempts('solarisPersonId',details);
        SolarisBankIdentificationWrapper.parseList(response);
    }
    @isTest
    static void testcreateNewIdentificationAttempt(){
        Test.setMock(HttpCalloutMock.class, new SolarisBankIdentificationWrapper.MockResponse());
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Identification__C','Sandbox');
        String response=SolarisbankService.createNewIdentificationAttempt('solarisPersonId','{}',details);
        SolarisBankIdentificationWrapper.parse(response);
    }
    
    @isTest
    static void testfetchAllESigningAttempts(){
        Test.setMock(HttpCalloutMock.class, new SolarisBankIdentificationWrapper.MockResponse());
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Identification__C','Sandbox');
        String response=SolarisbankService.fetchAllESigningAttempts('solarisPersonId',details);
        SolarisBankIdentificationWrapper.parseList(response);
    }
    
    @isTest
    static void testfetchPersonPhoneNumber(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankPersonWrapper.MockResponse());
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Account','Sandbox');
        String response=SolarisbankService.fetchPersonPhoneNumber('solarisPersonId',details);
    }
    
    @isTest
    static void fetchAllTaxIdentificationAttempts(){
        Test.setMock(HttpCalloutMock.class, new SolarisBankTaxIdentificationWrapper.MockResponse());
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Account','Sandbox');
        String response=SolarisbankService.fetchAllTaxIdentificationAttempts('solarisPersonId',details);
        SolarisBankTaxIdentificationWrapper.parseList(response);
    }
    
    @isTest
    static void testfetchAccountBalance(){
        Test.setMock(HttpCalloutMock.class, new SolarisBankTaxIdentificationWrapper.MockResponse());
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Bank_Account__c','Sandbox');
        String response=SolarisbankService.fetchAccountBalance('solarisPersonId',details);
    }
    
    @isTest
    static void testcreateBankStatementByPeriod(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankPersonWrapper.MockResponse());
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Account','Sandbox');
        String response=SolarisbankService.createBankStatementByPeriod('accountId','{}',details);
    }
    @isTest
    static void testfetchBankStatementByPeriod(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankPersonWrapper.MockResponse());
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Account','Sandbox');
        String response=SolarisbankService.fetchBankStatementByPeriod('accountId','statementId',details);
    }
    
    @isTest
    static void testcreateBankStatementByRange(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankPersonWrapper.MockResponse());
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Account','Sandbox');
        String response=SolarisbankService.createBankStatementByRange('accountId','{}',details);
    }
    @isTest
    static void testfetchBankStatementByRange(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankPersonWrapper.MockResponse());
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Account','Sandbox');
        String response=SolarisbankService.fetchBankStatementByRange('accountId','statementId',details);
    }
    
    @isTest
    static void testChangeCardStatus(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCardWrapper.MockResponse());
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Card__c','Sandbox');
        SolarisbankService.blockAccountCard('cardid',details);
        SolarisbankService.closeAccountCard('cardid',details);
        SolarisbankService.unblockAccountCard('cardid',details);
        SolarisbankService.CardResponse response=new SolarisbankService.CardResponse();
        response.status='asd';
        response.errors=new List<SolarisbankService.CardResponse>();
        response.detail='asdasd';
    }
    
    @isTest
    static void testcancelTimedOrder(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankTimedOrderWrapper.MockResponse());
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Scheduled_Order__c','Sandbox');
        SolarisbankService.cancelTimedOrder( 'solarisPersonAccountId', 'solarisBankAccountId', 'timedOrderId',details);
    }
    
    @isTest 
    static void testfetchIdentificationDetails(){
        Test.setMock(HttpCalloutMock.class, new SolarisBankIdentificationWrapper.MockResponse());
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Identification__c','Sandbox');
        SolarisbankService.fetchIdentificationDetails( 'solarisPersonId', 'solarisIdentificationId',details);
    }
    @isTest
    static void testinitiateCRPRequest(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCRPRequestWrapper.MockResponse());
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Account','Sandbox');
        SolarisbankService.initiateCRPRequest( 'tanUrl', 'solarisbankPersonId',details);
    }
    @isTest
    static void testinitiateCRPRequestError(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCRPRequestWrapper.MockResponse(true));
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Account','Sandbox');
        try{
        SolarisbankService.initiateCRPRequest( 'tanUrl', 'solarisbankPersonId',details);
        }catch(exception e){}
    }
    @isTest
    static void testconfirmCRPRequest(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCRPRequestWrapper.MockResponse());
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Account','Sandbox');
        SolarisbankService.confirmCRPRequest( 'tanUrl', 'solarisbankPersonId', 'tanOtp',details);
    }
    @isTest
    static void testconfirmCRPRequestError(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCRPRequestWrapper.MockResponse(true));
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Account','Sandbox');
        try{
        SolarisbankService.confirmCRPRequest( 'tanUrl', 'solarisbankPersonId', 'tanOtp',details);
        }catch(Exception e){}
    }
    @isTest
    static void testrequestNewCard(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCRPRequestWrapper.MockResponse());
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Card__c','Sandbox');
        SolarisbankService.requestNewCard( 'solarisbankPersonId', 'solrisBankAccountId','{}',details);
    }
     @isTest
    static void testrequestNewCardError(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCRPRequestWrapper.MockResponse(true));
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Card__c','Sandbox');
        try{
        SolarisbankService.requestNewCard( 'solarisbankPersonId', 'solrisBankAccountId','{}',details);
        }catch(Exception e){}
    }
    @isTest
    static void teststartMFA(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCRPRequestWrapper.MockResponse(true));
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Account','Sandbox');
        try{
        SolarisbankService.startMFA( 'solarisbankPersonId',details);
        }catch(Exception e){}
    }
    @isTest
    static void teststopMFA(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCRPRequestWrapper.MockResponse(true));
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Account','Sandbox');
        try{
        SolarisbankService.stopMFA( 'mfaId','1234',details);
        }catch(Exception e){}
    }
    @isTest
    static void teststopMFAError(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankCRPRequestWrapper.MockResponse(false));
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Account','Sandbox');
        try{
        SolarisbankService.stopMFA( 'mfaId','1234',details);
        }catch(Exception e){}
    }
    @isTest
    static void testrequestCloseAccount(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankPersonWrapper.MockResponse());
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Account','Sandbox');
        SolarisbankService.requestCloseAccount('{}',details);        
    }
     @isTest
    static void testrequestCloseAccountError(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankPersonWrapper.MockResponse(true));
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Account','Sandbox');
        try{
        SolarisbankService.requestCloseAccount('{}',details);        
        }catch(Exception e){}
    }
    @isTest
    static void updateCustomerDatatest(){
        Test.setMock(HttpCalloutMock.class, new SolarisbankPersonWrapper.MockResponse());
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Account','Sandbox');
        SolarisbankService.updateCustomerData( 'solarisbankPersonId', '{}',details);    
    }
    @isTest
    static void fetchIdentificationRequestDetailsTest(){
          Test.setMock(HttpCalloutMock.class, new SolarisBankIdentificationWrapper.MockResponse());
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'KYC_Detail__c','Sandbox');
        SolarisbankService.fetchIdentificationRequestDetails( 'solarisPersonId', 'solarisIdentificationId',details);
    }
    @isTest
    static void fetchIdentificationAttemptDetailsTest(){
        Test.setMock(HttpCalloutMock.class, new SolarisBankIdentificationAttempt.MockResponse());
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'KYC_Detail__c','Sandbox');
        SolarisbankService.fetchIdentificationAttemptDetails( 'solarisPersonId', 'solarisIdentificationId',details);
    }
  
    
}