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
            data.addMetadataInfo(userinfo.getUserId(),'TestClass','TestMentoid','TestComponent','Test class');
            data.addRecordInfo('Log_Event__e',null);
            data.addError(e);
            data.addErrorString(e.getStackTraceString(),e.getMessage());
            data.addComment('from test class');
            Test.startTest();
            String s=LogService.logError(data);
            Test.stopTest();
            System.assert(String.isNotBlank(s));
        }
        
        
        
    }    
    @isTest
    static void testLogApiCall(){
        LogService.ApiCallDetails x=new LogService.ApiCallDetails();
        LogService.ApiCallDetails call = new LogService.ApiCallDetails(userinfo.getUserId(),'Log_Event__e','Sandbox');
        
        call.responseCode=200;
        call.url='www.google.com';
        call.userId=userinfo.getUserId();
        call.addMetadataInfo(userinfo.getUserId(),'Call');
        call.addRecordInfo('Log_Event__e',null);
        call.addApiDetails('www.evsmartmoney.com','{}','{}',200);
        call.addComment('from test class');
        Test.startTest();
        LogService.LogApiCall(call);
        Test.stopTest();
    }
    
    @isTest
    static void testLogingTriggers(){
        Account a=TestDataFactory.getPersonAccount(true);
        Bank_Account__c bc=TestDataFactory.getBankAccount(a.Id,true);
        Case c=TestDataFactory.getBankCase(a.Id,true);
        Bank_Case_Item__c bankCase=TestDataFactory.getBankAccountBankCase(c.Id,false);
        bankCase.Account__c=a.Id;
        insert bankCase;
        
        KYC_Detail__c ident=new KYC_Detail__c();
        ident.Account__c =a.Id;
        insert ident;
         
        Scheduled_Order__c sc=new Scheduled_Order__c();
        sc.Bank_Account__c =bc.Id;
        insert sc;
        
        Tax_Identification__c ti=new Tax_Identification__c();
        ti.Account__c=a.id;
        insert ti;
        
        Card__c card=new Card__c();
        card.Person_Account__c=a.Id;
            card.Bank_Account__c=bc.Id;
        insert card;
        
        Booking__c book=new Booking__c();
        book.Bank_Account__c =bc.Id;
        insert book;
        
        
        
    }
}