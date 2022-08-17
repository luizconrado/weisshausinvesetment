/***************
* @group Service Class
* @description Publish slack alert to slack channels based on cofigs in Slack Alert Configuration
*/
public class SlackAlertService {
    
     //unified method where update and insert can be tracked from trigger
    public static void invokeAlert(String objectApiName){
        if (Trigger.isAfter && Trigger.isInsert)  invokeAlert(objectApiName, Trigger.new);
        else if (Trigger.isAfter &&  Trigger.isUpdate) invokeAlert(objectApiName, Trigger.new,Trigger.oldMap);
    }
    
    private static final String FIELD_TEMPLATE='{field}';
    private static final String FIELD_VALUE_TEMPLATE='{value}';
    private static final String FIELD_VALUE_OLD_TEMPLATE='{old}';
    private static final String HEADER_START_TEMPLATE='{{!';
    private static final String HEADER_END_TEMPLATE='}}';

    //publish insert changes
    public static void invokeAlert(String objectName,List<sObject> newRecords){
        
        //check configuration
        if(!checkTrackStatus(objectName,'Insert')) return;
        List<SlackConfiguration> fields=getFieldsToTrack(objectName);
        List<slackv2.invokePostMessage.PostMessageRequest> allAlerts=new List<slackv2.invokePostMessage.PostMessageRequest>();
        
        Map<String,String> apiNameAndFieldNameMap=new Map<String,String>();
        for(DescribeFieldResult fieldDetails:SchemaUtil.getAllObjectFields(objectName).values()){
            apiNameAndFieldNameMap.put(fieldDetails.getName(),fieldDetails.getLabel());
        }
        
        for(sObject record:newRecords){
            for(SlackConfiguration configField:fields){
                Boolean matchCustomFilterCritera=true;
                Boolean matchFilterCritera=true;
                Boolean createAlert=false;
                slackv2.invokePostMessage.PostMessageRequest alert=new slackv2.invokePostMessage.PostMessageRequest();
                alert.recordId=(String)record.get('Id');
                alert.message='';

                //alert configs
                string messageTemplate=FIELD_TEMPLATE+' : '+FIELD_VALUE_TEMPLATE;
                alert.messageDestinationId=configField.messageId; 
                if(configField.messageCreatetext!=null) messageTemplate=configField.messageCreatetext;
                if(configField.messageHeadertext!=null){
                    String msgHeader=configField.messageHeadertext;
                    if(msgHeader.contains(HEADER_START_TEMPLATE)){
                        String fieldName=msgHeader.substringBetween(HEADER_START_TEMPLATE, HEADER_END_TEMPLATE); 
                        fieldName=fieldName.trim();
                        if(record.getPopulatedFieldsAsMap().containsKey(fieldName)){
                            msgHeader=msgHeader.replace(HEADER_START_TEMPLATE+fieldName+HEADER_END_TEMPLATE, String.valueOf(record.get(fieldName)));
                        }
                    }
                    
                    alert.message+=msgHeader+'\n';
                    
                } 
                if(configField.recordTypeId!=null && (((String)record?.get('RecordTypeId'))!=configField?.recordTypeId)) matchFilterCritera=false;
                 
                matchCustomFilterCritera=checkEVFilterCriteras(record,objectName);
                
                if(matchFilterCritera && matchCustomFilterCritera){
                    for(String field:configField.fieldNames){
                        field=field.trim();
                        //checking if field value is to be tracked 
                        if(record.getPopulatedFieldsAsMap().containsKey(field) && record.get(field)!=null){
                            //replacing values in template string
                            alert.message +='- '+messageTemplate.replace(FIELD_TEMPLATE, '*'+apiNameAndFieldNameMap.get(field)+'*')
                            .replace(FIELD_VALUE_TEMPLATE,(record.get(field)!=null)?String.valueOf(record.get(field)):'')+'\n';
                            createAlert=true;
                        }
                    }
                }
                
                 if(createAlert) allAlerts.add(alert);
            }
            
           
            
        }
        System.debug('Slack Alert '+allAlerts.size());
        //post alerts
        if(allAlerts.size()>0) slackv2.invokePostMessage.postMessage(allAlerts);
    }
    //publish update changes
    public static void invokeAlert(String objectName,List<sObject> newRecords,Map<id,sObject> oldRecords){
        //check configuration
        if(!checkTrackStatus(objectName,'Update')) return;
        List<SlackConfiguration> fields=getFieldsToTrack(objectName);
        List<slackv2.invokePostMessage.PostMessageRequest> allAlerts=new List<slackv2.invokePostMessage.PostMessageRequest>();
        
        Map<String,String> apiNameAndFieldNameMap=new Map<String,String>();
        for(DescribeFieldResult fieldDetails:SchemaUtil.getAllObjectFields(objectName).values()){
            apiNameAndFieldNameMap.put(fieldDetails.getName(),fieldDetails.getLabel());
        }
        
        
        
        for(sObject record:newRecords){
            sObject oldRecord=oldRecords.get((Id)record.get('Id'));
            for(SlackConfiguration configField:fields){
                Boolean matchFilterCritera=true;
                Boolean createAlert=false;
                Boolean matchCustomFilterCritera=true;
                
                slackv2.invokePostMessage.PostMessageRequest alert=new slackv2.invokePostMessage.PostMessageRequest();
                alert.recordId=(String)record.get('Id');
                alert.message='';
                
                //alert configs
                alert.messageDestinationId=configField.messageId; 
                string messageTemplate=FIELD_TEMPLATE+' Changed From: '+FIELD_VALUE_OLD_TEMPLATE+' To '+FIELD_VALUE_TEMPLATE;
                
                if(configField.updateMessageHeaderText!=null){
                    String msgHeader=configField.updateMessageHeaderText;
                    if(msgHeader.contains(HEADER_START_TEMPLATE)){
                        String fieldName=msgHeader.substringBetween(HEADER_START_TEMPLATE, HEADER_END_TEMPLATE); 
                        if(record.getPopulatedFieldsAsMap().containsKey(fieldName)){
                            msgHeader=msgHeader.replace(HEADER_START_TEMPLATE+fieldName+HEADER_END_TEMPLATE, String.valueOf(record.get(fieldName)));
                        }
                    }
                    alert.message+=msgHeader+'\n';
                }
                
                if(configField.messageUpdatetext!=null) messageTemplate=configField.messageUpdatetext;
				
                if(configField.recordTypeId!=null && ((String)record?.get('RecordTypeId')!=configField?.recordTypeId.trim())) matchFilterCritera=false;
                 
                matchCustomFilterCritera=checkEVFilterCriteras(record,objectName);
                 
                if(matchFilterCritera && matchCustomFilterCritera){
                    for(String field:configField.fieldNames){
                        field=field.trim();
                        //checking if field is changed
                        if(record.getPopulatedFieldsAsMap().containsKey(field) && record.get(field)!=oldRecord.get(field)){
                            //preapring message template
                            String str='- '+
                            messageTemplate.replace(FIELD_TEMPLATE, '*'+apiNameAndFieldNameMap.get(field)+'*')
                            .replace(FIELD_VALUE_TEMPLATE,(record.get(field)!=null)?String.valueOf(record.get(field)):'')
                            .replace(FIELD_VALUE_OLD_TEMPLATE,(oldRecord.get(field)!=null)?String.valueOf(oldRecord.get(field)):'')+'\n';
                            alert.message +=str;
                            createAlert=true;
                            
                        }
                    }
                }
                
                
                if(createAlert) allAlerts.add(alert);
            }
            
           
        }
        
        if(allAlerts.size()>0) slackv2.invokePostMessage.postMessage(allAlerts);
    }
    
    
    private static Boolean checkEVFilterCriteras(sObject record,String objectName){
        Boolean statusCheck=true;
        
        if(objectName=='Account'){
            if(Boolean.valueOf(record.get('IsPersonAccount')) && Boolean.valueOf(record.get('Deletion_Request__c'))==true){
                statusCheck=false;
            }
            if(Boolean.valueOf(record.get('IsPersonAccount')) && String.valueOf(record.get('LastName'))=='[Not Provided]'){
                statusCheck=false;
            }
        }
        else if(objectName=='KYC_Detail__c'){
            if(Boolean.valueOf(record.get('Anonymized__c'))==true){
                statusCheck=false;
            }
        }
        else if(objectName=='Customer_Classification__c'){
            if(Boolean.valueOf(record.get('Anonymized__c'))==true){
                statusCheck=false;
            }
        }
        
        return statusCheck;
    }
    
