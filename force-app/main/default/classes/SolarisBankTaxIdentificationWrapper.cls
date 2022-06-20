/***************
* @group Wrapper Class
* @description SB
*/
public class SolarisBankTaxIdentificationWrapper {

	public String id {get;set;} 
	public String country {get;set;} 
	public String number_Z {get;set;} // in json: number
	public Boolean primary {get;set;} 
	public String reason_no_tin {get;set;} 
	public String reason_description {get;set;} 

	public SolarisBankTaxIdentificationWrapper(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'id') {
						id = parser.getText();
					} else if (text == 'country') {
						country = parser.getText();
					} else if (text == 'number') {
						number_Z = parser.getText();
					} else if (text == 'primary') {
						primary = parser.getBooleanValue();
					} else if (text == 'reason_no_tin') {
						reason_no_tin = parser.getText();
					} else if (text == 'reason_description') {
						reason_description = parser.getText();
					} else {
						System.debug(LoggingLevel.WARN, 'SolarisBankTaxIdentificationWrapper consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
    public SolarisBankTaxIdentificationWrapper(){}	
	public static List<SolarisBankTaxIdentificationWrapper> parseList(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return arrayOfSolarisBankTaxIdentificationWrapper(parser);
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
	




    private static List<SolarisBankTaxIdentificationWrapper> arrayOfSolarisBankTaxIdentificationWrapper(System.JSONParser p) {
        List<SolarisBankTaxIdentificationWrapper> res = new List<SolarisBankTaxIdentificationWrapper>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new SolarisBankTaxIdentificationWrapper(p));
        }
        return res;
    }
    
    public class MockResponse implements HttpCalloutMock { 
        
        public HTTPResponse respond(HTTPRequest req) { 
            SolarisBankTaxIdentificationWrapper data=new SolarisBankTaxIdentificationWrapper();
            data.id='asdasdsa';
            data.country='DE';
            data.number_Z='asd';
            data.primary=true;
            data.reason_no_tin='asdasd';
            data.reason_description='asdasd';
            
            List<SolarisBankTaxIdentificationWrapper> dataList=new List<SolarisBankTaxIdentificationWrapper>();
            dataList.add(data);
            
            HttpResponse resp = new HttpResponse(); 
            
            resp.setStatusCode(200); 
            
            resp.setStatus('success'); 
            
            resp.setBody(JSON.serialize(dataList)); 
            
            return resp; 
            
        }
    }

}