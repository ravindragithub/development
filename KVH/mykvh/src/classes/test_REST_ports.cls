/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
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
private class test_REST_ports {

	@testSetup static void setupTestPorts(){
		//need a countryPort....
		Country_Ports__c cp = new Country_Ports__c();
		cp.Name = 'Freedonia';
		insert cp;
		system.debug('Created CountryPort: ' + cp);
		//and TWO Ports...
		Port__c p0 = new Port__c();
		p0.Name = 'Port in a Storm';
		p0.Country_New__c = cp.Id;
		insert p0;
		system.debug('Created Port: ' + p0);
		
		Port__c p1 = new Port__c();
		p1.Name = 'Port in a Calm';
		p1.Country_New__c = cp.Id;
		insert p1;
		system.debug('Created Port: ' + p1);
		//Need a handful of Accounts
		List<Account> acctList = new List<Account>();
		for (integer i = 0; i<6; i++){
			Account a = new Account(Name = 'testAcct'+i);
			acctList.add(a);
			system.debug('Acct Name: ' + a);
		}
		insert acctList;
		//Need a handful of Services By Ports
		List<Services_by_Port__c> svcByPort = new List<Services_by_Port__c>();
		for (integer i = 0; i<6; i++){
			Services_by_Port__c sbp = new Services_by_Port__c(Service_Partner_Account__c = acctList[i].Id);
			if (i<3){
				sbp.Port_Name__c = p0.Id;
			} else {
				sbp.Port_Name__c = p1.Id;
			}
			svcByPort.add(sbp);
		}
		insert svcByPort;
		system.debug(svcByPort);
	}
	
    static testMethod void testDoGet() {
		string instance = ''; //empty string to replace instance....
		//test to ensure an API call with no record ID returns an empty list
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/ports/';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		List<Port__c> Ports = new List<Port__c>();		//init return list
		Ports = REST_ports.doGet();
		System.assert(Ports.isEmpty());
		
		//Test with a Bogus identifier
		
		//reset
		Ports.clear();
		
		req = new RestRequest(); 
		res = new RestResponse();
		 
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/ports/a0W000000000000000';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		
		Ports = REST_ports.doGet();
		System.assert(Ports.isEmpty());
		
		//Test svcProviders with a Bogus identifier
		
		//reset
		Ports.clear();
		
		req = new RestRequest(); 
		res = new RestResponse();
		 
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/ports/a0W000000000000000/svcproviders';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		List<Services_by_Port__c> SvcByPorts = new List<Services_by_Port__c>();
		SvcByPorts = REST_ports.doGet();
		System.assert(SvcByPorts.isEmpty());
		
		//Test with a Good identifier
		
		//reset
		SvcByPorts.clear();
		Ports.clear();
		
		req = new RestRequest(); 
		res = new RestResponse();
		Port__c p = [SELECT Id, Name FROM Port__c LIMIT 1];		//get a port from database.. there should be only 1!
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/ports/' + p.Id;  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		
		Ports = REST_ports.doGet();
		System.assertEquals(1, Ports.size());
		
		//Test svcByPorts with a Good Port identifier
		
		//reset
		SvcByPorts.clear();
		Ports.clear();
		
		req = new RestRequest(); 
		res = new RestResponse();
		
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/ports/' + p.Id + '/svcproviders';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		
		SvcByPorts = REST_ports.doGet();
		System.assertEquals(3, SvcByPorts.size());
		
		//Test svcByPorts with Valid port ID, but no Services by Port...
		delete SvcByPorts;
		
		//reset
		SvcByPorts.clear();
		Ports.clear();
		
		req = new RestRequest(); 
		res = new RestResponse();
		
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/ports/' + p.Id + '/svcproviders';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		
		SvcByPorts = REST_ports.doGet();
		System.assertEquals(0, SvcByPorts.size());
		
		
		
		//Test with "all" identifier and two valid Ports
		
		//reset
		SvcByPorts.clear();
		Ports.clear();
		
		req = new RestRequest(); 
		res = new RestResponse();
		
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/ports/' +'all';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		
		Ports = REST_ports.doGet();
		System.assertEquals(2, Ports.size());
		
		delete Ports;
		
		//Test with "all" identifier and ZERO valid Ports
		
		//reset
		SvcByPorts.clear();
		Ports.clear();
		
		req = new RestRequest(); 
		res = new RestResponse();
		
		req.requestURI = instance + 'salesforce.com/services/apexrest/V1/ports/' +'all';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		
		Ports = REST_ports.doGet();
		System.assertEquals(0, Ports.size());
	}
}