/***************
* @group Test Class
* @description test class for Salesforce
*/
@isTest
public class SalesforceTest {
    
    @isTest
    static void testSalesforce(){
        String u=Salesforce.baseUrl;
        Boolean bb=Salesforce.isSandbox;
        String s=Salesforce.edition;
        Boolean b=Salesforce.isCompactLayout;
    }
 
}