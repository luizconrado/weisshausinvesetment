/***************
* @group Test Class
* @description test class for TrackerDashboardController
*/
@isTest
private class TrackerDashboardControllerTest {

    @isTest
    static void getValues(){
        List<DateTime> ds=TrackerDashboardController.getPastYearWeeks();
        TrackerDashboardController.fetchAllTrackingRecords('1/1/2020','1/2/2020');
        TrackerDashboardController.getLoginHistory('1/1/2020','1/2/2020');
    }
}