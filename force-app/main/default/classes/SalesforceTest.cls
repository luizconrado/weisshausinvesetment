@isTest
public class SalesforceTest {
    
    @isTest
    static void testSalesforce(){
        Url u=Salesforce.baseUrl;
        Boolean bb=Salesforce.isSandbox;
        String s=Salesforce.edition;
        Boolean b=Salesforce.isCompactLayout;
    }

}