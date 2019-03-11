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
private class REST_services_V2_test {
	@testSetup static void setupTestData(){
				//Need an Account, Contract, Asset, and a Contracted Service...
		Account testAcct1 = new Account(Name = 'testAcct1');
		Insert testAcct1;
		testAcct1 = [SELECT Id, Name FROM Account WHERE name =: 'testAcct1' LIMIT 1];
		
		Contract testContract = new Contract(AccountId = testAcct1.id, Status = 'Draft', StartDate = date.today(), ContractTerm = 12);
		insert testContract;
		testContract = [SELECT Id, Name FROM Contract WHERE AccountId =:testAcct1.Id LIMIT 1];
		
		//Need KVH_Product_Family for Service
		KVH_Product_Family__c testProdFam = new KVH_Product_Family__c(Name = 'IPMC Package');
        insert testProdFam;
		
		
		//Need Product2 for Service
		Product2 mockSVC1 = new Product2(name = 'mockSVC1', Airtime_Group__c = 'CBX', ProductCode = 'mockSVC1', KVH_Product_Family__c = testProdFam.Id, isActive = true);
		insert mockSVC1;
		mockSVC1 = [SELECT id, Name FROM Product2 WHERE Name = 'mockSVC1' LIMIT 1];
		
		//Need Product2 for Asset...
		Product2 mockCBX = new Product2(name = 'CBX LICENSE', Airtime_Group__c = 'CBX', ProductCode = 'CBX LICENSE',  isActive = true);
		insert mockCBX;
		
		//Need IPMC PAckage Kind...
		IPMC_Package_Kinds__c PK = new IPMC_Package_Kinds__c (PackageKind__c = 'fs.mock');
		insert PK;
		
		//Need PkgKind Map
		Package_Kinds_by_Product__c PKbP = new Package_Kinds_by_Product__c(IPMC_Package_Kind__c = PK.Id, Product__c = mockSVC1.Id);
		insert PKbP;
		
		//Need Asset for test
		Asset testAsset = new Asset(Name = 'Test Asset', Product2ID = mockCBX.Id, AccountID = testAcct1.Id);
		insert testAsset;
		testAsset = [SELECT Id, Name FROM Asset WHERE Name = 'Test Asset' LIMIT 1];
		
		//NOW we can make a Contracted Service!
		Contracted_Services__c testService = new Contracted_Services__c(Name = 'Test Service', 
																		service_item__c = mockSVC1.Id, 
																		Contract__c = testContract.Id, 
																		Asset__c = testAsset.id,
																		Terminated_Date__c = Date.Today());
		insert testService;
	}
	
    static testMethod void myUnitTest() {
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
		List<REST_services_V2.SvcDetail> Services = new List<REST_services_V2.SvcDetail>();
		Services = REST_services_V2.doGet();
		System.assert(Services.isEmpty());
		
		//reset
		Services.Clear();
		system.assertEquals(0, Services.size());
		//test to ensure that we do get a record back from a proper API call
		Contracted_Services__c testService = new Contracted_Services__c();
		testService = [SELECT Id, Name, Terminated_Date__c, Asset__r.Name FROM Contracted_Services__c WHERE Name = 'Test Service' LIMIT 1];
		system.debug(testService);
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/services/' + testService.Id;
		system.debug(req.requestURI);
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		Services = REST_services_V2.doGet(); //careful here.... case sensitive!
		system.debug(res.statusCode);
		Integer size = Services.size();
		system.debug(size);
		system.assertEquals(size, 1);
		system.assertEquals(Date.Today(), Services[0].Service.Terminated_Date__c);	//verify that we get a terminated Service back
		
		//reset
		Services.Clear();
		system.assertEquals(0, Services.size());
		//test Name search
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/services/search';
		req.addParameter('name', 'Test Asset');
		system.debug(req.requestURI);
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		Services = REST_services_V2.doGet(); //careful here.... case sensitive!
		system.debug(res.statusCode);
		system.assertEquals(1, Services.size());
		system.assertEquals(1, Services[0].PkgKinds.size());
		
		//reset
		Services.Clear();
		system.assertEquals(0, Services.size());
		//delete PkgKind mapping
		Package_Kinds_by_Product__c[] PKbP = [SELECT Id FROM Package_Kinds_by_Product__c];
		delete PKbP;
		//test Name search again... should be no PkgKinds
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/services/search';
		req.addParameter('name', 'Test Asset');
		system.debug(req.requestURI);
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		Services = REST_services_V2.doGet(); //careful here.... case sensitive!
		system.debug(res.statusCode);
		system.assertEquals(1, Services.size());
		system.assertEquals(null, Services[0].PkgKinds);
		
		
		//final test, delete the Contracted Service and ensure GET returns nothing
		delete testService;
		//Id query
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/services/' + testService.Id;
		system.debug(req.requestURI);
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		Services = REST_services_V2.doGet(); //careful here.... case sensitive!
		system.assertEquals(0, Services.size());
		//name search
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/services/search';
		req.addParameter('name', 'Test Asset');
		system.debug(req.requestURI);
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		Services = REST_services_V2.doGet(); //careful here.... case sensitive!
		system.assertEquals(0, Services.size());
		
    }
}