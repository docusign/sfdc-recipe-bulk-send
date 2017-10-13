public class CreateEnvelopeResponse{
    
    public String envelopeId;	
    public String uri;	
    public String statusDateTime;	
    public String status;
    public String recipientId;
    
    public CreateEnvelopeResponse() {
        this.envelopeId = 'test';
        this.uri = 'test';
        this.statusDateTime = 'test';
        this.status = 'created';
        this.recipientId = '123';
    }
    
    public static CreateEnvelopeResponse parse(String json){
        return (CreateEnvelopeResponse) System.JSON.deserialize(json, CreateEnvelopeResponse.class);
    }
    
}