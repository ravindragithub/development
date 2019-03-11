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
private class REST_elements_V3_test {
	/* typical testClass statics...*/
	static integer MAX_LOOP_COUNTER = 2;
	private static final Id Platform_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Demo/Test/Monitor').getRecordTypeId();
	private static final Profile PortalProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Portal%' Limit 1];
	private static final User adminUser = [SELECT Id, username FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
	private static Asset testElementPatch = new Asset();   //Account (no ID, for creating the JSON body for PATCH)
	
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
		
		Contact c = new Contact();
		c.LastName = 'REST API test Contact';
		c.email = 'test_rest_elements_v3@kvh.com';
		c.AccountId = testAcctList[0].ParentId;
		insert c;
		
		//Need KVH_Product_Family for Asset
		KVH_Product_Family__c testProdFamily = new KVH_Product_Family__c(Name = 'IP Address', FCP_Element_Type__c = 'Terminal');
		insert testProdFamily;
		
		//Need Product2 for Asset positive tests
		list<Product2> testProdList = new list<Product2>();
		Product2 testProduct = new Product2(Name = 'IP Address', KVH_Product_Family__c = testProdFamily.Id);
		testProdList.add(testProduct);
		//Need Product2 for Asset negative tests
		Product2 testProduct2 = new Product2(Name = 'not an element');
		testProdList.add(testProduct2);
		insert testProdList;
		
		//Need Asset for positive test
		list<asset> testAssetList2 = new list<Asset>();
		Account acct = [SELECT Id FROM Account WHERE Name = 'Test REST API 0' LIMIT 1];
		Asset testAsset = new Asset(Name = 'Test Asset', Product2ID = testProduct.Id, AccountID = acct.Id);
		testAssetList2.add(testAsset);
		//Need Asset for negative test
		Asset testAsset2 = new Asset(Name = 'Test Asset2', Product2ID = testProduct2.Id, AccountID = acct.Id);
		testAssetList2.add(testAsset2);
		insert testAssetList2;
		
		testElementPatch.User_Defined_System_Name__c = 'Test Frendly Name Patch';
		
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
		system.assertEquals(2, assetReadList.size());						//only 2 very deliberatly created Assets....
		//Test Products setup Correctly
		list<Product2> readProds = new list<Product2>();
		readProds = [SELECT Id, Name, KVH_Product_Family__c FROM Product2];
		system.assertEquals(2,readProds.size());
		//test Asset Setup Correctly
		list<Asset> readAssets = new list<Asset>();
		readAssets = [SELECT Id, Name, Product2ID, AccountID FROM Asset];
		system.assertEquals(2,readAssets.size());
		//test that KVH Product Family
		list<KVH_Product_Family__c> testProdFamilylist = [SELECT id, Name, FCP_Element_Type__c FROM KVH_Product_Family__c WHERE Name = 'IP Address'];
		system.assertEquals(1,testProdFamilylist.size());
	}

