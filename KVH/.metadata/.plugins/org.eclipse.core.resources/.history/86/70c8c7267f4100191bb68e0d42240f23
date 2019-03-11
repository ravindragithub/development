global class serviceResults {
  public Boolean success;
  public String message;
  public Case srCase;
  //Constructors for resultCode inner class...
  //two parameter constructor
  public serviceResults(Boolean b, String s) {
    success = b;
    message = s;
  }
  //no parameter constructor
  public serviceResults(){

  }
  public void appendLog(String event, String details){
    Datetime myDT = Datetime.now(); 
    String myDate = myDT.formatGMT('yyyy-MM-dd-HH.mm.ss.SSS');
    message = message + '\n' + myDate +'\t' + event +'\t'+ details;
  }
  public void createCase(Exception e){
    Id ServCloud_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Cloud').getRecordTypeId();
    Case returnCase = new Case();
    returnCase.RecordTypeId = ServCloud_RECORD_TYPE_ID;
    returnCase.Origin = 'System Generated';
    returnCase.status = 'New';
    returnCase.subject = e.getMessage().abbreviate(250); //limit length to avoid exception
    returnCase.description = e.getStackTraceString();
    //Custom Fields....
    returnCase.Case_Symptom__c = 'Salesforce Error';
    srCase = returnCase;
  }
  public static case createExceptionCase(Exception e){
    Id ServCloud_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Cloud').getRecordTypeId();
    Case returnCase = new Case();
    returnCase.RecordTypeId = ServCloud_RECORD_TYPE_ID;
    returnCase.Origin = 'System Generated';
    returnCase.status = 'New';
    returnCase.subject = e.getMessage().abbreviate(250);
    returnCase.description = e.getStackTraceString();
    //Custom Fields....
    returnCase.Case_Symptom__c = 'Salesforce Error';
    return returnCase;
  }
}