public inherited sharing class MailUtility {
    
    public static Boolean sendAccountHtmlEmail(String contactId,String accountId,String emailTemplateId,String email){
        return sendSingleEmail(contactId,accountId,emailTemplateId,email,Constant.NOREPLOY_OW_EMAIL);
    }
    public static Boolean sendLeadHtmlEmail(String leadId,String emailTemplateId,String email){
        return sendSingleEmail(leadId,'',emailTemplateId,email,Constant.NOREPLOY_OW_EMAIL);
    }
    
    private static Boolean sendSingleEmail(String targetId,String whatId,String emailTemplateId,String email,String owdEmailId){
        if(true) return true;
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        if(String.isNotEmpty(targetId)) message.setTargetObjectId(targetId); 
        message.setOrgWideEmailAddressId(owdEmailId);
        message.setSaveAsActivity(false); 
        message.setTemplateID(emailTemplateId); 
        if(String.isNotEmpty(whatId)) message.setWhatId(whatId);
        message.toAddresses = new String[] { email};
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if (results[0].success) 
        {
            return true;
        } 
        else {
            System.debug('The email failed to send: ' +  results[0].errors[0].message);
            return false;
        }
    }
}