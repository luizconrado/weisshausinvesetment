/***************
* @group Test Class
* @description test class for LogsListViewController 
*/
@isTest
public class LogsListViewControllerTest {
    
    @testSetup
    static void setupDataTest(){
        Account a=TestDataFactory.getPersonAccount(true);
        Log__c debugLog=TestDataFactory.getDebugLog(a.Id,true);
        Log__c intLog=TestDataFactory.getIntegerationLog(a.Id,true); 
        Change_Request_Log__c crp=TestDataFactory.getChangeRequestLog(a.Id,true);
        History_Tracker__c ch=TestDataFactory.getChangeHistoryLog(a.Id,True);
        History_Tracker__c vh=TestDataFactory.getViewHistoryLog(a.Id,True);
    }
    
    @isTest
    static void getTotalRecordCountTest(){
        Account a=[SELECT id FROM ACCOUNT Limit 1];
        Test.startTest();
        Integer count=0;
        count+=LogsListViewController.getTotalRecordCount(a.Id,'API');
        count+=LogsListViewController.getTotalRecordCount(a.Id,'ERROR');
        count+=LogsListViewController.getTotalRecordCount(a.Id,'HISTORY');
        count+=LogsListViewController.getTotalRecordCount(a.Id,'CRP');
        count+=LogsListViewController.getTotalRecordCount(a.Id,'VIEW');
        System.assertEquals(5, count);
        Test.stopTest();
    }
    
    @isTest
    static void getLogsTest(){
        Account a=[SELECT id FROM ACCOUNT Limit 1];
        Test.startTest();
        LogsListViewController.getErrorLogs(a.id,null,null);
        LogsListViewController.getAPILogs(a.id,null,null);
        LogsListViewController.getCRPLogs(a.id,null,null);
        LogsListViewController.getHistoryLogs(a.id,null,null);
        LogsListViewController.getViewLogs(a.id,null,null);
        Test.stopTest();
    }

}