@isTest
public class DocuSignBulkSendDemoControllerTest {    
    
    @isTest(SeeAllData='true')
    public static void test() {
        
        Contact testContact = new Contact(
            FirstName = 'ContactFORUnitTestBulkDemoSend',
            LastName  = 'ContactFORUnitTestBulkDemoSend',
            Email     = 'contactFORUnitTestBulkDemoSend@demo.test.bulk.send'
        );
        insert testContact;
        
        DocuSignBulkSendDemoController demoController = new DocuSignBulkSendDemoController();
        
        Id testReportId;
        String csvFile = 'name,email \ntestName,test@mail.com';
        List<Report> reportList = [SELECT Id
                                        , DeveloperName 
                                     FROM Report 
                                    WHERE DeveloperName = 'DocuSign_Bulk_Send_Demo_Report'];
        
        Test.setMock(HttpCalloutMock.class, new AuthenticationMock());
         
        Test.startTest();
        
        DocuSignBulkSendDemoController.bulkSendDemoPreview(reportList[0].Id);
        DocuSignBulkSendDemoController.bulkSendDemoAura(reportList[0].Id);
        
        DocuSignBulkSendDemoController.bulkSendDemo(csvFile);
        DocuSignBulkSendDemoController.bulkSendDemoAura(csvFile);
        
        DocuSignBulkSendDemoController.getWrapReportsList();

        demoController.handleCheckboxChanged();
        demoController.handleAllCheckboxes();
        
        Test.stopTest();
        
    }

}