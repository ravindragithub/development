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
private class test_ContactUtilities {
	static final integer MAX_LOOP_COUNTER = 100;				//Use *EVEN* numbers only!
	private static final User adminUser = [SELECT Id, username FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
	
	@testSetup static void setupContactUtilitiesTestData(){
		//Need Contact, and Portal Users
		list<Account> testAccountList = new list<Account>();
        Account testGrandParent = new Account(Name = 'myKVH_User_Admin_Controller Test GrandParent Account');
		testAccountList.add(testGrandParent);
		insert testAccountList;

        list<Contact> contactList = new list<Contact>();
        for(integer i = 0; i < MAX_LOOP_COUNTER; i++){
        	Contact testContact = new Contact(LastName = 'testContactUtil' + i, AccountId = testGrandParent.Id, email='testContactUtil' + i + '@kvh.com');
        	contactList.add(testContact);
        }
        insert contactList;
        //Need a Profile.... a PORTAL profile! Profiles are Metadata!
		Profile PortalProf = new Profile();
		PortalProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Portal%' Limit 1];
		system.debug(PortalProf);
		list<User> userList = new list<User>();
		for(Contact c : [SELECT Id, LastName, email FROM Contact WHERE LastName LIKE 'testContactUtil%']){
			User tu = new User();
			tu.username = c.email;
			tu.LastName = c.LastName;
			tu.Email = c.email;
			tu.Alias = 'testAlia';
			tu.TimeZoneSidKey = 'America/New_York';
			tu.LocaleSidKey = 'en_US';
			tu.EmailEncodingKey = 'ISO-8859-1';
			tu.ProfileId = PortalProf.id;
			tu.LanguageLocaleKey = 'en_US';
			tu.ContactId = c.Id; //must CREATE() user with Contact Id.....
			tu.isActive = true;
			//tu.uas__Sync_to_Contact__c = false;								//handled by workflow
			//tu.contactList = true;
			userList.Add(tu);
		}
		system.runAs(adminUser){
			insert userList;
		}
		
	}

	static testMethod void testDeactivateUsers(){
		list<User> userList = new list<User>();
		userList = [SELECT Id, IsPortalEnabled, IsActive, ContactId FROM User 
						WHERE username LIKE 'testContactUtil%'];
		system.assertEquals(MAX_LOOP_COUNTER, userList.size());					//verify User test data step 1
		for (User u : userList){												//verify User test data step 2
			system.assert(u.IsPortalEnabled);
			system.assert(u.IsActive);
		}																		//OK!Right number of users, with the right fields set
		list<Contact> contactReadList = new list<Contact>();
		list<Contact> contactUpdateList = new list<Contact>();
		contactReadList = [SELECT Id, LastName, email, Inactive_Contact__c FROM Contact WHERE LastName LIKE 'testContactUtil%'];
		system.assertEquals(MAX_LOOP_COUNTER, contactReadList.size());				//verify Contact test data step 1
		for (integer i = 0; i < MAX_LOOP_COUNTER; i++){
			system.assertNotEquals(true, contactReadList[i].Inactive_Contact__c);				//verify Contact test data step 2
			string uname = contactReadList[i].email;										//tease out that embedded integer...
			//system.debug('Raw : ' + uname);
			uname = uname.removeEndIgnoreCase('@kvh.com');
			//system.debug('Remove tail : ' + uname);
			uname = uname.removeStartIgnoreCase('testContactUtil');
			//system.debug('Remove head : ' + uname);
			integer c = Integer.valueOf(uname);
			
			if(math.mod(c,2)==0){															//Deactivate the even ones only!
				Contact c2 = new Contact();														//Make a new Contact
				c2.Id = contactReadList[i].Id;													//clone the current iteration
				c2.Inactive_Contact__c = true;													//set the inactive flag
				contactUpdateList.add(c2);														//add it to the Update list
			} else {																		//Leave the odd ones active...
				Contact c2 = new Contact();														//Make a new Contact
				c2.Id = contactReadList[i].Id;													//clone the current iteration
				c2.Inactive_Contact__c = false;													//DO NOT set the inactive flag
				contactUpdateList.add(c2);														//add it to the Update list
			}
		}
		system.debug(contactUpdateList);														//should be the same size as MAX_LOOP_COUNTER
		system.assertEquals(MAX_LOOP_COUNTER, contactUpdateList.size());
		test.startTest();
		ContactUtilities util = new ContactUtilities();											//doesn't exercise contact trigger...
		util.deactivateUsers(contactUpdateList);			
		userList.clear();
		test.stopTest();
		userList = [SELECT Id, username, IsPortalEnabled, IsActive, ContactId FROM User 	//Use SOQL a FOR loop...
						WHERE username LIKE 'testContactUtil%'];
		
		for (integer i = 0; i < MAX_LOOP_COUNTER; i++){
			string uname = userList[i].username;
			system.debug('Raw : ' + uname);
			uname = uname.removeEndIgnoreCase('@kvh.com');
			system.debug('Remove tail : ' + uname);
			uname = uname.removeStartIgnoreCase('testContactUtil');
			system.debug('Remove head : ' + uname);
			integer c = Integer.valueOf(uname);
			if(math.mod(c,2)==0){
				system.assertEquals(true, userList[i].IsActive);
				system.debug('User : ' + userList[i] + ' Has Been Deactivated!');
			} else {
				system.assertEquals(true, userList[i].IsActive);
				system.debug('User : ' + userList[i] + ' Is Still Active!');
			}
		}
		

	}
}