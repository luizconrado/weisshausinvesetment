public without sharing  class TrackHistory {

    public static void captureChanges(List<Tracking_Events__e> changes){

        //creating map of object and schema
        Map<String,DescribeSobjectResult> objectDescriptionMap=new Map<String,DescribeSobjectResult>();
        Map<String,Map<String,DescribeFieldResult>> objectFieldsMap=new Map<String,Map<String,DescribeFieldResult>>();
        for(Tracking_Events__e event:changes){
            if(!objectDescriptionMap.containsKey(event.Object__c)){
                objectDescriptionMap.put(event.Object__c,null);
            }
            if(!objectFieldsMap.containsKey(event.Object__c)){
                objectFieldsMap.put(event.Object__c,null);
            }
        }
        //Obtaining schema of object and fields
        for(String objectName:objectDescriptionMap.keySet()){
            DescribeSobjectResult objectDetails=SchemaUtil.getSobjectType(objectName);
            objectDescriptionMap.put(objectName,objectDetails);
            objectFieldsMap.put(objectName,SchemaUtil.getAllObjectFields(objectName));
        }
        List<History_Tracker__c> toInsertRecords=new List<History_Tracker__c>();
        //create Records
        for(Tracking_Events__e event:changes){
            if(String.isNotEmpty(event.Operation__c)){
                History_Tracker__c change=new History_Tracker__c();
                change.Relation__c='On Record';
                change.RecordTypeId=Constant.TRACK_FIELD_CHANGE_RECORDTYPE_ID;
                change.Field__c=event.Field__c;
                change.Object__c=event.Object__c;
                change.Record_Id__c=event.Record_Id__c;
                change.Old_Value__c=event.Old_Value__c;
                change.New_Value__c=event.New_Value__c;
                change.Record_Name__c=event.Record_Name__c;
                change.User__c=event.User_Id__c;
                change.Operation__c=event.Operation__c;
                if(objectDescriptionMap.containsKey(event.Object__c)) change.Object_Label__c=objectDescriptionMap.get(event.Object__c).getLabel();
                if(objectFieldsMap.containsKey(event.Object__c)) change.Field_Label__c=objectFieldsMap.get(event.Object__c).get(event.Field__c).getLabel();
                toInsertRecords.add(change);
            }
        }
        if(toInsertRecords.size()>0) insert toInsertRecords;
        
    }
    // insert changes
    public static void publishChanges(String objectName,List<sObject> newRecords){
        //check configuration
        if(!checkTrackStatus(objectName,'Insert')) return;
        
        List<String> fields=getFieldsToTrack(objectName);
        if(fields.size()==0) return;
        
        List<Tracking_Events__e> toPublishRecords=new List<Tracking_Events__e>();
        for(sObject record:newRecords){
            for(String field:fields){
                field=field.trim();
                //checking if field value is changed 
                if(record.getPopulatedFieldsAsMap().containsKey(field)){
                    Tracking_Events__e e=New Tracking_Events__e();
                    e.Field__c=field;
                    e.Object__c=objectName;
                    e.Record_Id__c=String.valueOf(record.get('Id'));
                    e.Record_Name__c=String.valueOf(record.get(getFieldApiForName(objectName)));
                    e.New_Value__c=String.valueOf(record.get(field));
                    e.User_Id__c=Userinfo.getUserId();
                    e.Operation__c='Insert';
                    toPublishRecords.add(e);
                }
            }
        }
        if(toPublishRecords.size()>0) EventBus.publish(toPublishRecords);
    }
    // update changes
    public static void publishChanges(String objectName,List<sObject> newRecords,Map<id,sObject> oldRecords){
        //check configuration
        if(!checkTrackStatus(objectName,'Update')) return;
        
        List<String> fields=getFieldsToTrack(objectName);
        if(fields.size()==0) return;
        List<Tracking_Events__e> toPublishRecords=new List<Tracking_Events__e>();
        for(sObject record:newRecords){
            sObject oldRecord=oldRecords.get((Id)record.get('Id'));
            for(String field:fields){
                field=field.trim();
               //checking if field value is changed 
                if(record.getPopulatedFieldsAsMap().containsKey(field) && record.get(field)!=oldRecord.get(field)){
                    Tracking_Events__e e=New Tracking_Events__e();
                    e.Field__c=field;
                    e.Object__c=objectName;
                    e.Record_Id__c=String.valueOf(record.get('Id'));
                    e.Record_Name__c=String.valueOf(record.get(getFieldApiForName(objectName)));
                    e.New_Value__c=String.valueOf(record.get(field));
                    e.Old_Value__c=String.valueOf(oldRecord.get(field));
                    e.User_Id__c=Userinfo.getUserId();
                    e.Operation__c='Update';
                    System.debug('KING Event Update '+e);
                    toPublishRecords.add(e);
                }
            }
        }
        if(toPublishRecords.size()>0) EventBus.publish(toPublishRecords);
    }
       
    //unified method where update and insert can be tracked from trigger
    public static void publishChanges(String objectApiName){
        if (Trigger.isAfter && Trigger.isInsert)  publishChanges(objectApiName, Trigger.new);
        else if (Trigger.isAfter &&  Trigger.isUpdate) publishChanges(objectApiName, Trigger.new,Trigger.oldMap);
    }

    private static Boolean checkTrackStatus(String objectName,String operation){
        String query='SELECT Fields__c,Track_Insert__c,Track_Update__c FROM History_Tracker_Configuration__mdt ';
        query += ' WHERE Object__c=:objectName AND Track_Change__c=True ';
        if(operation=='Insert') query +=' AND Track_Insert__c = true ';
        if(operation=='Update') query +=' AND Track_Update__c = true ';
        List<History_Tracker_Configuration__mdt> fieldConfig=Database.query(query);
        if(fieldConfig.size()>0) return true;
        return false;
    }
    
    private static List<String> getFieldsToTrack(String ObjectName){
        //get field names that needs to be tracked
        List<History_Tracker_Configuration__mdt> fieldConfig=[SELECT Fields__c,Track_Insert__c,Track_Update__c FROM History_Tracker_Configuration__mdt WHERE Object__c=:ObjectName AND Track_Change__c=True];
        List<String> fields=new List<String>();
        if(fieldConfig.size()>0) fields=fieldConfig.get(0).Fields__c.split(',');
        return fields;
    }
    
    private static String getFieldApiForName(String objectName){
        String name='Name';
        if(objectName=='Task' || objectName=='Event' ) name='Subject';
        if(objectName=='Case') name='CaseNumber';
        if(objectName=='Contact' || objectName=='Account' || objectName=='Lead') name='LastName';
        return name;
    }
	// view of records
    @AuraEnabled
    public static void logUsageEntry(String recordId ,String objectName){
         //Check for status
        List<History_Tracker_Configuration__mdt> fieldConfig=[SELECT Id FROM History_Tracker_Configuration__mdt WHERE Object__c=:objectName AND Track_View__c=True];
        if(fieldConfig.size()==0) return;
        //Check if record created in past 5 min
        DateTime pastFiveMin=DateTime.now();
        pastFiveMin=pastFiveMin.addMinutes(-5);  
        List<History_Tracker__c> exsists=[SELECT id FROM History_Tracker__c WHERE Record_Id__c=:recordId AND CreatedDate>=:pastFiveMin AND User__c=:userinfo.getUserId()];
        if(exsists.size()>0) return;
        //query record name 
        String name=getFieldApiForName(objectName);
        String query='SELECT Id,'+name+' FROM '+objectName+' WHERE Id=:recordId';
        List<Sobject> result=database.query(query);
        if(result.size()==0) return;
        //get object details
        DescribeSobjectResult objectDetails=SchemaUtil.getSobjectType(objectName);
        History_Tracker__c log=new History_Tracker__c();
        //insert log
        log.Object_Label__c=objectDetails.getLabel();
        log.Object__c=objectName;
        log.User__c=Userinfo.getUserId();
        log.Record_Id__c=String.valueOf(result.get(0).get('Id'));
        log.Record_Name__c=String.valueOf(result.get(0).get(name));
        log.RecordTypeId=Constant.TRACK_USAGE_HISTORY_RECORDTYPE_ID;
		insert log;
    }
}