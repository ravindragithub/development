public with sharing class HTSOSS_hts_terminals_status extends HTSOSS_base{
  //Class attributes
  @AuraEnabled public string activation_state {get;set;}
  @AuraEnabled public string config_state {get;set;}
  @AuraEnabled public string detail_message {get;set;}
  @AuraEnabled public string distress_state {get;set;}
  @AuraEnabled public integer obj_id {get;set;}
  @AuraEnabled public string obj_name {get;set;}
  @AuraEnabled public integer obj_parentid {get;set;}
  @AuraEnabled public string operational_state {get;set;}
  @AuraEnabled public string operational_state_detail {get;set;}
  @AuraEnabled public string operational_state_id {get;set;}
  @AuraEnabled public string performance_state {get;set;}
  @AuraEnabled public string performance_state_detail {get;set;}
  @AuraEnabled public string performance_state_id {get;set;}
  @AuraEnabled public string state_calculation_done {get;set;}
  @AuraEnabled public string update_state {get;set;}
  @AuraEnabled public string update_state_detail {get;set;}
  @AuraEnabled public string update_state_id {get;set;}
  //Salesforce specific Class Attributes....
  @AuraEnabled public string message {get;set;}            //for error messages returned from OSS
  @AuraEnabled public integer response_code {get;set;}     //for HTTPS status codes returned from OSS
  //Class internal use only...
  @testVisible static string base_endpoint;   //use Named Credential for Endpoint
  
  public HTSOSS_hts_terminals_status(){   //no parameter constructor
    base_endpoint = getbase_endpoint();
  }
  public HTSOSS_hts_terminals_status getTerminalStatus(HTSOSS_hts_terminals terminalToGet){
    HTSOSS_hts_terminals_status terminalStatus = new HTSOSS_hts_terminals_status();
    HttpRequest req = new HttpRequest();
    req.setHeader('x-oss-remote-user', UserInfo.getUserId());
    req.setEndpoint(base_endpoint + '/hts/terminals/' + terminalToGet.obj_id + '/status');
    system.debug(req.getEndpoint());
    req.setTimeout(30000);   //30 seconds
    req.setMethod('GET');
    Http http = new Http();
    HTTPResponse res = http.send(req);
    CalloutLogs.log(req, res);
    terminalStatus = (HTSOSS_hts_terminals_status)JSON.deserialize(res.getBody(), HTSOSS_hts_terminals_status.class);
    terminalStatus.response_code = res.getStatusCode();
    //system.debug(res.getBody());
    return terminalStatus;
  }
}