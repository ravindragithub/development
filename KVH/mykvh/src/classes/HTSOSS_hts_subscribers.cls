public with sharing class HTSOSS_hts_subscribers extends HTSOSS_base{
  @testVisible static string base_endpoint;  //use Named Credential for Endpoint
  
  // Constructor
  public HTSOSS_hts_subscribers(){
    base_endpoint = getbase_endpoint();
  }
  //Class attributes
	@AuraEnabled public string obj_id {get;set;} // "00000000-0000-0001-0000-00000000000b",
	@AuraEnabled public string status {get;set;} // "Active",
	@AuraEnabled public string subscriber_id {get;set;} // "10.64.9",
	@AuraEnabled public string subscriber_plan_id {get;set;} // ""
	@AuraEnabled public list<string> subscriber_ip_addresses {get;set;}
  @AuraEnabled public Boolean subscriber_detailed_report {get;set;} //typically false.. available for POST, not required
	//Salesforce specific Class Attributes....
  @AuraEnabled public string message {get;set;}          //for error messages returned from OSS
  @AuraEnabled public integer response_code {get;set;}   //for HTTPS status codes returned from OSS
  
  //Callout methods
  //A variety of GETs
  public subscribers_list_wrapper getSubscribersList(integer max_records, string subscriberId){
    subscribers_list_wrapper returnWrapper = new subscribers_list_wrapper();
    //handle query parameters using base Class
    map<string, string> param_map = new map<string, string>();
    if(max_records != null){
      param_map.put('limit', string.valueOf(max_records));
    }
    if(subscriberId != null){
      param_map.put('subscriber_id', subscriberId);
    }
    string qparams = stringify_qparams(param_map);
    HttpRequest req = getHttpRequestObj('GET', '/hts/subscribers/');
    req.setEndpoint(req.getEndpoint() + qparams);    
    
    Http http = new Http();
    HTTPResponse res = http.send(req);
    CalloutLogs.log(req, res);
    returnWrapper.response_code = res.getStatusCode();
    
    if(returnWrapper.response_code == 200 || returnWrapper.response_code == 301){
      returnWrapper.subscribers_list = (list<HTSOSS_hts_subscribers>)JSON.deserialize(res.getBody(), list<HTSOSS_hts_subscribers>.class);
    } else if(returnWrapper.response_code == 404){  //404 from OSS just returns an Error message
      map<String, Object> message404 = (map<String, Object>)JSON.deserializeUntyped(res.getBody()); //deserialize error
      returnWrapper.message = (String)message404.get('message');                      //set the message value
      returnWrapper.subscribers_list = new list<HTSOSS_hts_subscribers>();            //synthesize the list
    } else {  //some sort of exception... return empty list!
      //Tease out that Error message...got a couple of type conversions!
      Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
      returnWrapper.message = (string)m.get('message');
      returnWrapper.subscribers_list = new list<HTSOSS_hts_subscribers>();
    }
    return returnWrapper;
  }
  
  public HTSOSS_hts_subscribers getSubscriber(HTSOSS_hts_subscribers subscriberToGet){
    HTSOSS_hts_subscribers returnSubscriber = new HTSOSS_hts_subscribers();
    string validationResults = validateSubscriberId(subscriberToGet);
    if(validationResults.left(7) == 'INVALID'){
      returnSubscriber.message = validationResults;
      returnSubscriber.response_code = 400;
      return returnSubscriber;
    }
    HttpRequest req = getHttpRequestObj('GET', '/hts/subscribers/');
    req.setEndpoint(req.getEndpoint() + subscriberToGet.obj_id);
    Http http = new Http();
    HTTPResponse res = http.send(req);
    CalloutLogs.log(req, res);
    returnSubscriber.response_code = res.getStatusCode();
    //wrap return
    if(returnSubscriber.response_code == 200){
      returnSubscriber = (HTSOSS_hts_subscribers)JSON.deserialize(res.getBody(), HTSOSS_hts_subscribers.class);
      returnSubscriber.response_code = 200; //need to replace that Salesforce specific attribute.
    } else if(returnSubscriber.response_code == 404){
      returnSubscriber.message = 'Subscriber not found';
    }else if(returnSubscriber.response_code == 500){
      returnSubscriber.message = 'Failed to GET Subscriber';
    }
    return returnSubscriber;
  }
  
  //POST
  public HTSOSS_hts_subscribers postSubscriber(HTSOSS_hts_subscribers subscriberToPost){
    HTSOSS_hts_subscribers returnSubscriber = subscriberToPost;
    //validate required input fields
    string validationResults = validateSubscriberForPost(subscriberToPost);
    if(validationResults.left(7) == 'INVALID'){
      returnSubscriber.message = validationResults;
      returnSubscriber.response_code = 400;
      return returnSubscriber;
    } //else...
    HttpRequest req = getHttpRequestObj('POST', '/hts/subscribers/');
    req.setBody(JSON.serialize(subscriberToPost, true));
    Http http = new Http();
    HTTPResponse res = http.send(req);
    CalloutLogs.log(req, res);
    returnSubscriber.response_code = res.getStatusCode();
    if(returnSubscriber.response_code == 201){
      returnSubscriber.message = 'Successfully Created Subscriber!';
    } else if(returnSubscriber.response_code == 500){
      returnSubscriber.message = 'Failed to POST Subscriber';
    }
    return returnSubscriber;
  }
  //DELETE
  public HTSOSS_hts_subscribers deleteSubscriber(HTSOSS_hts_subscribers subscriberToDelete){
    HTSOSS_hts_subscribers returnSubscriber = subscriberToDelete;
    string validationResults = validateSubscriberId(subscriberToDelete);
    if(validationResults.left(7) == 'INVALID'){
      returnSubscriber.message = validationResults;
      returnSubscriber.response_code = 400;
      return returnSubscriber;
    }
    HttpRequest req = getHttpRequestObj('DELETE', '/hts/subscribers/');
    req.setEndpoint(req.getEndpoint() + subscriberToDelete.obj_id);
    Http http = new Http();
    HTTPResponse res = http.send(req);
    CalloutLogs.log(req, res);
    returnSubscriber.response_code = res.getStatusCode();
    if(returnSubscriber.response_code == 204){
      returnSubscriber.message = 'Successfully Deleted Subscriber!';
    } else if(returnSubscriber.response_code == 404){
      returnSubscriber.message = 'Subscriber not found';
    } else if(returnSubscriber.response_code == 500){
      returnSubscriber.message = 'Failed to DELETE Subscriber';
    }
    return returnSubscriber;
  }
  //PUT
  public HTSOSS_hts_subscribers putSubscriber(HTSOSS_hts_subscribers subscriberToPut){
    HTSOSS_hts_subscribers returnSubscriber = subscriberToPut;
    string validationResults = validateSubscriberId(subscriberToPut);
    if(validationResults.left(7) == 'INVALID'){
      returnSubscriber.message = validationResults;
      returnSubscriber.response_code = 400;
      return returnSubscriber;
    }
    HttpRequest req = getHttpRequestObj('PUT', '/hts/subscribers/');
    req.setBody(JSON.serialize(subscriberToPut, true));  //this overload suppresses NULL values
    req.setEndpoint(req.getEndpoint() + subscriberToPut.obj_id);
    Http http = new Http();
    HTTPResponse res = http.send(req);
    CalloutLogs.log(req, res);
    returnSubscriber.response_code = res.getStatusCode();
    if(returnSubscriber.response_code == 204){
      returnSubscriber.message = 'Successfully Updated Subscriber!';
    } else if(returnSubscriber.response_code == 404){
      returnSubscriber.message = 'Subscriber not found';
    } else if(returnSubscriber.response_code == 500){
      returnSubscriber.message = 'Failed to PUT Subscriber';
    }
    return returnSubscriber;
  }
  //helper methods
  @TestVisible private string validateSubscriberId(HTSOSS_hts_subscribers subscriberToValidate){
    string results = 'Not Validated';
    list<string> detectibleErrors = new list<string>();
    //Conditions start here //TODO: convert to Custom Metadata?
    if(subscriberToValidate.obj_id == null){
      detectibleErrors.add(' Missing obj_id ');
    } //might want to add a regex or other format validation
    return stringifyErrors(detectibleErrors);
  }
  
  @TestVisible private string validateSubscriberForPost(HTSOSS_hts_subscribers subscriberToValidate){
    string results = 'Not Validated';
    list<string> detectibleErrors = new list<string>();
    //Conditions start here //TODO: convert to Custom Metadata?
    if(subscriberToValidate.subscriber_id != null){
      //might want to add a regex, AFTER null check passes
      //8 digits, a dash, 2 digits
      if(!Pattern.matches('\\d{8}-\\d{2}$', subscriberToValidate.subscriber_id)){
        detectibleErrors.add(' Invalid subscriber_id ');
      }
    } else {
      detectibleErrors.add(' Missing subscriber_id ');
    }

    if(subscriberToValidate.subscriber_ip_addresses == null){ //This is a list<string>
      detectibleErrors.add(' Missing subscriber_ip_addresses[] ');
    }
    if(subscriberToValidate.subscriber_plan_id == null){
      detectibleErrors.add(' Missing subscriber_plan_id ');
    }
    return stringifyErrors(detectibleErrors);
  }
  //inner classes
  //object list wrapper
  public with sharing class subscribers_list_wrapper{
    public string message {get;set;}          //for error messages returned from OSS
    public integer response_code {get;set;}   //for HTTPS status codes returned from OSS
    public HTSOSS_hts_subscribers[] subscribers_list {get;set;}
  }
}