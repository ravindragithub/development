public class Manage_myKVH_Users extends myKVH_User_Management_Base{
	/*****************************
	 *	Class variables, Are mostly in the Base Class
	 *****************************/
	
	//public list<Account> AcctsInHierarchy {get;set;}									//List of Accounts in the Current Users Hierarchy
	//public list<User> ManagedUsers;														//This is a list of the Users that the Current Users can manage (based on an Acct Hierarchy)
	
	//public list<myKVH_Role__c> ExtendedRolesList {get;set;}								//This is a list of all Role Extensions
	//public integer COUNT_OF_ROLE_EXTENSION {get;set;}									//Count of Role Extensions (e.g. Matrix Columns)
	
	//public map<integer, myKVH_Role__c> RoleExtensionMap {get;set;}						//This is a lookup map used to keep columns aligned
	
	//public list<myKVH_User_Role_Extension__c> UserExtensionsList {get;set;}				//This is a list of Role Extensions and assigned Users
	//public map<Id, list<myKVH_User_Role_Extension__c>> UserAssignedExtensionsMap {get;set;}		//maps User Id to assigned Role Extensions...
	//public map<Id, list<myKVH_Role__c>> UserExtensionMap {get;set;}					//This is a Map, User ID to list of Role Extensions
	//public map<Id, Boolean> FrozenUsersMap {get;set;}									//This is a Map, User Id to UserLogin.isFrozen
	//public map<id, Boolean> CustomerAdminMap {get;set;}								//This is a Map, User Id to Customer Admin Permission Set
	
	//public string CustAdminToolTip {get; set;}											//This serves as a Tooltip for the "Admin" role (PermissionSet.Description)
	
	//public list<ExtRoleMatrixRow> MatrixRows = new list<ExtRoleMatrixRow>();			//This is a list of Users with ALL Role Extensions (Our Wrapper Class)
	
	/******************************
	 *	Constructor
	 ******************************/ 
	public Manage_myKVH_Users(){	//BIG Constructor, much to do!
		system.debug('Manage_myKVH_Users.Constructor invoked');
	}
	public void onLoad(){	//Runs when page loads 
		/*ExtendedRolesList = [SELECT Id, Name, Description__c, Column_Header__c, isRoleExtension__c, Tool_Tip_Text__c FROM myKVH_Role__c 
							WHERE isRoleExtension__c = true
							AND isVisibleInPortal__c = true];*/																		//Get a list of all Role Extensions visible in Portal
		initExtendedRolesList();																									//initialize Base Class var
		
		system.debug(COUNT_OF_ROLE_EXTENSION);
		system.debug(myKVHHierarchy);
		AcctsInHierarchy = new list<Account>(getAccountsInHierarchy(myKVHHierarchy));			//Extract a list of Accounts from a filtered Hierarchy
		system.debug(AcctsInHierarchy);
		refreshGrid();
		//MatrixRows = getMatrixRows();
	}

	public void RefreshGrid(){
		system.debug('Invoking refreshGrid()...');
		matrixRows.clear();
		ManagedUsers = getManagedUsers(AcctsInHierarchy);
		FrozenUsersMap = getFrozenUsersMap(ManagedUsers);
		CustomerAdminMap = getCustomerAdminMap(ManagedUsers);
		
		UserExtensionsList = [SELECT Id, User__c, User__r.username, ExtendedRole__c, ExtendedRole__r.Name 							//Get a list of the  Role Extensions junction sObject....
								FROM myKVH_User_Role_Extension__c 
								WHERE User__c IN :ManagedUsers AND ExtendedRole__r.isRoleExtension__c = true
								AND ExtendedRole__r.isVisibleInPortal__c = true];						//assigned to that list of Managed Users visible to the Current User!
		UserExtensionMap = getUserExtensionMap(UserExtensionsList);																	//Create a map of User Id to list of Role Extensions
		UserAssignedExtensionsMap = getUserAssignedExtensionsMap(UserExtensionsList);												//Create a map of User Id to Assigned Role Extensions
		
		setMatrixRows(ManagedUsers);
		//MatrixRows = getMatrixRows();
	}


	/***********************
	 * Getters/Setters
	 ***********************/


}