global class UploadBulkRecipientsMock implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{ "bulkRecipientsCount": "10", "bulkRecipientsUri": "https:\\test.com" }');
        res.setStatusCode(200);
        return res;
    }
}