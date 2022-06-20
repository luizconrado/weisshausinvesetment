/***************
* @group Utility Class
* @description helper class to send email form system
*/
public  inherited sharing class MailUtill {
    
    //1. returns all index values of merge field refrense in string
    private static List<Integer> findIndexInString(String sentence,String keyword){
        List<Integer> listOfIndexs=new List<Integer>();
        
        //getting first index
        Integer index = sentence.indexOf(keyword);
        while (index >=0){
            listOfIndexs.add(index);
            //updating index
            index = sentence.indexOf(keyword, index+keyword.length());
        }
        return listOfIndexs;
    }
    
    //2. returns all merge field names in string
    private static List<String> findFieldsInTemplate(String emailTemplate,Boolean isClassic){
        String START_PARAMETER=(isClassic)?'{!':'{{';
        STRING END_PARAMETER=(isClassic)?'}':'}}';
        List<Integer> fieldOccurance=findIndexInString(emailTemplate,START_PARAMETER);
        List<String> fieldNameList=new List<String>();
        for(Integer i:fieldOccurance){
            fieldNameList.add(emailTemplate.substring(i, emailTemplate.length()).substringBetween(START_PARAMETER,END_PARAMETER));
         }
        
        return fieldNameList;
     }
    
    //3. returns pair of merge field and its reqpective query field 
    private static Map<String,String> proccessEmailTempalateFields(List<String> fieldList){
        Map<String,String> fieldAndRelationMap=new Map<String,String>();
        for(String field:fieldList){
            List<String>  objectAndRelation=field.split('\\.');
            if(!fieldAndRelationMap.containsKey(field)) fieldAndRelationMap.put(field,'');
            fieldAndRelationMap.put(field,objectAndRelation.get(0).replace('__c','__r')+'.'+objectAndRelation.get(1));
        }
        
        return fieldAndRelationMap;
    }
    
    //4. returns pair of merge field and its respective value
    private static Map<String,String> processFieldValues(Map<String,String> fieldRelationMap,String ObjectName,String recordId){
        String query='SELECT Id,';
        query+=String.join(fieldRelationMap.values(),',');
        query+= ' FROM '+ObjectName+' ';
        query += 'WHERE id=:recordId';
        List<Object> queryResult=Database.query(query);
        if(queryResult.size()>0){
            //converting result to json
            Map<String,Object> queryResultMap=(Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(queryResult.get(0)));
            //looping all fields
            for(String field:fieldRelationMap.keySet()){
                //getting relation field 
                String lookupRelation=fieldRelationMap.get(field);
                List<String> fieldRelation=lookupRelation.split('\\.');
                String value='';
                //checking if it is lookup field
                if(fieldRelation.get(0)!=ObjectName && queryResultMap.containsKey(fieldRelation.get(0))){
                    Map<String,Object> lookupFieldValues=(Map<String,Object>) queryResultMap.get(fieldRelation.get(0));
                    if(lookupFieldValues.containsKey(fieldRelation.get(1))){
                        value=String.valueOf(lookupFieldValues.get(fieldRelation.get(1)));	
                    }
                }
                else if(queryResultMap.containsKey(fieldRelation.get(1))){
                    value=String.valueOf(queryResultMap.get(fieldRelation.get(1)));
                }
                fieldRelationMap.put(field,value);    
            }
            
        }
        return fieldRelationMap;
    }
    
    //returns email with replaced value
    public static string proccessEmailTemplate(String htmlValue,Boolean isClassic,String objectName,String recordId){
        List<String> fields=findFieldsInTemplate(htmlValue,isClassic);
        Map<String,String> fieldRelationMap=proccessEmailTempalateFields(fields);
        fieldRelationMap=processFieldValues(fieldRelationMap,objectName,recordId);
        String START_PARAMETER=(isClassic)?'{!':'{{';
        STRING END_PARAMETER=(isClassic)?'}':'}}';
        for(String mergeField:fieldRelationMap.keySet()){
            htmlValue=htmlValue.replace(START_PARAMETER+mergeField+END_PARAMETER, fieldRelationMap.get(mergeField));
        }
        
        return htmlValue;
    }
    
    public static Boolean sendPlainHtmlEmail(String emailSubject,String body,String toAddress,String OWDId,String recordID){
        Boolean success=false;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setOrgWideEmailAddressId(OWDId);
        mail.setUseSignature(false);
        mail.setWhatId(recordID); 
        //mail.setInReplyTo(param1);
        mail.setToAddresses(new String[] {toAddress });
        mail.setSubject(emailSubject);
        mail.setHtmlBody(body); 
        mail.setSaveAsActivity(true);
        List<Messaging.SendEmailResult>  result=Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });//Send Email
        for(Messaging.SendEmailResult rr:result){
            success=rr.isSuccess(); 
            System.debug('Email Status ' + rr.IsSuccess());
            System.debug('Email result ' + rr.getErrors());
            
            if(!rr.IsSuccess())  logEmailError(recordID, JSON.serialize(rr.getErrors()),'sendEmail');
            
        }  
        return success;
    }
    

    //sends email with attachmets
    public static Boolean sendEmailWithAttachment(String emailSubject,String body,List<String> contentVersionIds,String toAddress,String OWDId,String recordID){
        Boolean success=false;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setOrgWideEmailAddressId(OWDId);
        mail.setUseSignature(false);
        mail.setWhatId(recordID); 
        //mail.setInReplyTo(param1);
        mail.setToAddresses(new String[] {toAddress });
        mail.setSubject(emailSubject);
        
        mail.setHtmlBody(body); 
        mail.setEntityAttachments(contentVersionIds);//Set Document Attachment
        mail.setSaveAsActivity(true);
        List<Messaging.SendEmailResult>  result=Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });//Send Email
        for(Messaging.SendEmailResult rr:result){
            success=rr.isSuccess(); 
            System.debug('Email Status ' + rr.IsSuccess());
            System.debug('Email result ' + rr.getErrors());
            
            if(!rr.IsSuccess())  logEmailError(recordID, JSON.serialize(rr.getErrors()),'sendEmailWithAttachment');
            
        }  
        return success;
    }
    
    //send email with email tempalte
    public static Boolean sendTemplateEmail(String toAddress,String reciverId,String accociatedRecordId,String emailTemplateId,String OWDId){
        Boolean success=false;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setOrgWideEmailAddressId(OWDId);
        mail.setUseSignature(false);
        mail.setTargetObjectId(reciverId); 
        mail.setTemplateID(emailTemplateId); 
        mail.setWhatId(accociatedRecordId); 
        mail.setToAddresses(new String[] {toAddress });
        mail.setSaveAsActivity(true);
        try{
            List<Messaging.SendEmailResult>  result=Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });//Send Email
            for(Messaging.SendEmailResult rr:result){
                success=rr.isSuccess(); 
                System.debug('Email Status ' + rr.IsSuccess());
                System.debug('Email result ' + rr.getErrors());
                
                if(!rr.IsSuccess())  logEmailError(accociatedRecordId, JSON.serialize(rr.getErrors()),'sendEmail');
            }  
        }
        catch(Exception e){
            System.debug('Email Status ' + e.getMessage());
            System.debug('Email result ' + e.getStackTraceString());
            success=false;
            logEmailError(accociatedRecordId, JSON.serialize(e.getMessage()),'sendEmail');
        }
        return success;
    }
    
    @testVisible
    private static void logEmailError(Id recordID,String errorMsg,String method){
        LogService.LogMetadata details=New LogService.LogMetadata();
        details.addMetadataInfo(userinfo.getUserId(),'MailUtill',method,'','Send Mail');
        details.addRecordInfo(recordID.getSobjectType().getDescribe().getName(), recordID);
        details.errorMessage= errorMsg;
        LogService.logError(details);
    }
    
    
}