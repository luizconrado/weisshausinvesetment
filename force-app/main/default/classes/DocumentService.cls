public  inherited  sharing class DocumentService {
    private static  String HOST_URL; 
    private static  String DOCUMENT_URL; 
    private static String ACCESS_TOKEN;
    
    
    private static void getApiDetails(String tenentType){
        
        String accessConfigDetails=(tenentType=='Production')?'DocumentRead_Prod':'DocumentRead_Dev';
        Solarisbank_Api_Config__mdt config=[SELECT id,Proxy_API_Key__c,Auth_Uri__c,Block_Card_URI__c,Bookings_URI__c,Card_Details_URI__c,Client_Id__c,Client_Secret__c,Close_Card_URI__c,Host_Url__c,Reservation_URI__c,Sepa_Credit_Transfer_URI__c,Sepa_Direct_Debit_URI__c,Unblock_Card_URI__c,Version__c
                                            FROM Solarisbank_Api_Config__mdt  WHERE Active__c=true AND DeveloperName=:accessConfigDetails LIMIT 1];
        HOST_URL=config.Host_Url__c;
        DOCUMENT_URL=config.Auth_Uri__c;
        ACCESS_TOKEN=config.Proxy_API_Key__c;
        
        
        
    }
    private static Map<String,String> getHeaders(String tenentType){
        getApiDetails(tenentType);
        return new Map<String,String>{
             
                'x-api-key'=>ACCESS_TOKEN
                };
                    }
    
    public static String fetchDocumentUrl(String userAuth0Id,String ticketNumber,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        String userDetailsUri=DOCUMENT_URL;
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
}