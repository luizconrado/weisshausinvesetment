@isTest
public class OpportuntiyRealEstateServiceTest {
     @isTest
    static void getRealEstateSaleEmailPreviewTest(){
      Account a=TestDataFactory.getPersonAccount(true);
        Contact c=[SELECT id FROM Contact LIMIT 1];
        Asset asset=TestDataFactory.getAssetRealEstate(a.id, c.Id,true);
        Evaluation__c eval=TestDataFactory.getAssetEvaluation(asset.Id, true);
        Evaluation__c eval2=TestDataFactory.getAssetEvaluation(asset.Id, false);
        eval2.Date__c=Date.today().addMonths(1);
        insert eval2;
        Evaluation__c eval3=TestDataFactory.getAssetEvaluation(asset.Id, false);
        eval3.Date__c=Date.today().addMonths(-1);
        insert eval3;
        Opportunity o=TestDataFactory.getOpportunityFullSale(a.id,false);
        o.Asset__c=asset.id;
        insert o;
        Test.startTest();
        Map<String,String> email=OpportuntiyRealEstateService.getRealEstateSaleEmailPreview(o.Id);
        String body=email.get('BODY');
        OpportuntiyRealEstateService.sendEmailToAgent(body, email.get('SUBJECT'), o.Id,'ev@smartmoney.com');
        System.assert(body.contains(a.LastName));
        Test.stopTest();
    }
     
    @isTest
    static void getTermDepositeStatusTest(){
        Account acc=TestDataFactory.getPersonAccount(true);
        Opportunity opp=TestDataFactory.getOpportunityFullSale(acc.Id, true);
        Test.startTest();
        OpportuntiyRealEstateService.getTermDepositeStatus(opp.id);
        OpportuntiyRealEstateService.getTermDepositeStatus(opp.id);
        Test.stopTest();
    }
    
    @isTest
    static void toggleTermDepostForUserTest(){
        Test.setMock(HttpCalloutMock.class, new Auth0Wrapper.MockResponse());
        Account acc=TestDataFactory.getPersonAccount(true);
        Opportunity opp=TestDataFactory.getOpportunityFullSale(acc.Id, true);
        
        Test.startTest(); 
        OpportuntiyRealEstateService.toggleTermDepostForUser(opp.id, true);
        Test.stopTest();
    }
 

}