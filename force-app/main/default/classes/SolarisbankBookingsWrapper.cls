/***************
* @group Wrapper Class
* @description SB
*/
public class SolarisbankBookingsWrapper {
    
    public String id;
    public String creation_date;
    public String valuta_date;
    public String booking_date;
    public String booking_type;
    public Amount amount;
    public String description;
    public String purpose_code;
    public String recipient_bic;
    public String recipient_iban;
    public String recipient_name;
    public String receiver_iban_virtual;
    public String sender_bic;
    public String sender_iban;
    public String sender_name;
    public String end_to_end_id;
    public String creditor_identifier;
    public String mandate_reference;
    public String transaction_id;
    public String return_transaction_id;
    public Amount sepa_charges;
    public String sepa_return_code;
    public String sepa_return_reason;
    public String sepa_return_reason_definition;
    public String meta_info;
    public String recorded_at;
    public String reconciliation_id;
    
    public class Amount {
        public Integer value;
        public String unit;
    }
    
    
    public static List<SolarisbankBookingsWrapper> parseList(String json) {
        return (List<SolarisbankBookingsWrapper>) System.JSON.deserialize(json, List<SolarisbankBookingsWrapper>.class);
    }
    
    public class MockResponse implements HttpCalloutMock { 
        
        public HTTPResponse respond(HTTPRequest req) { 
            SolarisbankBookingsWrapper book=new SolarisbankBookingsWrapper();
            SolarisbankBookingsWrapper.Amount amount=new SolarisbankBookingsWrapper.Amount();
            amount.unit='cents';
            amount.value=123;            
            book.id='123124';	
            book.creation_date='2016-09-14';
            book.valuta_date='2016-09-14';
            book.booking_date='2016-09-14';
            book.booking_type='SEPA_CREDIT_TRANSFER';
            book.amount=amount;
            book.description='asd';
            book.purpose_code='asd';
            book.recipient_bic='asd';
            book.recipient_iban='asd';
            book.recipient_name='asd';
            book.receiver_iban_virtual='asd';
            book.sender_bic='asd';
            book.sender_iban='asd';
            book.sender_name='asd';
            book.end_to_end_id='asd';
            book.creditor_identifier='asd';
            book.mandate_reference='asd';
            book.transaction_id='asd';
            book.return_transaction_id='asd';
            book.sepa_charges=amount;
            book.sepa_return_code='asd';
            book.sepa_return_reason='asd';
            book.sepa_return_reason_definition='asd';
            book.meta_info='asd';
            book.recorded_at='2016-09-14T17:38:50Z';
            book.reconciliation_id='asd';
            
            
            List<SolarisbankBookingsWrapper> books=new List<SolarisbankBookingsWrapper>();
            books.add(book);
            
            HttpResponse resp = new HttpResponse(); 
            
            resp.setStatusCode(200); 
            
            resp.setStatus('success'); 
            
            resp.setBody(JSON.serialize(books)); 
            
            return resp; 
            
        }
    } 
}