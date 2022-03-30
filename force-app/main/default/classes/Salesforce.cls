public inherited  sharing class Salesforce {
    
    private static final String BASE_URL;
    private static final String INSTANCE_NAME;
	private static final Boolean IS_SANDBOX;
	private static final String ORG_TYPE;
    private static final String USER_LAYOUT_PREFRENCE;
    public static String baseUrl {
        get {
            return BASE_URL;
        }
    }
    public static Boolean isSandbox {
        get {
            return IS_SANDBOX;
        }
    }
    public static String edition {
        get {
            return ORG_TYPE;
        }
    }
    public static Boolean isCompactLayout{
        get{
            return USER_LAYOUT_PREFRENCE=='VIEW_TWO'?true:false;
        }
    }
    static{
        String siteBaseUrl = Site.getBaseUrl();
        BASE_URL = String.isNotBlank(siteBaseUrl) ? new Url(siteBaseUrl).toExternalForm() : System.Url.getOrgDomainUrl().toExternalForm();
        Organization org = [SELECT InstanceName, IsSandbox, OrganizationType, NamespacePrefix FROM Organization LIMIT 1];
        List<UserPreference> up=[SELECT Id, UserId, Preference, Value FROM UserPreference where Preference='108' AND UserId=:userinfo.getUserId()];
        if(up.size()>0) USER_LAYOUT_PREFRENCE=up.get(0).Value;
        INSTANCE_NAME = org.InstanceName.toLowerCase();
        IS_SANDBOX = org.IsSandbox;
    }
  
}