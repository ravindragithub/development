public virtual class myKVH_User_Management_Base {

	/******************************************
	 * Common Controller/Page attributes      *
	 *****************************************/
	//Add and Edit User support...
	public myKVH_Contact__c myKVHContact {get;set;}									//staging sObject for Contact/User creation
	public Contact SFContact {get;set;}												//Salesforce Contact
	public User SFUser {get;set;}													//Salesforce User
	
	public User currentUser {get;set;}												//Currently logged in User, will be Customer Admin
	
	public list<AccountStructure.ObjectStructureMap> RawHierarchy {get;set;}		//this might not get surfaced...
	public list<AccountStructure.ObjectStructureMap> myKVHHierarchy {get;set;}		//this might not get surfaced...
	
	public String fleetId {get;set;}												//converts to Contact.AccountId, controls Fleet visibility
	public String fleetName {get;set;}												//captured from fleet hierarchy
	
	//Matrix support...
	public list<Account> AcctsInHierarchy {get;set;}								//List of Accounts in the Current Users Hierarchy
	public list<User> ManagedUsers;													//This is a list of the Users that the Current Users can manage (based on an Acct Hierarchy)
	
	//Common Query Strings...
	public string ContactSelect{get;set;}											//Standard Query string for Contact
	
	public list<myKVH_Role__c> ExtendedRolesList {get;set;}								//This is a list of all Role Extensions
	public integer COUNT_OF_ROLE_EXTENSION {get;set;}									//Count of Role Extensions (e.g. Matrix Columns)
	public map<integer, myKVH_Role__c> RoleExtensionMap {get;set;}						//This is a lookup map used to keep columns aligned
	public list<myKVH_User_Role_Extension__c> UserExtensionsList {get;set;}				//This is a list of Role Extensions and assigned Users
	public map<Id, Boolean> FrozenUsersMap {get;set;}									//This is a Map, User Id to UserLogin.isFrozen
	public map<id, Boolean> CustomerAdminMap {get;set;}								//This is a Map, User Id to Customer Admin Permission Set
	public string CustAdminToolTip {get; set;}											//This serves as a Tooltip for the "Admin" role (PermissionSet.Description)
	public map<Id, list<myKVH_User_Role_Extension__c>> UserAssignedExtensionsMap {get;set;}		//maps User Id to assigned Role Extensions...
	public map<Id, list<myKVH_Role__c>> UserExtensionMap {get;set;}					//This is a Map, User ID to list of Role Extensions
	

	public list<ExtRoleMatrixRow> MatrixRows = new list<ExtRoleMatrixRow>();			//This is a list of Users with ALL Role Extensions (Our Wrapper Class)
	/******************************************
	 * Constructor                            *
	 *****************************************/
	public myKVH_User_Management_Base(){
		ContactSelect = 'SELECT Id, FirstName, LastName, Name, Email, Phone, MobilePhone, AccountId, Account.Name, Job_Function__c, Receive_Network_Service_Notifications__c, Network_Outage_Type__c FROM Contact ';
		string currentUserId = userInfo.getUserId();
		currentUser = [SELECT Id, Username, ContactID, Contact.AccountId, Contact.Account.Name, ProfileId, myKVH_Role__c FROM User WHERE Id=:currentUserId];

		if (currentUser.Contact.AccountId != null){
			RawHierarchy = getRawHierarchy(currentUser.Contact.AccountId);		//includes non-myKVH Accounts
			system.debug('Unfiltered Hierarchy size: ' + RawHierarchy.size()); 
			myKVHHierarchy = getmyKVHHierarchy(RawHierarchy);					//Filters Hierarchy leaving only myKVH Accts and Platforms
			system.debug('Filtered Hierarchy size: ' + myKVHHierarchy.size());
		}
	}
	/******************************************
	 * Utility Methods                        *
	 *****************************************/
	 public void initExtendedRolesList(){
	 	ExtendedRolesList = [SELECT Id, Name, Description__c, Column_Header__c, isRoleExtension__c, Tool_Tip_Text__c FROM myKVH_Role__c 
							WHERE isRoleExtension__c = true
							AND isVisibleInPortal__c = true];																		//Get a list of all Role Extensions visible in Portal
		RoleExtensionMap = new map<integer, myKVH_Role__c>();																		//instanciate the public map 
		integer i = 0;																												//and set it up in sequence
		for(myKVH_Role__c r : ExtendedRolesList){
			system.debug('Value of i: ' + i + '  Role: ' + r); 
			RoleExtensionMap.put(i,r);
			i++;
		}
		
		COUNT_OF_ROLE_EXTENSION = i;																								//A counter will come in handy!
	 }
	
	public Boolean isManagedUser(User UserPassedIn, list<User> UsersInScope){
		Boolean returnFlag = false;
		map<Id, User> MngdUsrs = new map<Id, User>(UsersInScope);
		system.debug('Passed In User Id: ' + UserPassedIn.Id);
		system.debug('Managed Users Ids: ' + MngdUsrs.keySet());
		returnFlag = MngdUsrs.containsKey(UserPassedIn.Id);
		return returnFlag;
	}
	
	public list<AccountStructure.ObjectStructureMap> getRawHierarchy(string AcctId){
		AccountStructure util = new AccountStructure();
		system.debug('Getting Hierarchy for: ' + AcctId);
		//util.setcurrentId(AcctId);
		//system.debug('AccountStructure Current Id: ' + util.currentId);
		list<AccountStructure.ObjectStructureMap> AcctHierarchy = util.getObjectStructure(AcctId);
		return AcctHierarchy;
	}
	
	public list<AccountStructure.ObjectStructureMap> getmyKVHHierarchy(list<AccountStructure.ObjectStructureMap> hierarchy){
		//returns Accounts sent to myKVH AND Platforms as an Account map
		list<AccountStructure.ObjectStructureMap> returnList = new list<AccountStructure.ObjectStructureMap>();
		for(AccountStructure.ObjectStructureMap h : hierarchy){
			if(h.account.RecordType.DeveloperName.left(9) == 'Platform_'){
				returnList.add(h);
			} else if (h.account.Send_to_myKVH_Physical__c){
				if(h.nodeType == 'start'){												//Root of Hierarchy
					h.account.name = h.account.name + ' (Sees ALL Vessels in Fleet Hierarchy)';
				} else {
					h.account.name = h.account.name + ' (Sees ALL Vessels indented below)';
				}
				returnList.add(h);
			}
		}
		return returnList;
	}
	public myKVH_Contact__c populateActivationContact(Contact c){
		myKVH_Contact__c fromContact = new myKVH_Contact__c ();
		fromContact.email__c = c.email;
		fromContact.First_Name__c = c.FirstName;
		fromContact.Last_Name__c = c.LastName;
		fromContact.mobile__c = c.MobilePhone;
		fromContact.phone__c = c.Phone;
		fromContact.Receive_Network_Service_Notifications__c = c.Receive_Network_Service_Notifications__c;
		fromContact.Network_Outage_Type__c = c.Network_Outage_Type__c;			//the picklist
		fromContact.Job_Function__c = c.Job_Function__c ;
		fromContact.Contact__c = c.Id;											//super critical! affects user creation
		fleetId = c.AccountId;													//This is a Class variable...
		return fromContact;														//return the Activation Contact
	}
	
	//Method to return a Map of User Id to Frozen status... inverts Frozen logic
	public map<Id, Boolean> getFrozenUsersMap(list<User> ManagedUsers){
		map<Id, Boolean> returnMap = new map<Id, Boolean>();
		map<Id, User> queryKeys = new map<Id, User>(ManagedUsers);		//convert list to Map
		//Use map keys in SOQL for loop
		for(UserLogin ul : [SELECT UserId, isFrozen FROM UserLogin WHERE UserId IN: queryKeys.keyset()]){
			//system.debug(ul);
			returnMap.put(ul.UserId, !ul.isFrozen);
		}
		system.debug(returnMap);
		return returnMap;
	}
	
	//Method to return a Map of User Id to Customer Admin Permission Set....
	public map<Id, Boolean> getCustomerAdminMap(list<User> ManagedUsers){
		map<Id, Boolean> returnMap = new map<Id, Boolean>();
		map<Id, User> queryKeys = new map<Id, User>(ManagedUsers);		//convert list to Map
		//Use map keys in SOQL for loop
		for(PermissionSetAssignment p : [SELECT Assignee.Id, Assignee.Name, PermissionSetId, PermissionSet.Name, PermissionSet.Description
										 FROM PermissionSetAssignment
										 WHERE PermissionSet.Name = 'myKVH_Customer_Admin'
										 AND Assignee.Id IN: queryKeys.keyset()]){
			returnMap.put(p.Assignee.Id, true);	
			CustAdminToolTip = p.PermissionSet.Description;				//Over and over again.... :(
		}								//OK we have all the Managed users WITH the permission set in the map...
		for(User u : ManagedUsers){		//now complete the map with all the other Managed Users...
			if(returnMap.containsKey(u.Id) != true){
				returnMap.put(u.Id, false);
			}
		}
		//system.debug('Base Class Perm Set ID: ' + CustAdminPermSetId);
		return returnMap;
	}
	
	//One method returns a map of User ID to myKVH Role Extension
	public map<Id, list<myKVH_Role__c>> getUserExtensionMap(list<myKVH_User_Role_Extension__c> UREList){
		//returns a map of user ID to myKVH Roles based on a list of User Role Extensions (the junction sObject)
		map<Id, list<myKVH_Role__c>> returnMap = new map<Id, list<myKVH_Role__c>>();									//create a return Map, User ID vs list of Role Extensions
		map<Id, myKVH_Role__c> RoleExtensionMap = new map<Id, myKVH_Role__c>(ExtendedRolesList);						//build a lookup map from the List
		
		for(myKVH_User_Role_Extension__c URE : UREList){																//loop through the User Role Extensions
			list<myKVH_Role__c> roleList = new list<myKVH_Role__c>();													//Create a new list of Roles
			if(returnMap.get(URE.User__c) != null){																		//If the user already has a mapping
				roleList = returnMap.get(URE.User__c);																	//Get the existing role map
			}																		
			roleList.add(RoleExtensionMap.get(URE.ExtendedRole__c));
			returnMap.put(URE.User__c, RoleList);
		}
		system.debug (returnMap);
		return returnMap;
	}
	
	public map<Id, list<myKVH_User_Role_Extension__c>> getUserAssignedExtensionsMap(list<myKVH_User_Role_Extension__c> UREList){
		map<Id, list<myKVH_User_Role_Extension__c>> returnMap = new map<Id, list<myKVH_User_Role_Extension__c>>();
		for(myKVH_User_Role_Extension__c URE : UREList){																//loop through the User Role Extensions
			list<myKVH_User_Role_Extension__c> UserRoleExtList = new list<myKVH_User_Role_Extension__c>();				//Create a new list of roles extensions
			if(returnMap.get(URE.User__c) != null){																		//If the user already has a mapping
				UserRoleExtList = returnMap.get(URE.User__c);															//Get the existing role map
			}
			UserRoleExtList.add(URE);																					//Add the role Extension to the list
			returnMap.put(URE.User__c, UserRoleExtList);																//put the User and List into the Map
		}
		return returnMap;
	}
	
	// One Method returns a list of Accounts
	public list<Account> getAccountsInHierarchy(list<AccountStructure.ObjectStructureMap> hierarchy){
		//returns a list of Accounts from an Account Hierarchy
		list<Account> returnList = new list<Account>();
		for(AccountStructure.ObjectStructureMap h : hierarchy){
			returnList.add(h.account);
		}
		return returnList;
	}
	
	public list<User> getManagedUsers(list<Account> AcctList){
		//returns a list of Users (Portal Users!) from an Account Hierarchy (that "User.Contact.AccountId" bit)
		ManagedUsers = [SELECT Id, username, LastName, FirstName, Contact.AccountId, Contact.Account.Name							//And get a list of related Users from...
						FROM User WHERE (Contact.AccountId IN :AcctList) AND (IsActive = true) AND (isTestUser__c = false)
						ORDER BY LastName ASC];
		system.debug('Managed Users: ' + ManagedUsers);
		return ManagedUsers;
	}
	/*******************************
	 * Getters Setters... These are surfaced in pages...
	 ******************************/
	public list<ExtRoleMatrixRow> getMatrixRows(){
		return MatrixRows;
	}
	public void setMatrixRows(list<User> userList){
		MatrixRows.clear();
		system.debug('Number of Managed Users: ' + userList.size());
		for(User u : userList){																									//loop through Users
			system.debug('Count of Role Extensions: ' + COUNT_OF_ROLE_EXTENSION);
			list<UserHasRole> roleMap = new UserHasRole[COUNT_OF_ROLE_EXTENSION];													//Each one gets a list of role extensions...
			system.debug('Count of loop iterations: ' + COUNT_OF_ROLE_EXTENSION);
			for(integer j=0; j < COUNT_OF_ROLE_EXTENSION; j++){																		//Loop through each Role Extension...
				UserHasRole uxRole = new UserHasRole(false, RoleExtensionMap.get(j));												//assign it to the User for matrix presentation.
				system.debug(u.username + uxRole);
				if(UserExtensionMap.get(u.Id) != null){																				//If the user maps to assigned Role Extensions...
					list<myKVH_Role__c> UserREList = new list<myKVH_Role__c>(UserExtensionMap.get(u.Id));							//get that list...
					for(myKVH_Role__c r : UserREList){																				//and loop through it (kind of not efficient...)
						if(r.Id == uxRole.RoleExt.Id){																				//if we find that the user already has the role...
							uxRole.sethasRole(true);																				//set the matrix Boolean to True!
						}
					}
				}
				roleMap.set(j, uxRole);																								//Then put the Role Map in our Matrix in order ***Use List.set(i, o) ....
			}																														//***Use List.set(integer, object) method!!***
			system.debug('Size of List: ' + roleMap.size());
			//ExtRoleMatrixRow row = new ExtRoleMatrixRow(u, roleMap);																//create an instance of our wrapper Class
			ExtRoleMatrixRow row = new ExtRoleMatrixRow(u, FrozenUsersMap.get(u.Id), CustomerAdminMap.get(u.Id), roleMap);			//Now with FOUR properties!
			MatrixRows.add(row);																									//and add it to our list of Matrix Rows!
		}
	}
	/**********************************
	 *	Wrapper Class(es) for Matrix  *
	 *********************************/
	public Class ExtRoleMatrixRow{
		public User portalUser;												//Your garden variety Portal User
		public Boolean isNotFrozen;											//represents the (inverse of) isFrozen flag from the UserLogin sObject
		public Boolean isCustomerAdmin;										//indicates if User has Customer Admin Permission Set
		public list<UserHasRole> portalUsersRolesExt;						//Boolean  & myKVH_Role (user has it or not!)
		//constructor
		public ExtRoleMatrixRow(){ }									//no arguement Constructor
		
		public ExtRoleMatrixRow(User u, Boolean f, Boolean ca, list<UserHasRole> puRoleExt){	//three arguement Constructor
			this.PortalUser = u;
			this.isNotFrozen = f;
			this.isCustomerAdmin = ca;
			this.portalUsersRolesExt = puRoleExt;
		}
		
		//Getters (and TWO Setters)
		public User getPortalUser(){return portalUser;}
		
		public Boolean getIsNotFrozen(){return isNotFrozen;}
		public void setIsNotFrozen(Boolean b){isNotFrozen=b;}
		
		public Boolean getIsCustomerAdmin(){return isCustomerAdmin;}
		public void setIsCustomerAdmin(Boolean b){isCustomerAdmin=b;}
		
		public list<UserHasRole> getportalUsersRolesExt(){return portalUsersRolesExt;}
	}
	public Class UserHasRole{											//Boolean  & myKVH_Role (user has it or not!)
		public Boolean hasRole;												//has the role
		public myKVH_Role__c RoleExt;											//the role they have or not!
		//Constructor
		public UserHasRole(){ }										//no arguement Constructor
		
		public UserHasRole(Boolean b, myKVH_Role__c RE){				//two arguement Constructor
			this.hasRole = b;
			this.RoleExt = RE;
		}
		//Getters Setters
		public Boolean gethasRole(){return hasRole;}
		public void sethasRole(Boolean b){hasRole=b;} 
		
		public myKVH_Role__c getRoleExt(){return RoleExt;}				//No setter, use constructor
	}

}