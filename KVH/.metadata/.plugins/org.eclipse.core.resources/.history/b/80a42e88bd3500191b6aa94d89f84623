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
private class test_myKVHElementCount {
	
/* Begin setup test data.
	 * Sequence of events is critical. Please proceed with caution when making changes!
	 */
	private static final Id Platform_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Demo/Test/Monitor').getRecordTypeId();
	
	@testSetup static void setupTestData(){
		//Need to create a couple of Accounts
    	List<Account> testAcctList = new List<Account>();
    	for (integer i = 1; i < 4; i++){
    		Account a = new Account();
    		a.Name = 'Test Account ' + i;
    		a.RecordTypeId = Platform_RECORD_TYPE_ID;
    		a.BillingCountry = 'Spain';     //rhymes with "Pain"....
    		testAcctList.add(a); 
    		system.debug(testAcctList);
    	}
    	insert testAcctList;
    	//Need a couple of Products (maybe a KVH Product Family...)
    	KVH_Product_Family__c fam = new KVH_Product_Family__c();
    	fam.FCP_Element_Type__c = 'Terminal';
    	fam.Name = 'Terminal';
    	insert fam;
    	
    	List<Product2> testProdList = new Product2[MAX_LIST_SIZE];		//control the size of the list so we can use set
    	integer counter = 0;
    	while (counter < MAX_LIST_SIZE){
    		Product2 p = new Product2();
    		p.Name = 'Test Product ' + counter;
    		if (math.mod(counter, 3) == 0){			//Should be 0,3, 6, and 9.. yes?
    												//so testProdList[0], [3], [6], and [9] are terminals
    			p.KVH_Product_Family__c = fam.Id;
    		}
    		testProdList.set(counter, p);			//need to control index positions!
    		counter++; 
    	}
    	system.debug (testProdList);
    	insert testProdList;
		//List<Account> testAcctList = new List<Account>();
    	testAcctList = [SELECT Id, Name, RecordTypeId, BillingCountry FROM Account];
    	//List<Product2> testProdList = new List<Product2>();
    	testProdList = [SELECT Id, Name, KVH_Product_Family__c FROM Product2];
	}
	
	private static List<Account>testAcctList = getAccountList();
	private static List<Product2>testProdList = getProductList();
	private static List<KVH_Product_Family__c> familyList = getFamilyList();
	private static integer MAX_LIST_SIZE = 10;
	
	static List<Account> getAccountList() {
		List<Account> acctList = new List<Account>();
		acctList = [SELECT Id, Name, RecordTypeId, myKVH_Element_Count__c, Send_to_myKVH_Physical__c, BillingCountry FROM Account];
		return acctList;
	}
	static List<Product2> getProductList() {
		List<Product2> prodList = new List<Product2>();
		prodList = [SELECT Id, Name, KVH_Product_Family__c FROM Product2];
		return prodList;
	}
	static List<KVH_Product_Family__c> getFamilyList(){
		List<KVH_Product_Family__c> famList = new List<KVH_Product_Family__c>();
		famList = [SELECT Id, Name, FCP_Element_Type__c FROM KVH_Product_Family__c WHERE Name = 'Terminal' LIMIT 1];
		return famList;
	}
	
	
	/* Test data setup complete */

    static testMethod void TestUpdateElementCounts() {
        // TO DO: implement unit test
        system.debug('Invoking: TestUpdateElementCounts');
        //need a terminal asset, on a platform
        //ARRANGE
        Account testPlatform = testAcctList[0];        
        list<Asset> testAssetList = new Asset[MAX_LIST_SIZE];
        integer counter = 0;
    	while (counter < MAX_LIST_SIZE){
    		Asset testAsset = new Asset();
    		testAsset.Name = 'Test Asset not a terminal ' + counter;
    		testAsset.AccountId = testPlatform.Id;
			testAsset.Product2Id = testProdList[counter].Id;
    		if (math.mod(counter, 3) == 0){						//Should be 0, 3, 6, and 9.. yes? so testProdList[3], [6], and [9] are terminals
    			testAsset.Name = 'Test TERMINAL ' + counter;	//overwrite name
    		}
    		testAssetList.set(counter, testAsset);						//want to control index positions!
    		counter++; 
    	}
    	//ASSERT 		 
    	system.assertEquals(null, testPlatform.myKVH_Element_Count__c);		//Make sure that the new Account has no send flag
    	system.assertEquals(false, testPlatform.Send_to_myKVH_Physical__c);	//Make sure that the new Account has an Element Count of 0
    	
    	//ARRANGE
    	insert testAssetList;												//insert the test Assets 
    	//ACT
    	myKVHElementCount.UpdateElementCounts(testAssetList);				//Invoke the code (maybe a trigger does this someday)
        testAcctList = getAccountList();									//refresh the Account data
        testPlatform = testAcctList[0];										//refresh our test Account
        //ASSERT
        system.assertEquals(4, testPlatform.myKVH_Element_Count__c);		//Make sure that the account is updated now that the it has Terminals
        system.assert(testPlatform.Send_to_myKVH_Physical__c);				//Make sure that the Flag is set too
    }
}