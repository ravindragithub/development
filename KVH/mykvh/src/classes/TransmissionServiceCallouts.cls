//This is a public demo server instance...
//static string baseURL = 'http://192.168.208.40:8081/ts'; //dev server
//static string baseURL = 'http://es1.dallas.ops.kvh.com:8081/ts'; //dev server


public class TransmissionServiceCallouts {
	
	//static string ProductionOrgId = '00D30000000pQ0zEAE'; //Like *REALLY* Static!
	static string baseURL;
	//public REST_API_utilities.resultCode resultCode;   //used for ALL callouts. Well.... EXCEPT Ping!
	public resultCode resultCode;   //used for ALL callouts. Well.... EXCEPT Ping!
	public String key1;             //for ping
	public String val1;             //for ping
	
	public TransmissionServiceCallouts(){		//no parameter constructor
	    Production_Org_Ids__c mySetting = new Production_Org_Ids__c();  //Create a new instance of the Custom Setting
	    mySetting = Production_Org_Ids__c.getOrgDefaults();           //get the Org default dataset for our Production Org
		if(UserInfo.getOrganizationId() == mySetting.Org_Id_18_char__c){
		    /*We are in Production! Use Production Instance of TS!*/
			baseURL = 'http://199.244.86.5:9081/ts';  //Production instance :9081 is unencrypted server... 
			system.debug('Operating in a Production Instance...');
		} else {
		    /*We are in Sandbox! Use DEV Instance of TS!*/
		    system.debug('Operating in a Production Instance...');
			baseURL = 'http://199.244.86.5:9082/ts';  //Development instance :9082 is unencrypted server... 
		}
		system.debug('Base URL : ' + baseURL);
	}

	/*
    //uncomment the below line for functional testing
    static string baseURL = 'http://199.244.86.5:9082/ts';  //Development instance :9082 is unencrypted server... 
    
    //uncomment the below line for unit tests and deployment
    //static string baseURL = 'http://199.244.86.5:9081/ts';  //Production instance :9081 is unencrypted server... 
    
    //handle unit tests automatically. Test Class is written for Production Environment.
	*/
	
