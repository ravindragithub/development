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
private class test_REST_rateplans {

    static testMethod void test_get_rateplans() {
        // TO DO: implement unit test
		string instance = ''; //empty string to replace instance....
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		List<Rate_Plan__c> plans = new List<Rate_Plan__c>();
		//OK First test is to request ALL with no records in the system....
		
		plans.Clear();
		//test to ensure an API call with ALL returns all rate plans
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/rateplans/all';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		plans = REST_rateplans.doGet();
		system.assertEquals(0,plans.size());
		
		//Insert two Rate Plans...
		Rate_Plan__c p1 = new Rate_Plan__c();
		p1 = new Rate_Plan__c();
		p1.Name = 'Test Rate Plan 1';
		p1.Allowance_Units__c = 'MB';
		p1.Monthly_Data_Allowance__c = 1000;
		p1.Overage_Alert_Default__c = 1000;
		//p1.Overage_Alert_Units__c = 'MB';
		insert p1;
		
		Rate_Plan__c p2 = new Rate_Plan__c();
		p2 = new Rate_Plan__c();
		p2.Name = 'Test Rate Plan 2';
		p2.Allowance_Units__c = 'MB';
		p2.Monthly_Data_Allowance__c = 2000;
		p2.Overage_Alert_Default__c = 2000;
		//p2.Overage_Alert_Units__c = 'MB';
		insert p2;
		
		plans.Clear();					//reset
		//test to ensure an API call with no record ID returns an empty list
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/rateplans/';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		plans = REST_rateplans.doGet();
		system.assertEquals(0,plans.size());
		
		plans.Clear();					//reset
		//test to ensure an API call with a single record ID returns a single entry in the return list
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/rateplans/' + p1.Id;  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		plans = REST_rateplans.doGet();
		system.assertEquals(1,plans.size());
		
		plans.Clear();					//reset
		//test to ensure an API call with ALL returns all roles (this time we should get some records!)
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/rateplans/all';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		plans = REST_rateplans.doGet();
		system.assertEquals(2,plans.size());
		
		plans.Clear();					//reset
		//test to ensure an API call with an incorrect record ID returns an empty list
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/rateplans/a3i000000000000000';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		plans = REST_rateplans.doGet();
		system.assertEquals(0,plans.size());

    }
}