public with sharing class BankingService {
    
    //////////////
    //Constants
    ////////////////
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
        return [SELECT Id,CaseNumber, Type, Status, Subject, Description, Type_II__c, Internal_Description__c,
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
    public static void updateJiraInformation(String caseId,String subject,String discription){
        try{
           
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
            update c;
             
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
        Identification__c identRecord=[SELECT id,URL__c,Status__c,Completed_At__c,Reference__c,Account__r.Solarisbank_Tenent__c,Solarisbank_Id__c,Account__r.Solarisbank_Id__c FROM Identification__c WHERE id=:identifiactionId];
        LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(identRecord.Id,'Identification__c',identRecord.Account__r.Solarisbank_Tenent__c);
 		String responseString=SolarisbankService.fetchIdentificationRequestDetails(identRecord.Account__r.Solarisbank_Id__c,identRecord.Solarisbank_Id__c,apiCallDetails);
        String identifiactionStatusString=SolarisbankService.fetchIdentificationDetails(identRecord.Account__r.Solarisbank_Id__c,identRecord.Solarisbank_Id__c,apiCallDetails);
        SolarisBankIdentificationWrapper response=SolarisBankIdentificationWrapper.parse(responseString);
        SolarisBankIdentificationWrapper identifiactionStatus=SolarisBankIdentificationWrapper.parse(identifiactionStatusString);
		if(String.isNotEmpty(identifiactionStatus.completed_at)) identRecord.Completed_At__c=DateTime.valueOf(identifiactionStatus.completed_at.replace('T',' '));
        if(String.isNotEmpty(identifiactionStatus.status)) identRecord.Status__c=identifiactionStatus.status;
        if(String.isNotEmpty(response.url)) identRecord.URL__c=response.url;
        if(String.isNotEmpty(response.reference)) identRecord.Reference__c=response.reference;
        update identRecord;
        
    }
}