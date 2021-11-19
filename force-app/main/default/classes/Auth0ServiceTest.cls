@isTest
private class Auth0ServiceTest {

    @isTest
    static void fetchUserDetailsTest(){
        Test.setMock(HttpCalloutMock.class, new Auth0Wrapper.MockResponse());
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Account','Sandbox');
        Test.startTest();
        String jsonBody=Auth0Service.fetchUserDetails(userinfo.getUserId(), details);
        Auth0Wrapper.parse(jsonBody);
        Test.stopTest();
    }
     @isTest
    static void updateUserDetailsTest(){
        Test.setMock(HttpCalloutMock.class, new Auth0Wrapper.MockResponse());
        LogService.ApiCallDetails details=new LogService.ApiCallDetails(userinfo.getUserId(),'Account','Sandbox');
        Auth0Service.updateUserDetails(userinfo.getUserId(),'{}', details);
    }
}