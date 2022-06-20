public class FlowSendCustomerClassificationStatusToBE {
    @InvocableMethod(label='Update Customer Classification System Status to external service')
    public static void updateProductDataToExternalSystem(List<Customer_Classification__c> ccList){
        for(Customer_Classification__c cc:ccList){
        	CustomerClassificationService.updateSystemStatusToExternalSystem(cc.id);    
        } 
    }
}