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
private class testAssetTrigger {
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
    	List<Product2> testProdList = new List<Product2>();
    	integer counter = 0;
    	while (counter < MAX_LIST_SIZE){
    		Product2 p = new Product2();
    		p.Name = 'Test Product ' + counter;
    		if (math.mod(counter, 3) == 0){			//Should be 3, 6, and 9.. yes?
    			p.KVH_Product_Family__c = fam.Id;
    		}
    		testProdList.add(p);
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
	}/* Test data setup complete */
	
	/* Start of Unit Test Methods */
	//Try inserting a whole boatload of Assets! 
	static testMethod void InsertManyRootAssets(){
    	List<Asset> AssetList = new List<Asset>();
    	for (Integer j = 0; j < 10; j++){
    		Asset a1 = new Asset();
    		a1.Name = 'Test Asset ' + j;
    		a1.AccountId = testAcctList[0].Id;
    		a1.Product2Id = testProdList[0].Id;
    		AssetList.Add(a1);
    	}
    	system.assertEquals(10, AssetList.size());
    	insert AssetList;
    }
	
	//Try inserting a few Child Assets
	// NOTE: An improved unit test might utilize a Hierarchical structure consisting of
	// more than two levels. This would exercise the Asset Hierarchy Engine more vigorously
	// 
	static testMethod void testAssetTriggerFrameworkChildInsert(){
    	system.debug('testAssetTriggerFrameworkChildInsert : STARTING TEST');
    	Asset testRootAsset = new Asset();						//Need one Root Asset
    	testRootAsset.Name = 'Test Root Asset';					//Conveniently named...
    	testRootAsset.AccountId = testAcctList[0].Id;			//Note: testAcct[0]!
    	testRootAsset.Product2Id = testProdList[0].Id;			//needs any Product
    	insert testRootAsset;									//Insert record, (trigger fires!) now we have an Id!
    	system.debug(testRootAsset);							//for the non-beleivers!
    	
    	Integer LoopController = 10;							//This value can be adjusted for performance testing
    	List<Asset> childAssetList = new List<Asset>();			//We are going to insert a bunch of Child Assets
    	for (Integer j = 0; j < LoopController; j++){			//like ~200 would be nice! (Use LoopController)
    		Asset testChildAsset = new Asset();					
    		testChildAsset.Name = 'Test Child Asset ' + j;		//Conveniently named..
    		testChildAsset.AccountId = testAcctList[1].Id;		//NOTE!! Different Account than the Parent Asset! (trigger fixes this!)
    		testChildAsset.Product2Id = testProdList[1].Id;		//any old product...
    		testChildAsset.Parent_Asset__c = testRootAsset.Id;	//this makes it a child Asset
    		childAssetList.add(testChildAsset);					//add it to the list....
    	}
		insert childAssetList;									//Jam them into the DB (trigger fires!)
		//refresh testChildAsset List (should still be 200!)
    	childAssetList = [SELECT Id, AccountId, Name, Parent_Asset__c, Parent_Asset__r.AccountId, Root_Asset__c FROM Asset WHERE Name Like 'Test Child Asset%'];		
		system.assertEquals(LoopController, childAssetList.size());					//Verify we got the right number of Assets back
		for (Asset a : childAssetList){
			system.assertEquals(testRootAsset.AccountId, a.AccountId);	//Verify that the new Asset assumed their Parent's Account...
			system.assertEquals(testRootAsset.Id, a.Root_Asset__c);		//Verify that the Root Asset field is correctly populated...
		}
    }

