public class SolarisBankIdentificationAttempt {
    public String id {get;set;} 
    public String result {get;set;} 
    public String reason {get;set;} 
    public Payload payload {get;set;} 
    
    public class Identificationprocess {
        public String result {get;set;} 
        public String companyid {get;set;} 
        public String agentname {get;set;} 
        public String identificationtime {get;set;} 
        public String id {get;set;} 
        public String type {get;set;} 
        public String transactionnumber {get;set;} 
    }
    
    public class Customdata {
        public String custom3 {get;set;} 
        public String custom4 {get;set;} 
        public String custom1 {get;set;} 
        public String custom2 {get;set;} 
        public String custom5 {get;set;} 
    }
    
    public class Contactdata {
		public String mobilephone {get;set;} 
		public String email {get;set;} 

		 
	}
    public class Birthday {
		public String status {get;set;} 
		public String original {get;set;} 
        public String value {get;set;} 
		 
	}
    public class Userdata {
		public Birthday birthday {get;set;} 
		public Birthday firstname {get;set;} 
		public Address address {get;set;} 
		public Birthday birthplace {get;set;} 
        public Birthday birthname {get;set;} 
        public Birthday lastname {get;set;}
        public Birthday nationality {get;set;}
        public Birthday title{set;get;}
    }
    public class Address {
		public Birthday zipcode {get;set;} 
		public Birthday country {get;set;} 
		public Birthday city {get;set;} 
        public Birthday street {get;set;} 
        
    }
    public class Identificationdocument {
		public Birthday country {get;set;} 
		public Birthday number_Z {get;set;} // in json: number
		public Birthday issuedby {get;set;} 
		public Birthday dateissued {get;set;} 
		public Birthday type {get;set;} 
		public Birthday validuntil {get;set;} 

		 
	}
    public class Payload {
        public Identificationprocess identificationprocess {get;set;} 
        public Customdata customdata {get;set;} 
        public Contactdata contactdata {get;set;} 
        public Userdata userdata {get;set;} 
        public Identificationdocument identificationdocument {get;set;} 
    }
    public static List<SolarisBankIdentificationAttempt> parseList(String json) {
        return (List<SolarisBankIdentificationAttempt>) System.JSON.deserialize(json, List<SolarisBankIdentificationAttempt>.class);
    }
    public static String getIdentificationDocumentNumber(string jsonValue){
        String returnValue='';
        Map<String,Object> resultMap=(Map<String,Object>) JSON.deserializeUntyped(jsonValue);
        if(resultMap.containsKey('payload')){
            Map<String,Object> payloadMap=(Map<String,Object>) resultMap.get('payload');
            if(payloadMap.containsKey('identificationdocument') && payloadMap.get('identificationdocument')!=null){
                Map<String,Object> identificationdocumentMap=(Map<String,Object>) payloadMap.get('identificationdocument');
                if(identificationdocumentMap.containsKey('number') && identificationdocumentMap.get('number')!=null){
                    Map<String,Object> numberMap=(Map<String,Object>) identificationdocumentMap.get('number');
                    if(numberMap.containsKey('value')  && numberMap.get('value')!=null){
                        returnValue=(string)numberMap.get('value');
                        
                    }
                }
            }
        }
        return returnValue;
    }
    public class MockResponse implements HttpCalloutMock { 
        
        public HTTPResponse respond(HTTPRequest req) { 
            Birthday dataValue=new Birthday();
            dataValue.original=RandomUtil.randomString(6);
            dataValue.status='Success';
            dataValue.value=RandomUtil.randomString(6);
         	Identificationprocess identificationprocess=new Identificationprocess();
            identificationprocess.agentname='asd';
            Identificationprocess.companyid=RandomUtil.randomString(6);
            Identificationprocess.agentname=RandomUtil.randomString(6);
            Identificationprocess.id=RandomUtil.randomString(6);
            Identificationprocess.type=RandomUtil.randomString(6);
            Identificationprocess.transactionnumber=RandomUtil.randomString(6);
            Identificationprocess.identificationtime=String.valueOf(DateTime.now());
            
            Customdata customdata=new Customdata();
            customdata.custom1=RandomUtil.randomString(6);
            customdata.custom2=RandomUtil.randomString(6);
            customdata.custom3=RandomUtil.randomString(6);
            customdata.custom4=RandomUtil.randomString(6);
            customdata.custom5=RandomUtil.randomString(6);
            
            Contactdata contactdata=new Contactdata();
			contactdata.mobilephone='123566';
            contactdata.email='test@ev.com';
            
            Identificationdocument identificationdocument=new Identificationdocument();
            identificationdocument.country=dataValue;
            identificationdocument.number_Z=dataValue;
            identificationdocument.issuedby=dataValue;
            identificationdocument.type=dataValue;
            identificationdocument.validuntil=dataValue;
            
            Address address=new Address();
            address.zipcode=dataValue;
            address.country=dataValue;
            address.city=dataValue;
            address.street=dataValue;
            
            
            Userdata userdata=new Userdata();
            userdata.birthday=dataValue;
            userdata.birthname=dataValue;
            userdata.firstname=dataValue;
            userdata.birthplace=dataValue;
            userdata.birthname=dataValue;
            userdata.lastname=dataValue;
            userdata.nationality=dataValue;
            userdata.title=dataValue;
            userdata.address=address;
            
            Payload payload=new Payload();
			payload.identificationprocess=identificationprocess;
            payload.customdata=customdata;
            payload.contactdata=contactdata;
            payload.identificationdocument=identificationdocument;
            payload.userdata=userdata;
            SolarisBankIdentificationAttempt data=new SolarisBankIdentificationAttempt();
            data.id='asdasd';
            data.result='asdasd';
            data.reason='successful';
            data.payload=payload;
            
            List<SolarisBankIdentificationAttempt> dataList=new List<SolarisBankIdentificationAttempt>();
            dataList.add(data);
            
            HttpResponse resp = new HttpResponse(); 
            
            resp.setStatusCode(200); 
            resp.setStatus('success');
            resp.setBody(JSON.serialize(data)); 
           
            
            
            return resp; 
            
        }
    }
}