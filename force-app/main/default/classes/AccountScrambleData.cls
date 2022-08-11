/***************
* @group Queueable Class
* @description Class Responsible for anonimizing data of account and related records based on configuration settings Scramble_Configuration__c
*  Push Test
*/
public without sharing class AccountScrambleData implements Queueable {
    List<String> accountIdList=new List<String>();
    final String PLACEHOLDER='[SCRAMBLEDATA]';
    final String USER_ROLE='All Data Access';
    final String PICKLIST_PLACEHOLDER='Anonymized';
    List<Scramble_Configuration__c> scrambleConfiguration{private set;get{
        if(scrambleConfiguration==null) scrambleConfiguration=[SELECT id,Field__c,IsReference__c,Object__c FROM Scramble_Configuration__c];
        return  scrambleConfiguration;
    }}
    final String userForHiddineRole{private set;get{
        if(userForHiddineRole==null){
            List<User> users=[SELECT Id, UserRoleId FROM User WHERE UserRole.Name=:USER_ROLE AND isActive=true];
            if(users.size()>0) userForHiddineRole=users.get(0).Id;
        }
        return userForHiddineRole;
    }} 
        
      
    public AccountScrambleData(List<String> accountIds){
        accountIdList=accountIds;
    }
    
    /* Description : Scrambles all pii information configured in Scramble_Configuration__c
     * 1. Scrambles all non nulable fields
     * 2. logs error if filed cannot be updated 
	*/
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
                    /* we dont have this user due to license constrains
                    if(objectName=='Account'){
                        if( userForHiddineRole!=null){
                            obj.put('OwnerId',userForHiddineRole);
                        }
                    } 
					*/
                    
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
                            else if(field.getType() == Schema.DisplayType.BOOLEAN){
                                obj.put(field.getName(),false);
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
            
        }catch(Exception e){logError(null,null,'execute',e);}
    }
    
    //7 parse record error'
     @testVisible
    private void logRecordError(List<Database.SaveResult> updateResult){
        for (Database.SaveResult r : updateResult)
        {
            if (!r.isSuccess())    for (Database.Error e : r.getErrors()) logError(r.getId(), e.getMessage()+' : '+e.getFields(),'logRecordError',null);
        }
    }
     
    //6 log error
    @testVisible
    private void logError(String errorMessage,String stacktrace,String method,Exception error){
        LogService.LogMetadata metadata=new LogService.LogMetadata();
        metadata.addMetadataInfo(userinfo.getUserId(), 'AccountScrambleData',method,'Trigger','Scramble Data');
        metadata.addComment(String.join(accountIdList, ','));
        if(error!=null)metadata.addError(error);
        else metadata.addErrorString(errorMessage,stacktrace);
        LogService.logError(metadata);
        
    }
    
    //5.scramble data
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
            DateTime dt=DateTime.now();
            String dtNow=JSON.serialize(dt);
            dtNow=dtNow.replace('"','').replace('-','').replace(':','').replace('.','');
            return RandomUtil.randomString(3)+dtNow+'@'+RandomUtil.randomString(4)+'.eu';
        } 
        else if(fieldType.getType()==Schema.DisplayType.Phone){
            return String.valueOf(RandomUtil.randomNumber(10));
        }
        else if(fieldType.getType()==Schema.DisplayType.Picklist || fieldType.getType()==Schema.DisplayType.MultiPicklist){
            return PICKLIST_PLACEHOLDER;
        }
        return  RandomUtil.randomString(6);
         
    }
    
    //4.get fields that needs to be scrambled
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
    
    //3. query Objects
    @testVisible
    private Map<String,List<Sobject>> queryDatabase(Map<String,String> queryAndObjectMap){
        Map<String,List<Sobject>> databaseResultMap=new Map<String,List<Sobject>>();
        for(String objectName:queryAndObjectMap.keySet()){
            System.debug('Query '+queryAndObjectMap.get(objectName));
            databaseResultMap.put(objectName,Database.query(queryAndObjectMap.get(objectName)));
        }
        return databaseResultMap;
    }
    
    //2.generate querys
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
        
    //1.configure querys
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
