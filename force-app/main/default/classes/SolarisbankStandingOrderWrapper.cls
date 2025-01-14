/***************
* @group Wrapper Class
* @description SB
*/
public class SolarisbankStandingOrderWrapper {

	public class Amount {
		public Integer value;
		public String unit;
		
	}

	public String id;
	public String status;
	public String recipient_iban;
	public String recipient_name;
	public String recipient_bic;
	public String reference;
	public Amount amount;
	public String description;
	public String first_execution_date;
	public String last_execution_date;
	public String reoccurrence;
	public String end_to_end_id;
	public Boolean month_end_execution;
	public String next_occurrence;

	
	public static List<SolarisbankStandingOrderWrapper> parseList(String json) {
		return (List<SolarisbankStandingOrderWrapper>) System.JSON.deserialize(json, List<SolarisbankStandingOrderWrapper>.class);
	}
    
    public class MockResponse implements HttpCalloutMock { 
        
        public HTTPResponse respond(HTTPRequest req) { 
            SolarisbankStandingOrderWrapper data=new SolarisbankStandingOrderWrapper();
            SolarisbankStandingOrderWrapper.Amount amount=new SolarisbankStandingOrderWrapper.Amount();
            amount.unit='cents';
            amount.value=1235;
            data.id='1234';
            data.status='asd';
            data.recipient_iban='asd';
            data.recipient_name='asd';
            data.recipient_bic='asd';
            data.reference='asd';
            data.amount=amount;
            data.description='123';
            data.first_execution_date='2017-10-20';
            data.last_execution_date='2017-10-20';
            data.reoccurrence='asd';
            data.end_to_end_id='asd';
            data.month_end_execution=true;
            data.next_occurrence='2017-10-20';
          
          
            
            
            List<SolarisbankStandingOrderWrapper> dataList=new List<SolarisbankStandingOrderWrapper>();
            dataList.add(data);
            
            HttpResponse resp = new HttpResponse(); 
            
            resp.setStatusCode(200); 
            
            resp.setStatus('success'); 
            
            resp.setBody(JSON.serialize(dataList)); 
            
            return resp; 
            
        }
    }
}