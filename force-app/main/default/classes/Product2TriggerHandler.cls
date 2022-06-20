/***************
* @group Handler Class
* @description  Product2 trigger router
*/
public class Product2TriggerHandler extends TriggerHandler {
     
    
    protected override void afterInsert() {
        List<Product2> investmentProducts=new List<Product2>();
        for(Product2 prod:(List<Product2> )Trigger.new){
            if(prod.Minimum_Investment__c!=null && prod.isActive==true && prod.RecordTypeId==Constant.PRODUCT_INVESTMENT_RECORDTYPEID){
                investmentProducts.add(prod);
            }
        }
        
        if(investmentProducts.size()>0) createStandardPricebook(investmentProducts);
        
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
   
}