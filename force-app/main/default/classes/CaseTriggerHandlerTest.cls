@isTest
private class CaseTriggerHandlerTest {
    @isTest 
    static void genrateLog(){
        Account a=TestDataFactory.getPersonAccount(true);
        Case c=TestDataFactory.getStandardCase(a.Id,true);
        Case c2=TestDataFactory.getStandardCase(a.Id,true);
        Case c3=TestDataFactory.getStandardCase(a.Id,true);
        Test.startTest();
        List<Case> toUpdate=[SELECT id,Subject FROM CASE];
        for(Case cc:toUpdate)
        cc.Subject='How are you';
        update toUpdate;
        
        Test.stopTest();
    }

}