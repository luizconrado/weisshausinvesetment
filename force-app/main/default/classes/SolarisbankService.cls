public inherited  sharing class SolarisbankService {
    
    //private static final String PRODUCTION_URL='https://api.solarisbank.de';
    private static  String HOST_URL;//='https://api.solaris-sandbox.de';
    private static  String CLIENT_ID;//='';
    private static  String CLIENT_SECRET;//='';
    
    private static  String AUTH_URI;//='/oauth/token';
    private static  String BOOKINGS_URI;//='/v1/accounts/:account_id/bookings';
    private static  String RESERVATION_URI;//='/v1/accounts/:account_id/reservations';
    private static  String BLOCK_CARD;//='/v1/cards/:card_id/block'; 
    private static  String CLOSE_CARD;//='/v1/cards/:card_id/close';
    private static  String UNBLOCK_CARD;//='/v1/cards/:card_id/unblock';
    private static  String DETAILS_CARD;//='/v1/cards/:card_id';    
    private static  STRING GET_SEPADD_TRANSACTION_DETIALS;//='/v1/persons/:person_id/accounts/:account_id/transactions/sepa_direct_debit/:id';
    private static  String GET_SEPACT_TRANSACTION_DETAILS;//='/v1/persons/:person_id/accounts/:account_id/transactions/sepa_credit_transfer/:id';
    
    
    
    
    
    
    private static final String BANK_STATEMENT='/v1/accounts/:account_id/bank_statements';
    private static final String GET_BANK_STATEMENT='/v1/accounts/:account_id/bank_statements/:id/bookings';
    
    private static final String STATEMENT_OF_ACCOUNT='/v1/accounts/:account_id/statement_of_accounts';
    private static final String GET_STATEMENT_OF_ACCOUNT='/v1/accounts/:account_id/statement_of_accounts/:id/bookings';
    
    private static final String GET_PERSON_DETAILS='/v1/persons/:id';
    private static final String GET_ALL_BANK_ACCOUNTS='/v1/persons/:person_id/accounts';
    private static final String Get_ALL_CARDS='/v1/persons/:person_id/cards';
    private static final String GET_ALL_IDENTIFICATION_ATTEPMTS='/v1/persons/:person_id/identifications';
    private static final String GET_ALL_ESigning_ATTEPMTS='/v1/persons/:person_id/signings';
    private static final String GET_PHONE_NUMBER='/v1/persons/:person_id/mobile_number';
    private static final String GET_ALL_TAX_IDENTIFIACTION='/v1/persons/:person_id/tax_identifications';
    private static final String GET_ACCOUNT_BALANCE='/v1/accounts/:account_id/balance';
    private static final String GET_ALL_TIMED_BOOKINGS='/v1/persons/:person_id/accounts/:account_id/timed_orders';
    private static final String CANCEL_TIMED_BOOKING='/v1/persons/:person_id/accounts/:account_id/timed_orders/:id/cancel';
    private static final String GET_ALL_STANDING_ORDERS='/v1/persons/:person_id/accounts/:account_id/standing_orders';
    
    
    private static  String AUTH{private set;get{
        if(AUTH==null) AUTH= EncodingUtil.base64Encode(Blob.valueOf(CLIENT_ID+':'+CLIENT_SECRET));
        
        return AUTH;
    }}
    
    private static void getApiDetails(String tenentType){
        System.debug('SB Tenent => '+tenentType);
        Solarisbank_Api_Config__mdt config=[SELECT id,Auth_Uri__c,Block_Card_URI__c,Bookings_URI__c,Card_Details_URI__c,Client_Id__c,Client_Secret__c,Close_Card_URI__c,Host_Url__c,Reservation_URI__c,Sepa_Credit_Transfer_URI__c,Sepa_Direct_Debit_URI__c,Unblock_Card_URI__c,Version__c
                                            FROM Solarisbank_Api_Config__mdt  WHERE Active__c=true AND DeveloperName=:tenentType LIMIT 1];
        HOST_URL=config.Host_Url__c;
        AUTH_URI=config.Auth_Uri__c;
        BOOKINGS_URI=config.Version__c+config.Bookings_URI__c;
        RESERVATION_URI=config.Version__c+config.Reservation_URI__c;
        BLOCK_CARD=config.Version__c+config.Block_Card_URI__c;
        CLOSE_CARD=config.Version__c+config.Close_Card_URI__c;
        UNBLOCK_CARD=config.Version__c+config.Unblock_Card_URI__c;
        DETAILS_CARD=config.Version__c+config.Card_Details_URI__c;
        GET_SEPADD_TRANSACTION_DETIALS=config.Version__c+config.Sepa_Direct_Debit_URI__c;
        GET_SEPACT_TRANSACTION_DETAILS=config.Version__c+config.Sepa_Credit_Transfer_URI__c;
        CLIENT_ID=config.Client_Id__c;
        CLIENT_SECRET=config.Client_Secret__c;
    }
    private static String access_token{set;get;}
    private static Map<String,String> getHeaders(String tenentType){
        access_token = (access_token==null)?getAccessToken(tenentType):access_token;
        return new Map<String,String>{
            'Content-Type'=>'application/json',
                'Authorization'=>'Bearer '+access_token
                };
                    }
  
    private static String getAccessToken(String tenentType){
        getApiDetails(tenentType);
        HttpResponse response=RestService.post(HOST_URL+AUTH_URI,
                                               new Map<String,String>{
                                                   'Content-Type'=>'application/json',
                                                       'Authorization'=>'Basic '+AUTH
                                                       },
                                               '{"grant_type":"client_credentials","client_id":"'+CLIENT_ID+'","client_secret":"'+CLIENT_SECRET+'"}');
        if(Test.isRunningTest()) return '';
        Map<String,Object> responseBody=(Map<String,Object>) JSON.deserializeUntyped(response.getBody());
        return (String)responseBody.get('access_token');
    }
    
    
    ///////////////////////////
    // Retrive Data
    //////////////////////////
    
    //retreive bank account bookings from solaris bank
    public static String fetchBankAccountBookings(String bankAccountId,String pageNumber,String bookingDateStart,String bookingDateEnd,String recepientIban,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        String bookingUri=BOOKINGS_URI.replace(':account_id', bankAccountId);
        bookingUri+='?sort=-booking_date';
        bookingUri+='&page[number]='+pageNumber+'&page[size]=500';
        if(String.isNotEmpty(bookingDateEnd)) bookingUri+='&filter[booking_date][max]='+bookingDateEnd;
        if(String.isNotEmpty(bookingDateStart)) bookingUri+='&filter[booking_date][min]='+bookingDateStart;
        if(String.isNotEmpty(recepientIban))bookingUri+='&filter[recipient_iban]='+recepientIban;
        details.url=HOST_URL+bookingUri;
        HttpResponse response=RestService.get(HOST_URL+bookingUri,headers);
        details.responseCode=response.getStatusCode();
        LogService.LogApiCall(details);
        return response.getBody();
    }
    
    //retreive bank account reservations from solaris bank
    public static String fetchBankAccountReservations(String bankAccountId,String pageNumber,String expireDateStart,String expiresDateEnd,String refrenceId,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        
        String reservationUri=RESERVATION_URI.replace(':account_id', bankAccountId);
        
        reservationUri+='?page[number]='+pageNumber+'&page[size]=500';
        if(String.isNotEmpty(expiresDateEnd)) reservationUri+='&filter[expires_at][max]='+expiresDateEnd;
        if(String.isNotEmpty(expireDateStart)) reservationUri+='&filter[expires_at][min]='+expireDateStart;
        if(String.isNotEmpty(refrenceId)) reservationUri+='&filter[reference]='+refrenceId;
        details.url=HOST_URL+reservationUri;
        HttpResponse response=RestService.get(HOST_URL+reservationUri,headers);
        details.responseCode=response.getStatusCode();
        LogService.LogApiCall(details);
        return response.getBody();
    }
    
    public static String fetchAccountCard(String cardId,LogService.ApiCallDetails details){
        
        Map<String,String> headers=getHeaders(details.sbTenent);
        String card_uri=DETAILS_CARD.replace(':card_id',cardId);
        details.url=HOST_URL+card_uri;
        HttpResponse response=RestService.get(HOST_URL+card_uri,headers);
        details.responseCode=response.getStatusCode();
        LogService.LogApiCall(details);
        return response.getBody();
    }
    //get bookins transactional seap debit transfer details
    public static String fetchSepaDirectDebit(String solarisPersonAccountId,String solarisBankAccountId,String transactionId,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        
        String seapUri=GET_SEPADD_TRANSACTION_DETIALS.replace(':person_id', solarisPersonAccountId).replace(':account_id', solarisBankAccountId).replace(':id', transactionId);        
        details.url=HOST_URL+seapUri;
        HttpResponse response=RestService.get(HOST_URL+seapUri,headers);
        details.responseCode=response.getStatusCode();
        LogService.LogApiCall(details);
        return response.getBody();
    }
    //get bookins transactional seap credit transfer details
    public static String fetchSepaCreditTransfer(String solarisPersonAccountId,String solarisBankAccountId,String transactionId,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        
        String seapUri=GET_SEPACT_TRANSACTION_DETAILS.replace(':person_id', solarisPersonAccountId).replace(':account_id', solarisBankAccountId).replace(':id', transactionId);        
        HttpResponse response=RestService.get(HOST_URL+seapUri,headers);
        details.url=HOST_URL+seapUri;
        details.responseCode=response.getStatusCode();
        LogService.LogApiCall(details);
        return response.getBody();
    }
    
    //retrive all timed orders
    public static String fetchBankTimedOrders(String solarisPersonAccountId,String solarisBankAccountId,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        
        String timedUri=GET_ALL_TIMED_BOOKINGS.replace(':person_id', solarisPersonAccountId).replace(':account_id', solarisBankAccountId);        
        HttpResponse response=RestService.get(HOST_URL+timedUri,headers);
        details.url=HOST_URL+timedUri;
        details.responseCode=response.getStatusCode();
        LogService.LogApiCall(details);
        return response.getBody();
    }
    //retrive all standing orders
    public static String fetchBankStandingOrders(String solarisPersonAccountId,String solarisBankAccountId,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        
        String timedUri=GET_ALL_STANDING_ORDERS.replace(':person_id', solarisPersonAccountId).replace(':account_id', solarisBankAccountId);        
        HttpResponse response=RestService.get(HOST_URL+timedUri,headers);
        details.url=HOST_URL+timedUri;
        details.responseCode=response.getStatusCode();
        LogService.LogApiCall(details);
        return response.getBody();
    }
    
    //retrives person info
    public static String fetchPersonDetails(String solarisPersonId,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        
        String person_uri=GET_PERSON_DETAILS.replace(':id', solarisPersonId);
        HttpResponse response=RestService.get(HOST_URL+person_uri,headers);
        details.url=HOST_URL+person_uri;
        details.responseCode=response.getStatusCode();
        LogService.LogApiCall(details);
        return response.getBody();
    }
    public static String fetchAllBankAccounts(String solarisPersonId,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        
        String person_uri=GET_ALL_BANK_ACCOUNTS.replace(':person_id', solarisPersonId);
        HttpResponse response=RestService.get(HOST_URL+person_uri,headers);
        details.url=HOST_URL+person_uri;
        details.responseCode=response.getStatusCode();
        LogService.LogApiCall(details);
        return response.getBody();
    }
    public static String fetchAllCards(String solarisPersonId,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        String person_uri=Get_ALL_CARDS.replace(':person_id', solarisPersonId);
        HttpResponse response=RestService.get(HOST_URL+person_uri,headers);
        details.url=HOST_URL+person_uri;
        details.responseCode=response.getStatusCode();
        LogService.LogApiCall(details);
        return response.getBody();
    }
    public static String fetchAllIdentificationAttempts(String solarisPersonId,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        
        String person_uri=GET_ALL_IDENTIFICATION_ATTEPMTS.replace(':person_id', solarisPersonId);
        HttpResponse response=RestService.get(HOST_URL+person_uri,headers);
        details.url=HOST_URL+person_uri;
        details.responseCode=response.getStatusCode();
        LogService.LogApiCall(details);
        return response.getBody();
    }
    public static String fetchAllESigningAttempts(String solarisPersonId,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        
        String person_uri=GET_ALL_ESigning_ATTEPMTS.replace(':person_id', solarisPersonId);
        HttpResponse response=RestService.get(HOST_URL+person_uri,headers);
        details.url=HOST_URL+person_uri;
        details.responseCode=response.getStatusCode();
        LogService.LogApiCall(details);
        return response.getBody();
    }
    public static String fetchPersonPhoneNumber(String solarisPersonId,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        
        String person_uri=GET_PHONE_NUMBER.replace(':person_id', solarisPersonId);
        HttpResponse response=RestService.get(HOST_URL+person_uri,headers);
        details.url=HOST_URL+person_uri;
        details.responseCode=response.getStatusCode();
        LogService.LogApiCall(details);
        return response.getBody();
    }
    public static String fetchAllTaxIdentificationAttempts(String solarisPersonId,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        
        String person_uri=GET_ALL_TAX_IDENTIFIACTION.replace(':person_id', solarisPersonId);
        HttpResponse response=RestService.get(HOST_URL+person_uri,headers);
        details.url=HOST_URL+person_uri;
        details.responseCode=response.getStatusCode();
        LogService.LogApiCall(details);
        return response.getBody();
    }
    public static String fetchAccountBalance(String solarisBankAccountId,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        
        String balance_uri=GET_ACCOUNT_BALANCE.replace(':account_id', solarisBankAccountId);
        HttpResponse response=RestService.get(HOST_URL+balance_uri,headers);
        details.url=HOST_URL+balance_uri;
        details.responseCode=response.getStatusCode();
        LogService.LogApiCall(details);
        return response.getBody();
    }
    
    ///////////////////////////
    // Operation
    //////////////////////////
    /*    create bank statement of account
* 		@body
*    	{
*			"interval": "QUARTERLY",
*			"year": "2020",
*			"period": "2"
*		}
*/
    public static String createBankStatementByPeriod(String accountId,String body,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        
        String statement_uri=STATEMENT_OF_ACCOUNT.replace(':account_id', accountId);
        HttpResponse response=RestService.post(HOST_URL+statement_uri,headers,body);
        details.url=HOST_URL+statement_uri;
        details.responseCode=response.getStatusCode();
        LogService.LogApiCall(details);
        return response.getBody();
    }
    //retreive statement of account
    public static String fetchBankStatementByPeriod(String accountId,String statementId,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        
        String statement_uri=GET_STATEMENT_OF_ACCOUNT.replace(':account_id', accountId).replace(':id',statementId);
        HttpResponse response=RestService.get(HOST_URL+statement_uri,headers);
        details.url=HOST_URL+statement_uri;
        details.responseCode=response.getStatusCode();
        LogService.LogApiCall(details);
        return response.getBody();
    }
    
    /*    create bank statement of account
* 		@body
*    	{
*  			"start_date": "2020-01-15",
*  			"end_date": "2020-06-23"
*		}
*/
    public static String createBankStatementByRange(String accountId,String body,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        
        String statement_uri=BANK_STATEMENT.replace(':account_id', accountId);
        HttpResponse response=RestService.post(HOST_URL+statement_uri,headers,body);
        details.url=HOST_URL+statement_uri;
        details.responseCode=response.getStatusCode();
        LogService.LogApiCall(details);
        return response.getBody();
    }
    //retreive bank statement of account
    public static String fetchBankStatementByRange(String accountId,String statementId,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        
        String statement_uri=GET_BANK_STATEMENT.replace(':account_id', accountId).replace(':id',statementId);
        HttpResponse response=RestService.get(HOST_URL+statement_uri,headers);
        details.url=HOST_URL+statement_uri;
        details.responseCode=response.getStatusCode();
        LogService.LogApiCall(details);
        return response.getBody();
    }
    
    public static String blockAccountCard(String cardId,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        
        String block_uri=BLOCK_CARD.replace(':card_id',cardId);
        HttpResponse response=RestService.post(HOST_URL+block_uri,headers,'');
        details.url=HOST_URL+block_uri;
        details.responseCode=response.getStatusCode();
        LogService.LogApiCall(details);
        return response.getBody();
    }
    
    public static String closeAccountCard(String cardId,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        
        String block_uri=CLOSE_CARD.replace(':card_id',cardId);
        HttpResponse response=RestService.post(HOST_URL+block_uri,headers,'');
        details.url=HOST_URL+block_uri;
        details.responseCode=response.getStatusCode();
        LogService.LogApiCall(details);
        return response.getBody();
    }
    
    public static String unblockAccountCard(String cardId,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        
        String block_uri=UNBLOCK_CARD.replace(':card_id',cardId);
        HttpResponse response=RestService.post(HOST_URL+block_uri,headers,'');
        details.url=HOST_URL+block_uri;
        details.responseCode=response.getStatusCode();
        LogService.LogApiCall(details);
        return response.getBody();
    }
    
    public static String cancelTimedOrder(String solarisPersonAccountId,String solarisBankAccountId,String timedOrderId,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        
        String cancel_url=CANCEL_TIMED_BOOKING.replace(':person_id', solarisPersonAccountId).replace(':account_id', solarisBankAccountId).replace(':id', timedOrderId);
        HttpResponse response=RestService.patch(HOST_URL+cancel_url,headers);
        details.url=HOST_URL+cancel_url;
        details.responseCode=response.getStatusCode();
        LogService.LogApiCall(details);
        return response.getBody();
    }
    
    public class CardResponse{
        @AuraEnabled public String status{set;get;}
        @AuraEnabled public List<CardResponse> errors{set;get;}
        @AuraEnabled public String detail{set;get;}
    }
    

}