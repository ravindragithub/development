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
private class test_myKVH_add_new_User_ctrlEXT {
	private static final Id Platform_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Demo/Test/Monitor').getRecordTypeId();
	private static final Id DirectCust_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Customer').getRecordTypeId();
	private static final Id IndirectCust_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Indirect Customer').getRecordTypeId();
	private static final User adminUser = [SELECT Id, username FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
	private static final integer MAX_LOOP_COUNTER = 4;	//minimum of 4!
	
    @testSetup static void setupTestData() {
        // TO DO: implement unit test
        //create some portal and an internal User
        //Insert a Test User
		//Need a contact and account..
		//Going to need a parent Account too...
		//AND a platform, don't forget the send flags!!
		system.assert(MAX_LOOP_COUNTER >= 4);				//minimum of 4!
		list<Account> testAccountList = new list<Account>();
		Account testAcct = new Account(Name = 'myKVH_User_Admin_Controller Test Account', RecordTypeId = Platform_RECORD_TYPE_ID);
		testAcct.myKVH_Element_Count__c = 1;				//must have elements!
		
		
        Account testParent = new Account(Name = 'myKVH_User_Admin_Controller Test Parent Account', RecordTypeId = DirectCust_RECORD_TYPE_ID);
		testParent.Send_to_myKVH_Physical__c = true;
        
        Account testGrandParent = new Account(Name = 'myKVH_User_Admin_Controller Test GrandParent Account', RecordTypeId = DirectCust_RECORD_TYPE_ID);
        testGrandParent.Send_to_myKVH_Physical__c = true;
        
		testAccountList.add(testAcct);
		testAccountList.add(testParent);
		testAccountList.add(testGrandParent);
		insert testAccountList;
		testAcct.ParentId  = testParent.Id;
		update testAcct;
		testParent.ParentId  = testGrandParent.Id;
		update testParent;
		for(Account a : testAccountList){
			system.debug('Id: ' + a.Id + ' |Name: ' + a.Name + ' |Parent: ' + a.ParentId);
		}

		//testAccountList.add(testAcct);
		//testAccountList.add(testParent);
		//update testAccountList;
        //testAcct = [SELECT id, Name FROM Account WHERE Name = 'testAcct'];
        //add a bunch of contacts...
        list<Contact> contactList = new list<Contact>();
        for(integer i = 0; i < MAX_LOOP_COUNTER; i++){
        	Contact testContact = new Contact(FirstName = 'Contact' + i, LastName = 'Test' + i, Email = i + 'AccountAdmin.testContact@mock.user');
        	if(math.mod(i,2) == 0 ){	//even index on GrandParent, odd on Parent.....
        		testContact.AccountId = testGrandParent.Id;
        	} else {
        		testContact.AccountId = testParent.Id;
        	}
        	contactList.add(testContact);
        }
        insert contactList;
        
		//Need a Profile.... a PORTAL profile! Profiles are Metadata!
		list<Profile> PortalProfs = new list<Profile>();
		PortalProfs = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Portal%'];
		system.debug(PortalProfs);
		//Also need a myKVH Role... 
		myKVH_Role__c mockRole = new myKVH_Role__c();
		mockRole.name = 'mockRole';
		insert mockRole;
		myKVH_Role__c mockRole2 = new myKVH_Role__c();
		mockRole2.name = 'mockRole2';
		insert mockRole2;
		//create Custom Setting
		myKVH_new_User_Defaults__c setting = new myKVH_new_User_Defaults__c();
		setting.name = 'DirectCustomerDefaults';
		setting.SF_Profile_Id__c = PortalProfs[0].Id;
		setting.myKVH_Role_Id__c = mockRole.Id;
		insert setting;
		
		myKVH_new_User_Defaults__c setting2 = new myKVH_new_User_Defaults__c();
		setting2.name = 'CustomerOfServiceProviderDefaults';
		setting2.SF_Profile_Id__c = PortalProfs[1].Id;
		setting2.myKVH_Role_Id__c = mockRole2.Id;
		insert setting2;
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
			tu.ProfileId = PortalProfs[0].id;
			tu.LanguageLocaleKey = 'en_US';
			tu.ContactId = contactList[i].Id; //must CREATE() user with Contact Id.....
			userList.Add(tu);
		}
		system.runAs(adminUser){			//avoid mixed DML pain and suffering
			insert userList;
		}
		//Need to make sure that at least one user has the customer admin permission set....
		PermissionSet PS = [SELECT Id, Name FROM PermissionSet
							WHERE Name = 'myKVH_Customer_Admin' LIMIT 1];
		PermissionSetAssignment PSA = new PermissionSetAssignment(PermissionSetId = PS.Id, AssigneeId=userList[0].Id);
		
		system.runAs(adminUser){			//avoid mixed DML pain and suffering
			insert PSA;
		}
		//Need Account Sharing for at least one User...
		list<AccountShare> sharesToCreate = new list<AccountShare>();
		for (User u : userList){
			for(Account a : testAccountList){
				AccountShare newShare = new AccountShare();
				newShare.UserOrGroupId = u.id;
				newShare.AccountId = a.Id;
				newShare.CaseAccessLevel = 'Read';
				newShare.AccountAccessLevel = 'Read';
				newShare.OpportunityAccessLevel = 'Read';
				sharesToCreate.add(newShare);
			}
		}
		insert sharesToCreate;
		
    }
	static testMethod void test_setupData(){	//makes sure that the test data was setup correctly
		List<user> portalUsers = [SELECT Id, username, ContactId, Contact.AccountId FROM User WHERE username LIKE '%Admin.testUser@mock.user' AND ContactId != null];
		system.assertEquals(MAX_LOOP_COUNTER, portalUsers.size());
		test.startTest();
		system.runAs(portalUsers[0]){
			PageReference pageRef = Page.myKVH_add_new_User;
			Test.setCurrentPage(pageRef);
			myKVH_add_new_User_ctrlEXT ctrl1 = new myKVH_add_new_User_ctrlEXT(); 
			system.debug(ctrl1.RawHierarchy);
			system.assertEquals(3, ctrl1.RawHierarchy.size());
			system.debug(ctrl1.myKVHHierarchy);
			system.assertEquals(3, ctrl1.myKVHHierarchy.size());		//includes Platforms now...
		}
		test.stopTest(); 
	}
	static testMethod void testassignRoleAndProfile(){
		List<user> portalUsers = [SELECT Id, username, ContactId, myKVH_Role__c, ProfileId, Contact.AccountId FROM User WHERE username LIKE '%Admin.testUser@mock.user' AND ContactId != null];
		system.assertEquals(MAX_LOOP_COUNTER, portalUsers.size());
		system.assertNotequals(portalUsers[0].Contact.AccountId, portalUsers[1].Contact.AccountId);
		Account testAcct = [SELECT Id, RecordTypeId FROM Account WHERE Id =: portalUsers[1].Contact.AccountId LIMIT 1];
		test.startTest();
		system.runAs(portalUsers[0]){													//Do Portal user first
			myKVH_add_new_User_ctrlEXT ctrl1 = new myKVH_add_new_User_ctrlEXT();
			User returnedUser = ctrl1.assignRoleAndProfile(portalUsers[1], portalUsers[0]);	//portalUsers[0] is current User 
			system.assertEquals(portalUsers[1], returnedUser);
			system.assertEquals(portalUsers[1].myKVH_Role__c, returnedUser.myKVH_Role__c);
			system.assertEquals(portalUsers[1].ProfileId, returnedUser.ProfileId);
		}		
		
		testAcct.RecordTypeId = Platform_RECORD_TYPE_ID;		//shipboard User
		update testAcct;
		Profile PortalProf = new Profile();
		list<profile> PortalProfs = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Portal%' ];
		myKVH_Role__c mockRole2 = new myKVH_Role__c();
		mockRole2.name = 'mockRole2';
		insert mockRole2;
		system.runAs(portalUsers[0]){													//Do Portal user first
			myKVH_add_new_User_ctrlEXT ctrl1 = new myKVH_add_new_User_ctrlEXT();
			portalUsers[2].myKVH_Role__c = mockRole2.Id;
			portalUsers[2].ProfileId = PortalProfs[2].Id;
			User returnedUser = ctrl1.assignRoleAndProfile(portalUsers[2], portalUsers[0]);	//portalUsers[0] is current User
			system.assertEquals(portalUsers[2], returnedUser);
			system.assertEquals(portalUsers[2].myKVH_Role__c, returnedUser.myKVH_Role__c);
			system.assertEquals(portalUsers[2].ProfileId, returnedUser.ProfileId);
		}
		test.stopTest();
	}
	
