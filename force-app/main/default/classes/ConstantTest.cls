@isTest
private class ConstantTest {
    @isTest
    static void getValues(){
        System.assert(String.isNotEmpty(Constant.WEB_LEAD_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.TRACK_FIELD_CHANGE_RECORDTYPE_ID));
        System.assert(String.isNotEmpty(Constant.TRACK_USAGE_HISTORY_RECORDTYPE_ID));
        System.assert(String.isNotEmpty(Constant.PERSON_ACCOUNT_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.LEAD_VERIFY_EMAIL_TEMPLATE));
        System.assert(String.isNotEmpty(Constant.ACCOUNT_VERIFY_EMAIL_TEMPLATE));
        System.assert(String.isNotEmpty(Constant.LEAD_UNSUBSCRIBE_EMAIL_TEMPLATE));
        System.assert(String.isNotEmpty(Constant.ACCOUNT_UNSUBSCRIBE_EMAIL_TEMPLATE));
        System.assert(String.isNotEmpty(Constant.LEAD_SUBSCRIBED_EMAIL_TEMPLATE));
        System.assert(String.isNotEmpty(Constant.ACCOUNT_SUBSCRIBED_EMAIL_TEMPLATE));
        System.assert(String.isNotEmpty(Constant.STANDARD_OPPORTUNITY_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.STANDARD_CASE_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.INITEGERATION_LOG_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.DEBUG_LOG_RECORDTYPEID));
        
        System.assert(String.isNotEmpty(Constant.STANDARD_CAMPAIGN_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.BANKCASE_ACCOUNT_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.BANKCASE_BANKACCOUNT_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.BANKCASE_CARD_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.BANKCASE_BOOKING_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.BANKCASE_RESERVATION_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.BANKCASE_STANDINGORDER_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.BANKCASE_TIMEDGORDER_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.BANKCASE_STATEMENT_RECORDTYPEID));
         System.assert(String.isNotEmpty(Constant.STATEMENT_OF_ACCOUNTS_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.BANK_STATEMENTS_RECORDTYPEID));
        
        
            
        
        System.assert(Constant.PRODUCT_CONFIGURATION.values().size()>0);
        
    }
    
}