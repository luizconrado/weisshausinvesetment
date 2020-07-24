public class TestDataFactory {
      
    public static Lead getWebLead(Boolean doInsert){
        return getLead(SchemaUtil.getRecordTypeId('WebLeads', 'Lead'),doInsert);
    }
    public static Account getPersonAccount(Boolean doInsert){
        return getAccount(Constant.PERSON_ACCOUNT_RECORDTYPEID, doInsert);
    }
    public static Opportunity getStandardOpportunity(String accountId,Boolean doInsert){
        return getOpportunity(Constant.STANDARD_OPPORTUNITY_RECORDTYPEID,accountId,doInsert);
    }
    public static Case getStandardCase(String accountId,Boolean doInsert){
        return getCase(Constant.STANDARD_CASE_RECORDTYPEID, accountid, doInsert);
    }
    public static Campaign getStandardCampaign(Boolean doInsert){
        return getCampaing(Constant.STANDARD_CAMPAIGN_RECORDTYPEID,doInsert);
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
        
    private static Campaign getCampaing(String recordTypeId,Boolean doInsert){
        Campaign c=new Campaign();
        c.Name=RandomUtil.randomString(3);
        c.Product__c='Newsletter';
        c.RecordTypeId=recordTypeId;
        if(doInsert) insert c;
        return c;
        
    }
    
    
    
    
    private static Lead getLead(String recordtypeid,Boolean doInsert){
       
        
        Lead lead = new Lead();
        
        lead.Email = RandomUtil.randomString(3)+'@'+RandomUtil.randomString(4)+'.com';
        lead.ProductInterest__c = 'Newsletter';
        lead.State = 'New';
        lead.LastName = RandomUtil.randomString(4);
        lead.LeadSource = 'Website';
        lead.RecordTypeId = recordtypeid;
        lead.Website = 'www.'+RandomUtil.randomString(6)+'.com';
        if(doInsert) insert lead;
        return lead;
        
    }
    
    private static Account getAccount(String recordtypeid,Boolean doInsert){
        
        Account account = new Account();
        account.PersonEmail= RandomUtil.randomString(3)+'@'+RandomUtil.randomString(4)+'.com';
        account.ProductInterest__pc = 'Newsletter';
        account.LastName = RandomUtil.randomString(4);
        account.RecordTypeId = recordtypeid;
        if(doInsert) insert account;
        return account;
    }
    
    public static Contact getContact(Boolean doInsert){
        Contact c=new Contact();
        c.LastName=RandomUtil.randomString(6);
        c.Newsletter__c='Subscribed';
        if(doInsert) insert c;
        return c;
    }
    
    private static Opportunity getOpportunity(Final String recordTypeId,Final String accountId,Final Boolean doInsert){
        Opportunity opp=new Opportunity();
        opp.Name=RandomUtil.randomString(4);
        opp.AccountId=accountId;
        opp.StageName='Qualifying';
        opp.CloseDate=Date.today()+10;
        opp.RecordTypeId=recordTypeId;
        if(doInsert) insert opp;
        return opp;
    }
    
    private static Case getCase(String recordTypeId,String accountid,Boolean doInsert){
        Case c=new Case();
        c.RecordTypeId=recordTypeId;
        c.Status='New';
        c.Origin='Web';
		c.AccountId=accountid;
        if(doInsert) insert c;
        return c;
    }


}