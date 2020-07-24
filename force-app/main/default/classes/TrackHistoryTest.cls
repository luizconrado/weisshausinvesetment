@isTest
public class TrackHistoryTest {
    @testSetup
    static void setupData(){
        Account a=TestDataFactory.getPersonAccount(true);
    }
    
    @isTest
    static void logEntryTest(){
        
        Account a=TestDataFactory.getPersonAccount(true);
        TrackHistory.logUsageEntry(a.Id,'Account');
        List<History_Tracker__c> track=[select id from History_Tracker__c LIMIT 1];
        System.assertEquals(1, track.size());
    }
    
    @isTest
    static void publishChangesTest(){
        Test.startTest();
        List<String> fields=new List<String>();
        for(String key:SchemaUtil.getAllObjectFields('Account').keySet()) fields.add(key);
        List<Account> a=Database.query('Select '+String.join(fields,',')+' FROM Account');
        a.get(0).newsletter__pc='subscribed';
        TrackHistory.publishChanges('Account', a);
        Account clone=(Account)JSON.deserialize(JSON.serialize(a.get(0)),Account.class);
        clone.newsletter__pc='unsubscribed';
        Map<Id,Account> olda=new Map<Id,Account>(new List<Account>{clone});
        
        TrackHistory.publishChanges('Account',a,olda);
        Test.stopTest();
    }
    @isTest
    static void captureChangesTest(){
        Test.startTest();
        Account  a=[select Id,Name FROM Account LIMIT 1];
        Tracking_Events__e e=New Tracking_Events__e();
        e.Field__c='Name';
        e.Object__c='Account';
        e.Record_Id__c=a.Id;
        e.Record_Name__c=a.Name;
        e.New_Value__c=a.Name;
        e.Old_Value__c='Changed';
        e.Operation__c='Insert';
        e.User_Id__c=Userinfo.getUserId();
        TrackHistory.captureChanges(new List<Tracking_Events__e>{e});
        Test.stopTest();
        List<History_Tracker__c> newRecords=[SELECT id FROM History_Tracker__c];
        System.assert(newRecords.size()==1);
    }
    
}