public with sharing class AssetService {
    
    @AuraEnabled
    public static List<Asset_Link__c> getAllRealEstateImageLinks(string recordId){
        return [SELECT Id, Asset__c, Image_Url__c,Name FROM Asset_Link__c WHERE Asset__c=:recordId AND RecordTypeId=:Constant.ASSET_LINK_IMAGE_RECORDTYPEID AND Image_Url__c!=null ];
    }

}