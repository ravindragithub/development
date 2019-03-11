public class LTEOSS_lte_devices extends OSS_base{
  @AuraEnabled public String fw_ver  {get; set;}            //  "7.1.0s053 build 2933",
  @AuraEnabled public Integer group_id  {get; set;}         //  90,
  @AuraEnabled public Integer id  {get; set;}               //  10,
  @AuraEnabled public LTE_interface[] interfaces {get;set;} //
  @AuraEnabled public String last_online  {get; set;}       //  "2018-04-03T10:38:45",
  @AuraEnabled public String name  {get; set;}              //  "MAX_BR1_CC61",
  @AuraEnabled public String offline_at  {get; set;}        //  "2018-04-03T10:30:26",
  @AuraEnabled public String onlineStatus  {get; set;}      //  "ONLINE",
  @AuraEnabled public String sn  {get; set;}                //  "2935-0A29-CC61",
  @AuraEnabled public LTE_ssid_profile[] ssid_profiles_applied {get;set;} //
  @AuraEnabled public String status  {get; set;}            //  "online",
  @AuraEnabled public String virtual_device_id  {get; set;} //  "MAX_BR1_CC61"
  //Salesforce Specific attributes
  @AuraEnabled public string message {get;set;}          //for error messages returned from OSS
  @AuraEnabled public integer response_code {get;set;}   //for HTTPS status codes returned from OSS

  //inner classes
  //List wrapper
  public class Devices_list_wrapper{
    public string message {get;set;}          //for error messages returned from OSS
    public integer response_code {get;set;}   //for HTTPS status codes returned from OSS
    public LTEOSS_lte_devices[] devices {get;set;}
  }
  //Device inner classes
  public class LTE_ssid_profile{ //child of LTEOSS_lte_devices
    public Integer Id {get;set;}
    public string ssid {get;set;}
  }
  public class LTE_interface{ //child of LTEOSS_lte_devices
    public string apn {get;set;}
    public string carrier_name {get;set;}
    public integer cell_id {get;set;}
    public integer cell_plmn {get;set;}
    public LTE_cellular_signal cellular_signals {get;set;}
    public string gobi_band_class_name {get;set;}
    public string gobi_data_tech {get;set;}
    public string imei {get;set;}
    public string ip {get;set;}
    public string name {get;set;}
    public string s2g3glte {get;set;}
    public integer signal {get;set;}
    public integer signal_bar {get;set;}
    public integer signal_quality {get;set;}
    public LTE_sim[] sims {get;set;}
    public string status {get;set;}
    public string status_led {get;set;}
  }
  public class LTE_sim{ //child of "interfaces"
    public string sims_iccid {get;set;}
    public string sims_imsi {get;set;}
    public string sims_status {get;set;}
  }
  public class LTE_cellular_signal{ //child of "interfaces"
    public Integer rsrp {get;set;}
    public Integer rsrq {get;set;}
  }
  //Public Methods
  public static Devices_list_wrapper getLTEDevices(String org_id, Integer group_id){
    Devices_list_wrapper returnObj = new Devices_list_wrapper();
    HttpRequest req = OSS_base.getHttpRequestObj('GET', '/lte/devices/' + org_id + '/' + group_id);
    Http http = new Http();
    HTTPResponse res = http.send(req);
    CalloutLogs.log(req, res);
    returnObj.response_code = res.getStatusCode();
    if(returnObj.response_code == 200){
      returnObj.devices = (list<LTEOSS_lte_devices>)JSON.deserialize(res.getBody(), list<LTEOSS_lte_devices>.class);
      returnObj.response_code = res.getStatusCode();
    } else {
      //Tease out that Error message...got a couple of type conversions!
      Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
      returnObj.message = (string)m.get('message');
    }
    system.debug(returnObj);
    return returnObj;
  }

  public static LTEOSS_lte_devices getLTEDevice(String org_id, Integer group_id, Integer id){
    LTEOSS_lte_devices returnObj = new LTEOSS_lte_devices();
    HttpRequest req = OSS_base.getHttpRequestObj('GET', 
                                                 '/lte/devices/' 
                                                 + org_id + '/' 
                                                 + group_id + '/'
                                                 + id);
    HTTPResponse res = new HTTPResponse();
    Http http = new Http();
    try{
      res = http.send(req);
      system.debug(res);
      returnObj.response_code = res.getStatusCode();
      if(returnObj.response_code == 200){
        returnObj = (LTEOSS_lte_devices)JSON.deserialize(res.getBody(), LTEOSS_lte_devices.class);
        returnObj.response_code = res.getStatusCode();
      } else {
        //Tease out that Error message...got a couple of type conversions!
        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        returnObj.message = (string)m.get('message');
      }
    } catch(exception e){
      Case errorCase = serviceResults.createExceptionCase(e);
      insert errorCase;
      if(returnObj.response_code == null){
        returnObj.response_code = 500;
      }
      if(returnObj.message == null ||returnObj.message == ''){
        returnObj.message = e.getMessage();
      }
    } finally {
      CalloutLogs.log(req, res);
    }
    return returnObj;
  }
  public static LTEOSS_lte_devices postLTEDevice(String org_id, Integer group_id, String sn, String vtid){
    LTEOSS_lte_devices returnObj = new LTEOSS_lte_devices();
    String defaultKey = generateDefaultKey(sn);
    HttpRequest req = OSS_base.getHttpRequestObj('POST', 
                                                 '/lte/devices/' 
                                                 + org_id + '/' 
                                                 + group_id);
    req.setBody('{"virtual_device_id": "' + vtid + '",' +
                ' "sn": "' + sn + '",' +
                ' "shared_key": "' + defaultKey + '"}');
    HTTPResponse res = new HTTPResponse();
    Http http = new Http();
    try{
      res = http.send(req);
      system.debug(res);
      returnObj.response_code = res.getStatusCode();
      if(returnObj.response_code == 201){
        returnObj.response_code = res.getStatusCode();
      } else {
        //Tease out that Error message...got a couple of type conversions!
        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        returnObj.message = (string)m.get('message');
      }
    } catch(exception e){
      Case errorCase = serviceResults.createExceptionCase(e);
      insert errorCase;
      if(returnObj.response_code == null){
        returnObj.response_code = 500;
      }
      if(returnObj.message == null ||returnObj.message == ''){
        returnObj.message = e.getMessage();
      }
    } finally {
      CalloutLogs.log(req, res);
    }
    return returnObj;
  }
  public static LTEOSS_lte_devices updateLTEDevice(String org_id, Integer group_id, Integer id, String vtid){
    LTEOSS_lte_devices returnObj = new LTEOSS_lte_devices();
    HttpRequest req = OSS_base.getHttpRequestObj('PUT', 
                                                 '/lte/devices/' 
                                                 + org_id + '/' 
                                                 + group_id + '/'
                                                 + id);
    req.setBody('{"virtual_device_id": "' + vtid + '"}');
    HTTPResponse res = new HTTPResponse();
    Http http = new Http();
    try{
      res = http.send(req);
      system.debug(res);
      returnObj.response_code = res.getStatusCode();
      if(returnObj.response_code == 204){
        returnObj.response_code = res.getStatusCode();
      } else {
        //Tease out that Error message...got a couple of type conversions!
        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        returnObj.message = (string)m.get('message');
      }
    } catch(exception e){
      Case errorCase = serviceResults.createExceptionCase(e);
      insert errorCase;
      if(returnObj.response_code == null){
        returnObj.response_code = 500;
      }
      if(returnObj.message == null ||returnObj.message == ''){
        returnObj.message = e.getMessage();
      }
    } finally {
      CalloutLogs.log(req, res);
    }
    return returnObj;
  }

  public static LTEOSS_lte_devices deleteLTEDevice(String org_id, Integer group_id, Integer id){
    LTEOSS_lte_devices returnObj = new LTEOSS_lte_devices();
    HttpRequest req = OSS_base.getHttpRequestObj('DELETE', 
                                                 '/lte/devices/' 
                                                 + org_id + '/' 
                                                 + group_id + '/'
                                                 + id);
    HTTPResponse res = new HTTPResponse();
    Http http = new Http();
    try{
      res = http.send(req);
      system.debug(res);
      returnObj.response_code = res.getStatusCode();
      if(returnObj.response_code == 204){
        returnObj.response_code = res.getStatusCode();
      } else {
        //Tease out that Error message...got a couple of type conversions!
        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        returnObj.message = (string)m.get('message');
      }
    } catch(exception e){
      Case errorCase = serviceResults.createExceptionCase(e);
      insert errorCase;
      if(returnObj.response_code == null){
        returnObj.response_code = 500;
      }
      if(returnObj.message == null ||returnObj.message == ''){
        returnObj.message = e.getMessage();
      }
    } finally {
      CalloutLogs.log(req, res);
    }
    return returnObj;
  }
  @AuraEnabled public static String generateDefaultKey(String deviceSn){
    String returnString = 'INITIALIZING_ENGINE';  // greater than 16 characters by design!
    try{
      Blob snBlob = Blob.valueOf(deviceSn);
      Blob hash = Crypto.generateDigest('MD5', snBlob);
      returnString = replaceConfusingCharacters(EncodingUtil.base64Encode(hash).left(8));
    } catch (Exception e){
      Case errorCase = serviceResults.createExceptionCase(e);
      insert errorCase;
      returnString = 'KEY_GENERATION_FAILURE'; // greater than 16 characters by design!
    }
    return returnString;
  }
  @testVisible private static String replaceConfusingCharacters(String defaultPassword){
    String methodName = 'replaceConfusingCharacters(String defaultPassword)';
    String returnString = '';
    system.debug('METHOD_ENTRY - ' + methodName + '|Replacing O,o,0,i,I,l,L,1 with x in: ' + defaultPassword );
    String regExp = '[Oo0iIlL1]';
    returnString = defaultPassword.replaceAll(regExp, 'x'); 
    system.debug('METHOD_EXIT - ' + methodName + '|New default Password: ' + returnString);
    return returnString;
  }
}