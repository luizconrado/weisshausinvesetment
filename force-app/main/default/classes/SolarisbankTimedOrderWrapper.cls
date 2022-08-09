/***************
* @group Wrapper Class
* @description SB
*/
public class SolarisbankTimedOrderWrapper {
    
    public String id;
    public String execute_at;
    public String executed_at;
    public String status;
    public Scheduled_transaction scheduled_transaction;
    
    public class Amount {
        public Integer value;
        public String unit;
    }
    
    public class Scheduled_transaction {
        public String id;
        public String status;
        public String reference;
        public Amount amount;
        public String description;
        public String recipient_iban;
        public String recipient_name;
        public String recipient_bic;
        public String end_to_end_id;
        public String batch_id;
        public String created_at;
    }
    
    
    public static List<SolarisbankTimedOrderWrapper> parseList(String json) {
        return (List<SolarisbankTimedOrderWrapper>) System.JSON.deserialize(json, List<SolarisbankTimedOrderWrapper>.class);
    }
    public static SolarisbankTimedOrderWrapper parseObject(String json) {
        return (SolarisbankTimedOrderWrapper) System.JSON.deserialize(json, SolarisbankTimedOrderWrapper.class);
    }
    
    public class MockResponse implements HttpCalloutMock { 
        
        public HTTPResponse respond(HTTPRequest req) { 
            SolarisbankTimedOrderWrapper order=new SolarisbankTimedOrderWrapper();
            order.id='123455';
            order.execute_at='2018-01-01';
            order.executed_at='2018-01-01T06:20:45Z';
            order.status='SCHEDULED';
            SolarisbankTimedOrderWrapper.Amount amount=new SolarisbankTimedOrderWrapper.Amount();
            amount.unit='cents';
            amount.value=1235;
          
            SolarisbankTimedOrderWrapper.Scheduled_transaction trans=new SolarisbankTimedOrderWrapper.Scheduled_transaction();
            trans.id='asdasf';
            trans.status='created';
            trans.reference='asdasd';
            trans.amount=amount;
            trans.description='asdasdsad';
            trans.recipient_iban='asdasdasd';
            trans.recipient_name='asdasd';
            trans.recipient_bic='asd';
            trans.end_to_end_id='asdg';
            trans.batch_id='asd';
            trans.created_at='2017-01-01T20:37:50Z';
            order.scheduled_transaction=trans;
            
            
            
            
            HttpResponse resp = new HttpResponse(); 
            
            resp.setStatusCode(200); 
            
            resp.setStatus('success'); 
            
            resp.setBody(JSON.serialize(order)); 
           
            return resp; 
            
        }
    } 
}