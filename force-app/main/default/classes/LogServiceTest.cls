@isTest
public class LogServiceTest {
    
    @isTest
    static void testlogError(){
        try{
            Integer i = 1/0;
        }
        catch(Exception e){
            LogService.LogMetadata data=new LogService.LogMetadata();
            data.className='LogServiceTest';
            data.componentName='LogServiceTest';
            data.index='asdfg';
            data.methodName='testLogApiCall';
            data.objectName='Log_Event__e';
            data.operation='Test class';
            data.recordId=userinfo.getUserId();
            data.userId=userinfo.getUserId();
            data.error=e;
            Test.startTest();
            String s=LogService.logError(data);
            Test.stopTest();
            System.assert(String.isNotBlank(s));
        }
        
        
        
    }    
    @isTest
    static void testLogApiCall(){
        LogService.ApiCallDetails call = new LogService.ApiCallDetails(userinfo.getUserId(),'Log_Event__e','Sandbox');
        
        call.responseCode=200;
        call.url='www.google.com';
        call.userId=userinfo.getUserId();
        Test.startTest();
        LogService.LogApiCall(call);
        Test.stopTest();
    }
}