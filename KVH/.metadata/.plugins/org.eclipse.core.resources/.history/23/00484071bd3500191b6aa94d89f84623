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
private class REST_users_V4_test {
//Going to need... Accounts, Contact, Users
	// Platforms, shared Platforms
	// myKVH Roles, extended Roles
	/* Get the metadata first... */
	private static final Id Platform_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Demo/Test/Monitor').getRecordTypeId();
	private static final Profile PortalProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Portal%' Limit 1];
	private static final Profile ChatterFree = [SELECT Id, Name FROM Profile WHERE Name LIKE 'Chatter Free%' Limit 1];
	private static final Profile NOTPortalProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Standard%' Limit 1];
	private static final User adminUser = [SELECT Id, username FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
	@testSetup static void testDataSetup(){
		//Insert a Test User
		//Need a contact and account..
        //Need to create a couple of Accounts
    	List<Account> testAcctList = new List<Account>();
    	for (integer i = 0; i < 4; i++){
    		Account a = new Account();
    		a.Name = 'Test Account ' + i;
    		a.BillingCountry = 'Spain';     //rhymes with "Pain"....
    		testAcctList.add(a); 
    		system.debug(testAcctList);
    	}
    	insert testAcctList;
    	//Convert a couple to Platforms
    	testAcctList[1].RecordTypeId = Platform_RECORD_TYPE_ID;
    	testAcctList[1].Name = 'Test Platform 1';
    	testAcctList[1].myKVH_Element_Count__c = 1;
    	testAcctList[3].RecordTypeId = Platform_RECORD_TYPE_ID;
    	testAcctList[3].Name = 'Test Platform 3';
    	testAcctList[3].myKVH_Element_Count__c = 1;
    	update testAcctList;
    	
    	//Need a custom setting....
    	DefaultAccounts__c def = new DefaultAccounts__c();
    	def.Name = 'KVH_Official_Internal_Contacts';
    	def.Account_ID__c = testAcctList[2].Id;
    	def.Description__c = 'test description';
    	insert def;
        
        //Need a couple of myKVH Roles, one primary, one extended
        myKVH_Role__c primaryRole = new myKVH_Role__c(name = 'PrimaryRole');
        myKVH_Role__c extendedRole = new myKVH_Role__c(name = 'extendedRole', isRoleExtension__c = true);
        myKVH_Role__c extendedRole2 = new myKVH_Role__c(name = 'extendedRole2', isRoleExtension__c = true);
        insert primaryRole;
        insert extendedRole;
        insert extendedRole2;
        
        Contact testCont1 = new Contact(LastName = 'test1', AccountId = testAcctList[0].Id);
        insert testCont1;
        
        Contact testCont2 = new Contact(LastName = 'test2', AccountId = testAcctList[1].Id);
        insert testCont2;
        //	testCont1 = [SELECT id, Name FROM Contact WHERE LastName = 'test1'];
		// testUser1 ... is a Contact
		User testUser1 = new User();
		testUser1.username = 'restapi.testUser1@kvh.com';
		testUser1.LastName = 'User1';
		testUser1.Email = 'restapi.testUser1@kvh.com';
		testUser1.Alias = 'tuser1';
		testUser1.TimeZoneSidKey = 'America/New_York';
		testUser1.LocaleSidKey = 'en_US';
		testUser1.EmailEncodingKey = 'ISO-8859-1';
		testUser1.ProfileId = PortalProf.id;
		testUser1.LanguageLocaleKey = 'en_US';
		testUser1.ContactId = testCont1.Id; //must CREATE() user with Contact Id.....
		testUser1.myKVH_Role__c = primaryRole.Id;
		
		// testUser2 ... is a Chatter Free
        User testUserX = new User();
        testUserX.username = 'restapi.testUserX@kvh.com';
        testUserX.LastName = 'UserX';
        testUserX.Email = 'restapi.testUserX@kvh.com';
        testUserX.Alias = 'tuserX';
        testUserX.TimeZoneSidKey = 'America/New_York';
        testUserX.LocaleSidKey = 'en_US';
        testUserX.EmailEncodingKey = 'ISO-8859-1';
        testUserX.ProfileId = ChatterFree.id;
        testUserX.LanguageLocaleKey = 'en_US';
        testUserX.myKVH_Role__c = primaryRole.Id;
        
		test.startTest();
		system.runAs(adminUser){			//avoid that mixed DML pain and suffering
			insert testUser1;
			insert testUserX;
		}
		test.stopTest();
	}

    static testMethod void test_REST_users_V4() {
		string instance = ''; //empty string to replace instance....
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		list<REST_users_V4.myKVH_User2> userList = new list<REST_users_V4.myKVH_User2>();
		//list<User> UserList = new List<User>();
		
		User testUser1 = [SELECT id, username, Email FROM User WHERE username = 'restapi.testUser1@kvh.com' LIMIT 1];
		//test with an accurate User Id....
		UserList.clear();					//reset
		req.requestURI = instance + 'salesforce.com/services/apexrest/V4/users/' + testUser1.Id;  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		userList = REST_users_V4.doGet();
		system.assertEquals(1, userList.size());
		//system.assertEquals((string)PortalProf.id, userList[0].getmyKVHUser().Profile_Id);
		//test that there are no Role Extensions or Platform Shares 
		list<myKVH_Role__c> roleList = userList[0].getRoleExtensions();
		system.assertEquals(0, roleList.size());
		list<myKVH_Shared_Platforms__c> platShareList = userList[0].getPlatformShares();
		system.assertEquals(0, platShareList.size());
		
		//test with a bogus User Id....
		UserList.clear();					//reset
		req.requestURI = instance + 'salesforce.com/services/apexrest/V4/users/005000000000000';
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		userList = REST_users_V4.doGet();
		system.assertEquals(0, userList.size());
		
		//test with a realistic e-mail
		UserList.clear();					//reset
		req.requestURI = instance + 'salesforce.com/services/apexrest/V4/users/search';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		req.addParameter('email', 'restapi.testUser1@kvh.com');
		RestContext.response = res;
		userList = REST_users_V4.doGet();
		system.assertEquals(1, userList.size());
		system.assertEquals(PortalProf.id, userList[0].Profile_Id); 
		
		//test with a bogus e-mail
		UserList.clear();					//reset
		req.requestURI = instance + 'salesforce.com/services/apexrest/V4/users/search';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		req.addParameter('email', 'notatestUser1@kvh.com');
		RestContext.response = res;
		userList = REST_users_V4.doGet();
		system.assertEquals(0, userList.size());
		
		//test with no identifier
		UserList.clear();					//reset
		req.requestURI = instance + 'salesforce.com/services/apexrest/V4/users';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		userList = REST_users_V4.doGet();
		system.assertEquals(0, userList.size());
		system.assertEquals(400, res.statuscode);

		//test with duplicate E-mail
		//need another test user...
		// testUser2... is NOT a contact
		User testUser2 = new User();
		testUser2.username = 'restapi.testUser2@kvh.com';
		testUser2.LastName = 'User2';
		testUser2.Email = 'restapi.testUser1@kvh.com';	//deliberate duplicate e-mail
		testUser2.Alias = 'tuser2';
		testUser2.TimeZoneSidKey = 'America/New_York';
		testUser2.LocaleSidKey = 'en_US';
		testUser2.EmailEncodingKey = 'ISO-8859-1';
		testUser2.ProfileId = NOTPortalProf.id;  
		testUser2.LanguageLocaleKey = 'en_US';
		insert testUser2;
		testUser2 = [SELECT id, username, Email FROM User WHERE username = 'restapi.testUser2@kvh.com'];
		//Test Data mostly all set!
		
		UserList.clear();					//reset
		req.requestURI = instance + 'salesforce.com/services/apexrest/V4/users/search';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		req.addParameter('email', 'restapi.testUser1@kvh.com');
		RestContext.response = res;
		userList = REST_users_V4.doGet();
		system.assertEquals(2, userList.size());
		system.assertEquals(300, res.statuscode);
		
		//toss in 2 Extended Roles and 2 Platform Shares in there...
		system.runAs(testUser2){									//run as test user to avoid mixed DML exception
			Account sharePlat = [SELECT Id, Account.RecordTypeId, Account.RecordType.DeveloperName, Send_to_myKVH_Physical__c FROM Account WHERE Name = 'Test Platform 1' LIMIT 1];
			myKVH_Shared_Platforms__c testSharePlat = new myKVH_Shared_Platforms__c();
			testSharePlat.User__c = testUser1.Id;
			testSharePlat.Shared_Platform__c = sharePlat.Id;
			system.debug('Platform to be Shared: ' + sharePlat);
			insert testSharePlat;
			system.debug('Shared Platform: ' + testSharePlat);
			
			Account sharePlat3 = [SELECT Id, Account.RecordTypeId, Account.RecordType.DeveloperName, Send_to_myKVH_Physical__c FROM Account WHERE Name = 'Test Platform 3' LIMIT 1];
			myKVH_Shared_Platforms__c testSharePlat3 = new myKVH_Shared_Platforms__c();
			testSharePlat3.User__c = testUser1.Id;
			testSharePlat3.Shared_Platform__c = sharePlat3.Id;
			system.debug('Platform to be Shared: ' + sharePlat3);
			insert testSharePlat3;
			system.debug('Shared Platform: ' + testSharePlat3);
			
			myKVH_Role__c testExtRole = [SELECT Id FROM myKVH_Role__c WHERE name = 'extendedRole' LIMIT 1];
			myKVH_User_Role_Extension__c testUserRoleExt = new myKVH_User_Role_Extension__c();
			testUserRoleExt.User__c =  testUser1.Id;
			testUserRoleExt.ExtendedRole__c = testExtRole.Id;
			insert testUserRoleExt;
			
			myKVH_Role__c testExtRole2 = [SELECT Id FROM myKVH_Role__c WHERE name = 'extendedRole2' LIMIT 1];
			myKVH_User_Role_Extension__c testUserRoleExt2 = new myKVH_User_Role_Extension__c();
			testUserRoleExt2.User__c =  testUser1.Id;
			testUserRoleExt2.ExtendedRole__c = testExtRole2.Id;
			insert testUserRoleExt2;
		}
		
		//test with an accurate User Id....
		UserList.clear();					//reset
		roleList = new list<myKVH_Role__c>();
		platShareList = new list<myKVH_Shared_Platforms__c>();
		req.requestURI = instance + 'salesforce.com/services/apexrest/V4/users/' + testUser1.Id;  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		userList = REST_users_V4.doGet();
		system.assertEquals(1, userList.size());
		system.assertEquals(PortalProf.id, userList[0].Profile_Id);
		//test that there are indeed Role Extensions or Platform Shares 
		roleList = userList[0].getRoleExtensions();
		system.assertEquals(2,roleList.size());
		//system.assertEquals(testExtRole.Id, roleList[0].Id);						//list sequence could break this...
		platShareList = userList[0].getPlatformShares();
		system.assertEquals(2,platShareList.size());
		//system.assertEquals(sharePlat.Id, platShareList[0].Shared_Platform__c);	//list sequence could break this...
		
		// test with uas__User__c value...
		system.runAs(adminUser){
		    Contact readContact = [SELECT Id, LastName, uas__User__c FROM Contact WHERE LastName = 'test2' LIMIT 1];
            readContact.uas__User__c = testUser2.Id;
            update readContact;
		}
		
		UserList.clear();					//reset
		roleList = new list<myKVH_Role__c>();
		platShareList = new list<myKVH_Shared_Platforms__c>();
		req.requestURI = instance + 'salesforce.com/services/apexrest/V4/users/' + testUser2.Id;  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		userList = REST_users_V4.doGet();
		system.assertEquals(1, userList.size());
		system.assertNotEquals(PortalProf.id, userList[0].Profile_Id);
		Account readAcct = [SELECT Id, Name FROM Account WHERE Name = 'Test Platform 1' LIMIT 1];
		system.assertEquals(readAcct.Id, userList[0].Contact_AccountId); 
    }
    static testMethod void test_ChatterFreeUser(){
        string instance = ''; //empty string to replace instance....
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        list<REST_users_V4.myKVH_User2> userList = new list<REST_users_V4.myKVH_User2>();
        //list<User> UserList = new List<User>();
        
        User testUserX = [SELECT id, username, Email FROM User WHERE username = 'restapi.testUserX@kvh.com' LIMIT 1];
        //test with an accurate User Id....
        system.assertEquals('restapi.testuserx@kvh.com', testUserX.username);
        UserList.clear();                   //reset
        req.requestURI = instance + 'salesforce.com/services/apexrest/V4/users/' + testUserX.Id;  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        userList = REST_users_V4.doGet();
        system.assertEquals(1, userList.size());
        //system.assertEquals((string)PortalProf.id, userList[0].getmyKVHUser().Profile_Id);
        //test that there are no Role Extensions or Platform Shares 
        list<myKVH_Role__c> roleList = userList[0].getRoleExtensions();
        system.assertEquals(0, roleList.size());
        list<myKVH_Shared_Platforms__c> platShareList = userList[0].getPlatformShares();
        system.assertEquals(0, platShareList.size());
    }
}