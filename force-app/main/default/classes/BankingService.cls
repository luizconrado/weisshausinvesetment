/***************
* @group Service Class
* @description all caseobject  with banking case recordtype  related logic is here
*/

public with sharing class BankingService {
    
    //////////////
    //Constants
    ////////////////
    @AuraEnabled(cacheable=true) 
    public static Map<String,String> retriveDefaultTemplatHtml() {
        return new Map<String,String>{
            'START'=>Constant.DEFAULT_EV_TEMPLATE_START,
                'END'=>Constant.DEFAULT_EV_TEMPLATE_END
                };
    }
    @AuraEnabled 
    public static Boolean checkIsCompactLayout() {
        return Salesforce.isCompactLayout;
    }
    @AuraEnabled(cacheable=true) 
    public static Map<String,String> getBankCaseTypes(){
        PicklistEntry[] picklistvalues=SchemaUtil.getObjectPicklistFileds(SchemaUtil.getSobjectType('Case')).get('Type');
        Map<String,String> entrys=new Map<String,String>();
        for(PicklistEntry entry: picklistvalues){
            entrys.put(entry.getValue(),entry.getLabel());
        }
        return entrys;
    }
    @AuraEnabled(cacheable=true) 
    public static Map<Object,List<String>> getCaseIITypes(){
        return SchemaUtil.getDependentPicklistValues(Case.Type_II__c);
    }
    /////////////
    //Querys
    ///////////
   
    @AuraEnabled 
    public static List<Case> retriveCaseDetails(String caseId){
        return [SELECT Id,CaseNumber, Type, Status, Subject, Description, Type_II__c, Internal_Description__c,Thread_Id__c, 
                (SELECT Id,RecordTypeId,RecordType.Name,
                 Booking__r.Bank_Account__r.Name,Booking__r.Amount__c,Booking__r.Description__c , Booking__r.Recipient_IBAN__c, Booking__r.Recipient_Name__c, Booking__r.Recipient_BIC__c,Booking__c,Booking__r.Solarisbank_Id__c,Booking__r.Bank_Account__r.Solarisbank_Id__c,Booking__r.Bank_Account__r.Person_Account__r.Legal_Name__c,Booking__r.Name,Booking__r.Booking_Date__c,
                 Bank_Account__r.Person_Account__r.Solarisbank_Tenent__c,Bank_Account__r.Status__c ,Bank_Account__c ,Bank_Account__r.Solarisbank_Id__c,Bank_Account__r.Name,Bank_Account__r.Person_Account__r.Legal_Name__c,
                 Account__c,Account__r.Phone,Account__r.Legal_Name__c ,Account__r.Solarisbank_Tenent__c,Account__r.Solarisbank_Id__c,
                 Card__c,Card__r.Solarisbank_Id__c,Card__r.Person_Account__r.Legal_Name__c
                 FROM Bank_Case_Items__r) 
                FROM Case WHERE Id=:caseId];
    }
     
    
    @AuraEnabled 
    public static List<Knowledge__kav> retriveProcessKnowlodge(String typeI,String typeII){
			return [SELECT Id, Title,Type_II__c,Type__c, Summary,Information__c, ArticleNumber 
                    FROM Knowledge__kav WHERE Type__c=:typeI AND Type_II__c=:typeII
                   	AND PublishStatus ='Online'
                   ];         
    }
    
    @AuraEnabled
    public static List<ContentVersion> retriveContentVersionList(String caseRecordId){
        //retrive all files linked to case record
        List<ContentDocumentLink> link=[SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId=:caseRecordId];
        List<String> contentDocumentIds=new List<String>();
        For(ContentDocumentLink doc:link) contentDocumentIds.add(doc.ContentDocumentId);
        return [SELECT Id, ContentDocumentId,Title,ContentSize,Type__c,ContentModifiedDate,FileExtension,VersionNumber,ContentModifiedBy.Name FROM ContentVersion 
                WHERE ContentDocumentId IN: contentDocumentIds ORDER BY ContentModifiedDate DESC];
    }
    
    ///////////////
    //DML
    //////////////
    @AuraEnabled 
    public static Boolean updateJiraInformation(String caseId,String subject,String discription,List<String> contentVersionsIds){
        try{
           Boolean status=false;
            Case c=new Case();
            c.Id=caseId;
            String body='';
            body+='Subject';
            body+='\n';
            body+=subject;
            body+='\n';
            body+='\n';
            body+='Description';
            body+='\n';
            body+=discription;
            c.JIRA_Description__c=body;
            
            status= MailUtill.sendEmailWithAttachment(subject,discription.replaceAll('\n','<br/>'), contentVersionsIds, System.Label.Case_Jira_SupportEmail, Constant.EV_SUPPORT_OWD_EMAIL, caseId);
            if(status)c.status='Jira Ticket';
            update c;
            return status;
        }
        catch(Exception e){
            LogService.LogMetadata details=new LogService.LogMetadata();
            details.error=e;
            details.componentName='CaseJiraButton';
            details.userId=userinfo.getUserId();
            details.recordId=caseId;
            details.objectName='Case';
            details.className='BankingService';
            details.operation='Update Case JIRA Information';
            details.methodName='updateJiraInformation';
            String index = LogService.logError(details);
            throw new AuraHandledException('Please contact your System admin and provide '+index+' id to resolve issue.');
        }  
        
    }
    ///////////////
    //API
    //////////////
     
    @AuraEnabled
    public static string retriveBankBalanceDetails(string bankAccountId){
        Bank_Account__c bankAccountDetails=[SELECT id,Solarisbank_Id__c,Person_Account__r.Solarisbank_Tenent__c FROM Bank_Account__c WHERE id=:bankAccountId];
        
        LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(bankAccountDetails.Id,'Bank_Account__c',bankAccountDetails.Person_Account__r.Solarisbank_Tenent__c);
        
        return SolarisbankService.fetchAccountBalance(bankAccountDetails.Solarisbank_Id__c,apiCallDetails);
    }
    
    @AuraEnabled
    public static void retriveIdentificationDetailsAndUpdate(String identifiactionId){
        List<Attempt__c> toInsertAttempt=new List<Attempt__c>();
         
        KYC_Detail__c identRecord=[SELECT id,URL__c,Status__c,Completed_At__c,Reference__c,Account__r.Solarisbank_Tenent__c,Solarisbank_Id__c,Account__r.Solarisbank_Id__c, 
                                   Phone__c,Valid_Until__c,Document_Type__c,Email__c,Birthday__c,First_Name__c,Last_Name__c,Zipcode__c,Birth_Place__c,Nationality__c,Document_Number__c,Place_Of_Issue__c
                                   FROM KYC_Detail__c WHERE id=:identifiactionId];
        LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(identRecord.Id,'KYC_Detail__c',identRecord.Account__r.Solarisbank_Tenent__c);
        String identifiactionStatusString=SolarisbankService.fetchIdentificationDetails(identRecord.Account__r.Solarisbank_Id__c,identRecord.Solarisbank_Id__c,apiCallDetails);
        SolarisBankIdentificationWrapper identifiactionStatus=SolarisBankIdentificationWrapper.parse(identifiactionStatusString);
        if(String.isNotEmpty(identifiactionStatus.completed_at)) identRecord.Completed_At__c=DateTime.valueOf(identifiactionStatus.completed_at.replace('T',' '));
        if(String.isNotEmpty(identifiactionStatus.status)) identRecord.Status__c=identifiactionStatus.status;
        if(String.isNotEmpty(identifiactionStatus.url)) identRecord.URL__c=identifiactionStatus.url;
        if(String.isNotEmpty(identifiactionStatus.reference)) identRecord.Reference__c=identifiactionStatus.reference;
        System.debug('identifiactionStatus.status:'+identifiactionStatus.status);
        if(identifiactionStatus.status.equalsIgnoreCase('successful')){ 
            String identifiactionAttemptsString=SolarisbankService.fetchIdentificationAttemptDetails(identRecord.Account__r.Solarisbank_Id__c,identRecord.Solarisbank_Id__c,apiCallDetails);
            List<SolarisBankIdentificationAttempt> attemptsList=SolarisBankIdentificationAttempt.parseList(identifiactionAttemptsString);
            
            List<String> attemptId=new List<String>();
            for(SolarisBankIdentificationAttempt attempt:attemptsList) attemptId.add(attempt.id);
            List<Attempt__c> allAttempts=[SELECT Solarisbank_Id__c,id,Agent_Name__c,Identification_Time__c,Reason__c,Name,Type__c FROM Attempt__c WHERE KYC_Detail__c=:identRecord.id AND Solarisbank_Id__c IN:attemptId];
            Map<String,Attempt__c> allAttemptsMap=new Map<String,Attempt__c>();
            for(Attempt__c attemp:allAttempts)   allAttemptsMap.put(attemp.Solarisbank_Id__c,attemp);
            
            
            for(SolarisBankIdentificationAttempt attempt:attemptsList){
                Attempt__c att=(allAttemptsMap.containsKey(attempt.id))?allAttemptsMap.get(attempt.id):new Attempt__c(); 
                if(!allAttemptsMap.containsKey(attempt.id)) att.KYC_Detail__c=identRecord.id;
                att.Agent_Name__c=attempt.payload.identificationprocess.agentname;
                if(attempt?.payload?.identificationprocess?.identificationtime!=null)att.Identification_Time__c=Date.valueOf(attempt.payload.identificationprocess.identificationtime.replace('T',' '));
                att.Reason__c=attempt.reason;
                att.Result__c=attempt.payload.identificationprocess.result;
                att.Solarisbank_Id__c=attempt.id;
                att.Name=attempt.payload.identificationprocess.id;
                att.Type__c=attempt.payload.identificationprocess.type;
                if(attempt.payload.identificationprocess.result.equalsIgnoreCase('SUCCESS')){
                    
                    identRecord.Phone__c=attempt?.payload?.contactdata?.mobilephone;
                    identRecord.Email__c=attempt?.payload?.contactdata?.email;
                    if(attempt?.payload?.userdata?.birthday?.value!=null)identRecord.Birthday__c=Date.valueOf(attempt?.payload?.userdata?.birthday?.value);
                    identRecord.First_Name__c=attempt?.payload?.userdata?.firstname?.value;
                    identRecord.Last_Name__c=attempt?.payload?.userdata?.lastname?.value;
                    identRecord.Zipcode__c=attempt?.payload?.userdata?.address?.zipcode?.value;
                    
                    identRecord.Street__c=attempt?.payload?.userdata?.address?.street?.value;
                    
                    identRecord.Birth_Place__c=attempt?.payload?.userdata?.birthplace?.value;
                    identRecord.Birth_Name__c=attempt?.payload?.userdata?.birthname?.value;
                    identRecord.Nationality__c=attempt?.payload?.userdata?.nationality?.value; 
                    identRecord.Title__c=attempt?.payload?.userdata?.title?.value;
                    identRecord.Document_Number__c=SolarisBankIdentificationAttempt.getIdentificationDocumentNumber(JSON.serialize(attempt));
                    identRecord.Place_Of_Issue__c = attempt?.payload?.identificationdocument?.issuedby?.value;              
                    if(attempt?.payload?.identificationdocument?.dateissued?.value!=null)identRecord.Date_Issued__c= Date.valueOf(attempt?.payload?.identificationdocument?.dateissued?.value);  
                    identRecord.Document_Type__c= attempt?.payload?.identificationdocument?.type?.value;  
                    if(attempt?.payload?.identificationdocument?.validuntil?.value!=null)identRecord.Valid_Until__c= Date.valueOf(attempt?.payload?.identificationdocument?.validuntil?.value);  
                    
                }
                toInsertAttempt.add(att);
            }
        			
        }
        
        
        update identRecord;
        if(toInsertAttempt.size()>0) upsert toInsertAttempt;
        
    }
}