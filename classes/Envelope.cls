public class Envelope {
    
    public String    status;	
    public String    emailSubject;	
    public Recipient recipients;
    
    public Envelope(String pStatus, String pEmailSubject) {
        this.status = pStatus;
        this.emailSubject = pEmailSubject;
        this.recipients = new Recipient();
    }
    
    public String getRecipientId() {
        Signer s = recipients.signers[0];
        return s.recipientId;
    }
    
    public class Recipient {
        public Signer[] signers;
        
        public Recipient() {
            Signer signerItem = new Signer();
            this.signers = new List<Signer>();
            this.signers.add(signerItem);
        }
    }
    
    public class Signer {
        public String name;	
        public String email;	
        public String isBulkRecipient;	
        public String recipientId;	
        public String routingOrder;	
        public Tabs   tabs;
        
        public Signer() {
            this.email = 'bulk@recipient.com';
            this.name = 'Bulk Recipient';
            this.isBulkRecipient = 'true';
            this.recipientId = DocuSignUtil.generateRandomIndex(5);
            this.routingOrder = '1';
        }
    }
    
    public class Tabs {
        public SignHereTab[] signHereTabs;
    }
    
    public class SignHereTab {
        public String xPosition;	
        public String yPosition;	
        public String pageNumber;	
    }
}