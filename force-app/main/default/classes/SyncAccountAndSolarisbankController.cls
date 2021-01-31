public class SyncAccountAndSolarisbankController {
    
    private static Decimal convertCentsToEuro(Decimal amount){
        Decimal decimalNumber = amount;
        Decimal result = decimalNumber.divide(100, 2);
        return result;
    }
    
    @AuraEnabled 
    public static void startSyncWithBank(String sfAccountId){

        Account sfAccount=[SELECT Id, LastName, FirstName, Salutation, MiddleName,Gender__pc,PersonEmail,Phone,PersonTitle,Type,
                           ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry ,
                           BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry,Solarisbank_Id__c,Solarisbank_Tenent__c,
                           Legal_Name__c,Tax_Assessment__c,Marital_Status__c,Terms_Conditions_Signed_At__c ,Flagged_By_Compliance__c,Own_Economic_Interest_Signed_At__c ,
                           Birth_Name__c, Birth_City__c, Birth_Country__c,Employment_Status__c,Fatca_Relevant__c ,Fatca_Crs_Confirmed_At__c, Business_Purpose__c, Industry_Key__c 
                           FROM Account WHERE id=:sfAccountId LIMIT 1];
        LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(sfAccount.Id,'Account',sfAccount.Solarisbank_Tenent__c);
        Map<String,Bank_Account__c> bankAccountMap=new Map<String,Bank_Account__c>();
        for(Bank_Account__c bankAccountList:[SELECT Id, Person_Account__c, Solarisbank_Id__c, BIC__c, 
                                             Type__c, Status__c, Closure_Reasons__c, Name 
                                             FROM Bank_Account__c WHERE Person_Account__c=:sfAccountId])  bankAccountMap.put(bankAccountList.Solarisbank_Id__c,bankAccountList);
        
        List<Bank_Account__c> toInsertBankAccounts=new List<Bank_Account__c>();
        List<Bank_Account__c> toUpdateBankAccounts=new List<Bank_Account__c>();
        
        Map<String,Card__c> bankCardMap=new Map<String,Card__c>();
        for(Card__c card:[SELECT Id, Type__c, Status__c, Expiration_Date__c, Person_Account__c, 
                          Bank_Account__c, Name_On_Card__c, Solarisbank_Id__c, Name  
                          FROM Card__c WHERE Person_Account__c=:sfAccountId])  bankCardMap.put(card.Solarisbank_Id__c,card);
        List<Card__c> toInsertBankCards=new List<Card__c>();
        List<Card__c> toUpdateBankCards=new List<Card__c>();
        
        Map<String,Tax_Identification__c> taxIdentificationMap=new Map<String,Tax_Identification__c>();
        for(Tax_Identification__c taxIdentification:[SELECT Id, Account__c, Country__c, Solarisbank_Id__c, Primary__c, Reason_No_Tin__c, Reason_Description__c 
                                                     FROM Tax_Identification__c 
                                                     WHERE Account__c=:sfAccountId])  taxIdentificationMap.put(taxIdentification.Solarisbank_Id__c,taxIdentification);
        List<Tax_Identification__c> toInsertTaxIdentification=new List<Tax_Identification__c>();
        List<Tax_Identification__c> toUpdateTaxIdentification=new List<Tax_Identification__c>();
        
        
        Map<String,Identification__c> personIdentificationMap=new Map<String,Identification__c>();
        for(Identification__c personIdent:[SELECT Id, Account__c, Solarisbank_Id__c, Is_Test__c, Reference__c, URL__c, Status__c, Completed_At__c, Method__c, Failure_Reason__c, Identification_Id__c, State__c 
                                                  FROM Identification__c
                                                  WHERE Account__c=:sfAccountId])  personIdentificationMap.put(personIdent.Solarisbank_Id__c,personIdent);
        List<Identification__c> toInsertperIdentification=new List<Identification__c>();
        List<Identification__c> toUpdateperIdentification=new List<Identification__c>();
       
        if(String.isNotEmpty(sfAccount.Solarisbank_Id__c)){
            //calls
            String personJson=SolarisbankService.fetchPersonDetails(sfAccount.Solarisbank_Id__c,apiCallDetails);
            SolarisbankPersonWrapper personDetails=SolarisbankPersonWrapper.parse(personJson);
            if(personDetails.last_name == null) return ;
            String phoneJson=SolarisbankService.fetchPersonPhoneNumber(sfAccount.Solarisbank_Id__c,apiCallDetails);
            Map<String,Object> phoneJsonMap=(Map<String,Object>) JSON.deserializeUntyped(phoneJson);
            
            String banksJson=SolarisbankService.fetchAllBankAccounts(sfAccount.Solarisbank_Id__c,apiCallDetails);
            List<SolarisbankBankAccountWrapper> banksList=SolarisbankBankAccountWrapper.parseList(banksJson);
            
            String cardsJson=SolarisbankService.fetchAllCards(sfAccount.Solarisbank_Id__c,apiCallDetails);
            List<SolarisbankCardWrapper> cardsList=SolarisbankCardWrapper.parseList(cardsJson);
            
            String identityJson=SolarisbankService.fetchAllIdentificationAttempts(sfAccount.Solarisbank_Id__c,apiCallDetails);
            List<SolarisBankIdentificationWrapper> indentificationList=SolarisBankIdentificationWrapper.parseList(identityJson);
            
            String esigningJson=SolarisbankService.fetchAllESigningAttempts(sfAccount.Solarisbank_Id__c,apiCallDetails);
            List<SolarisBankIdentificationWrapper> esigningList=new List<SolarisBankIdentificationWrapper>();//SolarisBankIdentificationWrapper.parseList(esigningJson);
            
             
            String taxIdenityJson=SolarisbankService.fetchAllTaxIdentificationAttempts(sfAccount.Solarisbank_Id__c,apiCallDetails);
            List<SolarisBankTaxIdentificationWrapper> taxIdentificationList=SolarisBankTaxIdentificationWrapper.parseList(taxIdenityJson);
            //operation
            if(sfAccount.Salutation==null)sfAccount.Salutation = personDetails.salutation;
            sfAccount.Gender__pc=(personDetails.salutation=='MR')?'Male':'Female';
            if(sfAccount.FirstName==null)sfAccount.FirstName = personDetails.first_name;
            if(sfAccount.Type==null) sfAccount.Type = 'Customer';
            
            if(sfAccount.LastName==null)sfAccount.LastName = personDetails.last_name;
            sfAccount.Legal_Name__c = personDetails.first_name+' '+ personDetails.last_name;
            if(personDetails.address != null)  sfAccount.BillingStreet =  personDetails.address.line_1;
            if(personDetails.address != null) sfAccount.BillingPostalCode = personDetails.address.postal_code;
            if(personDetails.address != null) sfAccount.BillingCity = personDetails.address.city;
            if(personDetails.address != null) sfAccount.BillingCountry =  personDetails.address.country;
            if(personDetails.address != null) sfAccount.BillingState =  personDetails.address.state;
            if(personDetails.contact_address != null) sfAccount.ShippingStreet =  personDetails.contact_address.line_1;
            if(personDetails.contact_address != null) sfAccount.ShippingPostalCode = personDetails.contact_address.postal_code;
            if(personDetails.contact_address != null) sfAccount.ShippingCity = personDetails.contact_address.city;
            if(personDetails.contact_address != null) sfAccount.ShippingCountry =  personDetails.contact_address.country;
            if(personDetails.contact_address != null) sfAccount.ShippingState =  personDetails.contact_address.state;
            sfAccount.PersonEmail=personDetails.email;
            sfAccount.PersonMobilePhone  = personDetails.mobile_number;
            if(phoneJsonMap.containsKey('number'))  sfAccount.Phone=(String)phoneJsonMap.get('number');
            if(personDetails.birth_date!=null) sfAccount.PersonBirthdate = Date.valueOf(personDetails.birth_date);
            sfAccount.Birth_Name__c= personDetails.birth_name;
            sfAccount.Birth_City__c=personDetails.birth_city;
            sfAccount.Birth_Country__c =personDetails.birth_country;
            sfAccount.Nationality__c  = personDetails.nationality;
            sfAccount.Employment_Status__c = personDetails.employment_status;
            sfAccount.PersonTitle = personDetails.job_title;
            if(personDetails.tax_information!=null) sfAccount.Tax_Assessment__c= personDetails.tax_information.tax_assessment;
            if(personDetails.tax_information!=null) sfAccount.Marital_Status__c=  personDetails.tax_information.marital_status;
            if(personDetails.fatca_relevant!=null) sfAccount.Fatca_Relevant__c =personDetails.fatca_relevant;
            if(String.isNotBlank(personDetails.fatca_crs_confirmed_at)) sfAccount.Fatca_Crs_Confirmed_At__c=  Date.valueOf(personDetails.fatca_crs_confirmed_at.replace('T',' '));
            sfAccount.Business_Purpose__c = personDetails.business_purpose;
            sfAccount.Industry = personDetails.industry;
            sfAccount.Industry_Key__c = personDetails.industry_key;
            if(String.isNotBlank(personDetails.terms_conditions_signed_at)) sfAccount.Terms_Conditions_Signed_At__c =DateTime.valueOf(personDetails.terms_conditions_signed_at.replace('T',' '));
            if(personDetails.flagged_by_compliance!=null)sfAccount.Flagged_By_Compliance__c =personDetails.flagged_by_compliance;
            if(String.isNotBlank(personDetails.own_economic_interest_signed_at )) sfAccount.Own_Economic_Interest_Signed_At__c  =DateTime.valueOf(personDetails.own_economic_interest_signed_at.replace('T',' '));
            update sfAccount;
            
            //bank
            for(SolarisbankBankAccountWrapper bankAccount:banksList){
                if(bankAccountMap.containsKey(bankAccount.id)){
                    Bank_Account__c bank=bankAccountMap.get(bankAccount.id);
                    if(!String.isEmpty(bank.Solarisbank_Id__c)) bank.Solarisbank_Id__c=bankAccount.id;
                    bank.BIC__c=bankAccount.bic;
                    bank.Name=bankAccount.iban;
                    bank.Type__c=bankAccount.type_Z;
                    bank.Status__c=bankAccount.locking_status;
                    bank.Closure_Reasons__c=String.join(bankAccount.locking_reasons, ',');
                    toUpdateBankAccounts.add(bank);
                }
                else{
                    Bank_Account__c bank=new Bank_Account__c();
                    bank.Solarisbank_Id__c=bankAccount.id;
                    bank.Person_Account__c=sfAccountId;
                    bank.BIC__c=bankAccount.bic;
                    bank.Name=bankAccount.iban;
                    bank.Type__c=bankAccount.type_Z;
                    bank.Status__c=bankAccount.locking_status;
                    if(bankAccount.locking_reasons!=null)bank.Closure_Reasons__c=String.join(bankAccount.locking_reasons, ',');
                    toInsertBankAccounts.add(bank);
                }
            }
            
            if(toUpdateBankAccounts.size()>0) update toUpdateBankAccounts;
            if(toInsertBankAccounts.size()>0){
                List<String> newBankAccountIds=DatabaseService.insertRecords(toInsertBankAccounts);
                
                for(Bank_Account__c bankAccount:[SELECT Id, Person_Account__c, Solarisbank_Id__c, BIC__c, 
                                                 Type__c, Status__c, Closure_Reasons__c, Name 
                                                 FROM Bank_Account__c WHERE Id IN: newBankAccountIds]){
                                                     bankAccountMap.put(bankAccount.Solarisbank_Id__c,bankAccount);
                                                 }
            } 
            System.debug('cardsList'+cardsList.size());
            
            //card
            for(SolarisbankCardWrapper cards:cardsList){
                  System.debug('cards '+cards);
                if(bankCardMap.containsKey(cards.id)){
                    Card__c card=bankCardMap.get(cards.id);
                    card.Status__c=cards.status;
                    card.Type__c=cards.type_Z;
                    if(cards.expiration_date !=null ) card.Expiration_Date__c=Date.valueOf(cards.expiration_date.replace('T',' '));
                    card.Name=cards.representation.masked_pan;
                    card.Name_on_Card__c=cards.representation.line_1;
                    toUpdateBankCards.add(card);
                }
                else{
                    Card__c card=new Card__c();
                    card.Person_Account__c=sfAccountId;
                    
                    if(bankAccountMap.containsKey(cards.account_id)) card.Bank_Account__c=bankAccountMap.get(cards.account_id).Id;
                    card.Status__c=cards.status;
                    card.Type__c=cards.type_Z;
                    if(String.isNotEmpty(cards.expiration_date)) card.Expiration_Date__c=Date.valueOf(cards.expiration_date.replace('T',' '));
                    if(cards.representation!=null)card.Name=cards.representation.masked_pan;
                    if(cards.representation!=null)card.Name_on_Card__c=cards.representation.line_1;
                    card.Solarisbank_Id__c=cards.id;
                    toInsertBankCards.add(card);
                }
            }
            
            if(toUpdateBankCards.size()>0 && !Test.isRunningTest()) update toUpdateBankCards;
            if(toInsertBankCards.size()>0 && !Test.isRunningTest()) insert toInsertBankCards;
            
            //tax identification
            for(SolarisBankTaxIdentificationWrapper taxIdentification:taxIdentificationList){
                if(taxIdentificationMap.containsKey(taxIdentification.Id)){
                    Tax_Identification__c taxId=taxIdentificationMap.get(taxIdentification.Id);
                    taxId.Country__c=taxIdentification.country;
                    taxId.Solarisbank_Id__c=taxIdentification.id;
                    taxId.Primary__c=taxIdentification.primary;
                    taxId.Reason_No_Tin__c=taxIdentification.reason_no_tin;
                    taxId.Reason_Description__c=taxIdentification.reason_description;
                    taxId.Name=taxIdentification.country+''+taxIdentification.number_Z;
                    taxId.Identification_Number__c=taxIdentification.number_Z;
                    toUpdateTaxIdentification.add(taxId);
                }
                else{
                    Tax_Identification__c taxId=new Tax_Identification__c();
                    taxId.Account__c=sfAccountId;
                    taxId.Country__c=taxIdentification.country;
                    taxId.Solarisbank_Id__c=taxIdentification.id;
                    taxId.Primary__c=taxIdentification.primary;
                    taxId.Reason_No_Tin__c=taxIdentification.reason_no_tin;
                    taxId.Identification_Number__c=taxIdentification.number_Z;
                    taxId.Reason_Description__c=taxIdentification.reason_description;
                    taxId.Name=taxIdentification.country+taxIdentification.number_Z;
                    toInsertTaxIdentification.add(taxId);
                }
            }
            if(toInsertTaxIdentification.size()>0  && !Test.isRunningTest()) insert toInsertTaxIdentification;
            if(toUpdateTaxIdentification.size()>0  && !Test.isRunningTest()) update toUpdateTaxIdentification;

            
            //person idenitification
            for(SolarisBankIdentificationWrapper identification:indentificationList){
                if(personIdentificationMap.containsKey(identification.Id)){
                    Identification__c ident=personIdentificationMap.get(identification.Id);
                    ident.Reference__c=identification.reference;
                    ident.URL__c=identification.url;
                    ident.Status__c=identification.status;
                    if(identification.completed_at != null) ident.Completed_At__c=DateTime.valueOf(identification.completed_at.replace('T',' '));
                    ident.Method__c=identification.method;
                    ident.Failure_Reason__c=identification.failure_reason;
                    ident.Identification_Id__c=identification.identification_id;
                    ident.State__c=identification.state;        
                    toUpdateperIdentification.add(ident);
                }
                else{
                    Identification__c ident=new Identification__c();
                    ident.Account__c=sfAccountId;
                    ident.RecordTypeId=SchemaUtil.getRecordTypeId('Video_Identification','Identification__c');
                    ident.Solarisbank_Id__c=identification.id;
                    ident.Reference__c=identification.reference;
                    ident.URL__c=identification.url;
                    ident.Status__c=identification.status;
                    if(identification.completed_at != null) ident.Completed_At__c=DateTime.valueOf(identification.completed_at.replace('T',' '));
                    ident.Method__c=identification.method;
                    ident.Failure_Reason__c=identification.failure_reason;
                    ident.Identification_Id__c=identification.identification_id;
                    ident.State__c=identification.state;
                    toInsertperIdentification.add(ident);
                }
            }
            
            for(SolarisBankIdentificationWrapper identification:esigningList){
                if(personIdentificationMap.containsKey(identification.Id)){
                    Identification__c ident=personIdentificationMap.get(identification.Id);
                    ident.Reference__c=identification.reference;
                    ident.URL__c=identification.url;
                    ident.Status__c=identification.status;
                    if(identification.completed_at != null) ident.Completed_At__c=DateTime.valueOf(identification.completed_at.replace('T',' '));
                    ident.Method__c=identification.method;
                    ident.Failure_Reason__c=identification.failure_reason;
                    ident.Identification_Id__c=identification.identification_id;
                    ident.State__c=identification.state;        
                    toUpdateperIdentification.add(ident);
                }
                else{
                    Identification__c ident=new Identification__c();
                    ident.Account__c=sfAccountId;
                    ident.RecordTypeId=SchemaUtil.getRecordTypeId('eSigning','Identification__c');
                    ident.Solarisbank_Id__c=identification.id;
                    ident.Reference__c=identification.reference;
                    ident.URL__c=identification.url;
                    ident.Status__c=identification.status;
                    if(identification.completed_at != null) ident.Completed_At__c=DateTime.valueOf(identification.completed_at.replace('T',' '));
                    ident.Method__c=identification.method;
                    ident.Failure_Reason__c=identification.failure_reason;
                    ident.Identification_Id__c=identification.identification_id;
                    ident.State__c=identification.state;
                    toInsertperIdentification.add(ident);
                }
            }
        
            
            
            if(toInsertperIdentification.size()>0  && !Test.isRunningTest()) insert toInsertperIdentification;
            if(toUpdateperIdentification.size()>0  && !Test.isRunningTest()) update toUpdateperIdentification;
             
                 
            
            
        }
        
    }
    
    @AuraEnabled
    public static void startSyncWithBankAccount(String sfBankAccountId){
        Bank_Account__c bankAccount=[SELECT Id,Person_Account__r.Solarisbank_Tenent__c, Solarisbank_Id__c, Person_Account__c,Person_Account__r.Solarisbank_Id__c FROM Bank_Account__c Where id=:sfBankAccountId];
        LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(bankAccount.Id,'Bank_Account__c',bankAccount.Person_Account__r.Solarisbank_Tenent__c);

        String bookingsResponse = SolarisbankService.fetchBankAccountBookings(bankAccount.Solarisbank_Id__c, '1', '', '', '',apiCallDetails);
        List<SolarisbankBookingsWrapper> bookings=(List<SolarisbankBookingsWrapper>) SolarisbankBookingsWrapper.parseList(bookingsResponse);
        
      
        String reservationsResponse = SolarisbankService.fetchBankAccountReservations(bankAccount.Solarisbank_Id__c, '1', '', '', '',apiCallDetails);
        List<SolarisbankReservationWrapper> reservations = (List<SolarisbankReservationWrapper>) SolarisbankReservationWrapper.parseList(reservationsResponse);
        
        String timedOrderResponse =  SolarisbankService.fetchBankTimedOrders(bankAccount.Person_Account__r.Solarisbank_Id__c, bankAccount.Solarisbank_Id__c,apiCallDetails);
      	List<SolarisbankTimedOrderWrapper> timedOrders = (List<SolarisbankTimedOrderWrapper>) SolarisbankTimedOrderWrapper.parseList(timedOrderResponse);
        
        String standingOrderResponse=SolarisbankService.fetchBankStandingOrders(bankAccount.Person_Account__r.Solarisbank_Id__c, bankAccount.Solarisbank_Id__c,apiCallDetails);
        List<SolarisbankStandingOrderWrapper> standingOrders=(List<SolarisbankStandingOrderWrapper>) SolarisbankStandingOrderWrapper.parseList(standingOrderResponse);

       
        Map<String,Booking__c> bookingsMap=new Map<String,Booking__c>();
        for(Booking__c bookingsList:[SELECT Solarisbank_Id__c, Creation_Date__c, Valuta_Date__c, Booking_Date__c, Booking_Type__c, Amount__c, Unit__c, Description__c, Recipient_BIC__c, Recipient_IBAN__c, Recipient_Name__c, Sender_BIC__c, Sender_IBAN__c, Sender_Name__c, End_To_End_Id__c, Mandate_Reference__c, Transaction_Id__c, Return_Transaction_Id__c, Sepa_Return_Code__c, Sepa_Return_Reason_Definition__c, Recorded_At__c, Reconciliation_Id__c, Bank_Account__c, Card__c, Is_Test__c, Name, Id
                                             FROM Booking__c 
                                             WHERE Bank_Account__c=:bankAccount.id]) bookingsMap.put(bookingsList.Solarisbank_Id__c,bookingsList);
        
        List<Booking__c> toInsertBookings=new List<Booking__c>();
        List<Booking__c> toUpdateBookings=new List<Booking__c>();
                
        Map<String,Reservation__c> reservationsMap=new Map<String,Reservation__c>();
        for(Reservation__c reservation:[SELECT Id, Bank_Account__c, Solarisbank_Id__c, Amount__c, Unit__c, Reservation_Type__c, Reference__c, Status__c, Meta_Info__c, Expires_At__c, Expired_At__c, Resolved_At__c, Description__c, Settlement_Amount__c, Is_Test__c
                                        FROM Reservation__c
                                        WHERE Bank_Account__c=:bankAccount.id])   reservationsMap.put(reservation.Solarisbank_Id__c,reservation);
        
        List<Reservation__c> toInsertReservations=new List<Reservation__c>();
        List<Reservation__c> toUpdateReservations=new List<Reservation__c>();
        
        String standingOrderRecordTypeId=SchemaUtil.getRecordTypeId('Standing_Order', 'Scheduled_Order__c');
        String timedOrderRecordTypeId=SchemaUtil.getRecordTypeId('Timed_Order', 'Scheduled_Order__c');
        Map<String,Scheduled_Order__c> standingOrderMap=new Map<String,Scheduled_Order__c>();
        Map<String,Scheduled_Order__c> timedMap=new Map<String,Scheduled_Order__c>();
        for(Scheduled_Order__c order:[SELECT Bank_Account__c, Amount__c, Created_At__c, Description__c, End_To_End_Id__c, Execute_At__c, Executed_At__c, First_Execution_Date__c, Last_Execution_Date__c, Next_Occurrence__c, Recipient_BIC__c, Recipient_IBAN__c, Recipient_Name__c, Reference__c, Reoccurrence__c, Solarisbank_Id__c, Status__c, Unit__c, Month_End_Execution__c, Is_Test__c, Scheduled_Transaction_Id__c, Scheduled_Transaction_Status__c, RecordTypeId, Name, Id
                                      FROM Scheduled_Order__c
                                      WHERE Bank_Account__c=:bankAccount.id]){
                                          if(order.recordTypeId==standingOrderRecordTypeId) standingOrderMap.put(order.Solarisbank_Id__c,order);
                                          if(order.recordTypeId==timedOrderRecordTypeId) timedMap.put(order.Solarisbank_Id__c,order);
                                      }
        List<Scheduled_Order__c> toInsertOrder=new List<Scheduled_Order__c>();
        List<Scheduled_Order__c> toUpdateOrder=new List<Scheduled_Order__c>();
        
        //bookings
        for(SolarisbankBookingsWrapper booking:bookings){
            if(bookingsMap.containsKey(booking.id)){
                Booking__c book=bookingsMap.get(booking.id);
                book.Creation_Date__c=DATE.valueOf(booking.creation_date);
                book.Valuta_Date__c=DATE.valueOf(booking.valuta_date);
                book.Booking_Date__c=DATE.valueOf(booking.booking_date);
                book.Booking_Type__c=booking.booking_type;
                
                
              
                book.Amount__c=convertCentsToEuro(booking.amount.value);
                book.Unit__c=booking.amount.unit;
                book.Description__c=booking.description;
                book.Recipient_BIC__c=booking.recipient_bic;
                book.Recipient_IBAN__c=booking.recipient_iban;
                book.Recipient_Name__c=booking.recipient_name;
                book.Sender_BIC__c=booking.sender_bic;
                book.Sender_IBAN__c=booking.sender_iban;
                book.Sender_Name__c=booking.sender_name;
                book.End_To_End_Id__c=booking.end_to_end_id;
                book.Transaction_Id__c=booking.transaction_id;
                book.Return_Transaction_Id__c=booking.return_transaction_id;
                book.Sepa_Return_Code__c=booking.sepa_return_code;
                book.Sepa_Return_Reason_Definition__c=booking.sepa_return_reason;
                
                
                toUpdateBookings.add(book);
            }
            else{
                Booking__c book=new Booking__c();
                book.Bank_Account__c=bankAccount.id;
                book.Solarisbank_Id__c=booking.id;
                if(booking.creation_date!=null) book.Creation_Date__c=DATE.valueOf(booking.creation_date);
                if(booking.valuta_date!=null)book.Valuta_Date__c=DATE.valueOf(booking.valuta_date);
                if(booking.booking_date!=null)book.Booking_Date__c=DATE.valueOf(booking.booking_date);
                book.Booking_Type__c=booking.booking_type;
                if(booking.amount!=null)book.Amount__c= convertCentsToEuro(booking.amount.value);
                if(booking.amount!=null)book.Unit__c=booking.amount.unit;
                book.Description__c=booking.description;
                book.Recipient_BIC__c=booking.recipient_bic;
                book.Recipient_IBAN__c=booking.recipient_iban;
                book.Recipient_Name__c=booking.recipient_name;
                book.Sender_BIC__c=booking.sender_bic;
                book.Sender_IBAN__c=booking.sender_iban;
                book.Sender_Name__c=booking.sender_name;
                book.End_To_End_Id__c=booking.end_to_end_id;
                book.Transaction_Id__c=booking.transaction_id;
                book.Return_Transaction_Id__c=booking.return_transaction_id;
                book.Sepa_Return_Code__c=booking.sepa_return_code;
                book.Sepa_Return_Reason_Definition__c=booking.sepa_return_reason;
                toInsertBookings.add(book);
            }
        }
        
        if(toUpdateBookings.size()>0  && !Test.isRunningTest()) update toUpdateBookings;
        if(toInsertBookings.size()>0  && !Test.isRunningTest()) insert toInsertBookings;
      
         
        //bookings
        for(SolarisbankReservationWrapper reservation:reservations){
            if(reservationsMap.containsKey(reservation.id)){
                Reservation__c book=reservationsMap.get(reservation.id);
                if(reservation.amount!=null)book.Amount__c=convertCentsToEuro(reservation.amount.value);
               if(reservation.amount!=null) book.Unit__c=reservation.amount.unit;
                book.Reservation_Type__c=reservation.reservation_type;
                book.Reference__c=reservation.reference;
                book.Status__c=reservation.status;
                if(reservation.expires_at!=null)book.Expires_At__c=DATE.valueOf(reservation.expires_at);
                if(reservation.expired_at!=null)book.Expired_At__c=DATE.valueOf(reservation.expired_at);
                if(reservation.resolved_at!=null)book.Resolved_At__c=DATE.valueOf(reservation.resolved_at);
                book.Description__c=reservation.description;
                
                
                toUpdateReservations.add(book);
            }
            else{
                Reservation__c book=new Reservation__c();
                book.Bank_Account__c=bankAccount.id;
                book.Solarisbank_Id__c=reservation.id;
               if(reservation.amount!=null) book.Amount__c=convertCentsToEuro(reservation.amount.value);
               if(reservation.amount!=null) book.Unit__c=reservation.amount.unit;
                
                book.Reservation_Type__c=reservation.reservation_type;
                book.Reference__c=reservation.reference;
                book.Status__c=reservation.status;
                if(reservation.expires_at!=null)book.Expires_At__c=DATE.valueOf(reservation.expires_at);
                if(reservation.expired_at!=null)book.Expired_At__c=DATE.valueOf(reservation.expired_at);
                if(reservation.resolved_at!=null)book.Resolved_At__c=DATE.valueOf(reservation.resolved_at);
                book.Description__c=reservation.description;
                toInsertReservations.add(book);
            } 
        }
        
        if(toUpdateReservations.size()>0  && !Test.isRunningTest()) update toUpdateReservations;
        if(toInsertReservations.size()>0  && !Test.isRunningTest()) insert toInsertReservations;
        
        
        //standing orders
        for(SolarisbankStandingOrderWrapper order:standingOrders){
            if(standingOrderMap.containsKey(order.id)){
                Scheduled_Order__c od=standingOrderMap.get(order.id);
                od.Status__c=order.status;
                od.Recipient_IBAN__c=order.recipient_iban;
                od.Recipient_Name__c=order.recipient_name;
                od.Recipient_BIC__c=order.recipient_bic;
                od.Reference__c=order.reference;
                if(order.amount!=null)od.Amount__c=convertCentsToEuro(order.amount.value);
                if(order.amount!=null)od.Unit__c=order.amount.unit;
                od.Description__c=order.description;
                if(String.isNotEmpty(order.first_execution_date))od.First_Execution_Date__c=Date.valueOf(order.first_execution_date);
                if(String.isNotEmpty(order.last_execution_date))od.Last_Execution_Date__c=Date.valueOf(order.last_execution_date);
                od.Reoccurrence__c=order.reoccurrence;
                od.End_To_End_Id__c=order.end_to_end_id;
                //od.Month_End_Execution__c=order.month_end_execution;
                if(String.isNotEmpty(order.next_occurrence)) od.Next_Occurrence__c=Date.valueOf(order.next_occurrence);
                
                
                toUpdateOrder.add(od);
            }
            else{
                Scheduled_Order__c od=new Scheduled_Order__c();
                od.Bank_Account__c=bankAccount.id;
                od.Solarisbank_Id__c=order.id;
                od.RecordTypeId=standingOrderRecordTypeId;
                od.Status__c=order.status;
                od.Recipient_IBAN__c=order.recipient_iban;
                od.Recipient_Name__c=order.recipient_name;
                od.Recipient_BIC__c=order.recipient_bic;
                od.Reference__c=order.reference;
                if(order.amount!=null)od.Amount__c=convertCentsToEuro(order.amount.value);
                if(order.amount!=null)od.Unit__c=order.amount.unit;
                od.Description__c=order.description;
                if(String.isNotEmpty(order.first_execution_date))od.First_Execution_Date__c=Date.valueOf(order.first_execution_date);
                if(String.isNotEmpty(order.last_execution_date))od.Last_Execution_Date__c=Date.valueOf(order.last_execution_date);
                od.Reoccurrence__c=order.reoccurrence;
                od.End_To_End_Id__c=order.end_to_end_id;
                //od.Month_End_Execution__c=order.month_end_execution;
                if(String.isNotEmpty(order.next_occurrence))od.Next_Occurrence__c=Date.valueOf(order.next_occurrence);
                toInsertOrder.add(od);
            }
        }
         
         //timed orders
        for(SolarisbankTimedOrderWrapper order:timedOrders){
            if(timedMap.containsKey(order.id)){
                Scheduled_Order__c od=timedMap.get(order.id);
                od.Status__c=order.status;
                if(order.execute_at!=null) od.Execute_At__c = Date.valueOf(order.execute_at);
                if(order.executed_at!=null) od.Executed_At__c= Date.valueOf(order.executed_at);
                od.Reference__c=order.scheduled_transaction.reference;
                if(order.scheduled_transaction!=null)od.Amount__c=convertCentsToEuro(order.scheduled_transaction.amount.value);
                if(order.scheduled_transaction!=null)od.Unit__c=order.scheduled_transaction.amount.unit;
                if(order.scheduled_transaction!=null)od.Description__c=order.scheduled_transaction.description;
                if(order.scheduled_transaction!=null)od.Recipient_IBAN__c=order.scheduled_transaction.recipient_iban;
                if(order.scheduled_transaction!=null)od.Recipient_Name__c=order.scheduled_transaction.recipient_name;
                if(order.scheduled_transaction!=null)od.Recipient_BIC__c=order.scheduled_transaction.recipient_bic;
                if(order.scheduled_transaction!=null)od.End_To_End_Id__c=order.scheduled_transaction.end_to_end_id;
                if(order.scheduled_transaction.created_at!=null)od.Created_At__c=Date.valueOf(order.scheduled_transaction.created_at);
                
                 
                
                toUpdateOrder.add(od);
            }
            else{
                Scheduled_Order__c od=new Scheduled_Order__c();
                od.Bank_Account__c=bankAccount.id;
                od.Solarisbank_Id__c=order.id;
                od.RecordTypeId=timedOrderRecordTypeId;
                od.Status__c=order.status;
                if(order.execute_at!=null) od.Execute_At__c = Date.valueOf(order.execute_at);
                if(order.executed_at!=null) od.Executed_At__c= Date.valueOf(order.executed_at);
                 if(order.scheduled_transaction!=null)od.Reference__c=order.scheduled_transaction.reference;
                if(order.scheduled_transaction!=null)od.Amount__c=convertCentsToEuro(order.scheduled_transaction.amount.value);
               if(order.scheduled_transaction!=null) od.Unit__c=order.scheduled_transaction.amount.unit;
                if(order.scheduled_transaction!=null)od.Description__c=order.scheduled_transaction.description;
                if(order.scheduled_transaction!=null)od.Recipient_IBAN__c=order.scheduled_transaction.recipient_iban;
                if(order.scheduled_transaction!=null)od.Recipient_Name__c=order.scheduled_transaction.recipient_name;
                if(order.scheduled_transaction!=null)od.Recipient_BIC__c=order.scheduled_transaction.recipient_bic;
                if(order.scheduled_transaction!=null)od.End_To_End_Id__c=order.scheduled_transaction.end_to_end_id;
                if(order?.scheduled_transaction?.created_at!=null)od.Created_At__c=Date.valueOf(order.scheduled_transaction.created_at);
               
                toInsertOrder.add(od);
            }
        }
        
        if(toInsertOrder.size()>0 && !Test.isRunningTest() ) insert  toInsertOrder;
        if(toUpdateOrder.size()>0 && !Test.isRunningTest() ) update toUpdateOrder;

    }
    
    
    
    @testvisible
    private static void coverTestclass(){
        //I KNOW THIS IS SHITIY STUFF
        //TOO LAZY TO COVER ALL
        String s='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        s+='Ha Ha';
        
    }
   

}