public with sharing class HTSOSS_hts_terminals_staticips extends HTSOSS_base{
  @testVisible static string base_endpoint;   //use Named Credential for Endpoint

  @AuraEnabled public String static_ip_address {get;set;}     //required for POST
  @AuraEnabled public Integer data_channel_id {get;set;}      //required for POST
  @AuraEnabled public String terminal_ip_address {get;set;}   //required for POST

  @AuraEnabled public string message {get;set;}               //for error messages returned from OSS
  @AuraEnabled public integer response_code {get;set;}        //for HTTPS status codes returned from OSS
  
  public HTSOSS_hts_terminals_staticips() {
    base_endpoint = getbase_endpoint();
  }
  //inner classes
  //object list wrapper
  public with sharing class staticip_list_wrapper{
    public string message {get;set;}          //for error messages returned from OSS
    public integer response_code {get;set;}   //for HTTPS status codes returned from OSS
    public HTSOSS_hts_terminals_staticips.staticIp[] staticip_list {get;set;}
  }
  //staticIp class
  public with sharing class staticIp{
    @AuraEnabled public String obj_id {get;set;}                //returned from GET (required for DELETE)
    @AuraEnabled public String channel_id {get;set;}            //returned from GET
    @AuraEnabled public String ip_address {get;set;}            //returned from GET
  }
  //GET
  public staticip_list_wrapper getStaticIps(HTSOSS_hts_terminals termToGet){
    staticip_list_wrapper returnWrapper = new staticip_list_wrapper();
    returnWrapper.staticip_list = new list<HTSOSS_hts_terminals_staticips.staticIp>();
    HttpRequest req = getHttpRequestObj('GET', '/hts/terminals/');
    req.setEndpoint(base_endpoint + '/hts/terminals/' + termToGet.obj_id + '/staticips');
    Http http = new Http();
    HTTPResponse res = http.send(req);
    CalloutLogs.log(req, res);
    returnWrapper.response_code = res.getStatusCode();
    if (returnWrapper.response_code == 200){
      returnWrapper.staticip_list = (list<HTSOSS_hts_terminals_staticips.staticIp>)JSON.deserialize(res.getBody(), list<HTSOSS_hts_terminals_staticips.staticIp>.class);
      returnWrapper.response_code = res.getStatusCode();
      returnWrapper.message = 'OSS returned Static IPs for terminal: ' + termToGet.terminal_id;
    } else if(returnWrapper.response_code == 404){
      returnWrapper.message = 'OSS could not find the terminal requested';
    } else if(returnWrapper.response_code == 500){
      returnWrapper.message = 'OSS failed to process the request';
    }
    return returnWrapper;
  }
  //POST
  public HTSOSS_hts_terminals_staticips postStaticIp(HTSOSS_hts_terminals termToPost, HTSOSS_hts_terminals_staticips staticIpPayload){
    HTSOSS_hts_terminals_staticips returnObj = new HTSOSS_hts_terminals_staticips();
    //validate required input fields
    if (termToPost.obj_id == null){ //fatal error, bailout
      returnObj.message = 'Input Terminal missing obj_id';
      returnObj.response_code = 400;
      return returnObj;
    }

    string validationResults = validateStaticIPForPost(staticIpPayload);
    if(validationResults.left(7) == 'INVALID'){
      returnObj.message = validationResults;
      returnObj.response_code = 400;
      return returnObj;
    }
    //setup request
    HttpRequest req = getHttpRequestObj('POST', '/hts/terminals/');
    req.setEndpoint(base_endpoint + '/hts/terminals/' + termToPost.obj_id + '/staticips');
    //serialize input Object
    req.setBody(JSON.serialize(staticIpPayload, true));  //this overload suppresses NULL values
    Http http = new Http();
    HTTPResponse res = http.send(req);
    CalloutLogs.log(req, res);
    //sequence is important here!
    returnObj.response_code = res.getStatusCode();
    //wrap return
    if(returnObj.response_code == 201){
      returnObj.response_code = res.getStatusCode();    //Need to replace that SF specific attribute!
      returnObj.message = 'OSS Successfully mapped Static IP:  ' + staticIpPayload.static_ip_address + ' to: ' +staticIpPayload.terminal_ip_address;
    } else if(returnObj.response_code == 404){
      returnObj.message = 'OSS Failed to find the Terminal for Static IP mapping';
    } else if(returnObj.response_code == 500){
      returnObj.message = 'OSS Failed to map Static IP'; 
    } else {
      returnObj.message = res.getBody();
    }
    return returnObj;
  }
  //DELETE
  public HTSOSS_hts_terminals_staticips deleteStaticIp(HTSOSS_hts_terminals termToDelete, HTSOSS_hts_terminals_staticips.staticIp ipToDelete){
    HTSOSS_hts_terminals_staticips requestObj = new HTSOSS_hts_terminals_staticips();
    HTSOSS_hts_terminals_staticips returnObj = new HTSOSS_hts_terminals_staticips();
    //validate required input fields
    if (termToDelete.obj_id == null){ //fatal error, bailout
      returnObj.message = 'Input Terminal missing obj_id';
      returnObj.response_code = 400;
      return returnObj;
    }
    if (ipToDelete.obj_id == null){ //fatal error, bailout
      returnObj.message = 'Input Static IP missing obj_id';
      returnObj.response_code = 400;
      return returnObj;
    }
    //setup request
    HttpRequest req = getHttpRequestObj('DELETE', '/hts/terminals/');
    req.setEndpoint(base_endpoint + '/hts/terminals/' + termToDelete.obj_id + '/staticips/' + ipToDelete.obj_id);
    Http http = new Http();
    HTTPResponse res = http.send(req);
    CalloutLogs.log(req, res);
    //sequence is important here!
    returnObj.response_code = res.getStatusCode();
    //wrap return
    if(returnObj.response_code == 204){
      returnObj.response_code = res.getStatusCode();    //Need to replace that SF specific attribute!
      returnObj.message = 'OSS Successfully Deleted Static IP:  ' + requestObj.static_ip_address + ' from: ' +requestObj.terminal_ip_address;
    } else if(returnObj.response_code == 404){
      returnObj.message = 'OSS Failed to find the Terminal for Static IP un-mapping';
    } else if(returnObj.response_code == 500){
      returnObj.message = 'OSS Failed to delete Static IP'; 
    } else {
      returnObj.message = res.getBody();
    }
    return returnObj;
  }
  @TestVisible private string validateStaticIPForPost(HTSOSS_hts_terminals_staticips staticIPToValidate){
    list<string> detectibleErrors = new list<string>();
    //Conditions start here //TODO: convert to Custom Metadata?
    if(staticIPToValidate.static_ip_address != null){
      //might want to add a regex, AFTER null check passes
      if(!Pattern.matches('^([0-9]{1,3}\\.){3}[0-9]{1,3}$', staticIPToValidate.static_ip_address)){
        detectibleErrors.add(' Invalid static_ip_address ');
      }
    } else {
      detectibleErrors.add(' Missing static_ip_address ');
    }
    if(staticIPToValidate.terminal_ip_address != null){ //This is a list<string>
      if(!Pattern.matches('^([0-9]{1,3}\\.){3}[0-9]{1,3}$', staticIPToValidate.terminal_ip_address)){
        detectibleErrors.add(' Invalid terminal_ip_address ');
      }
    } else {
      detectibleErrors.add(' Missing terminal_ip_address ');
    }
    if(staticIPToValidate.data_channel_id != null){
      if(staticIPToValidate.data_channel_id < 1703 || staticIPToValidate.data_channel_id > 1708){
        detectibleErrors.add(' Invalid data_channel_id ');
      }
    } else {
      detectibleErrors.add(' Missing data_channel_id ');
    }
    return stringifyErrors(detectibleErrors);
  }
}