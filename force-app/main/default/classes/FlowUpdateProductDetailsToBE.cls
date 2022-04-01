public class FlowUpdateProductDetailsToBE {
    
    @InvocableMethod(label='Update Product details to external service')
    public static void updatedProductDataToExternalSystem(List<Product2> products){
        Product2ExternalService.updatedProductDataToExternalSystem(products);
    }
}