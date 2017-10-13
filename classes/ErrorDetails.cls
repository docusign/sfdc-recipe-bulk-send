global class ErrorDetails {
    
    public String errorCode;	
    public String message;	
    
    public ErrorDetails() { }
    
    public ErrorDetails(String json) {
        
        ErrorDetails error = ErrorDetails.parse(json);
        this.errorCode = error.errorCode;
        this.message = error.message;
        
    }
    
    public static ErrorDetails parse(String json){
        return (ErrorDetails) System.JSON.deserialize(json, ErrorDetails.class);
    }
    
    global class bulkRecipients {
        public Integer rowNumber;
        public String email;
        public String name;
        public String errorDetail;
        
    }
    
    global static bulkRecipients parseWrapper(String json){
        return (bulkRecipients) System.JSON.deserialize(json, bulkRecipients.class);
    }
}