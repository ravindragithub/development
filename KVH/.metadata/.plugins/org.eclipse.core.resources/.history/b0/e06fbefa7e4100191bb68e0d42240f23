public with sharing class HTSOSS_hts_satelliterouters extends HTSOSS_base{
  @testVisible static string base_endpoint;  //use Named Credential for Endpoint
  
  //Class variables
  public string obj_name {get;set;}
  public string model {get;set;}
  public integer serialnumber {get;set;}
  public string chip_sn {get;set;}          //Valid characters in decimal form are [0-9], or in hex form are either 0[xX][0-9a-fA-F] or [0-9a-fA-F]
  public integer obj_id {get;set;}
  public integer obj_revision {get;set;}    //required for PUT, results in NEW revision #
  //Salesforce Specific attributes 
  public string message {get;set;}          //for error messages returned from OSS
  public integer response_code {get;set;}   //for HTTPS status codes returned from OSS
  
  //Constructor
	public HTSOSS_hts_satelliterouters(){   //no parameter constructor
    base_endpoint = getbase_endpoint();
	}
	//Helper Methods
	@testVisible private HttpRequest getHttpRequestTemplate(string method){
	  HttpRequest req = new HttpRequest();
	  req.setHeader('x-oss-remote-user', UserInfo.getUserId());
	  req.setEndpoint(base_endpoint + '/hts/satelliterouters/');
	  req.setTimeout(30000);   //30 seconds
	  req.setMethod(method);
	  if(method == 'POST' || method == 'PUT'){
	    req.setHeader('Content-Type', 'application/json');
	  }
	  return req;
	}
  //Callout methods
	//A variety of GETs
	public satelliterouters_list_wrapper getSatelliteRouters(){
	  satelliterouters_list_wrapper return_wrapper = new satelliterouters_list_wrapper();
	  HttpRequest req = getHttpRequestTemplate('GET');
	  Http http = new Http();
	  HTTPResponse res = http.send(req);
	  CalloutLogs.log(req, res);
	  return_wrapper.response_code = res.getStatusCode();
	  if(return_wrapper.response_code == 200){
	    return_wrapper.satelliterouters_list = (list<HTSOSS_hts_satelliterouters>)JSON.deserialize(res.getBody(), list<HTSOSS_hts_satelliterouters>.class);
	  } else {  //some sort of exception... return empty list!
	    return_wrapper.satelliterouters_list = new list<HTSOSS_hts_satelliterouters>();
	    //Tease out that Error message...got a couple of type conversions!
	    Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
	    return_wrapper.message = (string)m.get('message');
	  }
	  system.debug(return_wrapper);
	  return return_wrapper;
	}
	//NOTE: 1 param getSatelliteRouters method deprecated. Use 5 param method for new development
	public satelliterouters_list_wrapper getSatelliteRouters(string sr_name){
	  return getSatelliteRouters(sr_name, null, null, null, null);
	}
	//overload adds new filter attribute
	public satelliterouters_list_wrapper getSatelliteRouters(string obj_name, integer max_records, String model, integer serialnumber, String chip_sn){
	  //Overloaded method to handle input Parameters
	  satelliterouters_list_wrapper return_wrapper = new satelliterouters_list_wrapper();
    //handle query parameters using utility Class
    map<string, string> param_map = new map<string, string>();
    if(obj_name != null){
      param_map.put('obj_name', obj_name);
    }
    if(max_records != null){
      param_map.put('limit', string.valueOf(max_records));
    }
    if(model != null){
      param_map.put('model', model);
    }
    if(serialnumber != null){
      param_map.put('serialnumber', string.valueOf(serialnumber));
    }
    if(chip_sn != null){
      param_map.put('chip_sn', chip_sn);
    }
    string qparams = stringify_qparams(param_map);
	  //HttpRequest req = getHttpRequestTemplate('GET');
    HttpRequest req = getHttpRequestObj('GET', '/hts/satelliterouters/');
	  req.setEndpoint(req.getEndpoint() + qparams);
	  Http http = new Http();
	  HttpResponse res = http.send(req);
	  CalloutLogs.log(req, res);
	  return_wrapper.response_code = res.getStatusCode();
	  if(return_wrapper.response_code == 200){   //NOTE: if named satrouter does not exist, will return 200 w/empty list!
	    return_wrapper.satelliterouters_list = (list<HTSOSS_hts_satelliterouters>)JSON.deserialize(res.getBody(), list<HTSOSS_hts_satelliterouters>.class);
	  } else {  //some sort of exception... return empty list!
	    return_wrapper.satelliterouters_list = new list<HTSOSS_hts_satelliterouters>();
	    //Tease out that Error message...got a couple of type conversions!
	    Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
	    return_wrapper.message = (string)m.get('message');
	  }
	  system.debug(return_wrapper);
	  return return_wrapper;
	}
	public HTSOSS_hts_satelliterouters getSatelliteRouter(HTSOSS_hts_satelliterouters sr_to_get){ 
	  //TODO: refactor for satelliterouter parameter
    HttpRequest req = getHttpRequestTemplate('GET');
    req.setEndpoint(req.getEndpoint() +  sr_to_get.obj_id);
	  Http http = new Http();
	  HTTPResponse res = http.send(req);
	  CalloutLogs.log(req, res);
	  //TODO: handle 404, 500....
	  //deserializaton should handle "message"
	  sr_to_get = (HTSOSS_hts_satelliterouters)JSON.deserialize(res.getBody(), HTSOSS_hts_satelliterouters.class);
	  sr_to_get.response_code = res.getStatusCode();
	  System.debug(sr_to_get);
	  return sr_to_get;
	}
	//POST
	public HTSOSS_hts_satelliterouters postSatelliteRouter(HTSOSS_hts_satelliterouters sr_to_post){
	  //Native API Call will not return anything if success, but might return an error message...
	  HttpRequest req = getHttpRequestTemplate('POST');
	  req.setBody(JSON.serialize(sr_to_post, true));
	  Http http = new Http();
	  HTTPResponse res = http.send(req);
	  CalloutLogs.log(req, res);
	  //TODO: handle 404, 500....
	  //deserializaton should handle "message"
	  sr_to_post.response_code = res.getStatusCode();
	  If(sr_to_post.response_code == 201){
	    sr_to_post.message = 'Successfully created Satellite Router';
	  } else {
	    system.debug(res.getBody());
	    sr_to_post.message = 'Failed to create Satellite Router';
	  }
	  System.debug(sr_to_post);
	  return sr_to_post;
	}
	  //PUT (not PATCH!)
    public HTSOSS_hts_satelliterouters putSatelliteRouter(HTSOSS_hts_satelliterouters sr_to_put){
      HttpRequest req = getHttpRequestTemplate('PUT');
      req.setEndpoint(req.getEndpoint() + sr_to_put.obj_id);
      //TODO: remove obj_id....
      //"obj_revision": "'obj_revision' is a required property"
      req.setBody(JSON.serialize(sr_to_put, true));
      Http http = new Http();
      HTTPResponse res = http.send(req);
      CalloutLogs.log(req, res);
      //TODO: handle 404, 500....
      //deserializaton should handle "message"
      system.debug('Response Code from HTSOSS: ' + res.getStatusCode());
      sr_to_put.response_code = res.getStatusCode();
      
      If(sr_to_put.response_code == 204){
        sr_to_put.message = 'Successfully updated Satellite Router';
      } else {
        
        sr_to_put.message = 'Failed to update Satellite Router';
        system.debug('Raw body from HTSOSS: ' + res.getBody());
      }
      System.debug(sr_to_put);
      return sr_to_put;
    }
    
    //DELETE
    public HTSOSS_hts_satelliterouters deleteSatelliteRouter(HTSOSS_hts_satelliterouters sr_to_delete){
      HttpRequest req = getHttpRequestTemplate('DELETE');
      req.setEndpoint(req.getEndpoint() + sr_to_delete.obj_id);
      Http http = new Http();
      HTTPResponse res = http.send(req);
      CalloutLogs.log(req, res);
      //TODO: handle 404, 500....
      //deserializaton should handle "message"
      sr_to_delete.response_code = res.getStatusCode();
      If(sr_to_delete.response_code == 204){
        sr_to_delete.message = 'Successfully deleted Satellite Router';
      } else {
        system.debug(res.getBody());
        sr_to_delete.message = 'Failed to delete Satellite Router';
      }
      System.debug(sr_to_delete);
      return sr_to_delete;
    }
	
  //inner classes
  //object list wrapper
  public with sharing class satelliterouters_list_wrapper{
    public string message {get;set;}          //for error messages returned from OSS
    public integer response_code {get;set;}   //for HTTPS status codes returned from OSS
    public HTSOSS_hts_satelliterouters[] satelliterouters_list {get;set;}
  }
}