    static testMethod void testDoGet() {
		// TO DO: implement unit test
		string instance = 'https://cs65.'; //ServCloud Sandbox
		//string instance = 'https://na19.'; //Production
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		//This test Class doesn't even really use a request URI... it calls the REST class directly
		req.requestURI = instance + 'salesforce.com/services/apexrest/V3/elements/';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		//test to ensure an API call with no record ID returns an empty list
		Integer size;
		Asset testAsset = new Asset();
		List<Asset> Elements = new List<Asset>();
		Elements = REST_elements_V3.doGet();
		system.assertEquals(400, res.statuscode);
		System.assert(Elements.isEmpty());
		
		
		//reset
		Elements.Clear();
		//Test to ensure that a proper API call returns a single record
		testAsset = [SELECT Id, Name FROM Asset WHERE Name = 'Test Asset' LIMIT 1];
		req.requestURI = instance + 'salesforce.com/services/apexrest/V3/elements/' + testAsset.Id;  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		Elements = REST_elements_V3.doGet();
		size = Elements.size();
		system.assertEquals(size, 1);
		
		//reset
		Elements.Clear();
		//Test to ensure that a proper API call returns a single record, and patches the Root_Asset__c field
		system.debug('Test to ensure that a proper API call returns a single record, and patches the Root_Asset__c field');
		testAsset = [SELECT Id, Name, Root_Asset__c FROM Asset WHERE Name = 'Test Asset' LIMIT 1];
		testAsset.Root_Asset__c = null;
		update testAsset;
		req.requestURI = instance + 'salesforce.com/services/apexrest/V3/elements/' + testAsset.Id;  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		Elements = REST_elements_V3.doGet();
		size = Elements.size();
		system.assertEquals(size, 1);
		
		//reset
		Elements.Clear();
		//Test to ensure that a proper API call returns a record NOTE: THIS Asset is not a Terminal!
		testAsset = [SELECT Id, Name FROM Asset WHERE Name = 'Test Asset2' LIMIT 1];
		req.requestURI = instance + 'salesforce.com/services/apexrest/V3/elements/' + testAsset.Id;  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		Elements = REST_elements_V3.doGet();
		size = Elements.size();
		system.assertEquals(size, 1);
		
		//reset
		Elements.Clear();
		//Test to ensure that an API call for ALL returns only 1 record (only 1 terminal Asset!)
		req.requestURI = instance + 'salesforce.com/services/apexrest/V3/elements/all';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		Elements = REST_elements_V3.doGet();
		size = Elements.size();
		system.assertEquals(size, 1);
		
		//reset
		Elements.Clear();
		
		//Test to ensure that an improper API call returns 0 records
		req.requestURI = instance + 'salesforce.com/services/apexrest/V3/elements/02i000000000000000';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		Elements = REST_elements_V3.doGet();
		size = Elements.size();
		system.assertEquals(404, res.statuscode);
		system.assertEquals(size, 0);
		
		//reset
		Elements.Clear();
		//Test to ensure that a improper API call returns a record
		req.requestURI = instance + 'salesforce.com/services/apexrest/V3/elements/001';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		Elements = REST_elements_V3.doGet();
		size = Elements.size();
		system.assertEquals(400, res.statuscode);
		system.assertEquals(size, 0);
		
		//reset
		
		Elements.Clear();
		//Test to ensure that a Name Search API call returns a record
		req = new RestRequest(); 
		res = new RestResponse();
		req.requestURI = instance + 'salesforce.com/services/apexrest/V3/elements/search';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		req.addParameter('name', 'Test Asset');		//add the query parameter, since we are not really making an HTTP request...
		RestContext.response = res;
		Elements = REST_elements_V3.doGet();
		size = Elements.size();
		system.assertEquals(size, 1);
		
		//reset
		Elements.Clear();
		//Test to ensure that a bogus Name Search API call returns no records
		req = new RestRequest(); 
		res = new RestResponse();
		req.requestURI = instance + 'salesforce.com/services/apexrest/V3/elements/search';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		req.addParameter('name', 'Should not Find this Asset');		//add the query parameter, since we are not really making an HTTP request...
		RestContext.response = res;
		Elements = REST_elements_V3.doGet();
		size = Elements.size();
		system.assertEquals(size, 0);
		
		//reset
		Elements.Clear();
		//Test for duplicate Asset Names a Name Search API call returns a record
		list<Product2> readProds = [SELECT Id, Name, KVH_Product_Family__c FROM Product2 WHERE KVH_Product_Family__c != ''];
		Asset testAsset2 = [SELECT Id, Name FROM Asset WHERE Name = 'Test Asset2' LIMIT 1];
		testAsset2.Product2Id = readProds[0].Id;
		testAsset2.Name = 'Test Asset';
		Update testAsset2;							//Delibrately create a duplicate...
		req = new RestRequest(); 
		res = new RestResponse();
		req.requestURI = instance + 'salesforce.com/services/apexrest/V3/elements/search';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		req.addParameter('name', 'Test Asset');		//add the query parameter, since we are not really making an HTTP request...
		RestContext.response = res;
		Elements = REST_elements_V3.doGet();
		size = Elements.size();
		system.assertEquals(size, 2);
		
		//reset
		Elements.Clear();
		testAsset = [SELECT Id, Name FROM Asset WHERE Name = 'Test Asset' LIMIT 1];
		delete testAsset;	//get rid of our one and only element
		testAsset2.Product2Id = null;
		Update testAsset2;							//Make it NOT an Element
		//Test to ensure that a proper API call for ALL only returns terminals
		req = new RestRequest(); 
		res = new RestResponse();
		req.requestURI = instance + 'salesforce.com/services/apexrest/V3/elements/all';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		Elements = REST_elements_V3.doGet();
		size = Elements.size();
		system.assertEquals(404, res.statuscode);
		system.assertEquals(size, 0);
    }
    
