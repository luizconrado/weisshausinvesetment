/***************
* @group Utility Class
* @description helper class to send response from custom api
*/
global class RestResponseWrapper {
    global Integer status{set;get;}
    global List<String> error{set;get;}
    global List<Object> success{set;get;}
    
    global static Blob setError(Integer status,List<String> error){
        RestResponseWrapper returnValue=new RestResponseWrapper();
        returnValue.status=status;
        returnValue.error=error;
        returnValue.success=new List<Object>();
        return Blob.valueOf(JSON.serialize(returnValue));
    }
    global static Blob setSuccess(Integer status,List<Object> success){
        RestResponseWrapper returnValue=new RestResponseWrapper();
        returnValue.status=status;
        returnValue.error=new List<String>();
        returnValue.success=success;
        return Blob.valueOf(JSON.serialize(returnValue));
    }
     
}