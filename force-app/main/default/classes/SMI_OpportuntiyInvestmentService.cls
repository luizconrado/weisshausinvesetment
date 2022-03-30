public class SMI_OpportuntiyInvestmentService {
    
    @AuraEnabled
    public static void sendMoneyTransferConformation(String oppId){
        try{         
            Opportunity oppDetails=[SELECT Id,External_Id__c ,Account.Solarisbank_Tenent__c,Is_Money_Transferred__c, Money_Transfer_Confirmed_By__c FROM Opportunity WHERE id=:oppId];
            if(!oppDetails.Is_Money_Transferred__c){
                LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(oppDetails.Id,'Opportunity',oppDetails.Account.Solarisbank_Tenent__c);
                String statusResponse=EVExternalService.sendInvestmentMoneyTransferdStatus(oppDetails.External_Id__c,true,apiCallDetails);
                oppDetails.Is_Money_Transferred__c=true;
                oppDetails.Money_Transfer_Confirmed_By__c=Userinfo.getUserId();
                update oppDetails;
            }
        }
        catch(Exception e){
            String index = logError(e,oppId,'Opportunity','SMI_OpportuntiyInvestmentConformMoneyTransfer','sendMoneyTransferConformation','SMI Money Transfer Conformation');
            throw new AuraHandledException('Please contact your System admin.And provide '+index+' id to resolve issue.');
        }
    }
    
    @InvocableMethod(label='Send Investment Status to EV')
    public static void sendStatusToEV(List<String> oppIds) {

        List<Opportunity> oppDetails=[SELECT Id,Investment_Status__c ,External_Id__c ,Account.Solarisbank_Tenent__c,Is_Money_Transferred__c, Money_Transfer_Confirmed_By__c FROM Opportunity WHERE id IN:oppIds];
        for(Opportunity opp:oppDetails){
            try{ 
                LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(opp.Id,'Opportunity',opp.Account.Solarisbank_Tenent__c);
                EVExternalService.sendInvestmentStatusChange(opp.External_Id__c,opp.Investment_Status__c,apiCallDetails);
                
            }
            catch(Exception e){
                String index = logError(e,oppDetails.get(0).Id,'Opportunity','SMI_OpportuntiyInvestmentConformMoneyTransfer','sendStatusToEV','SMI Invesment Status Change');
                throw new EVException('Please contact your System admin.And provide '+index+' id to resolve issue.');
            }
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