    static testMethod void testAssetTriggerFrameworkSystemUpdate(){
    	system.debug('testAssetTriggerFrameworkSystemUpdate : STARTING TEST');
    	List<Asset> AssetsToInsert = new List<Asset>();			//Use List insert to conserver DML and SOQL
    	
    	Asset testRootAsset = new Asset();						//Need one Root Asset
    	testRootAsset.Name = 'Test Root Asset';					//Conveniently named...
    	testRootAsset.AccountId = testAcctList[0].Id;			//Note: testAcct[0]!
    	testRootAsset.Product2Id = testProdList[0].Id;			//needs any Product
    	insert testRootAsset;									//Insert record, (trigger fires!) now we have an Id!
    	system.debug(testRootAsset);							//for the non-beleivers!
    	
    	Asset testChildAsset = new Asset();					
    	testChildAsset.Name = 'Test Child Asset ';				//Conveniently named..
    	testChildAsset.AccountId = testAcctList[1].Id;			//NOTE!! Different Account than the Parent Asset! (trigger fixes this!)
    	testChildAsset.Product2Id = testProdList[2].Id;			//make sure its an FCP Element
    	testChildAsset.Parent_Asset__c = testRootAsset.Id;		//this makes it a child Asset
    	AssetsToInsert.add(testChildAsset);						//Add to list of records to insert....
    	system.debug(testChildAsset);							//for the non-beleivers!
    	
    	Asset testRootAsset2 = new Asset();						//Need another Root Asset
    	testRootAsset2.Name = 'Test Root Asset 2';				//Conveniently named...
    	testRootAsset2.AccountId = testAcctList[2].Id;			//Note: testAcct[2]!
    	testRootAsset2.Product2Id = testProdList[5].Id;			//Use a different Product, but an FCP element
    	AssetsToInsert.add(testRootAsset2);						//Add to list of records to insert....
    	system.debug(testRootAsset2);							//for the non-beleivers!
    	insert AssetsToInsert;
    	
    	testRootAsset2.Parent_Asset__c = testChildAsset.Id;			//Make it a child
    	testRootAsset2.Name = 'Test Root Asset 2 is now a Grandchild';	//We can rename it...
    	update testRootAsset2;
    	
    	testRootAsset2 = [SELECT Id, Name, Root_Asset__c, AccountId FROM Asset WHERE Id =: testRootAsset2.Id];		//refesh the Asset
    	system.assertEquals(testRootAsset.Id, testRootAsset2.Root_Asset__c);							//verify that the Root cascaded down!
    	system.assertEquals(testRootAsset.AccountId, testRootAsset2.AccountId);							//verify that the Account cascaded down!
    }
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
    
    static testMethod void testDelete(){
    	Integer LoopController = 3;								//This value can be adjusted for performance testing
    	List<Asset> childAssetList = new List<Asset>();			//We are going to insert a few of Child Assets
    	for (Integer j = 0; j < LoopController; j++){			//like ~200 would be nice! (Use LoopController)
    		Asset testChildAsset = new Asset();					
    		testChildAsset.Name = 'Test Child Asset ' + j;		//Conveniently named..
    		testChildAsset.AccountId = testAcctList[j].Id;		//NOTE!! Different Account than the Parent Asset! (trigger fixes this!)
    		testChildAsset.Product2Id = testProdList[j].Id;		//any old product...NOTE ONLY testProduct[0], 3, 6, 9  is an FCP Element and critical when it comes to Before Delete!
    		childAssetList.add(testChildAsset);					//add it to the list....
    	}
    	insert childAssetList;
    	
    	delete childAssetList;									//ONLY the Asset based on testProdList[2] should create a myKVH_Deleted_Records__c!
    															//This Asset is name 'Test Child Asset 2'...
    	List<myKVH_Deleted_Records__c> DEL_Assets = new List<myKVH_Deleted_Records__c>();
    	DEL_Assets = [SELECT Id, Name, Object_Type__c FROM myKVH_Deleted_Records__c];
    	system.assertEquals(1, DEL_Assets.size());
    	system.assertEquals('Terminal', DEL_Assets[0].Object_Type__c);
    	system.assertEquals('Test Child Asset 0', DEL_Assets[0].Name);
    }
    
