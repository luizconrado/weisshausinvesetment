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
  
    public static DescribeSobjectResult getSobjectType(String objectApiName){
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(new String[] { objectApiName });
        return results[0];
    }
}