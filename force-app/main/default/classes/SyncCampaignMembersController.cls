public with sharing class SyncCampaignMembersController {
    
    
    private static  List<String>  getObjectAvilabelFields(List<String> products,Map<String,DescribeFieldResult> objFieldMap){
        List<String> fieldList=new List<String>();
        Map<String,String> productFieldMap=Util.getProductMetaDataConfiguration();
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
        for(CampaignMember member:campaingMembersList){
            if(member.ContactId!=null) contactOrLeadMemberMap.put(member.ContactId,member);
            else if(member.LeadId!=null) contactOrLeadMemberMap.put(member.LeadId,member);
        }
        return contactOrLeadMemberMap;
    }
    @AuraEnabled
    public static void startSync(String campaignId){
        Campaign campaing=[SELECT Id, Products__c FROM Campaign WHERE id=:campaignId];
       
        List<String> products=(campaing.Products__c!=null)?campaing.Products__c.split(';'):new List<String>();
        Map<String,DescribeFieldResult> leadFieldMap=Util.getAllObjectFields('Lead');
        Map<String,DescribeFieldResult> contactFieldMap=Util.getAllObjectFields('Contact');
        
        List<String> contactProductFileds=getObjectAvilabelFields(products,contactFieldMap);
        List<String> leadProductFileds=getObjectAvilabelFields(products,leadFieldMap);
        Map<String,CampaignMember> contactOrLeadMemberMap=getCampaingMembersMap(campaignId);
        
        List<CampaignMember> toInsertCampaignMembers=new List<CampaignMember>();
        List<Contact> allContacts=new List<Contact>();
        List<Lead> allLeads=new List<Lead>();
        
        
     
        
        if(contactProductFileds.size()>0){
            String contactQuery='SELECT Id FROM Contact WHERE ';
            for(String apiName:contactProductFileds){
                contactQuery+=' '+apiName+'=\'Subscribed\' OR ';
            }
            contactQuery=contactQuery.removeEnd('OR '); 
            System.debug('contactQuery '+contactQuery);
            allContacts=Database.query(contactQuery);
            
            for(Contact c:allContacts){
                if(contactOrLeadMemberMap.containsKey(c.Id)){
                    contactOrLeadMemberMap.remove(c.Id);
                }
                else{
                    CampaignMember cm=new CampaignMember();
                    cm.ContactId=c.Id;
                    cm.CampaignId=campaignId;
                    cm.Status='Sent';
                    toInsertCampaignMembers.add(cm);
                }
            }
            
        }
        
        if(leadProductFileds.size()>0){
            String leadQuery='SELECT Id FROM Lead WHERE IsConverted=false AND ';
            for(String apiName:leadProductFileds){
                leadQuery+=' '+apiName+'=\'Subscribed\' OR ';
            }
            leadQuery=leadQuery.removeEnd('OR ');
            System.debug('leadQuery '+leadQuery);
            allLeads=Database.query(leadQuery);
            System.debug('allLeads '+allLeads);
            for(Lead l:allLeads){
                if(contactOrLeadMemberMap.containsKey(l.Id)){
                    contactOrLeadMemberMap.remove(l.Id);
                }
                else{
                    CampaignMember cm=new CampaignMember();
                    cm.LeadId=l.Id;
                    cm.CampaignId=campaignId;
                    cm.Status='Sent';
                    toInsertCampaignMembers.add(cm);
                }
            }
        }
        
        
        if(toInsertCampaignMembers.size()>0){
            insert toInsertCampaignMembers;
        }
        if(contactOrLeadMemberMap.values().size()>0){
            delete contactOrLeadMemberMap.values();
        }
        
        
        
        
        
        
        
    }

}