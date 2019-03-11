public class myKVH_edit_user extends myKVH_User_Management_Base{
	
	public Id UserId {get;set;}
	public Boolean hasUserId {get;set;}												//indicates that we do or do not have a User ID
	public Boolean isSelfEditing {get;set;}											//Indicates that the Customer Admin is editing thierself
																					//Use this to prevent a Customer Admin from making thierself
																					//not-a-customer-admin
	public myKVH_edit_user(){	//Constructor
		hasUserId = true;
		try{
			UserId = (id)apexpages.currentpage().getparameters().get('user');
			system.debug('Editing User with Id: ' + UserId);
			if(UserId != null){
				//Query User/myKVH_Contact
				list<User> readUsers = [SELECT Id, username, LastName, FirstName, contactId, Contact.AccountId, Contact.Account.Name
										FROM User WHERE Id =: UserID];
				SFUser = readUsers[0];
				//Refactor to use Query string defined in Base Class
				list<Contact> readContacts = [SELECT Id, FirstName, LastName, Name, Email, Phone, MobilePhone, AccountId, Account.Name, 
													Job_Function__c, Receive_Network_Service_Notifications__c, Network_Outage_Type__c
												FROM Contact 
												WHERE Id =: SFUser.ContactId];
				SFContact = readContacts[0];
				list<myKVH_Contact__c> readmyKVHContacts = [SELECT Id, Name, email__c, First_Name__c, Last_Name__c,
																	mobile__c, phone__c, Receive_Network_Service_Notifications__c,
																	Job_Function__c, Contact__c, Network_Outage_Type__c
															FROM myKVH_Contact__c WHERE Contact__c =: SFContact.Id];
				if(readmyKVHContacts.size() == 0){							//No staging contact... not User created
					myKVHContact = populateActivationContact(SFContact);	//must create one! need to manage that FleetId!
				} else if (readmyKVHContacts.size() > 1){					//Should never happen!!
					//What if there are more than one! Maybe we should search on email!
				} else {													//One and only one staging Contact....
					//myKVHContact = readmyKVHContacts[0];					//THIS one obviously!
					myKVHContact = populateActivationContact(SFContact);	//refresh staging sOBject with real Contact details...
					myKVHContact.Id = readmyKVHContacts[0].Id;				//and query result Id so we can update!
				}
				//VAlidate user Passed into controller is within Current USers' scope....
				AcctsInHierarchy = new list<Account>(getAccountsInHierarchy(myKVHHierarchy));			//Extract a list of Accounts from a filtered Hierarchy
				hasUserId = isManagedUser(SFUser, getManagedUsers(AcctsInHierarchy));					//Dis-allow a URL hack!
				If(hasUserId == true){
					PermissionSet ps = [SELECT Id, Description FROM PermissionSet WHERE Name = 'myKVH_Customer_Admin' LIMIT 1];
					CustAdminToolTip = ps.description;
					initExtendedRolesList();
					RefreshGrid();
					if(UserInfo.getUserId() == UserID){
						isSelfEditing = true;
					}
				}
			} else {
				//handle misdirection! Apex page message? Redirect?
				hasUserId = false;
			}
			
		} catch (exception e){	//Handle a WTF situation....
			system.debug('Exception Message: ' + e.getMessage());
			system.debug('Stack Trace: ' + e.getStackTraceString());
		}
	}
	
	
		
	public void RefreshGrid(){
		system.debug('Invoking refreshGrid()...');
		matrixRows.clear();
		//ManagedUsers = getManagedUsers(AcctsInHierarchy);
		list<User>editableUser = new list<User>();	//reset the list
		editableUser.Add(SFUser);			//Add our ONE editable User... and away we go!
		FrozenUsersMap = getFrozenUsersMap(editableUser);
		CustomerAdminMap = getCustomerAdminMap(editableUser);
		
		UserExtensionsList = [SELECT Id, User__c, User__r.username, ExtendedRole__c, ExtendedRole__r.Name 			//Get a list of the  Role Extensions junction sObject....
								FROM myKVH_User_Role_Extension__c 
								WHERE User__c IN :editableUser AND ExtendedRole__r.isRoleExtension__c = true
								AND ExtendedRole__r.isVisibleInPortal__c = true];									//assigned to that list of Managed Users visible to the Current User!
		UserExtensionMap = getUserExtensionMap(UserExtensionsList);													//Create a map of User Id to list of Role Extensions
		UserAssignedExtensionsMap = getUserAssignedExtensionsMap(UserExtensionsList);								//Create a map of User Id to Assigned Role Extensions
		
		setMatrixRows(editableUser);
		//MatrixRows = getMatrixRows();
	}
	/************************
	 * Controls....         *
	 ***********************/
	public PageReference Cancel(){
		return new PageReference('/Manage_myKVH_Users');
	}
	public PageReference Save(){
		upsert myKVHContact;
		//	Permission Set 
		updateCustomerAdminPermission(); 					// uses @future invokation
		//	UserLogin (e.g. Freeze, Thaw....)
		updateSFUserLogin();								// uses Apex flex queue
		//	Need to save changes to Contact and User as well!!!
		updateSFContact(myKVHContact);
		updatePortalUser(myKVHContact);
		//	Role Extensions
		SaveUREChanges();

		return new PageReference('/Manage_myKVH_Users');
	}
	
	@testVisible private void SaveUREChanges(){
		list<myKVH_User_Role_Extension__c> UREsToAdd = new list<myKVH_User_Role_Extension__c>();		//action list 1
		list<myKVH_User_Role_Extension__c> UREsToDelete = new list<myKVH_User_Role_Extension__c>();		//action list 2
		
		for (ExtRoleMatrixRow row : MatrixRows){																				//loop through the matrix rows and process each one
																																//start by getting a list of this Users existing Role Extensions....
			list<myKVH_User_Role_Extension__c> UserCurrentREList = new list<myKVH_User_Role_Extension__c>(UserAssignedExtensionsMap.get(row.portalUser.Id));
			map<Id, myKVH_User_Role_Extension__c> UsersExistingRoleExtensionMap = new map<Id, myKVH_User_Role_Extension__c>();	//create a map, Role ID, Extension
			for(myKVH_User_Role_Extension__c AssignedRoleExt : UserCurrentREList){												//and loop through the List (kind of not efficient...)
				UsersExistingRoleExtensionMap.put(AssignedRoleExt.ExtendedRole__c, AssignedRoleExt );							//add to the map
			}																													//row processing setup complete
			/*Role extensions to Delete first! Build action list 1*/
			if(UserAssignedExtensionsMap.get(row.portalUser.Id) != null){														//See if this user (one per row!) has existing Role Extensions
				system.debug('This user has Extended Roles!!!');																//That *might* need to be deleted!
				system.debug(UsersExistingRoleExtensionMap);
				system.debug('Size of List: ' + row.portalUsersRolesExt.size());
				for(UserHasRole UREList : row.portalUsersRolesExt){																//loop through the Row's list of Roles....
					if(UREList.hasRole != true && UsersExistingRoleExtensionMap.containsKey(UREList.RoleExt.Id)){				//Box unchecked, but Role Extension exists!
						system.debug('Need to DELETE a Role Extension from: ' + row.portalUser.username + ' Role Extension: ' + UREList.RoleExt.Id); 
						UREsToDelete.add(UsersExistingRoleExtensionMap.get(UREList.RoleExt.Id));								//Add the Role Extension junction object to the action list!
					}
				}
			}
			/*Role extensions to Add second! build action list 2*/
			for(UserHasRole UREList : Row.portalUsersRolesExt){
				if(UREList.hasRole && UserAssignedExtensionsMap.get(row.portalUser.Id) == null){								//little box checked and they don't have *any* Role Extensions
					system.debug('Need to ADD a Role Extension for: ' + row.portalUser.username + ' Role Extension: ' + UREList.RoleExt);
					UREsToAdd.add(new myKVH_User_Role_Extension__c(User__c = row.portalUser.Id, ExtendedRole__c = UREList.RoleExt.Id));
				} else if (UREList.hasRole && UserAssignedExtensionsMap.get(row.portalUser.Id) != null){						//little box checked and they DO have Role extensions...
					if(UsersExistingRoleExtensionMap.containsKey(UREList.RoleExt.Id) == false){									//just not this one!!
						system.debug('Need to ADD a User Role Extension : ' + UREList.RoleExt.Name + ' To User: '+ row.portalUser.username);
						UREsToAdd.add(new myKVH_User_Role_Extension__c(User__c = row.portalUser.Id, ExtendedRole__c = UREList.RoleExt.Id));
					}
				} else {
					system.debug('Dont need to add URE: ' + UREList.RoleExt.Name + ' To User: ' + row.portalUser.username);
				}
			}
		}
		if(UREsToDelete.size() > 0){		//anything to delete??
			delete UREsToDelete;
		}
		if(UREsToAdd.size() > 0){			//anything to add??
			insert UREsToAdd;
		}
	}
	@testVisible private void updateCustomerAdminPermission(){
		//TODO need to ensure that a Customer Admin cannot remove thier own permission set!!
		//TODO avoid mixed DML
		system.debug('Invoking updateCustomerAdminPermission Method with no input Parameters....');
		list<ID> PSAsToAdd = new list<ID>();								//User IDs!!
		list<ID> PSAsToDel = new list<ID>();								//PermissionSetAssignment IDs!
		Id PermSetId;														//declare var for Perm set ID
		PermissionSet PermSet = [SELECT Id FROM PermissionSet WHERE Name = 'myKVH_Customer_Admin' LIMIT 1];
		PermSetId = Permset.Id;
		system.debug('Permission Set Id: ' + PermSetId);
		
		map<Id, Boolean> AddRemoveCustomerAdminMap = new map<Id, Boolean>();//Map of User Id to new admin flag for changed rows
		
		list<User> uList = new list<User>();								//construct a User list
		uList.Add(SFUser);													//Add our ONE User...
		map<Id, Boolean> CustAdminMap = getCustomerAdminMap(uList);			//create a NEW CustomerAdminMap from the database...
		system.debug('Base Class Perm Set ID: '  );
		system.debug('Database Customer Admins: ' + CustAdminMap);
		
		for(ExtRoleMatrixRow row : MatrixRows){											//Compare ROWs to List from DB
			system.debug('Row from page Admin Flag: ' + row.isCustomerAdmin);
			if(row.isCustomerAdmin != CustAdminMap.get(row.portalUser.Id)){				//There has been a change!!
				system.debug('User: ' + row.portalUser.Id + ' has had Admin Flag changed to: ' + row.isCustomerAdmin);
				AddRemoveCustomerAdminMap.put(row.portalUser.Id, row.isCustomerAdmin);	//add to "has changed" map
				if(row.isCustomerAdmin){												//if this is an add PermSet...
					PSAsToAdd.add(row.portalUser.Id);									//might as well capture it now!
				}
			} //else... no changes, there's nothing else to do!
		}
		if(AddRemoveCustomerAdminMap.size() > 0){	//find Users that already have the Customer Admin Permmission set 
													//(AND have been changed on page....)
			for(PermissionSetAssignment p : [SELECT Id, PermissionSetId, AssigneeId FROM PermissionSetAssignment
											 WHERE PermissionSet.Name = 'myKVH_Customer_Admin'
											 AND AssigneeId IN: AddRemoveCustomerAdminMap.keyset()]){
				if(AddRemoveCustomerAdminMap.get(p.AssigneeId) != true){	//Customer Admin is to be removed...
					PSAsToDel.add(p.Id);									//add the PermissionSetAssignment Id to be deleted....
					
				}
				
			}//Need to setup an @future method to handle the PSA adds/deletes.....
			/*Methods with the future annotation must be static methods, and can only return a void type.
			  The specified parameters must be primitive data types, arrays of primitive data types, or collections of primitive data types.
			  Methods with the future annotation cannot take sObjects or objects as arguments.*/
		}
		UpdateSFPermissionSets(PSAsToAdd, PSAsToDel, PermSetId);			//invoke @future method with params....
	}
	@future static void UpdateSFPermissionSets (list<Id> Adds, list<Id> Deletes, Id PermSetId){
		system.debug('Permission Set Id: ' + PermSetId);
		//The Deletes list is a list of PermissionSetAssignment Ids to be removed
		//The Adds list is a lsit of User IDs to have the myKVH_Customer_Admin permsision set assigned
		//PermSetId is the Permission Set Id to be assigned.
		list<PermissionSetAssignment> PSADels = new list<PermissionSetAssignment>();	//Need a list..
		if(Deletes != null){			//original = if(Adds != null)
			for(Id i : Deletes){															//Loop through primitives...
				PSADels.Add(new PermissionSetAssignment(Id=i));								//Converting as we go...
			}																				//And adding to list....
			delete PSADels;																	//Nuke those suckers!
		}
		
		if(Adds != null){		//original = if(Deletes != null)
			list<PermissionSetAssignment> PSAAdds = new list<PermissionSetAssignment>();			//Need a list..
			for(Id i : Adds){																		//Loop through primitives...
				PSAAdds.add(new PermissionSetAssignment(AssigneeId=i, PermissionSetId=PermSetId));	//Converting as we go...
			}																						//And adding to list....
			insert PSAAdds;																			//Nuke those suckers!
		}
	}
	
	@testVisible private void updateSFUserLogin(){
		system.debug('Invoking updateSFUserLogin Method with no input Parameters....');
		map<Id, Boolean> FreezeThawMap = new map<Id, Boolean>();			//User Id to isActive Status
		list<User> uList = new list<User>();								//construct a User list
		uList.Add(SFUser);													//Add our ONE User...
		map<Id, Boolean> FrozenUsers = getFrozenUsersMap(uList);			//create a NEW FrozenUserMap (isFrozen)...
		system.debug('Database Frozen Users: ' + FrozenUsers);
		
		for(ExtRoleMatrixRow row : MatrixRows){								//Compare ROW to List from DB
			if(row.isNotFrozen != FrozenUsers.get(row.portalUser.Id)){		//There has been a change!!
				system.debug('User: ' + row.portalUser.Id + ' has had isActive Flag changed to: ' + row.isNotFrozen);
				FreezeThawMap.put(row.portalUser.Id, row.isNotFrozen);		//Add the User to a Map with thier isActive Status
			} //else... no changes, there's nothing else to do!
		}
		if(FreezeThawMap.size() > 0){										//A user has been frozen or thawed....
			list<UserLogin> updateList = new list<UserLogin>();				//setup a list to be updated....
			for(UserLogin ul : [SELECT Id, UserId, isFrozen FROM UserLogin WHERE UserId IN: FreezeThawMap.keyset()]){			//get the Users to be updated....
				system.debug('Old isFrozen Flag: ' + ul.isFrozen + ' New isFrozen Flag:  ' + !FreezeThawMap.get(ul.UserId));	//invert logic!
				ul.isFrozen = !FreezeThawMap.get(ul.UserId);																	//Use map for current (changed to) Status, invert logic!!!
				updateList.add(ul);																								//add them to the update list....
			}
			update updateList; 												//implement the update
		}
	}
	
	@testVisible private void updateSFContact(myKVH_Contact__c stagingContact){
		system.debug('Invoking updateSFContact Method with: ' + stagingContact);
		String ContactId = stagingContact.Contact__c;
		Contact c = new Contact();
		list<Contact> cList = new list<Contact>();
		string WhereClause = 'WHERE Id = \'' + ContactId + '\'' ;			//Dynamic SOQL using database method is a touchy thing!
		system.debug('Query string: ' + ContactSelect + WhereClause); 		//ContactSelect is defined in Base Class
		cList = Database.query(ContactSelect + WhereClause);
		c = cList[0];
		//Fields below must match Query string in Base Class
		//c.email = stagingContact.email__c;	NOPE! Customer Admin CANNOT change Email (or Account!)
		c.FirstName = stagingContact.First_Name__c;
		c.LastName = stagingContact.Last_Name__c ;
		c.MobilePhone = stagingContact.mobile__c;
		c.Phone = stagingContact.phone__c;
		c.Receive_Network_Service_Notifications__c = stagingContact.Receive_Network_Service_Notifications__c;
		c.Network_Outage_Type__c = stagingContact.Network_Outage_Type__c;
		c.Job_Function__c = stagingContact.Job_Function__c;
		update c;
		//c.Id = stagingContact.Contact__c;											//super critical! affects user creation
	}
	@testVisible private void updatePortalUser(myKVH_Contact__c stagingContact){
		system.debug('Invoking updateSFUser Method with: ' + stagingContact);
		SFUser.LastName = stagingContact.Last_Name__c;
		SFUser.FirstName = stagingContact.First_Name__c;
		SFUser.Phone = stagingContact.phone__c;
		SFUser.MobilePhone = stagingContact.mobile__c;
		ID jobID = System.enqueueJob(new updateUser(SFUser));
		system.debug('Queued Job Id: ' + jobId);
	}
	public class updateUser implements Queueable{		//Queueable Class to avoid Mixed DML
		private User u = new User();					//Needs a User to create (should NOT have a record ID initially!)
		public updateUser(User editUser){				//constructor, handles input parameter
			this.u = editUser;							// "u" is visible to Class now.
		}
		public void execute(QueueableContext context){	//Mandatory Execute method
			update u;									//insert the User (won't work if there is a record ID!)
			system.debug(u);							
		}
	}
	/* getters setters */

}