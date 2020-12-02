public class SolarisBankIdentificationWrapper {
    @AuraEnabled public String id;
    @AuraEnabled public String reference;
    @AuraEnabled public String url;
    @AuraEnabled public String status;
    @AuraEnabled public String state;
    @AuraEnabled public String completed_at;
    @AuraEnabled public String method;
    @AuraEnabled public String identification_id;
    @AuraEnabled public String failure_reason;
    
    
     @AuraEnabled 
     public static List<SolarisBankIdentificationWrapper> parseList(String json) {
        return (List<SolarisBankIdentificationWrapper>) System.JSON.deserialize(json, List<SolarisBankIdentificationWrapper>.class);
    }
    
       
    public class MockResponse implements HttpCalloutMock { 
        
        public HTTPResponse respond(HTTPRequest req) { 
            SolarisBankIdentificationWrapper data=new SolarisBankIdentificationWrapper();
            data.id='asdasd';
            data.reference='asdasd';
            data.url='www.google.com';
            data.status='asdasd';
            data.state='asdasd';
            data.completed_at='2016-09-14T18:18:28.000Z';
            data.method='idnow';
            data.identification_id='asd';
            data.failure_reason='asd';
            
            List<SolarisBankIdentificationWrapper> dataList=new List<SolarisBankIdentificationWrapper>();
            dataList.add(data);
            
            HttpResponse resp = new HttpResponse(); 
            
            resp.setStatusCode(200); 
            
            resp.setStatus('success'); 
           
            resp.setBody(JSON.serialize(dataList)); 
            
            return resp; 
            
        }
    }
}