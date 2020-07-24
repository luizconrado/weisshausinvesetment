@isTest
private class UtilTest {
    @isTest
    static void getValues(){
        Util.getProductMetaDataConfiguration();
        Util.checkEmailPermission(Constant.LEAD_VERIFY_EMAIL_TEMPLATE);
        Util.checkEmailPermission(Constant.LEAD_SUBSCRIBED_EMAIL_TEMPLATE);
        Util.checkEmailPermission(Constant.LEAD_UNSUBSCRIBE_EMAIL_TEMPLATE);
        System.assert(Util.checkEmailPermission(null));
    }

}