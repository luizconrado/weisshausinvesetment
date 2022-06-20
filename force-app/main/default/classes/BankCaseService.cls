/***************
* @group Service Class
* @description all bank case object related logic is here
*/
public with sharing class BankCaseService {
    
    private static Bank_Case_Item__c initiateBankCase(String caseId,String filedName,String recordId,String recordType){
        String accountRecordTypeId = Constant.BANKCASE_ACCOUNT_RECORDTYPEID;
        String bankAccountRecordTypeId =Constant.BANKCASE_BANKACCOUNT_RECORDTYPEID;
        String cardRecordTypeId = Constant.BANKCASE_CARD_RECORDTYPEID;
        String bookingRecordTypeId = Constant.BANKCASE_BOOKING_RECORDTYPEID;
        String reservationRecordTypeId =  Constant.BANKCASE_RESERVATION_RECORDTYPEID;
        String standingRecordTypeId = Constant.BANKCASE_STANDINGORDER_RECORDTYPEID;
        String timedRecordTypeId = Constant.BANKCASE_TIMEDGORDER_RECORDTYPEID;
        String statementRecordTypeId =  Constant.BANKCASE_STATEMENT_RECORDTYPEID; 
        String identificationRecordTypeId=Constant.BANKCASE_IDENTIFICATION_RECORDTYPEID;
        Bank_Case_Item__c bc=new Bank_Case_Item__c();
        bc.Case__c=caseId;
        bc.put(filedName,recordId);
        switch on recordType {
            when 'TIMED_ORDER' {		
                bc.RecordTypeId = timedRecordTypeId;
            }	
            when 'STANDING_ORDER' {
                bc.RecordTypeId = standingRecordTypeId;
            }
        }
        switch on filedName {
            when 'Account__c' {		
                bc.RecordTypeId = accountRecordTypeId;
            }	
            when 'Bank_Account__c' {
                bc.RecordTypeId = bankAccountRecordTypeId;
            }
            when 'Card__c' {
                bc.RecordTypeId = cardRecordTypeId;
            }
            when 'Statement__c' {
                bc.RecordTypeId = statementRecordTypeId;
            }
            when 'Booking__c' {
                bc.RecordTypeId = bookingRecordTypeId;
            }
            when 'Reservation__c' {
                bc.RecordTypeId = reservationRecordTypeId;
            }
            when 'Identification__c' {
                bc.RecordTypeId = identificationRecordTypeId;
            }
            
        }
        return bc;
    }
    
    //Create Bank Case Records
    @AuraEnabled
    public static List<String> createBankCasesRecords(String caseId,String typeI,String typeII,String description, 
                                                      String bankId,String cardId,String accountId,
                                                      List<String> bookingsId,List<String> reservationsId,
                                                      List<String> timedOrdersId,List<String> standingOrdersId,String statementId,List<String> idententificationsIds){
                                                          try{                          
                                                              
                                                              
                                                              List<Bank_Case_Item__c> toInsertList = new List<Bank_Case_Item__c>();
                                                              List<String> toInsertIds = new List<String>();
                                                              
                                                              Case caseDetails=new Case();
                                                              caseDetails.Id=caseId;
                                                              caseDetails.Type = typeI;
                                                              caseDetails.Type_II__c=typeII;
                                                              caseDetails.Status='In Progress';
                                                              caseDetails.Internal_Description__c=description;
                                                              
                                                              Boolean isAccountExsists = false;
                                                              Boolean isBankExsists = false;
                                                              Boolean isCardExsisits = false;
                                                              Map<String,Boolean> isBookingExsists = new Map<String,Boolean>();
                                                              Map<String,Boolean> isReservationExsists = new Map<String,Boolean>();
                                                              Map<String,Boolean> isTimedExsists = new Map<String,Boolean>();
                                                              Map<String,Boolean> isStandingExsists = new Map<String,Boolean>();
                                                              Map<String,Boolean> isIdentificationExsists = new Map<String,Boolean>();
                                                              
                                                              for(String bookingId:bookingsId)   if(String.isNotBlank(bookingId)) isBookingExsists.put(bookingId,false);
                                                              
                                                              for(String reservationId:reservationsId)   if(String.isNotBlank(reservationId)) isReservationExsists.put(reservationId,false);
                                                              
                                                              for(String timedOrderId:timedOrdersId)   if(String.isNotBlank(timedOrderId)) isTimedExsists.put(timedOrderId,false);
                                                              
                                                              for(String standingOrderId:standingOrdersId)  if(String.isNotBlank(standingOrderId)) isStandingExsists.put(standingOrderId,false);
                                                              
                                                              for(String idententificationsId:idententificationsIds)  if(String.isNotBlank(idententificationsId)) isIdentificationExsists.put(idententificationsId,false);
                                                              
                                                              
                                                              List<Bank_Case_Item__c> allBankCases=[SELECT Id, Case__c, Bank_Account__c, Booking__c, Reservation__c, Scheduled_Order__c, Statement__c, Card__c, Seizure__c, Identification__c, Tax_Identification__c, Is_Test__c,  Account__c 
                                                                                                    FROM Bank_Case_Item__c WHERE Case__c=:caseId];            
                                                              for(Bank_Case_Item__c bCases:allBankCases){
                                                                  //check timed record
                                                                  if(isTimedExsists.containsKey(bCases.Scheduled_Order__c )) isTimedExsists.put(bCases.Scheduled_Order__c,true);   
                                                                  //check standing record
                                                                  if(isStandingExsists.containsKey(bCases.Scheduled_Order__c )) isStandingExsists.put(bCases.Scheduled_Order__c,true); 
                                                                  
                                                                  
                                                                  //check account record
                                                                  if(String.isNotBlank(accountId) &&  bCases.Account__c == accountId)  isAccountExsists = true;
                                                                  //check bank account record
                                                                  if(String.isNotBlank(bankId) && bCases.Bank_Account__c == bankId) isBankExsists = true;
                                                                  //check card record
                                                                  if(String.isNotBlank(cardId) && bCases.Card__c == cardId) isCardExsisits = true;
                                                                  //check bookings record
                                                                  if(isBookingExsists.containsKey(bCases.Booking__c))  isBookingExsists.put(bCases.Booking__c,true);  
                                                                  
                                                                  //check reservation record
                                                                  if(isReservationExsists.containsKey(bCases.Reservation__c )) isReservationExsists.put(bCases.Reservation__c,true);  
                                                                  //checking identification records
                                                                  if(isIdentificationExsists.containsKey(bCases.Identification__c )) isIdentificationExsists.put(bCases.Identification__c,true);  
                                                              }
                                                              
                                                              if(!isAccountExsists && String.isNotBlank(accountId)) toInsertList.add(initiateBankCase(caseId,'Account__c',accountId,''));
                                                              if(!isBankExsists && String.isNotBlank(bankId))  toInsertList.add(initiateBankCase(caseId,'Bank_Account__c',bankId,''));
                                                              if(!isCardExsisits && String.isNotBlank(cardId)) toInsertList.add(initiateBankCase(caseId,'Card__c',cardId,''));
                                                              if(String.isNotEmpty(statementId)) toInsertList.add(initiateBankCase(caseId,'Statement__c',statementId,''));
                                                              
                                                              for(String bookingId:isBookingExsists.keySet()){
                                                                  if(String.isNotBlank(bookingId) && !isBookingExsists.get(bookingId)){
                                                                      toInsertList.add(initiateBankCase(caseId,'Booking__c',bookingId,''));
                                                                  }
                                                              }
                                                              for(String reservation:isReservationExsists.keySet()){
                                                                  if(String.isNotBlank(reservation) && !isReservationExsists.get(reservation)){
                                                                      toInsertList.add(initiateBankCase(caseId,'Reservation__c',reservation,''));
                                                                  }
                                                              }
                                                              
                                                              
                                                              for(String timedOrder:isTimedExsists.keySet()){
                                                                  if(String.isNotBlank(timedOrder) && !isTimedExsists.get(timedOrder)){
                                                                      toInsertList.add(initiateBankCase(caseId,'Scheduled_Order__c',timedOrder,'TIMED_ORDER'));       
                                                                  }
                                                              }
                                                              
                                                              for(String standingOrder:isStandingExsists.keySet()){
                                                                  if(String.isNotBlank(standingOrder) && !isStandingExsists.get(standingOrder)){
                                                                      toInsertList.add(initiateBankCase(caseId,'Scheduled_Order__c',standingOrder,'STANDING_ORDER'));
                                                                  }
                                                              }
                                                              for(String identification:isIdentificationExsists.keySet()){
                                                                  if(String.isNotBlank(identification) && !isIdentificationExsists.get(identification)){
                                                                      toInsertList.add(initiateBankCase(caseId,'Identification__c',identification,''));
                                                                  }
                                                              }
                                                              
                                                              
                                                              
                                                              update caseDetails;
                                                              if(toInsertList.size()>0) toInsertIds = DatabaseService.insertRecords(toInsertList); 
                                                              return toInsertIds;
                                                          }
                                                          catch(Exception e){
                                                              String index = logError(e,caseId,'Case','BankCaseNewOverride','createBankCasesRecords','Create New Bank Case');
                                                              throw new AuraHandledException('Please contact your System admin.And provide '+index+' id to resolve issue.');
                                                          }
 
                                                      }
    //Change Card Status
    @AuraEnabled
    public static void initiateCardStatusChange(Bank_Case_Item__c bankCaseDetails,String newStatus,String reasonForChange,Boolean isJira){
        try{
            LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(bankCaseDetails.Id,'Bank_Case_Item__c',bankCaseDetails.Card__r.Person_Account__r.Solarisbank_Tenent__c);
            
            Boolean updateCase = false;
            bankCaseDetails.Old_Card_Status__c =bankCaseDetails.Card__r.Status__c;
            Case supportCase = new Case();
            if(isJira){
                
                
                supportCase.Status = 'Jira Ticket';
                supportCase.JIRA_Description__c ='Summary';
                supportCase.JIRA_Description__c +='\n';
                supportCase.JIRA_Description__c += bankCaseDetails.Card__r.Solarisbank_Id__c + ' - ' + bankCaseDetails.Card__r.Person_Account__r.Name + ' - Card ' + newStatus;
                supportCase.JIRA_Description__c +='\n';
                supportCase.JIRA_Description__c +='\n';
                supportCase.JIRA_Description__c +='Description ';
                supportCase.JIRA_Description__c +='\n'; 
                supportCase.JIRA_Description__c +=reasonForChange;
                supportCase.Id = bankCaseDetails.Case__c;
                updateCase = true;
                
                bankCaseDetails.Action__c = newStatus;
                bankCaseDetails.Description__c = reasonForChange;
            }
            else{
                String apiResponseJSON = '';
                if(newStatus=='Block') apiResponseJSON = SolarisbankService.blockAccountCard(bankCaseDetails.Card__r.Solarisbank_Id__c,apiCallDetails);    
                if(newStatus=='Close') apiResponseJSON = SolarisbankService.closeAccountCard(bankCaseDetails.Card__r.Solarisbank_Id__c,apiCallDetails);    
                if(newStatus=='Unblock') apiResponseJSON = SolarisbankService.unblockAccountCard(bankCaseDetails.Card__r.Solarisbank_Id__c,apiCallDetails);       
                SolarisbankService.CardResponse apiResponse=(SolarisbankService.CardResponse) JSON.deserialize(apiResponseJSON, SolarisbankService.CardResponse.class);
                String responseStatus = apiResponse.status;
                if(apiResponse.errors!=null){
                    bankCaseDetails.Api_Error__c = apiResponse.errors.get(0).detail;
                    String newResponseJSON = SolarisbankService.fetchAccountCard(bankCaseDetails.Card__r.Solarisbank_Id__c,apiCallDetails);
                    SolarisbankService.CardResponse newStatusResponse= (SolarisbankService.CardResponse) JSON.deserialize(newResponseJSON, SolarisbankService.CardResponse.class);
                    responseStatus = newStatusResponse.status;
                }
                
                Card__c card = new Card__c();
                card.Id = bankCaseDetails.Card__c;
                card.Status__c=responseStatus;
                update card;
                
                bankCaseDetails.Action__c = newStatus;
                bankCaseDetails.Description__c = reasonForChange;
                bankCaseDetails.New_Card_Status__c = responseStatus;
                
                
            }
            
            if(updateCase) update supportCase;
            update bankCaseDetails;
        }
        catch(Exception e){
            String index = logError(e,bankCaseDetails.Id,'Bank_Case_Item__c','BankCaseCardStatusChange','initiateCardStatusChange','Change Card Status');
            AuraHandledException error= new AuraHandledException('Please contact your System admin.And provide '+index+' id to resolve issue.');
            error.setMessage(error.getMessage());
            throw error;
            
        }        
    }
    
    //Cancel timed Order
    @AuraEnabled
    public static void initiateTimedOrderCancelation(Bank_Case_Item__c bankCaseDetails,String reason){
        try{
            LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(bankCaseDetails.Id,'Bank_Case_Item__c',bankCaseDetails.Scheduled_Order__r.Bank_Account__r.Person_Account__r.Solarisbank_Tenent__c);
            
            bankCaseDetails.Old_Order_Status__c = bankCaseDetails.Scheduled_Order__r.Status__c;
            String responseJSON = SolarisbankService.cancelTimedOrder(bankCaseDetails.Scheduled_Order__r.Bank_Account__r.Person_Account__r.Solarisbank_Id__c, bankCaseDetails.Scheduled_Order__r.Bank_Account__r.Solarisbank_Id__c, bankCaseDetails.Scheduled_Order__r.Solarisbank_Id__c,apiCallDetails);
            SolarisbankTimedOrderWrapper orderDetails = (SolarisbankTimedOrderWrapper) SolarisbankTimedOrderWrapper.parseObject(responseJSON);
            
            Scheduled_Order__c order = new Scheduled_Order__c();
            order.Id = bankCaseDetails.Scheduled_Order__c;
            order.Status__c = orderDetails.status;
            
            bankCaseDetails.New_Order_Status__c= orderDetails.status; 
            bankCaseDetails.Action__c = 'Cancel Timed Order';
            bankCaseDetails.Description__c = reason;
            update order;
            update  bankCaseDetails;
        }
        catch(Exception e){
            String index = logError(e,bankCaseDetails.Id,'Bank_Case_Item__c','BankCaseTimedOrderCancle','initiateTimedOrderCancelation','Cancle Timed Order');
            throw new AuraHandledException('Please contact your System admin.And provide '+index+' id to resolve issue.');
        }
    } 
    
    //create new identification
    public static string createNewIdentification(String recordId,String languageCode){
        try{
            Bank_Case_Item__c bankAccountDetails=[SELECT Id,Case__c,Action__c, Account__c,Identification__c,Account__r.Solarisbank_Id__c,Account__r.Solarisbank_Tenent__c FROM Bank_Case_Item__c WHERE id=:recordId];
            LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(recordId,'Bank_Case_Item__c',bankAccountDetails.Account__r.Solarisbank_Tenent__c);
            String requestBody='{"method": "idnow","language": "'+languageCode+'"}';
            String res=SolarisbankService.createNewIdentificationAttempt(bankAccountDetails.Account__r.Solarisbank_Id__c,requestBody,apiCallDetails);
            SolarisBankIdentificationWrapper response=SolarisBankIdentificationWrapper.parse(res);
            if(String.isNotEmpty(response.id)){
                LogService.ApiCallDetails apiCallDetailsForIdent =  new LogService.ApiCallDetails(recordId,'Bank_Case_Item__c',bankAccountDetails.Account__r.Solarisbank_Tenent__c);
                String responseString=SolarisbankService.fetchIdentificationRequestDetails(bankAccountDetails.Account__r.Solarisbank_Id__c,response.id,apiCallDetailsForIdent);
                SolarisBankIdentificationWrapper identResponse=SolarisBankIdentificationWrapper.parse(responseString);
                
                KYC_Detail__c newIdentification=new KYC_Detail__c();
                newIdentification.Solarisbank_Id__c=response.id;      
                newIdentification.Method__c='IDnow';
                newIdentification.Account__c=bankAccountDetails.Account__c;
                newIdentification.RecordTypeId=Constant.KYC_VIDEO_IDENTIFICATION_RECORDTYPEID;
                if(String.isNotEmpty(identResponse.url)) newIdentification.URL__c=identResponse.url;
                if(String.isNotEmpty(identResponse.reference)) newIdentification.Reference__c=identResponse.reference;
                insert newIdentification; 
                bankAccountDetails.Identification__c=newIdentification.Id;
                
                bankAccountDetails.Action__c='New Person Identification';
                update bankAccountDetails;
                Bank_Case_Item__c newbankCaseItem=new Bank_Case_Item__c();
                newbankCaseItem.Case__c=bankAccountDetails.Case__c;
                newbankCaseItem.Identification__c=newIdentification.id;
                newbankCaseItem.recordTypeId=Constant.BANKCASE_IDENTIFICATION_RECORDTYPEID;
                insert newbankCaseItem;
                
                return newIdentification.Id;
            }
            return res;
        }
        catch(Exception e){
            String index = logError(e,recordId,'Bank_Case_Item__c','BankCaseCreateNewIdentificationAttempt','createNewIdentification','Request New Idnow');
            throw new AuraHandledException('Please contact your System admin.And provide '+index+' id to resolve issue.');
        }
 
    } 
    
    //request details change
    public static SolarisbankCRPRequestWrapper intitatePersonDetailsChangeTanRequest(String recordId,String requestChangebody){
        try{
            List<Change_Request_Log__c> changeRequestList=new List<Change_Request_Log__c>();
            Bank_Case_Item__c bankAccountDetails=[SELECT Id,Case__c,Description__c,Action__c, Account__c,Identification__c,Account__r.Solarisbank_Id__c,Account__r.Solarisbank_Tenent__c FROM Bank_Case_Item__c WHERE id=:recordId];
            LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(recordId,'Bank_Case_Item__c',bankAccountDetails.Account__r.Solarisbank_Tenent__c);
            
            String responseString= SolarisbankService.updateCustomerData(bankAccountDetails.Account__r.Solarisbank_Id__c,requestChangebody,apiCallDetails);
            
            SolarisbankCRPRequestWrapper tanUrlResponse=SolarisbankCRPRequestWrapper.parse(responseString);
            
            if(tanUrlResponse.errors!=null && tanUrlResponse.errors.size()>0){
                Change_Request_Log__c changeRequestLog=new Change_Request_Log__c();
                changeRequestLog.Solarisbank_Id__c=tanUrlResponse.id;
                changeRequestLog.Operation__c='Update Account Details';
                changeRequestLog.Object_Name__c='Bank_Case_Item__c';
                changeRequestLog.Record_Id__c=recordId;
                changeRequestLog.Status__c='FAILED';
                changeRequestLog.Description__c=tanUrlResponse.errors.get(0).title +' : '+tanUrlResponse.errors.get(0).detail;
                changeRequestList.add(changeRequestLog);
                insert changeRequestList;
                return tanUrlResponse;
            }
            else{
                Change_Request_Log__c changeRequestLog=new Change_Request_Log__c();
                changeRequestLog.Solarisbank_Id__c=tanUrlResponse.id;
                changeRequestLog.Object_Name__c='Bank_Case_Item__c';
                changeRequestLog.Operation__c='Update Account Details';
                changeRequestLog.Record_Id__c=recordId;
                changeRequestLog.Status__c=tanUrlResponse.status;
                changeRequestLog.Updated_At__c=tanUrlResponse.updated_at;
                changeRequestLog.URL__c=tanUrlResponse.url;
                changeRequestList.add(changeRequestLog);
            }
            
            
            String crpResponseString = SolarisbankService.initiateCRPRequest(tanUrlResponse.url,bankAccountDetails.Account__r.Solarisbank_Id__c,apiCallDetails);
            SolarisbankCRPRequestWrapper crpResponse=SolarisbankCRPRequestWrapper.parse(crpResponseString);
            
            Change_Request_Log__c crpRequestLog=new Change_Request_Log__c();
            crpRequestLog.Solarisbank_Id__c=crpResponse.id;
            crpRequestLog.Object_Name__c='Bank_Case_Item__c';
            crpRequestLog.Operation__c='Update Account Details';
            crpRequestLog.Record_Id__c=recordId;
            crpRequestLog.Status__c=crpResponse.status;
            crpRequestLog.Updated_At__c=crpResponse.updated_at;
            crpRequestLog.URL__c=tanUrlResponse.url.replace('/authorize', '/confirm');
            changeRequestList.add(crpRequestLog);
            bankAccountDetails.Action__c='Update Person Details';
            bankAccountDetails.Description__c='Request to change '+requestChangebody;
            update bankAccountDetails;
            insert changeRequestList;
            return tanUrlResponse;
        }
        catch(Exception e){
            String index = logError(e,recordId,'Bank_Case_Item__c','BankCaseUpdatePersonDetails','intitatePersonDetailsChangeTanRequest','CRP for Person Details');
            AuraHandledException exp=new AuraHandledException('Please contact your System admin.And provide '+index+' id to resolve issue.');
            exp.setMessage(e.getMessage());
            throw exp;
            
        }
         
    }
    
    //accept crp otp and conform request
    public static String confirmPersonDetailsChangeTanRequest(String recordId,String tanurl,String otp){
       try{
            List<Change_Request_Log__c> changeRequestList=new List<Change_Request_Log__c>();
            Bank_Case_Item__c bankAccountDetails=[SELECT Description__c,Id,Case__c,Action__c, Account__c,Identification__c,Account__r.Solarisbank_Id__c,Account__r.Solarisbank_Tenent__c FROM Bank_Case_Item__c WHERE id=:recordId];
            LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(recordId,'Bank_Case_Item__c',bankAccountDetails.Account__r.Solarisbank_Tenent__c);
            String responseString = SolarisbankService.confirmCRPRequest(tanurl,bankAccountDetails.Account__r.Solarisbank_Id__c,otp,apiCallDetails);
            SolarisbankCRPRequestWrapper tanUrlResponse=SolarisbankCRPRequestWrapper.parse(responseString);
            
            Change_Request_Log__c crpRequestLog=new Change_Request_Log__c();
            if(tanUrlResponse.errors!=null && tanUrlResponse.errors.size()>0){
                crpRequestLog.Solarisbank_Id__c=tanUrlResponse.errors.get(0).id;
                crpRequestLog.Object_Name__c='Bank_Case_Item__c';
                crpRequestLog.Operation__c='Update Account Details';
                crpRequestLog.Record_Id__c=recordId;
                crpRequestLog.Status__c='FAILED';
                crpRequestLog.Description__c=tanUrlResponse.errors.get(0).title +' : '+tanUrlResponse.errors.get(0).detail;
                
            }
            else{
                crpRequestLog.Solarisbank_Id__c=tanUrlResponse.id;
                crpRequestLog.Object_Name__c='Bank_Case_Item__c';
                crpRequestLog.Operation__c='Update Account Details';
                crpRequestLog.Record_Id__c=recordId;
                crpRequestLog.Status__c=tanUrlResponse.status;
                crpRequestLog.Updated_At__c=tanUrlResponse.updated_at;
                crpRequestLog.URL__c=tanUrlResponse.url;
                AccountService.syncPersonDetailsWithSB(bankAccountDetails.Account__c);
            }
            
            
            
            insert crpRequestLog;
            return responseString;
        }
        catch(Exception e){
            
            String index = logError(e,recordId,'Bank_Case_Item__c','BankCaseUpdatePersonDetails','confirmPersonDetailsChangeTanRequest','Accept CRP for Person Details');
            throw new AuraHandledException('Please contact your System admin.And provide '+index+' id to resolve issue.');
        }
 
    }
    
      @AuraEnabled
    public static String requestCreateNewCard(String bankCaseId,String body){
        try{
            
            Map<String,Object> cardRequestBody=(Map<String,Object>) JSON.deserializeUntyped(body);
            Bank_Case_Item__c bankAccountDetails=[SELECT Id,Case__c,Description__c,Bank_Account__r.Person_Account__r.FirstName ,Bank_Account__r.Person_Account__r.LastName,Bank_Account__c,Bank_Account__r.Status__c,Bank_Account__r.Solarisbank_Id__c,Bank_Account__r.Person_Account__r.Solarisbank_Id__c,Bank_Account__r.Person_Account__r.Solarisbank_Tenent__c   FROM Bank_Case_Item__c WHERE id=:bankCaseId];
            LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(bankCaseId,'Bank_Case_Item__c',bankAccountDetails.Bank_Account__r.Person_Account__r.Solarisbank_Tenent__c);
            String res=SolarisbankService.requestNewCard(bankAccountDetails.Bank_Account__r.Person_Account__r.Solarisbank_Id__c, bankAccountDetails.Bank_Account__r.Solarisbank_Id__c, body,apiCallDetails);
            SolarisbankService.CardResponse bankAccount=(SolarisbankService.CardResponse) JSON.deserialize(res, SolarisbankService.CardResponse.class);
            if(bankAccount.errors!=null){
                return res;
            }
            
            bankAccountDetails.Action__c='New Card';
            bankAccountDetails.Description__c='Request for new card with refrence '+((String) cardRequestBody.get('reference'));
            
            Card__c newCard=new Card__c();
            newCard.Status__c=bankAccount.status;
            newCard.Type__c=(String) cardRequestBody.get('type');
            newCard.Name_On_Card__c =(String) cardRequestBody.get('line_1');
            newCard.Person_Account__c=bankAccountDetails.Bank_Account__r.Person_Account__c;
            newCard.Bank_Account__c=bankAccountDetails.Bank_Account__c;
            newCard.Solarisbank_Id__c=bankAccount.id;
            insert newCard;
            
            Bank_Case_Item__c newbankCaseItem=new Bank_Case_Item__c();
            newbankCaseItem.Case__c=bankAccountDetails.Case__c;
            newbankCaseItem.Card__c=newCard.id;
            newbankCaseItem.recordTypeId=Constant.BANKCASE_CARD_RECORDTYPEID;
            
            bankAccountDetails.Card__c=newCard.id;
            
            insert newbankCaseItem;
            update bankAccountDetails;
            
            return res;
        }
        catch(Exception e){
             
            String index = logError(e,bankCaseId,'Bank_Case_Item__c','BankCaseRequestNewCard','requestCreateNewCard','Request For New Card');
            throw new AuraHandledException('Please contact your System admin.And provide '+index+' id to resolve issue.');
             
        }
    }
    
    //helper
    private static String logError(Exception e,String recordID,String objectName,String componentName,String methodName,String operation){
        LogService.LogMetadata details=new LogService.LogMetadata();
        details.addError(e);
        details.addRecordInfo(objectName,recordId);
        
        details.addMetadataInfo(userinfo.getUserId(),'BankCaseService', methodName, componentName, operation);
        return LogService.logError(details);
    }
    
   
    
    
}