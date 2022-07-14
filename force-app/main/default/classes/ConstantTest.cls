/***************
* @group Test Class
* @description test class for Constant
*/
@isTest
private class ConstantTest {
    @isTest
    static void getValues(){
        System.assert(String.isNotEmpty(Constant.DEFAULT_LEAD_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.LEAD_BANKING_CUSTOMER_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.TRACK_FIELD_CHANGE_RECORDTYPE_ID));
        System.assert(String.isNotEmpty(Constant.TRACK_USAGE_HISTORY_RECORDTYPE_ID));
       
      
        System.assert(String.isNotEmpty(Constant.STANDARD_OPPORTUNITY_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.OPPORTUNITY_RE_FULLSALE_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.OPPORTUNITY_RE_PARTIALSALE_RECORDTYPEID));
        
        
        
        System.assert(String.isNotEmpty(Constant.INITEGERATION_LOG_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.DEBUG_LOG_RECORDTYPEID));
        
        System.assert(String.isNotEmpty(Constant.STANDARD_CAMPAIGN_RECORDTYPEID));
      
        System.assert(String.isNotEmpty(Constant.SUBSCRIPTION_DEFAULT_RECORDTYPEID));

        System.assert(String.isNotEmpty(Constant.STANDARD_CASE_RECORDTYPEID)); 
        
        System.assert(String.isNotEmpty(Constant.BANKCASE_ACCOUNT_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.BANKCASE_BANKACCOUNT_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.BANKCASE_CARD_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.BANKCASE_BOOKING_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.BANKCASE_RESERVATION_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.BANKCASE_STANDINGORDER_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.BANKCASE_TIMEDGORDER_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.BANKCASE_STATEMENT_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.BANKINGCASE_CASE_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.BANKCASE_IDENTIFICATION_RECORDTYPEID));
        
        System.assert(String.isNotEmpty(Constant.INVESTMENTCASE_CASE_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.EVKONTOAPPCASE_CASE_RECORDTYPEID));
        
        

        
        System.assert(String.isNotEmpty(Constant.STATEMENT_OF_ACCOUNTS_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.BANK_STATEMENTS_RECORDTYPEID));
        
        System.assert(String.isNotEmpty(Constant.TIMED_SCHEDULEDORDER_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.STANDING_SCHEDULEDORDER_RECORDTYPEID));
        
        System.assert(String.isNotEmpty(Constant.KYC_VIDEO_IDENTIFICATION_RECORDTYPEID));

        
          System.assert(String.isNotEmpty(Constant.ASSET_LINK_IMAGE_RECORDTYPEID));
        
	
        System.assert(String.isNotEmpty(Constant.EV_SUPPORT_OWD_EMAIL));
        System.assert(String.isNotEmpty(Constant.DEFAULT_EV_TEMPLATE_START));
        System.assert(String.isNotEmpty(Constant.DEFAULT_EV_TEMPLATE_END));

        System.assert(String.isNotEmpty(Constant.PERSON_ACCOUNT_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.PERSON_PARTNER_ACCOUNT_RECORDTYPEID));    
        System.assert(String.isNotEmpty(Constant.ACCOUNT_PERSON_INVESTMENT_RECORDTYPEID));    
        System.assert(String.isNotEmpty(Constant.ACCOUNT_BUSINESS_ACCOUNT_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.ACCOUNT_INVESTMENT_BANKING_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.ACCOUNT_REFREAL_EXSISTING_USER_EMAILTEMPLATE));
        System.assert(String.isNotEmpty(Constant.ACCOUNT_REFREAL_NEW_USER_EMAILTEMPLATE));
        
        System.assert(String.isNotEmpty(Constant.OPPORTUNITY_RE_VALUATION_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.OPPORTUNITY_INVESMENT_RECORDTYPEID));
        
        System.assert(String.isNotEmpty(Constant.OPPORTUNITY_REAL_ESTATE_SALE_EMAILTEMPLATE));
        
        
        System.assert(String.isNotEmpty(Constant.STANDARD_CAMPAIGN_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.KNOWLEDGE_SOLARISBANK_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.ASSET_LINK_IMAGE_RECORDTYPEID));
        
        System.assert(String.isNotBlank(Constant.DOCUMENT_ACCOUNT_RECORDTYPEID));
        System.assert(String.isNotBlank(Constant.DOCUMENT_OPPORTUNTIY_RECORDTYPEID));
        System.assert(String.isNotBlank(Constant.BANK_SOLARISBANK_RECORDTYPEID));
        
        
        System.assert(String.isNotEmpty(Constant.KNOWLEDGE_FAQ_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.ASSET_REAL_ESTATE_RECORDTYPEID));
        
    
        System.assert(String.isNotEmpty(Constant.ACCOUNT_REFREAL_BUSINESSE_USER_EMAILTEMPLATE));
        
    }
    @isTest
    static void getValues2(){
         System.assert(String.isNotEmpty(Constant.PRICEBOOK_STANDARD_PRICEBOOK_ID));
        System.assert(String.isNotEmpty(Constant.INTEGERATION_USER_ID));
       System.assert(String.isNotEmpty(Constant.PRODUCT_INVESTMENT_RECORDTYPEID));
        
        System.assert(String.isNotEmpty(Constant.CUSTOMER_CLASSIFICATION_PROFESSIONAL_RECORDTYPEID));
        System.assert(String.isNotEmpty(Constant.CUSTOMER_CLASSIFICATION_SEMI_PROFESSIONAL_RECORDTYPEID));
        
    }
    
}