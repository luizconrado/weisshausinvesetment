/***************
* @group Test Class
* @description test class for SchemaUtil
*/
@isTest
public class SchemaUtilTest {

    @isTest
    static void getObjectPicklistFiledsTest(){
        SchemaUtil.getObjectPicklistFileds( SchemaUtil.getSobjectType('Account'));
        SchemaUtil.getDependentPicklistValues(Case.Type_II__c);
    }
    @isTest
    static void getAllObjectFieldsTest(){
        SchemaUtil.getAllObjectFields('Account');
        SchemaUtil.getRecordTypeId('PersonAccount','Account');
        SchemaUtil.getRecordTypeId('Person Account','Account');
    }
}