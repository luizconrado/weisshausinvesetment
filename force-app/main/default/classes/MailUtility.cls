public inherited sharing class MailUtility {
    
    public static Boolean sendAccountHtmlEmail(String contactId,String accountId,String emailTemplateId,String email){
        
        return sendSingleEmail(contactId,accountId,emailTemplateId,email,getOWAId());
    }
    public static Boolean sendLeadHtmlEmail(String leadId,String emailTemplateId,String email){
        return sendSingleEmail(leadId,'',emailTemplateId,email,getOWAId());
    }
    private static String getOWAId(){
        Email_Configuration__c config = Email_Configuration__c.getOrgDefaults();
        String displayname=config.Organization_Wide_Address__c;
        System.debug('displayname '+displayname);
        if(String.isEmpty(displayname)) displayname='Support';
        System.debug('displayname '+displayname);

        List<OrgWideEmailAddress>  addresses=[SELECT Id, DisplayName, Address FROM OrgWideEmailAddress where DisplayName=:displayname ];
        return (addresses.size()>0)?addresses.get(0).Id:'';
    }
    
    private static Boolean sendSingleEmail(String targetId,String whatId,String emailTemplateId,String email,String owdEmailId){
        try{
        if(Util.checkEmailPermission(emailTemplateId)==false) return false;
        if(String.isEmpty(owdEmailId)) return false;
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        if(String.isNotEmpty(targetId)) message.setTargetObjectId(targetId); 
        message.setOrgWideEmailAddressId(owdEmailId);
        message.setSaveAsActivity(false); 
        message.setTemplateID(emailTemplateId); 
        if(String.isNotEmpty(whatId)) message.setWhatId(whatId);
        message.toAddresses = new String[] { email};
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if (results[0].success)  return true; 
        else { System.debug('The email failed to send: ' +  results[0].errors[0].message);return false; }
        }
        catch(Exception e){   System.debug('The email failed to send: ' +  e.getMessage());return false;}
        
           
       
    }
}