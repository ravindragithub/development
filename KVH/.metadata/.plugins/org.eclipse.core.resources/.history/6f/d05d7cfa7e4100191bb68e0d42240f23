public with sharing class HTSOSS_hts_collections extends HTSOSS_base{ 
  @testVisible static string base_endpoint;  //use Named Credential for Endpoint
  
	// Constructor
	public HTSOSS_hts_collections(){
	  base_endpoint = getbase_endpoint();
	}

	//inner Classes
	//RTP
	public with sharing class rtp{ //RouterTypes, Terminals, Plans
    public list<satellite_router_type> satellite_router_types {get;set;}
    public list<subscriber_plans> subscriber_plans {get;set;}
	  public list<terminal_templates> terminal_templates {get;set;}
	  public list<terminal_type> terminal_types {get;set;}
	  //Salesforce specific properties
	  public string message {get;set;}          //for error messages returned from OSS
	  public integer response_code {get;set;}   //for HTTPS status codes returned from OSS
	}
	
  public with sharing class satellite_router_type{
    public string obj_id {get;set;} //NOT an integer!
    public string obj_name {get;set;}
  }
  
	public with sharing class subscriber_plans{
	  public string obj_id {get;set;}
	  public string obj_name {get;set;}
    public double upload_cir {get; set;}
    public double out_bmc_download_mir {get; set;}
    public double download_cir {get; set;}
    public double in_bmc_download_mir {get; set;}
    public double out_bmc_upload_mir {get; set;}
    public double in_bmc_upload_mir {get; set;}
	}
	
  public with sharing class terminal_templates{
    public string obj_id {get;set;}
    public string obj_name {get;set;}
    public string version {get;set;}
  }
	
	public with sharing class terminal_type{
	  public integer obj_id {get;set;}
	  public string obj_name {get;set;} 
	}
	//Inner Class for terminalnetworks (Coming soon!!)
	public with sharing class terminalnetworks{
	  public list<terminalnetwork> terminalnetworks{get;set;}
	  //Salesforce specific properties
    public string message {get;set;}          //for error messages returned from OSS
    public integer response_code {get;set;}   //for HTTPS status codes returned from OSS
	}
	public with sharing class terminalnetwork{
    public integer obj_parentid {get;set;}
    public string eth0ip {get;set;}
	}
	// Methods
	public HTSOSS_hts_collections.rtp getRtp(){
	  HTSOSS_hts_collections.rtp returnKvhhts = new HTSOSS_hts_collections.rtp();
	  HttpRequest req = new HttpRequest();
    req.setHeader('x-oss-remote-user', UserInfo.getUserId());
	  req.setEndpoint(base_endpoint + '/hts/collections/rtp');
	  req.setTimeout(30000);   //30 seconds
	  req.setMethod('GET');
	  Http http = new Http();
	  HTTPResponse res = http.send(req);
	  CalloutLogs.log(req, res);
	  returnKvhhts = (HTSOSS_hts_collections.rtp)JSON.deserialize(res.getBody(), HTSOSS_hts_collections.rtp.class);
	  returnKvhhts.response_code = res.getStatusCode();
	  returnKvhhts.message = res.getStatus();
	  system.debug(returnKvhhts);
	  return returnKvhhts;
	}
	public HTSOSS_hts_collections.terminalnetworks getTerminalNetworks(){
	  HTSOSS_hts_collections.terminalnetworks returnTermNets = new HTSOSS_hts_collections.terminalnetworks();
	  returnTermNets.terminalnetworks = new list<terminalnetwork>();
	  HttpRequest req = getHttpRequestObj('GET', '/hts/collections/terminalnetworks');    
    Http http = new Http();
    HTTPResponse res = http.send(req);
    CalloutLogs.log(req, res);
    system.debug(res.getBody());
    try{
      returnTermNets.terminalnetworks = (list<HTSOSS_hts_collections.terminalnetwork>)JSON.deserialize(res.getBody(), list<HTSOSS_hts_collections.terminalnetwork>.class);
      returnTermNets.message = res.getStatus();
    } catch(exception e){
      returnTermNets.message = e.getMessage();
    }
    
    returnTermNets.response_code = res.getStatusCode();
    
    system.debug(returnTermNets);
    return returnTermNets;
	}
}