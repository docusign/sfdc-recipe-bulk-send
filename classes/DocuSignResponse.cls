public class DocuSignResponse {
    
    public Integer      statusCode;
    public ErrorDetails error;
    public Object       responseBody;
    
    public DocuSignResponse() { }
    
    public DocuSignResponse(Integer pStatusCode, ErrorDetails pError, Object pResponseBody) {
        this.statusCode = pStatusCode;
        this.error = pError;
        this.responseBody = pResponseBody;
    }
    
}