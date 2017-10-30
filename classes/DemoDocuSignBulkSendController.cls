global class DemoDocuSignBulkSendController {    
    
    public List<Wrapper>       wrapReportsList  { get; set; }
    public String              folderName 	    { get; set; }
    public String              warningMessage   { get; set; }
    public String              errorMessage	    { get; set; }
    public Integer             count            { get; set; }
    public Integer             index            { get; set; }
    public Boolean             tempCheckbox	    { get; set; }
    public String              selectedReportId { get; set; }
    public RecipientsInfo      recipientsInfo   { get; set; }
    
    public void init() {
        wrapReportsList = new List<Wrapper>();
        recipientsInfo = new RecipientsInfo();
        warningMessage = '';
        errorMessage = '';
        selectedReportId = '';
        folderName = 'DocuSign Demo';
        count = 0;
        index = 0;
        tempCheckbox = false;
    }
    
    public DemoDocuSignBulkSendController() {
        
        List<Report> reportsList = new List<Report>();
        
        init();
        
        reportsList = [SELECT Id
                       		, Name
                            , DeveloperName 
                       	    , FolderName
                         FROM Report 
                        WHERE FolderName =: folderName];
        
        if (!reportsList.isEmpty()) {
            for (Report report_i : reportsList) {
                wrapReportsList.add(new Wrapper(report_i, false));
            }
        }
    }
    
    @RemoteAction
    global static Results bulkSendDemoPreview(String reportId) {
        String bulkRecipientsCSV = '';
        Results result;
        RecipientsInfo recipientsInfo;
        List<RecipientWrap> recipientsList = new List<RecipientWrap>();
        
        bulkRecipientsCSV = generateBulkRecipientsCSV(reportId);
        recipientsInfo = recipientsListFromCSV(bulkRecipientsCSV);
        
        result = new Results('success', recipientsInfo, new ErrorDetails());
        
        return result;
    }
    
    @AuraEnabled
    global static Results bulkSendDemoPreviewAura(String reportId) {
        String bulkRecipientsCSV = '';
        Results result;
        RecipientsInfo recipientsInfo;
        List<RecipientWrap> recipientsList = new List<RecipientWrap>();
        
        bulkRecipientsCSV = generateBulkRecipientsCSV(reportId);
        recipientsInfo = recipientsListFromCSV(bulkRecipientsCSV);
        
        result = new Results('success', recipientsInfo, new ErrorDetails());        
        return result;
    }
    
    @RemoteAction
    global static Results bulkSendDemo(String bulkRecipientsCSV) {
        
        Results result;
        String baseUrl = '';
        CreateEnvelopeResponse createEnvelopeRes = new CreateEnvelopeResponse();
        DocuSignResponse authResponse;
        DocuSignResponse envelopeResponse;
        DocuSignResponse csvUploadResponse;
        List<RecipientWrap> recipientsList = new List<RecipientWrap>();
        
        List<DocuSign_Signing_Recipe_Integration__mdt> integrationMdtList = [SELECT Account_Id__c 
                                                                                  , Integration_Key__c 
                                                                                  , Named_Credential_API_Name__c 
                                                                               FROM DocuSign_Signing_Recipe_Integration__mdt 
                                                                              LIMIT 1];
        if (!integrationMdtList.isEmpty()) {
            
            authResponse = DocuSignRequests.basicAuthCallout(integrationMdtList[0]);
            
            if (authResponse.statusCode == 200) {
                
                baseUrl = String.valueOf( authResponse.responseBody );
                
                envelopeResponse = DocuSignRequests.createEnvelope(integrationMdtList[0], baseUrl);
                if (envelopeResponse.statusCode == 201) {
                    
                    createEnvelopeRes = (CreateEnvelopeResponse)envelopeResponse.responseBody;
                    
                    csvUploadResponse = DocuSignRequests.uploadBulkRecipientsList(integrationMdtList[0], baseUrl, createEnvelopeRes.envelopeId, createEnvelopeRes.recipientId, bulkRecipientsCSV); 
                    
                    if (csvUploadResponse.statusCode == 200) {
                        
                        result = new Results('success', 'Envelope was successfully created.', 'https://appdemo.docusign.com/prepare/' + createEnvelopeRes.envelopeId, new ErrorDetails());
                        return result;
                        
                    } else {
                        result = new Results('error', '', '', csvUploadResponse.error);
                        System.debug('result: ' + result);
                        return result;
                    }
                    
                    
                } else {
                    result = new Results('error', '', '', envelopeResponse.error);
                    return result;
                }
                
            } else {
                result = new Results('error', '', '', authResponse.error);
                return result;
            }
        }
        return result;
    }
    
    @AuraEnabled
    global static Results bulkSendDemoAura(String bulkRecipientsCSV) {
        
        System.debug(bulkRecipientsCSV);
        
        Results result;
        String baseUrl = '';
        CreateEnvelopeResponse createEnvelopeRes = new CreateEnvelopeResponse();
        DocuSignResponse authResponse;
        DocuSignResponse envelopeResponse;
        DocuSignResponse csvUploadResponse;
        List<RecipientWrap> recipientsList = new List<RecipientWrap>();
        
        List<DocuSign_Signing_Recipe_Integration__mdt> integrationMdtList = [SELECT Account_Id__c 
                                                                                  , Integration_Key__c 
                                                                                  , Named_Credential_API_Name__c 
                                                                               FROM DocuSign_Signing_Recipe_Integration__mdt 
                                                                              LIMIT 1];
        
        if (!integrationMdtList.isEmpty()) {
            authResponse = DocuSignRequests.basicAuthCallout(integrationMdtList[0]);
            
            if (authResponse.statusCode == 200) {
                
                baseUrl = String.valueOf( authResponse.responseBody );
                
                envelopeResponse = DocuSignRequests.createEnvelope(integrationMdtList[0], baseUrl);
                if (envelopeResponse.statusCode == 201) {
                    
                    createEnvelopeRes = (CreateEnvelopeResponse)envelopeResponse.responseBody;
                    
                    csvUploadResponse = DocuSignRequests.uploadBulkRecipientsList(integrationMdtList[0], baseUrl, createEnvelopeRes.envelopeId, createEnvelopeRes.recipientId, bulkRecipientsCSV);
                    
                    if (csvUploadResponse.statusCode == 200) {
                        
                        result = new Results('success', 'Envelope was successfully created.', 'https://appdemo.docusign.com/prepare/' + createEnvelopeRes.envelopeId, new ErrorDetails());
                        return result;
                        
                    } else {
                        result = new Results('error', '', '', csvUploadResponse.error);
                        System.debug('result: ' + result);
                        return result;
                    }
                    
                    
                } else {
                    result = new Results('error', '', '', envelopeResponse.error);
                    return result;
                }
                
            } else {
                result = new Results('error', '', '', authResponse.error);
                return result;
            }
        }
        return result;
    }
    
    @AuraEnabled
    public static List<Wrapper> getWrapReportsList() {
        List<Report> reportsList = new List<Report>();
        List<Wrapper> wrapReportsList = new List<Wrapper>();
        reportsList = [SELECT Id
                       		, Name
                            , DeveloperName 
                       	    , FolderName
                         FROM Report 
                        WHERE FolderName = 'DocuSign Demo'];
        
        if (!reportsList.isEmpty()) {
            for (Report report_i : reportsList) {
                wrapReportsList.add(new Wrapper(report_i, false));
            }
        }
        return wrapReportsList;
    }
    
    
    public static RecipientsInfo recipientsListFromCSV(String csvFile) {
        
        RecipientsInfo recipientInfo;
        Integer count = 0;
        List<String> columnList = new List<String>();
        List<RecipientWrap> recipientsList = new List<RecipientWrap>();
        List<String> rowList = csvFile.split('\n');
        
        if (!rowList.isEmpty()) {
            
            for (String row_i : rowList) {

                if (count < 100) {
                    columnList = row_i.split(',');
                    RecipientWrap recipient = new RecipientWrap( columnList[0].trim(), columnList[1].trim() );
                    recipientsList.add(recipient);
                }

                count++;
            }
            
        }
        recipientsList.remove(0);
			
        System.debug('recipientsList: ' + recipientsList);
        
        recipientInfo = new RecipientsInfo(recipientsList, csvFile, rowList.size()-1);

        return recipientInfo;
    }
    
    public static String generateBulkRecipientsCSV(String reportId) {        
        
        Integer rowCount = 1,
            	index = 0,
                nameIndex = -1,
                fNameIndex = -1,
                lNameIndex = -1,
                emailIndex = -1;
        String name = '',
               email = '',
               recipientName = '',
               csvFile = 'name,email \n';
        Set<String> reportIdSet = new Set<String>();
        Set<String> emailSet = new Set<String>();
        List<Reports.ReportDataCell> dataCellList = new List<Reports.ReportDataCell>();
        Map<Id, Reports.ReportResults> reportToResultMap = new Map<Id, Reports.ReportResults>();
        Map<Id, List<Reports.ReportDetailRow>> reportIdToDataRowListMap = new Map<Id, List<Reports.ReportDetailRow>>();
        Map<Id, Set<String>> reportIdToSetOfColumsMap = new Map<Id, Set<String>>();
        
        reportIdSet.add(reportId);
        
        if (!reportIdSet.isEmpty()) {
            
            reportToResultMap = obtainReportToResultMap(reportIdSet);
            
            if (!reportToResultMap.isEmpty()) {
                
                reportIdToDataRowListMap = obtainDataRowList(reportToResultMap);
                reportIdToSetOfColumsMap = obtainReportIdToSetOfColums(reportToResultMap);
                
                for ( Id reportId_i : reportIdToDataRowListMap.keySet() ) {
                    
                    if (reportIdToSetOfColumsMap.containsKey(reportId_i)) {
                        index = 0;
                        nameIndex = -1;
                        fNameIndex = -1;
                        lNameIndex = -1;
                        emailIndex = -1;
                        for (String column_i : reportIdToSetOfColumsMap.get(reportId_i)) {
                            if (column_i.toLowerCase().contains('email')) {
                                emailIndex = index;
                            }
                            if (column_i == 'FIRST_NAME') {
                                fNameIndex = index;
                            }
                            if (column_i == 'LAST_NAME') {
                                lNameIndex = index;
                            }
                            if (column_i == 'NAME') {
                                nameIndex = index;
                            }
                            
                            index++;
                        }
                        
                        dataCellList = new List<Reports.ReportDataCell>();
                        for (Reports.ReportDetailRow row_i : reportIdToDataRowListMap.get(reportId_i)) {
                            recipientName = '';
                            if (rowCount < 2000) {
                                
                                dataCellList = row_i.getDataCells();
                                
                                if (fNameIndex != -1 && lNameIndex != -1) {
                                    if (dataCellList[fNameIndex].getLabel() != '-') {
                                        recipientName += dataCellList[fNameIndex].getLabel();
                                    }
                                    if (dataCellList[lNameIndex].getLabel() != '-') {
                                        recipientName += ' ' + dataCellList[lNameIndex].getLabel();
                                    }
                                }
                                
                                if (!emailSet.contains(dataCellList.get(emailIndex).getLabel()) && dataCellList.get(emailIndex).getLabel() != '-' && recipientName != '') {
                                    csvFile += recipientName + ',' + dataCellList.get(emailIndex).getLabel() + '\n';
                                    emailSet.add(dataCellList.get(emailIndex).getLabel());
                                }
                                rowCount++;
                                
                            }
                        }                            
                    }
                }
            }
        }
        
        return csvFile;
    }
    
   
    private static Map<Id, Reports.ReportResults> obtainReportToResultMap(Set<String> reportIdSet) {
        Map<Id, Reports.ReportResults> reportToResultMap = new Map<Id, Reports.ReportResults>();
        	
        for (Id reportId_i : reportIdSet) {
            if (!reportToResultMap.containsKey(reportId_i)) {
                reportToResultMap.put(reportId_i, Reports.ReportManager.runReport(reportId_i, true));
            }
        }
        
        return reportToResultMap;
    }
    
    private static Map<Id, List<Reports.ReportDetailRow>> obtainDataRowList(Map<Id, Reports.ReportResults> reportToResultMap) {
        
        Map<Id, List<Reports.ReportDataCell>> reportIdToDataCellListMap = new Map<Id, List<Reports.ReportDataCell>>();
        Map<Id, List<Reports.ReportDetailRow>> reportIdToDataRowListMap = new Map<Id, List<Reports.ReportDetailRow>>();
        Map<String, Reports.ReportFactWithDetails> factMap = new Map<String, Reports.ReportFactWithDetails>();
        List<Reports.ReportDetailRow> tmpRowList = new List<Reports.ReportDetailRow>();
        
        for (Id reportId_i : reportToResultMap.keySet()) {
            factMap = (Map<String,reports.ReportFactWithDetails>) reportToResultMap.get(reportId_i).getFactMap();
            
            if (!reportIdToDataRowListMap.containsKey(reportId_i) && factMap.containsKey('T!T')) {
                tmpRowList = factMap.get('T!T').getRows();
                reportIdToDataRowListMap.put(reportId_i, tmpRowList);
            }
        }
        
        return reportIdToDataRowListMap;
    }
    
    private static Map<Id, Set<String>> obtainReportIdToSetOfColums(Map<Id, Reports.ReportResults> reportToResultMap) {
        Map<Id, Set<String>> reportIdToSetOfColumsMap = new Map<Id, Set<String>>();
        	
        for (Id reportId_i : reportToResultMap.keySet()) {
         	
            Reports.ReportMetadata metadata = reportToResultMap.get(reportId_i).getReportMetadata();
            if (!reportIdToSetOfColumsMap.containsKey(reportId_i)) {
                Set<String> columsSet = new Set<String>();
                columsSet.addAll(metadata.getDetailColumns());
                reportIdToSetOfColumsMap.put(reportId_i, columsSet);
            }
            
        }
        
        return reportIdToSetOfColumsMap;
    }
    
    public void handleCheckboxChanged() {
        wrapReportsList.get(index).isSelected = tempCheckbox;
    }
    
    public void handleAllCheckboxes() {
        if (!wrapReportsList.isEmpty()) {
            for (Wrapper item_i : wrapReportsList) {
                item_i.isSelected = tempCheckbox;
            }
        }
    } 
    
    
    //Wrap class
    
    public class Wrapper {
        @AuraEnabled
        public Report  reportItem { get; set; }
        @AuraEnabled
        public Boolean isSelected { get; set; }
        
        public Wrapper(Report  pReportItem, Boolean pIsSelected) {
            this.reportItem = pReportItem;
            this.isSelected = pIsSelected;
        }
    }
    
    global class Results {
        @AuraEnabled
        public String status { get; set; }
        @AuraEnabled
        public String message { get; set; }
        @AuraEnabled
        public String redirectUrl { get; set; }
        @AuraEnabled
        public ErrorDetails  errorDetail  { get; set; }
        @AuraEnabled
        public RecipientsInfo  recipientsInfo  { get; set; }
        
        public Results(String pStatus, String pMessage, String pRedirectUrl, ErrorDetails pError) {
            this.status = pStatus;
            this.message = pMessage;
            this.redirectUrl = pRedirectUrl;
            this.errorDetail = pError;
        }
        
        public Results(String pStatus, RecipientsInfo pRecipientsInfo, ErrorDetails pError) {
            this.status = pStatus;
            this.recipientsInfo = pRecipientsInfo;
            this.errorDetail = pError;
        }
    }
    
    public class RecipientWrap {
        @AuraEnabled
        public String name  { get; set; }
        @AuraEnabled
        public String email { get; set; }
        
        public RecipientWrap(String pName, String pEmail) {
            this.name = pName;
            this.email = pEmail;
        }
    }
    
    global class RecipientsInfo {
        @AuraEnabled
        public List<RecipientWrap> recipientsList { get; set; }
        @AuraEnabled
        public String              csvFile        { get; set; }
        @AuraEnabled
        public Integer 			   actualCount    { get; set; }
        
        public RecipientsInfo() { }

        public RecipientsInfo(List<RecipientWrap> pRecipientsList, String pCSVFile, Integer pActualCount) {
            this.recipientsList = pRecipientsList;
            this.csvFile = pCSVFile;
            this.actualCount = pActualCount;
        }
    }

}