@RestResource(urlMapping='/V1/fieldpermissions/*')
global with sharing class REST_fieldpermissions {
	@HttpGet
	//Responds to an HttpGet naturally... 
	global static myKVH_Field_Permission__c[] doGet() {
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
		//declare return list
		List<myKVH_Field_Permission__c> myKVH_FieldPermissions = new List<myKVH_Field_Permission__c>();
		//Get the identifier from the URI
		String identifier = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
		system.debug(identifier);
		
		if (identifier.left(3) == 'all') {	//try to get ALL the Field Permissions....
			Try {
				myKVH_FieldPermissions = [SELECT Id, Name, myKVH_User_Field__c, myKVH_Permission_Set__c, permissionRead__c, permissionEdit__c FROM myKVH_Field_Permission__c];
				if (myKVH_FieldPermissions.size()==0){
					res.statusCode = 404;
				}
			} Catch (Exception e) {res.statusCode = 500;}	//Something bad happened... Should never get here!
															//recommended remidial action is try again!
		} else if (identifier.left(3) == 'a1j') {	//a1j is the Field Permissions prefix....
			Try {
				myKVH_FieldPermissions = [SELECT Id, Name, myKVH_User_Field__c, myKVH_Permission_Set__c, permissionRead__c, permissionEdit__c 
											FROM myKVH_Field_Permission__c WHERE Id =: identifier];
				if (myKVH_FieldPermissions.size()==0){
					res.statusCode = 404;
				}
			} Catch (Exception e) {res.statusCode = 500;}	//Something bad happened... Should never get here!
															//recommended remidial action is try again!
		} else if (identifier.left(3) == 'a1k') {	//a1k is the Permission Set prefix....
			Try {
				myKVH_FieldPermissions = [SELECT Id, Name, myKVH_User_Field__c, myKVH_Permission_Set__c, permissionRead__c, permissionEdit__c 
											FROM myKVH_Field_Permission__c WHERE myKVH_Permission_Set__c =: identifier];
				if (myKVH_FieldPermissions.size()==0){
					res.statusCode = 404;
				}
			} Catch (Exception e) {res.statusCode = 500;}	//Something bad happened... Should never get here!
															//recommended remidial action is try again!
		} else {
			//We did not get an identifier
			res.statusCode = 400;		//Something bad happened... Should never get here!
										//recommended remedial action is try again!
		}
		
		
		return myKVH_FieldPermissions;
	}
}