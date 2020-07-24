@isTest
private class ConstantTest {
    @isTest
    static void getValues(){
        System.assert(String.isNotEmpty(Constant.WEB_LEAD_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.TRACK_FIELD_CHANGE_RECORDTYPE_ID));
        System.assert(String.isNotEmpty(Constant.TRACK_USAGE_HISTORY_RECORDTYPE_ID));
        System.assert(String.isNotEmpty(Constant.PERSON_ACCOUNT_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.NOREPLOY_OW_EMAIL));
        System.assert(String.isNotEmpty(Constant.LEAD_VERIFY_EMAIL_TEMPLATE));
        System.assert(String.isNotEmpty(Constant.ACCOUNT_VERIFY_EMAIL_TEMPLATE));
        System.assert(String.isNotEmpty(Constant.LEAD_UNSUBSCRIBE_EMAIL_TEMPLATE));
        System.assert(String.isNotEmpty(Constant.ACCOUNT_UNSUBSCRIBE_EMAIL_TEMPLATE));
        System.assert(String.isNotEmpty(Constant.LEAD_SUBSCRIBED_EMAIL_TEMPLATE));
        System.assert(String.isNotEmpty(Constant.ACCOUNT_SUBSCRIBED_EMAIL_TEMPLATE));
        System.assert(String.isNotEmpty(Constant.STANDARD_OPPORTUNITY_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.STANDARD_CASE_RECORDTYPEID));
        
        System.assert(Constant.PRODUCT_CONFIGURATION.values().size()>0);
        
    }

}