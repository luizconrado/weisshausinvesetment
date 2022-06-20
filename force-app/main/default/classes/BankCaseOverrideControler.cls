/***************
* @group Controller Class
* @description all bank case override button logic is here
*/
public with sharing class BankCaseOverrideControler {
    
    /////////////////////////////
    //Constants
    ////////////////////////////
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
    @auraEnabled(cacheable=true)
    public static Map<String,String> getCardStatusTypes(){
        PicklistEntry[] picklistvalues=SchemaUtil.getObjectPicklistFileds(SchemaUtil.getSobjectType('Card__c')).get('Status__c');
        Map<String,String> entrys=new Map<String,String>();
        for(PicklistEntry entry: picklistvalues) entrys.put(entry.getValue(),entry.getLabel());
        return entrys;
    }
    @AuraEnabled(cacheable=true) 
    public static Map<String,String> getScheludedOrderTypes(){
        PicklistEntry[] picklistvalues=SchemaUtil.getObjectPicklistFileds(SchemaUtil.getSobjectType('Scheduled_Order__c')).get('Status__c');
        Map<String,String> entrys=new Map<String,String>();
        for(PicklistEntry entry: picklistvalues) entrys.put(entry.getValue(),entry.getLabel());
        return entrys;
    }
    @AuraEnabled
    public static Boolean checkIsCompactLayout() {
        return Salesforce.isCompactLayout;
    }
    @auraEnabled(cacheable=true)
    public static Map<String,Map<String,String>> getKYCPicklistValues(){
        Map<String,PicklistEntry[]> picklistValues = SchemaUtil.getObjectPicklistFileds(SchemaUtil.getSobjectType('Bank__c'));
        Map<String,Map<String,String>> fieldAndValuesMap=new Map<String,Map<String,String>>();
        for(String field:picklistValues.keySet()){
            if(!fieldAndValuesMap.containsKey(field)) fieldAndValuesMap.put(field,new Map<String,String>());
            for(PicklistEntry entry:picklistValues.get(field)){
                if(entry.isActive()) {
                    fieldAndValuesMap.get(field).put(entry.getValue(),entry.getLabel());
                }
            }
        }
        return fieldAndValuesMap;
    }
    /////////////////////////////
    //Querys
    ////////////////////////////
    @AuraEnabled
    public static List<Case> getCaseDetails(String caseId){
        return [SELECT id,AccountId,Type,CaseNumber,Type_II__c,Description ,Internal_Description__c,
                Account.Name, Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingPostalCode, Account.BillingCountry,
                Account.Phone,Account.Industry , Account.PersonBirthdate,Account.Solarisbank_Id__c
                FROM Case 
                WHERE id=:caseId];
        
    }
    
    @AuraEnabled
    public static List<Bank_Case_Item__c> fetchExsistingBankCases(String caseId){
        return [SELECT Id, Case__c, Bank_Account__c, Booking__c, Reservation__c, Scheduled_Order__c, 
                Statement__c, Card__c, Seizure__c, Identification__c, Tax_Identification__c, Is_Test__c, 
                Account__c 
                FROM Bank_Case_Item__c WHERE Case__c=:caseId];            
    }
    @AuraEnabled
    public static Bank_Case_Item__c getBankCaseDetails(String recordId){
       return [SELECT Id, Case__c, Statement__c, 
                Reservation__c,Reservation__r.Bank_Account__r.Person_Account__r.Solarisbank_Tenent__c,
                Bank_Account__r.Person_Account__r.FirstName ,Bank_Account__r.Person_Account__r.LastName,Bank_Account__r.Person_Account__r.Employment_Status__c,
                Booking__c,Booking__r.Bank_Account__r.Person_Account__r.Solarisbank_Tenent__c,Booking__r.Bank_Account__r.Person_Account__r.Solarisbank_Id__c,Booking__r.Bank_Account__r.Solarisbank_Id__c,Booking__r.Transaction_Id__c,
                Card__c,Card__r.Status__c,Card__r.Solarisbank_Id__c,Card__r.Person_Account__r.Name,Card__r.Person_Account__r.Solarisbank_Tenent__c,
                Scheduled_Order__c,Scheduled_Order__r.Status__c,Scheduled_Order__r.Solarisbank_Id__c,
                Scheduled_Order__r.Bank_Account__r.Solarisbank_Id__c,Scheduled_Order__r.Bank_Account__r.Person_Account__r.Solarisbank_Id__c,Scheduled_Order__r.Bank_Account__r.Person_Account__r.Solarisbank_Tenent__c,
                Bank_Account__c,Bank_Account__r.Status__c,Bank_Account__r.Solarisbank_Id__c,Bank_Account__r.Person_Account__r.Solarisbank_Id__c,Bank_Account__r.Person_Account__r.Solarisbank_Tenent__c,
                Seizure__c, Identification__c, Tax_Identification__c, Is_Test__c,  Account__c,Account__r.Marital_Status__c,
                Account__r.PersonTitle,Account__r.Salutation,Account__r.Employment_Status__c,Account__r.Business_Purpose__c,
                Account__r.Industry,Account__r.Industry_Key__c,Account__r.Solarisbank_Id__c,Account__r.Solarisbank_Tenent__c,
                Account__r.BillingStreet,Account__r.BillingPostalCode,Account__r.BillingCity,Account__r.BillingCountry,Account__r.BillingState,
                Account__r.Preferred_Language__pc
                FROM Bank_Case_Item__c WHERE Id=:recordId];        
        
    }
    @AuraEnabled
    public static List<Bank__c> getSuccessKYCIdentificationRecord(String accountId){
        return [SELECT id,Employment_Status__c,Marital_Status__c FROM Bank__c WHERE Account__c=:accountId  AND RecordTypeId=:Constant.BANK_SOLARISBANK_RECORDTYPEID];
    }
    
    @AuraEnabled
    public static List<Bank_Account__c> getBankAccounts(String accountId){
        return [SELECT Id, Solarisbank_Id__c, BIC__c, Type__c, Status__c, Closure_Reasons__c, 
                Person_Account__c,Person_Account__r.Solarisbank_Id__c, Name,
                Person_Account__r.Solarisbank_Tenent__c
                FROM Bank_Account__c 
                WHERE Person_Account__c=:accountId];
    }
    @AuraEnabled
    public static List<Card__c> getAllBankCards(String sfBankAccountId){
        return [SELECT Id, Type__c, Status__c, Expiration_Date__c, Person_Account__c, Bank_Account__c, Name_On_Card__c, Solarisbank_Id__c, Name 
                FROM Card__c WHERE Bank_Account__c=:sfBankAccountId ORDER By Expiration_Date__c desc];
    }
    @AuraEnabled
    public static List<KYC_Detail__c> getAllIdentifications(String sfAccountId){
       return [SELECT Id, Name, RecordTypeId,RecordType.Name, Account__c, Completed_At__c, Failure_Reason__c,  Method__c, Reference__c, Solarisbank_Id__c, State__c, Status__c, URL__c 
                FROM KYC_Detail__c WHERE Account__c=:sfAccountId ORDER By Completed_At__c desc ];
    }
     
    /////////////////////////////
    //Dynamic Query
    ////////////////////////////
    @AuraEnabled
    public static List<Booking__c> retriveBookings(String sfBankId,Date bookingStartDate,Date bookingEndDate,String recipentIBAN){
        if(recipentIBAN!=null)  recipentIBAN = '%'+recipentIBAN+'%';
        String query = 'SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, Solarisbank_Id__c, Creation_Date__c, Valuta_Date__c, Booking_Date__c, Booking_Type__c, Amount__c, Unit__c, Description__c, Recipient_BIC__c, Recipient_IBAN__c, Recipient_Name__c, Sender_BIC__c, Sender_IBAN__c, Sender_Name__c, End_To_End_Id__c, Mandate_Reference__c, Transaction_Id__c, Return_Transaction_Id__c, Sepa_Return_Code__c, Sepa_Return_Reason_Definition__c, Recorded_At__c, Reconciliation_Id__c, Bank_Account__c, Card__c, Is_Test__c';
        query += ' FROM Booking__c ';
        query += ' WHERE Bank_Account__c=:sfBankId ';
        if(bookingStartDate!=null) query += ' AND Booking_Date__c >=:bookingStartDate ';
        if(bookingEndDate!=null) query += ' AND Booking_Date__c <=:bookingEndDate ';
        if(recipentIBAN!=null) query += ' AND Recipient_IBAN__c LIKE:recipentIBAN ';
        query += ' ORDER BY Booking_Date__c desc LIMIT 200';
        System.debug(query);
        return database.query(query);
    }
    @AuraEnabled
    public static List<Scheduled_Order__c> retriveTimedOrders(String sfBankId,Date startDateFilter,Date endDateFilter,String recipentIBAN){
        String timedOrderRecordTypeId=Constant.TIMED_SCHEDULEDORDER_RECORDTYPEID;
        if(recipentIBAN!=null)  recipentIBAN = '%'+recipentIBAN+'%';
        String query = 'SELECT Id,Bank_Account__c, Amount__c, Created_At__c, Description__c, End_To_End_Id__c, Execute_At__c, Executed_At__c, First_Execution_Date__c, Last_Execution_Date__c, Next_Occurrence__c, Recipient_BIC__c, Recipient_IBAN__c, Recipient_Name__c, Reference__c, Reoccurrence__c, Solarisbank_Id__c, Status__c, Unit__c, Month_End_Execution__c, Is_Test__c, Scheduled_Transaction_Id__c, Scheduled_Transaction_Status__c  ';
        query += ' FROM Scheduled_Order__c ';
        query += ' WHERE Bank_Account__c=:sfBankId AND RecordtypeId=:timedOrderRecordTypeId  ';
        if(startDateFilter!=null) query += ' AND Execute_At__c >=:startDateFilter ';
        if(endDateFilter!=null) query += ' AND Execute_At__c <=:endDateFilter ';
        if(recipentIBAN!=null) query += ' AND Recipient_IBAN__c LIKE:recipentIBAN ';
        query += ' ORDER BY Execute_At__c desc LIMIT 200';
        System.debug(query);
        return database.query(query);
    }  
    @AuraEnabled
    public static List<Scheduled_Order__c> retriveStandingOrders(String sfBankId,Date startDateFilter,Date endDateFilter,String recipentIBAN){
        String standingOrderRecordTypeId=Constant.STANDING_SCHEDULEDORDER_RECORDTYPEID;
        if(recipentIBAN!=null)  recipentIBAN = '%'+recipentIBAN+'%';
        String query = 'SELECT Id,Bank_Account__c, Amount__c, Created_At__c, Description__c, End_To_End_Id__c, Execute_At__c, Executed_At__c, First_Execution_Date__c, Last_Execution_Date__c, Next_Occurrence__c, Recipient_BIC__c, Recipient_IBAN__c, Recipient_Name__c, Reference__c, Reoccurrence__c, Solarisbank_Id__c, Status__c, Unit__c, Month_End_Execution__c, Is_Test__c, Scheduled_Transaction_Id__c, Scheduled_Transaction_Status__c  ';
        query += ' FROM Scheduled_Order__c ';
        query += ' WHERE Bank_Account__c=:sfBankId AND RecordtypeId=:standingOrderRecordTypeId  ';
        if(startDateFilter!=null) query += ' AND First_Execution_Date__c >=:startDateFilter ';
        if(endDateFilter!=null) query += ' AND First_Execution_Date__c <=:endDateFilter ';
        if(recipentIBAN!=null) query += ' AND Recipient_IBAN__c LIKE:recipentIBAN ';
        query += ' ORDER BY Execute_At__c desc LIMIT 200';
        System.debug(query);
        return database.query(query);
    }
    @AuraEnabled
    public static List<Reservation__c> retriveReservations(String sfBankId,Date expireStartDate,Date expireEndDate,String refrenceId){
        if(refrenceId!=null)  refrenceId = '%'+refrenceId+'%';
        String query = 'SELECT Id, Bank_Account__c, Solarisbank_Id__c, Amount__c, Unit__c, Reservation_Type__c, Reference__c, Status__c, Meta_Info__c, Expires_At__c, Expired_At__c, Resolved_At__c, Description__c, Settlement_Amount__c, Is_Test__c';
        query += ' FROM Reservation__c ';
        query += ' WHERE Bank_Account__c=:sfBankId ';
        if(expireStartDate!=null) query += ' AND Expires_At__c >=:expireStartDate ';
        if(expireEndDate!=null) query += ' AND Expires_At__c <=:expireEndDate ';
        if(refrenceId!=null) query += ' AND Reference__c LIKE:refrenceId ';
        query += ' ORDER BY Expires_At__c desc LIMIT 200';
        System.debug(query);
        return database.query(query);
    }
    /////////////////////////////
    //Api Calls
    ////////////////////////////
    @AuraEnabled
    public static String callGoogleMapSearchApi(String searchText,String sessionToken){
        HttpResponse response=RestService.get('https://maps.googleapis.com/maps/api/place/autocomplete/json?input='+EncodingUtil.urlEncode(searchText, 'UTF-8')+'&sessiontoken='+sessionToken.trim()+'&key='+System.label.GoogleMapApiToken, new Map<String,String>());
        return response.getBody();
          
    }
    @AuraEnabled
    public static String callGoogleMapsDetailsApi(String placeId,String sessionToken){
        HttpResponse response=RestService.get('https://maps.googleapis.com/maps/api/place/details/json?place_id='+placeId.trim()+'&sessiontoken='+sessionToken.trim()+'&key='+System.label.GoogleMapApiToken, new Map<String,String>());
        return response.getBody();
    }
    @AuraEnabled
    public static String requestTransactionDetails(String recordId,Bank_Account__c bankAccountDetails,String transactionId){
        
        LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(recordId,'Case',bankAccountDetails.Person_Account__r.Solarisbank_Tenent__c);
        
        return SolarisbankService.fetchSepaCreditTransfer(bankAccountDetails.Person_Account__r.Solarisbank_Id__c, bankAccountDetails.Solarisbank_Id__c, transactionId,apiCallDetails);
    }
    @AuraEnabled
    public static String retriveTransactionDetails(String bankcaseId){
        
        Bank_Case_Item__c bankCase=getBankCaseDetails(bankcaseId);
         LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(bankCase.Id,'Bank_Case_Item__c',bankCase.Booking__r.Bank_Account__r.Person_Account__r.Solarisbank_Tenent__c);
        return SolarisbankService.fetchSepaCreditTransfer(bankCase.Booking__r.Bank_Account__r.Person_Account__r.Solarisbank_Id__c,
                                                          bankCase.Booking__r.Bank_Account__r.Solarisbank_Id__c,
                                                          bankCase.Booking__r.Transaction_Id__c,apiCallDetails);
    }
    @AuraEnabled
    public static String fetchTrasnsactionDetails(string bankcaseId){
        Bank_Case_Item__c bankcase=getBankCaseDetails(bankcaseId);
        
        LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(bankcase.Id,'Bank_Case_Item__c',bankCase.Booking__r.Bank_Account__r.Person_Account__r.Solarisbank_Tenent__c);
        return SolarisbankService.fetchSepaCreditTransfer(bankCase.Booking__r.Bank_Account__r.Person_Account__r.Solarisbank_Id__c, bankCase.Booking__r.Bank_Account__r.Solarisbank_Id__c, bankCase.Booking__r.Transaction_Id__c, apiCallDetails);
    }
    
    @AuraEnabled
    public static string retriveBalanceDetails(string bankcaseId){
        Bank_Case_Item__c bankcase=getBankCaseDetails(bankcaseId);
        
        LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(bankcase.Id,'Bank_Case_Item__c',bankCase.Bank_Account__r.Person_Account__r.Solarisbank_Tenent__c);
        
        return SolarisbankService.fetchAccountBalance(bankcase.Bank_Account__r.Solarisbank_Id__c,apiCallDetails);
    }
    @AuraEnabled
    public static String createStatment(String recordId,Bank_Account__c bankAccountDetails,Boolean filterdByRange,String sbAccountId,String body){
        
        LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(recordId,'Case',bankAccountDetails.Person_Account__r.Solarisbank_Tenent__c);
        
        if(filterdByRange) return  SolarisbankService.createBankStatementByRange(sbAccountId,body,apiCallDetails);
        else  return SolarisbankService.createBankStatementByPeriod(sbAccountId,body,apiCallDetails);
    }
    @AuraEnabled
    public static String fetchBankStatement(String recordId,Bank_Account__c bankAccountDetails,Boolean filterdByRange,String solarisBankAccountId,Statement__c statement){
        
        LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(recordId,'Case',bankAccountDetails.Person_Account__r.Solarisbank_Tenent__c);
        
        String STATEMENT_OF_ACCOUNTS = Constant.STATEMENT_OF_ACCOUNTS_RECORDTYPEID;
        String BANK_STATEMENTS = Constant.BANK_STATEMENTS_RECORDTYPEID;
        statement.RecordTypeId = filterdByRange ? BANK_STATEMENTS : STATEMENT_OF_ACCOUNTS;
        String completeStatmentJSON='';
        if(filterdByRange){
            completeStatmentJSON =  SolarisbankService.fetchBankStatementByRange(solarisBankAccountId,statement.Solarisbank_Id__c,apiCallDetails);
        }
        else{
            completeStatmentJSON =  SolarisbankService.fetchBankStatementByPeriod(solarisBankAccountId,statement.Solarisbank_Id__c,apiCallDetails);
        }
        insert statement;
        return statement.Id+'________'+completeStatmentJSON;
    }  
   
    /////////////////////////////
    //Operations
    ////////////////////////////
    
    @AuraEnabled
    public static string createNewIdentification(String recordId,String languageCode){
        return BankCaseService.createNewIdentification(recordId,languageCode);
    } 
    
    @AuraEnabled
    public static SolarisbankCRPRequestWrapper intitatePersonDetailsChangeTanRequest(String recordId,String requestChangebody){
       return BankCaseService.intitatePersonDetailsChangeTanRequest(recordId,requestChangebody);
        
    }
    
    @AuraEnabled
    public static String confirmPersonDetailsChangeTanRequest(String recordId,String tanurl,String otp){
        return BankCaseService.confirmPersonDetailsChangeTanRequest(recordId,tanurl,otp);
        
    }
    
    
     
    @AuraEnabled
    public static List<String> createBankCases(String caseId,String typeI,String typeII,String description, 
                                               String bankId,String cardId,String accountId,
                                               List<String> bookingsId,List<String> reservationsId,
                                               List<String> timedOrdersId,List<String> standingOrdersId,String statementId,List<String> idententificationsIds){
                                                   return  BankCaseService.createBankCasesRecords(caseId,typeI,typeII,description,
                                                                                                  bankId,cardId,accountId,bookingsId,reservationsId,
                                                                                                  timedOrdersId,standingOrdersId,statementId,idententificationsIds);
                                               }
    
    
    
    @AuraEnabled
    public static void changeCardStatus(Bank_Case_Item__c bankCaseDetails,String newStatus,String reasonForChange,Boolean isJira){
        BankCaseService.initiateCardStatusChange(bankCaseDetails,newStatus,reasonForChange,isJira);
    }
    
    
    @AuraEnabled
    public static void requestCancleTimedOrder(Bank_Case_Item__c bankCaseDetails,String reason){
        BankCaseService.initiateTimedOrderCancelation(bankCaseDetails,reason);
    } 
    
    @AuraEnabled
    public static String requestCreateNewCard(String bankCaseId,String body){
       return BankCaseService.requestCreateNewCard(bankCaseId,body);
    }
    
    /////////////////////////////
    //DML
    ////////////////////////////
    @AuraEnabled
    public static void logVarification(Case_Verification__c cv){
        insert cv;
    }
    
}