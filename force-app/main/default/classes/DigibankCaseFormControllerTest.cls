/***************
* @group Test Class
* @description test class for DigibankCaseFormController
*/
@isTest
public class DigibankCaseFormControllerTest {
    
    @isTest
    static void constantsTest(){
        DigibankCaseFormController.getEVKONTOCaseRecordTypeId();
    }
    
    @isTest
    static void createNewEVKnotoCaseTest(){
        Account a=TestDataFactory.getPersonAccount(true);
        Case caseObject = New Case();
        caseObject.RecordTypeId = Constant.EVKONTOAPPCASE_CASE_RECORDTYPEID;
        caseObject.Origin = 'Web';
        caseObject.SuppliedEmail = a.PersonEmail;
        caseObject.Subject = 'this.subject';
        caseObject.Description = 'What issue are you Experiencing?';
        caseObject.Type = 'Bug';
        Test.startTest();
        DigibankCaseFormController.createNewEVKnotoCase(caseObject);
        Test.stopTest();
        List<Case> c=[SELECT id FROM Case];
        System.assert(c.size()>0);
    }
    @isTest
    static void createNewEVKnotoCaseError(){
        Test.startTest();
        try{
        DigibankCaseFormController.createNewEVKnotoCase(null);
            }catch(Exception e){}
        Test.stopTest();
    }
    @isTest
    static void attachFilesToCaseError(){
        Test.startTest();
        try{
        DigibankCaseFormController.attachFilesToCase(null,null);
        }catch(Exception e){}
        Test.stopTest();
    }
    @isTest
    static void attachFilesToCaseTest(){
        Account a=TestDataFactory.getPersonAccount(true);
        Case c=TestDataFactory.getEVKontoCase(a.Id,true);
        Contentversion cv=TestDataFactory.getContentVersion(true);
        Test.startTest();
        DigibankCaseFormController.attachFilesToCase(c.Id,New List<String>{cv.id});
        Test.stopTest();
    }
    
    @isTest
    static void processErrorTest(){
        try{
            DigibankCaseFormController.processError('a','b','c','d',null);
        }catch(exception e){}
    }
    
    
}