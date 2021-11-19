@isTest
public class AssetServiceTest {
    
    @isTest
    static void getAllRealEstateImageLinksTest(){
        Account a=TestDataFactory.getPersonAccount(true);
        Contact c=[SELECT id FROM Contact LIMIT 1];
        Asset asset=TestDataFactory.getAssetRealEstate(a.Id,c.Id,true);
        Asset_Link__c assetLink=TestDataFactory.getAssetLink(asset.Id,true);
        AssetService.getAllRealEstateImageLinks(asset.Id); 
    }

}