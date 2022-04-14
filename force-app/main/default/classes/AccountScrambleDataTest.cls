
/***************
* @group Test Class
* @description test class for AccountScrambleData
*/
@isTest
public class AccountScrambleDataTest {

    @testSetup
    static void setup(){
        List<Scramble_Configuration__c> scrableFields=new List<Scramble_Configuration__c>();
        scrableFields.add(new Scramble_Configuration__c(Field__c='Id',Object__c='Account',Name='Id',IsReference__c=true));
        scrableFields.add(new Scramble_Configuration__c(Field__c='LastName',Object__c='Account',Name='Name',IsReference__c=false));
        scrableFields.add(new Scramble_Configuration__c(Field__c='PersonBirthdate',Object__c='Account',Name='PersonBirthdate',IsReference__c=false));
        scrableFields.add(new Scramble_Configuration__c(Field__c='Age__pc',Object__c='Account',Name='Age',IsReference__c=false));
        scrableFields.add(new Scramble_Configuration__c(Field__c='Terms_Conditions_Signed_At__c',Object__c='Account',Name='Terms_Conditions_Signed',IsReference__c=false));
        scrableFields.add(new Scramble_Configuration__c(Field__c='PersonEmail',Object__c='Account',Name='PersonEmail',IsReference__c=false));
        
        scrableFields.add(new Scramble_Configuration__c(Field__c='AccountId',Object__c='Opportunity',Name='Opp_Id',IsReference__c=true));
        scrableFields.add(new Scramble_Configuration__c(Field__c='Amount',Object__c='Opportunity',Name='Amount',IsReference__c=false));
        scrableFields.add(new Scramble_Configuration__c(Field__c='StageName',Object__c='Opportunity',Name='StageName',IsReference__c=false));
        scrableFields.add(new Scramble_Configuration__c(Field__c='CloseDate',Object__c='Opportunity',Name='CloseDate',IsReference__c=false));
        
        insert scrableFields;
        
        Account personAccount=TestDataFactory.getPersonAccount(false);
        Date d=Date.today();
        personAccount.PersonBirthdate=d.addYears(-100); 
        personAccount.Age__pc='01-10';
        personAccount.Terms_Conditions_Signed_At__c=DateTime.now();
        personAccount.PersonEmail='asdfg@asdf.com';
        insert personAccount;
     
        Opportunity opp=TestDataFactory.getOpportunityFullSale(personAccount.id,false);
        opp.Amount=100;
        opp.StageName='Qualification';
        opp.CloseDate=Date.today()+3;
        insert opp;
    }
    
    @isTest
    static void scrambleDataSucess(){
        Account a=[SELECT id FROM Account];
        Test.startTest();
        
        System.enqueueJob(new AccountScrambleData(new List<String>{a.Id}));
        Test.stopTest();
    }
    @isTest
    static void logRecordErrorTest(){
        Account personAccount=TestDataFactory.getPersonAccount(false);
        Date d=Date.today();
        personAccount.PersonBirthdate=d.addYears(-100); 
        
        personAccount.Terms_Conditions_Signed_At__c=DateTime.now();
        personAccount.PersonEmail='asdfg@asdf.com';
        insert personAccount;
        update personAccount;
        Test.startTest();
        AccountScrambleData scrable=new AccountScrambleData(new List<String>{});
        scrable.logError('','',null);
        Test.stopTest();
            
            
    }
    
}