/***************
* @group Wrapper Class
* @description SB
*/
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
    @AuraEnabled public Date aml_follow_up_date;
    @AuraEnabled public Date aml_confirmed_on;
    @AuraEnabled Public Integer expected_monthly_revenue_cents;
    @AuraEnabled Public String vat_number;
    @AuraEnabled Public String nace_code;
    @AuraEnabled Public String customer_vetting_status;
    @AuraEnabled Public String risk_classification_status;
    @AuraEnabled Public String screening_progress;
    @AuraEnabled Public String business_address_line_1;
    @AuraEnabled Public String business_address_line_2;
    @AuraEnabled Public String business_postal_code;
    @AuraEnabled Public String business_city;
    @AuraEnabled Public String business_country;
    
    
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
         Boolean isError=false;
         public MockResponse(){} 
         public MockResponse(Boolean isError){
             this.isError=isError;
         }
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
            data.birth_date='2000-12-25';
            data.birth_city='Berlin';
            data.birth_country='DE';
            data.nationality='DE';
            data.employment_status='SELF_EMPLOYED';
            data.job_title='asd';
            data.fatca_relevant=true;
            data.fatca_crs_confirmed_at='2018-01-01';
            data.business_purpose='asd';
            data.industry='OTHER_SERVICES';
            data.industry_key='OTHER_SERVICES';
            data.flagged_by_compliance=true;
         
            
            
            
            HttpResponse resp = new HttpResponse(); 
            if(isError){
                resp.setStatusCode(400); 
                
                resp.setStatus('Error'); 
            }
            else{
                resp.setStatusCode(200); 
                
                resp.setStatus('OK'); 
            }
            
            
            resp.setBody(JSON.serialize(data)); 
            
            return resp; 
            
        }
    }
    
}