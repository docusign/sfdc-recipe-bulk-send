global class DocuSignRequests {
    
    @AuraEnabled
    public static DocuSignResponse basicAuthCallout(DocuSign_Signing_Recipe_Integration__mdt integrationMdt){
        
        DocuSignResponse dsResponse;
        String baseUrl = '';
        String endPoint = '';
        String authHeader = DocuSignUtil.generateAuthHeader(integrationMdt);
                
        endPoint = 'callout:' + integrationMdt.Named_Credential_API_Name__c + '/restapi/v2/login_information';
        
        HttpRequest req = new HttpRequest();
        
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('X-DocuSign-Authentication', authHeader );
        req.setEndpoint(endPoint);
                
        Http http = new Http();
        HTTPResponse response = http.send(req);
        
        if(response.getStatusCode() == 200) {
			
            AuthResponse authRes = AuthResponse.parse(response.getBody());
            baseUrl = AuthResponse.getBaseUrl(authRes.loginAccounts);            
            dsResponse = new DocuSignResponse(response.getStatusCode(), new ErrorDetails(), baseUrl);
            
        } else {
            dsResponse = new DocuSignResponse(response.getStatusCode(), new ErrorDetails( response.getBody() ), baseUrl);            
        }
        
        return dsResponse;
    }
    
    public static DocuSignResponse createEnvelope(DocuSign_Signing_Recipe_Integration__mdt integrationMdt, String baseUrl){
        
        DocuSignResponse dsResponse = new DocuSignResponse();
        CreateEnvelopeResponse createdEnvelopedRes;
        String authHeader = DocuSignUtil.generateAuthHeader(integrationMdt);
        String endPoint = '';
        
        endPoint = 'callout:' + integrationMdt.Named_Credential_API_Name__c + baseUrl.substringAfter('https://demo.docusign.net') + '/envelopes';
        
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint(endPoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('X-DocuSign-Authentication', authHeader);
        
        Envelope envelopeItem = new Envelope('created', 'demo');
        
        req.setBody(JSON.serialize(envelopeItem));
        
        Http http = new Http();
        HTTPResponse response = http.send(req);
        
        if(response.getStatusCode() == 201) {
            
            createdEnvelopedRes = CreateEnvelopeResponse.parse( response.getBody() );
            createdEnvelopedRes.recipientId = envelopeItem.getRecipientId();
            dsResponse = new DocuSignResponse(response.getStatusCode(), new ErrorDetails(), createdEnvelopedRes);
            
        } else {
            dsResponse = new DocuSignResponse(response.getStatusCode(), new ErrorDetails( response.getBody() ), createdEnvelopedRes);
        }
                
        return dsResponse;
    }
    
    public static DocuSignResponse uploadBulkRecipientsList(DocuSign_Signing_Recipe_Integration__mdt integrationMdt, String baseUrl, String envelopeId, String recipientId, String bulkRecipientsCSV) {
        
        DocuSignResponse dsResponse = new DocuSignResponse();
        String authHeader = DocuSignUtil.generateAuthHeader(integrationMdt);
        String body = '';
        String endPoint = '';
        
        endPoint = 'callout:' + integrationMdt.Named_Credential_API_Name__c + baseUrl.substringAfter('https://demo.docusign.net') + '/envelopes/' + envelopeId + '/recipients/' + recipientId + '/bulk_recipients';
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endPoint);
        req.setMethod('PUT');
        
        req.setHeader('X-DocuSign-Authentication', authHeader);
        req.setHeader('Content-Type', 'text/csv');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Disposition', 'file;filename=dsbulk.csv;fileExtension=.csv');
        
        body = bulkRecipientsCSV; 
        req.setBody(body);
        
        Http http = new Http();
        
        HTTPResponse response = http.send(req);
        
        if(response.getStatusCode() == 200) {
            
            dsResponse = new DocuSignResponse(response.getStatusCode(), new ErrorDetails(), '');
            
        } else {
            
            ErrorWrapper errors = ErrorWrapper.parse(response.getBody());
            dsResponse = new DocuSignResponse(response.getStatusCode(), errors.BulkRecipients[0].errorDetails[0], '');
            
        } 
        
        return dsResponse;
    }
    
    
    
}