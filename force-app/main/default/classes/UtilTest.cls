@isTest
private class UtilTest {
    @isTest
    static void getValues(){
        Util.getProductMetaDataConfiguration();
        Util.checkEmailPermission(Constant.ACCOUNT_VERIFY_EMAIL_TEMPLATE);
        Util.checkEmailPermission(Constant.ACCOUNT_UNSUBSCRIBE_EMAIL_TEMPLATE);
        Util.checkEmailPermission(Constant.ACCOUNT_SUBSCRIBED_EMAIL_TEMPLATE);
        System.assert(Util.checkEmailPermission(null));
    }

}