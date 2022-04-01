public class Product2ExternalService {
    
    
    
     
    public static void sendProductDataToExternalSystem(List<Product2> products){
        
        for(Product2 prod:products){
            if(prod.RecordTypeId==Constant.PRODUCT_INVESTMENT_RECORDTYPEID){
                try{
                    LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(prod.Id,'Product2',(Salesforce.isSandbox)?'Mobile':'Production');
                    
                    
                    Map<String,Object> product=new Map<String,Object>();
                    Map<String,Object> location =new Map<String,Object>();
                    Map<String,Object> investment=new Map<String,Object>();
                    Map<String,Object> bankinformation =new Map<String,Object>();
                    
                    product.put('id',prod.id);
                    product.put('createdAt',prod.CreatedDate);
                    product.put('status',(prod.IsActive)?'ACTIVE':'INACTIVE');
                    product.put('name',prod.Name);
                    
                    if(prod.Current_Amount__c!=null)product.put('currentAmount',prod.Current_Amount__c);
                    if(prod.Total_Amount__c!=null)product.put('totalAmount',prod.Total_Amount__c);
                    if(prod.Due_Date__c!=null) product.put('dueDate',prod.Due_Date__c);
                    
                    if(prod.City__c!=null)location.put('city',prod.City__c);
                    if(prod.Country__c!=null)location.put('country',prod.Country__c);
                    
                    if(prod.Interest__c!=null)investment.put('interest',prod.Interest__c);
                    if(prod.Expected_Distribution__c!=null)investment.put('expectedDistribution',prod.Expected_Distribution__c);
                   if(prod.Duration_in_months__c!=null)investment.put('duration',prod.Duration_in_months__c);
                    if(prod.Risk_Class__c!=null)investment.put('riskClass',prod.Risk_Class__c);
                    if(prod.Own_Contribution__c!=null)investment.put('ownContribution',prod.Own_Contribution__c);
                    if(prod.Minimum_Investment__c!=null)investment.put('minimumInvestment',prod.Minimum_Investment__c);
                    if(prod.Financing_Purpose__c!=null) investment.put('financingPurpose',prod.Financing_Purpose__c);
                    if(prod.Type_Of_Use__c!=null)investment.put('typeOfUse',prod.Type_Of_Use__c);
                    if(prod.Repayment__c!=null)investment.put('repayment',prod.Repayment__c);
                    
                    if(prod.Bank_Name__c!=null)bankinformation.put('bankName',prod.Bank_Name__c);
                    if(prod.Bank_IBAN__c!=null)bankinformation.put('iban',prod.Bank_IBAN__c);
                    if(prod.Bank_BIC__c!=null)bankinformation.put('bic',prod.Bank_BIC__c);
                    
                    if(location.size()>0) product.put('location',location);
                    if(investment.size()>0) product.put('investmentInformation',investment);
                    if(bankinformation.size()>0) product.put('bankingInformation',bankinformation);
                    
                    EVExternalService.sendProductsInfo(JSON.serialize(product), apiCallDetails);
                }
                Catch(Exception e){
                    LogService.LogMetadata errorDetails=new LogService.LogMetadata();
                    errorDetails.addError(e);
                    errorDetails.addMetadataInfo(userinfo.getUserId(), 'Product2ExternalService', 'sendProductDataToExternalSystem', 'Insert - Product2 - Send data to external system','Send Product Data To BE');
                    errorDetails.addRecordInfo('Product2',prod.Id);
                    LogService.logError(errorDetails);
                }
                
            }
            
            
        } 
        
    }
   
    public static void  updatedProductDataToExternalSystem(List<Product2> products){
        
        for(Product2 prod:products){
            if(prod.RecordTypeId==Constant.PRODUCT_INVESTMENT_RECORDTYPEID){
                try{
                    LogService.ApiCallDetails apiCallDetails =  new LogService.ApiCallDetails(prod.Id,'Product2',(Salesforce.isSandbox)?'Mobile':'Production');
                    
                    
                    Map<String,Object> product=new Map<String,Object>();
                    Map<String,Object> location =new Map<String,Object>();
                    Map<String,Object> investment=new Map<String,Object>();
                    Map<String,Object> bankinformation =new Map<String,Object>();
                    
                    product.put('id',prod.id);
                    product.put('createdAt',prod.CreatedDate);
                    product.put('status',(prod.IsActive)?'ACTIVE':'INACTIVE');
                    product.put('name',prod.Name);
                    
                    if(prod.Current_Amount__c!=null)product.put('currentAmount',prod.Current_Amount__c);
                    if(prod.Total_Amount__c!=null)product.put('totalAmount',prod.Total_Amount__c);
                    if(prod.Due_Date__c!=null) product.put('dueDate',prod.Due_Date__c);
                    
                    if(prod.City__c!=null)location.put('city',prod.City__c);
                    if(prod.Country__c!=null)location.put('country',prod.Country__c);
                    
                    if(prod.Interest__c!=null)investment.put('interest',prod.Interest__c);
                    if(prod.Expected_Distribution__c!=null)investment.put('expectedDistribution',prod.Expected_Distribution__c);
                    if(prod.Duration_in_months__c!=null)investment.put('duration',prod.Duration_in_months__c);
                    if(prod.Risk_Class__c!=null)investment.put('riskClass',prod.Risk_Class__c);
                    if(prod.Own_Contribution__c!=null)investment.put('ownContribution',prod.Own_Contribution__c);
                    if(prod.Minimum_Investment__c!=null)investment.put('minimumInvestment',prod.Minimum_Investment__c);
                    if(prod.Financing_Purpose__c!=null) investment.put('financingPurpose',prod.Financing_Purpose__c);
                    if(prod.Type_Of_Use__c!=null)investment.put('typeOfUse',prod.Type_Of_Use__c);
                    if(prod.Repayment__c!=null)investment.put('repayment',prod.Repayment__c);
                    
                    if(prod.Bank_Name__c!=null)bankinformation.put('bankName',prod.Bank_Name__c);
                    if(prod.Bank_IBAN__c!=null)bankinformation.put('iban',prod.Bank_IBAN__c);
                    if(prod.Bank_BIC__c!=null)bankinformation.put('bic',prod.Bank_BIC__c);
                    
                    if(location.size()>0) product.put('location',location);
                    if(investment.size()>0) product.put('investmentInformation',investment);
                    if(bankinformation.size()>0) product.put('bankingInformation',bankinformation);
                    
                    EVExternalService.updateProductsInfo(JSON.serialize(product),prod.Id, apiCallDetails);
                }
                Catch(Exception e){
                    LogService.LogMetadata errorDetails=new LogService.LogMetadata();
                    errorDetails.addError(e);
                    errorDetails.addMetadataInfo(userinfo.getUserId(), 'Product2ExternalService', 'sendProductDataToExternalSystem', 'Insert - Product2 - Send data to external system','Send Product Data To BE');
                    errorDetails.addRecordInfo('Product2',prod.Id);
                    LogService.logError(errorDetails);
                }
                
            }
            
            
        } 
        
    }
    
    
}