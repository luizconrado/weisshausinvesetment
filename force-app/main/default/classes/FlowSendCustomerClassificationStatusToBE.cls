/***************
* @group Flow Invocable Class
* @description used in flow Customer_Qualification_Insert_Send_Notification_to_group
*/
public class FlowSendCustomerClassificationStatusToBE {
    @InvocableMethod(label='Update Customer Classification System Status to external service')
    public static void updateProductDataToExternalSystem(List<Customer_Classification__c> ccList){
        for(Customer_Classification__c cc:ccList){
        	CustomerClassificationService.updateSystemStatusToExternalSystem(cc.id);    
        } 
    }
}