    //returns true if any one config of object is active
    private static Boolean checkTrackStatus(String objectName,String operation){
        String query='SELECT Id FROM Slack_Alert_Configuration__mdt ';
        query += ' WHERE Object_Name__c=:objectName AND Active__c=True ';
        if(operation=='Insert') query +=' AND Track_Insert__c = true ';
        if(operation=='Update') query +=' AND Track_Update__c = true ';
        List<Slack_Alert_Configuration__mdt> fieldConfig=Database.query(query);
        if(fieldConfig.size()>0) return true;
        return false;
    }
    
    private static List<SlackConfiguration> getFieldsToTrack(String ObjectName){
        //get field names that needs to be tracked
        List<SlackConfiguration> fields=new List<SlackConfiguration>();
        for(Slack_Alert_Configuration__mdt config:[SELECT Update_Message_Header__c,Create_Alert_Template__c,Update_Alert_Template__c,Field_Name__c,Slack_Destination_Id__c,Message_Header__c,RecordType_Id__c 
                                                   FROM Slack_Alert_Configuration__mdt
                                                   WHERE Object_Name__c=:ObjectName AND Active__c=True]){
                                                       SlackConfiguration s=new SlackConfiguration();
                                                       s.messageHeadertext=config.Message_Header__c;
                                                       s.updateMessageHeaderText=config.Update_Message_Header__c;
                                                       s.messageId=config.Slack_Destination_Id__c;
                                                       s.recordTypeId=config.RecordType_Id__c;
                                                       s.messageCreatetext=config.Create_Alert_Template__c;
                                                       s.messageUpdatetext=config.Update_Alert_Template__c;
                                                       List<String> fieldNames=new List<String>();
                                                       for(String fieldName:config.Field_Name__c.split(',')){
                                                          fieldNames.add(fieldName);
                                                       }
                                                       s.fieldNames=fieldNames;
                                                       fields.add(s);
                                                   }
        return fields;
    }
    
    public class SlackConfiguration{
        public List<String> fieldNames{set;get;}
        public String messageHeadertext{set;get;}
        public String updateMessageHeaderText{set;get;}
        public String messageCreatetext{set;get;}
        public String messageUpdatetext{set;get;}
        public String messageId{set;get;}
        public String recordTypeId{set;get;}
    }
  
    
}