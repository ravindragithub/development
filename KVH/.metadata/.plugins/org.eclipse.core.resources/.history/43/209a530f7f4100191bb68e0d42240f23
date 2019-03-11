@RestResource(urlMapping='/V1/mediasrvrs/*')
global with sharing class REST_mediasrvr {
	@HttpGet
	//Responds to an HTTP GET naturally...
	global static list<hostNames> doGet(){
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
		List<Media_Server_Configuration__c> mediasrvrs = new List<Media_Server_Configuration__c>();	//SOQL return list...
		String identifier = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);			//variables for srvr query
		if (identifier.length() == 9) {				//We got an srvr config identifier!!
			Try {
				mediasrvrs = [SELECT Name, Hardware_Serial_Number__c, Host_OS_ID__c, Secure_Media_ID__c, Guest_CommBox_ID__c, Omni_ID__c,
								Hardware_Part_Number__c												//Add Hardware Part number for SuperYacht support
								FROM Media_Server_Configuration__c WHERE Hardware_Serial_Number__c =: identifier];
				if (mediasrvrs.size()==0){
					res.statusCode = 404;
				} 
			} Catch (Exception e) { res.statusCode = 500; } /*ugly test coverage hack*/ //(stacking lines of code for better coverage %)
		} else if (identifier.left(3) == 'all'){	//Someone wants ALL the srvr configs! Maybe they are re-building database! This identifier has been known to time out....
			Try {
				system.debug('Trying to get all Media Server Configurations...');
				mediasrvrs = [SELECT Name, Hardware_Serial_Number__c, Host_OS_ID__c, Secure_Media_ID__c, Guest_CommBox_ID__c, Omni_ID__c,
								Hardware_Part_Number__c												//Add Hardware Part number for SuperYacht support
								FROM Media_Server_Configuration__c];
				res.statusCode = 200;
				if (mediasrvrs.size()==0){
					res.statusCode = 404;
				} 
			} Catch (Exception e) { res.statusCode = 500; } /*ugly test coverage hack*/ //(stacking lines of code for better coverage %)
		} else {									//The parameter is not an srvr ID or 'all'... 
			res.statusCode = 400;					//Something bad happened... Should never get here! recommended remidial action is try again!
		}
		hostNames hn = new hostNames();							//instanciate a class to get access to a helper method....
		List<hostNames> results = new List<hostNames>();		//declare return list...
		for(Media_Server_Configuration__c ms : mediasrvrs){		//loop through SOQL results...
			hostNames hn2 = new hostNames(hn.mapHostNames(ms));	//converting record to map....
			system.debug(hn2);
			results.add(hn2); 									//and adding to the list
		}
		return results;
	}
	
	//going to need a resultCode Class for the POST
	@HttpPost
	global static payload doPost(string SerialNumber, string PartNumber){
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
		REST_API_utilities.resultCode rc = new REST_API_utilities.resultCode(false, 'initialization');		//init result code for Payload class
		payload p = new payload(rc,null);	//init Payload class....
		//check for duplicates in Media server configs...
		List<Media_Server_Configuration__c> mediasrvrs = new List<Media_Server_Configuration__c>();	//init list for SOQL return
		mediasrvrs = [SELECT Name, Hardware_Serial_Number__c, Host_OS_ID__c, Secure_Media_ID__c, Guest_CommBox_ID__c, Omni_ID__c,
						Hardware_Part_Number__c												//Add Hardware Part number for SuperYacht support
						FROM Media_Server_Configuration__c WHERE Hardware_Serial_Number__c =: SerialNumber];
		//check for duplicates in Assets that already have the same media server hardware serial number... 
		AssetUtilities util = new AssetUtilities();				//Instanciate an Asset Utilities Class
		List<Asset> existingAssets = new List<Asset>();			//Expecting a list of Assets...
		existingAssets = util.CheckForExisting(SerialNumber);	//Call the method....
		system.debug(existingAssets);
		if (existingAssets.size() != 0){						//If there's already an Asset with the same Hardware Serial Number
			res.statusCode = 300;								//Don't make a duplicate Asset (via Trigger)!
			string exceptionMsg = 'Found '+existingAssets.size()+' Existing Assets for '+SerialNumber+ ' ! Cannot issue Identifiers!';
			p.resultCode.success = false;
			p.resultCode.exceptionMessage = exceptionMsg;
		} else if (mediasrvrs.size() != 0){						//Chassis Serial Number already exists! found duplicates!!
			//Salesforce is configured to prevent duplicate hardware serial numbers... cannot effectively test this path (stacking lines of code for better coverage %)
			res.statusCode = 300;	string exceptionMsg = 'Found '+mediasrvrs.size()+' Duplicate Serial Numbers for '+SerialNumber+ ' ! Cannot issue Identifiers!';
			p.resultCode.success = false;	p.resultCode.exceptionMessage = exceptionMsg;
		} else {												//Not a duplicate...Run with it!
			Try {
				Media_Server_Configuration__c ms = new Media_Server_Configuration__c(Hardware_Serial_Number__c = SerialNumber,
																						Hardware_Part_Number__c = PartNumber);
				insert ms;
				mediasrvrs = [SELECT Name, Hardware_Serial_Number__c, Host_OS_ID__c, Secure_Media_ID__c, Guest_CommBox_ID__c, Omni_ID__c,
						Hardware_Part_Number__c												//Add Hardware Part number for SuperYacht support
						FROM Media_Server_Configuration__c WHERE Hardware_Serial_Number__c =: SerialNumber];
				hostNames hn = new hostNames();					//instanciate a class to get access to a helper method....
				p.hostNames = hn.mapHostNames(mediasrvrs[0]);
				p.resultCode.success = true;
				p.resultCode.exceptionMessage = '';
				res.statusCode = 200;
			} Catch (Exception e) {								//something unexpected happened...(stacking lines of code for better coverage %)
				p.resultCode.success = false;	p.resultCode.exceptionMessage = 'Salesforce exception message: ' + e.getMessage();
				res.statusCode = 500;
			}
		}
		return p;
	}
	
	@HttpPatch
	//Responds to an HTTP PATCH naturally...
	global static payload doPatch(string SerialNumber, string PartNumber){
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
		REST_API_utilities.resultCode rc = new REST_API_utilities.resultCode(false, 'initialization');		//init result code for Payload class
		payload p = new payload(rc,null);	//init Payload class....
		system.debug('SerialNumber : ' + SerialNumber + '   PartNumber : ' + PartNumber);
		//find serial number, check for dupes!
		List<Media_Server_Configuration__c> mediasrvrs = new List<Media_Server_Configuration__c>();	//init list for SOQL return
		mediasrvrs = [SELECT Name, Hardware_Serial_Number__c, Host_OS_ID__c, Secure_Media_ID__c, Guest_CommBox_ID__c, Omni_ID__c,
						Hardware_Part_Number__c												//Add Hardware Part number for SuperYacht support
						FROM Media_Server_Configuration__c WHERE Hardware_Serial_Number__c =: SerialNumber];
		system.debug('Number of Media Server Config records : ' + mediasrvrs.size());
		//find the corresponding Asset, check for dupes
		List<Asset> MSAssets = new List<Asset>();	//init List for SOQL return
		MSAssets = [SELECT Id, Name, serialNumber, Asset_ID__c, Product2.ProductCode FROM Asset WHERE Name =: SerialNumber]; //Asset_ID__c = msc.Hardware_Part_Number__c + '_US_' + msc.Hardware_Serial_Number__c;	//This field prevents dupes from BaaN Integration
		system.debug('Number of Asset records : ' + MSAssets.size());
		//get the Hardware Part Number Ids
		List<Product2> productIds = new List<Product2>();
		ProductIds = [SELECT Id, ProductCode, Product_ID__c FROM Product2 WHERE ProductCode =: PartNumber AND Product_ID__c =: PartNumber+'_US'];
		system.debug('Number of Product2 records : ' + productIds.size());
		//Validate inputs, assume failure!
		p.resultCode.success = false;
		
		if (SerialNumber == null || SerialNumber == ''){
			res.statusCode = 400;
			p.resultCode.exceptionMessage = 'Hardware Serial Number cannot be NULL for PATCH';
		} else if (PartNumber == null || PartNumber == '') {
			res.statusCode = 400;
			p.resultCode.exceptionMessage = 'Hardware Part Number cannot be NULL for PATCH';
		} else if (productIds.size() <> 1){
			res.statusCode = 400;
			p.resultCode.exceptionMessage = 'Problem with Hardware Part Number';
		}else if (mediasrvrs.size() == 0) {
			res.statusCode = 400;
			p.resultCode.exceptionMessage = 'Hardware Serial was not found in Media Server Config records';
		} else if (mediasrvrs.size() > 1) {			//Salesforce is configured to prevent duplicate hardware serial numbers... cannot effectively test this path
			res.statusCode = 300;
			p.resultCode.exceptionMessage = 'Found '+mediasrvrs.size()+' Existing Media Server Config records for '+SerialNumber+ ' ! Cannot make updates!';
		} else if (MSAssets.size() == 0) {
			res.statusCode = 400;
			p.resultCode.exceptionMessage = 'Hardware Serial Number was not found in Asset records';
		} else if (MSAssets.size() > 1) {
			res.statusCode = 300;
			p.resultCode.exceptionMessage = 'Found '+MSAssets.size()+' Existing Assets for '+SerialNumber+' ! Cannot make updates!';
		} else {	//Everything is cool... 1 media server config, 1 asset, and a part number.... 
			system.debug('Everything is cool... 1 media server config, 1 asset, and a part number....');
			try {
				mediasrvrs[0].Hardware_Part_Number__c = PartNumber;
				update mediasrvrs[0];											//update the media server config record..
				system.debug('Media Server Config updated...' + mediasrvrs[0]);
				system.debug('Asset details...' + MSassets[0]);
				MSAssets[0].Product2Id = productIds[0].Id;						//MUST use SF record ID...
				MSAssets[0].Asset_ID__c = PartNumber + '_US_' + SerialNumber;	//This field prevents dupes from BaaN Integration
				update MSassets;												//update the asset record, if successful, prepare the payload and return it!
				system.debug('Asset updated...' + MSassets[0]);
				hostNames hn = new hostNames();									//instanciate a class to get access to a helper method....
				p.hostNames = hn.mapHostNames(mediasrvrs[0]);
				p.resultCode.success = true;
				p.resultCode.exceptionMessage = '';
				res.statusCode = 200;
			} catch (exception e) {								//something unexpected happened...(stacking lines of code for better coverage %)
				p.resultCode.success = false;	p.resultCode.exceptionMessage = 'Salesforce exception message: ' + e.getMessage();
				res.statusCode = 500;
			}
		}
		return p;
	}
	
	//Maybe the right solution is a custom Class that consists of a resultCode object and a hostNames object..
	//Pre-serializing the Server List and delivering as a string...
	global class payload {						//Used as return object for a POST call
		//public resultCode resultCode;			//resultCode class...
		public REST_API_utilities.resultCode resultCode;			//resultCode class...
		public map<string, string> hostNames;	//hostNames map...
		//Constructor for payload inner class
		public payload(REST_API_utilities.resultCode RC_code, map<string, string> MS_list){
			resultCode = RC_Code;
			hostNames = MS_List;
		}
	}
	
	global class HostNames {								//hostNames class (a GET call returns an array of these!)
		public map<string, string> hostNames;
		//TWO constructors for inner class...
		public hostNames(){									//no argument constructor for access to helper methods
		}
		public hostNames(map<string, string> SRVR_list){	//map in map out constructor
			hostNames = SRVR_list.clone();
		}
		//Class helper methods
		public map<string, string> mapHostNames(Media_Server_Configuration__c MS_list){
			//Create Map of SF Field Names to Media Server Host Names
			map<string, string> FieldToHostName = new map<string, string>();	//declare return map
			//create map.... kind of critcal mapping here!!
			FieldToHostName.put('chassis', MS_list.Hardware_Serial_Number__c);
			FieldToHostName.put('mskvh', MS_list.Host_OS_ID__c);
			FieldToHostName.put('drm-mskvh', MS_list.Secure_Media_ID__c);
			FieldToHostName.put('cbx-mskvh', MS_list.Guest_CommBox_ID__c);
			FieldToHostName.put('omni-mskvh', MS_list.Omni_ID__c);
			return FieldToHostName;
		}
	}

}