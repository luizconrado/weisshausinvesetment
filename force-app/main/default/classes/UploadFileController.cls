public class UploadFileController {
    
    
    private static File_Type_Option__mdt getConfigurations(String objectName,String recordId){
        String recordTypeName='';
        String query='SELECT id,recordType.DeveloperName FROM case WHERE id=:recordId';
        List<Sobject> records=Database.query(query);   
        if(records.size()>0){
            Map<String,Object> recordMap=(Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(records.get(0)));
            if(recordMap.containsKey('RecordType')){
                Map<String,Object> recordType=(Map<String,Object>)recordMap.get('RecordType');
                if(recordType.containsKey('DeveloperName')){
                    recordTypeName=String.valueOf(recordType.get('DeveloperName'));
                }
            }
        }
        List<File_Type_Option__mdt> config=[SELECT Types__c,Prefix_Field_Name__c FROM File_Type_Option__mdt WHERE Object_Name__c=:objectName
                                           AND Record_Type_Name__c=:recordTypeName AND Active__c=:true];
        if(config.size()>0) return config.get(0);
        List<File_Type_Option__mdt> defaultConfig=[SELECT Types__c,Prefix_Field_Name__c FROM File_Type_Option__mdt WHERE DeveloperName='Default' AND Active__c=:true];
        return defaultConfig.get(0);
    }
    
    
    
    @AuraEnabled
    public static List<String> getOptions(String objectName,String recordId){
        File_Type_Option__mdt config=getConfigurations(objectName,recordId);
        return config.Types__c.split(',');
    }
    
    @AuraEnabled
    public static List<ContentVersion> retriveTagedVersions(String objectName,String recordId,String tag){
        File_Type_Option__mdt config=getConfigurations(objectName,recordId);
        String query='SELECT id,'+config.Prefix_Field_Name__c.trim()+' FROM '+objectName+' WHERE id=:recordId';
        List<Sobject> records=Database.query(query);
        if(records.size()==0) return null;
        sobject record=records.get(0);
        String prefix=String.valueOf(record.get(config.Prefix_Field_Name__c.trim()));
        tag = prefix +' - '+tag;
        List<ContentDocumentLink> link=[SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId=:recordId];
        List<String> contentDocumentIds=new List<String>();
        For(ContentDocumentLink doc:link) contentDocumentIds.add(doc.ContentDocumentId);
        return [SELECT Id, ContentDocumentId,Title,ContentSize,Type__c,ContentModifiedDate,FileExtension,VersionNumber,ContentModifiedBy.Name FROM ContentVersion 
                WHERE Type__c =:tag AND ContentDocumentId IN: contentDocumentIds ORDER BY ContentModifiedDate DESC];
        
    }
    
    @AuraEnabled
    public static void tagVersionFiles(String objectName,String recordId,String tag,List<String> documnetIds){
        File_Type_Option__mdt config=getConfigurations(objectName,recordId);
        String query='SELECT id,'+config.Prefix_Field_Name__c.trim()+' FROM '+objectName+' WHERE id=:recordId';
        List<Sobject> records=Database.query(query);
        if(records.size()==0) return;
        sobject record=records.get(0);
        String prefix=String.valueOf(record.get(config.Prefix_Field_Name__c.trim()));
        tag = prefix +' - '+tag;
        List<ContentVersion> files=[SELECT Id, ContentDocumentId,Title,ContentSize,Type__c,ContentModifiedDate,FileExtension,VersionNumber,ContentModifiedBy.Name FROM ContentVersion 
                                    WHERE  ContentDocumentId IN: documnetIds ORDER BY ContentModifiedDate DESC];
        for(ContentVersion file:files){
            file.Title=tag +' - '+file.Title;
            file.Type__c=tag;
        }
        update files;
    }

   
}