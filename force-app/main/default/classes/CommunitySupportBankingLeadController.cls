/***************
* @group Controller Class
* @description class responsible for logic behind lwc component "support_kontoform" , creates a lead 
* Ref :  https://qa01-evsmartmoney.cs107.force.com/support/s/kontoanmeldung?language=de
*/
public without sharing class CommunitySupportBankingLeadController {
    
    
    @AuraEnabled
    public static Boolean createBankingLead(String salutation,String firstName,String lastName,String emailAddress,Map<String,String> utmParameters){
        Boolean status=false;
        try{
            LeadService.Service service=new LeadService.Service();
            service.createLead(salutation,firstName, lastName, emailAddress,true,'Website',utmParameters,Constant.LEAD_BANKING_CUSTOMER_RECORDTYPEID);
            status=true;
        }
        Catch(Exception e){
            String errorId=logError(e,null,'Lead','support_kontoform','createBankingLead',emailAddress+' : '+firstName+' : '+lastName,'Create Banking Lead');
            status=false;
        }
        return status;
    } 
    
    @testVisible
    private static String logError(Exception e,String recordID,String objectName,String componentName,String methodName,String comment,String operation){
        LogService.LogMetadata details=new LogService.LogMetadata();
        details.addError(e);
        details.addRecordInfo(objectName,recordId);
        details.addComment(comment);
        details.addMetadataInfo(userinfo.getUserId(),'CommunitySupportBankingLeadController', methodName, componentName, operation);
        return LogService.logError(details);
    }


}