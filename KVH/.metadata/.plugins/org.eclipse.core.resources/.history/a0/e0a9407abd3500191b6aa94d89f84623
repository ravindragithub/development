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
//This test class could be improved by using mock callouts to simulate return codes other than 200...
/* Needed to change the Instance for Salesforce after we refreshed the Sandbox....
 * jthom 1/27/14																   */
@isTest
private class Test_REST_beams {
	private static final integer MAX_LOOP_COUNTER = 5; 
	@testSetup static void setupTestBeams(){
		//Need to create a few test beams....
		list<Beam__c> testBeams = new list<Beam__c>();
		for(integer i = 0; i < MAX_LOOP_COUNTER; i++){
			Beam__c testBeam = new beam__c(Name = 'TEST BEAM '+string.valueOf(i),
			//ACU_Name__c = 'Test Beam '+string.valueOf(i), populated by Workflow to match Name
			Map_Name__c = 'Test Map Name '+string.valueOf(i), 
			SAT_Long__c = 90, SAT_Name__c ='Test Sat Name '+string.valueOf(i), 
			Feed_Designator__c = 'TestFD '+string.valueOf(i),
			Frequency_KU_Downlink_MHz__c = 12643);
			testBeams.add(testBeam);
		}
		insert testBeams;
	}
	
	static testMethod void testSetupData(){
		List<Beam__c> readBeams = new List<Beam__c>([SELECT id, Name, ACU_Name__c FROM beam__c]);
		system.assertEquals(MAX_LOOP_COUNTER, readBeams.size());	//verify data creation
		for(Beam__c b: readBeams){
			system.assertEquals(b.Name, b.ACU_Name__c);				//verify workflow
		}
	}

	static testMethod void testDoGet() {
		// TO DO: implement unit test

		List<beam__c> Beams = new List<beam__c>([SELECT id, Name FROM beam__c]);
		string BeamId = Beams[0].Id;
		system.debug(Beams[0].id);
		
		//string instance = 'https://cs14.'; //ServCloud Sandbox
		string instance = 'https://na13.'; //Production
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		//let's test the "no identifier" response. Should be zero records
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/beams/';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		//test to ensure an API call with no record ID returns an empty list
		List<beam__c> RestBeams = new List<beam__c>();
		RestBeams = REST_beams.doGet();
		System.assert(RestBeams.isEmpty());
		
		//reset
		RestBeams.clear();
		//let's see if the "all" identifier returns the right number of beams...
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/platforms/all';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		RestBeams = REST_beams.doGet();
		System.assertequals(RestBeams.size(), Beams.size());
		
		//reset
		RestBeams.clear();
		//let's see if a specific identifier returns the right beam...
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/platforms/'+Beams[0].id;  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		RestBeams = REST_beams.doGet();
		System.assertequals(RestBeams[0].Name, Beams[0].Name);
		
		//OK lest see if we get our "beams not found responses"
		delete Beams;
		//reset
		RestBeams.clear();
		//let's see if the "all" identifier returns the right number of beams...ZERO at this point
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/platforms/all';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		RestBeams = REST_beams.doGet();
		System.assertequals(0, RestBeams.size());
		
		//reset
		RestBeams.clear();
		//let's see if the "all" identifier returns the right number of beams...ZERO at this point
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/platforms/' + BeamId;  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		RestBeams = REST_beams.doGet();
		System.assertequals(0, RestBeams.size());
	}
}