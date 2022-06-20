/***************
* @group Test Class
* @description test class for CustomerClassificationService
*/
@isTest
public class CustomerClassificationServiceTest {

    @isTest
    static void updateSystemStatusToExternalSystemTest(){
        Test.setMock(HttpCalloutMock.class, new EVExternalServiceTest.EVMockResponse());
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Customer_Classification__c cc=TestDataFactory.getProfessionalCustomerClassfication(a.Id,true);
        User u=TestDataFactory.getUser('Integration');
        Test.startTest();
        System.runAs(u){
            CustomerClassificationService.updateSystemStatusToExternalSystem(cc.Id);
        }
        Test.stopTest();
        
    }
    @isTest
    static void updateSystemStatusToExternalSystemExceptionTest(){
        Test.setMock(HttpCalloutMock.class, new EVExternalServiceTest.EVMockResponse(true));
        Account a=TestDataFactory.getPersonInvestmentAccount(true);
        Customer_Classification__c cc=TestDataFactory.getProfessionalCustomerClassfication(a.Id,true);
        User u=TestDataFactory.getUser('Integration');
        Test.startTest();
        System.runAs(u){
            try{
            CustomerClassificationService.updateSystemStatusToExternalSystem(cc.Id);
            }
            Catch(Exception e){}
        }
        Test.stopTest();
        
    }
	
@isTest
    static void logErrorTest(){
        try{
            Integer i=1/0;
            
        }catch(Exception e){
            CustomerClassificationService.logError('Account','null',e,'CustomerClassificationServiceTest','logErrorTest','Test Class');
        }
    }    

}