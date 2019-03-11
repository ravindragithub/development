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
private class test_REST_permissionset {
 
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
		// First things first, test an 'all' request with no records... should return a 404 status code
        
		//string instance = 'https://cs14.'; //ServCloud Sandbox
		//string instance = 'https://na13.'; //Production
		string instance = ''; //empty string to replace instance....
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		//Need an instance of the Class we are calling
		REST_permissionset myClass = new REST_permissionset();
		// We need a list to receive the responses... we will reuse this over and over...
		List<myKVH_Permission_Set__c> restPermissionSet = new List<myKVH_Permission_Set__c>();
		
		//let's see if the "all" identifier returns the right number of features (should be zero with a status code of 404!)...
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/permissionsets/all';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		restPermissionSet = REST_permissionset.doGet();
		System.assertequals(0, restPermissionSet.size());
		system.assertequals(404, res.statusCode);

		//Need a Role, and Feature
		//Two Roles
		myKVH_Role__c testRole1 = new myKVH_Role__c(Name = 'myKVH:testRole1', Description__c = 'This is a Test Description');
		insert testRole1;
		testRole1 = [SELECT id, Name, Description__c FROM myKVH_Role__c WHERE Name = 'myKVH:testRole1'];
		
		myKVH_Role__c testRole2 = new myKVH_Role__c(Name = 'myKVH:testRole2', Description__c = 'This is a Test Description');
		insert testRole2;
		testRole2 = [SELECT id, Name, Description__c FROM myKVH_Role__c WHERE Name = 'myKVH:testRole2'];
        //one Feature
        myKVH_Feature__c testFeat1 = new myKVH_Feature__c(Name = 'testFeat1', isUpdateable__c = true, isReadable__c = true, isDeleteable__c = true, 
        							isCreateable__c = true, isBillable__c = false, hasFieldLevelSecurity__c = true, Status__c = 'Planned', 
        							Description__c = 'This is a test Description');
		insert testFeat1;
		testFeat1 = [SELECT Id, Name, isUpdateable__c, isReadable__c, isDeleteable__c, isCreateable__c, isBillable__c, 
									hasFieldLevelSecurity__c, Status__c, Description__c 
									FROM myKVH_Feature__c WHERE Name = 'testFeat1'];
		//And now a couple of permission sets....
		myKVH_Permission_Set__c testPermSet1 = new myKVH_Permission_set__c(Name = 'testPermSet1', myKVH_Role__c = testRole1.Id, 
												myKVH_Feature__c = testFeat1.Id, canUpdate__c = true, canRead__c = true, 
												canDelete__c = true, canCreate__c = true);
		insert testPermSet1;
		testPermSet1 = [SELECT Id, Name, myKVH_Role__c, myKVH_Feature__c, canUpdate__c, canRead__c, canDelete__c, canCreate__c
						FROM myKVH_Permission_Set__c WHERE myKVH_Role__c =: testRole1.Id];
		/* Kind of need this one.... need to figure out the naming thing */
		myKVH_Permission_Set__c testPermSet2 = new myKVH_Permission_set__c(Name = 'testPermSet2', myKVH_Role__c = testRole2.Id, 
												myKVH_Feature__c = testFeat1.Id, canUpdate__c = true, canRead__c = true, 
												canDelete__c = true, canCreate__c = true);
		insert testPermSet2;
		testPermSet2 = [SELECT Id, Name, myKVH_Role__c, myKVH_Feature__c, canUpdate__c, canRead__c, canDelete__c, canCreate__c
						FROM myKVH_Permission_Set__c WHERE  myKVH_Role__c =: testRole2.Id];
		//reset
		myClass = new REST_permissionset();
		restPermissionSet.clear();
		req = new RestRequest(); 
		res = new RestResponse();
		//let's see if a proper identifier returns the right Permission Set...
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/permissionsets/' + testPermSet1.Id;  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		restPermissionSet = REST_permissionset.doGet();
		System.assertequals(1, restPermissionSet.size());

		//reset
		myClass = new REST_permissionset();
		restPermissionSet.clear();
		req = new RestRequest(); 
		res = new RestResponse();
		//let's see if a missing identifier returns the stuff...
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/permissionsets/';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		restPermissionSet = REST_permissionset.doGet();
		System.assertequals(0, restPermissionSet.size());
		system.assertequals(400, res.statusCode);
		
		//reset
		myClass = new REST_permissionset();
		restPermissionSet.clear();
		req = new RestRequest(); 
		res = new RestResponse();
		//let's see if a Role identifier returns its related Permission Sets...
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/permissionsets/' + testRole1.Id;  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		restPermissionSet = REST_permissionset.doGet();
		System.assertequals(1, restPermissionSet.size());
		
		//reset
		myClass = new REST_permissionset();
		restPermissionSet.clear();
		req = new RestRequest(); 
		res = new RestResponse();
		//let's see if a bogus Premmission Set identifier returns zero records and a 404...
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/permissionsets/' + 'a1k000000000000001';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		restPermissionSet = REST_permissionset.doGet();
		System.assertequals(0, restPermissionSet.size());
		system.assertequals(404, res.statusCode);
		
		//reset
		myClass = new REST_permissionset();
		restPermissionSet.clear();
		req = new RestRequest(); 
		res = new RestResponse();
		//let's see if a bogus Role identifier returns zero records and a 404...
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/permissionsets/' + 'a1l000000000000001';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		restPermissionSet = REST_permissionset.doGet();
		System.assertequals(0, restPermissionSet.size());
		system.assertequals(404, res.statusCode);
		
		//reset
		myClass = new REST_permissionset();
		restPermissionSet.clear();
		req = new RestRequest(); 
		res = new RestResponse();
		//retest that the "all" identifier returns the right number of features (should be two now!)...
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/permissionsets/all';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		restPermissionSet = REST_permissionset.doGet();
		System.assertequals(2, restPermissionSet.size());

    }

}