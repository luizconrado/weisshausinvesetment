/***************
* @group Wrapper Class
* @description SB
*/
public class SolarisbankReservationWrapper {
    
    public String id;
    public Amount amount;
    public String reservation_type;
    public String reference;
    public String status;
    public String meta_info;
    public String expires_at;
    public String expired_at;
    public String resolved_at;
    public String description;
    
    public class Amount {
        public Integer value;
        public String unit;
    }
    
    
    public static List<SolarisbankReservationWrapper> parseList(String json) {
        return (List<SolarisbankReservationWrapper>) System.JSON.deserialize(json, List<SolarisbankReservationWrapper>.class);
    }
    public class MockResponse implements HttpCalloutMock { 
        
        public HTTPResponse respond(HTTPRequest req) { 
            SolarisbankReservationWrapper data=new SolarisbankReservationWrapper();
            SolarisbankReservationWrapper.Amount amount=new SolarisbankReservationWrapper.Amount();
            amount.unit='cents';
            amount.value=123;            
            data.id='asd';
            data.amount=amount;
            data.reservation_type='asd';
            data.reference='asd';
            data.status='asd';
            data.meta_info='asd';
            data.expires_at='2017-10-02T16:12:41Z';
            data.expired_at='2017-10-02T16:12:41Z';
            data.resolved_at='2017-10-02T16:12:41Z';
            data.description='asd';
            
            
            List<SolarisbankReservationWrapper> dataList=new List<SolarisbankReservationWrapper>();
            dataList.add(data);
            
            HttpResponse resp = new HttpResponse(); 
            
            resp.setStatusCode(200); 
            
            resp.setStatus('success'); 
            
            resp.setBody(JSON.serialize(dataList)); 
            
            return resp; 
            
        }
    } 
}