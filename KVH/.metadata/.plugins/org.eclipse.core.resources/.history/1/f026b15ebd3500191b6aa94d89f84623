public with sharing class HTSOSS_hts_terminals_asynch extends HTSOSS_base{
  @testVisible static string base_endpoint;   //use Named Credential for Endpoint

  @AuraEnabled public string obj_id {get;set;}                //returned from call, is the Job ID
  
  @AuraEnabled public integer coremodule_id {get;set;}        //Required for POST
  @AuraEnabled public string mgmtipaddress {get;set;}         //Required for POST
  @AuraEnabled public string template_id {get;set;}           //Required for POST
  @AuraEnabled public string terminal_id {get;set;}           //Required for POST
  @AuraEnabled public string terminal_ip_address {get;set;}   //Required for POST
  @AuraEnabled public integer terminaltype_id {get;set;}      //Required for POST

  @AuraEnabled public Boolean complete {get;set;}             //Returned from GET status
  @AuraEnabled public Boolean result {get;set;}               //Returned from GET status

  @AuraEnabled public string message {get;set;}               //for error messages returned from OSS
  @AuraEnabled public integer response_code {get;set;}        //for HTTPS status codes returned from OSS
    
  public HTSOSS_hts_terminals_asynch() {   //no parameter constructor
    base_endpoint = getbase_endpoint();
    }
  //Callout methods
  //GET
  public HTSOSS_hts_terminals_asynch getAsyncStatus(HTSOSS_hts_terminals_asynch terminalJobToGet){
    HTSOSS_hts_terminals_asynch returnTerminal = terminalJobToGet;
    //validate required input fields
    system.debug(terminalJobToGet);
    string validationResults = validateTerminalForGET(terminalJobToGet);
    if(validationResults.left(7) == 'INVALID'){
      returnTerminal.message = validationResults;
      returnTerminal.response_code = 400;
      return returnTerminal;
    }
    //need to stringify qParams...
    HttpRequest req = getHttpRequestObj('GET', '/hts/terminals/async/status');
    req.setEndpoint(req.getEndpoint() + '?obj_id=' + terminalJobToGet.obj_id);
    Http http = new Http();
    HTTPResponse res = http.send(req);
    CalloutLogs.log(req, res);
    returnTerminal.response_code = res.getStatusCode();
    //wrap return
    if(returnTerminal.response_code == 200){
      returnTerminal = (HTSOSS_hts_terminals_asynch)JSON.deserialize(res.getBody(), HTSOSS_hts_terminals_asynch.class);
      returnTerminal.response_code = 200; //need to replace that Salesforce specific attribute.
    } else if(returnTerminal.response_code == 404){
      returnTerminal = (HTSOSS_hts_terminals_asynch)JSON.deserialize(res.getBody(), HTSOSS_hts_terminals_asynch.class);
      returnTerminal.response_code = 404; //need to replace that Salesforce specific attribute.
    } else if(returnTerminal.response_code == 500){
      returnTerminal.message = 'Failed to GET Asynchronous Job for Terminal';
    }
    system.debug('Status Code from HTSOSS: ' + returnTerminal.response_code + ' ' + returnTerminal.message);
    //CalloutLogs.logEntries.add(CalloutLogs.convert(req, res));
    return returnTerminal;
  }

  //POST
  public HTSOSS_hts_terminals_asynch postTerminalAsynch(HTSOSS_hts_terminals_asynch terminalToPost){
    HTSOSS_hts_terminals_asynch returnTerminal = terminalToPost;
    //validate required input fields
    string validationResults = validateTerminalForPOST(terminalToPost);
    if(validationResults.left(7) == 'INVALID'){
      returnTerminal.message = validationResults;
      returnTerminal.response_code = 400;
      return returnTerminal;
    }
    //serialize input Object
    //HttpRequest req = getHttpRequestTemplate('POST');
    HttpRequest req = getHttpRequestObj('POST', '/hts/terminals/async');
    req.setBody(JSON.serialize(terminalToPost, true));  //this overload suppresses NULL values
    Http http = new Http();
    HTTPResponse res = http.send(req);
    CalloutLogs.log(req, res);
    //sequence is important here!
    returnTerminal.response_code = res.getStatusCode();
    //wrap return
    if(returnTerminal.response_code == 200){
      returnTerminal = (HTSOSS_hts_terminals_asynch)JSON.deserialize(res.getBody(), HTSOSS_hts_terminals_asynch.class);
      returnTerminal.response_code = res.getStatusCode();    //Need to replace that SF specific attribute!
      returnTerminal.message = 'Successfully Created Asynchronous Job';
    } else if(returnTerminal.response_code == 500){
      returnTerminal.message = 'Failed to Create Asynchronous Job';
    } else {
      returnTerminal.message = res.getBody();
    }
    system.debug('Status Code from HTSOSS: ' + returnTerminal.response_code + ' ' + returnTerminal.message);
    return returnTerminal;
  }

  @testVisible private string validateTerminalForGET(HTSOSS_hts_terminals_asynch terminalToGet){
    string results = 'Not Validated';
    list<string> errorsDetected = new list<string>();
    //Conditions start here
    //TODO: convert to Custom Metadata?
    if(terminalToGet.obj_id == null){
      errorsDetected.add(' Missing obj_id ');
    } else if(terminalToGet.obj_id.length() != 36){
        errorsDetected.add(' obj_id incorrect length ');
    }
    //Check size of list
    If(errorsDetected.size() > 0){
      results = 'INVALID';
      for(string s : errorsDetected){
        results = results + ',' + s;
      }
    } else {
      results = 'VALID';
    }
    return results;
  }
}