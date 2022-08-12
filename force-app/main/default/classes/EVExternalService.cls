/***************
* @group External Service
* @description all api calls are invoked from here to EV Backend service
*/
public class EVExternalService {
    private static  String HOST_URL; 
    private static String ACCESS_TOKEN;
    
    private static String PRODUCTS_URI='products';
    private static String UPDATE_PRODUCTS_URI='products/:id';
    
    private static String DOCUMENT_URI='customers/:auth0Id/documents/:TicketId';
    private static String CUSTOMER_CLASSIFICATION_UPDATE_DETAILS='customers/:auth0Id/categorization';
    private static String DOCUMENT_ARCHIVE_URI='customers/cases/delete';
    
    
    private static String INVESTMENT_UPDATE_DETAILS='investments/:ExternalId';
  
    private static String INVESTMENT_DOCUMENT_DETAILS='investments/:ExternalId/documents';
  	private static String INVESTMENT_DOCUMENT_TEMP_LINK='investments/:ExternalId/customers/:auth0Id/documents/:TicketId';
    
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
    
    
    /***************
    * @description request temp document url whihc allows user to view docuemnt referd in document record
    * @param userAuth0Id user auth0 id
    * @param ticketNumber docuemnt ticket number
    * @return temp document refrence url
    */
    public static String fetchDocumentUrl(String userAuth0Id,String ticketNumber,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        String userDetailsUri=DOCUMENT_URI;
        userDetailsUri=userDetailsUri.replace(':auth0Id', EncodingUtil.urlEncode(userAuth0Id,'UTF-8'));
        userDetailsUri=userDetailsUri.replace(':TicketId', EncodingUtil.urlEncode(ticketNumber,'UTF-8'));
        
        HttpResponse response=RestService.get(HOST_URL+userDetailsUri,headers);
        details.addRequestDetails(HOST_URL+userDetailsUri,'GET','',response.getBody(),response.getStatusCode());
        LogService.LogApiCall(details);
        if(response.getStatusCode()>300) throw new RestService.RestCallException(response.getStatus());
        return response.getBody(); 
    }
    
    /***************
    * @description request temp document url whihc allows user to view docuemnt referd in document record
    * @param userAuth0Id user auth0 id
    * @param ticketNumber docuemnt ticket number
    * @return temp document refrence url
    */
    public static String fetchInvestmentDocumentUrl(String oppExternalId,String userAuth0Id,String ticketNumber,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        String userDetailsUri=INVESTMENT_DOCUMENT_TEMP_LINK;
        userDetailsUri=userDetailsUri.replace(':ExternalId', EncodingUtil.urlEncode(oppExternalId,'UTF-8'));
        userDetailsUri=userDetailsUri.replace(':auth0Id', EncodingUtil.urlEncode(userAuth0Id,'UTF-8'));
        userDetailsUri=userDetailsUri.replace(':TicketId', EncodingUtil.urlEncode(ticketNumber,'UTF-8'));
        
        HttpResponse response=RestService.get(HOST_URL+userDetailsUri,headers);
        details.addRequestDetails(HOST_URL+userDetailsUri,'GET','',response.getBody(),response.getStatusCode());
        LogService.LogApiCall(details);
        if(response.getStatusCode()>300) throw new RestService.RestCallException(response.getStatus());
        return response.getBody(); 
    }
    
