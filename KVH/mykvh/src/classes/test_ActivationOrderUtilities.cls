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
private class test_ActivationOrderUtilities {
	static final integer MAX_LOOP_COUNTER = 10;
	static final User acctOwner = [SELECT Id FROM User WHERE User.Profile.Name LIKE 'KVH Standard%' AND IsActive = true LIMIT 1];
	static final User adminUser = [SELECT Id FROM User WHERE User.Profile.Name LIKE 'System Administrator' AND IsActive = true LIMIT 1];
	
	@testSetup static void setupTestData(){
		//setup Accounts
		
		list<Account> testAccts = new list<Account>();
		for (integer i = 0; i < MAX_LOOP_COUNTER; i++){
			Account a = new Account();
			a.Name = i + 'testAcct for Activation Orders';
			a.OwnerId = acctOwner.Id;
			testAccts.add(a);
		}
		insert testAccts;
		//setup Activation Contacts
		list<myKVH_Contact__c> testActConts = new list<myKVH_Contact__c>();
		for (integer i = 0; i < MAX_LOOP_COUNTER; i++){
			myKVH_Contact__c ac = new myKVH_Contact__c();
			ac.First_Name__c = i + 'test Act Cont FN';
			ac.Last_Name__c = i + 'test Act Cont LN';
			ac.email__c = i + 'activationtestemail@kvh.com';
			ac.Account__c = testAccts[i].Id;
			testActConts.add(ac);
		}
		system.runAs(adminUser){
			insert testActConts;
		}
		
	}
	static testMethod void testSetupData(){
		list<Account> readAcctList = new list<Account>();
		readAcctList = [SELECT Id, Name, OwnerId FROM Account];
		system.assertEquals(MAX_LOOP_COUNTER, readAcctList.size());
		for(Account a : readAcctList){
			system.assertEquals(acctOwner.Id, a.OwnerId);
		}
		system.debug('readAcctList size : ' + readAcctList.size());
		list<myKVH_Contact__c> readActContList = new list<myKVH_Contact__c>();
		readActContList = [SELECT Id, First_Name__c, Last_Name__c, Account__c, OwnerId FROM myKVH_Contact__c];
		system.assertEquals(MAX_LOOP_COUNTER, readActContList.size());
		for(myKVH_Contact__c ac : readActContList){
			system.assertEquals(adminUser.Id, ac.OwnerId);
		}
		system.debug('readActContList size : ' + readActContList.size());
		//system.assert(false);
	}

    static testMethod void testConvertContacts() {
        // TO DO: implement unit test
        string ActContQueryString = 'SELECT Receive_Network_Service_Notifications__c, Phone__c, OwnerId, Mobile__c, Last_Name__c, ';
        ActContQueryString += 'Job_Function__c,  Id, First_Name__c,  Email__c, Account__c, Country__c, State_Province__c FROM myKVH_Contact__c';
        
        string ContactQueryString = 'SELECT Receive_Network_Service_Notifications__c, Phone, OwnerId, MobilePhone, ';
        ContactQueryString += 'LastName, Job_Function__c, FirstName, Email, AccountId From Contact';
        
        
		ActivationOrderUtilities util = new ActivationOrderUtilities();
		list<myKVH_Contact__c> testActConts = new list<myKVH_Contact__c>();
		testActConts = database.query(ActContQueryString);
		Database.SaveResult[] sr = util.ConvertContact(testActConts);
		
		system.assertEquals(MAX_LOOP_COUNTER, sr.size());
		for(Database.SaveResult sr2 : sr){
			if (sr2.isSuccess()) {
				// Operation was successful, so get the ID of the record that was processed
				System.debug('Successfully inserted account. Contact ID: ' + sr2.getId());
			}
			else {
				// Operation failed, so get all errors                
				for(Database.Error err : sr2.getErrors()) {
					System.debug('The following error has occurred.');                    
					System.debug(err.getStatusCode() + ': ' + err.getMessage());
					System.debug('Account fields that affected this error: ' + err.getFields());
				}
			}
		}
		list<Contact> contList = new list<Contact>();
		contList = Database.Query(ContactQueryString);
		system.assertEquals(MAX_LOOP_COUNTER, contList.size());
		for (Contact c : contList){
			system.assertEquals(acctOwner.Id,c.OwnerId);
		}
		//system.assert(false);
    }
}