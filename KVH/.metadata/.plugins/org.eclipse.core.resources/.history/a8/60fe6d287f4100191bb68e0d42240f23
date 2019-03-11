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
private class test_REST_mediasrvr {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        // Need to generate a few Media Server Configs.... 
        // First, test GETs with no records.... should get 404s
		//string instance = 'https://cs16.'; //ServCloud Sandbox... kind of irrelevant for this test
		//string instance = 'https://na13.'; //Production
		//Create Account... need a test Account for Asset Creations (via Trigger...)
        Account testAcct = new Account();
        testAcct.Name = 'KVH Default test Acct';
        insert testAcct;
        //Need some products to base the Assets on...
        List<String> partNums = new List<String>{'02-2104','02-2103-01','02-2103'};
        List<Product2> Parts = new List<Product2>();
        for (string s : partNums) {
        	Product2 p = new Product2();
        	p.Name = s;
        	p.ProductCode = s;
        	p.Product_ID__c = s + '_US';
        	Parts.add(p);
        }
        insert Parts;
        
		string instance = ''; //empty string to replace instance....
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		List<REST_mediasrvr.hostNames> hostList = new List<REST_mediasrvr.hostNames>();
		
		
		//OK First test is to request ALL with no records in the system....
		hostList.clear();
		//test to ensure an API call with ALL returns all Media Servers
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/mediasrvrs/all';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		hostList = REST_mediasrvr.doGet();
		system.assertEquals(0, hostList.size());
		system.assertEquals(404, res.statuscode);
		
		//OK now test is to request a bogus serial number....
		hostList.clear();
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/mediasrvrs/140700000';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		hostList = REST_mediasrvr.doGet();
		system.assertEquals(0, hostList.size());
		system.assertEquals(404, res.statuscode);
		
		//OK now test a missing resource identifier....
		hostList.clear();
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/mediasrvrs';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		hostList = REST_mediasrvr.doGet();
		system.assertEquals(0, hostList.size());
		system.assertEquals(400, res.statuscode);
		
		//OK now lets insert a new record.....
		hostList.clear();
		//going to need a payload class for the response...
		//REST_mediasrvr.resultCode rc = new REST_mediasrvr.resultCode(false, 'initialization');		//init result code for Payload class
		REST_API_utilities.resultCode rc = new REST_API_utilities.resultCode();		//trying a no parameter constructor 
		REST_mediasrvr.payload p = new REST_mediasrvr.payload(rc,null);	//init Payload class....
		
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/mediasrvrs';
		req.httpMethod = 'POST';
		map<string, string> BodyMap = new map<String, String>();
		BodyMap.put('SerialNumber', '140700001');
		BodyMap.put('PartNumber', '02-2103-01');
		String Body = JSON.serialize(BodyMap);
		req.requestBody = Blob.valueOf(Body);
		RestContext.request = req;
		RestContext.response = res;
		p = REST_mediasrvr.doPost('140700001', '02-2103-01');
		system.debug(p);
		system.assertEquals(true, p.resultCode.success);
		system.assertEquals(200, res.statuscode);
		
		//OK now lets insert a duplicate record, this tests for duplicate Asset ID
		hostList.clear();
		//going to need a payload class for the response...
		rc = new REST_API_utilities.resultCode(false, 'initialization');		//init result code for Payload class
		p = new REST_mediasrvr.payload(rc,null);	//init Payload class....
		
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/mediasrvrs';  
		req.httpMethod = 'POST';
		BodyMap = new map<String, String>();
		BodyMap.put('SerialNumber', '140700001');
		BodyMap.put('PartNumber', '02-2103-01');
		Body = JSON.serialize(BodyMap);
		req.requestBody = Blob.valueOf(Body);
		RestContext.request = req;
		RestContext.response = res;
		p = REST_mediasrvr.doPost('140700001', '02-2103-01');
		system.assertEquals(false, p.resultCode.success);
		system.assertEquals('Found 1 Existing Assets for 140700001 ! Cannot issue Identifiers!', p.resultCode.exceptionMessage);
		system.debug(p);
		system.assertEquals(300, res.statuscode);
		
