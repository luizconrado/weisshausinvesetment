public inherited sharing class Constant {
    
    public static final String WEB_LEAD_RECORDTYPEID{private set;get{
        if(WEB_LEAD_RECORDTYPEID==null)WEB_LEAD_RECORDTYPEID=SchemaUtil.getRecordTypeId('WebLeads', 'Lead');
        return WEB_LEAD_RECORDTYPEID;
    }}
    public static final String TRACK_FIELD_CHANGE_RECORDTYPE_ID{private set;get{
        if(TRACK_FIELD_CHANGE_RECORDTYPE_ID==null)TRACK_FIELD_CHANGE_RECORDTYPE_ID=SchemaUtil.getRecordTypeId('Field_History','History_Tracker__c');
        return TRACK_FIELD_CHANGE_RECORDTYPE_ID;
    }}
    public static final String TRACK_USAGE_HISTORY_RECORDTYPE_ID{private set;get{
        if(TRACK_USAGE_HISTORY_RECORDTYPE_ID == null) TRACK_USAGE_HISTORY_RECORDTYPE_ID=SchemaUtil.getRecordTypeId('Usage_Tracker','History_Tracker__c');
        return TRACK_USAGE_HISTORY_RECORDTYPE_ID;
    }} 
    public static final String PERSON_ACCOUNT_RECORDTYPEID{private set;get{
        if(PERSON_ACCOUNT_RECORDTYPEID==null)PERSON_ACCOUNT_RECORDTYPEID=SchemaUtil.getRecordTypeId('PersonAccount', 'Account');
        return PERSON_ACCOUNT_RECORDTYPEID;
    }}
    public static final Map<String, String> PRODUCT_CONFIGURATION{private set;get{
        if(PRODUCT_CONFIGURATION==null)PRODUCT_CONFIGURATION=Util.getProductMetaDataConfiguration();
        return PRODUCT_CONFIGURATION;
    }}
    
    public static final ID NOREPLOY_OW_EMAIL{private set;get{
        if(NOREPLOY_OW_EMAIL==null)NOREPLOY_OW_EMAIL=[SELECT Id, DisplayName, Address FROM OrgWideEmailAddress where DisplayName='noreply'].Id;
        return NOREPLOY_OW_EMAIL;
    }}
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