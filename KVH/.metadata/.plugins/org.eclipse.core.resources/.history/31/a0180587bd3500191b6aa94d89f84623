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
private class test_REST_API_utilities {
	/* typical testClass statics...*/
	static integer MAX_LOOP_COUNTER = 4;
	private static final Id Platform_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Demo/Test/Monitor').getRecordTypeId();
	private static final Profile PortalProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Portal%' Limit 1];
	private static final User adminUser = [SELECT Id, username FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
	
	@testSetup static void setupTestData(){
		//need An Account hierarhcy, and an Asset...
		list<Account> testAcctList = new list<Account>();
		map<String, Account> acctMap = new map<String, Account>();
		for (integer i = 0; i < MAX_LOOP_COUNTER; i++){    //We need 2
			Account a = new Account();      
			a.Name = 'Test REST API ' + i;    
			a.BillingCountry = 'Spain';      //rhymes with "Pain"....
			testAcctList.add(a); 
			acctMap.put(a.Name, a);
			system.debug(testAcctList);
		}
		for(integer i = 0; i < MAX_LOOP_COUNTER; i++){
			Account r = new Account();
			r.name = i + 'Test REST API Platforms';
			r.RecordTypeId = Platform_RECORD_TYPE_ID;
			acctMap.put(r.Name, r);
			testAcctList.add(r);
		}
		insert testAcctList;
		testAcctList.clear();
		for (integer i = 0; i < MAX_LOOP_COUNTER; i++){
			Account top = acctMap.get('Test REST API ' + i);
			Account bottom = acctMap.get(i + 'Test REST API Platforms');
			bottom.ParentId = top.Id;
			testAcctlist.add(bottom);
		}
		update testAcctList;
		
		//Need some Assets...
		list<Asset> testAssetList = new list<Asset>();
		for(integer i = 0; i < MAX_LOOP_COUNTER; i++){
			Asset element = new Asset();
			element.Name = 'Test Asset ' + i;
			element.AccountId = acctMap.get(i + 'Test REST API Platforms').Id;
			testAssetList.add(element);
		}
		insert testAssetList;
		
		Contact c = new Contact();
		c.LastName = 'REST API test Contact';
		c.email = 'test_REST_API_utilities@kvh.com';
		c.AccountId = testAcctList[0].ParentId;
		insert c;
		
	}
	
	static testMethod void testSetupData(){
		list<Account> readList = new list<Account>();
		readList = [SELECT Id, ParentId, Name FROM Account];
		system.assertEquals(MAX_LOOP_COUNTER * 2, readList.size());
		for(Account a : readList){
			if(a.name.right(9) == 'Platforms'){
				system.assertNotEquals(a.ParentID, null);
			}
		}
		list<Asset> assetReadList = new list<Asset>();
		assetReadList = [SELECT Id, Name, AccountId FROM Asset];
		system.assertEquals(MAX_LOOP_COUNTER, assetReadList.size());
	}
	
	static testMethod void test_getBillingAcct(){
		//test null return
		REST_API_utilities util = new REST_API_utilities();
		list<Asset> assetReadList = new list<Asset>();
		assetReadList = [SELECT Id, Name, AccountId FROM Asset];
		Account a =  util.getBillingAccount(assetReadList[0]);
		system.assertEquals(a, null);
		//test positive return
		a = [SELECT id, Name FROM Account WHERE Name = 'Test REST API 0' LIMIT 1];
		a.Account_Type__c = 'Customer';
		a.Custom_Call_Acct_ID__c = '6666';
		a.Account_Effective_Date__c = Date.today();
		a.Revenue_Category__c = 'VSAT';
		update a;
		Account b =  util.getBillingAccount(assetReadList[0]);
		system.assertEquals(a.id, b.id);
		//test orphan Asset
		Contact con = [SELECT Id, LastName, email FROM Contact LIMIT 1];
		Asset x = new Asset();
		x.Name = 'Orphan Asset';
		x.ContactId = con.Id;
		insert x;
		Account c =  util.getBillingAccount(x);
		system.assertEquals(c, null);
		//test Asset as an Immediate child of CC account
		x.AccountId = a.id;
		update x;
		Account d =  util.getBillingAccount(x);
		system.assertEquals(a.id, d.id);
	}

    static testMethod void testReturnCode() {
        // TO DO: implement unit test
        //test no paramater constructor...
        REST_API_utilities.resultCode rc = new REST_API_utilities.resultCode(); 
		rc.success = true;
		rc.exceptionMessage = 'Everything is cool';
		system.assert(rc.success);
		system.assertEquals('Everything is cool', rc.exceptionMessage);
		//test two parameter constructor...
		REST_API_utilities.resultCode rc2 = new REST_API_utilities.resultCode(false, 'Constructor test'); 
		system.assertEquals(false, rc2.success);
		system.assertEquals('Constructor test', rc2.exceptionMessage);
    }
}