		//OK now test is to request ALL with one record in the system....
		hostList.clear();
		//test to ensure an API call with ALL returns all Media Servers
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/mediasrvrs/all';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		hostList = REST_mediasrvr.doGet();
		system.assertEquals(1, hostList.size());
		system.assertEquals(200, res.statuscode);
		
		//Now test for duplicate Media Server
		hostList.clear();
		//going to need a payload class for the response...
		rc = new REST_API_utilities.resultCode(false, 'initialization');		//init result code for Payload class
		p = new REST_mediasrvr.payload(rc,null);	//init Payload class....
		
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/mediasrvrs';  
		req.httpMethod = 'POST';
		BodyMap = new map<String, String>();
		BodyMap.put('SerialNumber', '140700001');
		BodyMap.put('PartNumber', '02-2103-01');
		Body = JSON.serialize(BodyMap);
		req.requestBody = Blob.valueOf(Body);
		RestContext.request = req;
		RestContext.response = res;
		p = REST_mediasrvr.doPost('140700001', '02-2103-01');
		system.assertEquals(false, p.resultCode.success);
		system.assertEquals('Found 1 Existing Assets for 140700001 ! Cannot issue Identifiers!', p.resultCode.exceptionMessage);
		system.debug(p);
		system.assertEquals(300, res.statuscode);
		
		//TEST PATCH with no serial number
		hostList.clear();
		//going to need a payload class for the response...
		rc = new REST_API_utilities.resultCode(false, 'initialization');		//init result code for Payload class
		p = new REST_mediasrvr.payload(rc,null);	//init Payload class....
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/mediasrvrs';  
		req.httpMethod = 'PATCH';
		BodyMap = new map<String, String>();
		BodyMap.put('SerialNumber', '');
		BodyMap.put('PartNumber', '02-2103-01');
		Body = JSON.serialize(BodyMap);
		RestContext.request = req;
		RestContext.response = res;
		p = REST_mediasrvr.doPatch('', '02-2103-01');
		system.assertEquals(false, p.resultCode.success);
		system.assertEquals('Hardware Serial Number cannot be NULL for PATCH', p.resultCode.exceptionMessage);
		system.debug(p);
		
		//TEST PATCH with no Part number
		hostList.clear();
		//going to need a payload class for the response...
		rc = new REST_API_utilities.resultCode(false, 'initialization');		//init result code for Payload class
		p = new REST_mediasrvr.payload(rc,null);	//init Payload class....
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/mediasrvrs';  
		req.httpMethod = 'PATCH';
		BodyMap = new map<String, String>();
		BodyMap.put('SerialNumber', '140700001');
		BodyMap.put('PartNumber', '');
		Body = JSON.serialize(BodyMap);
		RestContext.request = req;
		RestContext.response = res;
		p = REST_mediasrvr.doPatch('140700001', '');
		system.assertEquals(false, p.resultCode.success);
		system.assertEquals('Hardware Part Number cannot be NULL for PATCH', p.resultCode.exceptionMessage);
		system.debug(p);
		
		//TEST PATCH with incorrect Part number
		hostList.clear();
		//going to need a payload class for the response...
		rc = new REST_API_utilities.resultCode(false, 'initialization');		//init result code for Payload class
		p = new REST_mediasrvr.payload(rc,null);	//init Payload class....
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/mediasrvrs';  
		req.httpMethod = 'PATCH';
		BodyMap = new map<String, String>();
		BodyMap.put('SerialNumber', '140700001');
		BodyMap.put('PartNumber', 'zz-zzzz-zz');
		Body = JSON.serialize(BodyMap);
		RestContext.request = req;
		RestContext.response = res;
		p = REST_mediasrvr.doPatch('140700001', 'zz-zzzz-zz');
		system.assertEquals(false, p.resultCode.success);
		system.assertEquals('Problem with Hardware Part Number', p.resultCode.exceptionMessage);
		system.debug(p);
		
