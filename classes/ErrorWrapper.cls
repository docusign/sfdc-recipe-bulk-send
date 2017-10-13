public class ErrorWrapper{
	public BulkRecipients[] bulkRecipients;
	class BulkRecipients {
		public String rowNumber;	//2
		public String email;	//-
		public String name;	//Bertha Boxer
		public ErrorDetails[] errorDetails;
	}
	
	public static ErrorWrapper parse(String json){
		return (ErrorWrapper) System.JSON.deserialize(json, ErrorWrapper.class);
	}
}