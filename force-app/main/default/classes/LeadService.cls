/***************
* @group Service Class
* @description all lead related logic are here
*/
public inherited sharing class LeadService {

    
    public without sharing class Service{
        
        /***************
        * @description creates lead
        * @param salutation  
        * @param firstName  
        * @param lastName 
        * @param emailAddress 
        * @param makertingOptin 
        * @param utmParameters map of utm parameters 
        * @param recordTypeId lead recordtypeId 
        * @return list containg inserted recordid
        */
        public List<String> createLead(String salutation,String firstName,String lastName,String emailAddress,String website,Boolean makertingOptin,String source,Map<String,String> utmParameters,String recordTypeId){
            
            List<Lead> exsistingLead=[SELECT id,UTM_Medium__c,Website,UTM_Source__c,UTM_Content__c,UTM_Campaign__c,UTM_Term__c,Company,LeadSource,Gender__c,Status,Marketing_Opt_In_Date__c,Marketing_Opt_In__c,Email,LastName,FirstName FROM Lead WHERE RecordTypeId=:recordTypeId AND Email=:emailAddress];
            
            Lead l=new Lead();
            
            if(exsistingLead.size()>0) l = exsistingLead.get(0);
            if(exsistingLead.size()==0) l.RecordTypeId = recordTypeId;
            
            if(firstName!=null)l.FirstName=firstName;
            if(lastName!=null){
                l.LastName=lastName;
            }
            else if(l.lastName==null){
                l.LastName='[Not Provided]'; 
            }
                
            
            if(salutation!=null)l.salutation=salutation;
            if(String.isNotEmpty(salutation?.trim()) && (salutation.contains('Herr') || salutation.contains('Mr')) ) l.Gender__c='Male';
            else if(String.isNotEmpty(salutation?.trim()) && (salutation.contains('Frau')|| salutation.contains('Ms'))) l.Gender__c='Female';
            if(l.Email==null) l.Email=emailAddress;
            if(makertingOptin!=null)l.Marketing_Opt_In__c=makertingOptin; 
            if(l.Status==null) l.Status='New';
            if(source!=null)l.LeadSource=source;
            if(website!=null) l.Website=website;
            
            
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
            List<String> successId=new List<String>();
            if(toInsert.size()>0) successId=processDmlResult(Database.insert(toInsert, dlo));
            else if(toUpdate.size()>0) successId=processDmlResult(Database.update(toUpdate,dlo));
            return successId;
        }
        
        /***************
        * @description create subscriptions for lead
        * @param leadId list of lead ids
        * @param productType name of product for whihc subscription is to be created
        * @param utmParameters map of utm prameters
        * @param website url of subscription  button
        */
        public void createSubscription(List<String> leadId,String productType,Map<String,String> utmParameters,String website){
            Map<String,Subscription__c> leadAndSubMap=new Map<String,Subscription__c>();
            for(Subscription__c sub:[SELECT Id,Lead__c FROM Subscription__c  WHERE RecordTypeId=:Constant.SUBSCRIPTION_LEAD_RECORDTYPEID AND Lead__c IN:leadId AND Type__c=:productType]){
                leadAndSubMap.put(sub.Lead__c,sub);
            }
            List<Subscription__c> toInsert=new List<Subscription__c>();
            for(String id:leadId){
                if(!leadAndSubMap.containsKey(id)){
                    Subscription__c newSubscriptionProduct=new Subscription__c();
                    newSubscriptionProduct.RecordTypeId=Constant.SUBSCRIPTION_LEAD_RECORDTYPEID;
                    newSubscriptionProduct.Subscription_Status__c='Awaiting Confirmation';
                    newSubscriptionProduct.Type__c=productType;
                    newSubscriptionProduct.Source__c=getSubstring(website,254);
                    newSubscriptionProduct.Lead__c=id;
                    newSubscriptionProduct.Send_Mail__c=true;
                    newSubscriptionProduct.UTM_Medium__c=getSubstring(utmParameters.get('utm_medium'),80);
                    newSubscriptionProduct.UTM_Source__c=getSubstring(utmParameters.get('utm_source'),80); 
                    newSubscriptionProduct.UTM_Content__c=getSubstring(utmParameters.get('utm_content'),80);
                    newSubscriptionProduct.UTM_Campaign__c=getSubstring(utmParameters.get('utm_campaign'),80);
                    newSubscriptionProduct.UTM_Term__c=getSubstring(utmParameters.get('utm_term'),80);
                    toInsert.add(newSubscriptionProduct);
                }
            }
            
            if(toInsert.size()>0) insert toInsert;
        }
        
        private string getSubstring(String s,Integer range){
            String str='';
            if(s!=null && String.isNotBlank(s) && s.length()>range) str=s.trim().substring(0, range);
            else if(s!=null) str=s;
            return str;
            
        } 
        private  List<String> processDmlResult(Database.SaveResult[] result){
            List<String> successIds=new List<String>();
            for (Database.SaveResult sr : result) {
                if (!sr.isSuccess()) {
                    for(Database.Error err : sr.getErrors()) {
                        throw new DMLException(err.getStatusCode() + ' : ' + err.getMessage()+' : '+err.getFields());
                    }
                }
                else if (sr.isSuccess()) {
                    successIds.add(sr.getId());
                }
            }
            return successIds;
        }
    }
}