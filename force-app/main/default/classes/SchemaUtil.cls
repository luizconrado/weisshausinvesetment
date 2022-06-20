public inherited sharing class SchemaUtil {
    public static String getRecordTypeId(final String recordTypeDevName, final String objectAPIName) {
        Schema.DescribeSObjectResult sobjectResult = Schema.getGlobalDescribe().get(objectAPIName).getDescribe();
        if (sobjectResult != null) {
            List<Schema.RecordTypeInfo> recordTypeInfo = sobjectResult.getRecordTypeInfos();
            for (Schema.RecordTypeInfo info : recordTypeInfo) {
                if (info.getDeveloperName() == recordTypeDevName) {
                    return info.getRecordTypeId();
                }
            }
        }
        return '';
    }
    public static Map<String, DescribeFieldResult> getAllObjectFields(String sObjectApiName) {
        Schema.DescribeSObjectResult[] results = Schema.describeSObjects(new String[]{
            sObjectApiName
                });
        DescribeSObjectResult sObjectName = results[0];
        Map<String, DescribeFieldResult> listOfObjectFields = new Map<String, DescribeFieldResult>();
        
        for (SObjectField f : sObjectName.fields.getMap().values()) {
            DescribeFieldResult field = f.getDescribe();
            listOfObjectFields.put(field.getName(), field);
        }
        return listOfObjectFields;
    }
    public static Map<String,PicklistEntry[]> getObjectPicklistFileds(DescribeSObjectResult sObjectName){
        Map<String,PicklistEntry[]> picklistValues=new Map<String,PicklistEntry[]>();
        for (SObjectField f : sObjectName.fields.getMap().values()) {
            DescribeFieldResult field = f.getDescribe();
            if(field.getType()===Schema.DisplayType.Picklist){
                picklistValues.put(field.getName(),field.getPicklistValues());
            }
        }
        return picklistValues;
    }
    public static DescribeSobjectResult getSobjectType(String objectApiName){
        Schema.DescribeSobjectResult[] results = null;
        try{
        results=Schema.describeSObjects(new String[] { objectApiName });
        }catch(Exception e){}
        return (results!=null)?results[0]:null;
    }
    
    //Pass dependent field parameter e.g.: Account.YourDependentField__c
    public static Map<Object,List<String>> getDependentPicklistValues(Schema.sObjectField dependentField){
        Map<Object,List<String>> dependentPicklistValues = new Map<Object,List<String>>();
        //Get dependent field result
        Schema.DescribeFieldResult dependentFieldResult = dependentField.getDescribe();
        //Get dependent field controlling field 
        Schema.sObjectField controllerField = dependentFieldResult.getController();
        //Check controlling field is not null
        if(controllerField == null)  return null;
        //Get controlling field result
        Schema.DescribeFieldResult controllerFieldResult = controllerField.getDescribe();
        //Get controlling field picklist values if controlling field is not a checkbox
        List<Schema.PicklistEntry> controllerValues = (controllerFieldResult.getType() == Schema.DisplayType.Boolean ? null : controllerFieldResult.getPicklistValues());
        
        //It is used to decode the characters of the validFor fields. 
        String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
        
        for (Schema.PicklistEntry entry : dependentFieldResult.getPicklistValues()){
            if (entry.isActive()){
                //The PicklistEntry is serialized and deserialized using the Apex JSON class and it will check to have a 'validFor' field
                List<String> base64chars = String.valueOf(((Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')).split('');
                for (Integer i = 0; i < controllerValues.size(); i++){
                    Object controllerValue = (controllerValues == null ? (Object) (i == 1) : (Object) (controllerValues[i].isActive() ? controllerValues[i].getLabel() : null));
                    Integer bitIndex = i / 6;
                    Integer bitShift = 5 - Math.mod(i, 6 );
                    try{
                        if(controllerValue == null || (base64map.indexOf(base64chars[bitIndex]) & (1 << bitShift)) == 0){
                            continue;
                        } 
                    }catch(Exception e){}
                    if (!dependentPicklistValues.containsKey(controllerValue)){
                        dependentPicklistValues.put(controllerValue, new List<String>());
                    }
                    dependentPicklistValues.get(controllerValue).add(entry.getLabel());
                }
            }
        }
        return dependentPicklistValues;
    }
}