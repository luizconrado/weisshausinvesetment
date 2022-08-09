public inherited sharing class KYCDetailTriggerHandler extends TriggerHandler {
    
    protected override void beforeInsert(){
        List<KYC_Detail__c> kycRecordList=(List<KYC_Detail__c>) Trigger.new;
        
        
        setAccountNameValue(kycRecordList);
        
    }
    
    
    /***************
    * @description sets account name in custom field - used in slack alert, formula fields where not working and cannot do it in flows/as they are processed after trigger
    * @param kycRecordList cc list
    */
    private static void setAccountNameValue(List<KYC_Detail__c> kycRecordList){
        List<String> accountIds=new List<String>();
        for(KYC_Detail__c kycRecord:kycRecordList){
            if(kycRecord.Account__c!=null) accountIds.add(kycRecord.Account__c);
        }
        
        Map<String,String> accountIdAndNameMap=new Map<String,String>();
        for(Account acc:[SELECT Id,Name FROM Account WHERE Id IN:accountIds]){
            accountIdAndNameMap.put(acc.Id,acc.Name);
        }
        
        for(KYC_Detail__c kycRecord:kycRecordList){
            if(accountIdAndNameMap.containsKey(kycRecord.Account__c)) kycRecord.Account_Name__c=accountIdAndNameMap.get(kycRecord.Account__c);
        }
        
    }

}