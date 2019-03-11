/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class myKVH_User_Management_Base_test {
	private static final Id Platform_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Demo/Test/Monitor').getRecordTypeId();
	private static final Id DirectCust_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Customer').getRecordTypeId();
	private static final User adminUser = [SELECT Id, username FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
	static final integer MAX_LOOP_COUNTER = 6;
	
	
	@testSetup static void setupTestData(){
		//We are going to need....
		//An Account hierarchy including Platform, DC (not sent to myKVH), DC Send to myKVH
		//Contacts along that hierarchy and related Users
		//myKVH Roles (extended)
		list<Account> testAccounts = new list<Account>();
		Account Level1 = new Account(Name = 'Level 1', RecordTypeId = DirectCust_RECORD_TYPE_ID, Send_to_myKVH_Physical__c = true, Apply_Custom_Sharing__c = true);
		testAccounts.add(Level1);
		Account Level2a = new Account(Name = 'Level 2a', RecordTypeId = DirectCust_RECORD_TYPE_ID, Send_to_myKVH_Physical__c = false, Apply_Custom_Sharing__c = true);
		testAccounts.add(Level2a);
		Account Level2b = new Account(Name = 'Level 2b', RecordTypeId = DirectCust_RECORD_TYPE_ID, Send_to_myKVH_Physical__c = true, Apply_Custom_Sharing__c = true);
		testAccounts.add(Level2b);
		Account Platform1a = new Account(Name = 'Platform 1a', RecordTypeId = Platform_RECORD_TYPE_ID, Send_to_myKVH_Physical__c = true, myKVH_Element_Count__c = 1, Apply_Custom_Sharing__c = true);
		testAccounts.add(Platform1a);
		Account Platform1b = new Account(Name = 'Platform 1b', RecordTypeId = Platform_RECORD_TYPE_ID, Send_to_myKVH_Physical__c = true, myKVH_Element_Count__c = 1, Apply_Custom_Sharing__c = true);
		testAccounts.add(Platform1b);
		insert testAccounts;
		testAccounts.clear();
		Level2a.ParentId = Level1.Id;
		Level2b.ParentId = Level1.Id;
		Platform1a.ParentId = Level2a.Id;
		Platform1b.ParentId = Level2b.Id;
		testAccounts.add(Level2a);
		testAccounts.add(Level2b);
		testAccounts.add(Platform1a);
		testAccounts.add(Platform1b);
		update testAccounts;				//Account Hierarchy all set....
		
		//add a bunch of contacts...
        list<Contact> contactList = new list<Contact>();
        for(integer i = 0; i < MAX_LOOP_COUNTER; i++){
        	Contact testContact = new Contact(LastName = 'test' + i, AccountId = Level1.Id);
        	contactList.add(testContact);
        }
        insert contactList;
        
		//Need a Profile.... a PORTAL profile! Profiles are Metadata!
		Profile PortalProf = new Profile();
		PortalProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Portal%' Limit 1];
		system.debug(PortalProf);
		//Convert Contacts to Portal Users
		list<User> userList = new list<User>();
		for(integer i = 0; i < MAX_LOOP_COUNTER; i++){
			User tu = new User();
			tu.username = i + 'AccountAdmin.testUser@mock.user';
			tu.LastName = 'User1';
			tu.Email = i + 'AccountAdmin.testUser@mock.user';
			tu.Alias = 'AccAdm' + i;
			tu.TimeZoneSidKey = 'America/New_York';
			tu.LocaleSidKey = 'en_US';
			tu.EmailEncodingKey = 'ISO-8859-1';
			tu.ProfileId = PortalProf.id;
			tu.LanguageLocaleKey = 'en_US';
			tu.ContactId = contactList[i].Id; //must CREATE() user with Contact Id.....
			userList.Add(tu);
		}
		system.runAs(adminUser){
			insert userList;
		}
		//Need to apply Custom Sharing to Account Hierarchy
		/*Set<Id> testAcctIds = (new Map<Id,SObject>(testAccounts)).keySet();
		UAccountShareJKT.createAccountShare(testAcctIds, false);
		
		list<AccountShare> shareList = [SELECT Account.Name, UserOrGroupID, AccountAccessLevel FROM AccountShare];
		system.debug('Account Shares created: ' + shareList);*/
		
		//system.assert(false);
		list<myKVH_Role__c> testRoles = new list<myKVH_Role__c>();
		for(integer i = 0; i < 4; i++){
			myKVH_Role__c r = new myKVH_Role__c();
			r.name = 'testRole ' + i;
			if(i==0){
				r.isRoleExtension__c = false; 
			} else {
				r.isRoleExtension__c = true; 
				r.isVisibleInPortal__c = true;
			}
			testRoles.add(r);
		}
		insert testRoles;
		system.runAs(adminUser){
			//Apply Role Extensions to Users
			list<myKVH_User_Role_Extension__c> UREinsert = new list<myKVH_User_Role_Extension__c>();
			for(User u : userList){
				for(myKVH_Role__c r : [SELECT Id FROM myKVH_Role__c WHERE isRoleExtension__c = true AND isVisibleInPortal__c = true]){
					UREinsert.add(new myKVH_User_Role_Extension__c(ExtendedRole__c = r.Id, User__c = u.Id));
				}
			}
			insert UREinsert;
		}
	}
	
	static testMethod void test_SetupData() {
        Account[] AcctList = [SELECT Id, Name, RecordTypeId, Send_to_myKVH_Physical__c FROM Account];
        system.assertEquals(5, AcctList.size());
        for(Account a : AcctList){
        	if(a.Name == 'Level 2a'){
        		system.Assert(a.Send_to_myKVH_Physical__c == false);
        	} else {
        		system.Assert(a.Send_to_myKVH_Physical__c == true);
        	}
        }
        User[] userList = [SELECT Id, username FROM User WHERE username LIKE '%AccountAdmin.testUser@mock.user'];
        system.assertEquals(MAX_LOOP_COUNTER, userList.size());
        myKVH_Role__c[] rolesList = [SELECT Id, Name, isRoleExtension__c FROM myKVH_Role__c];
        system.assertEquals(4, rolesList.size());
        for(myKVH_Role__c r : rolesList){
        	if(r.Name == 'testRole 0'){
        		system.assertEquals(false, r.isRoleExtension__c);
        	} else {
        		system.assertEquals(true, r.isRoleExtension__c);
        	}
        }
        //make sure we have the right number of UserRoleExtensions
        list<myKVH_Role__c> readRoles= new list<myKVH_Role__c>();
        readRoles = [SELECT Id FROM myKVH_Role__c WHERE isRoleExtension__c = true AND isVisibleInPortal__c = true];
        list<myKVH_User_Role_Extension__c> UREread = new list<myKVH_User_Role_Extension__c>();
        UREread = [SELECT Id FROM myKVH_User_Role_Extension__c];
        system.assertEquals((readRoles.size() * userList.size()), UREread.size());
    }
    static testMethod void test_getCustomerAdminMap(){
    	//ARRANGE
		User CustAdminUser = new User();
		CustAdminUser = [SELECT Id FROM User WHERE username = '0AccountAdmin.testUser@mock.user' LIMIT 1];
		//Need to make sure that at least one user has the customer admin permission set....
		PermissionSet PS = [SELECT Id, Name FROM PermissionSet
							WHERE Name = 'myKVH_Customer_Admin' LIMIT 1];
		PermissionSetAssignment PSA = new PermissionSetAssignment(PermissionSetId = PS.Id, AssigneeId=CustAdminUser.Id);
		insert PSA;
		test.startTest();
		system.runAs(CustAdminUser){																			//Do Portal user first
			PageReference pageRef = Page.Manage_myKVH_Users;
			Test.setCurrentPage(pageRef);
			Manage_myKVH_Users util = new Manage_myKVH_Users();													//tests constructor...
			util.onLoad();																						//simple Page Load...
			list<myKVH_User_Management_Base.ExtRoleMatrixRow> readList = util.getMatrixRows();
			system.assertEquals(MAX_LOOP_COUNTER, util.ManagedUsers.size());
			system.assertEquals(3, util.ExtendedRolesList.size());													//Should be three
			map<Id, Boolean> CustAdmins = util.getCustomerAdminMap(util.ManagedUsers);
			system.assertEquals(MAX_LOOP_COUNTER, CustAdmins.size());
			for(Id i : CustAdmins.keySet()){
				if(i ==  CustAdminUser.id){
					system.assertEquals(true, CustAdmins.get(i));
				} else {
					system.assertNotEquals(true, CustAdmins.get(i));
				}
			}
		}
		test.stopTest();
    }

    static testMethod void test_Constructor(){
    	//ARRANGE
		User CustAdminUser = new User();
		CustAdminUser = [SELECT Id FROM User WHERE username = '0AccountAdmin.testUser@mock.user' LIMIT 1];
		//Need to make sure that at least one user has the customer admin permission set....
		PermissionSet PS = [SELECT Id, Name FROM PermissionSet
							WHERE Name = 'myKVH_Customer_Admin' LIMIT 1];
		PermissionSetAssignment PSA = new PermissionSetAssignment(PermissionSetId = PS.Id, AssigneeId=CustAdminUser.Id);
		insert PSA;
		
		test.startTest();
		
		system.runAs(CustAdminUser){																			//Do Portal user first
			//PageReference pageRef = Page.Manage_myKVH_Users;
			//Test.setCurrentPage(pageRef);
			myKVH_User_Management_Base util = new myKVH_User_Management_Base();													//tests constructor...
			system.debug('Current User: ' + util.currentUser);
			//Account Sharing prevents this from working correctly.
			//system.assertEquals(5, util.RawHierarchy.size());
			//system.assertEquals(3, util.myKVHHierarchy.size());
			util.initExtendedRolesList();
			system.assertEquals(3, util.ExtendedRolesList.size());
			system.assertEquals(3, util.COUNT_OF_ROLE_EXTENSION);
			util.AcctsInHierarchy = util.getAccountsInHierarchy(util.myKVHHierarchy);
			list<User> readUsers = util.getManagedUsers(util.AcctsInHierarchy);
			map<Id, Boolean> readPopcicles = util.getFrozenUsersMap(readUsers);
		}
		test.stopTest();
    }
    static testMethod void test_ExtRoleMatrixRow(){
    	User[] userList = [SELECT Id, username FROM User WHERE username LIKE '%AccountAdmin.testUser@mock.user'];
    	myKVH_User_Management_Base.ExtRoleMatrixRow ERMR = new myKVH_User_Management_Base.ExtRoleMatrixRow();
    	system.assertEquals(null, ERMR.portalUser);
    	system.assertEquals(null, ERMR.isNotFrozen);
    	system.assertEquals(null, ERMR.isCustomerAdmin);
    	system.assertEquals(null, ERMR.portalUsersRolesExt);
    	
    	myKVH_User_Management_Base.UserHasRole UHR = new myKVH_User_Management_Base.UserHasRole();
    	system.assertEquals(null, UHR.hasRole);
    	system.assertEquals(null, UHR.RoleExt);
    	
    	list<myKVH_User_Management_Base.UserHasRole> UHRList = new list<myKVH_User_Management_Base.UserHasRole>();
    	integer counter = 0;
        for(myKVH_Role__c r : [SELECT Id FROM myKVH_Role__c WHERE isRoleExtension__c = true AND isVisibleInPortal__c = true]){
        	UHRList.add(new myKVH_User_Management_Base.UserHasRole(true, r));
        	counter++;
        }
    	ERMR.portalUser = userList[0];
    	ERMR.setIsNotFrozen(true);
    	ERMR.setIsCustomerAdmin(true);
    	ERMR.portalUsersRolesExt =  UHRList;
    	
    	system.assertEquals(userList[0], ERMR.getPortalUser());
    	system.assertEquals(true, ERMR.getIsNotFrozen());
    	system.assertEquals(true, ERMR.getisCustomerAdmin());
    	system.assertEquals(counter, ERMR.getportalUsersRolesExt().size());
    	
    }
    
    static testMethod void test_PopulateActivationContact(){
    	//ARRANGE
    	myKVH_User_Management_Base util = new myKVH_User_Management_Base();
    	
		User u = [SELECT Id FROM User WHERE username = '0AccountAdmin.testUser@mock.user' LIMIT 1];
    	Account a = [SELECT Id From Account WHERE Name = 'Level 1' LIMIT 1];
    	
    	Contact c = new Contact();
    	c.email = 'unit@test.com';
		c.FirstName = 'Unit';
		c.LastName = 'Test';
		c.MobilePhone = '401-555-1212';
		c.Phone = '401-555-1212';
		c.Receive_Network_Service_Notifications__c = true;
		c.Job_Function__c = 'Captain';
		c.AccountId = a.Id;
    	insert c;
    	//ACT
    	myKVH_Contact__c stagingContact = util.populateActivationContact(c);
    	system.assertEquals(c.email , stagingContact.email__c);
    	system.assertEquals(c.FirstName , stagingContact.First_Name__c);
    	system.assertEquals(c.LastName , stagingContact.Last_Name__c);
    	system.assertEquals(c.MobilePhone , stagingContact.mobile__c);
    	system.assertEquals(c.Phone , stagingContact.phone__c);
    	system.assertEquals(c.Receive_Network_Service_Notifications__c , stagingContact.Receive_Network_Service_Notifications__c);
    	system.assertEquals(c.Job_Function__c , stagingContact.Job_Function__c);
    	system.assertEquals(util.fleetId, a.Id);
    	
    	util.myKVHContact = stagingContact;
    	util.SFContact = c;
    	util.SFUser = u;
    }
    static testMethod void test_getUserExtensionMap(){
    	//ARRANGE
    	myKVH_User_Management_Base util = new myKVH_User_Management_Base();
    	list<myKVH_Role__c> readRoles= new list<myKVH_Role__c>();
        readRoles = [SELECT Id FROM myKVH_Role__c WHERE isRoleExtension__c = true AND isVisibleInPortal__c = true];
        list<myKVH_User_Role_Extension__c> UREread = new list<myKVH_User_Role_Extension__c>();
        UREread = [SELECT Id, User__c, ExtendedRole__c FROM myKVH_User_Role_Extension__c];
        util.initExtendedRolesList();
        //ACT
        map<Id, list<myKVH_Role__c>> readMap = util.getUserExtensionMap(UREread);
        //ASSERT
        User[] userList = [SELECT Id, username FROM User WHERE username LIKE '%AccountAdmin.testUser@mock.user'];
        for(User u : userList){
        	system.assertEquals(3, readMap.get(u.Id).size());
        }
    }
}