/***************
* @group Wrapper Class
* @description SB
*/
public class SolarisbankCardWrapper {
    
    public class Representation {
        public String line_1 {get;set;} 
        public String masked_pan {get;set;} 
        public String formatted_expiration_date {get;set;} 
        public Representation(){}
        public Representation(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'line_1') {
                            line_1 = parser.getText();
                        } else if (text == 'masked_pan') {
                            masked_pan = parser.getText();
                        } else if (text == 'formatted_expiration_date') {
                            formatted_expiration_date = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Representation consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public String id {get;set;} 
    public String type_Z {get;set;} // in json: type
    public String status {get;set;} 
    public String expiration_date {get;set;} 
    public String person_id {get;set;} 
    public String account_id {get;set;} 
    public String business_id {get;set;} 
    public Representation representation {get;set;} 
    public String sia_account_number{set;get;}
    Public String creation_date{set;get;}
    public SolarisbankCardWrapper(){}
    public SolarisbankCardWrapper(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'id') {
                        id = parser.getText();
                    } else if (text == 'type') {
                        type_Z = parser.getText();
                    } else if (text == 'status') {
                        status = parser.getText();
                    } else if (text == 'expiration_date') {
                        expiration_date = parser.getText();
                    } else if (text == 'person_id') {
                        person_id = parser.getText();
                    } else if (text == 'account_id') {
                        account_id = parser.getText();
                    } else if (text == 'representation') {
                        representation = new Representation(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'SolarisbankCardWrapper consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    public static void consumeObject(System.JSONParser parser) {
        Integer depth = 0;
        do {
            System.JSONToken curr = parser.getCurrentToken();
            if (curr == System.JSONToken.START_OBJECT || 
                curr == System.JSONToken.START_ARRAY) {
                    depth++;
                } else if (curr == System.JSONToken.END_OBJECT ||
                           curr == System.JSONToken.END_ARRAY) {
                               depth--;
                           }
        } while (depth > 0 && parser.nextToken() != null);
    }
    
    private static List<SolarisbankCardWrapper> arrayOfSolarisbankCardWrapper(System.JSONParser p) {
        List<SolarisbankCardWrapper> res = new List<SolarisbankCardWrapper>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new SolarisbankCardWrapper(p));
        }
        return res;
    }
    
    public static List<SolarisbankCardWrapper> parseList(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return arrayOfSolarisbankCardWrapper(parser);
    }
    
    public class MockResponse implements HttpCalloutMock { 
        Boolean isError=false;
        public MockResponse(){}
        public MockResponse(Boolean isError){
            isError=isError;
        }
        public HTTPResponse respond(HTTPRequest req) { 
            SolarisbankCardWrapper data=new SolarisbankCardWrapper();
            data.id='123123';
            data.type_Z='123';
            data.status='fsdf';
            data.expiration_date='2022-09-07';
            data.person_id= 'asd';
            data.account_id= 'asd';
            data.business_id='asd';
            data.sia_account_number='asd';
            data.creation_date='2022-09-07';
            SolarisbankCardWrapper.Representation rep=new SolarisbankCardWrapper.Representation();
            rep.line_1='asd';
            rep.masked_pan='asd';
            rep.formatted_expiration_date='asd';
            data.representation=rep;
            
            List<SolarisbankCardWrapper> dataList=new List<SolarisbankCardWrapper>();
            dataList.add(data);
            
            HttpResponse resp = new HttpResponse(); 
            
            resp.setStatusCode(200); 
            
            resp.setStatus('success'); 
           
        
            if(isError){
                 resp.setBody('{"errors":[{"detail":"testing"}]}'); 
            }
            else if(req.getEndpoint().containsIgnoreCase('Unblock')){
                resp.setBody('{"errors":[{"detail":"testing"}]}'); 
            }
            else if(req.getEndpoint().contains('block')){
                data.status='BLOCKED';
                resp.setBody(JSON.serialize(data)); 
                
            }
            else if(req.getEndpoint().startsWith('https://api.solaris-sandbox.de/v1/cards/testcardeaea2acad1bcf119')){
                data.status='BLOCKED';
                resp.setBody(JSON.serialize(data)); 
            }
            else{
                resp.setBody(JSON.serialize(dataList)); 
            }
           
            
            return resp; 
            
        }
    }
    
    
}