    static testMethod void testContactSubResource(){
    	string instance = 'https://cs65.'; //ServCloud Sandbox
		//string instance = 'https://na19.'; //Production
    	Integer size;
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		//This test Class doesn't even really use a request URI... it calls the REST class directly
		Asset testAsset = [SELECT Id, Name FROM Asset WHERE Name = 'Test Asset' LIMIT 1];	//The Asset does not have a billing Account.... make sure that we get an empty List
		req.requestURI = instance + 'salesforce.com/services/apexrest/V3/elements/' + testAsset.Id + '/contact';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		List<Contact> mainContacts = new List<Contact>();
		mainContacts = REST_elements_V3.doGet();
		system.assertEquals(404, res.statuscode);
		System.assertEquals(mainContacts, null);

		//Need that Account, and The contact....
		//Make the Billing Account
		Account a = [SELECT id, Name FROM Account WHERE Name = 'Test REST API 0' LIMIT 1];
        Billing_Account__c ba = new Billing_Account__c();
        ba.Account__c = a.Id;
		ba.Billing_Account_ID__c = '6666';
		ba.Account_Effective_Date__c = Date.today();
		ba.Revenue_Category__c = 'VSAT';
		insert ba;
		//Test billing account OK, but no Airtime Main contact
		req = new RestRequest(); 
		res = new RestResponse();
		req.requestURI = instance + 'salesforce.com/services/apexrest/V3/elements/' + testAsset.Id + '/contact';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		mainContacts = REST_elements_V3.doGet();
		system.assertEquals(404, res.statuscode);
		System.assertEquals(mainContacts, null);	

		Contact con = [SELECT Id, email FROM Contact WHERE email = 'test_rest_elements_v3@kvh.com' LIMIT 1];
        ba.Main_Contact__c = con.Id;
        update ba;
        Contract agreement = new Contract();
        agreement.AccountId = a.Id;
        agreement.ContractTerm = 5;
        agreement.Billing_Account__c = ba.Id;
        agreement.StartDate = system.today();
        insert agreement;
        Product2 prod = new Product2();
        prod.name = 'test product';
        insert prod;
        SBQQ__Subscription__c sub = new SBQQ__Subscription__c();
        sub.SBQQ__Account__c = a.Id;
        sub.Asset__c = testAsset.Id;
        sub.SBQQ__Contract__c = agreement.Id;
        sub.SBQQ__Quantity__c = 1;
        sub.SBQQ__Product__c = prod.Id;
        insert sub;
        
		//Test that it actually works!!
		req = new RestRequest(); 
		res = new RestResponse();
		req.requestURI = instance + 'salesforce.com/services/apexrest/V3/elements/' + testAsset.Id + '/contact';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		mainContacts = REST_elements_V3.doGet();
        Contact maincontact = maincontacts[0];
		system.assertEquals('test_rest_elements_v3@kvh.com', maincontact.Email);
    }
    
