public virtual class OSS_base {

  public static string base_endpoint;   //use Named Credential for Endpoint
  
  static {   //no parameter constructor
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
  
  public static string getbase_endpoint(){
    return base_endpoint;
  }
  public static HttpRequest getHttpRequestObj(string method, string resourcePath){
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
  public static string stringify_qparams(map<string, string> params){
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
}