	static testMethod void testBaaNIntegrationAccounts() {
		// setup custom settings....
		List<DefaultAccounts__c> DefAccts = new List<DefaultAccounts__c>();
		DefaultAccounts__c OneDefAcct = new DefaultAccounts__c();
		OneDefAcct.Name = 'DefaultAssets';					//setup DefaultAssets default Account
		OneDefAcct.Account_ID__c = testAcctList[1].Id;
		OneDefAcct.Description__c = 'Default Assets Account';
    	DefAccts.Add(OneDefAcct);
    	OneDefAcct = new DefaultAccounts__c();				//reset
    	OneDefAcct.Name = 'KVHEurope';						//setup KVHEurope default Account
		OneDefAcct.Account_ID__c = testAcctList[2].Id;
		OneDefAcct.Description__c = 'Activations In Progress Account';
    	DefAccts.Add(OneDefAcct);
    	insert DefAccts;
    	
    	// Users are metadata, let's choose Charlie (this will break when he retires!)
		User u1 = [SELECT Id FROM User WHERE Alias='chalp']; //Charlie Halpin 
		System.RunAs(u1) {
       
           System.debug('Test class run under user Charlie: ' +u1.Id);
           
           List<Asset> newUpdtdAsset = new List<Asset>();
           
           Asset ast1 = new Asset();
           ast1.Name = 'TESTASSET';
           ast1.AccountId = testAcctList[2].Id;			//Starts with KE default Account....
           ast1.Item__c = '01-0115';
           ast1.Asset_ID__c = '01-0115_US_TESTASSET';
           ast1.InstallDate = date.today();
           
           newUpdtdAsset.add(ast1);
           insert newUpdtdAsset;						// so Charlie insert the Asset....
           System.debug('New Asset Added: ' + newUpdtdAsset);
           
           ast1 = [SELECT Id, Name, AccountId FROM Asset WHERE Asset_ID__c = '01-0115_US_TESTASSET'];		//refresh Asset
           system.assertEquals(ast1.AccountId, testAcctList[2].Id);
           
           //Now when Charlie changes the Asset.AccountID we need to make sure that the Account really changes!
           newUpdtdAsset.clear();					//reset...
           ast1.AccountId = testAcctList[0].Id;		// NOT a KVH Default Account!!
           newUpdtdAsset.add(ast1);
           update newUpdtdAsset;
           ast1 = [SELECT Id, Name, AccountId FROM Asset WHERE Asset_ID__c = '01-0115_US_TESTASSET'];		//refresh Asset
           system.assertEquals(ast1.AccountId, testAcctList[0].Id);											//Account should not change!
		}
		
		User u2 = [SELECT Id FROM User WHERE Alias='KVHAdmin'];  //00530000004UxCsAAK - KVH Admin ID
		System.RunAs(u2) {
      
           System.debug('Test class run under user KVHAdmin: ' +u2.Id);
           OneDefAcct = DefaultAccounts__c.getInstance('DefaultAssets');		//Get Custom Setting with Account Id...
           Asset ast1 = new Asset();
           List<Asset> newUpdtdAsset1 = new List<Asset>();
           
           List<Asset> recordNeed2Update = [SELECT Id, AccountId, Name, Created_By_Integration__c, InstallDate FROM Asset 
                                            WHERE Asset_ID__c = '01-0115_US_TESTASSET' ]; // 
                                            
            for (Asset a : recordNeed2Update) {
				System.debug('TEST Asset ID: ' +a.Id);
				System.debug('TEST Asset AccountId: '+a.AccountId);
				System.debug('TEST Asset Name: '+a.Name);
				System.debug('TEST Asset Created By Integration: '+a.Created_By_Integration__c);
				System.debug('TEST Asset Install Date: '+a.InstallDate);
                
				a.Created_By_Integration__c = true;
				a.AccountId = OneDefAcct.Account_ID__c;         //KVH Default Assets, aka testAcctList[1].Id;
				newUpdtdAsset1.add(a);
            }
            update newUpdtdAsset1;
            //Now we need to assert that when KVH Admin makes an Asset Update, AND the Asset's Account is something other than
            // the KVH Default Assets Account, that it doesn't overwrite the Account ID (because someone in Support already made it correct!)
           ast1 = [SELECT Id, Name, AccountId FROM Asset WHERE Asset_ID__c = '01-0115_US_TESTASSET'];		//refresh Asset
           system.assertEquals(ast1.AccountId, testAcctList[0].Id);											//Account should not change!
		}
	}
}