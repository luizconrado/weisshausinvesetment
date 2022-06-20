/***************
* @group Flow Invocable Class
* @description used in flow Product2_Insert_Send_data_to_external_system
*/
public class FlowSendProductDetailsToBE {
    @InvocableMethod(label='Send Product details to external service')
    public static void sendProductDataToExternalSystem(List<Product2> products){
        Product2Service.sendProductDataToExternalSystem(products);
        
    }
   
}