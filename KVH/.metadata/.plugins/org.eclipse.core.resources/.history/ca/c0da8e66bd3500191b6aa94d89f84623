public class LTEOSS_lte_subscribers extends OSS_base{
  @AuraEnabled public String activation_date {get; set;}
  @AuraEnabled public String apn {get; set;}
  @AuraEnabled public String call_plan {get; set;}
  @AuraEnabled public String contract_end_date {get; set;}
  //@AuraEnabled public Integer current_usage {get; set;}
  @AuraEnabled public String ipaddress {get; set;}
  //@AuraEnabled public Boolean is_online {get; set;}
  @AuraEnabled public String last_seen {get; set;}
  @AuraEnabled public String last_seen_carrier {get; set;}
  @AuraEnabled public String status {get; set;}
  @AuraEnabled public LTEsubscriber subscriber {get; set;}
  @AuraEnabled public String subscriber_id {get; set;}
  //Salesforce Specific attributes
  @AuraEnabled public string message {get;set;}          //for error messages returned from OSS
  @AuraEnabled public integer response_code {get;set;}   //for HTTPS status codes returned from OSS

  //inner classes
  //Subscriber inner classes
  public class LTEsubscriber{ //child of LTEOSS_lte_subscribers
    @AuraEnabled public String iccid {get; set;}
    @AuraEnabled public String imsi {get; set;}
  }
  //List wrapper
  public class Subscribers_list_wrapper{
    @AuraEnabled public string message {get;set;}          //for error messages returned from OSS
    @AuraEnabled public integer response_code {get;set;}   //for HTTPS status codes returned from OSS
    @AuraEnabled public LTEOSS_lte_subscribers[] subscribers {get;set;}
  }

  public LTEOSS_lte_subscribers() {
    
  }
  //Public Methods
  public static Subscribers_list_wrapper getLTESubscribers(){
    Subscribers_list_wrapper returnObj = new Subscribers_list_wrapper();
    HttpRequest req = OSS_base.getHttpRequestObj('GET', '/lte/subscribers/');
    Http http = new Http();
    HTTPResponse res = http.send(req);
    CalloutLogs.log(req, res);
    returnObj.response_code = res.getStatusCode();
    if(returnObj.response_code == 200){
      returnObj.subscribers = (list<LTEOSS_lte_subscribers>)JSON.deserialize(res.getBody(), list<LTEOSS_lte_subscribers>.class);
      returnObj.response_code = res.getStatusCode();
    } else {
      //Tease out that Error message...got a couple of type conversions!
      Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
      returnObj.message = (string)m.get('message');
      returnObj.subscribers = new list<LTEOSS_lte_subscribers>();
    }
    system.debug(returnObj);
    return returnObj;
  }
  public static LTEOSS_lte_subscribers getLTESubscriberInfo(String subscriber_id, String iccid){
    LTEOSS_lte_subscribers returnObj = new LTEOSS_lte_subscribers();
    map<String, String> qpMap = new map<String, String>();
    if(subscriber_id != null){
      qpMap.put('subscriber_id', subscriber_id);
    }
    if(iccid != null){
      qpMap.put('iccid', iccid);
    }
    HttpRequest req = OSS_base.getHttpRequestObj('GET', '/lte/subscribers/info' + OSS_base.stringify_qparams(qpMap));
    Http http = new Http();
    HTTPResponse res = http.send(req);
    CalloutLogs.log(req, res);
    returnObj.response_code = res.getStatusCode();
    if(returnObj.response_code == 200){
      returnObj = (LTEOSS_lte_subscribers)JSON.deserialize(res.getBody(), LTEOSS_lte_subscribers.class);
      returnObj.response_code = res.getStatusCode();
    } else {
      //Tease out that Error message...got a couple of type conversions!
      Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
      returnObj.message = (string)m.get('message');
    }
    system.debug(returnObj);
    return returnObj;
  }
  public static LTEOSS_lte_subscribers postLTESubscriber(String call_plan, String iccid, String region, String subscriber_id){
    LTEOSS_lte_subscribers returnObj = new LTEOSS_lte_subscribers();
    //validate inputs (rudimentary validation!)
    if(call_plan == null || iccid == null || region == null || subscriber_id == null){
      returnObj.response_code = 500;
      returnObj.message = 'Bad request, one or more input parameters is NULL';
      return returnObj;
    }
    HttpRequest req = OSS_base.getHttpRequestObj('POST', '/lte/subscribers/activate');
    req.setBody('{"call_plan": "' + call_plan + '",' +
            ' "iccid": "' + iccid + '",' +
            ' "region": "' + region + '",' +
            ' "subscriber_id": "' + subscriber_id + '"}');
    Http http = new Http();
    HTTPResponse res = http.send(req);
    CalloutLogs.log(req, res);
    returnObj.response_code = res.getStatusCode();
    if(returnObj.response_code == 201){
      return returnObj;
    } else {
      //Tease out that Error message...got a couple of type conversions!
      Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
      returnObj.message = (string)m.get('message');
    }
    system.debug(returnObj);
    return returnObj;
  }
  public static LTEOSS_lte_subscribers putLTESubscriberHibernate(String iccid, String subscriber_id){
    LTEOSS_lte_subscribers returnObj = new LTEOSS_lte_subscribers();
    //validate inputs (rudimentary validation!)
    if(iccid == null || subscriber_id == null){
      returnObj.response_code = 500;
      returnObj.message = 'Bad request, one or more input parameters is NULL';
      return returnObj;
    }
    HttpRequest req = OSS_base.getHttpRequestObj('PUT', '/lte/subscribers/hibernate');
    req.setBody('{"iccid": "' + iccid + '",' +
                ' "subscriber_id": "' + subscriber_id + '"}');
    Http http = new Http();
    HTTPResponse res = http.send(req);
    CalloutLogs.log(req, res);
    returnObj.response_code = res.getStatusCode();
    if(returnObj.response_code == 204){
      return returnObj;
    } else {
      //Tease out that Error message...got a couple of type conversions!
      Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
      returnObj.message = (string)m.get('message');
    }
    system.debug(returnObj);
    return returnObj;
  }
  public static LTEOSS_lte_subscribers putLTESubscriberRestore(String iccid, String subscriber_id){
    LTEOSS_lte_subscribers returnObj = new LTEOSS_lte_subscribers();
    //validate inputs (rudimentary validation!)
    if(iccid == null || subscriber_id == null){
      returnObj.response_code = 500;
      returnObj.message = 'Bad request, one or more input parameters is NULL';
      return returnObj;
    }
    HttpRequest req = OSS_base.getHttpRequestObj('PUT', '/lte/subscribers/restore');
    req.setBody('{"iccid": "' + iccid + '",' +
                ' "subscriber_id": "' + subscriber_id + '"}');
    Http http = new Http();
    HTTPResponse res = http.send(req);
    CalloutLogs.log(req, res);
    returnObj.response_code = res.getStatusCode();
    if(returnObj.response_code == 204){
      return returnObj;
    } else {
      //Tease out that Error message...got a couple of type conversions!
      Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
      returnObj.message = (string)m.get('message');
    }
    system.debug(returnObj);
    return returnObj;
  }
  public static LTEOSS_lte_subscribers putLTESubscriberTerminate(String iccid){
    LTEOSS_lte_subscribers returnObj = new LTEOSS_lte_subscribers();
    //validate inputs (rudimentary validation!)
    if(iccid == null){
      returnObj.response_code = 500;
      returnObj.message = 'Bad request, one or more input parameters is NULL';
      return returnObj;
    }
    HttpRequest req = OSS_base.getHttpRequestObj('PUT', '/lte/subscribers/terminate');
    req.setBody('{"iccid": "' + iccid + '"}');
    Http http = new Http();
    HTTPResponse res = http.send(req);
    CalloutLogs.log(req, res);
    returnObj.response_code = res.getStatusCode();
    if(returnObj.response_code == 204){
      return returnObj;
    } else {
      //Tease out that Error message...got a couple of type conversions!
      Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
      returnObj.message = (string)m.get('message');
    }
    system.debug(returnObj);
    return returnObj;
  }
  public static LTEOSS_lte_subscribers putLTESubscriberSetUdf(String iccid, String subscriber_id){
    LTEOSS_lte_subscribers returnObj = new LTEOSS_lte_subscribers();
    //validate inputs (rudimentary validation!)
    if(iccid == null){
      returnObj.response_code = 500;
      returnObj.message = 'Bad request, one or more input parameters is NULL';
      return returnObj;
    }
    if(subscriber_id == null){
      subscriber_id = '';
    }
    HttpRequest req = OSS_base.getHttpRequestObj('PUT', '/lte/subscribers/'+iccid+'/setudf');
    req.setBody('{"subscriber_id": "' + subscriber_id + '"}');
    Http http = new Http();
    HTTPResponse res = http.send(req);
    CalloutLogs.log(req, res);
    returnObj.response_code = res.getStatusCode();
    if(returnObj.response_code == 204){
      return returnObj;
    } else {
      //Tease out that Error message...got a couple of type conversions!
      Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
      returnObj.message = (string)m.get('message');
    }
    system.debug(returnObj);
    return returnObj;
  }
}