    /***************
    * @description send product details to backed 
    * @param body - all fields data of product2 record
    * @return success body
    */
    public static String sendProductsInfo(String body,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        
        HttpResponse response=RestService.post(HOST_URL+PRODUCTS_URI,headers,body);
        details.addRequestDetails(HOST_URL+PRODUCTS_URI,'POST',body,response.getBody(),response.getStatusCode());
        LogService.LogApiCall(details);
        if(response.getStatusCode()>300) throw new RestService.RestCallException(response.getStatus());
        return response.getBody();
    }
    /***************
    * @description send updated product details to backed 
    * @param body - all fields data of product2 record
    * @return success body
    */
    public static String updateProductsInfo(String body,String productId,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        String uri=UPDATE_PRODUCTS_URI;
        uri=uri.replace(':id', productId);
        HttpResponse response=RestService.put(HOST_URL+uri,headers,body);
        details.addRequestDetails(HOST_URL+uri,'PUT',body,response.getBody(),response.getStatusCode());
        LogService.LogApiCall(details);
        if(response.getStatusCode()>300) throw new RestService.RestCallException(response.getStatus());
        return response.getBody();
    }
    
    
     /***************
    * @description send investment opportunties  updates to backend
    * @param externalId - opporunity external id
    * @param body
    * @return success body
    * @example
    * {
      "amount": 1000,
      "status": "ACTIVE",
      "moneyTransferred": true,
      "moneyTransferredAt": "1970-01-01T00:00:00Z",
      "completedAt": "1970-01-01T00:00:00Z",
      "riskAcceptedAt": "1970-01-01T00:00:00Z",
      "moneyTransferBannerEnabled": true,
      "referenceCode": "010101ABC"
    }
    */
    public static String updateInvestmentUpdate(String externalId,String customerId,String body,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        headers.put('x-customer-id',customerId);
        String invDetailsUri=INVESTMENT_UPDATE_DETAILS;
        invDetailsUri=invDetailsUri.replace(':ExternalId', EncodingUtil.urlEncode(externalId,'UTF-8'));
        HttpResponse response=RestService.put(HOST_URL+invDetailsUri,headers,body);
        details.addRequestDetails(HOST_URL+invDetailsUri,'PUT',body,response.getBody(),response.getStatusCode());
        details.addComment(JSON.serialize(headers));
        LogService.LogApiCall(details);
        if(response.getStatusCode()>300) throw new RestService.RestCallException(response.getStatus());
        return response.getBody();
    }
    
    /***************
    * @description sends details of all fiels attached to investment opportunity to backend 
    * @param externalId - opporunity external id
    * @param body - attachment file details
    * @return success body
    */
     public static String sendInvestmentDocumentInformation(String externalId,String body,LogService.ApiCallDetails details){
        
        Map<String,String> headers=getHeaders(details.sbTenent);
        
        String invDetailsUri=INVESTMENT_DOCUMENT_DETAILS;
        invDetailsUri=invDetailsUri.replace(':ExternalId', EncodingUtil.urlEncode(externalId,'UTF-8'));
        HttpResponse response=RestService.post(HOST_URL+invDetailsUri,headers,body);
        details.addRequestDetails(HOST_URL+invDetailsUri,'POST',body,response.getBody(),response.getStatusCode());
        LogService.LogApiCall(details);
         
        if(response.getStatusCode()>300) throw new RestService.RestCallException(response.getStatus());
        return response.getBody();
    }
    
     /***************
    * @description send customer CLASSIFICATION  updates to backend
    * @param externalId - external id
    * @param body
    * @return success body
    * @example
    * {"status":"ONGOING" }
    */
    public static String updateCustomerClassificationUpdate(String externalId,String customerId,String body,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        String invDetailsUri=CUSTOMER_CLASSIFICATION_UPDATE_DETAILS;
        invDetailsUri=invDetailsUri.replace(':auth0Id', EncodingUtil.urlEncode(customerId,'UTF-8'));
        HttpResponse response=RestService.patch(HOST_URL+invDetailsUri,headers,body);
        details.addRequestDetails(HOST_URL+invDetailsUri,'PATCH',body,response.getBody(),response.getStatusCode()); 
        details.addComment(JSON.serialize(headers));
        LogService.LogApiCall(details);
        if(response.getStatusCode()>300) throw new RestService.RestCallException(response.getStatus());
        return response.getBody();
    }
      /***************
    * @description send customer case archive zip file link to backend
    * @param body
    * @return success body
    * @example
    * {
    *   "fileName": "string",
    *   "customerId": "string",
    *   "fileUrl": "string",
    *    "documentId": "string"
    *  }
    */
    public static String sendCustomerCaseArchiveFile(String body,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        String invDetailsUri=DOCUMENT_ARCHIVE_URI;
        HttpResponse response=RestService.post(HOST_URL+invDetailsUri,headers,body);
        details.addRequestDetails(HOST_URL+invDetailsUri,'POST',body,response.getBody(),response.getStatusCode()); 
        details.addComment(JSON.serialize(headers));
        LogService.LogApiCall(details);
        if(response.getStatusCode()>300) throw new RestService.RestCallException(response.getStatus());
        return response.getBody();
    }
    
    
    
}