global class CalloutLogs {
  
  public static list<Callout_Log__c> logEntries {get;set;} //need a static variable to avoid the pending work exception
  static{
    logEntries = new list<Callout_Log__c>();              //We want to make sure that we have an instance of the static var
  }

  public static Callout_Log__c log(HttpRequest request, HttpResponse response){
    //Converts HttpRequest and HttpResponse to string representations
    //Creates a Callout Log record, and adds it to the static list<Callout_Log__c> member
    //Returns the Callout Log record that was converted
    Callout_Log__c returnLog = new Callout_log__c();
    //Request Attributes...
    if(request != null){
      returnLog.Req_Endpoint__c = request.getEndpoint();
      returnLog.Req_Body__c = request.getBody();
      returnLog.Req_Method__c = request.getMethod();
      //HTSSF-277 populate Terminal Id Field for terminals POST
      if(returnLog.Req_Method__c == 'POST' 
           && 
        returnLog.Req_Endpoint__c.contains('/hts/terminals/')){

        returnLog.HTS_Terminal_Id__c = processTerminalId(returnLog.Req_Body__c);
      }
    }
    //Response Attributes...
    if(response != null){
      returnLog.Res_Body__c = response.getBody();
      returnLog.Res_Status_Code__c = string.valueOf(response.getStatusCode());
      returnLog.Res_Status__c = response.getStatus();
      returnLog.Res_Headers__c = processHeaders(response);
    }
    //additional Attributes
    returnLog.Time_Stamp__c = DateTime.now();
    returnLog.Time_Stamp_2__c = returnLog.Time_Stamp__c.getTime(); //high resolution time stamps
    returnLog.User_Id__c = UserInfo.getUserId();
    logEntries.add(returnLog);
    return returnLog;
  }

  public static string commitLogs(){
    string returnString = 'Failed to commit Callout Log...';
    if(logEntries != null){
      if(logEntries.size() == 0){
        returnString = 'No Callout Logs to commit...';
      } else {
        upsert logEntries;
        returnString = 'Committed ' + logEntries.size() + ' Callout Log Entries';
      }
    }
    return returnString;
  }


public static list<Callout_Log__c> getRecordsToPurge(Integer days_To_Retain)
{
  // // Retention_Policy__mdt is a "Custom MetaData Type"
  // // John Thompson wants days_To_Retain passed in so unit tests can vary it.
  // // The Production code that calls this method will have the two lines of commented-out code immediately below.
  // List<Retention_Policy__mdt> myRetentionPol = [SELECT Days__c FROM Retention_Policy__mdt WHERE DeveloperName='Callout_Log_c'];
  // Integer days_To_Retain = Integer.valueOf(myRetentionPol[0].Days__c);

  // Make sure the retention is negative regardless of what's passed in.
  Integer retain_Neg = -Math.abs(days_To_Retain);
  Time tim0 = Time.newInstance(0,0,0,0);

  // Do the addDays() on the Date.   DateTime.addDays is buggy and can return incorrect results:   https://success.salesforce.com/ideaView?id=08730000000YpPWAA0
  DateTime DTCutOff = DateTime.newInstance(Date.today().addDays(retain_Neg), tim0);
  String strDTCutOff = string.valueOf(DtCutOff).replace(' ','T') + 'Z';

  list<Callout_Log__c> retList;
  string mySOQL = 'SELECT Id, HTS_Terminal_Id__c, CreatedDate FROM Callout_Log__c WHERE CreatedDate < ' + strDtCutOff +
  ' ORDER BY CreatedDate';

  System.debug('mySOQL: ' + mySOQL);

  retList = Database.query(mySOQL);
  return retList;
}


  @testVisible private static string processHeaders(HttpResponse response){
    string returnString = 'unable to process headers....';
    map<string, string> headers = new map<string, string>();
    string[] keys = response.getHeaderKeys();
    for (string k : keys){
      headers.put(k, response.getHeader(k));
    }
    returnString = JSON.serializePretty(headers);
    system.debug(returnString);
    return returnString;
  }

  @testVisible private static string processTerminalId(string reqBody){
    string returnString = '';
    if(reqBody != null){    //Make sure that we have a non-null body
      returnString = reqBody.substringAfter('"terminal_id":"').left(8); //pluck out the terminal_id
      system.debug(returnString);
      Pattern isNumbers = Pattern.Compile('^\\d+$');                     //regex setup.. all digits
      Matcher VTIDMatch = isNumbers.Matcher(returnString);              //verify all digits
      if(!VTIDMatch.Matches()){   //if NOT...
        returnString = '';      //return an empty string
      }
    }
    return returnString;
  }
}