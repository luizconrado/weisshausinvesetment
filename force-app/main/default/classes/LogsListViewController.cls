public without sharing class LogsListViewController {
    
    @AuraEnabled
    public static Integer getTotalRecordCount(String recordId,String logType){
        String DEBUG_LOG_RECORDTYPEID=Constant.DEBUG_LOG_RECORDTYPEID;
        String INITEGERATION_LOG_RECORDTYPEID=Constant.INITEGERATION_LOG_RECORDTYPEID;
        String TRACK_FIELD_CHANGE_RECORDTYPE_ID=Constant.TRACK_FIELD_CHANGE_RECORDTYPE_ID;
        String TRACK_USAGE_HISTORY_RECORDTYPE_ID=Constant.TRACK_USAGE_HISTORY_RECORDTYPE_ID;
        String query='SELECT count() ';
        
        switch on logType {
            when 'API' {		 
                 query+='FROM Log__c ';
            }	
            when 'ERROR' {	 
                 query+='FROM Log__c ';
            }
            when 'CRP' {	
                 query+='FROM Change_Request_Log__c ';
            }
            when 'HISTORY' {	
                 query+='FROM History_Tracker__c ';
            }
            when 'VIEW' {	 
                 query+='FROM History_Tracker__c ';
            }
        }
        
        query+='WHERE Record_Id__c=:recordId  ';
        switch on logType {
            when 'API' {		 
                query+=' AND RecordTypeId=:INITEGERATION_LOG_RECORDTYPEID ';
            }	
            when 'ERROR' {	 
                query+=' AND RecordTypeId=:DEBUG_LOG_RECORDTYPEID ';
            }
            when 'HISTORY' {	
                query+=' AND RecordTypeId=:TRACK_FIELD_CHANGE_RECORDTYPE_ID ';
            }
            when 'VIEW' {	 
                query+=' AND RecordTypeId=:TRACK_USAGE_HISTORY_RECORDTYPE_ID ';
            }
        }
        
        query+=' LIMIT 50000 ';
        return database.countQuery(query);
    }
    
    
    @AuraEnabled
    public static List<Log__c> getErrorLogs(String recordId,String lognumber,string searchType){
        String DEBUG_LOG_RECORDTYPEID=Constant.DEBUG_LOG_RECORDTYPEID;
        String query='SELECT Id,Name,User__c ,User__r.Name , Log_Number__c ,Operation__c,Message__c,CreatedDate ';
        query+='FROM Log__c ';
        query+='WHERE Record_Id__c=:recordId AND RecordTypeId=:DEBUG_LOG_RECORDTYPEID ';
        if(lognumber!=null && searchType!=null && searchType=='NEXT') query+=' AND Name>:lognumber ';
        if(lognumber!=null && searchType!=null && searchType=='PREV') query+=' AND Name<:lognumber ';
        query+='ORDER BY CreatedDate Desc ';
        query+='LIMIT 10';
        
        
        return database.query(query);
    }
    
    @AuraEnabled
    public static List<Log__c> getAPILogs(String recordId,String lognumber,string searchType){
        String INITEGERATION_LOG_RECORDTYPEID=Constant.INITEGERATION_LOG_RECORDTYPEID;
        String query='SELECT Id,Name ,User__c ,User__r.Name, Log_Number__c ,Endpoint__c,Response_Status_Code__c,CreatedDate ';
        query+='FROM Log__c ';
        query+='WHERE Record_Id__c=:recordId AND RecordTypeId=:INITEGERATION_LOG_RECORDTYPEID  ';
        if(lognumber!=null && searchType!=null && searchType=='NEXT') query+=' AND Name>:lognumber ';
        if(lognumber!=null && searchType!=null && searchType=='PREV') query+=' AND Name<:lognumber ';
        query+='ORDER BY CreatedDate Desc ';
        query+='LIMIT 10 '  ;
        return database.query(query);
    }
    
    @AuraEnabled
    public static List<Change_Request_Log__c> getCRPLogs(String recordId,String logNumber,String searchType){
        String query='SELECT Id,Name ,CreatedById  ,CreatedBy.Name, Operation__c ,Updated_At__c,Status__c,CreatedDate ';
        query+='FROM Change_Request_Log__c ';
        query+='WHERE Record_Id__c=:recordId  ';
        if(lognumber!=null && searchType!=null && searchType=='NEXT') query+=' AND Name>:lognumber ';
        if(lognumber!=null && searchType!=null && searchType=='PREV') query+=' AND Name<:lognumber ';
        query+='ORDER BY CreatedDate Desc ';
        query+='LIMIT 10 ';
        return database.query(query);
    }

    @AuraEnabled
    public static List<History_Tracker__c> getHistoryLogs(String recordId,String lognumber,string searchType){
        String TRACK_FIELD_CHANGE_RECORDTYPE_ID=Constant.TRACK_FIELD_CHANGE_RECORDTYPE_ID;
        String query='SELECT Id,Name ,User__c ,User__r.Name, Object_Label__c ,Field_Label__c,New_Value__c,Old_Value__c,Operation__c,CreatedDate ';
        query+='FROM History_Tracker__c ';
        query+='WHERE Record_Id__c=:recordId AND RecordTypeId=:TRACK_FIELD_CHANGE_RECORDTYPE_ID  ';
        if(lognumber!=null && searchType!=null && searchType=='NEXT') query+=' AND Name>:lognumber ';
        if(lognumber!=null && searchType!=null && searchType=='PREV') query+=' AND Name<:lognumber ';
        query+='ORDER BY CreatedDate Desc ';
        query+='LIMIT 10 '  ;
        return database.query(query);
    }
    @AuraEnabled
    public static List<History_Tracker__c> getViewLogs(String recordId,String lognumber,string searchType){
        String TRACK_USAGE_HISTORY_RECORDTYPE_ID=Constant.TRACK_USAGE_HISTORY_RECORDTYPE_ID;
        String query='SELECT Id,Name ,User__c ,User__r.Name,CreatedDate ';
        query+='FROM History_Tracker__c ';
        query+='WHERE Record_Id__c=:recordId AND RecordTypeId=:TRACK_USAGE_HISTORY_RECORDTYPE_ID  ';
        if(lognumber!=null && searchType!=null && searchType=='NEXT') query+=' AND Name>:lognumber ';
        if(lognumber!=null && searchType!=null && searchType=='PREV') query+=' AND Name<:lognumber ';
        query+='ORDER BY CreatedDate Desc ';
        query+='LIMIT 10 '  ;
        return database.query(query);
    }
}