/***************
* @group Test Class
* @description test class for Translate
*/
@isTest
public class TranslateTest {
    
    @isTest
    static void getTranslatedPickListValuesTest(){
        Translate.getTranslatedPickListValues('Knowledge__kav','Type__c');
    }
    
    @isTest
    static void translateTest(){
        PageReference myVfPage = Page.Translate;
        Test.setCurrentPage(myVfPage);
        
        // Put Id into the current page Parameters
        ApexPages.currentPage().getParameters().put('objectName','Knowledge__kav');
        ApexPages.currentPage().getParameters().put('fieldName','Type__c');
        ApexPages.currentPage().getParameters().put('type','PICKLIST');
        Translate tanslate=new Translate();
    }
    
}