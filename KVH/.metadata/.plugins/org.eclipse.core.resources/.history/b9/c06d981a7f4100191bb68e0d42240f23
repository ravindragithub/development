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
private class Test_REST_elements {

	static {
		//test data
		//Need Account for Asset
		Account testAcct1 = new Account(Name = 'testAcct1');
		Insert testAcct1;
		testAcct1 = [SELECT Id, Name FROM Account WHERE name =: 'testAcct1' LIMIT 1];
		
		//Need KVH_Product_Family for Asset
		KVH_Product_Family__c testProdFamily = new KVH_Product_Family__c(Name = 'IP Address', FCP_Element_Type__c = 'Terminal');
		insert testProdFamily;
		testProdFamily = [SELECT id, Name, FCP_Element_Type__c FROM KVH_Product_Family__c WHERE Name = 'IP Address' LIMIT 1];
		
		//Need Product2 for Asset positive tests
		Product2 testProduct = new Product2(Name = 'IP Address', KVH_Product_Family__c = testProdFamily.Id);
		insert testProduct;
		testProduct = [SELECT id, Name FROM Product2 WHERE Name = 'IP Address' LIMIT 1];
		
		//Need Product2 for Asset negative tests
		Product2 testProduct2 = new Product2(Name = 'not an element');
		insert testProduct2;
		testProduct2 = [SELECT id, Name FROM Product2 WHERE Name = 'not an element' LIMIT 1];
		
		//Need Asset for positive test
		Asset testAsset = new Asset(Name = 'Test Asset', Product2ID = testProduct.Id, AccountID = testAcct1.Id);
		insert testAsset;
		
		//Need Asset for negative test
		Asset testAsset2 = new Asset(Name = 'Test Asset2', Product2ID = testProduct2.Id, AccountID = testAcct1.Id);
		insert testAsset2;

		
	}
    static testMethod void testDoGet() {
		// TO DO: implement unit test
		//string instance = 'https://cs9.'; //ServCloud Sandbox
		//string instance = 'https://na13.'; //Production
		string instance = ''; //empty string to replace instance....
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		//This test Class doesn't even really use a request URI... it calls the REST class directly
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/elements/';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		//test to ensure an API call with no record ID returns an empty list
		Integer size;
		Asset testAsset = new Asset();
		List<Asset> Elements = new List<Asset>();
		Elements = REST_elements.doGet();
		system.assertEquals(400, res.statuscode);
		System.assert(Elements.isEmpty());
		
		
		//reset
		Elements.Clear();
		//Test to ensure that a proper API call returns a single record
		testAsset = [SELECT Id, Name FROM Asset WHERE Name = 'Test Asset' LIMIT 1];
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/elements/' + testAsset.Id;  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		Elements = REST_elements.doGet();
		size = Elements.size();
		system.assertEquals(size, 1);
		
		//reset
		Elements.Clear();
		//Test to ensure that a proper API call returns a record NOTE: THIS Asset is not a Terminal!
		testAsset = [SELECT Id, Name FROM Asset WHERE Name = 'Test Asset2' LIMIT 1];
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/elements/' + testAsset.Id;  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		Elements = REST_elements.doGet();
		size = Elements.size();
		system.assertEquals(size, 1);
		
		//reset
		Elements.Clear();
		//Test to ensure that an API call for ALL returns only 1 record (only 1 terminal Asset!)
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/elements/all';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		Elements = REST_elements.doGet();
		size = Elements.size();
		system.assertEquals(size, 1);
		
		//reset
		Elements.Clear();
		//Test to ensure that an improper API call returns 0 records
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/elements/02i';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		Elements = REST_elements.doGet();
		size = Elements.size();
		system.assertEquals(404, res.statuscode);
		system.assertEquals(size, 0);
		
		//reset
		Elements.Clear();
		//Test to ensure that a improper API call returns a record
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/elements/001';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		Elements = REST_elements.doGet();
		size = Elements.size();
		system.assertEquals(400, res.statuscode);
		system.assertEquals(size, 0);
		
		//reset
		Elements.Clear();
		//Test to ensure that a Name Search API call returns a record
		req = new RestRequest(); 
		res = new RestResponse();
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/elements/search';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		req.addParameter('name', 'Test Asset');		//add the query parameter, since we are not really making an HTTP request...
		RestContext.response = res;
		Elements = REST_elements.doGet();
		size = Elements.size();
		system.assertEquals(size, 1);
		
		//reset
		Elements.Clear();
		//Test to ensure that a bogus Name Search API call returns no records
		req = new RestRequest(); 
		res = new RestResponse();
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/elements/search';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		req.addParameter('name', 'Test not an Asset');		//add the query parameter, since we are not really making an HTTP request...
		RestContext.response = res;
		Elements = REST_elements.doGet();
		size = Elements.size();
		system.assertEquals(size, 0);
		
		//reset
		Elements.Clear();
		testAsset = [SELECT Id, Name FROM Asset WHERE Name = 'Test Asset' LIMIT 1];
		delete testAsset;	//get rid of our one and only element
		//Test to ensure that a proper API call for ALL only returns terminals
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/elements/all';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		Elements = REST_elements.doGet();
		size = Elements.size();
		system.assertEquals(404, res.statuscode);
		system.assertEquals(size, 0);
    }
}