		//TEST PATCH with incorrect serial number
		hostList.clear();
		//going to need a payload class for the response...
		rc = new REST_API_utilities.resultCode(false, 'initialization');		//init result code for Payload class
		p = new REST_mediasrvr.payload(rc,null);	//init Payload class....
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/mediasrvrs';  
		req.httpMethod = 'PATCH';
		BodyMap = new map<String, String>();
		BodyMap.put('SerialNumber', '140799999');
		BodyMap.put('PartNumber', '02-2103-01');
		Body = JSON.serialize(BodyMap);
		RestContext.request = req;
		RestContext.response = res;
		p = REST_mediasrvr.doPatch('140799999', '02-2103-01');
		system.assertEquals(false, p.resultCode.success);
		system.assertEquals('Hardware Serial was not found in Media Server Config records', p.resultCode.exceptionMessage);
		system.debug(p);
		
		//delete the corresponding Asset..
		Asset dupeAsset = new Asset();
		dupeAsset = [SELECT Id, Name, AccountId, Product2.ProductCode, SerialNumber FROM Asset WHERE SerialNumber = '140700001'];
		delete dupeAsset;
		//TEST PATCH with missing Asset Serial Number
		hostList.clear();
		//going to need a payload class for the response...
		rc = new REST_API_utilities.resultCode(false, 'initialization');		//init result code for Payload class
		p = new REST_mediasrvr.payload(rc,null);	//init Payload class....
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/mediasrvrs';  
		req.httpMethod = 'PATCH';
		BodyMap = new map<String, String>();
		BodyMap.put('SerialNumber', '140700001');
		BodyMap.put('PartNumber', '02-2103-01');
		Body = JSON.serialize(BodyMap);
		RestContext.request = req;
		RestContext.response = res;
		p = REST_mediasrvr.doPatch('140700001', '02-2103-01');
		system.assertEquals(false, p.resultCode.success);
		system.assertEquals('Hardware Serial Number was not found in Asset records', p.resultCode.exceptionMessage);
		system.debug(p);
		
		//insert two assets with duplicate serial numbers
		dupeAsset.id=null;
		insert dupeAsset;
		dupeAsset.id=null;
		insert dupeAsset;
		//TEST PATCH with duplicate Asset serial number
		hostList.clear();
		//going to need a payload class for the response...
		rc = new REST_API_utilities.resultCode(false, 'initialization');		//init result code for Payload class
		p = new REST_mediasrvr.payload(rc,null);	//init Payload class....
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/mediasrvrs';  
		req.httpMethod = 'PATCH';
		BodyMap = new map<String, String>();
		BodyMap.put('SerialNumber', '140700001');
		BodyMap.put('PartNumber', '02-2103-01');
		Body = JSON.serialize(BodyMap);
		RestContext.request = req;
		RestContext.response = res;
		p = REST_mediasrvr.doPatch('140700001', '02-2103-01');
		system.assertEquals(false, p.resultCode.success);
		system.assertEquals('Found 2 Existing Assets for 140700001 ! Cannot make updates!', p.resultCode.exceptionMessage);
		system.debug(p);
		
		//TEST PATCH with duplicate hardware serial number
		//Salesforce prevents duplicate hardware serial numbers... cannot test code path.
		
		//delete one of the assets
		delete dupeAsset;
		//TEST PATCH with the correct serial number....
		hostList.clear();
		//going to need a payload class for the response...
		rc = new REST_API_utilities.resultCode(false, 'initialization');		//init result code for Payload class
		p = new REST_mediasrvr.payload(rc,null);	//init Payload class....
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/mediasrvrs';  
		req.httpMethod = 'PATCH';
		BodyMap = new map<String, String>();
		BodyMap.put('SerialNumber', '140700001');
		BodyMap.put('PartNumber', '02-2104');
		Body = JSON.serialize(BodyMap);
		RestContext.request = req;
		RestContext.response = res;
		p = REST_mediasrvr.doPatch('140700001', '02-2104');
		system.assertEquals(true, p.resultCode.success);
		system.assertEquals('', p.resultCode.exceptionMessage);
		system.debug(p);
		
    }
}