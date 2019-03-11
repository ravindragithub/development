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
private class test_myKVHUserSync {
	static final integer MAX_LOOP_COUNTER = 10;
	private static final Profile NOTPortalProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Standard%' Limit 1];
	@testSetup static void setupTestUsers(){
		list<User> testUserList = new list<User>();
		for (integer i = 0; i < MAX_LOOP_COUNTER; i++){
			User u = new User();
			u.username = i + 'testUserSync@kvh.com';
			u.LastName = i + 'User';
			u.Email = i + 'testUserSync@kvh.com';
			u.Alias = i + 'tuser';
			u.TimeZoneSidKey = 'America/New_York';
			u.LocaleSidKey = 'en_US';
			u.EmailEncodingKey = 'ISO-8859-1';
			u.ProfileId = NOTPortalProf.id;
			u.LanguageLocaleKey = 'en_US';
			testUserList.add(u);
		}
		
		insert testUserList;
	}

    static testMethod void test_myKVHUserSync() {
        // TO DO: implement unit test
        list<User> testUsers = [SELECT Id, myKVH_Manual_Push__c, username from User WHERE username LIKE '%testUserSync@kvh.com'];
        system.assertEquals(MAX_LOOP_COUNTER, testUsers.size());
        for(User u : testUsers){
        	system.assertNotequals(true, u.myKVH_Manual_Push__c);
        }
        test.startTest();
        ID jobID = System.enqueueJob(new myKVHUserSync(testUsers));
        
        testUsers.clear();
        testUsers = [SELECT Id, myKVH_Manual_Push__c, username from User WHERE username LIKE '%testUserSync@kvh.com'];
        for(User u : testUsers){
        	system.assertNotequals(true, u.myKVH_Manual_Push__c);
        }
        test.stopTest();
        testUsers.clear();
        testUsers = [SELECT Id, myKVH_Manual_Push__c, username from User WHERE username LIKE '%testUserSync@kvh.com'];
        for(User u : testUsers){
        	system.assertNotequals(true, u.myKVH_Manual_Push__c);
        }
    }
}