public with sharing class HTSOSS_hts_terminals_replace extends HTSOSS_base{
  @testVisible static string base_endpoint;   //use Named Credential for Endpoint

  @AuraEnabled public list<HTSOSS_hts_terminals_asynch> terminals {get;set;}

  @AuraEnabled public string message {get;set;}               //for error messages returned from OSS
  @AuraEnabled public integer response_code {get;set;}        //for HTTPS status codes returned from OSS

  public HTSOSS_hts_terminals_replace() {   //no parameter constructor
    base_endpoint = getbase_endpoint();
    terminals = new list<HTSOSS_hts_terminals_asynch>();
  }

  //POST
  public HTSOSS_hts_terminals_replace postTerminalsToReplace(HTSOSS_hts_terminals_replace terminalsToReplace){
    HTSOSS_hts_terminals_replace returnTerminals = terminalsToReplace;
    //validate required input fields
    map<String, String> validationMap = new map<String, String>();
    for(HTSOSS_hts_terminals_asynch t : terminalsToReplace.terminals){
      if(t.terminal_id == null){ //bail out!
        returnTerminals.message = 'FATAL_ERROR Found missing Terminal Id';
        returnTerminals.response_code = 400;
        return returnTerminals;
      }
      String validationResults = validateTerminalForPOST(t);
      if(validationResults != 'VALID') {
        validationMap.put(t.terminal_id,validationResults);
      }
    }
    if(validationMap.size() > 0){ //bail out!
      returnTerminals.message = 'FATAL_ERROR Input data failed validation!';
        for(String s : validationMap.keySet()){
          returnTerminals.message += s + '\t' + validationMap.get(s);
        }
      returnTerminals.response_code = 400;
      return returnTerminals;
    }
    //serialize input Object
    HttpRequest req = getHttpRequestObj('POST', '/hts/terminals/replace');
    req.setBody(JSON.serialize(terminalsToReplace, true));  //this overload suppresses NULL values
    //system.debug(req.getBody());
    Http http = new Http();
    HTTPResponse res = http.send(req);
    CalloutLogs.log(req, res);
    //sequence is important here!
    returnTerminals.response_code = res.getStatusCode();
    //wrap return
    if(returnTerminals.response_code == 202){
      returnTerminals.terminals = (list<HTSOSS_hts_terminals_asynch>)JSON.deserialize(res.getBody(), list<HTSOSS_hts_terminals_asynch>.class);
      returnTerminals.response_code = res.getStatusCode();    //Need to replace that SF specific attribute!
      returnTerminals.message = 'Successfully Created ' + returnTerminals.terminals.size() + ' Asynchronous Jobs';
    } else if(returnTerminals.response_code == 500){
      returnTerminals.message = 'Failed to Create Asynchronous Jobs';
    } else {
      returnTerminals.message = res.getBody();
    }
    system.debug('Status Code from HTSOSS: ' + returnTerminals.response_code + ' ' + returnTerminals.message);
    return returnTerminals;
  }
}