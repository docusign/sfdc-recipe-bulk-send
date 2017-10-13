@isTest
public class AuthResponseTest {
    
    @isTest
    public static void test() {
        
        AuthResponse auth = new AuthResponse();
        AuthResponse.parse('{"loginAccounts": [{"name": "Synebo","accountId": "3779472","baseUrl": "https://demo.docusign.net/restapi/v2/accounts/3779472","isDefault": "true","userName": "FNameTest LNameTest","userId": "590e47bc-0662-4a26-bb04-d0e13d38178c","email": "anastasia.kovalchuk@synebo.io","siteDescription": ""}]}');
        
        AuthResponse.LoginAccount log = new AuthResponse.LoginAccount();
        
        AuthResponse.getBaseUrl(new List<AuthResponse.LoginAccount>{log});
        
    }

}