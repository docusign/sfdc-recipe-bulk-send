@isTest
public class DemoDocuSignBulkSendControllerTest {    
    
    @isTest(SeeAllData='true')
    public static void test() {
        
        Contact testContact = new Contact(
            FirstName = 'ContactFORUnitTestBulkDemoSend',
            LastName  = 'ContactFORUnitTestBulkDemoSend',
            Email     = 'contactFORUnitTestBulkDemoSend@demo.test.bulk.send'
        );
        insert testContact;
        
        DemoDocuSignBulkSendController demoController = new DemoDocuSignBulkSendController();
        
        Id testReportId;
        String csvFile = 'name,email \ntestName,test@mail.com';
        List<Report> reportList = [SELECT Id
                                        , DeveloperName 
                                     FROM Report 
                                    WHERE DeveloperName = 'Report_For_Unit_Test_Bulk_Demo_Send'];
        
        Test.setMock(HttpCalloutMock.class, new AuthenticationMock());
        
        Test.startTest();
        
        DemoDocuSignBulkSendController.bulkSendPreview(reportList[0].Id);
        DemoDocuSignBulkSendController.bulkSendPreviewAura(reportList[0].Id);
        
        DemoDocuSignBulkSendController.bulkSend(csvFile);
        DemoDocuSignBulkSendController.bulkSendAura(csvFile);
        
        DemoDocuSignBulkSendController.getWrapReportsList();

        demoController.handleCheckboxChanged();
        demoController.handleAllCheckboxes();
        
        Test.stopTest();
        
    }

}