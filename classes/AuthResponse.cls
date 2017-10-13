public class AuthResponse {
    
    public LoginAccount[] loginAccounts;
    
    public class LoginAccount {
        public String name;	
        public String accountId;	
        public String baseUrl;	
        public String isDefault;	
        public String userName;	
        public String userId;	
        public String email;	
        public String siteDescription;
    }
    
    public AuthResponse() { }
    
    public static AuthResponse parse(String json){
        return (AuthResponse) System.JSON.deserialize(json, AuthResponse.class);
    }
    
    public static String getBaseUrl(LoginAccount[] loginAccounts) {
        return loginAccounts[0].baseUrl;
    }
}