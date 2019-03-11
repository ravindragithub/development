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
private class test_UserTrigger {
	static final integer MAX_LOOP_COUNTER = 100;
    @testSetup static void setupTestData() {
        //setup Account Hierarchy
		list<Account> testAccountList = new list<Account>();
		Account testAcct = new Account(Name = 'myKVH_User_Admin_Controller Test Account');
        Account testParent = new Account(Name = 'myKVH_User_Admin_Controller Test Parent Account');
        Account testGrandParent = new Account(Name = 'myKVH_User_Admin_Controller Test GrandParent Account');
		testAccountList.add(testAcct);
		testAccountList.add(testParent);
		testAccountList.add(testGrandParent);
		insert testAccountList;
		//Iterate through list adjust parent Accounts....
		map<string, Account> testAccountMap = new map<string, Account>();
		for(Account a : testAccountList){
			system.debug('Id: ' + a.Id + ' Name: ' + a.Name);
			testAccountMap.put(a.Name, a);
		}
		testAcct.ParentId  = testAccountMap.get('myKVH_User_Admin_Controller Test Parent Account').Id;
		update testAcct;
		testParent.ParentId  = testAccountMap.get('myKVH_User_Admin_Controller Test GrandParent Account').Id;
		update testParent;
		
		for(Account a : testAccountList){
			system.debug('Id: ' + a.Id + ' |Name: ' + a.Name + ' |Parent: ' + a.ParentId);
		}
		//add a bunch of contacts...
        list<Contact> contactList = new list<Contact>();
        for(integer i = 0; i < MAX_LOOP_COUNTER; i++){
        	Contact testContact = new Contact(LastName = 'UserTriggerTest' + i, AccountId = testAccountMap.get('myKVH_User_Admin_Controller Test GrandParent Account').Id);
        	contactList.add(testContact);
        }
        insert contactList;
    }
    static testMethod void testUserTrigger() {
		//Need a Profile.... a PORTAL profile! Profiles are Metadata!
		Profile PortalProf = new Profile();
		PortalProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Portal%' Limit 1];
		system.debug(PortalProf);
		//Convert Contacts to Portal Users
		list<User> userList = new list<User>();
		integer i = 0;
		for(Contact c : [SELECT Id, Name FROM Contact WHERE LastName LIKE 'UserTriggerTest%']){
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
			tu.ContactId = c.Id; //must CREATE() user with Contact Id.....
			userList.Add(tu);
			i++;
		}
		insert userList;
		update userList;
    }
}