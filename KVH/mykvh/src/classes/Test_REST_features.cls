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
private class Test_REST_features {

    static testMethod void testGET() {
        // TO DO: implement unit test
        // First things first, test an 'all' request with no records... should return a 404 status code
        
		//string instance = 'https://cs14.'; //ServCloud Sandbox
		//string instance = 'https://na13.'; //Production
		string instance = ''; //empty string to replace instance....
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		//Need an instance of the Class we are calling
		REST_features myClass = new REST_features();
		// We need a list to receive the responses... we will reuse this over and over...
		List<myKVH_Feature__c> restFeatures = new List<myKVH_Feature__c>();
		
		//let's see if the "all" identifier returns the right number of features (should be zero with a status code of 404!)...
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/features/all';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		restFeatures = REST_features.doGet();
		System.assertequals(0, restFeatures.size());
		system.assertequals(404, res.statusCode);
        
        // Now we need a couple of Features to work with...
        myKVH_Feature__c testFeat1 = new myKVH_Feature__c(Name = 'testFeat1', isUpdateable__c = true, isReadable__c = true, isDeleteable__c = true, 
        							isCreateable__c = true, isBillable__c = false, hasFieldLevelSecurity__c = true, Status__c = 'Planned', 
        							Description__c = 'This is a test Description');
		insert testFeat1;
		testFeat1 = [SELECT Id, Name, isUpdateable__c, isReadable__c, isDeleteable__c, isCreateable__c, isBillable__c, 
									hasFieldLevelSecurity__c, Status__c, Description__c 
									FROM myKVH_Feature__c WHERE Name = 'testFeat1'];
									
		myKVH_Feature__c testFeat2 = new myKVH_Feature__c(Name = 'testFeat2', isUpdateable__c = true, isReadable__c = true, isDeleteable__c = true, 
        							isCreateable__c = true, isBillable__c = false, hasFieldLevelSecurity__c = true, Status__c = 'Planned', 
        							Description__c = 'This is a test Description for Feature 2');
		insert testFeat2;
		testFeat2 = [SELECT Id, Name, isUpdateable__c, isReadable__c, isDeleteable__c, isCreateable__c, isBillable__c, 
									hasFieldLevelSecurity__c, Status__c, Description__c 
									FROM myKVH_Feature__c WHERE Name = 'testFeat2'];
		
		//reset
		myClass = new REST_features();
		restFeatures.clear();
		//let's test the "no identifier" response. Should be zero records
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/features/';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		//test to ensure an API call with no record ID returns an empty list
		restFeatures = REST_features.doGet();
		System.assert(restFeatures.isEmpty());
		system.assertequals(400, res.statusCode);
		
		//reset
		myClass = new REST_features();
		restFeatures.clear();
		
		//let's see if the "all" identifier returns the right number of features...
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/features/all';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		restFeatures = REST_features.doGet();
		System.assertequals(2, restFeatures.size());
		
		//reset
		myClass = new REST_features();
		restFeatures.clear();
		//let's see if a specific identifier returns the right feature...
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/features/'+testFeat1.id;  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		restFeatures = REST_features.doGet();
		System.assertequals('testFeat1', restFeatures[0].Name);
		
		//reset
		myClass = new REST_features();
		restFeatures.clear();
		//let's see if an erroneous identifier returns a 404 status code...
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/features/'+'a1i000000000000001';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		restFeatures = REST_features.doGet();
		system.debug(res);
		system.assertequals(0, restFeatures.size());
		system.assertequals(404, res.statusCode);
		
		//reset
		myClass = new REST_features();
		restFeatures.clear();
		//let's see if an erroneous identifier prefix returns a 400 status code...
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/features/'+'a1j000000000000001';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		restFeatures = REST_features.doGet();
		system.debug(res);
		system.assertequals(0, restFeatures.size());
		system.assertequals(400, res.statusCode);
    }
    static testMethod void testPOST(){
		string instance = ''; //empty string to replace instance....
		//Need an instance of the Class we are calling
		REST_features myClass = new REST_features();
		//going to need a payload class for the response...
		REST_API_utilities.resultCode rc = new REST_API_utilities.resultCode();		//trying a no parameter constructor 
		REST_features.payload p = new REST_features.payload(rc,null);
		// We need a list to receive the responses... we will reuse this over and over...
		List<myKVH_Feature__c> restFeatures = new List<myKVH_Feature__c>();
		
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		RestContext.request = req;
		RestContext.response = res;
    	//OK, test an OK POST
    	req.requestURI = instance + 'salesforce.com/services/apexrest/V1/features';
		req.httpMethod = 'POST';
		map<string, string> BodyMap = new map<String, String>();
		BodyMap.put('Name', 'my_test_feature');
		BodyMap.put('Status', 'Planned');
		BodyMap.put('Decsription', 'This Feature is part of a Unit Test');
		String Body = JSON.serialize(BodyMap);
		req.requestBody = Blob.valueOf(Body);
		
		p = REST_features.doPost('my_test_feature', 'Planned', 'This Feature is part of a Unit Test');
		system.debug(p);
		system.assertEquals(true, p.resultCode.success);
		system.assertEquals(200, res.statuscode);
		system.assertEquals('my_test_feature', p.createdFeatures[0].Name);
		system.assertNotEquals(null, p.createdFeatures[0].Id);
		
    	//test a duplicate POST
		//going to need a payload class for the response...
		rc = new REST_API_utilities.resultCode(false, 'initialization');		//init result code for Payload class
		p = new REST_features.payload(rc,null);	//re-init Payload class....
		RestContext.request = req;
		RestContext.response = res;
    	req.requestURI = instance + 'salesforce.com/services/apexrest/V1/features';
		req.httpMethod = 'POST';
		BodyMap.clear();
		BodyMap.put('Name', 'my_test_feature');
		BodyMap.put('Status', 'Planned');
		BodyMap.put('Decsription', 'This Feature is part of a Unit Test');
		Body = JSON.serialize(BodyMap);
		req.requestBody = Blob.valueOf(Body);
		
		p = REST_features.doPost('my_test_feature', 'Planned', 'This Feature is part of a Unit Test');
		system.debug(p);
		system.assertEquals(false, p.resultCode.success);
		system.assertEquals('A Feature Named ' + 'my_test_feature' + ' Already exists! Cannot Create Duplicate Feature!', p.resultCode.exceptionMessage);
		system.assertEquals(300, res.statuscode);
		system.assertEquals('my_test_feature', p.createdFeatures[0].Name);
		
    	//test a bogus Status field POST
    	//going to need a payload class for the response...
		rc = new REST_API_utilities.resultCode(false, 'initialization');		//init result code for Payload class
		p = new REST_features.payload(rc,null);	//re-init Payload class....
		RestContext.request = req;
		RestContext.response = res;
    	req.requestURI = instance + 'salesforce.com/services/apexrest/V1/features';
		req.httpMethod = 'POST';
		BodyMap.clear();
		BodyMap.put('Name', 'my_nonduplicate_feature');
		BodyMap.put('Status', 'Bogus');		//not a real status...
		BodyMap.put('Decsription', 'This Feature is part of a Unit Test');
		Body = JSON.serialize(BodyMap);
		req.requestBody = Blob.valueOf(Body);
		
		p = REST_features.doPost('my_nonduplicate_feature', 'Bogus', 'This Feature is part of a Unit Test');
		system.debug(p);
		system.assertEquals(false, p.resultCode.success);
		system.assert(p.resultCode.exceptionMessage.startsWith('Bogus' + ' is not a valid Status for features!'));
		system.assertEquals(400, res.statuscode);
		system.assertEquals(0, p.createdFeatures.size());
    }
}