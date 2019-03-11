@RestResource(urlMapping='/V1/permissionsets/*')
global with sharing class REST_permissionset {
	@HttpGet
	//Responds to an HttpGet naturally... 
	global static myKVH_Permission_Set__c[] doGet() {
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
		//declare return list
		List<myKVH_Permission_Set__c> myKVH_PermissionSet = new List<myKVH_Permission_Set__c>();
		//Get the identifier from the URI
		String identifier = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
		system.debug(identifier);
		
		if (identifier.left(3) == 'all') {	//try to get ALL the Permission Sets
			Try {
				myKVH_PermissionSet = [SELECT Id, myKVH_Role__c, Name, myKVH_Feature__c, 
							canUpdate__c, canRead__c, canDelete__c, canCreate__c FROM myKVH_Permission_Set__c];
				if (myKVH_PermissionSet.size()==0){
					res.statusCode = 404;
				}
			} Catch (Exception e) {res.statusCode = 500;}	//Something bad happened... Should never get here!
															//recommended remidial action is try again!
		} else if (identifier.left(3) == 'a1k') {	//a1k is the Permission Set prefix
			Try {
				myKVH_PermissionSet = [SELECT Id, myKVH_Role__c, Name, myKVH_Feature__c, 
							canUpdate__c, canRead__c, canDelete__c, canCreate__c FROM myKVH_Permission_Set__c
							WHERE Id =: identifier];
				if (myKVH_PermissionSet.size()==0){
					res.statusCode = 404;
				}
			} Catch (Exception e) {res.statusCode = 500;}	//Something bad happened... Should never get here!
															//recommended remidial action is try again!
		} else if (identifier.left(3) == 'a1l') {	//a1l is the Role prefix
			Try {
				myKVH_PermissionSet = [SELECT Id, myKVH_Role__c, Name, myKVH_Feature__c, 
							canUpdate__c, canRead__c, canDelete__c, canCreate__c FROM myKVH_Permission_Set__c
							WHERE myKVH_Role__c =: identifier];
				if (myKVH_PermissionSet.size()==0){
					res.statusCode = 404;
				}
			} Catch (Exception e) {res.statusCode = 500;}	//Something bad happened... Should never get here!
															//recommended remidial action is try again!
		} else {
			//We did not get an identifier
			res.statusCode = 400;		//Something bad happened... Should never get here!
										//recommended remedial action is try again!
		}
		return myKVH_PermissionSet;
	}
}