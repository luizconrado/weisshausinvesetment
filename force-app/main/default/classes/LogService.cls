public inherited  sharing class LogService {
    
    public static void LogApiCall(ApiCallDetails details){
        Log_Event__e e=New Log_Event__e();
        e.Type__c='Integeration';
        String index=RandomUtil.randomUUID();
        details.index = index;
        details.operation='REST Call';
        e.Comments__c=details.comments;
        e.Body__c=JSON.serialize(details);
        EventBus.publish(e);
    }
    public static String logError(LogMetadata details){
        String index=RandomUtil.randomUUID();
        if(details.error!=null){
            System.debug('ERROR => '+details.error.getStackTraceString());
            System.debug('ERROR TYPE => '+details.error.getMessage());
            details.stacktrace=details.error.getStackTraceString();
            details.errorMessage=details.error.getMessage();
            details.error=null;
           
        }
        Log_Event__e e=New Log_Event__e();
        e.Type__c='Debug';
        details.index = index;
        e.Comments__c=details.comments;
        e.Body__c=JSON.serialize(details);
        EventBus.publish(e);
        return index;
    }
    
    
    public static void captureLogs(List<Log_Event__e> events){
        List<Log__c> toInsert =new  List<Log__c>();
        
        for(Log_Event__e event:events){ 
            Log__c log=new Log__c();
            if(event.Type__c=='Integeration'){
                ApiCallDetails details = (ApiCallDetails) JSON.deserialize(event.Body__c, ApiCallDetails.class);
                log.RecordTypeId=Constant.INITEGERATION_LOG_RECORDTYPEID;
                log.User__c=details.userId;
                log.Operation__c=details.operation;
                log.Object_Name__c=details.objectName;
                log.Record_Id__c=details.recordId;
                log.Log_Number__c=details.index;
                log.Request_Body__c=details.requestBody;
                log.Endpoint__c=details.url;
                log.Response_Status_Code__c =details.responseCode;
                log.Response_Body__c=details.responseBody;
                log.Call__c=details.calltype;
                log.Comments__c=event.Comments__c;
            }
            else if(event.Type__c=='Debug'){
                LogMetadata details = (LogMetadata) JSON.deserialize(event.Body__c, LogMetadata.class);
                log.RecordTypeId=Constant.DEBUG_LOG_RECORDTYPEID;
                log.User__c=details.userId;
                log.Object_Name__c=details.objectName;
                log.Operation__c=details.operation;
                log.Record_Id__c=details.recordId;
                log.Log_Number__c=details.index;
                log.Stack_Trace__c=details.stacktrace;
                log.Class_Name__c=details.className;
                log.Message__c=details.errorMessage;
                log.Method_Name__c=details.methodName;
                log.Component_Name__c=details.componentName;
                log.Comments__c=event.Comments__c;
            }
            toInsert.add(log);
        }
        if(toInsert.size()>0) insert toInsert;
    }
    
    public class ApiCallDetails{
        @AuraEnabled public String userId{set;get;}
        @AuraEnabled public String sbTenent{set;get;}
        @AuraEnabled public String recordId{set;get;}
        @AuraEnabled public String index{set;get;}
        @AuraEnabled public String operation{set;get;}
        @AuraEnabled public String objectName{set;get;}
        @AuraEnabled public String url{set;get;}
        @AuraEnabled public String requestBody{set;get;}
        @AuraEnabled public Integer responseCode{set;get;}
        @AuraEnabled public String responseBody{set;get;}
        @AuraEnabled public String calltype{set;get;}
        @AuraEnabled public String comments{set;get;}
        public void addComment(String comments){
            this.comments=comments;
        }
        public void addMetadataInfo(String userId,String operation){
            this.userId=userId;
            this.operation=operation;
        }
        public void addRecordInfo(String objectName,String recordId){
            this.objectName=objectName;
            this.recordId=recordId;
        }
        public void addApiDetails(String url,String requestBody,String responseBody,Integer responseCode){
            this.url=url;
            this.requestBody=requestBody;
            this.responseBody=responseBody;
            this.responseCode=responseCode;
         }
        public ApiCallDetails(String recordId,String objectName,String sbTenent){
            userId = userinfo.getUserId();
            this.recordId=recordId;
            this.objectName=objectName;
            this.sbTenent=sbTenent;
        }
        public ApiCallDetails(){}
    } 
    
    public class LogMetadata{
        public String userId{set;get;}
        public String operation{set;get;}
        public String objectName{set;get;}
        public String recordId{set;get;}
        public String className{set;get;}
        public String methodName{set;get;}
        public String index{set;get;}
        public String componentName{set;get;}
        public String stacktrace{set;get;}
        public String errorMessage{set;get;}
        @AuraEnabled public String comments{set;get;}
        
        public Exception error{set;get;}
        public LogMetadata(){}
        public void addMetadataInfo(String userId,String className,String methodName,String componentName,String operation){
            this.userId=userId;
            this.className=className;
            this.methodName=methodName;
            this.componentName=componentName;
            this.operation=operation;
        }
        public void addRecordInfo(String objectName,String recordId){
            this.objectName=objectName;
            this.recordId=recordId;
        }
        public void addError(Exception error){
            this.error=error;
        }
        public void addComment(String comments){
            this.comments=comments;
        }
        public void addErrorString(String errorMessage,String stacktrace){
            this.stacktrace=stacktrace;
         	this.errorMessage=errorMessage;   
        }
    }

}