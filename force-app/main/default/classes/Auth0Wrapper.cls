public class Auth0Wrapper {
    
    public class User_metadata {
        public String invitation_code;
        public String language;
        public String person_id;
        public Boolean term_deposit_enabled;
    }
    
    public String created_at;
    public String email;
    public Boolean email_verified;
    public String family_name;
    public String given_name;
    public List<Identities> identities;
    public String name;
    public String nickname;
    public String picture;
    public String updated_at;
    public String user_id;
    public User_metadata user_metadata;
    public String last_ip;
    public String last_login;
    public Integer logins_count;
    public App_metadata app_metadata;
    public class Identities {
        public String user_id;
        public String provider;
        public String connection;
        public Boolean isSocial;
    }
    public class App_metadata{
        public String source_application;
    }
    
    public static Auth0Wrapper parse(String json) {
        return (Auth0Wrapper) System.JSON.deserialize(json, Auth0Wrapper.class);
    }
    
     public class MockResponse implements HttpCalloutMock { 
        
        public HTTPResponse respond(HTTPRequest req) { 
            String  body='';
            
            if(req.getEndpoint().endsWith('/oauth/token') && req.getMethod()=='POST'){
                body='{"access_token":"wPBXw3DRQz8FZxjddeIXMtbX08CffPv5"}';
            } 
            else if(req.getEndpoint().contains('users/') &&  (req.getMethod()=='GET' || req.getMethod()=='PATCH')){
                Auth0Wrapper x=new Auth0Wrapper();
                x.email='ev@ev.com';
                x.email_verified=true;
                x.family_name='family_name';
                x.given_name='given_name';
                x.name='name';
                Auth0Wrapper.App_metadata app_metadata=new Auth0Wrapper.App_metadata();
                app_metadata.source_application='lightOnboarding';
                x.app_metadata=app_metadata;
                Auth0Wrapper.User_metadata user_metadata=new Auth0Wrapper.User_metadata();
                user_metadata.invitation_code='testCalss';
                user_metadata.language='de';
                user_metadata.person_id='cped135sdc1841654645w6';
                user_metadata.term_deposit_enabled=true;
                x.user_metadata=user_metadata;
                body=JSON.serialize(x);
            }
            
             
            
            
            HttpResponse resp = new HttpResponse(); 
            resp.setStatusCode(200); 
            resp.setStatus('success'); 
            resp.setBody(body); 
            return resp; 
            
        }
    } 
}