    static testMethod void testdoPatch(){
        //Need a element_patch Class to generate a JSON body
        REST_elements_V3.element_patch patchBody = new REST_elements_V3.element_patch();
        patchBody.element_update_fields = testElementPatch;
        //Serialize the wrapper Class for the request..
        String JSONbody = JSON.serialize(patchBody);
        list<Asset> readElement = [SELECT Id, Name FROM Asset WHERE Name = 'Test Asset'];
        string identifier = readElement[0].Id;
        Test.startTest();
        string instance = 'https://cs65.'; //ServCloud Sandbox
        //string instance = 'https://na19.'; //Production
        //string instance = '';   //empty string to replace instance...
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        //setup the HTTP Request
        req.requestURI = instance + 'salesforce.com/services/apexrest/V3/elements/' + identifier;  
        req.httpMethod = 'PATCH';
        req.requestBody = Blob.valueOf(JSONbody);
        RestContext.request = req;
        RestContext.response = res;
        REST_elements_V3.elements_return PATCHresults = REST_elements_V3.doPatch(patchBody);
        system.assertEquals(true, PATCHresults.resultCode.success);
        system.assertEquals('', PATCHresults.resultCode.exceptionMessage);
        system.assertEquals(testElementPatch.User_Defined_System_Name__c, PATCHresults.system_name);
        test.stopTest();
    }
    static testMethod void testdoPatch_notFound(){
        //Need a element_patch Class to generate a JSON body
        REST_elements_V3.element_patch patchBody = new REST_elements_V3.element_patch();
        patchBody.element_update_fields = testElementPatch;
        //Serialize the wrapper Class for the request..
        String JSONbody = JSON.serialize(patchBody);
        list<Asset> readElement = [SELECT Id, Name FROM Asset WHERE Name = 'Test Asset'];
        string identifier = readElement[0].Id;
        delete readElement[0];                      //remove the asset to simulate a not found..
        Test.startTest();
        //string instance = 'https://cs9.'; //ServCloud Sandbox
        //string instance = 'https://na13.'; //Production
        string instance = '';   //empty string to replace instance...
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        //setup the HTTP Request
        req.requestURI = instance + 'salesforce.com/services/apexrest/V3/elements/' + identifier;  
        req.httpMethod = 'PATCH';
        req.requestBody = Blob.valueOf(JSONbody);
        RestContext.request = req;
        RestContext.response = res;
        REST_elements_V3.elements_return PATCHresults = REST_elements_V3.doPatch(patchBody);
        system.assertEquals(false, PATCHresults.resultCode.success);
        system.assertEquals('Element was not found with Id == ', PATCHresults.resultCode.exceptionMessage.left(33));
        system.assertEquals(testElementPatch.User_Defined_System_Name__c, PATCHresults.system_name);
        test.stopTest();
    }
    static testMethod void testdoPatch_nonAsset(){
        //Need a element_patch Class to generate a JSON body
        REST_elements_V3.element_patch patchBody = new REST_elements_V3.element_patch();
        patchBody.element_update_fields = testElementPatch;
        //Serialize the wrapper Class for the request..
        String JSONbody = JSON.serialize(patchBody);
        list<Asset> readElement = [SELECT Id, Name FROM Asset WHERE Name = 'Test Asset'];
        string identifier = '003000000000000000';
        Test.startTest();
        //string instance = 'https://cs9.'; //ServCloud Sandbox
        //string instance = 'https://na13.'; //Production
        string instance = '';   //empty string to replace instance...
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        //setup the HTTP Request
        req.requestURI = instance + 'salesforce.com/services/apexrest/V3/elements/' + identifier;  
        req.httpMethod = 'PATCH';
        req.requestBody = Blob.valueOf(JSONbody);
        RestContext.request = req;
        RestContext.response = res;
        REST_elements_V3.elements_return PATCHresults = REST_elements_V3.doPatch(patchBody);
        system.assertEquals(false, PATCHresults.resultCode.success);
        system.assertEquals('Not as Asset (Element) Id == ', PATCHresults.resultCode.exceptionMessage.left(29));
        system.assertEquals(testElementPatch.User_Defined_System_Name__c, PATCHresults.system_name);
        test.stopTest();
    }
}