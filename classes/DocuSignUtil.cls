public class DocuSignUtil {
    
    public class Authentication{
        public String Username;	
        public String Password;	
        public String IntegratorKey;
        
        public Authentication(String pUsername, String pPassword, String pIntegratorKey) {
            this.Username      = pUsername;
            this.Password      = pPassword;
            this.IntegratorKey = pIntegratorKey;
        }
    }
    
    public static String generateRandomIndex(Integer len) {
        final String chars = '123456789';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }
    
    public static String generateAuthHeader(DocuSign_Signing_Recipe_Integration__mdt integrationMdt) {
        String userName = '{!$Credential.UserName}',
               password = '{!$Credential.Password}',
               integratorKey = '';
        
        integratorKey = integrationMdt.Integration_Key__c;
        
        DocuSignUtil util = new DocuSignUtil();
        DocuSignUtil.Authentication auth = new DocuSignUtil.Authentication(userName, password, integratorKey);
        
        return JSON.serialize(auth);
    }
    
    public static String obtainNamedCredential(DocuSign_Signing_Recipe_Integration__mdt integrationMd) {
        String userName = '{!$Credential.UserName}',
               password = '{!$Credential.Password}',
               integratorKey = '';
        
        return integrationMd.Named_Credential_API_Name__c;
    }
    
    
}