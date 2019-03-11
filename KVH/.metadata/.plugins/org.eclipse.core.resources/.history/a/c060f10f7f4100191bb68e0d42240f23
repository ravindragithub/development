@RestResource(urlMapping='/V1/roles/*') 
global with sharing class REST_roles {
	@HttpGet
	//Responds to an HttpGet naturally... 
	//Given an User ID, or an E-mail search parameter
	//this Class returns a list of Users, Typically one and only one!
	global static myKVH_Role__c[] doGet(){
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
		//declare return list
		List<myKVH_Role__c> myKVHRoles = new List<myKVH_Role__c>();
		//Get the identifier from the URI
		String identifier = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
		if (identifier.left(3) == 'a1l') {
			Try {
				system.debug(identifier);
				myKVHRoles = [SELECT Id, Name, Description__c, isRoleExtension__c FROM myKVH_Role__c WHERE Id = :identifier];
				system.debug(myKVHRoles);
				if (myKVHRoles.size() == 0){
					system.debug('No rows returned from Query... ' + myKVHRoles);
					res.statusCode = 404;
				}
			} Catch (Exception e) { res.statusCode = 500; }	//Something bad happened... Should never get here!
															//recommended remidial action is try again!
		} else if (identifier.left(3) == 'all'){
			//Someone is trying to get ALL the roles!!
			Try {
				system.debug(identifier);
				myKVHRoles = [SELECT Id, Name, Description__c, isRoleExtension__c FROM myKVH_Role__c];
				system.debug(myKVHRoles);
				if (myKVHRoles.size() == 0){
					system.debug('No rows returned from Query... ' + myKVHRoles);
					res.statusCode = 404;
				}
			} Catch (Exception e) { res.statusCode = 500; }	//Something bad happened... Should never get here!
															//recommended remidial action is try again!
		} else {
			//fail! We did not get a User ID or a proper E-mail search query
			res.statusCode = 400;		//Something bad happened... Should never get here!
										//recommended remedial action is try again!
		}
		return myKVHRoles;
	}
}