public class EVExternalService {
    private static  String HOST_URL; 
    private static String ACCESS_TOKEN;
    
    private static String PRODUCTS_URI='products';
    private static String UDPATE_PRODUCTS_URI='products/:id';
    private static String DOCUMENT_URI='customers/:auth0Id/documents/:TicketId';
    private static String INVESTMENT_MONEY_TRANSFERD_FLAG='investments/:ExternalId/money-transferred';
    private static String INVESTMENT_STATUS_CHANGED_FLAG='investments/:ExternalId';
    private static String INVESTMENT_DOCUMENT_DETAILS='investments/:ExternalId/documents';
  
    
    private static void getApiDetails(String tenentType){
        
        String accessConfigDetails=(tenentType=='Production')?'EVConnect_Prod':'EVConnect_Dev';
        Solarisbank_Api_Config__mdt config=[SELECT id,Proxy_API_Key__c,Auth_Uri__c,Block_Card_URI__c,Bookings_URI__c,Card_Details_URI__c,Client_Id__c,Client_Secret__c,Close_Card_URI__c,Host_Url__c,Reservation_URI__c,Sepa_Credit_Transfer_URI__c,Sepa_Direct_Debit_URI__c,Unblock_Card_URI__c,Version__c
                                            FROM Solarisbank_Api_Config__mdt  WHERE Active__c=true AND DeveloperName=:accessConfigDetails LIMIT 1];
        HOST_URL=config.Host_Url__c;
        ACCESS_TOKEN=config.Proxy_API_Key__c;
        
        
        
    }
    private static Map<String,String> getHeaders(String tenentType){
        getApiDetails(tenentType);
        return new Map<String,String>{
            
            'x-api-key'=>ACCESS_TOKEN
                };
                    }
    
    //document
    public static String fetchDocumentUrl(String userAuth0Id,String ticketNumber,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        String userDetailsUri=DOCUMENT_URI;
        userDetailsUri=userDetailsUri.replace(':auth0Id', EncodingUtil.urlEncode(userAuth0Id,'UTF-8'));
        userDetailsUri=userDetailsUri.replace(':TicketId', EncodingUtil.urlEncode(ticketNumber,'UTF-8'));
        
        HttpResponse response=RestService.get(HOST_URL+userDetailsUri,headers);
        details.url=HOST_URL+userDetailsUri;
        details.responseCode=response.getStatusCode();
        details.calltype='GET';
         
        if(response.getStatusCode() != 200 || response.getStatusCode() != 201) details.responseBody=response.getBody();
        LogService.LogApiCall(details);
        if(response.getStatusCode()>300) throw new RestService.RestCallException(response.getStatus());
        return response.getBody(); 
    }
    
    //product
    public static String sendProductsInfo(String body,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        
        HttpResponse response=RestService.post(HOST_URL+PRODUCTS_URI,headers,body);
        details.url=HOST_URL+PRODUCTS_URI;
        details.responseCode=response.getStatusCode();
        details.calltype='POST';
        if(response.getStatusCode()>300) details.requestBody=body;
        if(response.getStatusCode() != 200 || response.getStatusCode() != 201) details.responseBody=response.getBody();
        LogService.LogApiCall(details);
        if(response.getStatusCode()>300) throw new RestService.RestCallException(response.getStatus());
        return response.getBody();
    }
    public static String updateProductsInfo(String body,String productId,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        String uri=UDPATE_PRODUCTS_URI;
        uri=uri.replace(':id', productId);
        HttpResponse response=RestService.put(HOST_URL+uri,headers,body);
        details.url=HOST_URL+uri;
        details.responseCode=response.getStatusCode();
        details.calltype='PUT';
        if(response.getStatusCode()>300) details.requestBody=body;
        if(response.getStatusCode() != 200 || response.getStatusCode() != 201) details.responseBody=response.getBody();
        LogService.LogApiCall(details);
        if(response.getStatusCode()>300) throw new RestService.RestCallException(response.getStatus());
        return response.getBody();
    }
    
    //Invesemnet
    
    public static String sendInvestmentMoneyTransferdStatus(String externalId,boolean status,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        DateTime dt=DateTime.now();
        DateTime dtGmt=Datetime.valueOfGmt(String.valueOf(dt));
        String gmtDTString=JSON.serialize(dtGmt);
        
        String invDetailsUri=INVESTMENT_MONEY_TRANSFERD_FLAG;
        invDetailsUri=invDetailsUri.replace(':ExternalId', EncodingUtil.urlEncode(externalId,'UTF-8'));
        HttpResponse response=RestService.put(HOST_URL+invDetailsUri,headers,'{"moneyTransferred":'+status+',"moneyTransferredAt":'+gmtDTString+'}');
        details.url=HOST_URL+invDetailsUri;
        details.responseCode=response.getStatusCode(); 
        details.calltype='PUT';
        if(response.getStatusCode() != 200 || response.getStatusCode() != 201) details.responseBody=response.getBody() ;
        LogService.LogApiCall(details);
        if(response.getStatusCode()>300) throw new RestService.RestCallException(response.getStatus());
        return response.getBody();
    }
    public static String sendInvestmentStatusChange(String externalId,String status,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        
        String invDetailsUri=INVESTMENT_STATUS_CHANGED_FLAG;
        invDetailsUri=invDetailsUri.replace(':ExternalId', EncodingUtil.urlEncode(externalId,'UTF-8'));
        HttpResponse response=RestService.put(HOST_URL+invDetailsUri,headers,'{"status":"'+status+'"}');
        details.url=HOST_URL+invDetailsUri;
        details.responseCode=response.getStatusCode(); 
        details.calltype='PUT';
        details.requestBody='{"status":"'+status+'"}';
        if(response.getStatusCode() != 200 || response.getStatusCode() != 201) details.responseBody=response.getBody();
        LogService.LogApiCall(details);
        if(response.getStatusCode()>300) throw new RestService.RestCallException(response.getStatus());
        return response.getBody();
    }
    public static String sendInvestmentDocumentInformation(String externalId,String body,LogService.ApiCallDetails details){
        
        Map<String,String> headers=getHeaders(details.sbTenent);
        
        String invDetailsUri=INVESTMENT_DOCUMENT_DETAILS;
        invDetailsUri=invDetailsUri.replace(':ExternalId', EncodingUtil.urlEncode(externalId,'UTF-8'));
        HttpResponse response=RestService.post(HOST_URL+invDetailsUri,headers,body);
        details.url=HOST_URL+invDetailsUri;
        details.responseCode=response.getStatusCode(); 
        details.calltype='POST';
        details.requestBody=body;
        if(response.getStatusCode() != 200 || response.getStatusCode() != 201) details.responseBody=response.getBody();
        LogService.LogApiCall(details);
        if(response.getStatusCode()>300) throw new RestService.RestCallException(response.getStatus());
        return response.getBody();
    }
    
    
}