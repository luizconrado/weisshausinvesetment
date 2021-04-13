public class SolarisbankCRPRequestWrapper {
    
    @AuraEnabled public String id; 
    @AuraEnabled public String status; 
    @AuraEnabled public String url; 
    @AuraEnabled public DateTime updated_at; 
    @AuraEnabled public List<errorsWrapper> errors; 
   
    Public class errorsWrapper{
        @AuraEnabled public String code; 
        @AuraEnabled public String title; 
        @AuraEnabled public String detail; 
        @AuraEnabled public String id; 
        
    }
  
   
    public static SolarisbankCRPRequestWrapper parse(String json) {
        return (SolarisbankCRPRequestWrapper) System.JSON.deserialize(json, SolarisbankCRPRequestWrapper.class);
    }
     public class MockResponse implements HttpCalloutMock { 
         Boolean isError=false;
         public MockResponse(){} 
         public MockResponse(Boolean isError){
             this.isError=isError;
         }
         
        public HTTPResponse respond(HTTPRequest req) { 
            SolarisbankCRPRequestWrapper data=new SolarisbankCRPRequestWrapper();
            data.id='asdasd';
            data.status='SUCCESS';
            data.url='www.google.com';
            data.updated_at=Datetime.now();
         
            if(isError){
                errorsWrapper wrap=new errorsWrapper();
                wrap.code='404';
                wrap.title='Error';
                wrap.detail='Error';
                data.id='asdasd';
                data.errors=new List<errorsWrapper>{wrap};
            }
            
                         
            HttpResponse resp = new HttpResponse(); 
            
            resp.setStatusCode(200); 
            
            resp.setStatus('success'); 
            resp.setBody(JSON.serialize(data)); 
            return resp; 
        }
    }

}