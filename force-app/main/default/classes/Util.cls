public inherited sharing class Util {
    
    public static Map<String, String> getProductMetaDataConfiguration() {
        Map<String, String> productCodeAPIMap = new Map<String, String>();
        List<Subscription_Product_Configuration__mdt> productConfigList = [SELECT Id, Label, Field_API__c FROM Subscription_Product_Configuration__mdt];
        for (Subscription_Product_Configuration__mdt productConfigRec : productConfigList) {
            productCodeAPIMap.put(productConfigRec.Label, productConfigRec.Field_API__c);
        }
        return productCodeAPIMap;
    }
}