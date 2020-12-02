public class SolarisbankPersonWrapper {
    @AuraEnabled public String id;
    @AuraEnabled public String salutation;
    @AuraEnabled public String title;
    @AuraEnabled public String first_name;
    @AuraEnabled public String last_name;
    @AuraEnabled public Person_Address address;
    @AuraEnabled public Person_Address contact_address;
    @AuraEnabled public String email;
    @AuraEnabled public String mobile_number;
    @AuraEnabled public String birth_name;
    @AuraEnabled public String birth_date;
    @AuraEnabled public String birth_city;
    @AuraEnabled public String birth_country;
    @AuraEnabled public String nationality;
    @AuraEnabled public String employment_status;
    @AuraEnabled public String job_title;
    @AuraEnabled public Tax_information tax_information;
    @AuraEnabled public Boolean fatca_relevant;
    @AuraEnabled public String fatca_crs_confirmed_at;
    @AuraEnabled public String business_purpose;
    @AuraEnabled public String industry;
    @AuraEnabled public String industry_key;
    @AuraEnabled public String terms_conditions_signed_at;
    @AuraEnabled public Boolean flagged_by_compliance;
    @AuraEnabled public String own_economic_interest_signed_at;
    
    public class Person_Address {
        @AuraEnabled public String line_1;
        @AuraEnabled public String line_2;
        @AuraEnabled public String postal_code;
        @AuraEnabled public String city;
        @AuraEnabled public String country;
        @AuraEnabled public String state;
    }
    
    public class Tax_information {
        @AuraEnabled public String tax_assessment;
        @AuraEnabled public String marital_status;
    }
    
    
    @AuraEnabled 
    public static SolarisbankPersonWrapper parse(String json) {
        return (SolarisbankPersonWrapper) System.JSON.deserialize(json, SolarisbankPersonWrapper.class);
    }
    
    public class MockResponse implements HttpCalloutMock { 
        
        public HTTPResponse respond(HTTPRequest req) { 
            SolarisbankPersonWrapper data=new SolarisbankPersonWrapper();
            
            data.id='asd';
            data.salutation='Mr';
            data.title='Mr';
            data.first_name='asd';
            data.last_name='asd';
            data.email='asd@asd.com';
            data.mobile_number='123';
            data.birth_name='cdsc';
            data.birth_date='1/1/1911';
            data.birth_city='asd';
            data.birth_country='DE';
            data.nationality='asd';
            data.employment_status='asd';
            data.job_title='asd';
            data.fatca_relevant=true;
            data.fatca_crs_confirmed_at='2018-01-01';
            data.business_purpose='asd';
            data.industry='Tech';
            data.industry_key='Tech';
            data.terms_conditions_signed_at='2018-01-01';
            data.flagged_by_compliance=true;
            data.own_economic_interest_signed_at='2018-01-01';
            
            
            
            HttpResponse resp = new HttpResponse(); 
            
            resp.setStatusCode(200); 
            
            resp.setStatus('success'); 
            
            resp.setBody(JSON.serialize(data)); 
            
            return resp; 
            
        }
    }
    
}