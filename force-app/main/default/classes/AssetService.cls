/***************
* @group Service
* @description all asset related logic are here
*/

public with sharing class AssetService {
    
    /***************
    * @description returns all asset links that are related asset record
    * @param recordId asset record id whose details are needed
    * @return List<Asset_Link__c> returns list of asset links
    * @example
    * AssetService.getAllRealEstateImageLinks(assetId);
    */
    @AuraEnabled
    public static List<Asset_Link__c> getAllRealEstateImageLinks(string recordId){
        return [SELECT Id, Asset__c, Image_Url__c,Name FROM Asset_Link__c WHERE Asset__c=:recordId AND RecordTypeId=:Constant.ASSET_LINK_IMAGE_RECORDTYPEID AND Image_Url__c!=null ];
    }

}