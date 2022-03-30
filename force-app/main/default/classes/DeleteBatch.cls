public class DeleteBatch implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select Id from account where FirstName LIKE \'%signup%\' or LastName =\'last name\' ');
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope){
         
        Delete scope;
    }
    
    public void finish(Database.BatchableContext BC){
    }
}