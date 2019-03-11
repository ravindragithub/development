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
private class test_REST_roles {
	
    static testMethod void myUnitTest() {
        // TO DO: implement unit test

		
		//string instance = 'https://cs16.'; //ServCloud Sandbox... kind of irrelevant for this test
		//string instance = 'https://na13.'; //Production
		string instance = ''; //empty string to replace instance....
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		List<myKVH_Role__c> RoleList = new List<myKVH_Role__c>();
		//OK First test is to request ALL with no records in the system....
		
		RoleList.Clear();
		//test to ensure an API call with ALL returns all roles
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/roles/all';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		RoleList = REST_roles.doGet();
		system.assertEquals(0,RoleList.size());
		
		//Now we can insert some test data....
		//test data
		//One Role
		myKVH_Role__c testRole1 = new myKVH_Role__c(Name = 'myKVH:testRole1', Description__c = 'This is a Test Description');
		Database.Saveresult srId1 = database.insert(testRole1);
		//Two Roles...
		myKVH_Role__c testRole2 = new myKVH_Role__c(Name = 'myKVH:testRole2', Description__c = 'This is another Test Description');
		Database.Saveresult srId2 = database.insert(testRole2);
		//And read some test data back....
		myKVH_Role__c readRole = new myKVH_Role__c();
		readRole = [SELECT Id, Name, Description__c FROM myKVH_Role__c WHERE Name = 'myKVH:testRole1' Limit 1];
		system.debug(readRole);
		
		//test to ensure an API call with no record ID returns an empty list
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/roles/';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		RoleList = REST_roles.doGet();
		system.assert(RoleList.isEmpty());
		
		//reset
		RoleList.Clear();
		//test to ensure an API call with a single record ID returns a single entry in the return list
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/roles/'+readRole.Id;  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		RoleList = REST_roles.doGet();
		system.assertEquals(1,RoleList.size());
		system.assertEquals('myKVH:testRole1',RoleList[0].Name);
		
		//Reset
		RoleList.Clear();
		//test to ensure an API call with ALL returns all roles (this time we should get some records!)
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/roles/all';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		RoleList = REST_roles.doGet();
		system.assertEquals(2,RoleList.size());
		
		//reset
		RoleList.Clear();
		//test to ensure an API call with an incorrect record ID returns an empty list
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/roles/'+'a1l000000000000001';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		RoleList = REST_roles.doGet();
		system.assertEquals(0,RoleList.size());

    }
}