public class  OpportuntiyInvestmentService {
    
    @AuraEnabled
    public static void sendMoneyTransferConformation(String oppId){
        try{         
            Opportunity oppDetails=[SELECT Id,External_Id__c ,Account.EVSM_Auth0_Id__c,Account.Solarisbank_Tenent__c,Is_Money_Transferred__c, Money_Transfer_Confirmed_By__c FROM Opportunity WHERE id=:oppId];
            if(!oppDetails.Is_Money_Transferred__c && String.isNotEmpty(oppDetails.External_Id__c) && oppDetails.External_Id__c!=null){
                LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(oppDetails.Id,'Opportunity',oppDetails.Account.Solarisbank_Tenent__c);
                DateTime dt=DateTime.now();
                DateTime dtGmt=Datetime.valueOfGmt(String.valueOf(dt));
                String gmtDTString=JSON.serialize(dtGmt);
                String body='{"moneyTransferred":true,"moneyTransferredAt":'+gmtDTString+'}';
                String statusResponse=EVExternalService.updateInvestmentUpdate(oppDetails.External_Id__c,oppDetails.Account.EVSM_Auth0_Id__c,body,apiCallDetails);
                oppDetails.Is_Money_Transferred__c=true;
                oppDetails.Money_Transfer_Confirmed_By__c=Userinfo.getUserId();
                oppDetails.StageName='WAIT_FOR_START_DATE';
                update oppDetails;
            }
        }
        catch(Exception e){
            String index = logError(e,oppId,'Opportunity','OpportuntiyInvestmentService','sendMoneyTransferConformation','SMI Money Transfer Conformation');
            throw new AuraHandledException('Please contact your System admin.And provide '+index+' id to resolve issue.');
        }
    }
    
    
     @AuraEnabled
    public static void sendInvestmentStatus(String oppId){
        try{         
            Opportunity oppDetails=[SELECT Id,StageName,Account.EVSM_Auth0_Id__c,External_Id__c,Account.Solarisbank_Tenent__c FROM Opportunity WHERE id=:oppId];
            if(String.isNotEmpty(oppDetails.External_Id__c) && oppDetails.External_Id__c!=null){
                LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(oppDetails.Id,'Opportunity',oppDetails.Account.Solarisbank_Tenent__c);
                DateTime dt=DateTime.now();
                DateTime dtGmt=Datetime.valueOfGmt(String.valueOf(dt));
                String gmtDTString=JSON.serialize(dtGmt);
                String body='{"status":"'+oppDetails.StageName+'"}';
                String statusResponse=EVExternalService.updateInvestmentUpdate(oppDetails.External_Id__c,oppDetails.Account.EVSM_Auth0_Id__c,body,apiCallDetails);
            }
            
        }
        catch(Exception e){
            String index = logError(e,oppId,'Opportunity','OpportuntiyInvestmentService','sendInvestmentStatus','SMI Send Stage');
        }
    }
    
    
    //helper
    private static String logError(Exception e,String recordID,String objectName,String componentName,String methodName,String operation){
        LogService.LogMetadata details=new LogService.LogMetadata();
        details.addError(e);
        details.addRecordInfo(objectName,recordId);
        
        details.addMetadataInfo(userinfo.getUserId(),'SMI_OpportuntiyInvestmentService', methodName, componentName, operation);
        return LogService.logError(details);
    }
}