@isTest
public class CreateEnvelopeResponseTest {
    
    @isTest
    public static void test() {
        
        CreateEnvelopeResponse response = new CreateEnvelopeResponse();
        CreateEnvelopeResponse.parse('{ "loginAccounts": [{"name": "Test","accountId": "1234567","baseUrl": "https://demo.docusign.net/restapi/v2/accounts/1234567","isDefault": "true","userName": "FNameTest LNameTest","userId": "256hs57h-1111-4a26-bb04-d0e13d38178c","email": "testEmail.test.com", "siteDescription": ""}]}');
        
    }

}