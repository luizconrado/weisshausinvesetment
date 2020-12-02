public with sharing class BankCaseService {
    private static Bank_Case__c initiateBankCase(String caseId,String filedName,String recordId,String recordType){
        String accountRecordTypeId = Constant.BANKCASE_ACCOUNT_RECORDTYPEID;
        String bankAccountRecordTypeId =Constant.BANKCASE_BANKACCOUNT_RECORDTYPEID;
        String cardRecordTypeId = Constant.BANKCASE_CARD_RECORDTYPEID;
        String bookingRecordTypeId = Constant.BANKCASE_BOOKING_RECORDTYPEID;
        String reservationRecordTypeId =  Constant.BANKCASE_RESERVATION_RECORDTYPEID;
        String standingRecordTypeId = Constant.BANKCASE_STANDINGORDER_RECORDTYPEID;
        String timedRecordTypeId = Constant.BANKCASE_TIMEDGORDER_RECORDTYPEID;
        String statementRecordTypeId =  Constant.BANKCASE_STATEMENT_RECORDTYPEID;   
        Bank_Case__c bc=new Bank_Case__c();
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
        }
        return bc;
    }
    
    //Create Bank Case Records
    @AuraEnabled
    public static List<String> createBankCasesRecords(String caseId,String typeI,String typeII,String description, 
                                                      String bankId,String cardId,String accountId,
                                                      List<String> bookingsId,List<String> reservationsId,
                                                      List<String> timedOrdersId,List<String> standingOrdersId,String statementId){
                                                          try{                          
                                                              
                                                              
                                                              List<Bank_Case__c> toInsertList = new List<Bank_Case__c>();
                                                              List<String> toInsertIds = new List<String>();
                                                              
                                                              Case caseDetails=new Case();
                                                              caseDetails.Id=caseId;
                                                              caseDetails.Type = typeI;
                                                              caseDetails.Type_II__c=typeII;
                                                              caseDetails.Description=description;
                                                              
                                                              Boolean isAccountExsists = false;
                                                              Boolean isBankExsists = false;
                                                              Boolean isCardExsisits = false;
                                                              Map<String,Boolean> isBookingExsists = new Map<String,Boolean>();
                                                              Map<String,Boolean> isReservationExsists = new Map<String,Boolean>();
                                                              Map<String,Boolean> isTimedExsists = new Map<String,Boolean>();
                                                              Map<String,Boolean> isStandingExsists = new Map<String,Boolean>();
                                                              
                                                              for(String bookingId:bookingsId)   if(String.isNotBlank(bookingId)) isBookingExsists.put(bookingId,false);
                                                              
                                                              for(String reservationId:reservationsId)   if(String.isNotBlank(reservationId)) isReservationExsists.put(reservationId,false);
                                                              
                                                              for(String timedOrderId:timedOrdersId)   if(String.isNotBlank(timedOrderId)) isTimedExsists.put(timedOrderId,false);
                                                              
                                                              for(String standingOrderId:standingOrdersId)  if(String.isNotBlank(standingOrderId)) isStandingExsists.put(standingOrderId,false);
                                                              
                                                              List<Bank_Case__c> allBankCases=[SELECT Id, Case__c, Bank_Account__c, Booking__c, Reservation__c, Scheduled_Order__c, Statement__c, Card__c, Seizure__c, Identification__c, Tax_Identification__c, Is_Test__c,  Account__c 
                                                                                               FROM Bank_Case__c WHERE Case__c=:caseId];            
                                                              for(Bank_Case__c bCases:allBankCases){
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
                                                              
                                                              
                                                              update caseDetails;
                                                              if(toInsertList.size()>0) toInsertIds = DatabaseService.insertRecords(toInsertList); 
                                                              return toInsertIds;
                                                          }
                                                          catch(Exception e){
                                                              LogService.LogMetadata details=new LogService.LogMetadata();
                                                              details.error=e;
                                                              details.componentName='BankCaseNewOverride';
                                                              details.userId=userinfo.getUserId();
                                                              details.recordId=caseId;
                                                              details.objectName='Case';
                                                              details.className='BankCaseService';
                                                              details.operation='Create New Bank Case';
                                                              details.methodName='createBankCasesRecords';
                                                            
                                                              String index = LogService.logError(details);
                                                              throw new AuraHandledException('Please contact your System admin.And provide '+index+' id to resolve issue.');
                                                          }
                                                      }
    //Change Card Status
    @AuraEnabled
    public static void initiateCardStatusChange(Bank_Case__c bankCaseDetails,String newStatus,String reasonForChange,Boolean isJira){
        try{
            LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(bankCaseDetails.Id,'Bank_Case__c',bankCaseDetails.Card__r.Person_Account__r.Solarisbank_Tenent__c);
            
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
            LogService.LogMetadata details=new LogService.LogMetadata();
            details.error=e;
            details.componentName='BankCaseCardStatusChange';
            details.userId=userinfo.getUserId();
            details.recordId=bankCaseDetails.Id;
            details.objectName='Bank_Case__c';
            details.className='BankCaseService';
            details.operation='Change Card Status';
            details.methodName='initiateCardStatusChange';
            String index = LogService.logError(details);
            throw new AuraHandledException('Please contact your System admin.And provide '+index+' id to resolve issue.');
        }        
    }
    
    //Cancel timed Order
    @AuraEnabled
    public static void initiateTimedOrderCancelation(Bank_Case__c bankCaseDetails,String reason){
        try{
            LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(bankCaseDetails.Id,'Bank_Case__c',bankCaseDetails.Scheduled_Order__r.Bank_Account__r.Person_Account__r.Solarisbank_Tenent__c);
            
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
            LogService.LogMetadata details=new LogService.LogMetadata();
            details.error=e;
            details.componentName='BankCaseTimedOrderCancle';
            details.userId=userinfo.getUserId();
            details.recordId=bankCaseDetails.Id;
            details.objectName='Bank_Case__c';
            details.className='BankCaseService';
            details.operation='Cancle Timed Order';
            details.methodName='initiateTimedOrderCancelation';
            String index = LogService.logError(details);
            throw new AuraHandledException('Please contact your System admin.And provide '+index+' id to resolve issue.');
        }
    } 
}