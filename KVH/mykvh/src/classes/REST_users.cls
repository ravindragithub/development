@RestResource(urlMapping='/V1/users/*') 
global with sharing class REST_users {
	@HttpGet
	//Responds to an HttpGet naturally... 
	//Given an User ID, or an E-mail search parameter
	//this Class returns a list of Users, Typically one and only one!
	//***OR*** A list of AccountShares!!!
	global static sObject[] doGet(){	//Need to use generic sObject because we might return Users or Account Shares!
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
		List<User> myKVHUsers = new List<User>();											//declare return list...
		String identifier = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);	//Get the identifier from the URI...
		system.debug(identifier);
		String emailSearch = req.params.get('email');										//Set the search param from URI (there might not be one...)
		system.debug(emailSearch);
		if (identifier.left(6) == 'search') {										//Determine if the request is an E-mail search....
			system.debug('Execute an E-Mail User Query against ' + emailSearch);
			Try {
				myKVHUsers = [SELECT Id, Name, Email, Username, Profile.Name, Profile.Id, myKVH_Role__c, IsActive, FirstName, LastName, Contact.AccountId
							FROM User WHERE Email = :emailSearch];
				system.debug(myKVHUsers);
				if (myKVHUsers.size() == 0){												//email not found!
					system.debug('No rows returned from Query... ' + myKVHUsers);
					res.statusCode = 404;													//return 404 and empty list
				} else if (myKVHUsers.size() > 1){											//duplicates found!
					system.debug('Duplicate User E-mail addresses found... ' + myKVHUsers);
					res.statusCode = 300;													//return 300 and list of users
				} else {																	//everything is cool!
					myKVHUsers[0].Last_API_Access__c = DateTime.Now();						//put a time stamp in the user record
					update myKVHUsers;	}} Catch (Exception e) { res.statusCode = 500; }								//Something bad happened... Should never get here!
																						//recommended remedial action is try again!
		} else if (identifier.left(3) == '005'){									//Determine if the request is against a User Id....
			Try {
				system.debug(identifier);
				myKVHUsers = [SELECT Id, Name, Email, Username, Profile.Name, Profile.Id, myKVH_Role__c, IsActive, FirstName, LastName, Contact.AccountId
							FROM User WHERE Id = :identifier];
				system.debug(myKVHUsers);
				if (myKVHUsers.size() == 0){											//User Id not found!
					system.debug('No rows returned from Query... ' + myKVHUsers);
					res.statusCode = 404;												//return 404 and empty list
				} else {																//everything is cool!, there can be only 1!
					myKVHUsers[0].Last_API_Access__c = DateTime.Now();					//put a time stamp in the user record
					update myKVHUsers;	}} Catch (Exception e) { res.statusCode = 500; }							//Something bad happened... Should never get here!
																					//recommended remidial action is try again!
		} else if (identifier.left(15) == 'platform_shares') {					//Determine if the request is for the AccountShares sub-resource...
			List<AccountShare> acctShares = new List<AccountShare>();			//declare return list...
			String UserId = req.requestURI.substringBeforeLast('/');				//Get the group from the URI, step 1
			UserId = UserId.substringAfterLast('/');								//step 2
			system.debug(UserId);
			Try {
				acctShares = [SELECT UserOrGroupId, RowCause, 
							LastModifiedDate, LastModifiedById, 
							Id, ContactAccessLevel, CaseAccessLevel, 
							Account.RecordType.DeveloperName,
							AccountId, AccountAccessLevel FROM AccountShare
							WHERE UserOrGroupId =: UserId
							AND Account.RecordType.DeveloperName LIKE 'Platform_%' 
							AND Account.Send_to_myKVH_Physical__c = true];
				system.debug('Number of Sharing Records Found : ' + acctShares.size());
				if (acctShares.size() == 0){										//No Account Shares found....
					system.debug('No rows returned from Query... ' + acctShares);
					myKVHUsers = [SELECT Id, Name, Email, Username, Profile.Name, Profile.Id, myKVH_Role__c, IsActive, FirstName, LastName, Contact.AccountId
									FROM User WHERE Id =: UserId];
					system.debug(myKVHUsers);											//verify UserID is OK and respond appropriately
					if (myKVHUsers.size() == 0){											//User Id not found!
						system.debug('No rows returned from Query... ' + myKVHUsers + ' Invalid User!');
						res.statusCode = 404;												//User not found status code = 404, return empty list
						system.debug(res.statusCode);
						system.debug(acctShares);
						return acctShares;
					} else {																//User found status code = 200
						system.debug(res.statusCode);										//There just aren't any Account Shares!
						system.debug(acctShares);
						return acctShares;													//Return the empty list
					}
				} else {															//Everything is cool, we found Account Shares for the User
					system.debug(res.statusCode);
					system.debug(acctShares);
					return acctShares;}} Catch (Exception e) { res.statusCode = 500; }	//Something bad happened... Should never get here!
															//recommended remedial action is try again!
		} else {						//fail! We did not get a User ID or a proper E-mail search query
			res.statusCode = 400;		//Something bad happened... Should never get here!
										//recommended remedial action is try again!
		}
		system.debug(res.statusCode);
		system.debug(myKVHUsers);
		return myKVHUsers;
	}
}