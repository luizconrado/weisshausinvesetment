public class SolarisbankBankAccountWrapper {
    public String id {get;set;} 
    public String iban {get;set;} 
    public String bic {get;set;} 
    public String type_Z {get;set;} // in json: type
    
    public String locking_status {get;set;} 
    public List<String> locking_reasons {get;set;} 
    public String person_id {get;set;} 
    public String status {get;set;} 
    public String closure_reasons {get;set;} 
    public Date technical_closure_date {get;set;} 
    public Date legal_closure_date {get;set;} 
    public Boolean error{set;get;}
      
    //{"errors":[{"id":"76885565-5da2-4def-a155-96955e97f1d0","status":403,"code":"unauthorized_action","title":"Unauthorized Action","detail":"Action 'solaris_account_closure_request#create' is not allowed"}]}
    public SolarisbankBankAccountWrapper(){}
    public SolarisbankBankAccountWrapper(JSONParser  parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'id') {
                        id = parser.getText();
                    } else if (text == 'iban') {
                        iban = parser.getText();
                    } else if (text == 'bic') {
                        bic = parser.getText();
                    } else if (text == 'type') {
                        type_Z = parser.getText();
                    } else if (text == 'locking_status') {
                        locking_status = parser.getText();
                    } else if (text == 'locking_reasons') {
                        locking_reasons = arrayOfString(parser);
                    } else if (text == 'person_id') {
                        person_id = parser.getText();
                    } else if (text == 'status') {
                        status = parser.getText();
                    } else if (text == 'closure_reasons') {
                        closure_reasons = parser.getText();
                    }
                    else if (text == 'technical_closure_date') {
                        technical_closure_date = Date.valueOf(parser.getText());
                    }
                    else if (text == 'legal_closure_date') {
                        legal_closure_date = Date.valueOf(parser.getText());
                    }
                    else if(text=='errors'){
                        error=true;
                    }
                    else {
                       	
                        System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    public class Locking_reasons {
        
      
        public Locking_reasons(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        {
                            System.debug(LoggingLevel.WARN, 'Locking_reasons consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Errors {
        @AuraEnabled public String id {get;set;} 
        @AuraEnabled public String title {get;set;} 
        @AuraEnabled public String detail {get;set;} 
        @AuraEnabled public List<Errors> errors{get;set;}

    }
    public static Errors parseError(String jsonString){
        return  (Errors) System.JSON.deserialize(jsonString, Errors.Class);
    }
    public static List<SolarisbankBankAccountWrapper> parseList(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return arrayOfSolarisbankBankAccountWrapper(parser);
    }
    public static SolarisbankBankAccountWrapper parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return objectOfSolarisbankBankAccountWrapper(parser);
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
    
    
    private static List<SolarisbankBankAccountWrapper> arrayOfSolarisbankBankAccountWrapper(System.JSONParser p) {
        List<SolarisbankBankAccountWrapper> res = new List<SolarisbankBankAccountWrapper>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new SolarisbankBankAccountWrapper(p));
        }
        return res;
    }
    
     private static SolarisbankBankAccountWrapper objectOfSolarisbankBankAccountWrapper(System.JSONParser p) {
        List<SolarisbankBankAccountWrapper> res = new List<SolarisbankBankAccountWrapper>();
        if (p.getCurrentToken() == null) p.nextToken();
        return new SolarisbankBankAccountWrapper(p);
    }
    
    
    private static List<String> arrayOfString(System.JSONParser p) {
        List<String> res = new List<String>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getText());
        }
        return res;
    }
    
    
    
    
    
    
    private static List<Locking_reasons> arrayOfLocking_reasons(System.JSONParser p) {
        List<Locking_reasons> res = new List<Locking_reasons>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Locking_reasons(p));
        }
        return res;
    }
    
    public class MockResponse implements HttpCalloutMock { 
        
        public HTTPResponse respond(HTTPRequest req) { 
            SolarisbankBankAccountWrapper data=new SolarisbankBankAccountWrapper();
            
            List<String> reasons=new List<String>();
            reasons.add('reason');
            data.id='1asd';
            data.iban='asd';
            data.bic='asd';
            data.type_Z='asdf';
            data.locking_status='asd';
            data.person_id='asd';
            data.status='asd';
            data.locking_reasons=reasons;
          
            
            List<SolarisbankBankAccountWrapper> dataList=new List<SolarisbankBankAccountWrapper>();
            dataList.add(data);
            
            HttpResponse resp = new HttpResponse(); 
            
            resp.setStatusCode(200); 
            
            resp.setStatus('success'); 
            
            resp.setBody(JSON.serialize(dataList)); 
            
            return resp; 
            
        }
    }
    
}