@RestResource(urlMapping='/V1/features/*') 
global with sharing class REST_features {
		
	@HttpGet
	//Responds to an HttpGet naturally... 
	global static myKVH_feature__c[] doGet() {
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
		//declare return list
		List<myKVH_feature__c> Features = new List<myKVH_feature__c>();
		//Get the identifier from the URI
		String identifier = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
		system.debug(identifier);
		if (identifier.left(3) == 'a1i') {//a1i is prefix for myKVH Feature
			Try {
				Features = [SELECT Id, Name, isUpdateable__c, isReadable__c, isDeleteable__c, isCreateable__c, isBillable__c, 
									hasFieldLevelSecurity__c, Status__c, Description__c 
									FROM myKVH_Feature__c WHERE Id=:identifier];
				if (Features.size()==0){
					res.statusCode = 404;
				}
			} Catch (Exception e) {res.statusCode = 500;}	//Something bad happened... Should never get here!
															//recommended remidial action is try again!
		} else if (identifier.left(3) == 'all'){
			//Someone wants ALL the Features! Maybe they are re-building database!
			Try {
				system.debug('Trying to get all Features...');
				Features = [SELECT Id, Name, isUpdateable__c, isReadable__c, isDeleteable__c, isCreateable__c, isBillable__c, 
									hasFieldLevelSecurity__c, Status__c, Description__c 
									FROM myKVH_Feature__c];
				if (Features.size()==0){
					res.statusCode = 404;
				}
			} Catch (Exception e) {res.statusCode = 500;}	//Something bad happened... Should never get here!
															//recommended remidial action is try again!
		} else {
			//We did not get a Beam identifier
			res.statusCode = 400;		//Something bad happened... Should never get here!
										//recommended remedial action is try again!
		}
		return Features;
	}
	
	@HttpPost
	//responds to a POST request naturally...
	global static payload doPost(string Name, string Status, string Description){
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
		//going to need a payload Class for the POST... resultCode + myKVH_Feature__c[]
		REST_API_utilities.resultCode rc = new REST_API_utilities.resultCode(false, 'initialization');		//init result code for Payload class
		payload p = new payload(rc,null);	//init Payload class....
		
		List<myKVH_feature__c> FeaturesList = new List<myKVH_Feature__c>();			//declare return list
		FeaturesList = [SELECT id, Name FROM myKVH_Feature__c];						//for now fill it up with all names...
		map<string, myKVH_Feature__c> FeatureNameMap = new map<String, myKVH_Feature__c>();
		for(myKVH_Feature__c f : FeaturesList){										//copy list into a map of names, sObjects
			FeatureNameMap.put(f.name, f);											//use FeatureNameMap to verify non-duplicate
		}
		FeaturesList.Clear();														//we can re-use FeatureList now.
		
		Schema.DescribeFieldResult fieldResult = myKVH_Feature__c.Status__c.getDescribe();	//get picklist information
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();					//get all the picklist values
		Set<String> lstPickvals=new Set<String>();											//create a string Set to hold them
		for (Schema.PicklistEntry a : ple ) {												//loop through the picklist values
			lstPickvals.add(a.getValue());													//add the value to our Set
		}																					//now we can validate the input Status Field!
		
		if(FeatureNameMap.get(Name) != null){		//Validate non-duplicate name
			res.statusCode = 300;					//Duplicate Feature Name!
			myKVH_Feature__c dupeFeature = new myKVH_Feature__c();
			dupeFeature = FeatureNameMap.get(Name);
			string exceptionMsg = 'A Feature Named ' + dupeFeature.Name + ' Already exists! Cannot Create Duplicate Feature!';
			p.resultCode.success = false;
			p.resultCode.exceptionMessage = exceptionMsg;
			FeaturesList.add(dupeFeature);
			p.createdFeatures = FeaturesList;
		} else if(lstPickvals.contains(Status) == false){	//Validate Status field is in PickList
			res.statusCode = 400;							//Invalid status field....!
			string exceptionMsg = Status + ' is not a valid Status for features! Use one of the following : ' + lstPickvals;
			p.resultCode.success = false;
			p.resultCode.exceptionMessage = exceptionMsg;
			p.createdFeatures = FeaturesList;				//This should be empty at this point!
		} else {
			try{
				myKVH_Feature__c feature = new myKVH_Feature__c(Name = Name, Status__c = Status, Description__c = Description);
				insert feature;
				FeaturesList = [SELECT Id, Name FROM myKVH_Feature__c WHERE Id = : feature.id];
				res.statusCode = 200;
				p.resultCode.success = true;
				p.resultCode.exceptionMessage = '';
				p.createdFeatures = FeaturesList;
			} catch (exception e){
				p.resultCode.success = false;	p.resultCode.exceptionMessage = 'Salesforce exception message: ' + e.getMessage();
				res.statusCode = 500;
			}
			
		}
		return p;
	}
	
	//"Payload" helper class
	global class payload {						//Used as return object for a POST call
		//public resultCode resultCode;			//resultCode class...
		public REST_API_utilities.resultCode resultCode;			//resultCode class...
		public List<myKVH_Feature__c> createdFeatures = new List<myKVH_Feature__c>();
		
		//Constructor for payload inner class
		public payload(REST_API_utilities.resultCode RC_code, List<myKVH_Feature__c> FeaturesList){
			resultCode = RC_Code;
			createdFeatures = FeaturesList;
		}
	}
}