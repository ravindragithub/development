public with sharing class LTEOSS_lte_organizations extends OSS_base{
  //Need to be careful with regard to namespace
  //https://success.salesforce.com/issues_view?id=a1p3A0000001CBeQAM

  //use OSS attribute names for easier serialization/deserialization
  @AuraEnabled public String id {get;set;}
  @AuraEnabled public String name {get;set;}
  @AuraEnabled public Boolean primary {get;set;}
  @AuraEnabled public String status {get;set;}

  //Currently, OSS does not have a resource for a single organization....
  //@AuraEnabled public string message {get;set;}               //for error messages returned from OSS
  //@AuraEnabled public integer response_code {get;set;}        //for HTTPS status codes returned from OSS
  
  //inner classes
  //Organizations list wrapper
  public class Organizations_list_wrapper{
    public string message {get;set;}          //for error messages returned from OSS
    public integer response_code {get;set;}   //for HTTPS status codes returned from OSS
    public LTEOSS_lte_organizations[] orgs {get;set;}
  }
  //Groups
  public class Groups{
    @AuraEnabled public Integer id {get;set;}
    @AuraEnabled public String name {get;set;}
  }
  //Groups list wrapper
  public class Groups_list_wrapper{
    public string message {get;set;}          //for error messages returned from OSS
    public integer response_code {get;set;}   //for HTTPS status codes returned from OSS
    public LTEOSS_lte_organizations.Groups[] groups {get;set;}
  }
  //imported_device
  public class ImportedDevices{ //Kind of the same as a Group... yes?
    public Integer group_id {get;set;}
    public String sn {get; set;}
  }
  //imported_device wrapper
  public class ImportedDeviceWrapper{
    public string message {get;set;}          //for error messages returned from OSS
    public integer response_code {get;set;}   //for HTTPS status codes returned from OSS
    public LTEOSS_lte_organizations.ImportedDevices[] imported_devices {get;set;}
  }
  public static Organizations_list_wrapper getLTEOrganizations(){
    Organizations_list_wrapper returnObj = new Organizations_list_wrapper();
    HttpRequest req = OSS_base.getHttpRequestObj('GET', '/lte/organizations/');
    Http http = new Http();
    HTTPResponse res = http.send(req);
    CalloutLogs.log(req, res);
    returnObj.response_code = res.getStatusCode();
    if(returnObj.response_code == 200){
      returnObj.orgs = (list<LTEOSS_lte_organizations>)JSON.deserialize(res.getBody(), list<LTEOSS_lte_organizations>.class);
    } else {
      //Tease out that Error message...got a couple of type conversions!
      Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
      returnObj.message = (string)m.get('message');
      returnObj.orgs = new list<LTEOSS_lte_organizations>();
    }
    system.debug(returnObj);
    return returnObj;
  }
  //two overloads for this method...
  public static Groups_list_wrapper getGroupByOrgId(string org_id){
    Groups_list_wrapper returnObj = new Groups_list_wrapper();
    return getGroupByOrgId(org_id, null);
  }
  public static Groups_list_wrapper getGroupByOrgId(string org_id, String name){
    Groups_list_wrapper returnObj = new Groups_list_wrapper();
    HttpRequest req = new HttpRequest();
    if(name == null){
      req = OSS_base.getHttpRequestObj('GET', '/lte/organizations/' + org_id 
                                            + '/groups');
    } else {
      req = OSS_base.getHttpRequestObj('GET', '/lte/organizations/' + org_id 
                                            + '/groups?name=' + name);
    }
    Http http = new Http();
    HTTPResponse res = http.send(req);
    CalloutLogs.log(req, res);
    returnObj.response_code = res.getStatusCode();
    if(returnObj.response_code == 200){
      returnObj.groups = (list<LTEOSS_lte_organizations.Groups>)JSON.deserialize(res.getBody(), list<LTEOSS_lte_organizations.Groups>.class);
    } else {
      //Tease out that Error message...got a couple of type conversions!
      Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
      returnObj.message = (string)m.get('message');
      returnObj.groups = new list<LTEOSS_lte_organizations.Groups>();
    }
    system.debug(returnObj);
    return returnObj;
  }
  public static ImportedDeviceWrapper postToImportDevices(String deviceSN){
    ImportedDeviceWrapper returnObj = new ImportedDeviceWrapper();
    HttpRequest req = new HttpRequest();
    req = OSS_base.getHttpRequestObj('POST', '/lte/organizations/importdevices');
    req.setBody('{"serial_numbers":["' + deviceSN + '"]}');
    system.debug(req.getBody());
    Http http = new Http();
    HTTPResponse res = http.send(req);
    CalloutLogs.log(req, res);
    returnObj.response_code = res.getStatusCode();
    if(returnObj.response_code == 201){
      returnObj = (LTEOSS_lte_organizations.ImportedDeviceWrapper)JSON.deserialize(res.getBody(), LTEOSS_lte_organizations.ImportedDeviceWrapper.class);
      returnObj.response_code = 201;  //need to replace that response code....
    } else {
      //Tease out that Error message...got a couple of type conversions!
      Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
      returnObj.message = (string)m.get('message');
      returnObj.imported_devices = new list<LTEOSS_lte_organizations.ImportedDevices>();
    }
    system.debug(returnObj);
    return returnObj;
  }
}