	/*This inner Class is still referred to in  IPMC_Service_Mapping_Controller as of 12/18/14*/
	//TODO Globalize the IPMC_Service_Mapping_Controller references to this inner Class 
    public class resultCode {
        public Boolean success;
        public String exceptionMessage;
        //Constructor for resultCode inner class...
        public resultCode(Boolean b, String s) {
            success = b;
            exceptionMessage = s;
        }
    }
    /* TransmissionServiceCallout Methods */
    public TransmissionServiceCallouts ping() { // "ping" service does not return a resultCode object
        //This is a GET request to the Transmission Service
        Http h = new Http();            //Instantiate a new http object and build the URL
        string url = baseURL + '/ping'; //:9081 is unencrypted server... 
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        req.setTimeout(60000);
        // Send the request, and return a response (wrap the following up in a try-catch)
        HttpResponse res = h.send(req);
        system.debug(res.getBody());
        TransmissionServiceCallouts TSC = (TransmissionServiceCallouts)JSON.deserialize(res.getBody(),TransmissionServiceCallouts.class);
        return TSC;
    }
    public resultCode SiteDeactivate(string swSerialNumber) { // Deactivates a CBX or MS
        /* This method will need to "Re-claim" the KenCast License issued to the Asset when deactivated
         * the general flow is make the Callout, if success=true, then update the License, and the Asset. */
        //This is a POST request to the Transmission Service
        TransmissionServiceCallouts TSC = new TransmissionServiceCallouts();
        Asset a = new Asset();
        a = [SELECT id, Name, IPMC_KenCast_SiteID__c, IPMC_License_Issued__c, IPMC_License_Issued_by__c
            FROM Asset WHERE Name =:swSerialNumber];
        system.debug(a.name);
        decimal siteid = decimal.valueOf(a.IPMC_KenCast_SiteID__c);
        KenCast_License__c kl = new KenCast_License__c();
        kl = [SELECT Id, Site_ID__c, Received_by_Transmission_Service__c, Message_from_Transmission_Service__c, Issued_to_Asset__c
            FROM KenCast_License__c WHERE Site_ID__c =:siteid];
        system.debug(kl);
        
        Http h = new Http();    //Instanciate a new HTTP object, and build the URL
        string url = baseURL + '/SiteDeactivate';   //:9081 is unencrypted server... 
        // Instantiate a new HTTP request, specify the method (POST) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setTimeout(60000);
        //setBody experiements...
        req.setBody('{"swSerialNumber":"'+swSerialNumber+'"}'); //brute force JSON...we *could* serialize an object
        system.debug('Request: '+req);
        // Send the request, and return a response (wrap this up in a try-catch)
                // Send the request, and return a response (wrap this up in a try-catch)
        try {
            HttpResponse res = h.send(req);
            system.debug('Response: '+res.getBody()); //good to here...
            TSC = (TransmissionServiceCallouts)JSON.deserialize(res.getBody(),TransmissionServiceCallouts.class);
            if (TSC.resultCode.success) {   // "Success":"true"
                //Update the Asset and License
                disconnectLicenseandAsset(a,kl, TSC.resultCode);
                system.debug(TSC);
            }
        } catch (Exception e) {
            TSC.resultCode.exceptionMessage = 'SiteDeactivate Callout for swSerialNumber: ' + swSerialNumber + ' failed! ' + e.getMessage();
            TSC.resultCode.success = false;
        }
        return TSC.resultCode;
        
    }
    public resultCode SiteActivate(string swSerialNumber, Integer siteId, string LicenseContents) { // Activates a CBX or MS
        /* This method will need to "issue" the KenCast License to the Asset when activated
         * the general flow is make the Callout, if success=true, then update the License, and the Asset. */
        //This is a POST request to the Transmission Service
        TransmissionServiceCallouts TSC = new TransmissionServiceCallouts();
        string b64LicenseContents = EncodingUtil.base64Encode(Blob.valueOf(LicenseContents));
        Asset a = new Asset();
        a = [SELECT id, Name, IPMC_KenCast_SiteID__c, IPMC_License_Issued__c, IPMC_License_Issued_by__c
            FROM Asset WHERE Name =:swSerialNumber];
        system.debug(a);
        //Need to check activation status of Asset (and maybe proceed anyway....)
        KenCast_License__c kl = new KenCast_License__c();
        kl = [SELECT Id, Site_ID__c, Received_by_Transmission_Service__c, Message_from_Transmission_Service__c, Issued_to_Asset__c
            FROM KenCast_License__c WHERE Site_ID__c =:siteid];
        system.debug(kl);
        if (kl == null) {
            kl = getLicense();
        }
        Http h = new Http();    //Instantiate a new HTTP object, and build the URL
        string url = baseURL + '/SiteActivate'; //:9081 is unencrypted server... 
        // Instantiate a new HTTP request, specify the method (POST) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setTimeout(60000);
        //make the Callout.... carefully craft the JSON body....(String, Integer, b64String)
        req.setBody('{"swSerialNumber":"'+swSerialNumber+'",'+'"siteId":'+siteid+','+'"b64LicenseContents":"'+b64LicenseContents+'"}');
        system.debug('Request: '+req.getBody());
        // Send the request, and return a response (wrap this up in a try-catch)
        try {
            HttpResponse res = h.send(req);
            system.debug('Response: '+res.getBody()); //good to here...
            TSC = (TransmissionServiceCallouts)JSON.deserialize(res.getBody(),TransmissionServiceCallouts.class);
            if (TSC.resultCode.success) {   // "Success":"true"
                //Update the Asset and License
                connectLicenseandAsset(a, kl, TSC.resultCode); 
                system.debug(TSC);
            }
        } catch (Exception e) {
            TSC.resultCode.exceptionMessage = 'SiteActivate Callout for swSerialNumber: ' + swSerialNumber + ' SiteId: ' + siteid + ' failed! ' + e.getMessage();
            TSC.resultCode.success = false;
        }
        return TSC.resultCode;
    }
    
