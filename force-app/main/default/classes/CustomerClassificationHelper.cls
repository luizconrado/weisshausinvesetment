/***************
* @group Helper Class
* @description Customer Classification trigger logic
*/
public inherited sharing class CustomerClassificationHelper {
    
    /***************
    * @description business logic behine approval fields 
    * @param classificationList cc list
    * @param oldClassificationMap old cc map
    */
    public static void processSystemStatusValue(List<Customer_Classification__c> classificationList,Map<Id,Customer_Classification__c> oldClassificationMap){
       Boolean isValidationValid = !Label.Users_Exclusion.contains(Userinfo.getUserName());
        
        for(Customer_Classification__c classification:classificationList){
            
            //only if approval fields are changed
            if(classification.Internal_Approval__c!=oldClassificationMap.get(classification.Id).Internal_Approval__c
               || classification.Data_Submitted_to_Partner__c!=oldClassificationMap.get(classification.Id).Data_Submitted_to_Partner__c
               || classification.Partner_Approval__c!=oldClassificationMap.get(classification.Id).Partner_Approval__c){
                   
                   Boolean isBreakLoop=false;
                   //validation rules 
                   if(oldClassificationMap.get(classification.Id).Internal_Approval__c=='Customer Rejected' && isValidationValid){
                       if(classification.Internal_Approval__c!='Customer Rejected' ){
                           classification.addError('Cannot modify approval fields after Internal Approval is Rejected'); 
                           isBreakLoop=true;
                       }
                       else if(classification.Data_Submitted_to_Partner__c!='No' || classification.Partner_Approval__c!='Customer Rejected'){
                           classification.addError('Cannot modify approval fields after Internal Approval is Rejected'); 
                           isBreakLoop=true;
                       } 
                   }
                   
                   if(oldClassificationMap.get(classification.Id).Partner_Approval__c=='Customer Rejected' && isValidationValid){
                       if(classification.Partner_Approval__c!='Customer Rejected'){
                           classification.addError('Cannot modify approval fields after Partner Approval is Rejected'); 
                           isBreakLoop=true;
                       }
                       else if(classification.Data_Submitted_to_Partner__c!=oldClassificationMap.get(classification.Id).Data_Submitted_to_Partner__c || classification.Internal_Approval__c!=oldClassificationMap.get(classification.Id).Internal_Approval__c){
                           classification.addError('Cannot modify approval fields after Partner Approval is Rejected'); 
                           isBreakLoop=true;
                       } 
                   }
                    
                   if(!isBreakLoop){                                  
                       //setting system values
                       if(classification.Internal_Approval__c=='Pending'){
                           if(classification.Data_Submitted_to_Partner__c=='Pending'){
                               if(classification.Partner_Approval__c=='Pending'){
                                   classification.System_Status__c='AWAITING_INTERNAL_PROCESSING';
                               }
                               else if(classification.Partner_Approval__c=='Customer Approved' || classification.Partner_Approval__c=='Customer Rejected' && isValidationValid){
                                   classification.addError('Restricted Value : Partner Approval (Internal Approval Required)');                        
                               } 
                           }
                           else if(classification.Data_Submitted_to_Partner__c=='Yes' || classification.Data_Submitted_to_Partner__c=='No' && isValidationValid){
                               classification.addError('Restricted Value : Data Submitted to Partner (Internal Approval Required)');
                           } 
                       }
                       else if(classification.Internal_Approval__c=='Customer Rejected'){
                           classification.Data_Submitted_to_Partner__c='No';
                           classification.Partner_Approval__c='Customer Rejected';
                           classification.System_Status__c='INTERNAL_MANUALLY_DECLINED';
                       }
                       else if(classification.Internal_Approval__c=='Customer Approved'){
                           if(classification.Data_Submitted_to_Partner__c=='Pending'){
                               if(classification.Partner_Approval__c=='Pending'){
                                   classification.System_Status__c='AWAITING_INTERNAL_PROCESSING';
                               }
                               else if(classification.Partner_Approval__c=='Customer Approved' || classification.Partner_Approval__c=='Customer Rejected' && isValidationValid){
                                   classification.addError('Restricted Value : Partner Approval (Data Submitted to Partner Required)');
                               } 
                           }
                           else if(classification.Data_Submitted_to_Partner__c=='Yes'){
                               if(classification.Partner_Approval__c=='Pending'){
                                   classification.System_Status__c='AWAITING_PARTNER_PROCESSING';
                               }
                               else if(classification.Partner_Approval__c=='Customer Approved'){
                                   classification.System_Status__c='PARTNER_MANUALLY_APPROVED';
                               } 
                               else if(classification.Partner_Approval__c=='Customer Rejected'){
                                   classification.System_Status__c='PARTNER_MANUALLY_DECLINED';
                               }
                           }
                           else if(classification.Data_Submitted_to_Partner__c=='No' && isValidationValid){
                               classification.addError('Restricted Value : Data Submitted to Partner (Invalid value)'); 
                               
                           }
                       }
                       
                       
                       
                       
                       
                       
                       //set timestamps           
                       if(classification.Internal_Approval__c!=oldClassificationMap.get(classification.Id).Internal_Approval__c){
                           classification.Internal_Approval_By__c=Userinfo.getUserId();
                           classification.Internal_Approval_Date__c=DateTime.now();
                       }
                       if(classification.Data_Submitted_to_Partner__c!=oldClassificationMap.get(classification.Id).Data_Submitted_to_Partner__c){
                           classification.Data_Submitted_to_Partner_By__c=Userinfo.getUserId();
                           classification.Data_Submitted_to_Partner_Date__c=DateTime.now();
                       }
                       if(classification.Partner_Approval__c!=oldClassificationMap.get(classification.Id).Partner_Approval__c){
                           classification.Partner_Approval_By__c=Userinfo.getUserId();
                           classification.Partner_Approval_Date__c=DateTime.now();
                       }
                       
                       //null checks for fields
                       if(String.isEmpty(classification.Internal_Approval__c)){
                           classification.addError('Please select Internal Approval value');    
                       }
                       if(String.isEmpty(classification.Data_Submitted_to_Partner__c)){
                           classification.addError('Please select Data Submitted to Partner value');    
                       }
                       if(String.isEmpty(classification.Partner_Approval__c)){
                           classification.addError('Please select Partner Approval value');    
                       }
                   }
               }
        }
    }

     /***************
    * @description sets account name in custom field - used in slack alert, formula fields where not working and cannot do it in flows/as they are processed after trigger
    * @param classificationList cc list
    */
    public static void setAccountNameValue(List<Customer_Classification__c> classificationList){
        List<String> accountIds=new List<String>();
        for(Customer_Classification__c classification:classificationList){
            if(classification.Account__c!=null) accountIds.add(classification.Account__c);
        }
        
        Map<String,String> accountIdAndNameMap=new Map<String,String>();
        for(Account acc:[SELECT Id,Name FROM Account WHERE Id IN:accountIds]){
            accountIdAndNameMap.put(acc.Id,acc.Name);
        }
        
        for(Customer_Classification__c classification:classificationList){
            if(accountIdAndNameMap.containsKey(classification.Account__c)) classification.Account_Name__c=accountIdAndNameMap.get(classification.Account__c);
        }
        
    }
}