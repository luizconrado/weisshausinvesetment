/***************
* @group Test Class
* @description test class for TestDataFactory
*/
@isTest
public class TestDataFactoryTest {
    
    
    @isTest
    public static void getStandaloneGenerators(){
        Account bizAccount=TestDataFactory.getBusinessAccount(true);
        Account personAccount=TestDataFactory.getPersonInvestmentAccount(true);
        Bank_Account__c bankAccount=TestDataFactory.getBankAccount(personAccount.Id, true);
        Lead lead=TestDataFactory.getWebLead(true);
        Campaign camp=TestDataFactory.getStandardCampaign(true);
        Contact con=TestDataFactory.getContact(true);
        
        TestDataFactory.getChangeRequestLog(bizAccount.id,true);
        TestDataFactory.getContactCampaignMember(camp.id, con.id,true);        
        TestDataFactory.getLeadCampaignMember(camp.id, lead.id, true);
        TestDataFactory.getCard(personAccount.id, bankAccount.id, true);
        TestDataFactory.getReservation(bankAccount.id,true);
        TestDataFactory.getUser('Integration');
        TestDataFactory.getSeziure(personAccount.id,true);
        TestDataFactory.getContentVersion(true);
        TestDataFactory.getDocumentForAccount(personAccount.id,true);
        
    }

    @isTest
    public static void getBankGeneratorsTest(){
        Account personAccount=TestDataFactory.getPersonAccount(true);
        Bank__c bank=TestDataFactory.getBankSolarisBank(personAccount.id,true);
        Bank_Account__c bankAccount=TestDataFactory.getBankAccount(personAccount.Id, true);
        TestDataFactory.getKYCVideoIdentification(personAccount.Id,true);
        TestDataFactory.getBooking(bankAccount.id,true);
        TestDataFactory.getTimedOrder(bankAccount.id,true);
        TestDataFactory.getStandingOrder(bankAccount.id,true);
        
        
    }
    @isTest
    public static void getOpportuntiyGeneratorsTest(){
        Account personAccount=TestDataFactory.getPersonAccount(true);
        
        TestDataFactory.getStandardOpportunity(personAccount.id,true);
        TestDataFactory.getOpportunityFullSale(personAccount.id,true);
        TestDataFactory.getBankCase(personAccount.id, true);
        
    }
    @isTest
    public static void getCaseGeneratorsTest(){
        Account personAccount=TestDataFactory.getPersonAccount(true);
        
        TestDataFactory.getStandardCase(personAccount.id,true);
        TestDataFactory.getBankCase(personAccount.id, true);
        TestDataFactory.getEVKontoCase(personAccount.id, true);
        TestDataFactory.getCaseInvestment(personAccount.id, true);
        
    }
    
    @isTest
    public static void getBankCaseItemGeneratorsTest(){
        Account personAccount=TestDataFactory.getPersonAccount(true);
        Case c=   TestDataFactory.getBankCase(personAccount.id, true);
        TestDataFactory.getAccountBankCase( c.id,true);
        TestDataFactory.getCardBankCase( c.id,true);
        TestDataFactory.getBookingBankCase( c.id,true);
        TestDataFactory.getBankAccountBankCase( c.id,true);
        TestDataFactory.getTimedOrderBankCase( c.id,true);
    }
    @isTest
    public static void getAssetGeneratorsTest(){
        Account personAccount=TestDataFactory.getPersonAccount(true);
        Contact c=[SELECT id FROM Contact WHERE accountId=:personAccount.Id];
        Asset asset=TestDataFactory.getAssetRealEstate(personAccount.id, c.Id,true);
        TestDataFactory.getAssetLink(asset.id,true);
        TestDataFactory.getAssetEvaluation(asset.id, true);
        
    }
    
    @isTest
    static void getLogGeneratorsTest(){
        Account personAccount=TestDataFactory.getPersonAccount(true);
        TestDataFactory.getDebugLog(personAccount.id,true);
        TestDataFactory.getDebugLog(personAccount.id,true);
        TestDataFactory.getChangeHistoryLog(personAccount.id,true);
        TestDataFactory.getViewHistoryLog(personAccount.id,true);
        
        
    }
}