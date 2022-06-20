public class DeleteBatch implements Database.Batchable<sObject>{
    
    String objectName='Account';
    public DeleteBatch(String objectName){
        this.objectName=objectName;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        String query='';
        if(objectName.equalsIgnoreCase('Account')){
            query='select Id from account where FirstName LIKE \'%signup%\' or LastName =\'last name\' ';
        }
        else if(objectName.equalsIgnoreCase('Log')){
            query='SELECT id FROM Log__c';
        }
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope){
         
        Delete scope;
    }
    
    public void finish(Database.BatchableContext BC){
    }
}