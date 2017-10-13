@isTest
public class DocuSignRequestsTest {
    
    @isTest
    public static void authenticationTest() {
        
        Test.setMock(HttpCalloutMock.class, new AuthenticationMock());
        List<DocuSign_Signing_Recipe_Integration__mdt> integrationMdtList = [SELECT Account_Id__c 
                                                                                  , Integration_Key__c 
                                                                                  , Named_Credential_API_Name__c 
                                                                               FROM DocuSign_Signing_Recipe_Integration__mdt 
                                                                              LIMIT 1];
        
        Test.startTest();
        DocuSignRequests.basicAuthCallout(integrationMdtList[0]);
        Test.stopTest();
    }
    
    @isTest
    public static void createEnvelopeTest() {
        
        Test.setMock(HttpCalloutMock.class, new CreateEnvelopeMock());
        List<DocuSign_Signing_Recipe_Integration__mdt> integrationMdtList = [SELECT Account_Id__c 
                                                                                  , Integration_Key__c 
                                                                                  , Named_Credential_API_Name__c 
                                                                               FROM DocuSign_Signing_Recipe_Integration__mdt 
                                                                              LIMIT 1];
        
        Test.startTest();
        DocuSignRequests.createEnvelope(integrationMdtList[0], 'http:\\test.com');
        Test.stopTest();
    }
    
    @isTest
    public static void uploadRecipientsCSVTest() {
        
        Test.setMock(HttpCalloutMock.class, new UploadBulkRecipientsMock());
        List<DocuSign_Signing_Recipe_Integration__mdt> integrationMdtList = [SELECT Account_Id__c 
                                                                                  , Integration_Key__c 
                                                                                  , Named_Credential_API_Name__c 
                                                                               FROM DocuSign_Signing_Recipe_Integration__mdt 
                                                                              LIMIT 1];
        
        Test.startTest();
        DocuSignRequests.uploadBulkRecipientsList(integrationMdtList[0], 'http:\\test.com', 'test', '123', 'name,email\ntest,test@test.com');
        Test.stopTest();
    }

}