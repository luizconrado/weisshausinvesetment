/***************
* @group Test Class
* @description test class for CommunityWLSupportPageController
*/
@isTest
public class CommunityWLSupportPageControllerTest {

    @isTest
    static void createCaseTest(){
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Test.startTest();
        CommunityWLSupportPageController.createCase('From Test Class','Investment Case',a.PersonEmail,'Investment_Case');
        Test.stopTest();
        System.assert([SELECT id FROM Case].size()>0);
    }
    @isTest
    static void createCaseNegetiveTest(){
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Test.startTest();
        try{
        CommunityWLSupportPageController.createCase('From Test Class From Test Class From Test Class From Test Class From Test Class From Test Class From Test Class From Test Class From Test Class From Test Class From Test Class From Test Class From Test Class From Test Class From Test Class From Test Class From Test Class From Test Class From Test Class From Test Class From Test Class From Test Class From Test Class From Test Class From Test Class From Test Class From Test Class From Test Class From Test Class From Test Class From Test Class From Test Class'
                                                    ,'Investment Case',a.PersonEmail,'Investment_Case');
        }catch(Exception e){}
        Test.stopTest();
        System.assert([SELECT id FROM Case].size()==0);
    }
}