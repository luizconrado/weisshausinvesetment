public class TestDataFactory {
    
    //standalone generators
    public static Change_Request_Log__c getChangeRequestLog(String recordId,Boolean doInsert){
        Change_Request_Log__c crp=new Change_Request_Log__c();
        crp.Record_Id__c=recordId;
        if(doInsert) insert crp;
        return crp;
        
    }
    
    public static Account getBusinessAccount(Boolean doInsert){	
        Account businessAccount=new Account();	
        businessAccount.Name=RandomUtil.randomString(8);	
        businessAccount.RecordTypeId=Constant.ACCOUNT_BUSINESS_ACCOUNT_RECORDTYPEID;	
        if(doInsert) insert businessAccount;	
        return businessAccount;	
    }  
    public static Contact getContact(Boolean doInsert){
        Contact c=new Contact();
        c.LastName=RandomUtil.randomString(6);
        if(doInsert) insert c;
        return c;
    }
    
    public static CampaignMember getLeadCampaignMember(String campaignId,String leadId,Boolean doInsert){
        CampaignMember cm=new CampaignMember();
        cm.LeadId=leadId;
        cm.CampaignId=campaignId;
        cm.Status='Sent';
        if(doInsert) insert cm;
        return cm;
        
    }
    public static CampaignMember getContactCampaignMember(String campaignId,String contactId,Boolean doInsert){
        CampaignMember cm=new CampaignMember();
        cm.ContactId=contactId;
        cm.CampaignId=campaignId;
        cm.Status='Sent';
        if(doInsert) insert cm;
        return cm;
        
    }
    public static Card__c getCard(String accountId,String bankId,Boolean doInsert){
        Card__c card=new Card__c();
        card.name='434971******2356';
        card.Name_On_Card__c='NAME1 NAME2 SURNAME';
        card.Person_Account__c=accountId;
        card.Bank_Account__c=bankId;
        card.Solarisbank_Id__c='testcardeaea2acad1bcf119a9c0cfc'+RandomUtil.randomString(3);
        
        if(doInsert) insert card;
        return card;
    }
    public static Reservation__c getReservation(String bankId,Boolean doInsert){
        Reservation__c res=new Reservation__c();
        res.Bank_Account__c=bankId;
        res.Solarisbank_Id__c='088434f167eaea2acad1bcf119a9c0cfc'+RandomUtil.randomString(3);
        if(doInsert) insert res;
        return res;
    }
    public static user getUser(String profileName){	
        Profile p = [SELECT Id FROM Profile WHERE Name=:profileName]; 	
        User u = new User(Alias = 'standt', Email=profileName+'@evsmertmoney.com', 	
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 	
                          LocaleSidKey='en_US', ProfileId = p.Id, 	
                          TimeZoneSidKey='America/Los_Angeles', UserName=profileName+'@evsmertmoney.com');	
        insert u;	
        return u;	
        
    }
     
    public static Bank__c getBankSolarisBank(String accountId,Boolean doInsert){
        return generateBank(accountId,Constant.BANK_SOLARISBANK_RECORDTYPEID,true);
    }
  
    public static Seizure__c getSeziure(String accountId,Boolean doInsert){
        Seizure__c sei=new Seizure__c();
        sei.Account__c=accountId;
        sei.Solarisbank_Id__c='0652225cebcd3bec2c95ea8c461fe146c'+RandomUtil.randomString(3);
        if(doInsert) insert Sei;
        return sei;
    }
    
    //record generate handlers
    public static Lead getWebLead(Boolean doInsert){
        return generateLead(Constant.DEFAULT_LEAD_RECORDTYPEID,doInsert);
    }
    public static Account getPersonAccount(Boolean doInsert){
        return generateAccount(Constant.PERSON_ACCOUNT_RECORDTYPEID, doInsert);
    }
    
    public static Opportunity getStandardOpportunity(String accountId,Boolean doInsert){
        return generateOpportunity(Constant.STANDARD_OPPORTUNITY_RECORDTYPEID,accountId,doInsert);
    }
    public static Opportunity getOpportunityFullSale(String accountId,Boolean doInsert){
        return generateOpportunity(Constant.OPPORTUNITY_RE_FULLSALE_RECORDTYPEID,accountId,doInsert);
    }
    public static Case getStandardCase(String accountId,Boolean doInsert){
        return generateCase(Constant.STANDARD_CASE_RECORDTYPEID, accountid, doInsert);
    }
    public static Case getBankCase(String accountId,Boolean doInsert){
        return generateCase(Constant.BANKINGCASE_CASE_RECORDTYPEID, accountid, doInsert);
    }
    public static Case getEVKontoCase(String accountId,Boolean doInsert){
        return generateCase(Constant.EVKONTOAPPCASE_CASE_RECORDTYPEID, accountid, doInsert);
    }
    public static Case getCaseInvestment(String accountId,Boolean doInsert){
        return generateCase(Constant.INVESTMENTCASE_CASE_RECORDTYPEID, accountid, doInsert);
    }
    public static Campaign getStandardCampaign(Boolean doInsert){
        return generateCampaing(Constant.STANDARD_CAMPAIGN_RECORDTYPEID,doInsert);
    }    
    public static Contentversion getContentVersion(Boolean doInsert){
        Contentversion cv=new Contentversion(Title = 'ABC',Type__c='Draft', PathOnClient = 'test', VersionData = EncodingUtil.base64Decode('Unit Test Attachment Body'));
        if(doInsert) insert cv;
        return  cv;
    }
    
    public static Bank_Account__c getBankAccount(String accountId,Boolean doInsert){
        return generateBankAccount(accountId,doInsert);
    }
    public static Bank_Case_Item__c getAccountBankCase(String caseId,Boolean doInsert){
        return generateBankCase(Constant.BANKCASE_ACCOUNT_RECORDTYPEID,caseId,doInsert);
    }
    public static Bank_Case_Item__c getCardBankCase(String caseId,Boolean doInsert){
        return generateBankCase(Constant.BANKCASE_CARD_RECORDTYPEID,caseId,doInsert);
    }
    public static Bank_Case_Item__c getBookingBankCase(String caseId,Boolean doInsert){
        return generateBankCase(Constant.BANKCASE_BOOKING_RECORDTYPEID,caseId,doInsert);
    }
    public static Bank_Case_Item__c getBankAccountBankCase(String caseId,Boolean doInsert){
        return generateBankCase(Constant.BANKCASE_BANKACCOUNT_RECORDTYPEID,caseId,doInsert);
    }
    public static Bank_Case_Item__c getTimedOrderBankCase(String caseId,Boolean doInsert){
        return generateBankCase(Constant.BANKCASE_TIMEDGORDER_RECORDTYPEID,caseId,doInsert);
    }
    
    
    
    
    
    public static Booking__c getBooking(String bankaccountId,Boolean doInsert){
        return generateBooking(bankaccountId,doInsert);
    }
    
    public static Scheduled_Order__c getTimedOrder(String bankaccountId,Boolean doInsert){
        return generateScheduledOrder(Constant.TIMED_SCHEDULEDORDER_RECORDTYPEID,bankaccountId,doInsert);
    }
    public static Scheduled_Order__c getStandingOrder(String bankaccountId,Boolean doInsert){
        
        return generateScheduledOrder(Constant.STANDING_SCHEDULEDORDER_RECORDTYPEID,bankaccountId,doInsert);
    }
     public static KYC_Detail__c getKYCVideoIdentification(String accountId,Boolean doInsert){
        return genrateKYC(accountId,Constant.KYC_VIDEO_IDENTIFICATION_RECORDTYPEID,doInsert);
    }
     
    public static Asset getAssetRealEstate(String accountId,String contactId,Boolean doInsert){
        return generateAsset(accountId,contactId,Constant.ASSET_REAL_ESTATE_RECORDTYPEID,doInsert);
    }
    
    public static Asset_Link__c getAssetLink(String assetId,Boolean doInsert){
        return generateAssetLink(assetId,Constant.ASSET_LINK_IMAGE_RECORDTYPEID,doInsert);
    }
    
    public static Evaluation__c getAssetEvaluation(String assetId,Boolean doInsert){
        return generateEvaluation(assetId,doInsert);
    }
    
    public static Knowledge__kav getKnowledgeFAQRecord(Boolean doInsert){
        return generateKnowledgeRecord(Constant.KNOWLEDGE_FAQ_RECORDTYPEID,doInsert);
    }
    public static Knowledge__kav getKnowledgeSBRecord(Boolean doInsert){
        return generateKnowledgeRecord(Constant.KNOWLEDGE_SOLARISBANK_RECORDTYPEID,doInsert);
    }
    
    public static Document__c getDocumentForAccount(String accountId,Boolean doInsert){
        return generateDocumentRecord(Constant.DOCUMENT_ACCOUNT_RECORDTYPEID, accountId, doInsert);
    } 
    
    public static Log__c getDebugLog(String recordId,Boolean doInsert){
        return generateLog(recordId,Constant.DEBUG_LOG_RECORDTYPEID, doInsert);
    }
    public static Log__c getIntegerationLog(String recordId,Boolean doInsert){
        return generateLog(recordId,Constant.INITEGERATION_LOG_RECORDTYPEID, doInsert);
    }
    public static Subscription__c getNewsletterSubscription(String accountId,String contactId,Boolean doInsert){
        return generateSubscription(accountId,contactId,'Newsletter',Constant.SUBSCRIPTION_DEFAULT_RECORDTYPEID,doInsert);
    }
    public static History_Tracker__c getChangeHistoryLog(String recordId,Boolean doInsert){
        return generateHistoryLog(recordId,Constant.TRACK_FIELD_CHANGE_RECORDTYPE_ID, doInsert);
    } 
    public static History_Tracker__c getViewHistoryLog(String recordId,Boolean doInsert){
        return generateHistoryLog(recordId,Constant.TRACK_USAGE_HISTORY_RECORDTYPE_ID, doInsert);
    } 
    /*
Generators
*/
    
    private static Booking__c generateBooking(String bankaccountId,Boolean doInsert){
        Booking__c book=new Booking__c();
        book.Bank_Account__c=bankaccountId;
        book.Solarisbank_Id__c='088434f167eaea2acad1bcf119a9c0cfc'+RandomUtil.randomString(3);
        book.Transaction_Id__c='088434f167eaea2acad1bcf119a9c0cfc'+RandomUtil.randomString(3);
        if(doInsert) insert book;
        return book;
    }
    
    private static Scheduled_Order__c generateScheduledOrder(String recordTypeId,String bankaccountId,Boolean doInsert){
        Scheduled_Order__c order=new Scheduled_Order__c();
        order.recordTypeId=recordTypeId;
        order.Bank_Account__c=bankaccountId;
        order.Solarisbank_Id__c='088434f167eaea2acad1bcf119a9c0cfc'+RandomUtil.randomString(3);
        if(doInsert) insert order;
        return order;
    }
    
    private static Bank_Case_Item__c generateBankCase(String recordTypeId,String caseId,Boolean doInsert){
        Bank_Case_Item__c bc=new Bank_Case_Item__c();
        bc.RecordTypeId=recordTypeId;
        bc.Case__c=caseId;
        if(doInsert) insert bc;
        return bc;
    }
    
    private static Bank_Account__c generateBankAccount(Final String accountId,Boolean doInsert){
        Bank_Account__c ba=new Bank_Account__c();
        ba.Person_Account__c = accountId;
        ba.Name='DE98110101002528376528';
        ba.BIC__c='SOBKDEBBXXX';
        ba.Status__c='Active';
        ba.Solarisbank_Id__c='0652225cebcd3bec2c95ea8c461fe146c'+RandomUtil.randomString(3);
        if(doInsert ) insert ba;
        return ba;
    }
    
    private static Campaign generateCampaing(String recordTypeId,Boolean doInsert){
        Campaign c=new Campaign();
        c.Name=RandomUtil.randomString(3);
        c.Product__c='Newsletter';
        c.RecordTypeId=recordTypeId;
        if(doInsert) insert c;
        return c;
        
    }
    
    
    
    
    private static Lead generateLead(String recordtypeid,Boolean doInsert){
        
        
        Lead lead = new Lead();
        
        lead.Email = RandomUtil.randomString(3)+'@'+RandomUtil.randomString(4)+'.com';
        
        lead.State = 'New';
        lead.LastName = RandomUtil.randomString(4);
        lead.LeadSource = 'Website';
        lead.RecordTypeId = recordtypeid;
        lead.Website = 'www.'+RandomUtil.randomString(6)+'.com';
        if(doInsert) insert lead;
        return lead;
        
    }
    
    private static Account generateAccount(String recordtypeid,Boolean doInsert){
        
        Account account = new Account();
        account.PersonEmail= RandomUtil.randomString(3)+'@'+RandomUtil.randomString(4)+'.com';
        account.Auth0_ID__c='auth0|'+RandomUtil.randomString(6);
        account.LastName = RandomUtil.randomString(4);
        account.RecordTypeId = recordtypeid;
        account.Solarisbank_Id__c='0652225cebcd3bec2c95ea8c461fe'+RandomUtil.randomString(6);
        account.Solarisbank_Tenent__c='Mobile'; 
        if(doInsert) insert account;
        return account;
    }
    
    
    
    private static Opportunity generateOpportunity(Final String recordTypeId,Final String accountId,Final Boolean doInsert){
        Opportunity opp=new Opportunity();
        opp.Name=RandomUtil.randomString(4);
        opp.AccountId=accountId;
        opp.StageName='Qualifying';
        opp.CloseDate=Date.today()+10;
        opp.RecordTypeId=recordTypeId;
        if(doInsert) insert opp;
        return opp;
    }
    
    private static Case generateCase(String recordTypeId,String accountid,Boolean doInsert){
        Case c=new Case();
        c.RecordTypeId=recordTypeId;
        c.Status='New';
        c.Origin='Web';
        c.AccountId=accountid;
        if(doInsert) insert c;
        return c;
    }
    
    
    
    private static Subscription__c generateSubscription(String accountId,String contactId,String subType,String recordTypeId,Boolean doInsert){
        Subscription__c newSubscriptionProduct=new Subscription__c();
        newSubscriptionProduct.Subscription_Status__c='Subscribed';
        newSubscriptionProduct.Type__c=subType;//'';
        newSubscriptionProduct.Account__c=accountId;
        
        newSubscriptionProduct.Send_Mail__c=false;
        newSubscriptionProduct.recordTypeId=recordTypeId;
        newSubscriptionProduct.Contact__c=contactId;
        if(doinsert) insert newSubscriptionProduct;
        return newSubscriptionProduct;
    }
    
    private static KYC_Detail__c genrateKYC(String accountId,String recordTypeId,Boolean doInsert){
        KYC_Detail__c newIdentification=new KYC_Detail__c();
        newIdentification.Solarisbank_Id__c='testcardeaea2acad1bcf119a9c0cfc'+RandomUtil.randomString(3);      
        newIdentification.Account__c=accountId;
        newIdentification.RecordTypeId=recordTypeId;
        if(doInsert) insert newIdentification; 
        return newIdentification;
    }
     
    private static Asset generateAsset(String accountId,String contactId,String recordTypeId,Boolean doInsert){
        Asset assetObject=new Asset();
        assetObject.Name=RandomUtil.randomString(6);
        assetObject.Is_Deleted_By_Customer__c=false;
        assetObject.Asset_Id__c=RandomUtil.randomString(8);
        assetObject.contactId=contactId;
        assetObject.AccountId=accountId;
        assetObject.RecordTypeId=recordTypeId;
        if(doInsert) insert assetObject;
        return assetObject;
    }
    
    private static Asset_Link__c generateAssetLink(String assetId,String recordTypeId,Boolean doInsert){
        Asset_Link__c link=new Asset_Link__c();
        link.Asset__c=assetId;
        link.Image_Url__c='www.ev-smartmoney.com';
        link.RecordTypeId=recordTypeId;
        if(doInsert) insert link;
        return link;
    }
    
    private static Evaluation__c generateEvaluation(string assetId,Boolean doInsert){
        Evaluation__c eval=new Evaluation__c();
        eval.Asset__c=assetId;
        eval.Date__c=Date.today();
        eval.Value__c=RandomUtil.randomNumber(100000);
        if(doInsert) insert eval;
        return eval;
    }
    
    
    private static Knowledge__kav generateKnowledgeRecord(String recordTypeId,Boolean doInsert){	
        Knowledge__kav km=new Knowledge__kav();	
        km.Title= RandomUtil.randomString(60);	
        km.RecordTypeId=recordTypeId;	
        km.Summary=RandomUtil.randomString(60);	
        km.Information__c=RandomUtil.randomString(60);	
        if(doInsert) insert km;	
        return km;	
    }
    
    private static Document__c generateDocumentRecord(String docRecordTypeId,String accountId,Boolean doInsert){
        Document__c doc=new Document__c();
        doc.RecordTypeId=docRecordTypeId;
        doc.Account__c=accountId;
        doc.Status__c='Created';
        doc.Name=RandomUtil.randomString(6);
        doc.Ticket_Number__c=RandomUtil.randomString(6);
        doc.Template_Id__c=RandomUtil.randomString(6);
        doc.Version__c=String.valueOf(RandomUtil.randomNumber(10));
        doc.Document_Created_At__c=DateTime.now();
        if(doInsert) insert doc;
        return doc;
    }
    
    private static Log__c generateLog(String recordId,String recordTypeId,Boolean doInsert){
        Log__c l=new Log__c();
        l.User__c=userinfo.getUserId();
        l.Log_Number__c=RandomUtil.randomUUID();
        l.Record_Id__c=recordId;
        if(doInsert) insert l;
        return l;
    }    
    
    private static History_Tracker__c generateHistoryLog(String recordId,String recordTypeId,Boolean doInsert){
        History_Tracker__c ht=new History_Tracker__c();
        ht.User__c=userinfo.getUserId();
        ht.Record_Id__c=recordId;
        if(doInsert) insert ht;
        return ht;
    }
    private static Bank__c generateBank(String accountId,String recordTypeId,Boolean doInsert){
        Bank__c sb=new Bank__c();
        sb.Account__c=accountId;
        sb.RecordTypeId=recordTypeId;
        sb.Solarisbank_Id__c='testcardeaea2acad1bcf119a9c0cfc'+RandomUtil.randomString(3);
        if(doInsert) insert sb;
        return sb;
    }
    
    
    //Rest helper	
    public static RestRequest setRestRequest(String endpoint,String method){	
        RestRequest req = new RestRequest(); 	
        req.requestURI = endpoint; 	
        req.httpMethod = method;	
        req.addHeader('Content-Type', 'application/json');	
        return req;	
    }
    
}