/***************
* @group Service Class
* @description all asset related logic are here
*/

public with sharing class AssetService {
    
    /***************
    * @description fetchs all assets links realted to asset
    * @param recordId of asset
    * @return list of Asset_Link__c
    */
    @AuraEnabled
    public static List<Asset_Link__c> getAllRealEstateImageLinks(string recordId){
        return [SELECT Id, Asset__c, Image_Url__c,Name FROM Asset_Link__c WHERE Asset__c=:recordId AND RecordTypeId=:Constant.ASSET_LINK_IMAGE_RECORDTYPEID AND Image_Url__c!=null ];
    }

}