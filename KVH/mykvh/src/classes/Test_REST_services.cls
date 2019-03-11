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
private class Test_REST_services {
	
	static {
		//Need an Account, Contract, Asset, and a Contracted Service...
		Account testAcct1 = new Account(Name = 'testAcct1');
		Insert testAcct1;
		testAcct1 = [SELECT Id, Name FROM Account WHERE name =: 'testAcct1' LIMIT 1];
		
		Contract testContract = new Contract(AccountId = testAcct1.id, Status = 'Draft', StartDate = date.today(), ContractTerm = 12);
		insert testContract;
		testContract = [SELECT Id, Name FROM Contract WHERE AccountId =:testAcct1.Id LIMIT 1];
		
		//Need KVH_Product_Family for Asset
		KVH_Product_Family__c testProdFamily = new KVH_Product_Family__c(Name = 'IP Address', FCP_Element_Type__c = 'Terminal');
		insert testProdFamily;
		testProdFamily = [SELECT id, Name, FCP_Element_Type__c FROM KVH_Product_Family__c WHERE Name = 'IP Address' LIMIT 1];
		
		//Need Product2 for Asset
		Product2 testProduct = new Product2(Name = 'IP Address', KVH_Product_Family__c = testProdFamily.Id);
		insert testProduct;
		testProduct = [SELECT id, Name FROM Product2 WHERE Name = 'IP Address' LIMIT 1];
		
		//Need Asset for test
		Asset testAsset = new Asset(Name = 'Test Asset', Product2ID = testProduct.Id, AccountID = testAcct1.Id);
		insert testAsset;
		testAsset = [SELECT Id, Name FROM Asset WHERE Name = 'Test Asset' LIMIT 1];
		
		//NOW we can make a Contracted Service!
		Contracted_Services__c testService = new Contracted_Services__c(Name = 'Test Service', Contract__c = testContract.Id, Asset__c = testAsset.id);
		insert testService;
	}

    static testMethod void testDoGet() {
        // TO DO: implement unit test
		//string instance = 'https://cs9.'; //ServCloud Sandbox
		//string instance = 'https://na13.'; //Production
		string instance = ''; //empty string to replace instance....
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		 
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/services/';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		//test to ensure that an API call with no Record ID returns an empty list
		List<Contracted_Services__c> Services = new List<Contracted_Services__c>();
		Services = REST_services.doGet();
		System.assert(Services.isEmpty());
		
		//reset
		Services.Clear();
		//test to ensure that we do get a record back from a proper API call
		Contracted_Services__c testService = new Contracted_Services__c();
		testService = [SELECT Id, Name FROM Contracted_Services__c WHERE Name = 'Test Service' LIMIT 1];
		system.debug(testService);
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/services/' + testService.Id;
		system.debug(req.requestURI);
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		Services = REST_services.doGet(); //careful here.... case sensitive!
		system.debug(res.statusCode);
		Integer size = Services.size();
		system.debug(size);
		system.assertEquals(size, 1);
    }
}