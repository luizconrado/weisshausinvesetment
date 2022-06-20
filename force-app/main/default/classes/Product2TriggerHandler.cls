public class Product2TriggerHandler extends TriggerHandler {
     
    protected override void beforeInsert() {
        /*
        for(Product2 prod:(List<Product2> )Trigger.new){
            if(prod.RecordTypeId==Constant.PRODUCT_INVESTMENT_RECORDTYPEID){
                if(!validatePosibleInvestmentDate(prod.Possible_Investment_Dates__c)){
                    prod.addError('Please enter possible investment date in format yyyy-mm-dd');
                }  
            }
        }
*/
    }
    protected override void afterInsert() {
        List<Product2> investmentProducts=new List<Product2>();
        for(Product2 prod:(List<Product2> )Trigger.new){
            if(prod.Minimum_Investment__c!=null && prod.isActive==true && prod.RecordTypeId==Constant.PRODUCT_INVESTMENT_RECORDTYPEID){
                investmentProducts.add(prod);
            }
        }
        
        if(investmentProducts.size()>0) createStandardPricebook(investmentProducts);
        
    }
    
    protected override void beforeUpdate() {
        /*
        for(Product2 prod:(List<Product2> )Trigger.newMap.values()){
            if(prod.RecordTypeId==Constant.PRODUCT_INVESTMENT_RECORDTYPEID){
                if(!validatePosibleInvestmentDate(prod.Possible_Investment_Dates__c)){
                    prod.addError('Please enter possible investment date in format yyyy-mm-dd');
                }  
            }
        }
*/
    }
    
    private void createStandardPricebook(List<Product2> newProducts){
        List<PricebookEntry> toInsertPB=new List<PricebookEntry>();
        for(Product2 prod:newProducts){
            PricebookEntry pb=new PricebookEntry();
            
            pb.UnitPrice=prod.Minimum_Investment__c;
            pb.Product2Id=prod.Id;
            pb.Pricebook2Id=Constant.PRICEBOOK_STANDARD_PRICEBOOK_ID;  
            pb.IsActive=true;
             
            toInsertPB.add(pb);
        }
        
        insert toInsertPB;
        
    }
    /*
    private boolean validatePosibleInvestmentDate(String posibleDates){
        if(posibleDates!=null && String.isNotEmpty(posibleDates)){
            for(String posibleDate:posibleDates.split(',')){
                List<String> dateParts=posibleDate.split('-');
                if(!(dateParts.size()==3 && dateParts.get(0).length()==4 && dateParts.get(1).length()==2 && dateParts.get(2).length()==2)){
                    return false;
                } 
            }
        }
        return true;
    }
*/
}