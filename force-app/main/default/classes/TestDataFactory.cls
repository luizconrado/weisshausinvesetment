public class TestDataFactory {
    
    public static Lead getWebLead(Boolean doInsert){
        return getLead(Util.getRecordTypeId('WebLeads', 'Lead'),doInsert);
    }
    
    private static Lead getLead(String recordtypeid,Boolean doInsert){
       
        
        Lead lead = new Lead();
        
        lead.Email = Util.randomString(3)+'@'+Util.randomString(4)+'.com';
        lead.ProductInterest__c = 'Newsletter';
        lead.State = 'New';
        lead.LastName = Util.randomString(4);
        lead.LeadSource = 'Website';
        lead.RecordTypeId = recordtypeid;
        lead.Website = 'www.'+Util.randomString(6)+'.com';
        if(doInsert) insert lead;
        return lead;
        
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
    public static Campaign getCampaing(Boolean doInsert){
        Campaign c=new Campaign();
        c.Name=Util.randomString(3);
        c.Products__c='Newsletter';
        if(doInsert) insert c;
        return c;
        
    }
    
    public static Contact getContact(Boolean doInsert){
        Contact c=new Contact();
        c.LastName=Util.randomString(6);
        c.Newsletter__c='Subscribed';
        if(doInsert) insert c;
        return c;
    }

}