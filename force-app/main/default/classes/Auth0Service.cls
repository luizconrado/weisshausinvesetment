/***************
* @group External Service
* @description all api calls to Auth0 are configured here
*/
public inherited  sharing  class Auth0Service {
    private static  String HOST_URL;//='https://digibank-ev.eu.auth0.com';
    private static  String CLIENT_ID;//='wPBXw3DRQz8FZxjddeIXMtbX08CffPv5';
    private static  String CLIENT_SECRET;//='Y5k7YvdBimGGJGBmqujvRKaRV-5mMOf3gAGzXGWCi7w60Ab1p1wkzRsD-vEfpihR';
    private static  String AUTH_URI;//='/oauth/token';
    private static  String VERSION;// ='/api/v2/';
    private static String GET_USER_DETAILS_URI='users/:id';
    
    
    private static String access_token{set;get;}
    
        
    private static void getApiDetails(String tenentType){
        Solarisbank_Api_Config__mdt config=[SELECT id,Proxy_API_Key__c,Auth_Uri__c,Block_Card_URI__c,Bookings_URI__c,Card_Details_URI__c,Client_Id__c,Client_Secret__c,Close_Card_URI__c,Host_Url__c,Reservation_URI__c,Sepa_Credit_Transfer_URI__c,Sepa_Direct_Debit_URI__c,Unblock_Card_URI__c,Version__c
                                            FROM Solarisbank_Api_Config__mdt  WHERE Active__c=true AND DeveloperName='Auth0' LIMIT 1];
        HOST_URL=config.Host_Url__c;
        AUTH_URI=config.Auth_Uri__c;
        VERSION='/api/'+config.Version__c+'/';
        CLIENT_ID=config.Client_Id__c;
        CLIENT_SECRET=config.Client_Secret__c;
         
        
        
    }
    
    public static String getAccessToken(String tenentType){
        getApiDetails(tenentType);
        HttpResponse response=RestService.extraTimoutpost(HOST_URL+AUTH_URI,
                                               new Map<String,String>{
                                                   'Content-Type'=>'application/json'
                                                    },
                                               '{"grant_type":"client_credentials","client_id":"'+CLIENT_ID+'","client_secret":"'+CLIENT_SECRET+'","audience":"'+HOST_URL+VERSION+'"}',30000);
        
      
        Map<String,Object> responseBody=(Map<String,Object>) JSON.deserializeUntyped(response.getBody());
        return (String)responseBody.get('access_token');
    }
    
    private static Map<String,String> getHeaders(String tenentType){
        access_token = (access_token==null)?getAccessToken(tenentType):access_token;
        return new Map<String,String>{
            'Content-Type'=>'application/json',
                'Authorization'=>'Bearer '+access_token
                };
                    }
    
    /***************
    * @description retirves user details 
    * @param userAuth0Id id of user
    * @return user details
    */
    public static String fetchUserDetails(String userAuth0Id,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        String userDetailsUri=VERSION+GET_USER_DETAILS_URI;
        userDetailsUri=userDetailsUri.replace(':id', EncodingUtil.urlEncode(userAuth0Id,'UTF-8'));
        
       
        HttpResponse response=RestService.get(HOST_URL+userDetailsUri,headers);
        details.url=HOST_URL+userDetailsUri;
        details.responseCode=response.getStatusCode();
        details.calltype='GET';
        
        if(response.getStatusCode() != 200 || response.getStatusCode() != 201) details.responseBody=response.getBody();
        LogService.LogApiCall(details);
        if(response.getStatusCode()>300) throw new RestService.RestCallException(response.getStatus());
        return response.getBody(); 
    }
    
    /***************
    * @description updates user details
    * @param userAuth0Id id of user
    * @param body request body
    * @return update response
    * @example of body
    * { "user_metadata": { "term_deposit_enabled":'+status+' } }
    */
    public static String updateUserDetails(String userAuth0Id,String body,LogService.ApiCallDetails details){
        Map<String,String> headers=getHeaders(details.sbTenent);
        String userDetailsUri=VERSION+GET_USER_DETAILS_URI;
        userDetailsUri=userDetailsUri.replace(':id',EncodingUtil.urlEncode(userAuth0Id,'UTF-8'));
        HttpResponse response=RestService.patch(HOST_URL+userDetailsUri, headers, body);
        details.calltype='PATCH';
        details.url=HOST_URL+userDetailsUri;
        details.responseCode=response.getStatusCode();
        if(response.getStatusCode() != 200 || response.getStatusCode() != 201) details.responseBody=response.getBody();
        LogService.LogApiCall(details);
        if(response.getStatusCode()>300) throw new RestService.RestCallException(response.getStatus());
        return response.getBody();
    }
    
}