/***************
* @group Controller Class
* @description contorler class for button on campaing to sync all account with same subscription as campaign
*/
public with sharing class SyncCampaignMembersController {
    
    
    
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
        Map<String,CampaignMember> contactOrLeadMemberMap=getCampaingMembersMap(campaignId);
        List<String> products=(campaing.Product__c!=null)?campaing.Product__c.split(';'):new List<String>();
        
        List<CampaignMember> toInsertCampaignMembers=new List<CampaignMember>();
        
        List<Subscription__c> subscriptions=[Select id,Contact__c from Subscription__c WHERE Type__c IN:products AND Subscription_Status__c='Subscribed'];
        for(Subscription__c sub:subscriptions){
            //remove from campaing member if already member
            if(contactOrLeadMemberMap.containsKey(sub.Contact__c))  contactOrLeadMemberMap.remove(sub.Contact__c);
            else{
                //insert as new member    
                CampaignMember cm=new CampaignMember();
                cm.ContactId=sub.Contact__c;
                cm.CampaignId=campaignId;
                cm.Status='Sent';
                toInsertCampaignMembers.add(cm);
            }
        }
        
        if(toInsertCampaignMembers.size()>0)  insert toInsertCampaignMembers;
        if(contactOrLeadMemberMap.values().size()>0) delete contactOrLeadMemberMap.values();
        
       
    }

}