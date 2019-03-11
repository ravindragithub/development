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
private class test_Manage_myKVH_Users {
	private static final Id Platform_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Demo/Test/Monitor').getRecordTypeId();
	private static final Id DirectCust_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Customer').getRecordTypeId();
	private static final User adminUser = [SELECT Id, username FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
	static final integer MAX_LOOP_COUNTER = 24;
	
	@testSetup static void setupTestData(){
		//We are going to need....
		//An Account hierarchy including Platform, DC (not sent to myKVH), DC Send to myKVH
		//Contacts along that hierarchy and related Users
		//myKVH Roles (extended)
		list<Account> testAccounts = new list<Account>();
		Account Level1 = new Account(Name = 'Level 1', RecordTypeId = DirectCust_RECORD_TYPE_ID, Send_to_myKVH_Physical__c = true);
		testAccounts.add(Level1);
		Account Level2a = new Account(Name = 'Level 2a', RecordTypeId = DirectCust_RECORD_TYPE_ID, Send_to_myKVH_Physical__c = false);
		testAccounts.add(Level2a);
		Account Level2b = new Account(Name = 'Level 2b', RecordTypeId = DirectCust_RECORD_TYPE_ID, Send_to_myKVH_Physical__c = true);
		testAccounts.add(Level2b);
		Account Platform1a = new Account(Name = 'Platform 1a', RecordTypeId = Platform_RECORD_TYPE_ID, Send_to_myKVH_Physical__c = true, myKVH_Element_Count__c = 1);
		testAccounts.add(Platform1a);
		Account Platform1b = new Account(Name = 'Platform 1b', RecordTypeId = Platform_RECORD_TYPE_ID, Send_to_myKVH_Physical__c = true, myKVH_Element_Count__c = 1);
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
	}
	static testMethod void test_Controller(){
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
			system.assertEquals(MAX_LOOP_COUNTER, util.ManagedUsers.size());
			system.assertEquals(3, util.ExtendedRolesList.size());													//Should be three
			User delUser = [SELECT Id FROM User WHERE username = '1AccountAdmin.testUser@mock.user' LIMIT 1];	//Deactivate one User
			delUser.isActive = false;
			update delUser;
			util.RefreshGrid();
			system.assertEquals(MAX_LOOP_COUNTER-1, util.ManagedUsers.size());									//Count should change
			User User2 = [SELECT Id FROM User WHERE username = '2AccountAdmin.testUser@mock.user' LIMIT 1];		//need another User
			myKVH_Role__c[] testRole = [SELECT Id FROM myKVH_Role__c WHERE isRoleExtension__c = true LIMIT 2];	//and 2 Roles
			myKVH_User_Role_Extension__c URE = new myKVH_User_Role_Extension__c();								//Use to create a role extensions
			URE.User__c = User2.Id;							
			URE.ExtendedRole__c = testRole[0].Id;
			insert URE;																							//Add it to the database
			URE = new myKVH_User_Role_Extension__c();															//Use to create a role extensions
			URE.User__c = User2.Id;							
			URE.ExtendedRole__c = testRole[1].Id;
			insert URE;																							//Add it to the database
			util.RefreshGrid();																					//refresh the grid
			system.assertEquals(2, util.UserExtensionsList.size());												//Should be only TWO checkBox! (And on ONE User!)
			
			list<myKVH_User_Management_Base.ExtRoleMatrixRow> pageTable = util.getMatrixRows();							//lets get a table from the page...
			system.assertEquals(MAX_LOOP_COUNTER-1, pageTable.size());											//Should have this many rows...
			
			system.assertEquals(MAX_LOOP_COUNTER-1, util.MatrixRows.size());									//Should have this many rows...
			myKVH_User_Management_Base.ExtRoleMatrixRow pageTableRow = util.MatrixRows[0];								//pluck off one row
			user User3 = pageTableRow.getPortalUser();															//Pluck off a user...
			list<myKVH_User_Management_Base.UserHasRole> User3Roles = pageTableRow.getportalUsersRolesExt();			//get thier list of UREs
			
			for(integer i = 0; i < util.MatrixRows.size(); i++){												//loop through the matrix rows
				if(util.MatrixRows[i].getPortalUser().username =='2AccountAdmin.testUser@mock.user'){			//This is the user that already has extended rows!
					for(integer j = 0; j < util.MatrixRows[i].getportalUsersRolesExt().size(); j++){			//loop through the roles...
						if(util.MatrixRows[i].getportalUsersRolesExt()[j].gethasRole()){
							myKVH_Role__c testRoleGetter = util.MatrixRows[i].getportalUsersRolesExt()[j].getRoleExt();
							util.MatrixRows[i].getportalUsersRolesExt()[j].sethasRole(false);					//invert the setting
						} else if(util.MatrixRows[i].getportalUsersRolesExt()[j].gethasRole() == false){
							util.MatrixRows[i].getportalUsersRolesExt()[j].sethasRole(true);					//invert the setting
						}
					}
				} else if (util.MatrixRows[i].getPortalUser().username =='3AccountAdmin.testUser@mock.user'){			//This is the user that has no  extended rows!
					for(integer j = 0; j < util.MatrixRows[i].getportalUsersRolesExt().size(); j++){			//loop through the roles...
						if(util.MatrixRows[i].getportalUsersRolesExt()[j].gethasRole() == false){
							util.MatrixRows[i].getportalUsersRolesExt()[j].sethasRole(true);					//invert the setting
						}
					}
				}
			}
			myKVH_User_Management_Base.ExtRoleMatrixRow testNoArguementConstructor = new myKVH_User_Management_Base.ExtRoleMatrixRow();
			myKVH_User_Management_Base.UserHasRole testNoArguementConstructor2 = new myKVH_User_Management_Base.UserHasRole();
		}
		test.stopTest();
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
    }

}