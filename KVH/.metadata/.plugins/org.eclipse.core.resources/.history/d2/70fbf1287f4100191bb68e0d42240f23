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
private class test_REST_users_V2 {
	
	
	//static Profile PortalProf = new Profile();
	private static Profile PortalProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Portal%' Limit 1];
	private static Profile NOTPortalProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Standard%' Limit 1];
	private static final User adminUser = [SELECT Id, username FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
	
	@testSetup static void testDataSetup(){
		Account testAcct = new Account(Name = 'testAcct');
        insert testAcct;
        testAcct = [SELECT id, Name FROM Account WHERE Name = 'testAcct'];
        Contact testCont1 = new Contact(LastName = 'test1', AccountId = testAcct.Id);
        insert testCont1;
        testCont1 = [SELECT id, Name FROM Contact WHERE LastName = 'test1'];
		//Need a Profile.... a PORTAL profile!
		
		//PortalProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Portal%' Limit 1];
		//system.debug(PortalProf);
		//Need a NOT a PORTAL profile...
		
		//NOTPortalProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Standard%' Limit 1];
		//system.debug(NOTPortalProf);
		// testUser1 ... is a Contact
		User testUser1 = new User();
		testUser1.username = 'v2users@kvh.com';
		testUser1.LastName = 'User1';
		testUser1.Email = 'v2users@kvh.com';
		testUser1.Alias = 'tuser1';
		testUser1.TimeZoneSidKey = 'America/New_York';
		testUser1.LocaleSidKey = 'en_US';
		testUser1.EmailEncodingKey = 'ISO-8859-1';
		testUser1.ProfileId = PortalProf.id;
		testUser1.LanguageLocaleKey = 'en_US';
		testUser1.ContactId = testCont1.Id; //must CREATE() user with Contact Id.....
		system.runAs(adminUser){
			insert testUser1;
		}
		
		testUser1 = [SELECT id, username, Email FROM User WHERE username = 'v2users@kvh.com'];
		//test data part 1 completed!!
	}
    static testMethod void myUnitTest() {
		//Insert a Test User
		//Need a contact and account..
		// testUser1 ... is a Contact
		User testUser1 = new User();
		testUser1 = [SELECT id, username, Email FROM User WHERE username = 'v2users@kvh.com'];
		//test data part 1 completed!!

		string instance = ''; //empty string to replace instance....
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		List<User> UserList = new List<User>();
		
		//test with an accurate User Id....
		UserList.clear();					//reset
		req.requestURI = instance + 'salesforce.com/services/apexrest/V2/users/' + testUser1.Id;  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		userList = REST_users_V2.doGet();
		system.assertEquals(1, userList.size());
		system.assertEquals(PortalProf.id, userList[0].ProfileId);
		
		//test with a bogus User Id....
		UserList.clear();					//reset
		req.requestURI = instance + 'salesforce.com/services/apexrest/V2/users/005000000000000';
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		userList = REST_users_V2.doGet();
		system.assertEquals(0, userList.size());
		
		//test with a realistic e-mail
		UserList.clear();					//reset
		req.requestURI = instance + 'salesforce.com/services/apexrest/V2/users/search';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		req.addParameter('email', 'v2users@kvh.com');
		RestContext.response = res;
		userList = REST_users_V2.doGet();
		system.assertEquals(1, userList.size());
		system.assertEquals(PortalProf.id, userList[0].ProfileId);
		
		//test with a bogus e-mail
		UserList.clear();					//reset
		req.requestURI = instance + 'salesforce.com/services/apexrest/V2/users/search';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		req.addParameter('email', 'notatestUser1@kvh.com');
		RestContext.response = res;
		userList = REST_users_V2.doGet();
		system.assertEquals(0, userList.size());
		
		//test with no identifier
		UserList.clear();					//reset
		req.requestURI = instance + 'salesforce.com/services/apexrest/V2/users';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		userList = REST_users_V2.doGet();
		system.assertEquals(0, userList.size());
		system.assertEquals(400, res.statuscode);

		//test with duplicate E-mail
		//need another test user...
		// testUser2... is NOT a contact
		User testUser2 = new User();
		testUser2.username = 'v2users.2@kvh.com';
		testUser2.LastName = 'User2';
		testUser2.Email = 'v2users@kvh.com';	//deliberate duplicate e-mail
		testUser2.Alias = 'tuser2';
		testUser2.TimeZoneSidKey = 'America/New_York';
		testUser2.LocaleSidKey = 'en_US';
		testUser2.EmailEncodingKey = 'ISO-8859-1';
		testUser2.ProfileId = NOTPortalProf.id;  
		testUser2.LanguageLocaleKey = 'en_US';
		insert testUser2;
		testUser2 = [SELECT id, username, Email FROM User WHERE username = 'v2users.2@kvh.com'];
		//Test Data all set!
		
		UserList.clear();					//reset
		req.requestURI = instance + 'salesforce.com/services/apexrest/V2/users/search';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		req.addParameter('email', 'v2users@kvh.com');
		RestContext.response = res;
		userList = REST_users_V2.doGet();
		system.assertEquals(2, userList.size());
		system.assertEquals(300, res.statuscode);
	}

	static testMethod void test_platform_shares (){
		//Need a couple of Account Record Types...
		String Direct_Customer_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Customer').getRecordTypeId();
		String Leisure_Vessel_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Leisure Vessel').getRecordTypeId();
		
        Account testAcct = [SELECT id, Name FROM Account WHERE Name = 'testAcct'];

		// testUser1 ... is a Contact
		User testUser1 = new User();
		testUser1 = [SELECT id, username, Email FROM User WHERE username = 'v2users@kvh.com'];
		//test data part 1 completed!!

		//need a couple of platforms
		Account testPlat1= new Account(Name = 'testPlat1', RecordTypeId = (id)Leisure_Vessel_RECORD_TYPE_ID, myKVH_Element_Count__c = 1);
        insert testPlat1;
        testPlat1 = [SELECT Id, Name, RecordType.DeveloperName, Send_to_myKVH_Physical__c FROM Account WHERE Id =: testPlat1.Id];
        Account testPlat2= new Account(Name = 'testPlat2', RecordTypeId = (id)Leisure_Vessel_RECORD_TYPE_ID);
        insert testPlat2;
		
		
		/* Need to refactor since we are doing something different here in V2... */
		//need a couple of AccountShares
		myKVH_Shared_Platforms__c newShare = new myKVH_Shared_Platforms__c();
		newShare.User__c = testUser1.Id;			//This is the user who gets access to the account (Platform)
		newShare.Shared_Platform__c = testPlat1.Id;				//This is the account (platform) that the user gets access to
		//newShare.CaseAccessLevel = 'None';				//These three field control the level of access....
		//newShare.AccountAccessLevel = 'Read';
		//newShare.OpportunityAccessLevel = 'None';

		system.debug('------------adding Part #1 ' + testUser1.id);
		//system.debug('------------newShare.CaseAccessLevel ' + newShare.CaseAccessLevel);
		//system.debug('------------newShare.AccountAccessLevel ' + newShare.AccountAccessLevel);
		//system.debug('------------newShare.OpportunityAccessLevel ' + newShare.OpportunityAccessLevel);
		insert newShare;
		
		system.debug('testPlat1 RecTypeDevName : '+testPlat1.RecordType.DeveloperName);
		system.debug('testPlat1 Send Flag : '+testPlat1.Send_to_myKVH_Physical__c);
		//we can test for valid user with shares now
		string instance = ''; //empty string to replace instance....
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		List<sObject> sObjectList = new List<sObject>();
		
		sObjectList.clear();	//RESET!
		
		req.requestURI = instance + 'salesforce.com/services/apexrest/V2/users/'+testUser1.Id+'/platform_shares';
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		sObjectList = REST_users_V2.doGet();				//Should return a populated List but with a 200 status code....
		system.assertEquals(1, sObjectList.size());
		
		//Now test for a valid user with no shares
		delete newShare;									//remove the share
		sObjectList.clear();								//RESET!
		
		req.requestURI = instance + 'salesforce.com/services/apexrest/V2/users/'+testUser1.Id+'/platform_shares';
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		sObjectList = REST_users_V2.doGet();				//Should return an empty List but with a 200 status code....
		system.assertEquals(0, sObjectList.size());
		
		//Now test for an invaliud user
		sObjectList.clear();	//RESET!
		
		req.requestURI = instance + 'salesforce.com/services/apexrest/V2/users/005000000000000001/platform_shares';
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		sObjectList = REST_users_V2.doGet();				//Should return an empty List but with a 404 status code....
		system.assertEquals(0, sObjectList.size());
		system.assertEquals(404, res.statuscode);
		
	}
}