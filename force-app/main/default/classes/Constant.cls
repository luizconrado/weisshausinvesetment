public inherited sharing class Constant { 
    
   
    
    //OWD Email Address
    public static final String EV_SUPPORT_OWD_EMAIL{set;get{
        if(EV_SUPPORT_OWD_EMAIL==null){
            EV_SUPPORT_OWD_EMAIL=[SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE Address='support@ev-smartmoney.com'].id;
        }
        return EV_SUPPORT_OWD_EMAIL;
    }}
    
    //TEMPLATE BODY
    public static final String DEFAULT_EV_TEMPLATE_START='<!DOCTYPE html> <html style="overflow-y: hidden;"> <head> <title></title> </head> <body style="margin: 0px; height: auto; min-height: auto;"> <div style="background-color: #f6f6f6;font-family: sans-serif;"> <div style="display: block;margin: 0 auto !important;max-width: 580px;padding: 10px;width: 580px;"> <div style="box-sizing: border-box;background: url(https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0155I000000dP6n&oid=00D5I000002GOw0&lastMod=1611845345000) repeat;display: block;margin: 0 auto;max-width: 580px;padding: 10px;"> <div style="text-align: center;padding-bottom: 10px;padding-top: 10px;"><img src="https://ev-smartmoney--c.documentforce.com/servlet/servlet.ImageServer?id=0155I000000cWLT&oid=00D5I000002GOw0&lastMod=1609923772000" style="text-align: right; width: 207px; border: 0; text-decoration:none; vertical-align: baseline;" width="200" /></div> </div> <div style="line-height: 1.4;box-sizing: border-box;padding: 20px;font-size: 14px;background: #ffffff;border-radius: 3px;width: 100%;">&nbsp; <p>';
    public static final String DEFAULT_EV_TEMPLATE_END='</p> </div> <div style="line-height: 1.4;padding-bottom: 10px;padding-top: 10px;color: #999999;font-size: 12px;text-align: center;"> <p>Sie erhalten diese E-Mail, da Ihre E-Mail-Adresse auf <a href="mailto:support@ev-smartmoney.com" style="color: inherit !important; font-family: inherit !important; font-size: inherit !important; font-weight: inherit !important; line-height: inherit !important; text-decoration: none !important;" target="_blank">support@ev-smartmoney.com</a> registriert ist.</p> <p>Wenn Sie Fragen oder R&uuml;ckmeldungen haben sind wir per E-Mail unter <a href="mailto:support@ev-smartmoney.com" style="color: inherit !important; font-family: inherit !important; font-size: inherit !important; font-weight: inherit !important; line-height: inherit !important; text-decoration: none !important;" target="_blank">support@ev-smartmoney.com</a> oder unter folgender Telefonnummer gerne f&uuml;r Sie da: +49 30 74395959 (Mo-Fr: 9-18 Uhr)</p> <p>Copyright &copy; 2020 EV Smart Money Holding GmbH | HRB 215045 B | Amtsgericht Charlottenburg | Lizenzpartner der Engel &amp; V&ouml;lkers Marken GmbH &amp; Co. KG | Klaus-Groth-Stra&szlig;e 3, 14050 Berlin, Germany. | Gesch&auml;ftsf&uuml;hrung: Dr. Kyros Khadjavi</p> </div> </div> </div> </body> </html>';
    
    //LEAD
    public static final String DEFAULT_LEAD_RECORDTYPEID{private set;get{
        if(DEFAULT_LEAD_RECORDTYPEID==null)DEFAULT_LEAD_RECORDTYPEID=SchemaUtil.getRecordTypeId('Default', 'Lead');
        return DEFAULT_LEAD_RECORDTYPEID;
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
    public static final String PERSON_PARTNER_ACCOUNT_RECORDTYPEID{private set;get{
        if(PERSON_PARTNER_ACCOUNT_RECORDTYPEID==null)PERSON_PARTNER_ACCOUNT_RECORDTYPEID=SchemaUtil.getRecordTypeId('Person_Partner_Account', 'Account');
        return PERSON_PARTNER_ACCOUNT_RECORDTYPEID;
    }}
    
    public static final String ACCOUNT_BUSINESS_ACCOUNT_RECORDTYPEID{private set;get{
        if(ACCOUNT_BUSINESS_ACCOUNT_RECORDTYPEID==null)ACCOUNT_BUSINESS_ACCOUNT_RECORDTYPEID=SchemaUtil.getRecordTypeId('Business_Account', 'Account');
        return ACCOUNT_BUSINESS_ACCOUNT_RECORDTYPEID;
    }}
    
    //OPPORTUNTIY
    public static final String STANDARD_OPPORTUNITY_RECORDTYPEID{private set;get{
        if(STANDARD_OPPORTUNITY_RECORDTYPEID==null)STANDARD_OPPORTUNITY_RECORDTYPEID=SchemaUtil.getRecordTypeId('Standard_Opportunity', 'Opportunity');
        return STANDARD_OPPORTUNITY_RECORDTYPEID;
    }}
    public static final String OPPORTUNITY_RE_FULLSALE_RECORDTYPEID{private set;get{
        if(OPPORTUNITY_RE_FULLSALE_RECORDTYPEID==null)OPPORTUNITY_RE_FULLSALE_RECORDTYPEID=SchemaUtil.getRecordTypeId('Real_Estate_RE_Full_Sale', 'Opportunity');
        return OPPORTUNITY_RE_FULLSALE_RECORDTYPEID;
    }}
    public static final String OPPORTUNITY_RE_PARTIALSALE_RECORDTYPEID{private set;get{
        if(OPPORTUNITY_RE_PARTIALSALE_RECORDTYPEID==null)OPPORTUNITY_RE_PARTIALSALE_RECORDTYPEID=SchemaUtil.getRecordTypeId('Real_Estate_RE_Partial_Sale', 'Opportunity');
        return OPPORTUNITY_RE_PARTIALSALE_RECORDTYPEID;
    }}
        public static final String OPPORTUNITY_RE_VALUATION_RECORDTYPEID{private set;get{
        if(OPPORTUNITY_RE_VALUATION_RECORDTYPEID==null)OPPORTUNITY_RE_VALUATION_RECORDTYPEID=SchemaUtil.getRecordTypeId('Real_Estate_RE_Valuation', 'Opportunity');
        return OPPORTUNITY_RE_VALUATION_RECORDTYPEID;
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
    public static final String EVKONTOAPPCASE_CASE_RECORDTYPEID{private set;get{
        if(EVKONTOAPPCASE_CASE_RECORDTYPEID==null)EVKONTOAPPCASE_CASE_RECORDTYPEID=SchemaUtil.getRecordTypeId('E_V_Konto_App_Case', 'Case');
        return EVKONTOAPPCASE_CASE_RECORDTYPEID;
    }}
    public static final String INVESTMENTCASE_CASE_RECORDTYPEID{private set;get{
        if(INVESTMENTCASE_CASE_RECORDTYPEID==null)INVESTMENTCASE_CASE_RECORDTYPEID=SchemaUtil.getRecordTypeId('Investment_Case', 'Case');
        return INVESTMENTCASE_CASE_RECORDTYPEID;
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
        if(BANKCASE_ACCOUNT_RECORDTYPEID==null)BANKCASE_ACCOUNT_RECORDTYPEID=SchemaUtil.getRecordTypeId('Account', 'Bank_Case_Item__c');
        return BANKCASE_ACCOUNT_RECORDTYPEID;
    }}
    public static final String BANKCASE_BANKACCOUNT_RECORDTYPEID{private set;get{
        if(BANKCASE_BANKACCOUNT_RECORDTYPEID==null)BANKCASE_BANKACCOUNT_RECORDTYPEID=SchemaUtil.getRecordTypeId('Bank_Account', 'Bank_Case_Item__c');
        return BANKCASE_BANKACCOUNT_RECORDTYPEID;
    }}
    public static final String BANKCASE_CARD_RECORDTYPEID{private set;get{
        if(BANKCASE_CARD_RECORDTYPEID==null)BANKCASE_CARD_RECORDTYPEID=SchemaUtil.getRecordTypeId('Card', 'Bank_Case_Item__c');
        return BANKCASE_CARD_RECORDTYPEID;
    }}
    public static final String BANKCASE_BOOKING_RECORDTYPEID{private set;get{
        if(BANKCASE_BOOKING_RECORDTYPEID==null)BANKCASE_BOOKING_RECORDTYPEID=SchemaUtil.getRecordTypeId('Booking', 'Bank_Case_Item__c');
        return BANKCASE_BOOKING_RECORDTYPEID;
    }}

    public static final String BANKCASE_RESERVATION_RECORDTYPEID{private set;get{
        if(BANKCASE_RESERVATION_RECORDTYPEID==null)BANKCASE_RESERVATION_RECORDTYPEID=SchemaUtil.getRecordTypeId('Reservation', 'Bank_Case_Item__c');
        return BANKCASE_RESERVATION_RECORDTYPEID;
    }}
    public static final String BANKCASE_STANDINGORDER_RECORDTYPEID{private set;get{
        if(BANKCASE_STANDINGORDER_RECORDTYPEID==null)BANKCASE_STANDINGORDER_RECORDTYPEID=SchemaUtil.getRecordTypeId('Standing_Order', 'Bank_Case_Item__c');
        return BANKCASE_STANDINGORDER_RECORDTYPEID;
    }}
    public static final String BANKCASE_TIMEDGORDER_RECORDTYPEID{private set;get{
        if(BANKCASE_TIMEDGORDER_RECORDTYPEID==null)BANKCASE_TIMEDGORDER_RECORDTYPEID=SchemaUtil.getRecordTypeId('Timed_Order', 'Bank_Case_Item__c');
        return BANKCASE_TIMEDGORDER_RECORDTYPEID;
    }}
    public static final String BANKCASE_STATEMENT_RECORDTYPEID{private set;get{
        if(BANKCASE_STATEMENT_RECORDTYPEID==null)BANKCASE_STATEMENT_RECORDTYPEID=SchemaUtil.getRecordTypeId('Statement', 'Bank_Case_Item__c');
        return BANKCASE_STATEMENT_RECORDTYPEID;
    }}
    public static final String BANKCASE_IDENTIFICATION_RECORDTYPEID{private set;get{
        if(BANKCASE_IDENTIFICATION_RECORDTYPEID==null)BANKCASE_IDENTIFICATION_RECORDTYPEID=SchemaUtil.getRecordTypeId('Identification', 'Bank_Case_Item__c');
        return BANKCASE_IDENTIFICATION_RECORDTYPEID;
    }}
    
    
    
    //Subscription
    public static final String SUBSCRIPTION_DEFAULT_RECORDTYPEID{private set;get{
        if(SUBSCRIPTION_DEFAULT_RECORDTYPEID==null)SUBSCRIPTION_DEFAULT_RECORDTYPEID=SchemaUtil.getRecordTypeId('Default', 'Subscription__c');
        return SUBSCRIPTION_DEFAULT_RECORDTYPEID;
    }}
    
    //IDENTIFIACTION
    public static final String IDENTIFIACTION_VIDEO_IDENTIFICATION_RECORDTYPEID{
        private set;get{
        if(IDENTIFIACTION_VIDEO_IDENTIFICATION_RECORDTYPEID==null)IDENTIFIACTION_VIDEO_IDENTIFICATION_RECORDTYPEID=SchemaUtil.getRecordTypeId('Video_Identification', 'Identification__c');
        return IDENTIFIACTION_VIDEO_IDENTIFICATION_RECORDTYPEID;
        }}
     //Knowledge
    
    public static final String KNOWLEDGE_FAQ_RECORDTYPEID{private set;get{
        if(KNOWLEDGE_FAQ_RECORDTYPEID==null)KNOWLEDGE_FAQ_RECORDTYPEID=SchemaUtil.getRecordTypeId('FAQ', 'Knowledge__kav');
        return KNOWLEDGE_FAQ_RECORDTYPEID;
    }}
    
    public static final String KNOWLEDGE_SOLARISBANK_RECORDTYPEID{private set;get{
        if(KNOWLEDGE_SOLARISBANK_RECORDTYPEID==null)KNOWLEDGE_SOLARISBANK_RECORDTYPEID=SchemaUtil.getRecordTypeId('Solarisbank', 'Knowledge__kav');
        return KNOWLEDGE_SOLARISBANK_RECORDTYPEID;
    }}
    
    //Asset
    public static final String ASSET_LINK_IMAGE_RECORDTYPEID{
        private set;get{
        if(ASSET_LINK_IMAGE_RECORDTYPEID==null)ASSET_LINK_IMAGE_RECORDTYPEID=SchemaUtil.getRecordTypeId('Asset_Image', 'Asset_Link__c');
        return ASSET_LINK_IMAGE_RECORDTYPEID;
        }}
    public static final String ASSET_REAL_ESTATE_RECORDTYPEID{
        private set;get{
        if(ASSET_REAL_ESTATE_RECORDTYPEID==null)ASSET_REAL_ESTATE_RECORDTYPEID=SchemaUtil.getRecordTypeId('Real_Estate', 'Asset');
        return ASSET_REAL_ESTATE_RECORDTYPEID;
        }}
    
    //Document__c
    public static final String DOCUMENT_ACCOUNT_RECORDTYPEID{
        private set;get{
            if(DOCUMENT_ACCOUNT_RECORDTYPEID==null)DOCUMENT_ACCOUNT_RECORDTYPEID=SchemaUtil.getRecordTypeId('Account_Documents', 'Document__c');
            return DOCUMENT_ACCOUNT_RECORDTYPEID;
        }}
    
    
    //EMAIL TEMPLATE
    public static final String ACCOUNT_REFREAL_EXSISTING_USER_EMAILTEMPLATE{private set;get{
        if(ACCOUNT_REFREAL_EXSISTING_USER_EMAILTEMPLATE==null) ACCOUNT_REFREAL_EXSISTING_USER_EMAILTEMPLATE=[SELECT Id, Name, DeveloperName FROM EmailTemplate WHERE DeveloperName='Referral_Code_Existing_User'].Id;
            return ACCOUNT_REFREAL_EXSISTING_USER_EMAILTEMPLATE;
    }}
    public static final String ACCOUNT_REFREAL_NEW_USER_EMAILTEMPLATE{private set;get{
        if(ACCOUNT_REFREAL_NEW_USER_EMAILTEMPLATE==null) ACCOUNT_REFREAL_NEW_USER_EMAILTEMPLATE=[SELECT Id, Name, DeveloperName FROM EmailTemplate WHERE DeveloperName='Referral_Code_New_User'].Id;
            return ACCOUNT_REFREAL_NEW_USER_EMAILTEMPLATE;
    }}
    public static final String ACCOUNT_REFREAL_BUSINESSE_USER_EMAILTEMPLATE{private set;get{
        if(ACCOUNT_REFREAL_BUSINESSE_USER_EMAILTEMPLATE==null) ACCOUNT_REFREAL_BUSINESSE_USER_EMAILTEMPLATE=[SELECT Id, Name, DeveloperName FROM EmailTemplate WHERE DeveloperName='Referral_Code_Business_User'].Id;
            return ACCOUNT_REFREAL_BUSINESSE_USER_EMAILTEMPLATE;
    }}
    
    public static final String OPPORTUNITY_REAL_ESTATE_SALE_EMAILTEMPLATE{private set;get{
        if(OPPORTUNITY_REAL_ESTATE_SALE_EMAILTEMPLATE==null) OPPORTUNITY_REAL_ESTATE_SALE_EMAILTEMPLATE=[SELECT Id, Name, DeveloperName FROM EmailTemplate WHERE DeveloperName='Real_Estate_Sale'].Id;
            return OPPORTUNITY_REAL_ESTATE_SALE_EMAILTEMPLATE;
    }}
}