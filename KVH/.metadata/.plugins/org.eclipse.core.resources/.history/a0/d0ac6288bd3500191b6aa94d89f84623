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
private class test_myKVH_Role_Extensions_Utilities {
	static integer MAX_LOOP_COUNTER = 50;
	// Need Users, Role Extensions, 
	@testSetup static void setupTestData(){
		//Need a NOT a PORTAL profile...
		Profile NOTPortalProf = new Profile();
		NOTPortalProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Standard%' Limit 1];
		
		list<User> userList = new list<User>();
		for(integer i = 0; i<MAX_LOOP_COUNTER; i++){
			User u = new User();
			u.username = i + 'UREExt.testUser1@kvh.com';
			u.LastName = i + 'User';
			u.Email = i + 'UREExt.testUser1@kvh.com';
			u.Alias = i + 'tuser1';
			u.TimeZoneSidKey = 'America/New_York';
			u.LocaleSidKey = 'en_US';
			u.EmailEncodingKey = 'ISO-8859-1';
			u.ProfileId = NOTPortalProf.id;
			u.LanguageLocaleKey = 'en_US';
			u.myKVH_Manual_Push__c = false;
			userList.add(u);
		}
		insert userList;
		
		list<myKVH_Role__c> roleList = new list<myKVH_Role__c>();
		for(integer i = 0; i<MAX_LOOP_COUNTER; i++){
			myKVH_Role__c r = new myKVH_Role__c();
			r.name = 'B list Role ' + i;
			r.isRoleExtension__c = true; 
			roleList.add(r);
			r = new myKVH_Role__c();
			r.name = 'A list Role ' + i;
			r.isRoleExtension__c = true; 
			roleList.add(r);
		}
		insert roleList;

	}

    static testMethod void testCombined() {
        list<User> testUsers = new list<User>();
        testUsers = [SELECT Id, LastName, myKVH_Manual_Push__c  FROM User WHERE username LIKE '%UREExt.testUser1@kvh.com'];
        system.assertEquals(MAX_LOOP_COUNTER, testUsers.size());
        for(User u : testUsers){
        	system.assertEquals(false, u.myKVH_Manual_Push__c);
        }
        list<myKVH_Role__c> testRoles = new list<myKVH_Role__c>();
        testRoles = [SELECT Id, Name FROM myKVH_Role__c WHERE Name LIKE '% list Role %'];
        system.assertEquals(MAX_LOOP_COUNTER * 2, testRoles.size());
        test.startTest();
        //Need to create a list of myKVH User Role Extensions... each user has 2 roles!
        list<myKVH_User_Role_Extension__c> testURElist = new list<myKVH_User_Role_Extension__c>();
        integer roleCounter = 0;
        for(integer i = 0; i < MAX_LOOP_COUNTER; i++){
        	myKVH_User_Role_Extension__c ure = new myKVH_User_Role_Extension__c();
        	ure.user__c = testUsers[i].Id;
        	ure.ExtendedRole__c = testRoles[roleCounter].Id;			//Role extension #1
        	testURElist.add(ure);
        	roleCounter++;
        	ure = new myKVH_User_Role_Extension__c();
        	ure.user__c = testUsers[i].Id;
        	ure.ExtendedRole__c = testRoles[roleCounter].Id;			//Role extension #2
        	testURElist.add(ure);
        	roleCounter++;
        }
        system.assertEquals(MAX_LOOP_COUNTER * 2, testURElist.size());	//should be double the number of users....
        
        system.runAs(testUsers[0]){										//execute DML as a specific user to avoid mixed DML exception
			insert testURElist;											//insert the records, trigger runs
        }
        
        testUsers.clear();												//reset!
        
        list<User> readUsers = new list<User>();
        readUsers = [SELECT Id, LastName, myKVH_Manual_Push__c  FROM User WHERE username LIKE '%UREExt.testUser1@kvh.com'];
        for(User u : readUsers){										//test ALL the Users!
        	system.assertEquals(false, u.myKVH_Manual_Push__c);			//trigger should set push flag, workflow clears it!
        }
        
        readUsers.clear();												//reset!
        
        testUsers = [SELECT Id, LastName, myKVH_Manual_Push__c  FROM User WHERE username LIKE '%UREExt.testUser1@kvh.com'];
        system.assertEquals(MAX_LOOP_COUNTER, testUsers.size());
        for(User u : testUsers){
        	system.assertEquals(false, u.myKVH_Manual_Push__c);
        }
        
        system.runAs(testUsers[0]){										//execute DML as a specific user to avoid mixed DML exception
        	delete testURElist;											//delete all the User Role extensions
        }
        
        test.stopTest();

        readUsers = [SELECT Id, LastName, myKVH_Manual_Push__c  FROM User WHERE username LIKE '%UREExt.testUser1@kvh.com'];
        for(User u : readUsers){										//test ALL the Users!
        	system.assertEquals(false, u.myKVH_Manual_Push__c);			//trigger should set push flag, workflow clears it!
        }																//if we get here the delete trigger works!
        
    }
}