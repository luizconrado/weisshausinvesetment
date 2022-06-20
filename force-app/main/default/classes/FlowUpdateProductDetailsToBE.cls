/***************
* @group Flow Invocable Class
* @description used in flow Product2_Update_Send_data_to_external_system
*/
public class FlowUpdateProductDetailsToBE {
    
    @InvocableMethod(label='Update Product details to external service')
    public static void updatedProductDataToExternalSystem(List<Product2> products){
        Product2Service.updatedProductDataToExternalSystem(products);
    }
}