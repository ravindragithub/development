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
private class test_ContactTrigger_V2 {
	static final integer MAX_LOOP_COUNTER = 100;
	@testSetup static void setupContactTriggerTestData(){
		
	}
    static testMethod void ContactTrigger_V2_UnitTest() {
        // TO DO: implement unit test
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
		
        //testAcct = [SELECT id, Name FROM Account WHERE Name = 'testAcct'];
        //add a bunch of contacts...
        list<Contact> contactList = new list<Contact>();
        for(integer i = 0; i < MAX_LOOP_COUNTER; i++){
        	Contact testContact = new Contact(LastName = 'test' + i, AccountId = testGrandParent.Id);
        	contactList.add(testContact);
        }
        insert contactList;
        update contactList;
        delete contactList;
        /* no assertions... the ContactTrigger_V2 doesn't actually DO anything at this point.... */
    }
}