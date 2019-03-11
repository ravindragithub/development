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
@isTest (SeeAllData=true)
private class Test_REST_accounts {
	//need to see all data so that we can collect the appropriate record type
	//need a platform account (positive assertion)
	//and a not-a-platform account (negative assertion) 
	static {
		//Collect Record types from Org data
		RecordType PlatRecType = new RecordType();
		PlatRecType = [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName = 'Platform_Vessel_Maritime' LIMIT 1];
		RecordType CustRecType = new RecordType();
		CustRecType = [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName = 'Direct_Customer' LIMIT 1];
		system.debug('Record Type ID and Name:' + PlatRecType.Id + ' - ' + PlatRecType.DeveloperName);
		//Create a Platform Account and a Direct Customer Account
		Account PlatformAcct = new Account(Name = 'TestAcct_Platform', RecordTypeId = PlatRecType.Id, BillingCountry = 'Platform');
		insert PlatformAcct;
		Account DirCustAcct = new Account(Name = 'TestAcct_Customer', RecordTypeId = CustRecType.Id, BillingCountry = 'Spain');
		insert DirCustAcct;
	}

    static testMethod void testDoGet() {
        // TO DO: implement unit test
		//string instance = 'https://cs9.'; //ServCloud Sandbox
		string instance = 'https://na13.'; //Production
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		 
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/accounts/';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		//test to ensure an API call with no record ID returns an empty list
		List<Account> Accounts = new List<Account>();
		Accounts = REST_accounts.doGet();
		System.assert(Accounts.isEmpty());
		
		//reset
		Accounts.clear();
		//test to ensure that API does not return Platforms.
		Account testAccount = new Account();
		testAccount = [SELECT Id, Name FROM Account WHERE Name = 'TestAcct_Platform' LIMIT 1]; //NOT a Customer!
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/platforms/' + testAccount.Id;  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		Accounts = REST_accounts.doGet(); //We shouldn't get anything back here....
		Integer size = Accounts.size();
		system.assertEquals(size, 0);
		
		//reset
		Accounts.clear();
		//test to ensure that API will return Customers.
		//Account testAccount = new Account();
		testAccount = [SELECT Id, Name FROM Account WHERE Name = 'TestAcct_Customer' LIMIT 1]; //A Customer!
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/accounts/' + testAccount.Id;  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		Accounts = REST_accounts.doGet(); //We should get 1 record back here....
		size = Accounts.size();
		system.assertEquals(size, 1);
    }
}