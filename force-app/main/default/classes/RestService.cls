public inherited  sharing class RestService {
    
    public static HttpResponse get(String endpoint,Map<String,String> headers){
        return call('GET',endpoint,headers,'',null);
    }  
    public static HttpResponse patch(String endpoint,Map<String,String> headers,String body){
        return call('PATCH',endpoint,headers,body,null);
    } 
    public static HttpResponse put(String endpoint,Map<String,String> headers,String body){
        return call('PUT',endpoint,headers,body,null);
    } 
    
    public static HttpResponse post(String endpoint,Map<String,String> headers,String body){
        return call('POST',endpoint,headers,body,null);
    }  
    
    public static HttpResponse extraTimoutpost(String endpoint,Map<String,String> headers,String body,Integer timeoutSec){
        return call('POST',endpoint,headers,body,timeoutSec);
    }  
    
    private static HttpResponse call(String method,String endpoint,Map<String,String> headers,String body,Integer timeoutSec){
        HttpRequest request=new HttpRequest();
        System.debug('API call to => '+endpoint);
        request.setEndpoint(endpoint);
        request.setMethod(method);
        if(timeoutSec!=null)request.setTimeout(timeoutSec);
        if(String.isNotEmpty(body)) request.setBody(body);
        for(String header:headers.keySet()) request.setHeader(header,headers.get(header));
        HttpResponse response=new HttP().send(request);
        System.debug('Rest Status '+response.getStatus());
        System.debug('Rest Response '+response.getBody());
        return response;
    }
    
    public class RestCallException extends Exception {}
    
    

}