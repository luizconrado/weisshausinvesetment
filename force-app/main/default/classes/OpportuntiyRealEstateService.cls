public with sharing class OpportuntiyRealEstateService {
    
    
    //AIM : get current termdepost status
    @AuraEnabled
    public static Boolean getTermDepositeStatus(String recordId){
        List<Opportunity> opp=[SELECT Id, AccountId,Account.Solarisbank_Tenent__c,Account.Auth0_ID__c ,Account.Solarisbank_Id__c,Account.PersonEmail,Account.Name FROM Opportunity WHERE id=:recordId];
        if(opp.size()==0) return false;
        List<Solarisbank__c> sbList=[SELECT id,Name,Email__c,Solarisbank_Id__c,Is_Term_Deposit_Enabled__c FROM Solarisbank__c WHERE Account__c=:opp.get(0).AccountId];
        Solarisbank__c sbDetails=new Solarisbank__c();
        //create new sb details if doesnt exsist
        if(sbList.size()==0){
            sbDetails.Name=opp.get(0).Account.Name;
            sbDetails.Account__c=opp.get(0).AccountId;
            sbDetails.Solarisbank_Id__c=opp.get(0).Account.Solarisbank_Id__c;
            sbDetails.Email__c=opp.get(0).Account.PersonEmail;
            sbDetails.Is_Term_Deposit_Enabled__c=false;
            insert sbDetails;
        }
        else{
          sbDetails=sbList.get(0);  
        } 
        
        return sbDetails.Is_Term_Deposit_Enabled__c;
    }
    
    //AIM : toggle term deposit tag on auth0 user
    @AuraEnabled
    public static Boolean toggleTermDepostForUser(String recordId,Boolean status){
        Boolean changedStatusFlag=false;
        List<Opportunity> opp=[SELECT Id, AccountId,Account.Solarisbank_Tenent__c,Account.Auth0_ID__c ,Account.Solarisbank_Id__c,Account.PersonEmail,Account.Name FROM Opportunity WHERE id=:recordId];
        if(opp.size()==0) return false;
        List<Solarisbank__c> sbList=[SELECT id,Name,Email__c,Term_Deposit_Enabled_At__c,Solarisbank_Id__c,Is_Term_Deposit_Enabled__c FROM Solarisbank__c WHERE Account__c=:opp.get(0).AccountId];
        Solarisbank__c sbDetails=new Solarisbank__c();
        if(sbList.size()>0) sbDetails = sbList.get(0);
        LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(opp.get(0).Id,'Opportunity',opp.get(0).Account.Solarisbank_Tenent__c);

        String responseJson = Auth0Service.updateUserDetails(opp.get(0).Account.Auth0_ID__c,'{ "user_metadata": { "term_deposit_enabled":'+status+' } }',apiCallDetails);
        Auth0Wrapper userDetails = Auth0Wrapper.parse(responseJson);
        
        //create new sb details if doesnt exsist
        if(sbList.size()==0){
            System.debug('sbList '+sbList.size());
            sbDetails.Name=opp.get(0).Account.Name;
            sbDetails.Account__c=opp.get(0).AccountId;
            sbDetails.Solarisbank_Id__c=opp.get(0).Account.Solarisbank_Id__c;
            sbDetails.Email__c=opp.get(0).Account.PersonEmail;
            sbDetails.Is_Term_Deposit_Enabled__c=false;
            insert sbDetails;
        }
         
        System.debug('sbDetails '+sbDetails);
        if(userDetails.user_metadata.term_deposit_enabled == status){
            sbDetails.Is_Term_Deposit_Enabled__c = status;
            sbDetails.Term_Deposit_Enabled_At__c = DateTime.now();
            update sbDetails;
            changedStatusFlag = true;
        }
        
        return changedStatusFlag;
        
    }
    
    //AIM : Retrive real estate email template desing
    @AuraEnabled
    public static Map<String,String> getRealEstateSaleEmailPreview(Id recordId){
        List<Opportunity> realEstateSale=[SELECT id,Asset__c,RecordTypeId FROM Opportunity WHERE id=:recordId];
        setAssetEvaluationDateToCurrentMonth(realEstateSale.get(0).Asset__c);
        String emailTo=getSentToEmail(realEstateSale.get(0).RecordTypeId); 
        String s='';
        EmailTemplate template=[SELECT Id, Name, Subject, HtmlValue FROM EmailTemplate where id=:Constant.OPPORTUNITY_REAL_ESTATE_SALE_EMAILTEMPLATE];
        s=MailUtill.proccessEmailTemplate(template.HtmlValue, true, recordId.getSobjectType().getDescribe().getName(), recordId);
        return new Map<String,String>{'BODY'=>s,'SUBJECT'=>template.Subject,'EMAIL'=>emailTo};
    }

	//AIM: send email to ev smartmoney team with email details    
    @AuraEnabled
    public static void sendEmailToAgent(String body,String subject,String recordId,String emailTo){
        MailUtill.sendPlainHtmlEmail(subject, body,emailTo, Constant.EV_SUPPORT_OWD_EMAIL, recordId);
    }

    //retirve email template 
    private static String getSentToEmail(String recordTypeId){
        String urlVariable='';
        String emailAddress='';
        
        if(recordTypeId==Constant.OPPORTUNITY_RE_PARTIALSALE_RECORDTYPEID)urlVariable='RealEstateOpportunityPartialSaleEmail';
        else if(recordTypeId==Constant.OPPORTUNITY_RE_VALUATION_RECORDTYPEID)urlVariable='RealEstateOpportunityValuationEmail';
        else if(recordTypeId==Constant.OPPORTUNITY_RE_FULLSALE_RECORDTYPEID)urlVariable='RealEstateOpportunityFullSaleEmail';
        List<Constant__mdt> value=[SELECT id,Value__c FROM Constant__mdt WHERE DeveloperName=:urlVariable];
        if(value.size()>0) emailAddress=value.get(0).Value__c;
        return emailAddress;
    }
    
    //update evaluation dates to latest
    private static void setAssetEvaluationDateToCurrentMonth(String assetId ){
       	Boolean doUpdate=false;
        List<Asset> realEstate=[SELECT Id, Latest_Evaluation_Date__c, Latest_Evaluation_Price__c,(SELECT id,Date__c,Value__c FROM Evaluations__r) FROM Asset WHERE id=:assetId];
        if(realEstate.size()>0){
            if(realEstate.get(0).Latest_Evaluation_Date__c==null || realEstate.get(0).Latest_Evaluation_Date__c.month()!=Date.Today().Month()){
                for(Evaluation__c evaluation:realEstate.get(0).Evaluations__r){
                    if(evaluation.Date__c.month()==Date.Today().Month()-1 && evaluation.Date__c.year()==Date.today().Year()){
                        realEstate.get(0).Latest_Evaluation_Date__c=evaluation.Date__c;
                        realEstate.get(0).Latest_Evaluation_Price__c=evaluation.Value__c;
                        doUpdate=true;
                    }
                }                	
            }
        }
        if(doUpdate) update realEstate;
    }
}