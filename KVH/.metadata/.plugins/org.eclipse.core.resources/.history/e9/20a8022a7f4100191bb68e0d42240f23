@isTest
public with sharing class test_myKVH_Role_for_user {
	@testSetup static void testDataSetup(){
		//Need a primary, and an extended Role....
		myKVH_Role__c PrimaryRole1 = new myKVH_Role__c(Name='PrimaryRole1', isRoleExtension__c = false);
		insert PrimaryRole1;
		myKVH_Role__c PrimaryRole2 = new myKVH_Role__c(Name='PrimaryRole2', isRoleExtension__c = false);
		insert PrimaryRole2;
		
		myKVH_Role__c ExtendedRole = new myKVH_Role__c(Name='ExtendedRole', isRoleExtension__c = true);
		insert ExtendedRole;
		
		Account testAcct = new Account(Name = 'testAcct');
        insert testAcct;
		
		Contact testCont1 = new Contact(LastName = 'test1', AccountId = testAcct.Id);
        insert testCont1;

	}
	
	static testMethod void myUnitTest(){
		//invoke user page and controller extension...
		User testUser1 = new User();
		testUser1 = createTestUser();
		ApexPages.StandardController sc = new ApexPages.standardController(testUser1);
		myKVH_role_for_user_ctrlEXT ctrl = new myKVH_role_for_user_ctrlEXT(sc);
		myKVH_Role__c role1, role2 = new myKVH_Role__c();
		role1 = [SELECT id, Name FROM myKVH_Role__c WHERE Name = 'PrimaryRole1' LIMIT 1];
		role2 = [SELECT id, Name FROM myKVH_Role__c WHERE Name = 'PrimaryRole2' LIMIT 1];
		//test for intial role ID value
		system.assertEquals(role1.id, ctrl.getmyKVH_Role_Id());
		
		//make sure that there 3 roles are in the test data
		list<myKVH_Role__c> listOfThree = new list<myKVH_Role__c>();
		listOfThree = [SELECT Id FROM myKVH_Role__c];
		system.assertEquals(3,listOfThree.size());
		
		//test option list setup
		list<SelectOption> list_test = new list<selectoption>();
		list_test = ctrl.getRoles();
		system.assertEquals(2, list_test.size());
		//test set role ID
		

		ctrl.setmyKVH_Role_Id(role2.id);
		system.assertEquals(role2.id, ctrl.getmyKVH_Role_Id());
		//test onclick change....
		ctrl.onClickAction();
		system.assert(ctrl.getDirty());
		system.assertEquals(role2.id, ctrl.myUser.myKVH_Role__c);
		//test save changes
		
		ctrl.saveRoleChanges();
		system.assertEquals(false, ctrl.getDirty());
		user assertionUser = new user();
		assertionUser = [SELECT id, username, myKVH_Role__c FROM User WHERE username = 'testMyKVHRoleForUser99@kvh.com'];
		system.assertEquals(role2.Id, assertionUser.myKVH_Role__c);
		/* // causes System.DmlException: 
			Update failed. First exception on row 0 with id 0051300000BK0cgAAD; 
			first error: MIXED_DML_OPERATION, DML operation on setup object is 
			not permitted after you have updated a non-setup object (or vice versa): 
			User, original object: Account: []
		*/	
	}	
	
		static User createTestUser(){
		
        Account testAcct = [SELECT id, Name FROM Account WHERE Name = 'testAcct'];
        
        
        Contact testCont1 = [SELECT id, Name FROM Contact WHERE LastName = 'test1'];
		
        //Need a Profile.... a PORTAL profile!
        Profile PortalProf = new Profile();
        PortalProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Portal%' Limit 1];
        system.debug(PortalProf);
        
        //Need a myKVH Roles...
        
        myKVH_Role__c role1 = [SELECT id, Name FROM myKVH_Role__c WHERE Name = 'PrimaryRole1' LIMIT 1];
        // testUser1 ... is a Contact
        User testUser1 = new User();
        testUser1.username = 'testMyKVHRoleForUser99@kvh.com';
        testUser1.LastName = 'User1';
		testUser1.Email = 'testMyKVHRoleForUser99@kvh.com';
		testUser1.Alias = 'tuser1';
		testUser1.TimeZoneSidKey = 'America/New_York';
		testUser1.LocaleSidKey = 'en_US';
		testUser1.EmailEncodingKey = 'ISO-8859-1';
		testUser1.ProfileId = PortalProf.id;
		testUser1.LanguageLocaleKey = 'en_US';
		testUser1.ContactId = testCont1.Id; //must CREATE() user with Contact Id.....
		testUser1.myKVH_Role__c = role1.Id;
        insert testUser1;
        testUser1 = [SELECT id, username, myKVH_Role__c FROM User WHERE username = 'testMyKVHRoleForUser99@kvh.com'];
        return testUser1;
	}

}