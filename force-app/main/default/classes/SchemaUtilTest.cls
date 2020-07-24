@isTest
public class SchemaUtilTest {

    @isTest
    static void getObjectPicklistFiledsTest(){
        SchemaUtil.getObjectPicklistFileds( SchemaUtil.getSobjectType('Account'));
    }
    @isTest
    static void getAllObjectFieldsTest(){
        SchemaUtil.getAllObjectFields('Account');
        SchemaUtil.getRecordTypeId('PersonAccount','Account');
        SchemaUtil.getRecordTypeId('Person Account','Account');
    }
}