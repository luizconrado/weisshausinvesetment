public class TestDataFactory {
     
    public static Lead getWebLead(Boolean doInsert){
        return generateLead(Constant.DEFAULT_LEAD_RECORDTYPEID,doInsert);
    }
    public static Account getPersonAccount(Boolean doInsert){
        return generateAccount(Constant.PERSON_ACCOUNT_RECORDTYPEID, doInsert);
    }
  
    public static Opportunity getStandardOpportunity(String accountId,Boolean doInsert){
        return generateOpportunity(Constant.STANDARD_OPPORTUNITY_RECORDTYPEID,accountId,doInsert);
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
    public static Campaign getStandardCampaign(Boolean doInsert){
        return generateCampaing(Constant.STANDARD_CAMPAIGN_RECORDTYPEID,doInsert);
    }    
    public static Contentversion getContentVersion(Boolean doInsert){
        Contentversion cv=new Contentversion(Title = 'ABC',Type__c='Draft', PathOnClient = 'test', VersionData = EncodingUtil.base64Decode('Unit Test Attachment Body'));
        if(doInsert) insert cv;
        return  cv;
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

    
    
    public static Card__c getCard(String accountId,String bankId,Boolean doInsert){
        Card__c card=new Card__c();
        card.name='434971******2356';
        card.Name_On_Card__c='NAME1 NAME2 SURNAME';
        card.Person_Account__c=accountId;
        card.Bank_Account__c=bankId;
        card.Solarisbank_Id__c='testcardeaea2acad1bcf119a9c0cfcboo';

        if(doInsert) insert card;
        return card;
    }
    public static Reservation__c getReservation(String bankId,Boolean doInsert){
        Reservation__c res=new Reservation__c();
        res.Bank_Account__c=bankId;
        res.Solarisbank_Id__c='088434f167eaea2acad1bcf119a9c0cfcboo';
        if(doInsert) insert res;
        return res;
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
    
    public static Identification__c getVideoIdentification(String accountId,Boolean doInsert){
        return genrateIdentification(accountId,Constant.IDENTIFIACTION_VIDEO_IDENTIFICATION_RECORDTYPEID,doInsert);
    }
    
    /*
    Generators
	*/
    
    private static Booking__c generateBooking(String bankaccountId,Boolean doInsert){
        Booking__c book=new Booking__c();
        book.Bank_Account__c=bankaccountId;
        book.Solarisbank_Id__c='088434f167eaea2acad1bcf119a9c0cfcboo';
        book.Transaction_Id__c='088434f167eaea2acad1bcf119a9c0cfcboo';
        if(doInsert) insert book;
        return book;
    }
    
    private static Scheduled_Order__c generateScheduledOrder(String recordTypeId,String bankaccountId,Boolean doInsert){
        Scheduled_Order__c order=new Scheduled_Order__c();
        order.recordTypeId=recordTypeId;
        order.Bank_Account__c=bankaccountId;
        order.Solarisbank_Id__c='088434f167eaea2acad1bcf119a9c0cfcboo';
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
        ba.Solarisbank_Id__c='0652225cebcd3bec2c95ea8c461fe146cacc';
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
        
        account.LastName = RandomUtil.randomString(4);
        account.RecordTypeId = recordtypeid;
        account.Solarisbank_Id__c='0652225cebcd3bec2c95ea8c461fe146cacc';
        account.Solarisbank_Tenent__c='Sandbox'; 
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
    
    public static Subscription__c getNewsletterSubscription(String accountId,String contactId,Boolean doInsert){
        return generateSubscription(accountId,contactId,'Newsletter',Constant.SUBSCRIPTION_DEFAULT_RECORDTYPEID,doInsert);
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
    
    private static Identification__c genrateIdentification(String accountId,String recordTypeId,Boolean doInsert){
        Identification__c newIdentification=new Identification__c();
        newIdentification.Solarisbank_Id__c='testcardeaea2acad1bcf119a9c0cfcboo';      
        newIdentification.Account__c=accountId;
        newIdentification.RecordTypeId=recordTypeId;
        if(doInsert) insert newIdentification; 
        return newIdentification;
    }

}