@isTest
public class AccountServiceTest {
    
    @isTest
    static void sendEmailToAccountTest(){
        Account a=TestDataFactory.getPersonAccount(true);
        Test.startTest();
        AccountService.sendEmailToAccount(a.Id,JSON.serialize(New Map<String,Boolean>{
            'newsletter'=>true,
                'productA'=>true
                }));
        Test.stopTest();
    }
    
    @isTest
    static void getLastEmailToAccountInfoTest(){
        
        Account a=TestDataFactory.getPersonAccount(true);
        AccountService.getLastEmailToAccountInfo(a.Id);
    }
}