	static testMethod void testIndirectRoleAndProfile(){
		myKVH_new_User_Defaults__c indirectSettings = myKVH_new_User_Defaults__c.getValues('CustomerOfServiceProviderDefaults');
		List<user> portalUsers = [SELECT Id, username, myKVH_Role__c, ProfileId, ContactId, Contact.AccountId FROM User WHERE username LIKE '%Admin.testUser@mock.user' AND ContactId != null];
		Account testIndirect = new Account(Name = 'myKVH_User_Admin_Controller Test Indirect Account', RecordTypeId = IndirectCust_RECORD_TYPE_ID);
		insert testIndirect;
		system.debug('indirectID: ' + testIndirect.Id);
		Contact testIndirectContact = new Contact(FirstName = 'Indirect', LastName = 'Contact', Email = 'IndirectAccount.testContact@mock.user', AccountId = testIndirect.Id);
		insert testIndirectContact;
		system.debug('indirectContact: ' + testIndirectContact);
		list<profile> PortalProfs = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Portal%' ];
		//Convert Contact to Portal User
		list<User> userList = new list<User>();
		
		User tu = new User();
		tu.username = 'IndirectAccount.testContact@mock.user';
		tu.LastName = 'User1';
		tu.Email = 'IndirectAccount.testContact@mock.user';
		tu.Alias = 'AccAdm';
		tu.TimeZoneSidKey = 'America/New_York';
		tu.LocaleSidKey = 'en_US';
		tu.EmailEncodingKey = 'ISO-8859-1';
		tu.ProfileId = portalUsers[0].ProfileId;
		tu.myKVH_Role__c = portalUsers[0].myKVH_Role__c;
		tu.LanguageLocaleKey = 'en_US';
		tu.ContactId = testIndirectContact.Id; //must CREATE() user with Contact Id.....
	
		system.runAs(adminUser){			//avoid mixed DML pain and suffering
			insert tu;
		}
		tu = [SELECT Id, username, ContactId, ProfileId, myKVH_Role__c,  Contact.AccountId, Contact.Account.RecordTypeID, Contact.Account.RecordType.DeveloperName
				FROM User WHERE Id =: tu.Id LIMIT 1];	//need ALL that User detail...
		test.startTest();
			//Do Portal user first
			myKVH_add_new_User_ctrlEXT ctrl1 = new myKVH_add_new_User_ctrlEXT();
			system.assertNotEquals(tu.myKVH_Role__c, indirectSettings.myKVH_Role_Id__c);
			system.assertNotEquals(tu.ProfileId, indirectSettings.SF_Profile_Id__c);
			User returnedUser = ctrl1.assignRoleAndProfile(tu, portalUsers[0]);	//portalUsers[0] is current User
			system.assertEquals(tu, returnedUser);
			system.assertEquals(returnedUser.myKVH_Role__c, indirectSettings.myKVH_Role_Id__c);
			system.assertEquals(returnedUser.ProfileId, indirectSettings.SF_Profile_Id__c);
		
		test.stopTest();
	}
	static testMethod void testShipboardUser(){
		myKVH_new_User_Defaults__c indirectSettings = myKVH_new_User_Defaults__c.getValues('CustomerOfServiceProviderDefaults');
		List<user> portalUsers = [SELECT Id, username, myKVH_Role__c, ProfileId, ContactId, Contact.AccountId FROM User WHERE username LIKE '%Admin.testUser@mock.user' AND ContactId != null];
		Account testPlatform = new Account(Name = 'myKVH_User_Admin_Controller Test Indirect Account', RecordTypeId = Platform_RECORD_TYPE_ID);
		insert testPlatform;
		system.debug('PlatformID: ' + testPlatform.Id);
		Contact testPlatformContact = new Contact(FirstName = 'Indirect', LastName = 'Contact', Email = 'PlatformAccount.testContact@mock.user', AccountId = testPlatform.Id);
		insert testPlatformContact;
		system.debug('PlatformContact: ' + testPlatformContact);
		list<profile> PortalProfs = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Portal%' ];
		//Convert Contact to Portal User
		list<User> userList = new list<User>();
		
		User tu = new User();
		tu.username = 'IndirectAccount.testContact@mock.user';
		tu.LastName = 'User1';
		tu.Email = 'IndirectAccount.testContact@mock.user';
		tu.Alias = 'AccAdm';
		tu.TimeZoneSidKey = 'America/New_York';
		tu.LocaleSidKey = 'en_US';
		tu.EmailEncodingKey = 'ISO-8859-1';
		tu.ProfileId = portalUsers[0].ProfileId;
		tu.myKVH_Role__c = portalUsers[0].myKVH_Role__c;
		tu.LanguageLocaleKey = 'en_US';
		tu.ContactId = testPlatformContact.Id; //must CREATE() user with Contact Id.....
	
		system.runAs(adminUser){			//avoid mixed DML pain and suffering
			insert tu;
		}
		tu = [SELECT Id, username, ContactId, ProfileId, myKVH_Role__c,  Contact.AccountId, Contact.Account.RecordTypeID, Contact.Account.RecordType.DeveloperName
				FROM User WHERE Id =: tu.Id LIMIT 1];	//need ALL that User detail...
		test.startTest();
			//Do Portal user first.. no indirect Ancestors, so should match Current User!
			myKVH_add_new_User_ctrlEXT ctrl1 = new myKVH_add_new_User_ctrlEXT();
			system.assertNotEquals(tu.myKVH_Role__c, indirectSettings.myKVH_Role_Id__c);
			system.assertNotEquals(tu.ProfileId, indirectSettings.SF_Profile_Id__c);
			User returnedUser = ctrl1.assignRoleAndProfile(tu, portalUsers[0]);	//portalUsers[0] is current User
			system.assertEquals(tu, returnedUser);
			system.assertEquals(returnedUser.myKVH_Role__c, portalUsers[0].myKVH_Role__c);
			system.assertEquals(returnedUser.ProfileId, portalUsers[0].ProfileId);
		
		test.stopTest();
	}
	static testMethod void testShipboardUser2(){
		myKVH_new_User_Defaults__c indirectSettings = myKVH_new_User_Defaults__c.getValues('CustomerOfServiceProviderDefaults');
		List<user> portalUsers = [SELECT Id, username, myKVH_Role__c, ProfileId, ContactId, Contact.AccountId FROM User WHERE username LIKE '%Admin.testUser@mock.user' AND ContactId != null];
		list<Account> insertList = new list<Account>();
		Account testPlatform = new Account(Name = 'myKVH_User_Admin_Controller Test Platform Account', RecordTypeId = Platform_RECORD_TYPE_ID);	//need a Platform
		insertList.add(testPlatform);
		Account testIndirect = new Account(Name = 'myKVH_User_Admin_Controller Test Indirect Account', RecordTypeId = IndirectCust_RECORD_TYPE_ID);	//need an indirect
		insertList.add(testIndirect);
		insert insertList;
		testPlatform.ParentId = testIndirect.Id;
		update testPlatform;
		system.debug('Platform.Id: ' + testPlatform.Id + ' Platform.ParentId: ' + testPlatform.ParentId);
		Contact testPlatformContact = new Contact(FirstName = 'Indirect', LastName = 'Contact', Email = 'PlatformAccount.testContact@mock.user', AccountId = testPlatform.Id);
		insert testPlatformContact;
		system.debug('indirectContact: ' + testPlatformContact);
		list<profile> PortalProfs = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Portal%' ];
		//Convert Contact to Portal User
		list<User> userList = new list<User>();
		
		User tu = new User();
		tu.username = 'IndirectAccount.testContact@mock.user';
		tu.LastName = 'User1';
		tu.Email = 'IndirectAccount.testContact@mock.user';
		tu.Alias = 'AccAdm';
		tu.TimeZoneSidKey = 'America/New_York';
		tu.LocaleSidKey = 'en_US';
		tu.EmailEncodingKey = 'ISO-8859-1';
		tu.ProfileId = portalUsers[0].ProfileId;
		tu.myKVH_Role__c = portalUsers[0].myKVH_Role__c;
		tu.LanguageLocaleKey = 'en_US';
		tu.ContactId = testPlatformContact.Id; //must CREATE() user with Contact Id.....
	
		system.runAs(adminUser){			//avoid mixed DML pain and suffering
			insert tu;
		}
		tu = [SELECT Id, username, ContactId, ProfileId, myKVH_Role__c,  Contact.AccountId, Contact.Account.RecordTypeID, Contact.Account.RecordType.DeveloperName
				FROM User WHERE Id =: tu.Id LIMIT 1];	//need ALL that User detail...
		test.startTest();
			//Do Portal user first.. no indirect Ancestors, so should match Current User!
			myKVH_add_new_User_ctrlEXT ctrl1 = new myKVH_add_new_User_ctrlEXT();
			system.assertNotEquals(tu.myKVH_Role__c, indirectSettings.myKVH_Role_Id__c);
			system.assertNotEquals(tu.ProfileId, indirectSettings.SF_Profile_Id__c);
			User returnedUser = ctrl1.assignRoleAndProfile(tu, portalUsers[0]);	//portalUsers[0] is current User
			system.assertEquals(tu, returnedUser);
			system.assertEquals(returnedUser.myKVH_Role__c, indirectSettings.myKVH_Role_Id__c);
			system.assertEquals(returnedUser.ProfileId, indirectSettings.SF_Profile_Id__c);
		
		test.stopTest();
	}
	static testMethod void testShipboardUser3(){
		myKVH_new_User_Defaults__c indirectSettings = myKVH_new_User_Defaults__c.getValues('CustomerOfServiceProviderDefaults');
		List<user> portalUsers = [SELECT Id, username, myKVH_Role__c, ProfileId, ContactId, Contact.AccountId FROM User WHERE username LIKE '%Admin.testUser@mock.user' AND ContactId != null];
		list<Account> insertList = new list<Account>();
		Account testPlatform = new Account(Name = 'myKVH_User_Admin_Controller Test Platform Account', RecordTypeId = Platform_RECORD_TYPE_ID);	//need a Platform
		insertList.add(testPlatform);
		Account testIndirectParent = new Account(Name = 'myKVH_User_Admin_Controller Test Indirect Account', RecordTypeId = IndirectCust_RECORD_TYPE_ID);	//need an indirect
		insertList.add(testIndirectParent);
		Account testIndirectGrandParent = new Account(Name = 'myKVH_User_Admin_Controller Test Indirect Account', RecordTypeId = IndirectCust_RECORD_TYPE_ID);	//need an indirect
		insertList.add(testIndirectGrandParent);
		insert insertList;
		insertList.clear();
		testPlatform.ParentId = testIndirectParent.Id;
		insertList.add(testPlatform);
		testIndirectParent.parentId = testIndirectGrandParent.Id;
		insertList.add(testIndirectParent);
		update insertList;
		system.debug('Platform.Id: ' + testPlatform.Id + ' Platform.ParentId: ' + testPlatform.ParentId);
		Contact testPlatformContact = new Contact(FirstName = 'Indirect', LastName = 'Contact', Email = 'PlatformAccount.testContact@mock.user', AccountId = testPlatform.Id);
		insert testPlatformContact;
		system.debug('indirectContact: ' + testPlatformContact);
		list<profile> PortalProfs = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Portal%' ];
		//Convert Contact to Portal User
		list<User> userList = new list<User>();
		
		User tu = new User();
		tu.username = 'IndirectAccount.testContact@mock.user';
		tu.LastName = 'User1';
		tu.Email = 'IndirectAccount.testContact@mock.user';
		tu.Alias = 'AccAdm';
		tu.TimeZoneSidKey = 'America/New_York';
		tu.LocaleSidKey = 'en_US';
		tu.EmailEncodingKey = 'ISO-8859-1';
		tu.ProfileId = portalUsers[0].ProfileId;
		tu.myKVH_Role__c = portalUsers[0].myKVH_Role__c;
		tu.LanguageLocaleKey = 'en_US';
		tu.ContactId = testPlatformContact.Id; //must CREATE() user with Contact Id.....
	
		system.runAs(adminUser){			//avoid mixed DML pain and suffering
			insert tu;
		}
		tu = [SELECT Id, username, ContactId, ProfileId, myKVH_Role__c,  Contact.AccountId, Contact.Account.RecordTypeID, Contact.Account.RecordType.DeveloperName
				FROM User WHERE Id =: tu.Id LIMIT 1];	//need ALL that User detail...
		test.startTest();
			//Do Portal user first.. no indirect Ancestors, so should match Current User!
			myKVH_add_new_User_ctrlEXT ctrl1 = new myKVH_add_new_User_ctrlEXT();
			system.assertNotEquals(tu.myKVH_Role__c, indirectSettings.myKVH_Role_Id__c);
			system.assertNotEquals(tu.ProfileId, indirectSettings.SF_Profile_Id__c);
			User returnedUser = ctrl1.assignRoleAndProfile(tu, portalUsers[0]);	//portalUsers[0] is current User
			system.assertEquals(tu, returnedUser);
			system.assertEquals(returnedUser.myKVH_Role__c, indirectSettings.myKVH_Role_Id__c);
			system.assertEquals(returnedUser.ProfileId, indirectSettings.SF_Profile_Id__c);
		
		test.stopTest();
	}
	static testMethod void testConstructor(){
		system.debug('TEST!');
		List<user> portalUsers = [SELECT Id, username, ContactId, Contact.AccountId FROM User WHERE username LIKE '%Admin.testUser@mock.user' AND ContactId != null];
		test.startTest();
		system.runAs(portalUsers[0]){													//Do Portal user first
			PageReference pageRef = Page.myKVH_add_new_User;
			Test.setCurrentPage(pageRef);
			myKVH_add_new_User_ctrlEXT ctrl1 = new myKVH_add_new_User_ctrlEXT();
			system.assertEquals(portalUsers[0].Contact.AccountId, ctrl1.currentUser.Contact.AccountId);
			ctrl1.myKVHContact.email__c = '1AccountAdmin.testContact@mock.user';
			ctrl1.searchUsers();
		}		
		test.stopTest();
	}
	static testMethod void test1Getter(){
		list<User> testListGetter = new list<User>();
		myKVH_add_new_User_ctrlEXT ctrl1 = new myKVH_add_new_User_ctrlEXT();
		testListGetter = ctrl1.getFoundUsers();
	}
	static testMethod void testCreateCase(){
		List<user> portalUsers = [SELECT Id, username, ContactId, Contact.AccountId FROM User WHERE username LIKE '%Admin.testUser@mock.user' AND ContactId != null];
		test.startTest();
		string testCaseID;
		system.runAs(portalUsers[0]){													//Do Portal user first
			myKVH_add_new_User_ctrlEXT ctrl1 = new myKVH_add_new_User_ctrlEXT();
			testCaseID = ctrl1.testCreateCase('Case Created in Test Class');	//Call private method test helper
		}
		list<Case> caseList = [SELECT Id, Subject, CaseNumber FROM Case];			//Query results.... 
		system.assertEquals(1, caseList.size());									//should only be one...
		system.assertEquals(testCaseId, caseList[0].Id);				//with this Case number...
		system.assertEquals('Case Created in Test Class', caseList[0].Subject.right(26));		//And this subject!!
		test.stopTest();
	}
	static testMethod void testDuplicateUsers(){
		List<user> portalUsers = [SELECT Id, username, lastName, firstName, ContactId, Contact.AccountId FROM User WHERE username LIKE '%Admin.testUser@mock.user' AND ContactId != null];
		User runningUser = portalUsers[0];
		portalUsers.remove(0);
		test.startTest();
		system.runAs(runningUser){													//Do Portal user first
			PageReference pageRef = Page.myKVH_add_new_User;
			Test.setCurrentPage(pageRef);
			myKVH_add_new_User_ctrlEXT ctrl1 = new myKVH_add_new_User_ctrlEXT();
			ctrl1.foundUsers = portalUsers.deepClone(true, true, true);
			system.assertEquals(MAX_LOOP_COUNTER-1, ctrl1.foundUsers.size());
			ctrl1.foundUsers[0].username = ctrl1.foundUsers[1].username;
			ctrl1.analyzeFoundUsers();
			system.assertEquals(true, ctrl1.gethasErrors());
		}
		test.stopTest();
	}
	static testMethod void testSingleFoundUser(){
		List<user> portalUsers = [SELECT Id, username, lastName, firstName, ContactId, Contact.AccountId FROM User WHERE username LIKE '%Admin.testUser@mock.user' AND ContactId != null];
		User runningUser0 = portalUsers[0];
		User runningUser1 = portalUsers[1];
		
		test.startTest();
		system.runAs(runningUser0){													//Grandparent Account 
			PageReference pageRef = Page.myKVH_add_new_User;
			Test.setCurrentPage(pageRef);
			myKVH_add_new_User_ctrlEXT ctrl1 = new myKVH_add_new_User_ctrlEXT();
			ctrl1.foundUsers.add(portalUsers[2]);									//peer user
			ctrl1.analyzeFoundUsers();
			system.assertEquals(true, ctrl1.gethasErrors());
			system.assertEquals(portalUsers[2].id, ctrl1.newUser.Id);
		}
		system.runAs(runningUser1){													//Parent Account 
			PageReference pageRef = Page.myKVH_add_new_User;
			Test.setCurrentPage(pageRef);
			myKVH_add_new_User_ctrlEXT ctrl1 = new myKVH_add_new_User_ctrlEXT();
			ctrl1.foundUsers.add(portalUsers[2]);									//out of bounds user
			ctrl1.analyzeFoundUsers();
			system.assertEquals(true, ctrl1.gethasErrors());
			system.assertEquals(null, ctrl1.newUser.Id);
		}
		test.stopTest();
	}
	static testMethod void testSearchContacts(){
		List<user> portalUsers = [SELECT Id, username, lastName, firstName, ContactId, Contact.AccountId FROM User WHERE username LIKE '%Admin.testUser@mock.user' AND ContactId != null];
		User runningUser0 = portalUsers[0];		//Grandparent Account
		User runningUser1 = portalUsers[1];		//Parent Account
		test.startTest();
		system.runAs(runningUser0){													//Grandparent Account 
			PageReference pageRef = Page.myKVH_add_new_User;
			Test.setCurrentPage(pageRef);
			myKVH_add_new_User_ctrlEXT ctrl1 = new myKVH_add_new_User_ctrlEXT();
			ctrl1.myKVHContact.email__c = 'wrong@e.,mail';
			ctrl1.searchContacts();
			system.assertEquals(true, ctrl1.searchCompleted);
			
			ctrl1.myKVHContact.email__c = '2AccountAdmin.testContact@mock.user';
			ctrl1.searchContacts();
			system.assertEquals(true, ctrl1.searchCompleted);
			system.assertEquals(false, ctrl1.gethasErrors());
		}
		
		system.runAs(runningUser1){													//parent Account 
			PageReference pageRef = Page.myKVH_add_new_User;
			Test.setCurrentPage(pageRef);
			myKVH_add_new_User_ctrlEXT ctrl1 = new myKVH_add_new_User_ctrlEXT();
			ctrl1.myKVHContact.email__c = 'wrong@e.,mail';
			ctrl1.searchContacts();
			system.assertEquals(true, ctrl1.searchCompleted);
			
			ctrl1.myKVHContact.email__c = '2AccountAdmin.testContact@mock.user';		//out of bounds contact
			ctrl1.searchContacts();
			system.assertEquals(true, ctrl1.searchCompleted);
			system.assertEquals(true, ctrl1.gethasErrors());
		}
		test.stopTest();
	}
	static testMethod void testDuplicateContacts(){
		List<User> portalUsers = [SELECT Id, username, lastName, firstName, ContactId, Contact.AccountId FROM User WHERE username LIKE '%Admin.testUser@mock.user' AND ContactId != null];
		User runningUser0 = portalUsers[0];		//Grandparent Account
		User runningUser1 = portalUsers[1];		//Parent Account
		list<Contact> portalContacts = [SELECT Id, email FROM Contact WHERE email LIKE '%AccountAdmin.testContact@mock.user'];
		portalContacts[0].email = portalContacts[1].email;							//now we have a dupe!
		update portalContacts;														//hope this doesn't throw an exception...
		system.debug(portalContacts);
		test.startTest();
		system.runAs(runningUser1){													//Parent Account 
			PageReference pageRef = Page.myKVH_add_new_User;
			Test.setCurrentPage(pageRef);
			myKVH_add_new_User_ctrlEXT ctrl1 = new myKVH_add_new_User_ctrlEXT();
			ctrl1.myKVHContact.email__c = portalContacts[0].email;
			ctrl1.searchContacts();
			
			system.assertEquals(1, ctrl1.foundContacts.size());
			system.assertEquals(true, ctrl1.searchCompleted);
			system.assertEquals(false, ctrl1.gethasErrors());
		}
		//sequence is important here....
		system.runAs(runningUser0){													//Grandparent Account 
			PageReference pageRef = Page.myKVH_add_new_User;
			Test.setCurrentPage(pageRef);
			myKVH_add_new_User_ctrlEXT ctrl1 = new myKVH_add_new_User_ctrlEXT();
			ctrl1.myKVHContact.email__c = portalContacts[0].email;
			ctrl1.searchContacts();
			list<Contact> contList = ctrl1.getfoundContacts();
			system.assertEquals(2, contList.size());
			system.assertEquals(2, ctrl1.foundContacts.size());
			ctrl1.contactId = ((string)contList[0].Id);						//simulate user selection
			ctrl1.contactSelected();
			string testString = ctrl1.testsetSFContact(ctrl1.contactId);
			system.assertEquals('Tested setSFContact',testString);
			Contact c = ctrl1.getSFContact();
			system.assertEquals(c.Id, contList[0].Id);
			system.assertEquals(true, ctrl1.searchCompleted);
			system.assertEquals(false, ctrl1.gethasErrors());						//Page Message severity is WARNING, not FATAL
			ctrl1.createUserFromContact();
		}
		test.stopTest();
		portalUsers.clear();
		portalUsers = [SELECT Id, username, lastName, firstName, ContactId, Contact.AccountId FROM User WHERE username LIKE '%AccountAdmin.testContact@mock.user' AND ContactId != null];
		//system.assertEquals(1, portalUsers.size());
	}
	
