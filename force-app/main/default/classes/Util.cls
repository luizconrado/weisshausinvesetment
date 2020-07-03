public inherited sharing class Util {
    
    public static Map<String, String> getProductMetaDataConfiguration() {
        Map<String, String> productCodeAPIMap = new Map<String, String>();
        List<Subscription_Product_Configuration__mdt> productConfigList = [SELECT Id, Label, Field_API__c FROM Subscription_Product_Configuration__mdt];
        for (Subscription_Product_Configuration__mdt productConfigRec : productConfigList) {
            productCodeAPIMap.put(productConfigRec.Label, productConfigRec.Field_API__c);
        }
        return productCodeAPIMap;
    }
    
    public static Boolean checkEmailPermission(String templateId){
       	Boolean pass=true;
        Email_Configuration__c config = Email_Configuration__c.getOrgDefaults();
        if(templateId==Constant.LEAD_VERIFY_EMAIL_TEMPLATE || templateId==Constant.ACCOUNT_VERIFY_EMAIL_TEMPLATE){
            pass = config.Send_Verification_Email__c;
        }
        else if(templateId==Constant.LEAD_SUBSCRIBED_EMAIL_TEMPLATE || templateId==Constant.ACCOUNT_SUBSCRIBED_EMAIL_TEMPLATE){
            pass = config.Send_Subscribed_Email__c;
        }
        else if(templateId==Constant.LEAD_UNSUBSCRIBE_EMAIL_TEMPLATE || templateId==Constant.ACCOUNT_UNSUBSCRIBE_EMAIL_TEMPLATE){
            pass = config.Send_Unsubscribed_Email__c;
        }
        return pass;
    }
}