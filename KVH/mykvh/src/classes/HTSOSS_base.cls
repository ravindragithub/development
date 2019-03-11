public virtual class HTSOSS_base {
  
  public static string base_endpoint;   //use Named Credential for Endpoint
  
  public HTSOSS_base(){   //no parameter constructor
    Production_Org_Ids__c mySetting = new Production_Org_Ids__c();  //Create a new instance of the Custom Setting
    mySetting = Production_Org_Ids__c.getOrgDefaults();           //get the Org default dataset for our Production Org
    if(UserInfo.getOrganizationId() == mySetting.Org_Id_18_char__c){
      /*We are in Production! Use Production Instance of OSS!*/
      base_endpoint = 'callout:HTSOSS';  //Production instance :9081 is unencrypted server... 
      system.debug('Operating in a Production Instance! Base Endpoint: ' + base_endpoint);
    } else {
      /*We are in Sandbox! Use DEV Instance of OSS!*/
      base_endpoint = 'callout:HTSOSS_dev';  //Development instance :9082 is unencrypted server... 
      system.debug('Operating in a Sandbox Instance! Base Endpoint: ' + base_endpoint);
    }
  }
  
  public string getbase_endpoint(){
    return base_endpoint;
  }
  public HttpRequest getHttpRequestObj(string method, string resourcePath){
    HttpRequest req = new HttpRequest();
    req.setHeader('x-oss-remote-user', UserInfo.getUserId());
    req.setEndpoint(base_endpoint + resourcePath);
    req.setTimeout(120000);   //120 seconds
    req.setMethod(method);
    if(method == 'POST' || method == 'PUT'){
      req.setHeader('Content-Type', 'application/json');
    }
    return req;
  }
  
  public string stringify_qparams(map<string, string> params){
    //Turns a map of strings to a single query parameter string with appropriate ?s and &s
    string returnString = '';
    integer counter = 0;
    for(string key : params.keySet()){
      if (params.get(key) !=null){
        if(counter == 0){
          returnString = returnString + '?';
        } else {
          returnString = returnString + '&';
        }
        string key_value_pair = EncodingUtil.urlEncode(key, 'UTF-8') + '=' + EncodingUtil.urlEncode(params.get(key), 'UTF-8');
        returnString = returnString + key_value_pair;
        counter++;
      }
    }
    return returnString;
  }
  public string stringifyErrors(list<string> validationResults){
    string returnString = 'Not Validated...';
    //Check size of list
    If(validationResults.size() > 0){
      returnString = 'INVALID';
      for(string s : validationResults){
        returnString = returnString + ',' + s;
      }
    } else {
      returnString = 'VALID';
    }
    return returnString;
  }
  public string validateTerminalForPOST(HTSOSS_hts_terminals_asynch terminalToPost){
    string results = 'Not Validated';
    map<String, String> attributeMap = new map<String, String>();
    attributeMap.put('coremodule_id', String.valueOf(terminalToPost.coremodule_id));
    attributeMap.put('mgmtipaddress', terminalToPost.mgmtipaddress);
    attributeMap.put('template_id', terminalToPost.template_id);
    attributeMap.put('terminal_id', terminalToPost.terminal_id);
    attributeMap.put('terminal_ip_address', terminalToPost.terminal_ip_address);
    attributeMap.put('terminaltype_id', String.valueOf(terminalToPost.terminaltype_id));
    return validateTerminalBase(attributeMap);
  }
  public string validateTerminalForPost(HTSOSS_hts_terminals terminalToPost){
    string results = 'Not Validated';
    map<String, String> attributeMap = new map<String, String>();
    attributeMap.put('coremodule_id', String.valueOf(terminalToPost.coremodule_id));
    attributeMap.put('mgmtipaddress', terminalToPost.mgmtipaddress);
    attributeMap.put('template_id', terminalToPost.template_id);
    attributeMap.put('terminal_id', terminalToPost.terminal_id);
    attributeMap.put('terminal_ip_address', terminalToPost.terminal_ip_address);
    attributeMap.put('terminaltype_id', String.valueOf(terminalToPost.terminaltype_id));
    return validateTerminalBase(attributeMap);
  }
  @testVisible private String validateTerminalBase(map<String, String> attributeMap){
    string results = 'Not Validated';
    list<string> errorsDetected = new list<string>();
    //Conditions start here
    //TODO: convert to Custom Metadata?
    if(attributeMap.get('coremodule_id') == null){
      errorsDetected.add(' Missing coremodule_id ');
    } else if (!Pattern.matches('^[0-9]*$',attributeMap.get('coremodule_id'))){
      errorsDetected.add(' Non-numeric coremodule_id ');
    }
    if(attributeMap.get('mgmtipaddress') == null){   //change to mgmtipaddress IBO-18
      errorsDetected.add(' Missing mgmtipaddress ');
    } else if (!Pattern.matches('^([0-9]{1,3}\\.){3}[0-9]{1,3}$',attributeMap.get('mgmtipaddress'))){
      errorsDetected.add(' Invalid mgmtipaddress ');
    }
    if(attributeMap.get('template_id') == null){
      errorsDetected.add(' Missing template_id ');
    }
    if(attributeMap.get('terminal_id') == null){
      errorsDetected.add(' Missing terminal_id ');
    } else if (!Pattern.matches('^[1-9]{1}[0-9]{6}[1-9]{1}$',attributeMap.get('terminal_id'))){
      errorsDetected.add(' Invalid terminal_id ');
    }
    if(attributeMap.get('terminal_ip_address') == null){
      errorsDetected.add(' Missing terminal_ip_address ');
    } else if (!Pattern.matches('^([0-9]{1,3}\\.){3}[0-9]{1,3}(\\/([1-9]|1[0-9]|2[0-4]))$',attributeMap.get('terminal_ip_address'))){
      errorsDetected.add(' Invalid terminal_ip_address ');
    }
    if(attributeMap.get('terminaltype_id') == null){
      errorsDetected.add(' Missing terminaltype_id ');
    } else if (!Pattern.matches('^[0-9]*$',attributeMap.get('terminaltype_id'))){
      errorsDetected.add(' Non-numeric terminaltype_id ');
    }
    //Check size of list
    If(errorsDetected.size() > 0){
      results = 'INVALID';
      for(string s : errorsDetected){
        results = results + ',' + s;
      }
      system.debug('Errors Detected: ' + results);
    } else {
      results = 'VALID';
    }
    return results;
  }
}