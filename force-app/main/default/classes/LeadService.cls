/***************
* @group Service
* @description all lead related logic are here
*/
public inherited sharing class LeadService {

    
    public without sharing class Service{
        
        public void createLead(String salutation,String firstName,String lastName,String emailAddress,Boolean makertingOptin,String source,Map<String,String> utmParameters,String recordTypeId){
            
            List<Lead> exsistingLead=[SELECT id,UTM_Medium__c,UTM_Source__c,UTM_Content__c,UTM_Campaign__c,UTM_Term__c,Company,LeadSource,Gender__c,Status,Marketing_Opt_In_Date__c,Marketing_Opt_In__c,Email,LastName,FirstName FROM Lead WHERE RecordTypeId=:recordTypeId AND Email=:emailAddress];
            
            Lead l=new Lead();
            
            if(exsistingLead.size()>0) l = exsistingLead.get(0);
            if(exsistingLead.size()==0) l.RecordTypeId = recordTypeId;
            
            l.FirstName=firstName;
            l.LastName=lastName; 
            l.salutation=salutation;
            if(String.isNotEmpty(salutation?.trim()) && (salutation.contains('Herr') || salutation.contains('Mr')) ) l.Gender__c='Male';
            else if(String.isNotEmpty(salutation?.trim()) && (salutation.contains('Frau')|| salutation.contains('Ms'))) l.Gender__c='Female';
            if(l.Email==null) l.Email=emailAddress;
            l.Marketing_Opt_In__c=makertingOptin; 
            if(l.Status==null) l.Status='New';
            l.LeadSource=source;
            if(l.Company==null) l.Company='[Not Provide]';
            
            if(l.UTM_Medium__c==null)l.UTM_Medium__c=getSubstring(utmParameters.get('utm_medium'),80);
            if(l.UTM_Source__c==null)l.UTM_Source__c=getSubstring(utmParameters.get('utm_source'),80);
            if(l.UTM_Content__c==null)l.UTM_Content__c=getSubstring(utmParameters.get('utm_content'),80);
            if(l.UTM_Campaign__c==null)l.UTM_Campaign__c=getSubstring(utmParameters.get('utm_campaign'),80);
            if(l.UTM_Term__c==null)l.UTM_Term__c=getSubstring(utmParameters.get('utm_term'),80);
            
            if(makertingOptin && l.Marketing_Opt_In_Date__c==null) l.Marketing_Opt_In_Date__c = DateTime.now();
            
            List<Lead> toInsert=new List<Lead>();
            List<Lead> toUpdate=new List<Lead>();
            
            if(exsistingLead.size()>0) toUpdate.add(l);
            else if(exsistingLead.size()==0)  toInsert.add(l);
            
            
            Database.DMLOptions dlo = new Database.DMLOptions();
            dlo.emailHeader.triggerAutoResponseEmail  = true;
            
            if(toInsert.size()>0) processDmlResult(Database.insert(toInsert, dlo));
            else if(toUpdate.size()>0) processDmlResult(Database.update(toUpdate,dlo));
        }
        
        private string getSubstring(String s,Integer range){
            String str='';
            if(s!=null && String.isNotBlank(s) && s.length()>range) str=s.trim().substring(0, range);
            else if(s!=null) str=s;
            return str;
            
        }
        private  void processDmlResult(Database.SaveResult[] result){
            for (Database.SaveResult sr : result) {
                if (!sr.isSuccess()) {
                    for(Database.Error err : sr.getErrors()) {
                        throw new DMLException(err.getStatusCode() + ' : ' + err.getMessage()+' : '+err.getFields());
                    }
                }
            }
        }
    }
}