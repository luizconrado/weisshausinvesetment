public inherited sharing class CustomerClassificationHandler extends TriggerHandler {
    protected override void beforeUpdate() {
        List<Customer_Classification__c> classificationList=(List<Customer_Classification__c>) Trigger.new;
        Map<Id,Customer_Classification__c> oldclassificationMap=(Map<Id,Customer_Classification__c>) Trigger.oldMap;
        
        
        CustomerClassificationHelper.processSystemStatusValue(classificationList,oldclassificationMap);
        
        
    } 

}