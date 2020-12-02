public inherited  sharing class RestService {
    
    public static HttpResponse get(String endpoint,Map<String,String> headers){
        return call('GET',endpoint,headers,'');
    }  
    public static HttpResponse patch(String endpoint,Map<String,String> headers){
        return call('PATCH',endpoint,headers,'');
    } 
    
    public static HttpResponse post(String endpoint,Map<String,String> headers,String body){
        return call('POST',endpoint,headers,body);
    }  
    
    private static HttpResponse call(String method,String endpoint,Map<String,String> headers,String body){
        HttpRequest request=new HttpRequest();
        System.debug('API call to => '+endpoint);
        request.setEndpoint(endpoint);
        request.setMethod(method);
        if(String.isNotEmpty(body)) request.setBody(body);
        for(String header:headers.keySet()) request.setHeader(header,headers.get(header));
        HttpResponse response=new HttP().send(request);
        System.debug('Rest Status '+response.getStatus());
        System.debug('Rest Response '+response.getBody());
        return response;
    }
}