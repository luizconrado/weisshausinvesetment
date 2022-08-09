/***************
* @group Utility Class
* @description dml opertaiopn support class
*/
public  inherited  sharing class DatabaseService {
    
    public static List<String> insertRecords(List<SObject> recordsList){
        List<String> newRecordIds=new List<String>();
        Database.SaveResult[] srList = Database.insert(recordsList, false);
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) newRecordIds.add(sr.getId());
            else {
                for(Database.Error err : sr.getErrors()) {
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Fields that affected this error: ' + err.getFields());
                }
            }
        }
        return newRecordIds;
    }
    
}