    public resultCode SiteMapPkgKinds(string swSerialNumber, List<String> pkgKinds) {
        //This is a POST request to the Transmission Service
        //Need to get a s/w serial number (from a contracted Service)
        //AND a Products (also from a contracted service) which gives us
        //the required params of swSerialNumber and List of PkgKinds
        TransmissionServiceCallouts TSC = new TransmissionServiceCallouts();
        Http h = new Http();            //Instantiate a new http object and build the URL
        string url = baseURL + '/SiteMapPkgKinds';  //:9081 is unencrypted server... 
        // Instantiate a new HTTP request, specify the method (POST) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setTimeout(60000);
        //make the Callout.... carefully craft the JSON body....(String, String[])
        string JSONBody = '{"swSerialNumber":"'+swSerialNumber+'", "pkgKinds":';
        string JSONString = JSON.Serialize(pkgKinds);
        system.debug(JSONString);
        JSONBody = JSONBody + JSONString + '}';
        req.setBody(JSONBody);
        system.debug('Request: '+req.getBody());
        try {
            HttpResponse res = h.send(req);
            system.debug('Response: '+res.getBody()); //good to here...
            TSC = (TransmissionServiceCallouts)JSON.deserialize(res.getBody(),TransmissionServiceCallouts.class);
            if (TSC.resultCode.success) {   // "Success":"true"
                //Maybe we create a log entry??
                system.debug(TSC);
            }
        } catch (Exception e) {
            TSC.resultCode.exceptionMessage = 'SiteMapPkgKinds Callout for swSerialNumber: ' + swSerialNumber + ' failed! ' + e.getMessage();
            TSC.resultCode.success = false;
        }
        return TSC.resultCode;
    }
    
    public KenCast_License__c getLicense() {
        KenCast_License__c NextAvailableLicense = new KenCast_License__c();
        NextAvailableLicense = [SELECT Id, Site_ID__c, License_File__c, Issued_to_Asset__c,
                                Received_by_Transmission_Service__c,
                                Message_from_Transmission_Service__c
                        FROM KenCast_License__c
                        WHERE Issued_to_Asset__c = null
                        LIMIT 1];
        return NextAvailableLicense;
    }
    
    public void connectLicenseandAsset(Asset a, KenCast_License__c kl, resultCode rc) {//used by SiteActivate 
        //update Asset...
        a.IPMC_KenCast_SiteID__c = string.valueOf(kl.Site_ID__c);
        a.IPMC_License_Issued__c = datetime.now();
        a.IPMC_License_Issued_by__c = UserInfo.getUserId();
        update a;
        //update License
        kl.Issued_to_Asset__c = a.id;
        kl.Message_from_Transmission_Service__c = 'Activation Callout | '+string.valueOf(rc);
        kl.Received_by_Transmission_Service__c = true;
        try {
            update kl;
        } catch (Exception e) {
            system.debug(e);
        }
    }
    public void disconnectLicenseandAsset(Asset a, KenCast_License__c kl, resultCode rc) {//used by SiteActivate 
        //update Asset... history is maintained by Asset Feed
        system.debug(a.name);
        a.IPMC_KenCast_SiteID__c = null;
        a.IPMC_License_Issued__c = null;
        a.IPMC_License_Issued_by__c = null;
        update a;
        //update License... history is maintained by License feed
        system.debug(kl);
        kl.Issued_to_Asset__c = null;
        kl.Message_from_Transmission_Service__c = 'Deactivation Callout | '+string.valueOf(rc);
        kl.Received_by_Transmission_Service__c = true;
        system.debug(kl);
        try {
            update kl;
        } catch (Exception e) {
            system.debug(e);
        }
    }
}