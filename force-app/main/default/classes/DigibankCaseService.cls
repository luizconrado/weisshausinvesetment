public with sharing class DigibankCaseService {
    
    @AuraEnabled
    public static String fetchBugBody(String caseId){
        String emailBody='';
        List<Case> casesDetails=[SELECT Internal_Description__c ,Id,Subject,Description,Occurrence_Of_Issue__c,Expected_Result__c,Actual_Result__c,
                                 Phone_OS__c,Phone_Model__c,App_Version__c
                                 FROM Case WHERE Id=:caseId];
        if(casesDetails.size()>0){
            Case caseDetails=casesDetails.get(0);
            emailBody += 'Description';
            emailBody += '\n';
            emailBody += '\n';
            if(caseDetails.Description!=null) emailBody += caseDetails.Description;
            emailBody += '\n';
            emailBody += '\n';
            emailBody += 'Expected Result';
            emailBody += '\n';
            if(caseDetails.Expected_Result__c!=null) emailBody += caseDetails.Expected_Result__c;
            emailBody += '\n';
            emailBody += '\n';
            emailBody += 'Actual Result';
            emailBody += '\n';
            if(caseDetails.Actual_Result__c!=null) emailBody += caseDetails.Actual_Result__c;
            emailBody += '\n';
            emailBody += '\n';
            emailBody += 'Occurrence of issue (time and date)';
            emailBody += '\n';
            if(caseDetails.Occurrence_Of_Issue__c!=null) emailBody += caseDetails.Occurrence_Of_Issue__c?.format();
            emailBody += '\n';
            emailBody += '\n';
            emailBody += 'Phone Model';
            emailBody += '\n';
            if(caseDetails.Phone_Model__c!=null) emailBody += caseDetails.Phone_Model__c;
            emailBody += '\n';
            emailBody += '\n';
            emailBody += 'Phone OS';
            emailBody += '\n';
            if(caseDetails.Phone_OS__c!=null) emailBody += caseDetails.Phone_OS__c;
            emailBody += '\n';
            emailBody += '\n';
            emailBody += 'App Version';
            emailBody += '\n';
            if(caseDetails.App_Version__c!=null) emailBody += caseDetails.App_Version__c;
            emailBody += '\n';
            
        }
        return emailBody;
    }
    
    @AuraEnabled
    public static Boolean prepareBugInfoBody(String caseId,String bugBody,String bugSubject){
        Boolean success=false;
        List<Case> casesDetails=[SELECT Internal_Description__c ,Id,Subject,Description,Occurrence_Of_Issue__c,Expected_Result__c,Actual_Result__c,
                                 Phone_OS__c,Phone_Model__c,App_Version__c
                                 FROM Case WHERE Id=:caseId];
        if(casesDetails.size()>0){
            Case caseDetails=casesDetails.get(0);
            String description='Subject';
            description+='\n';
            description+=bugSubject;
            description+='\n';
            description+='\n';
            description+='Body';
            description+='\n';
            caseDetails.Internal_Description__c=description;
            caseDetails.Submitted_FLC_Date__c=DateTime.now();
            caseDetails.Status='Ticket Reported';
            List<ContentVersion> cvFiles=getAttachedFileIds(caseId);
            List<String> cvIds=new List<String>();
            for(ContentVersion cv:cvFiles) cvIds.add(cv.Id);
            success = sendUSerEmail(cvIds,bugSubject,bugBody,caseDetails.id);
            update caseDetails;
        }
        return success;
    }
    
    private static List<ContentVersion> getAttachedFileIds(String recordId){
        List<ContentDocumentLink> cdlList=[SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId=:recordId];
        List<String> cdIds=new List<String>();
        for(ContentDocumentLink cdl:cdlList)cdIds.add(cdl.ContentDocumentId);
        List<ContentVersion> filesList=[SELECT id FROM ContentVersion WHERE ContentDocumentId IN:cdIds AND Type__c LIke '%Digibank'];
        return filesList;
    }
    
    private static Boolean sendUSerEmail(List<String> fileIds,String emailSubject,String body,String caseId){
        List<OrgWideEmailAddress> owds=[SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE Address='support@ev-smartmoney.com'];
        Boolean success=false;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if(owds.size()>0) mail.setOrgWideEmailAddressId(owds.get(0).Id);
        mail.setUseSignature(false);
        mail.setWhatId(caseId); 
        mail.setToAddresses(new String[] { System.label.DigibankSupport_Email });//Set To Email Address
        mail.setSubject(emailSubject);
        String bodyTemplate=templateStart();
        bodyTemplate+=body.replaceAll('\n','<Br/>');
        bodyTemplate+=templateEnd();
        mail.setHtmlBody(bodyTemplate); 
        mail.setEntityAttachments(fileIds);//Set Document Attachment
        mail.setSaveAsActivity(true);
        List<Messaging.SendEmailResult>  result=Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });//Send Email
        for(Messaging.SendEmailResult rr:result){
            success=rr.isSuccess(); 
            System.debug('Email Status ' + rr.IsSuccess());
            System.debug('Email result ' + rr.getErrors());
            
            if(!rr.IsSuccess())  logEmailError(caseId, JSON.serialize(rr.getErrors()));
            
        }  
        return success;
    }
    
    private static String templateStart(){
        return '<!DOCTYPE html> <html style="overflow-y: hidden;"> <head> <title></title> </head> <body style="margin: 0px; height: auto; min-height: auto;"> <div style="background-color: #f6f6f6;font-family: sans-serif;"> <div style="display: block;margin: 0 auto !important;max-width: 580px;padding: 10px;width: 580px;"> <div style="box-sizing: border-box;background: url(https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0155I000000dP6n&oid=00D5I000002GOw0&lastMod=1611845345000) repeat;display: block;margin: 0 auto;max-width: 580px;padding: 10px;"> <div style="text-align: center;padding-bottom: 10px;padding-top: 10px;"><img src="https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0155I000000cWLT&oid=00D5I000002GOw0&lastMod=1609923772000" style="text-align: right; width: 207px; border: 0; text-decoration:none; vertical-align: baseline;" width="200" /></div> </div> <div style="line-height: 1.4;box-sizing: border-box;padding: 20px;font-size: 14px;background: #ffffff;border-radius: 3px;width: 100%;">&nbsp; <p>';
    }
    private static String templateEnd(){
        return '</p> </div> <div style="line-height: 1.4;padding-bottom: 10px;padding-top: 10px;color: #999999;font-size: 12px;text-align: center;"> <p>Sie erhalten diese E-Mail, da Ihre E-Mail-Adresse auf <a href="mailto:support@ev-smartmoney.com" style="color: inherit !important; font-family: inherit !important; font-size: inherit !important; font-weight: inherit !important; line-height: inherit !important; text-decoration: none !important;" target="_blank">support@ev-smartmoney.com</a> registriert ist.</p> <p>Wenn Sie Fragen oder R&uuml;ckmeldungen haben sind wir per E-Mail unter <a href="mailto:support@ev-smartmoney.com" style="color: inherit !important; font-family: inherit !important; font-size: inherit !important; font-weight: inherit !important; line-height: inherit !important; text-decoration: none !important;" target="_blank">support@ev-smartmoney.com</a> oder unter folgender Telefonnummer gerne f&uuml;r Sie da: +49 30 74395959 (Mo-Fr: 9-18 Uhr)</p> <p>Copyright &copy; 2020 EV Smart Money Holding GmbH | HRB 215045 B | Amtsgericht Charlottenburg | Lizenzpartner der Engel &amp; V&ouml;lkers Marken GmbH &amp; Co. KG | Klaus-Groth-Stra&szlig;e 3, 14050 Berlin, Germany. | Gesch&auml;ftsf&uuml;hrung: Dr. Kyros Khadjavi</p> </div> </div> </div> </body> </html> ';
    }
    @testVisible
    private static void logEmailError(String recordID,String errorMsg){
        LogService.LogMetadata details=New LogService.LogMetadata();
        details.addMetadataInfo(userinfo.getUserId(),'DigibankCaseService','prepareBugInfoBody','EVKontoCaseSendBugMail','Send EV Konto Mail');
        details.addRecordInfo('Case', recordId);
        details.errorMessage= errorMsg;
        LogService.logError(details);
    }
}