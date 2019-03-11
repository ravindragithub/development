public with sharing class HTSOSS_hts_terminals extends HTSOSS_base{
  @testVisible static string base_endpoint;   //use Named Credential for Endpoint
  /*Class Attributes*/
  /*CRUD Documentation template                              //||GET[]|POST|GET<id>|PUT<id>|DELETE<id>|| (example value)*/
  public integer accessbitmask {get;set;}                    //||     |    |GET<id>|       |          ||11111111
  /*SoOoO.... "activate" is a reserved work in Apex :(
   *we get "is_active" :)*/
  //public boolean activate {get;set;}                       //||GET[]|    |GET<id>|       |          ||
  public string adminpassword {get;set;}                     //||     |    |GET<id>|       |          ||"iDirect"
  public string auto_route_to_remotes {get;set;}             //||     |    |GET<id>|       |          ||"Inherit"
  public string contactmail {get;set;}                       //||     |    |GET<id>|       |          ||""
  public string contactname {get;set;}                       //||     |    |GET<id>|       |          ||""
  @AuraEnabled
  public string contactnote {get;set;}                       //||     |    |GET<id>|       |          ||""
  public string contactphone {get;set;}                      //||     |    |GET<id>|       |          ||""
  @AuraEnabled
  public integer coremodule_id {get;set;}                    //||GET[]|POST|GET<id>|       |          ||1882
  @AuraEnabled
  public string customer_id {get;set;}                       //||     |    |GET<id>|       |          ||""
  @AuraEnabled
  public channel[] data_channels {get;set;}                  //||     |    |GET<id>|PUT<id>|          ||[{"channel_id": "1703","obj_id": "19983779-10.64.76.82","ip_address": "162.246.227.64"}]
  public boolean enableauthentication {get;set;}             //||     |    |GET<id>|       |          ||true
  public boolean enableconnectionacceleration {get;set;}     //||     |    |GET<id>|       |          ||false
  public boolean enablertpcompression {get;set;}             //||     |    |GET<id>|       |          ||false
  public boolean enablestaticroutes {get;set;}               //||     |    |GET<id>|PUT<id>|          ||
  public boolean enabletcpacceleration {get;set;}            //||     |    |GET<id>|       |          ||true
  public boolean enabletcpcompression {get;set;}             //||     |    |GET<id>|       |          ||false
  public boolean enabletcpheadercompression {get;set;}       //||     |    |GET<id>|       |          ||false
  public boolean enableudpcompression {get;set;}             //||     |    |GET<id>|       |          ||false
  public boolean enableudppayloadcompression {get;set;}      //||     |    |GET<id>|       |          ||false
  public boolean enable_multicast {get;set;}                 //||     |    |       |PUT<id>|          ||
  public string encivlen {get;set;}                          //||     |    |GET<id>|       |          ||"128 bit"
  public boolean forcelogout {get;set;}                      //||     |    |GET<id>|       |          ||false
  public string freqoffsetmax {get;set;}                     //||     |    |GET<id>|       |          ||"20"
  public integer inboundkeyrollperiodsec {get;set;}          //||     |    |GET<id>|       |          ||7200
  public string initialpower {get;set;}                      //||     |    |GET<id>|       |          ||"-20"
  @AuraEnabled
  public boolean is_active {get;set;}                        //||GET[]|    |GET<id>|PUT<id>|          ||true *** SF specific mapped to "activate" in pulse... ***
  public boolean linkencryption {get;set;}                   //||     |    |GET<id>|       |          ||false
  public string maxaccelerationsession {get;set;}            //||     |    |GET<id>|       |          ||""
  public string maxlinkimpairement {get;set;}                //||     |    |GET<id>|       |          ||"10"
  public string maxpower {get;set;}                          //||     |    |GET<id>|       |          ||"-10"
  public string maxtcpstream {get;set;}                      //||     |    |GET<id>|       |          ||"100"
  public string mgmtgateway {get;set;}                       //||     |    |GET<id>|       |          ||"172.16.200.1"
  @AuraEnabled
  public string mgmtipaddress {get;set;}                     //||     |POST|GET<id>|       |          ||"172.16.200.1"
  public string mgmtsubnetmask {get;set;}                    //||     |    |GET<id>|       |          ||"255.255.255.0"
  public string minbytescompression {get;set;}               //||     |    |GET<id>|       |          ||""
  public string mincompressioncycles {get;set;}              //||     |    |GET<id>|       |          ||""
  public string nominalmodcod {get;set;}                     //||     |    |GET<id>|       |          ||"QPSK-9/10"
  @AuraEnabled
  public integer obj_id {get;set;}                           //||GET[]|    |GET<id>|PUT<id>|DELETE<id>||2045 (path attribute)
  @AuraEnabled
  public string obj_name {get;set;}                          //||     |    |GET<id>|       |          ||"KVH-Lab Term-12345678"
  public integer obj_parentid {get;set;}                     //||     |    |GET<id>|       |          ||57
  @AuraEnabled
  public integer obj_revision {get;set;}                     //||GET[]|    |GET<id>|PUT<id>|          ||1
  public string onedbcompression {get;set;}                  //||     |    |GET<id>|       |          ||""
  public string ospassword {get;set;}                        //||     |    |GET<id>|       |          ||"iDirect"
  public string radiuspassword {get;set;}                    //||     |    |GET<id>|       |          ||"iDirect"
  public string radiususername {get;set;}                    //||     |    |GET<id>|       |          ||"idirect"
  public string rtpportrange {get;set;}                      //||     |    |GET<id>|       |          ||""
  public string snrmetricadvertisement {get;set;}            //||     |    |GET<id>|       |          ||""
  public integer static_ip_data_channel_id {get;set;}         //||     |    |       |       |          ||
  public string statsmanagementprofile_id {get;set;}         //||     |    |GET<id>|       |          ||"1107"
  public string tcpcompressionportrange {get;set;}           //||     |    |GET<id>|       |          ||""
  public string tcpheadercompressionportrange {get;set;}     //||     |    |GET<id>|       |          ||""
  public string tcpportrange {get;set;}                      //||     |    |GET<id>|       |          ||""
  @AuraEnabled
  public string template_id {get;set;}                       //||     |POST|GET<id>|       |          ||"TEMPLATE_2169"
  @AuraEnabled
  public string template_version {get;set;}                  //||     |    |GET<id>|       |          ||
  public string terindetification {get;set;}                 //||     |    |GET<id>|       |          ||""
  @AuraEnabled
  public string terminal_id {get;set;}                       //||GET[]|POST|GET<id>|       |          ||12345678 ??string??
  @AuraEnabled
  public string terminal_ip_address {get;set;}               //||     |POST|       |       |          ||
  @AuraEnabled
  public string terminal_service_ip {get;set;}               //||     |    |GET<id>|       |          ||
  @AuraEnabled
  public integer terminaltype_id {get;set;}                  //||     |POST|GET<id>|       |          ||1828
  public string thresholdprofile_id {get;set;}               //||     |    |GET<id>|       |          ||"1655"
  public string udpcompressionmethod {get;set;}              //||     |    |GET<id>|       |          ||"ECRTP(1)"
  public string udppayloadportrange {get;set;}               //||     |    |GET<id>|       |          ||""
  public integer udppayloadsize {get;set;}                   //||     |    |GET<id>|       |          ||100
  public string udpportrange {get;set;}                      //||     |    |GET<id>|       |          ||""
  public integer updateprofile_id {get;set;}                 //||     |    |GET<id>|       |          ||349
  public string userpassword {get;set;}                      //||     |    |GET<id>|       |          ||"iDirect"
  //Salesforce specific Class Attributes...
  @AuraEnabled
  public string message {get;set;}          //for error messages returned from OSS
  @AuraEnabled
  public integer response_code {get;set;}   //for HTTPS status codes returned from OSS
  
  public HTSOSS_hts_terminals(){   //no parameter constructor
    base_endpoint = getbase_endpoint();
  }
  //Callout methods
  //A "universal" GET 
  //NOTE: 2 param getTerminals method deprecated. Use 3 param method for new development
  public terminals_list_wrapper getTerminals(integer max_records, string obj_name){
    return getTerminals(max_records, obj_name, null);
  }
  //overload adds new filter attribute
  public terminals_list_wrapper getTerminals(integer max_records, string obj_name, integer coremodule_id){
    terminals_list_wrapper return_wrapper = new terminals_list_wrapper();
    //handle query parameters using utility Class
    map<string, string> param_map = new map<string, string>();
    if(max_records != null){
      param_map.put('limit', string.valueOf(max_records));
    }
    if(obj_name != null){
      param_map.put('terminal_id', obj_name);
    }
    if(coremodule_id != null){
      param_map.put('coremodule_id', string.valueOf(coremodule_id));
    }
    string qparams = stringify_qparams(param_map);
    
    //HttpRequest req = getHttpRequestTemplate('GET');
    HttpRequest req = getHttpRequestObj('GET', '/hts/terminals/');
    req.setEndpoint(req.getEndpoint() + qparams);    
    
    Http http = new Http();
    HTTPResponse res = http.send(req);
    CalloutLogs.log(req, res); 
    return_wrapper.response_code = res.getStatusCode();
    if(return_wrapper.response_code == 200){
      return_wrapper.terminals_list = (list<HTSOSS_hts_terminals>)JSON.deserialize(res.getBody(), list<HTSOSS_hts_terminals>.class);
    } else {  //some sort of exception... return empty list!
     return_wrapper.terminals_list = new list<HTSOSS_hts_terminals>();
     //Tease out that Error message...got a couple of type conversions!
     Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
     return_wrapper.message = (string)m.get('message');
    }
    system.debug(return_wrapper); 
    //CalloutLogs.logEntries.add(CalloutLogs.convert(req, res));
    return return_wrapper;
  }
  
  public HTSOSS_hts_terminals getTerminal(HTSOSS_hts_terminals terminalToGet){
    HTSOSS_hts_terminals returnTerminal = terminalToGet;
    //validate required input fields
    string validationResults = validateTerminalForGET(terminalToGet);
    if(validationResults.left(7) == 'INVALID'){
      returnTerminal.message = validationResults;
      returnTerminal.response_code = 400;
      return returnTerminal;
    }
    //HttpRequest req = getHttpRequestTemplate('GET');
    HttpRequest req = getHttpRequestObj('GET', '/hts/terminals/');
    req.setEndpoint(req.getEndpoint() + terminalToGet.obj_id);
    Http http = new Http();
    HTTPResponse res = http.send(req);
    CalloutLogs.log(req, res);
    //system.debug('Async Logger Job Id: ' + CalloutLogs.log(req, res));
    returnTerminal.response_code = res.getStatusCode();
    //wrap return
    if(returnTerminal.response_code == 200){
      returnTerminal = (HTSOSS_hts_terminals)JSON.deserialize(res.getBody(), HTSOSS_hts_terminals.class);
      returnTerminal.response_code = 200; //need to replace that Salesforce specific attribute.
    } else if(returnTerminal.response_code == 404){
      returnTerminal.message = 'Terminal not found';
    }else if(returnTerminal.response_code == 500){
      returnTerminal.message = 'Failed to GET Terminal';
    }
    system.debug('Status Code from HTSOSS: ' + returnTerminal.response_code + ' ' + returnTerminal.message);
    //CalloutLogs.logEntries.add(CalloutLogs.convert(req, res));
    return returnTerminal;
  }
  
  
  //POST
  public HTSOSS_hts_terminals postTerminal(HTSOSS_hts_terminals terminalToPost){
    HTSOSS_hts_terminals returnTerminal = terminalToPost;
    //validate required input fields
    string validationResults = validateTerminalForPOST(terminalToPost);
    if(validationResults.left(7) == 'INVALID'){
      returnTerminal.message = validationResults;
      returnTerminal.response_code = 400;
      return returnTerminal;
    }
    //serialize input Object
    //HttpRequest req = getHttpRequestTemplate('POST');
    HttpRequest req = getHttpRequestObj('POST', '/hts/terminals/');
    req.setBody(JSON.serialize(terminalToPost, true));  //this overload suppresses NULL values
    Http http = new Http();
    HTTPResponse res = http.send(req);
    CalloutLogs.log(req, res);
    //system.debug('Async Logger Job Id: ' + CalloutLogs.log(req, res));
    returnTerminal.response_code = res.getStatusCode();
    //wrap return
    if(returnTerminal.response_code == 201){
      returnTerminal.message = 'Successfully Created Terminal';
    } else if(returnTerminal.response_code == 500){
      returnTerminal.message = 'Failed to Create Terminal';
    } else {
      returnTerminal.message = res.getBody();
    }
    system.debug('Status Code from HTSOSS: ' + returnTerminal.response_code + ' ' + returnTerminal.message);
    return returnTerminal;
  }
  
  //PUT (not PATCH)
  public HTSOSS_hts_terminals putTerminal(HTSOSS_hts_terminals terminalToPut){
    HTSOSS_hts_terminals requestObj = new HTSOSS_hts_terminals();
    HTSOSS_hts_terminals responseObj = terminalToPut;
    //require for API Resource PATH
    requestObj.obj_id = terminalToPut.obj_id;
    //PUT as few parameters as needed....
    requestObj.obj_revision = terminalToPut.obj_revision;
    requestObj.is_active = terminalToPut.is_active;
    requestObj.coremodule_id = terminalToPut.coremodule_id;
    requestObj.enable_multicast = terminalToPut.enable_multicast;
    requestObj.enablestaticroutes = terminalToPut.enablestaticroutes;
    requestObj.static_ip_data_channel_id = terminalToPut.static_ip_data_channel_id;
    //validate required input fields
    string validationResults = validateTerminalForPUT(requestObj);
    if(validationResults.left(7) == 'INVALID'){
      responseObj.message = validationResults;
      responseObj.response_code = 400;
      return responseObj;
    }
    //serialize input Object
    HttpRequest req = getHttpRequestObj('PUT', '/hts/terminals/');
    req.setBody(JSON.serialize(requestObj, true));  //this overload suppresses NULL values
    req.setEndpoint(req.getEndpoint() + requestObj.obj_id);
    Http http = new Http();
    HTTPResponse res = http.send(req);
    CalloutLogs.log(req, res);
    responseObj.response_code = res.getStatusCode();
    //wrap return
    if(responseObj.response_code == 204){
      responseObj.message = 'Successfully Updated Terminal';
    } else if(responseObj.response_code == 404){
      responseObj.message = 'Terminal not found';
    }else if(responseObj.response_code == 500){
      responseObj.message = 'Failed to Update Terminal';
    }
    system.debug('Status Code from HTSOSS: ' + responseObj.response_code + ' ' + responseObj.message);
    return responseObj;
  }
  
  //DELETE
  public HTSOSS_hts_terminals deleteTerminal(HTSOSS_hts_terminals terminalToDelete){
    HTSOSS_hts_terminals returnTerminal = terminalToDelete;
    //validate required input fields
    string validationResults = validateTerminalForDELETE(terminalToDelete);
    if(validationResults.left(7) == 'INVALID'){
      returnTerminal.message = validationResults;
      returnTerminal.response_code = 400;
      return returnTerminal;
    }
    //serialize input Object
    //HttpRequest req = getHttpRequestTemplate('DELETE');
    HttpRequest req = getHttpRequestObj('DELETE', '/hts/terminals/');
    //req.setBody(JSON.serialize(terminalToDelete, true));  //this overload suppresses NULL values
    req.setEndpoint(req.getEndpoint() + terminalToDelete.obj_id);
    Http http = new Http();
    HTTPResponse res = http.send(req);
    CalloutLogs.log(req, res);
    returnTerminal.response_code = res.getStatusCode();
    //wrap return
    if(returnTerminal.response_code == 204){
      returnTerminal.message = 'Successfully Deleted Terminal';
    } else if(returnTerminal.response_code == 404){
      returnTerminal.message = 'Terminal not found';
    }else if(returnTerminal.response_code == 500){
      returnTerminal.message = 'Failed to Delete Terminal';
    }
    system.debug('Status Code from HTSOSS: ' + returnTerminal.response_code + ' ' + returnTerminal.message);
    return returnTerminal;
  }
  //Helper methods
  @testVisible private string validateTerminalForGET(HTSOSS_hts_terminals terminalToGet){
    string results = 'Not Validated';
    list<string> errorsDetected = new list<string>();
    //Conditions start here
    //TODO: convert to Custom Metadata?
    if(terminalToGet.obj_id == null){
      errorsDetected.add(' Missing obj_id ');
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
  @testVisible private string validateTerminalForDELETE(HTSOSS_hts_terminals terminalToDelete){
    string results = 'Not Validated';
    list<string> errorsDetected = new list<string>();
    //Conditions start here
    //TODO: convert to Custom Metadata?
    if(terminalToDelete.obj_id == null){
      errorsDetected.add(' Missing obj_id ');
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
  
  @testVisible private string validateTerminalForPUT(HTSOSS_hts_terminals terminalToPut){
    string results = 'Not Validated';
    list<string> errorsDetected = new list<string>();
    //Conditions start here
    //TODO: convert to Custom Metadata?
    if(terminalToPut.obj_id == null){
      errorsDetected.add(' Missing obj_id ');
    }
    if(terminalToPut.obj_revision == null){
      errorsDetected.add(' Missing obj_revision ');
    }
    if(terminalToPut.enablestaticroutes != null && terminalToPut.static_ip_data_channel_id == null){
      errorsDetected.add(' Missing static_ip_data_channel_id, required when enabling/disabling static routes ');
    }
    if(terminalToPut.static_ip_data_channel_id != null && terminalToPut.enablestaticroutes == null){
      errorsDetected.add(' Missing enablestaticroutes, required when referencing static routes ');
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
  
  //inner classes
  //object list wrapper
  public with sharing class terminals_list_wrapper{
    public string message {get;set;}          //for error messages returned from OSS
    public integer response_code {get;set;}   //for HTTPS status codes returned from OSS
    public HTSOSS_hts_terminals[] terminals_list {get;set;}
  }
  //data channels
  public with sharing class channel{
    public Boolean enablestaticroutes {get;set;}
    public String obj_id {get;set;}
  }
}