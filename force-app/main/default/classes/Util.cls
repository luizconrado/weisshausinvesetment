public with sharing class Util {
    public static String getUUID() {
        Blob b = Crypto.generateAesKey(128);
        String h = EncodingUtil.convertToHex(b);
        String guid = h.substring(0, 8) + '-' + h.substring(8, 12) + '-' + h.substring(12, 16) + '-' + h.substring(16, 20) + '-' + h.substring(20);
        return guid;
    }
    public static Integer randomNumber( Integer maxValue) {
        return Integer.valueOf(Math.random() * maxValue);
    }
    
    public static String randomString( Integer length) {
        String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String result = '';
        while (result.length() < length) {
            Integer i = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            result += chars.substring(i, i + 1);
        }
        return result;
    }
    
    public static String getRecordTypeId(final String recordTypeDevName, final String objectAPIName) {
        Schema.DescribeSObjectResult sobjectResult = Schema.getGlobalDescribe().get(objectAPIName).getDescribe();
        if (sobjectResult != null) {
            List<Schema.RecordTypeInfo> recordTypeInfo = sobjectResult.getRecordTypeInfos();
            for (Schema.RecordTypeInfo info : recordTypeInfo) {
                if (info.getDeveloperName() == recordTypeDevName) {
                    return info.getRecordTypeId();
                }
            }
        }
        return '';
    }

    public static Map<String, DescribeFieldResult> getAllObjectFields(String sObjectApiName) {
        Schema.DescribeSObjectResult[] results = Schema.describeSObjects(new String[]{
                sObjectApiName
        });
        DescribeSObjectResult sObjectName = results[0];
        Map<String, DescribeFieldResult> listOfObjectFields = new Map<String, DescribeFieldResult>();

        for (SObjectField f : sObjectName.fields.getMap().values()) {
            DescribeFieldResult field = f.getDescribe();
            listOfObjectFields.put(field.getName(), field);
        }
        return listOfObjectFields;
    }

    public static Map<String, String> getProductMetaDataConfiguration() {
        Map<String, String> productCodeAPIMap = new Map<String, String>();
        List<Subscription_Product_Configuration__mdt> productConfigList = [SELECT Id, Label, Field_API__c FROM Subscription_Product_Configuration__mdt];
        for (Subscription_Product_Configuration__mdt productConfigRec : productConfigList) {
            productCodeAPIMap.put(productConfigRec.Label, productConfigRec.Field_API__c);
        }
        return productCodeAPIMap;
    }
}