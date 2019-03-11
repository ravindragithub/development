@RestResource(urlMapping='/V4/users/*') 
global with sharing class REST_users_V4 {
	@HttpGet
	//Responds to an HttpGet naturally... 
	//Given an User ID, or an E-mail search parameter
	//this Class returns a list of myKVH_User2, A wrapper Class that consists of a single User and a List of Role Extensions and Platform Shares!
	global static myKVH_User2[] doGet(){	//Need to use generic sObject because we might return Users or Account Shares!
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
		myKVH_User2 util = new myKVH_User2();													//utility Class to get at methods....
		List<myKVH_User2> myKVHUsers = new List<myKVH_User2>();								//declare return list based on Inner Class...
		List<User> userList = new list<User>();												//need a working list of users...
		String identifier = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);	//Get the identifier from the URI...
		system.debug(identifier);
		String emailSearch = req.params.get('email');										//Set the search param from URI (there might not be one...)
		system.debug(emailSearch);
		if (identifier.left(6) == 'search') {										//Determine if the request is an E-mail search....
			system.debug('Execute an E-Mail User Query against ' + emailSearch);
			Try {
				userList = [SELECT Id, Name, Email, Username, Profile.Name, Profile.Id, myKVH_Role__c, IsActive, FirstName, LastName, Contact.AccountId, 
							Contact.Account.RecordType.DeveloperName, Contact.Account.BillingCountry,
							//Adding Portal related details 12/17/2015
							IsPortalEnabled, IsPortalSelfRegistered,
							//Adding ContactId 1/24/2017
							ContactId  
							FROM User WHERE Email = :emailSearch];
				system.debug(userList);
				if (userList.size() == 0){													//email not found!
					system.debug('No rows returned from Query... ' + userList);
					res.statusCode = 404;													//return 404 and empty list
				} else if (userList.size() > 1){											//duplicates found!
					system.debug('Duplicate User E-mail addresses found... ' + userList);
					res.statusCode = 300;													//return 300 and list of users
					myKVHUsers = util.getmyKVH_Users2(userList);								//Build the return Class here!
				} else {																	//everything is cool!
					userList[0].Last_API_Access__c = DateTime.Now();						//put a time stamp in the user record 
					update userList;														//save the change....
					myKVHUsers = util.getmyKVH_Users2(userList);								//Build the return Class here!
					
				}
			} Catch (Exception e) { res.statusCode = 500; system.debug(e.getMessage()); }								//Something bad happened... Should never get here!
																						//recommended remedial action is try again!
		} else if (identifier.left(3) == '005'){										//Determine if the request is against a User Id....
			Try {
				system.debug(identifier);
				userList = [SELECT Id, Name, Email, Username, Profile.Name, Profile.Id, myKVH_Role__c, IsActive, FirstName, LastName, Contact.AccountId, 
							Contact.Account.RecordType.DeveloperName, Contact.Account.BillingCountry,
							//Adding Portal related details 12/17/2015
							IsPortalEnabled, IsPortalSelfRegistered,
							//Adding ContactId 1/24/2017
                            ContactId 
							FROM User WHERE Id = :identifier];
				system.debug(userList);
				if (userList.size() == 0){												//User Id not found!
					system.debug('No rows returned from Query... ' + userList);
					res.statusCode = 404;												//return 404 and empty list
				} else {																//everything is cool!, there can be only 1!
					userList[0].Last_API_Access__c = DateTime.Now();					//put a time stamp in the user record
					update userList;													//save the change....
					myKVHUsers = util.getmyKVH_Users2(userList);								//Build the return Class here!
				}
			} Catch (Exception e) { res.statusCode = 500; system.debug(e.getMessage()); }		//Something bad happened... Should never get here!
																						//recommended remedial action is try again!
		} else {						//fail! We did not get a User ID or a proper E-mail search query
			res.statusCode = 400;		//Something bad happened... Should never get here!
										//recommended remedial action is try again!
		}
		system.debug(res.statusCode);
		system.debug(myKVHUsers);
		return myKVHUsers;
	}
	//Need to define a wrapper Class, User + Role Extensions + Platform Shares
	global Class myKVH_User2{
		//User myKVHUser;
		list<myKVH_Role__c> RoleExtensions;
		list<myKVH_Shared_Platforms__c> PlatformShares;
		//Emulate User attributes....
		string Id; 
		string Name; 
		string Email; 
		string Username; 
		string Profile_Name; 
		public string Profile_Id; 
		string myKVH_Role_Id; 
		Boolean IsActive; 
		string FirstName; 
		string LastName; 
		public string Contact_AccountId; 
		string Contact_Account_RecordType_DeveloperName; 
		public string Contact_Account_BillingCountry;
		//Adding Portal related details 12/17/2015
		Boolean IsPortalEnabled;
		Boolean IsPortalSelfRegistered;
		//Adding ContactId 1/24/2017
        string Contact_Id;
		
		//Constructors
		public myKVH_User2(){	//no Arguement Constructor
		}
		public myKVH_User2(User u, list<myKVH_Role__c> RoleList, List<myKVH_Shared_Platforms__c> pShareList){
			//this.myKVHUser = u; //Emulate User sObject
			this.Id = u.Id; 
			this.Name = u.Name; 
			this.Email = u.Email; 
			this.Username = u.Username; 
			this.Profile_Name = u.Profile.Name; 
			this.Profile_Id = u.Profile.Id; 
			this.myKVH_Role_Id = u.myKVH_Role__c; 
			this.IsActive = u.IsActive; 
			this.FirstName = u.FirstName; 
			this.LastName = u.LastName;
			this.Contact_AccountId = u.Contact.AccountId; 
			this.Contact_Account_RecordType_DeveloperName = u.Contact.Account.RecordType.DeveloperName; 
			this.Contact_Account_BillingCountry = u.Contact.Account.BillingCountry;
			//Adding Portal related details 12/17/2015
			this.IsPortalEnabled = u.IsPortalEnabled;
			this.IsPortalSelfRegistered = u.IsPortalSelfRegistered;
			//Adding ContactId 1/24/2017
            this.Contact_Id = u.ContactId;
			//lists....
			this.RoleExtensions = RoleList;
			this.PlatformShares = pShareList;
		}
		//getters and (no) setters
		/*public User getmyKVHUser(){
			return myKVHUser;
		}*/
		public list<myKVH_Role__c> getRoleExtensions(){
			return RoleExtensions;
		}
		public list<myKVH_Shared_Platforms__c> getPlatformShares(){
			return PlatformShares;
		}
		//Class Methods
		public map<id, list<myKVH_Role__c>> getRoleExtensions (list<User> userList){							//returns a map of User Ids to Role Extensions
			map<id, list<myKVH_Role__c>> returnMap = new map<id, list<myKVH_Role__c>>();						//declare return map
			list<myKVH_User_Role_Extension__c> allRoleExtensions = new list<myKVH_User_Role_Extension__c>();	//sObject to Query
			map<Id, User> userMap = new map<Id, User>(userList);												//User map will be handy
			allRoleExtensions = [SELECT Id, User__c, Name__c, ExtendedRole__c, ExtendedRole__r.Name 
								FROM myKVH_User_Role_Extension__c 
								WHERE User__c IN :userMap.keySet()];											//Get all the Role Extensions for all the Users
			for(myKVH_User_Role_Extension__c mre : allRoleExtensions){											//loop through all the extended Roles
				myKVH_Role__c singleRole = new myKVH_Role__c(Id = mre.ExtendedRole__c,
															Name = mre.ExtendedRole__r.Name);					//need a single instance Role, AND..
				list<myKVH_Role__c> roleList = new list<myKVH_Role__c>();										//prepare a list of myKVH Roles
				if(returnMap.get(mre.User__c) != null){															//If the User is already listed in the return map
					roleList = returnMap.get(mre.User__c);														//get the current list to add to
				}
				roleList.add(singleRole);																		//add the role to the list
				returnMap.put(mre.User__c, roleList);															//put the user and the list in the map
			}
			system.debug('Role Extensions by User map: ' + returnMap);
			return returnMap;
		}
		
		public map<id, list<myKVH_Shared_Platforms__c>> getPlatformShares (list<User> userList){
			map<id, list<myKVH_Shared_Platforms__c>> returnMap = new map<id, list<myKVH_Shared_Platforms__c>>();
			list<myKVH_Shared_Platforms__c> allPlatformShares = new list<myKVH_Shared_Platforms__c>();			//sObject to Query
			map<Id, User> userMap = new map<Id, User>(userList);												//User map will be handy
			allPlatformShares = [SELECT Id, User__c, Shared_Platform__c, Shared_Platform__r.Name
								FROM myKVH_Shared_Platforms__c
								WHERE User__c IN :userMap.keySet()
								AND Shared_Platform__r.RecordType.DeveloperName LIKE 'Platform_%' 
								AND Shared_Platform__r.Send_to_myKVH_Physical__c = true];						//Get all the Platform Shares for all the Users
			for(myKVH_Shared_Platforms__c ps : allPlatformShares){												//loop through all the User's Platform Shares
				myKVH_Shared_Platforms__c singlePlatform = new myKVH_Shared_Platforms__c();						//Copying each one
				singlePlatform = ps;																			//
				list<myKVH_Shared_Platforms__c> platformList = new list<myKVH_Shared_Platforms__c>();			//prepare a list of Shared Platforms
				if(returnMap.get(ps.User__c) != null){															//If we have already started building the list...
					platformList = returnMap.get(ps.User__c);													//get the work in progress
				}																								
				platformList.add(singlePlatform);																//and add it to the return list
				returnMap.put(ps.User__c, platformList);														//then put the list back into the map
			}
			system.debug('Shared Platforms by User map: ' + returnMap);
			return returnMap;
		}
		
		public list<myKVH_User2> getmyKVH_Users2 (list<User> userList){
			list<myKVH_User2> returnList = new list<myKVH_User2>();
			
			map<Id, Contact> contactMap = new map<Id, Contact>();
			for(Contact c : [SELECT Id, AccountId, Account.RecordType.DeveloperName, Account.BillingCountry, uas__User__c
							FROM Contact 
							WHERE uas__User__c IN :userList]){//maybe query against a list/set of Email?
				contactMap.put(c.uas__User__c, c);
			}
			system.debug('Contact Map: ' + contactMap);
			system.debug('Getting Shared Platforms....' + userList);
			map<id, list<myKVH_Shared_Platforms__c>> UsersPlatformShares = getPlatformShares(userList);
			system.debug('Getting Role Extensions....'+ userList);
			map<id, list<myKVH_Role__c>> UsersRoleExtensions = getRoleExtensions(userList);
			
			for(User u : userList){
				myKVH_User2 singleUser = new myKVH_User2(u, UsersRoleExtensions.get(u.Id), UsersPlatformShares.get(u.Id));
				if(singleUser.RoleExtensions == null){
					singleUser.RoleExtensions = new list<myKVH_Role__c>();
				}
				if(singleUser.PlatformShares == null){
					singleUser.PlatformShares = new list<myKVH_Shared_Platforms__c>();
				}
				if(u.Contact.AccountId == null && contactMap.containsKey(u.Id)){	//ensure that contactMap has a lookup!
					singleUser.Contact_AccountId = contactMap.get(u.Id).AccountId;
					singleUser.Contact_Account_RecordType_DeveloperName = contactMap.get(u.Id).Account.RecordType.DeveloperName;
					singleUser.Contact_Account_BillingCountry = contactMap.get(u.Id).Account.BillingCountry; 
				}
				if(u.Contact.AccountId == null && !(contactMap.containsKey(u.Id))){
                    //Is this guy a Chatter Free User??
                    Profile ChatterFree = [SELECT Id, Name FROM Profile WHERE Name LIKE 'Chatter Free%' Limit 1];
                    system.debug(ChatterFree);
                    if(singleUser.Profile_Id == ChatterFree.Id){
                        //Put this guy in the KVH Official Account...
                        DefaultAccounts__c def = new DefaultAccounts__c();
                        def = DefaultAccounts__c.getInstance('KVH_Official_Internal_Contacts');
                        singleUser.Contact_AccountId = def.Account_ID__c;
                        singleUser.Contact_Account_BillingCountry = 'United States'; 
                    }
				}
				system.debug('User details: ' + u);
				returnList.add(singleUser);
			}
			return returnList;
		}
	}
}