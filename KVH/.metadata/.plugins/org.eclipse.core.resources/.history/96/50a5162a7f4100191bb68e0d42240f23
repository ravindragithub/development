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
/* This test Class tests:
 *    -myKVH_Shared_Platforms_Utilities
 *    -PlatformShareTrigger
 * In essence, when a myKVH_Shared_Platforms__c record is created, updated, or deleted,
 * the trigger fires, calling a utility class that sets a boolean field on the User.
 * A workflow rule on the User sends an Outbound Message from the User record, and clears the flag.
 * Kind of hard to test with the Workflow running, so we compare SystemModstamps
 * before and after the myKVH_Shared_Platforms__c trigger is invoked.
 * The trigger must alter the related User record.
 */
private class test_myKVH_Shared_Platforms_Utilities {
	/* typical testClass statics...*/
	static integer MAX_LOOP_COUNTER = 25;
	private static final Id Platform_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Demo/Test/Monitor').getRecordTypeId();
	private static final Profile PortalProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Portal%' Limit 1];
	private static final User adminUser = [SELECT Id, username FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
	// Need (portal) Users, and Platform Accounts 
	@testSetup static void setupTestData(){
		//Need a contact and account..
        //Need to create a couple of Accounts
    	List<Account> testAcctList = new List<Account>();
    	for (integer i = 0; i < 1; i++){		//We just need one, but this makes it easy to create as many as we need!
    		Account a = new Account();			
    		a.Name = 'Test Account ' + i;		
    		a.BillingCountry = 'Spain';			//rhymes with "Pain"....
    		testAcctList.add(a); 
    		system.debug(testAcctList);
    	}
		for(integer i = 0; i<MAX_LOOP_COUNTER; i++){
			Account r = new Account();
			r.name = i + 'Shared Platforms Tests';
			r.RecordTypeId = Platform_RECORD_TYPE_ID;
			testAcctList.add(r);
		}
		//insert Accounts and Platforms together
    	insert testAcctList;
		//Need an Account to Hang Contacts from....
        Account testAcct = ([SELECT id, Name FROM Account WHERE Name = 'Test Account 0' LIMIT 1]);
        list<Contact> contList = new list<Contact>();			//create a few contacts
        for(integer i = 0; i < MAX_LOOP_COUNTER; i++){			//as many as required....
        	Contact testCont1 = new Contact(LastName = 'test1', AccountId = testAcct.Id);
        	contList.add(testCont1);
        }
        insert contList;
        
        list<User> userlist = new list<User>();					//convert Contacts to Portal Users
        for(integer i = 0; i < MAX_LOOP_COUNTER; i++){
        	User testUser1 = new User();
			testUser1.username = i + 'PSUtil.testUser@kvh.com';
			testUser1.LastName = 'User1';
			testUser1.Email = i +'PSUtil.testUser@kvh.com';
			testUser1.Alias = i + 'tuser1';
			testUser1.TimeZoneSidKey = 'America/New_York';
			testUser1.LocaleSidKey = 'en_US';
			testUser1.EmailEncodingKey = 'ISO-8859-1';
			testUser1.ProfileId = PortalProf.id;
			testUser1.LanguageLocaleKey = 'en_US';
			testUser1.ContactId = contList[i].Id;				//must CREATE() user with Contact Id.....
			userlist.add(testUser1);
		}
		system.runAs(adminUser){
			insert userlist;
		}
	}

    static testMethod void testInsert(){
        //need our list of Users, and our list of Platforms
        list<User> testUsersListOriginal = new list<User>([SELECT Id, username, SystemModstamp FROM User WHERE username LIKE '%PSUtil.testUser@kvh.com']);
        system.assertEquals(MAX_LOOP_COUNTER, testUsersListOriginal.size());							//Make sure that we got data
        map<Id, User> userMapOriginal = new map<Id, User>(testUsersListOriginal);						//Setup a map for comparison engine
        list<Account> testPlatList = new list<Account>([SELECT Id, Name FROM Account WHERE Name like '%Shared Platforms Tests']);
        system.assertEquals(MAX_LOOP_COUNTER, testPlatList.size());										//Make sure that we got data
        list<myKVH_Shared_Platforms__c> testShareList = new list<myKVH_Shared_Platforms__c>();			//setup shared platforms
        for(integer i = 0; i<MAX_LOOP_COUNTER; i++){													//use a loop counter
        	myKVH_Shared_Platforms__c SP = new myKVH_Shared_Platforms__c();								//One share for...
        	SP.User__c = testUsersListOriginal[i].Id;													//Each User...
        	SP.Shared_Platform__c = testPlatList[i].Id;													//and Each Platform
        	testShareList.add(SP);																		//fill the list, and insert a little later
        }
        test.startTest();																				//and away we go!
        list<myKVH_Shared_Platforms__c> readList = new list<myKVH_Shared_Platforms__c>();				//Setup a list to collect shared platforms
        readList=[SELECT Id, User__c, Shared_Platform__c FROM myKVH_Shared_Platforms__c];				//fill it up (but there should be NONE!)
        system.assertEquals(0,readList.size());															//make sure that there are none.
		/* Kind of hard to do an assertion against the User field since the workflow reverts the value
         * our best bet will be to verif that the User object was changed as a result of new Platform Share records
         * Compare SystemModstamp values, before and after inserts/deletes of Platform Share records
         */
        
        insert testShareList;																			//insert our list from above... trigger should fire, followed by workflow!
        test.stopTest();																				//stopTest runs all async jobs.....
        for (User u : [SELECT Id, username, SystemModstamp FROM User WHERE username LIKE '%PSUtil.testUser@kvh.com']){
        	system.assertNotequals(u.SystemModstamp, userMapOriginal.get(u.Id).SystemModstamp);			//Verifies that the User was changed!
        }																								//onInsert test complete!

    }
    static testMethod void testUpdate(){
    	//need our list of Users, and our list of Platforms
        list<User> testUsersListOriginal = new list<User>([SELECT Id, username, SystemModstamp FROM User WHERE username LIKE '%PSUtil.testUser@kvh.com']);
        system.assertEquals(MAX_LOOP_COUNTER, testUsersListOriginal.size());							//Make sure that we got data
        map<Id, User> userMapOriginal = new map<Id, User>(testUsersListOriginal);						//Setup a map for comparison engine
        list<Account> testPlatList = new list<Account>([SELECT Id, Name FROM Account WHERE Name like '%Shared Platforms Tests']);
        system.assertEquals(MAX_LOOP_COUNTER, testPlatList.size());										//Make sure that we got data
        list<myKVH_Shared_Platforms__c> testShareList = new list<myKVH_Shared_Platforms__c>();			//setup shared platforms
        for(integer i = 0; i<MAX_LOOP_COUNTER; i++){													//use a loop counter
        	myKVH_Shared_Platforms__c SP = new myKVH_Shared_Platforms__c();								//One share for...
        	SP.User__c = testUsersListOriginal[i].Id;													//Each User...
        	SP.Shared_Platform__c = testPlatList[i].Id;													//and Each Platform
        	testShareList.add(SP);																		//fill the list, and insert a little later
        }
        
        list<myKVH_Shared_Platforms__c> readList = new list<myKVH_Shared_Platforms__c>();				//Setup a list to collect shared platforms
        readList=[SELECT Id, User__c, Shared_Platform__c FROM myKVH_Shared_Platforms__c];				//fill it up (but there should be NONE!)
        system.assertEquals(0,readList.size());															//make sure that there are none.
		/* Kind of hard to do an assertion against the User field since the workflow reverts the value
         * our best bet will be to verif that the User object was changed as a result of new Platform Share records
         * Compare SystemModstamp values, before and after inserts/deletes of Platform Share records
         */
        insert testShareList;																			//insert our list from above... trigger should fire, followed by workflow!
		//RESET
		//Arrange... setup original list for comparison
		test.startTest();																				//and away we go!
		testUsersListOriginal = [SELECT Id, username, SystemModstamp FROM User WHERE username LIKE '%PSUtil.testUser@kvh.com'];
		//Act... fire after Update Trigger
		update testShareList;
		//Assert...make sure that the workflow fires
		test.stopTest();																				//stopTest runs all async jobs.....
        for (User u : [SELECT Id, username, SystemModstamp FROM User WHERE username LIKE '%PSUtil.testUser@kvh.com']){
        	system.assertNotequals(u.SystemModstamp, userMapOriginal.get(u.Id).SystemModstamp);			//Verifies that the User was changed!
        }																								//onUpdate test complete!
    }
    
    static testMethod void testDelete(){
    	//need our list of Users, and our list of Platforms
        list<User> testUsersListOriginal = new list<User>([SELECT Id, username, SystemModstamp FROM User WHERE username LIKE '%PSUtil.testUser@kvh.com']);
        system.assertEquals(MAX_LOOP_COUNTER, testUsersListOriginal.size());							//Make sure that we got data
        map<Id, User> userMapOriginal = new map<Id, User>(testUsersListOriginal);						//Setup a map for comparison engine
        list<Account> testPlatList = new list<Account>([SELECT Id, Name FROM Account WHERE Name like '%Shared Platforms Tests']);
        system.assertEquals(MAX_LOOP_COUNTER, testPlatList.size());										//Make sure that we got data
        list<myKVH_Shared_Platforms__c> testShareList = new list<myKVH_Shared_Platforms__c>();			//setup shared platforms
        for(integer i = 0; i<MAX_LOOP_COUNTER; i++){													//use a loop counter
        	myKVH_Shared_Platforms__c SP = new myKVH_Shared_Platforms__c();								//One share for...
        	SP.User__c = testUsersListOriginal[i].Id;													//Each User...
        	SP.Shared_Platform__c = testPlatList[i].Id;													//and Each Platform
        	testShareList.add(SP);																		//fill the list, and insert a little later
        }
        
        list<myKVH_Shared_Platforms__c> readList = new list<myKVH_Shared_Platforms__c>();				//Setup a list to collect shared platforms
        readList=[SELECT Id, User__c, Shared_Platform__c FROM myKVH_Shared_Platforms__c];				//fill it up (but there should be NONE!)
        system.assertEquals(0,readList.size());															//make sure that there are none.
		/* Kind of hard to do an assertion against the User field since the workflow reverts the value
         * our best bet will be to verif that the User object was changed as a result of new Platform Share records
         * Compare SystemModstamp values, before and after inserts/deletes of Platform Share records
         */
        insert testShareList;																			//insert our list from above... trigger should fire, followed by workflow!
		//RESET
		//Arrange... setup original list for comparison
		test.startTest();																				//and away we go!
		testUsersListOriginal = [SELECT Id, username, SystemModstamp FROM User WHERE username LIKE '%PSUtil.testUser@kvh.com'];
		//Act... fire after Update Trigger
		delete testShareList;
		//Assert...make sure that the workflow fires
		test.stopTest();																				//stopTest runs all async jobs.....
        for (User u : [SELECT Id, username, SystemModstamp FROM User WHERE username LIKE '%PSUtil.testUser@kvh.com']){
        	system.assertNotequals(u.SystemModstamp, userMapOriginal.get(u.Id).SystemModstamp);			//Verifies that the User was changed!
        }																								//onDelete test complete!
    }
}