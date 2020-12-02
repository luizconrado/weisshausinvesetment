public inherited sharing class Constant {
    //LEAD
    public static final String WEB_LEAD_RECORDTYPEID{private set;get{
        if(WEB_LEAD_RECORDTYPEID==null)WEB_LEAD_RECORDTYPEID=SchemaUtil.getRecordTypeId('WebLeads', 'Lead');
        return WEB_LEAD_RECORDTYPEID;
    }}
    //HISTORY TRACKER
    public static final String TRACK_FIELD_CHANGE_RECORDTYPE_ID{private set;get{
        if(TRACK_FIELD_CHANGE_RECORDTYPE_ID==null)TRACK_FIELD_CHANGE_RECORDTYPE_ID=SchemaUtil.getRecordTypeId('Field_History','History_Tracker__c');
        return TRACK_FIELD_CHANGE_RECORDTYPE_ID;
    }}
    public static final String TRACK_USAGE_HISTORY_RECORDTYPE_ID{private set;get{
        if(TRACK_USAGE_HISTORY_RECORDTYPE_ID == null) TRACK_USAGE_HISTORY_RECORDTYPE_ID=SchemaUtil.getRecordTypeId('Usage_Tracker','History_Tracker__c');
        return TRACK_USAGE_HISTORY_RECORDTYPE_ID;
    }} 
    //ACCOUNT
    public static final String PERSON_ACCOUNT_RECORDTYPEID{private set;get{
        if(PERSON_ACCOUNT_RECORDTYPEID==null)PERSON_ACCOUNT_RECORDTYPEID=SchemaUtil.getRecordTypeId('PersonAccount', 'Account');
        return PERSON_ACCOUNT_RECORDTYPEID;
    }}
    //OPPORTUNTIY
    public static final String STANDARD_OPPORTUNITY_RECORDTYPEID{private set;get{
        if(STANDARD_OPPORTUNITY_RECORDTYPEID==null)STANDARD_OPPORTUNITY_RECORDTYPEID=SchemaUtil.getRecordTypeId('Standard_Opportunity', 'Opportunity');
        return STANDARD_OPPORTUNITY_RECORDTYPEID;
    }}
    //CASE
    public static final String STANDARD_CASE_RECORDTYPEID{private set;get{
        if(STANDARD_CASE_RECORDTYPEID==null)STANDARD_CASE_RECORDTYPEID=SchemaUtil.getRecordTypeId('General_Questions', 'Case');
        return STANDARD_CASE_RECORDTYPEID;
    }}
    public static final String BANKINGCASE_CASE_RECORDTYPEID{private set;get{
        if(BANKINGCASE_CASE_RECORDTYPEID==null)BANKINGCASE_CASE_RECORDTYPEID=SchemaUtil.getRecordTypeId('Banking_Case', 'Case');
        return BANKINGCASE_CASE_RECORDTYPEID;
    }}
    //CAMPAIGN
    public static final String STANDARD_CAMPAIGN_RECORDTYPEID{private set;get{
        if(STANDARD_CAMPAIGN_RECORDTYPEID==null)STANDARD_CAMPAIGN_RECORDTYPEID=SchemaUtil.getRecordTypeId('Standard_Campaign', 'Campaign');
        return STANDARD_CAMPAIGN_RECORDTYPEID;
    }}
    //SCHEDULED ORDER
    public static final String TIMED_SCHEDULEDORDER_RECORDTYPEID{private set;get{
        if(TIMED_SCHEDULEDORDER_RECORDTYPEID==null)TIMED_SCHEDULEDORDER_RECORDTYPEID=SchemaUtil.getRecordTypeId('Timed_Order', 'Scheduled_Order__c');
        return TIMED_SCHEDULEDORDER_RECORDTYPEID;
    }}
     public static final String STANDING_SCHEDULEDORDER_RECORDTYPEID{private set;get{
        if(STANDING_SCHEDULEDORDER_RECORDTYPEID==null)STANDING_SCHEDULEDORDER_RECORDTYPEID=SchemaUtil.getRecordTypeId('Standing_Order', 'Scheduled_Order__c');
        return STANDING_SCHEDULEDORDER_RECORDTYPEID;
    }}
    //LOG
    public static final String INITEGERATION_LOG_RECORDTYPEID{private set;get{
        if(INITEGERATION_LOG_RECORDTYPEID==null)INITEGERATION_LOG_RECORDTYPEID=SchemaUtil.getRecordTypeId('Integration', 'Log__c');
        return INITEGERATION_LOG_RECORDTYPEID;
    }}
    public static final String DEBUG_LOG_RECORDTYPEID{private set;get{
        if(DEBUG_LOG_RECORDTYPEID==null)DEBUG_LOG_RECORDTYPEID=SchemaUtil.getRecordTypeId('Debug', 'Log__c');
        return DEBUG_LOG_RECORDTYPEID;
    }}
    //STATMENT
    public static final String STATEMENT_OF_ACCOUNTS_RECORDTYPEID{private set;get{
        if(STATEMENT_OF_ACCOUNTS_RECORDTYPEID==null)STATEMENT_OF_ACCOUNTS_RECORDTYPEID=SchemaUtil.getRecordTypeId('STATEMENT_OF_ACCOUNTS', 'Statement__c');
        return STATEMENT_OF_ACCOUNTS_RECORDTYPEID;
    }}
      public static final String BANK_STATEMENTS_RECORDTYPEID{private set;get{
        if(BANK_STATEMENTS_RECORDTYPEID==null)BANK_STATEMENTS_RECORDTYPEID=SchemaUtil.getRecordTypeId('BANK_STATEMENTS', 'Statement__c');
        return BANK_STATEMENTS_RECORDTYPEID;
    }}
    
    //BANK CASE
    public static final String BANKCASE_ACCOUNT_RECORDTYPEID{private set;get{
        if(BANKCASE_ACCOUNT_RECORDTYPEID==null)BANKCASE_ACCOUNT_RECORDTYPEID=SchemaUtil.getRecordTypeId('Account', 'Bank_Case__c');
        return BANKCASE_ACCOUNT_RECORDTYPEID;
    }}
    public static final String BANKCASE_BANKACCOUNT_RECORDTYPEID{private set;get{
        if(BANKCASE_BANKACCOUNT_RECORDTYPEID==null)BANKCASE_BANKACCOUNT_RECORDTYPEID=SchemaUtil.getRecordTypeId('Bank_Account', 'Bank_Case__c');
        return BANKCASE_BANKACCOUNT_RECORDTYPEID;
    }}
    public static final String BANKCASE_CARD_RECORDTYPEID{private set;get{
        if(BANKCASE_CARD_RECORDTYPEID==null)BANKCASE_CARD_RECORDTYPEID=SchemaUtil.getRecordTypeId('Card', 'Bank_Case__c');
        return BANKCASE_CARD_RECORDTYPEID;
    }}
    public static final String BANKCASE_BOOKING_RECORDTYPEID{private set;get{
        if(BANKCASE_BOOKING_RECORDTYPEID==null)BANKCASE_BOOKING_RECORDTYPEID=SchemaUtil.getRecordTypeId('Booking', 'Bank_Case__c');
        return BANKCASE_BOOKING_RECORDTYPEID;
    }}
    public static final String BANKCASE_RESERVATION_RECORDTYPEID{private set;get{
        if(BANKCASE_RESERVATION_RECORDTYPEID==null)BANKCASE_RESERVATION_RECORDTYPEID=SchemaUtil.getRecordTypeId('Reservation', 'Bank_Case__c');
        return BANKCASE_RESERVATION_RECORDTYPEID;
    }}
    public static final String BANKCASE_STANDINGORDER_RECORDTYPEID{private set;get{
        if(BANKCASE_STANDINGORDER_RECORDTYPEID==null)BANKCASE_STANDINGORDER_RECORDTYPEID=SchemaUtil.getRecordTypeId('Standing_Order', 'Bank_Case__c');
        return BANKCASE_STANDINGORDER_RECORDTYPEID;
    }}
    public static final String BANKCASE_TIMEDGORDER_RECORDTYPEID{private set;get{
        if(BANKCASE_TIMEDGORDER_RECORDTYPEID==null)BANKCASE_TIMEDGORDER_RECORDTYPEID=SchemaUtil.getRecordTypeId('Timed_Order', 'Bank_Case__c');
        return BANKCASE_TIMEDGORDER_RECORDTYPEID;
    }}
    public static final String BANKCASE_STATEMENT_RECORDTYPEID{private set;get{
        if(BANKCASE_STATEMENT_RECORDTYPEID==null)BANKCASE_STATEMENT_RECORDTYPEID=SchemaUtil.getRecordTypeId('Statement', 'Bank_Case__c');
        return BANKCASE_STATEMENT_RECORDTYPEID;
    }}
    
    //METADATA
    public static final Map<String, String> PRODUCT_CONFIGURATION{private set;get{
        if(PRODUCT_CONFIGURATION==null)PRODUCT_CONFIGURATION=Util.getProductMetaDataConfiguration();
        return PRODUCT_CONFIGURATION;
    }}
    
    
    // EMAIL TEMPLATE
    public static final ID LEAD_VERIFY_EMAIL_TEMPLATE{private set;get{
        if(LEAD_VERIFY_EMAIL_TEMPLATE==null) LEAD_VERIFY_EMAIL_TEMPLATE=[SELECT id,name,developername FROM emailtemplate WHERE developername ='Weisshausinvestment_Lead_Verify_Email'].Id;
        return LEAD_VERIFY_EMAIL_TEMPLATE;
    }}
    public static final ID ACCOUNT_VERIFY_EMAIL_TEMPLATE{private set;get{
        if(ACCOUNT_VERIFY_EMAIL_TEMPLATE==null) ACCOUNT_VERIFY_EMAIL_TEMPLATE=[SELECT id,name,developername FROM emailtemplate WHERE developername ='Weisshausinvestment_Person_Account_Verify_Email'].Id;
        return ACCOUNT_VERIFY_EMAIL_TEMPLATE;
    }}
    public static final ID LEAD_UNSUBSCRIBE_EMAIL_TEMPLATE{private set;get{
        if(LEAD_UNSUBSCRIBE_EMAIL_TEMPLATE==null) LEAD_UNSUBSCRIBE_EMAIL_TEMPLATE=[SELECT id,name,developername FROM emailtemplate WHERE developername ='Weisshausinvestment_Lead_unsubscribe_Email'].Id;
        return LEAD_UNSUBSCRIBE_EMAIL_TEMPLATE;
    }}
    public static final ID ACCOUNT_UNSUBSCRIBE_EMAIL_TEMPLATE{private set;get{
        if(ACCOUNT_UNSUBSCRIBE_EMAIL_TEMPLATE==null) ACCOUNT_UNSUBSCRIBE_EMAIL_TEMPLATE=[SELECT id,name,developername FROM emailtemplate WHERE developername ='Weisshausinvestment_Person_Account_unsubscribe_Email'].Id;
        return ACCOUNT_UNSUBSCRIBE_EMAIL_TEMPLATE;
    }}
    public static final ID LEAD_SUBSCRIBED_EMAIL_TEMPLATE{private set;get{
        if(LEAD_SUBSCRIBED_EMAIL_TEMPLATE==null) LEAD_SUBSCRIBED_EMAIL_TEMPLATE=[SELECT id,name,developername FROM emailtemplate WHERE developername ='Weisshausinvestment_Lead_Thank_You_Email'].Id;
        return LEAD_SUBSCRIBED_EMAIL_TEMPLATE;
    }}
    public static final ID ACCOUNT_SUBSCRIBED_EMAIL_TEMPLATE{private set;get{
        if(ACCOUNT_SUBSCRIBED_EMAIL_TEMPLATE==null) ACCOUNT_SUBSCRIBED_EMAIL_TEMPLATE=[SELECT id,name,developername FROM emailtemplate WHERE developername ='Weisshausinvestment_Person_Account_Thank_You_Email'].Id;
        return ACCOUNT_SUBSCRIBED_EMAIL_TEMPLATE;
    }}
    
}