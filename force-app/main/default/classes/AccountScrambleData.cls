
/***************
* @group Queueable
* @description Sramble field data based on configuration provided in Scramble_Configuration__c custom setting
*/
public without sharing class AccountScrambleData implements Queueable {
    List<String> accountIdList=new List<String>();
    final String PLACEHOLDER='[SCRAMBLEDATA]';
    final String USER_ROLE='All Data Access';

    /***************
    * @description retrives all configuration from Scramble_Configuration__c
    */
    List<Scramble_Configuration__c> scrambleConfiguration{private set;get{
        if(scrambleConfiguration==null) scrambleConfiguration=[SELECT id,Field__c,IsReference__c,Object__c FROM Scramble_Configuration__c];
        return  scrambleConfiguration;
    }}
    
    /***************
    * @description default user to update owner id 
    */
    final String userForHiddineRole{private set;get{
        if(userForHiddineRole==null){
            List<User> users=[SELECT Id, UserRoleId FROM User WHERE UserRole.Name=:USER_ROLE AND isActive=true];
            userForHiddineRole=users.get(0).Id;
        }
        return userForHiddineRole;
    }}
        
    
    public AccountScrambleData(List<String> accountIds){
        accountIdList=accountIds;
    }
    
     
    public void execute(QueueableContext context) {
        try{
            Map<String,List<Sobject>> toUpdate=new Map<String,List<Sobject>>();
            Map<String,String> queryConfigurationMap=getConfigurations();
            Map<String,String> queryAndObjectMap=getQuerys(queryConfigurationMap,accountIdList);
            Map<String,List<Sobject>> queryResult=queryDatabase(queryAndObjectMap);
            Map<String,List<DescribeFieldResult>> scrambleFields=getFieldsToScramble();
            
            for(String objectName:queryResult.keySet()){
                List<Sobject> dbResult=queryResult.get(objectName);
                List<DescribeFieldResult> fieldsToScramble=scrambleFields.get(objectName);
                for(Sobject obj:dbResult){
                    if(objectName=='Account'){
                        //change default user for scrambled records
                        if( userForHiddineRole!=null){
                            obj.put('OwnerId',userForHiddineRole);
                        }
                    }  
                    
                    for(DescribeFieldResult field:fieldsToScramble){
                        if(obj.get(field.getName()) !=null){
                            String scrambledData=getScrambledData(field);
                            if(field.getType()==Schema.DisplayType.Date){
                                obj.put(field.getName(),Date.valueOf(scrambledData));    
                            }
                            else if(field.getType()==Schema.DisplayType.DateTime){
                                obj.put(field.getName(),DateTime.valueOf(scrambledData));    
                            }
                            else if(field.getType()==Schema.DisplayType.Double || field.getType()==Schema.DisplayType.Integer || field.getType()==Schema.DisplayType.CURRENCY){
                                obj.put(field.getName(),Double.valueOf(scrambledData));    
                            }
                            else{
                            	obj.put(field.getName(),scrambledData);        
                            }
                            
                        } 
                    }

                    if(!toUpdate.containsKey(objectName)) toUpdate.put(objectName,new List<Sobject>());
                    toUpdate.get(objectName).add(obj);
                }
            }

            for(List<Sobject> objResults:toUpdate.values()) logRecordError(Database.update(objResults,false));
            
        }catch(Exception e){logError(null,null,e);}
    }
    
    /***************
    * @description parse database update errors and insert to log object
    * @param updateResult result of databse.update 
    */
    @testVisible
    private void logRecordError(List<Database.SaveResult> updateResult){
        for (Database.SaveResult r : updateResult)
        {
            if (!r.isSuccess())    for (Database.Error e : r.getErrors()) logError(r.getId(), e.getMessage(),null);
        }
    }
     
    /***************
    * @description logs error
    * @param errorMessage error message
    * @param stacktrace error stacktrace
    * @param error Exception 
    */
    @testVisible
    private void logError(String errorMessage,String stacktrace,Exception error){
        LogService.LogMetadata metadata=new LogService.LogMetadata();
        metadata.addMetadataInfo(userinfo.getUserId(), 'AccountScrambleData', 'execute',null,'Scramble Data');
        if(error!=null)metadata.addError(error);
        else metadata.addErrorString(errorMessage,stacktrace);
        
        LogService.logError(metadata);
        
    }
    
    /***************
    * @description generate random data based on field type
    * @param fieldType field type for which random data is needed
    * @return string random string
    */
    @testVisible
    private string getScrambledData(DescribeFieldResult fieldType){
        if(fieldType.getType()==Schema.DisplayType.Date){
            return String.valueOf(Date.today());
        }
        else if(fieldType.getType()==Schema.DisplayType.DateTime){
            return String.valueOf(Datetime.now());
        }
        else if(fieldType.getType()==Schema.DisplayType.Double || fieldType.getType()==Schema.DisplayType.Integer || fieldType.getType()==Schema.DisplayType.CURRENCY){
            return String.valueOf(RandomUtil.randomNumber(2));
        }
        else if(fieldType.getType()==Schema.DisplayType.Email){
            return RandomUtil.randomString(5)+'@'+RandomUtil.randomString(4)+'.eu';
        } 
        else if(fieldType.getType()==Schema.DisplayType.Picklist){
            return fieldType.getPicklistValues().get(0).getValue();
        }
        return  RandomUtil.randomString(6);
         
    }
    
    /***************
    * @description prepare field list of each object for which data need to be scrambled
    * @return Map<String,List<DescribeFieldResult>>  map of object and list of fields whose data needs to be scrambled
    */
    @testVisible
    private Map<String,List<DescribeFieldResult>> getFieldsToScramble(){
        Map<String,List<DescribeFieldResult>> objectAndFieldList=new Map<String,List<DescribeFieldResult>>();
        List<Scramble_Configuration__c> fields=scrambleConfiguration;
        for(Scramble_Configuration__c field:fields){
            if(!objectAndFieldList.containsKey(field.Object__c)) objectAndFieldList.put(field.Object__c,new List<DescribeFieldResult>());
            
            Map<String, DescribeFieldResult> fieldDescribe = SchemaUtil.getAllObjectFields(field.Object__c);
            
            if(!field.IsReference__c) objectAndFieldList.get(field.Object__c).add(fieldDescribe.get(field.Field__c));
        }
        return objectAndFieldList;
    }
    
    /***************
    * @description querys database to fetch records
    * @param queryAndObjectMap key value pair of object and query 
    * @return Map<String,List<Sobject>> map of object name and list of records 
    */
    @testVisible
    private Map<String,List<Sobject>> queryDatabase(Map<String,String> queryAndObjectMap){
        Map<String,List<Sobject>> databaseResultMap=new Map<String,List<Sobject>>();
        for(String objectName:queryAndObjectMap.keySet()){
            databaseResultMap.put(objectName,Database.query(queryAndObjectMap.get(objectName)));
        }
        return databaseResultMap;
    }
    
    /***************
    * @description preapres fully qualified query by replacing account id in where condition
    * @param querys map of object and query returnd from getConfigurations()
    * @param accountIdList list of account ids whose data needs to be scrabled
    * @return Map<String,String> returns key value pair of obejct and fully qualified query
    */
    @testVisible
    private Map<String,String> getQuerys(Map<String,String> querys,List<String> accountIdList){
        Map<String,String> objectAndQueryMap=new Map<String,String>();
        String accountIds='(';
        for(String id:accountIdList) accountIds+='\''+id+'\',';
        accountIds=accountIds.removeEnd(',');
        accountIds+=')';
        for(String objectName:querys.keySet()) objectAndQueryMap.put(objectName,querys.get(objectName).replace(PLACEHOLDER,accountIds ));
        return objectAndQueryMap;
    }
        
    /***************
    * @description creates soql querys for each object that is configured
    * @return  Map<String,String> : key is object name and value is soql query
    */
    @testVisible
    private Map<String,String> getConfigurations(){
        List<Scramble_Configuration__c> fields=scrambleConfiguration;
        if(fields.size()==0) return null;
        Map<String,List<String>> objectAndFieldsMap=new Map<String,List<String>>();
        Map<String,String> objectAndRelationMap=new Map<String,String>();
        for(Scramble_Configuration__c field:fields){
            
            if(!objectAndFieldsMap.containsKey(field.Object__c)) objectAndFieldsMap.put(field.Object__c,new List<String>());
            
            if(field.IsReference__c) objectAndRelationMap.put(field.Object__c,field.Field__c);
            
            if(!field.IsReference__c) objectAndFieldsMap.get(field.Object__c).add(field.Field__c);
            
        }
        Map<String,String> querys=new Map<String,String>();
        for(String objectName:objectAndFieldsMap.keySet()){
            String fieldsQuery='SELECT Id,';
            if(objectName=='Account')fieldsQuery+='OwnerId,';
            fieldsQuery+=string.join(objectAndFieldsMap.get(objectName), ',');
            String objectQuery=' FROM '+objectName;
            String whereQuery= ' WHERE '+objectAndRelationMap.get(objectName)+' IN '+PLACEHOLDER;    
            querys.put(objectName,fieldsQuery+objectQuery+whereQuery);
        }
        
        return querys;
    }
    
    
    

}