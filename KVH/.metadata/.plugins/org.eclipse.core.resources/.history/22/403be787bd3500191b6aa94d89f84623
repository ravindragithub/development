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
private class test_SiteUtilities {
	private static final Id Platform_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Demo/Test/Monitor').getRecordTypeId();
	private static final Id DirectCust_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Customer').getRecordTypeId();
	private static final integer MAX_LOOP_COUNTER = 5;
	private static final User adminUser = [SELECT Id, username FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
	
	@testSetup static void setupTestData(){
		// TO DO: implement unit test
        //create some portal and an internal User
        //Insert a Test User
		//Need a contact and account..
		//Going to need a parent Account too...
		//AND a platform, don't forget the send flags!!
		list<Account> testAccountList = new list<Account>();
		Account testAcct = new Account(Name = 'SiteUtilities Test Platform', RecordTypeId = Platform_RECORD_TYPE_ID);
		testAcct.myKVH_Element_Count__c = 1;				//must have elements!
		
		
        Account testParent = new Account(Name = 'SiteUtilities Test Parent Account', RecordTypeId = DirectCust_RECORD_TYPE_ID);
		testParent.Send_to_myKVH_Physical__c = true;
        
        Account testGrandParent = new Account(Name = 'SiteUtilities Test GrandParent Account', RecordTypeId = DirectCust_RECORD_TYPE_ID);
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
        	Contact testContact = new Contact(LastName = 'test' + i, AccountId = testGrandParent.Id, Email = i + 'SiteUtilities.testContact@mock.user');
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
			tu.username = i + 'SiteUtilities.testUser@mock.user';
			tu.LastName = 'User1';
			tu.Email = i + 'SiteUtilities.testUser@mock.user';
			tu.Alias = 'AccAdm' + i;
			tu.TimeZoneSidKey = 'America/New_York';
			tu.LocaleSidKey = 'en_US';
			tu.EmailEncodingKey = 'ISO-8859-1';
			tu.ProfileId = PortalProf.id;
			tu.LanguageLocaleKey = 'en_US';
			tu.ContactId = contactList[i].Id; //must CREATE() user with Contact Id.....
			userList.Add(tu);
		}
		system.runAs(adminUser){			// avoid mixed DML
			insert userList;
		}
		
	}

    static testMethod void test_getFleetlist() {
        // TO DO: implement unit test
        system.debug('starting test');
        //Need a User..
        User u = new User();
        u = [SELECT Id FROM User WHERE username = '0SiteUtilities.testUser@mock.user' LIMIT 1];
        //Need a look at the mock Platform... "Fleet of One" in the User's Hierarchy (could be several, test data only sets up one)
        Account plat = new Account();
        plat = [SELECT Id, Name FROM Account WHERE Name = 'SiteUtilities Test Platform' LIMIT 1];
        list<String> VisiblePlatformIds = new list<String>();				//need a list of Platforms visible to User....
        SiteUtilities util = new SiteUtilities();
        VisiblePlatformIds = util.getFleetList(u.Id);
        system.assertEquals(1, VisiblePlatformIds.size());					//there should be only one
        system.assertEquals(plat.id, VisiblePlatformIds[0]);				//and it should be THIS one!
    }
}