/***************
* @group Handler Class
* @description Customer Classification trigger router
*/
public inherited sharing class CustomerClassificationHandler extends TriggerHandler {
    
    protected override void beforeInsert(){
        List<Customer_Classification__c> classificationList=(List<Customer_Classification__c>) Trigger.new;
        
        
        CustomerClassificationHelper.setAccountNameValue(classificationList);
        
    }
    
    protected override void beforeUpdate() {
        List<Customer_Classification__c> classificationList=(List<Customer_Classification__c>) Trigger.new;
        Map<Id,Customer_Classification__c> oldclassificationMap=(Map<Id,Customer_Classification__c>) Trigger.oldMap;
        
        
        CustomerClassificationHelper.processSystemStatusValue(classificationList,oldclassificationMap);
        
        
    } 

}