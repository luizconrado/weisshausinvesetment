public class FlowSendProductDetailsToBE {
    @InvocableMethod(label='Send Product details to external service')
    public static void sendProductDataToExternalSystem(List<Product2> products){
        Product2Service.sendProductDataToExternalSystem(products);
        
    }
   
}