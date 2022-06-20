/***************
* @group Test Class
* @description test class for LeadService
*/
@isTest
public class LeadServiceTest {

    @isTest
    static void createLeadNewTest(){
        Test.startTest();
        User u=TestDataFactory.getUser('Integration');
        System.runAs(u){
            LeadService.Service service=new LeadService.Service();
            service.createLead('Frau','Test','case','test@ev.com',true,'Website',new Map<String,String>(),Constant.LEAD_BANKING_CUSTOMER_RECORDTYPEID);
        }
        Test.stopTest();
        System.assert([SELECT id FROM Lead].size()>0);
    }
    @isTest
    static void createLeadExceptionTest(){
        Test.startTest();
        User u=TestDataFactory.getUser('Integration');
        System.runAs(u){
            try{
            LeadService.Service service=new LeadService.Service();
                service.createLead('','','','',true,'Website',new Map<String,String>(),Constant.LEAD_BANKING_CUSTOMER_RECORDTYPEID);
            }
            Catch(Exception e){
                
            }
        }
        Test.stopTest();
    }
        
    @isTest
    static void createLeadExsistingTest(){
        Lead l=TestDataFactory.getLeadBankingCustomer(true);
        Test.startTest();
        User u=TestDataFactory.getUser('Integration');
        System.runAs(u){
            LeadService.Service service=new LeadService.Service();
            service.createLead('Frau','Test','case',l.Email,true,'Website',new Map<String,String>(),Constant.LEAD_BANKING_CUSTOMER_RECORDTYPEID);
        }
        Test.stopTest();
    }
}