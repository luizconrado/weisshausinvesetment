public with sharing class SyncCampaignMembersController {
    
    
    private static  List<String>  getObjectAvailableFields(List<String> products,Map<String,DescribeFieldResult> objFieldMap){
        List<String> fieldList=new List<String>();
        Map<String,String> productFieldMap=Util.getProductMetaDataConfiguration();
    	//maps api field name of product if it exsistins in object
        for(String prodName:products){
            if(productFieldMap.containsKey(prodName)){
                String apiName=productFieldMap.get(prodName); 
                if(objFieldMap.containsKey(apiName)) fieldList.add(apiName);
            }
        }
        return fieldList;
    }
    private static Map<String,CampaignMember> getCampaingMembersMap(String campaignId){
        List<CampaignMember> campaingMembersList=[SELECT Id,LeadOrContactOwnerId , CampaignId, ContactId,LeadId  FROM CampaignMember WHERE CampaignId =:campaignId];
        Map<String,CampaignMember> contactOrLeadMemberMap=new Map<String,CampaignMember>();
        //get campaing memebrs and returns map of contact/leadid
        for(CampaignMember member:campaingMembersList){
            if(member.ContactId!=null) contactOrLeadMemberMap.put(member.ContactId,member);
            else if(member.LeadId!=null) contactOrLeadMemberMap.put(member.LeadId,member);
        }
        return contactOrLeadMemberMap;
    }
    @AuraEnabled
    public static void startSync(String campaignId){
        Campaign campaing=[SELECT Id, Product__c FROM Campaign WHERE id=:campaignId];
       
       
        List<String> products=(campaing.Product__c!=null)?campaing.Product__c.split(';'):new List<String>();
       	//get all fields of object
        Map<String,DescribeFieldResult> leadFieldMap=SchemaUtil.getAllObjectFields('Lead');
        Map<String,DescribeFieldResult> contactFieldMap=SchemaUtil.getAllObjectFields('Contact');
        
        //get field and comaping members
        List<String> contactProductFileds=getObjectAvailableFields(products,contactFieldMap);
        List<String> leadProductFileds=getObjectAvailableFields(products,leadFieldMap);
        Map<String,CampaignMember> contactOrLeadMemberMap=getCampaingMembersMap(campaignId);
        
        List<CampaignMember> toInsertCampaignMembers=new List<CampaignMember>();
        List<Contact> allContacts=new List<Contact>();
        List<Lead> allLeads=new List<Lead>();
        
        
     
        //process all contacts for subscribed product
        if(contactProductFileds.size()>0){
            String contactQuery='SELECT Id FROM Contact WHERE ';
            for(String apiName:contactProductFileds){
                contactQuery+=' '+apiName+'=\'Subscribed\' OR ';
            }
            contactQuery=contactQuery.removeEnd('OR '); 
            allContacts=Database.query(contactQuery);
            
            for(Contact c:allContacts){
                //remove from campaing member if already member
                if(contactOrLeadMemberMap.containsKey(c.Id))  contactOrLeadMemberMap.remove(c.Id);
                else{
                    //insert as new member    
                    CampaignMember cm=new CampaignMember();
                    cm.ContactId=c.Id;
                    cm.CampaignId=campaignId;
                    cm.Status='Sent';
                    toInsertCampaignMembers.add(cm);
                }
            }
            
        }
        //process all leads for subscribed product
        if(leadProductFileds.size()>0){
            String leadQuery='SELECT Id FROM Lead WHERE IsConverted=false AND ';
            for(String apiName:leadProductFileds){
                leadQuery+=' '+apiName+'=\'Subscribed\' OR ';
            }
            leadQuery=leadQuery.removeEnd('OR ');
            allLeads=Database.query(leadQuery);
            for(Lead l:allLeads){
                //remove from campaing member if already member
                if(contactOrLeadMemberMap.containsKey(l.Id)) contactOrLeadMemberMap.remove(l.Id);
                else{
                //insert as new member    
                    CampaignMember cm=new CampaignMember();
                    cm.LeadId=l.Id;
                    cm.CampaignId=campaignId;
                    cm.Status='Sent';
                    toInsertCampaignMembers.add(cm);
                }
            }
        }
        
        
        if(toInsertCampaignMembers.size()>0)  insert toInsertCampaignMembers;
        if(contactOrLeadMemberMap.values().size()>0) delete contactOrLeadMemberMap.values();
    }

}