	static testMethod void testCreateContact(){
		//Need a Fleet ID and a to popualte some fields
		List<User> portalUsers = [SELECT Id, username, lastName, firstName, ContactId, Contact.AccountId FROM User WHERE username LIKE '%Admin.testUser@mock.user' AND ContactId != null];
		User runningUser0 = portalUsers[0];		//Grandparent Account
		test.startTest();
		system.runAs(runningUser0){													//Grandparent Account 
			PageReference pageRef = Page.myKVH_add_new_User;
			Test.setCurrentPage(pageRef);
			myKVH_add_new_User_ctrlEXT ctrl1 = new myKVH_add_new_User_ctrlEXT();
			ctrl1.myKVHContact.email__c = 'user1@unit.test';
			ctrl1.myKVHContact.First_Name__c = 'FirstName';
			ctrl1.myKVHContact.Last_Name__c = 'LastName';
			ctrl1.FleetId = runningUser0.Contact.AccountId;
			ctrl1.createContactUser();
			list<Contact> readList = new list<Contact>();
			readList = [SELECT Id, email FROM Contact WHERE email = 'user1@unit.test'];
			system.assertEquals(1, readList.size());
			system.assertEquals(readList[0].Id, ctrl1.myKVHContact.Contact__c);				//Should update Activation sObject with reference to Created Contact
			//Create User now...
			User mockUser = ctrl1.createPortalUser(readList[0].Id);
			system.assertEquals(readList[0].email, mockUser.username);
		}
		test.stopTest();
		portalUsers.clear();
		portalUsers = [SELECT Id, username, lastName, firstName, ContactId, Contact.AccountId FROM User WHERE username = 'user1@unit.test' AND ContactId != null];
		system.assertEquals(1, portalUsers.size());
	}
	static testMethod void testNextPrevious(){
		myKVH_add_new_User_ctrlEXT ctrl1 = new myKVH_add_new_User_ctrlEXT();
		ctrl1.foundContacts = new list<Contact>();
		system.assertEquals(1, ctrl1.state);
		ctrl1.next();
		system.assertEquals(3, ctrl1.state);
		ctrl1.next();
		system.assertEquals(4, ctrl1.state);
		ctrl1.next();
		system.assertEquals(5, ctrl1.state);
		ctrl1.next();
		system.assertEquals(5, ctrl1.state);
		ctrl1.prev();
		system.assertEquals(4, ctrl1.state);
		ctrl1.prev();
		system.assertEquals(3, ctrl1.state);
		system.assertEquals(true, ctrl1.saveDisabled);
		ctrl1.prev();
		system.assertEquals(1, ctrl1.state);
		ctrl1.prev();
		system.assertEquals(1, ctrl1.state);
	}
}