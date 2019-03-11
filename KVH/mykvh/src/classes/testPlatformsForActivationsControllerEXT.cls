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
private class testPlatformsForActivationsControllerEXT {
	
	static void setupTestEnv(){
		
	}
	
	@isTest /*(SeeAllData=true)*/
	static void testRecTypes() {
		
		Account testParent = new Account();
		testParent.name = 'Airtime Activations in Progress';
		testParent.BillingCountry = 'Spain';
		insert testParent;
		
		Account testAcct = new Account();
		
		ApexPages.StandardController sc = new ApexPages.StandardController(testAcct);
		PlatformForActivationsControllerEXT ctrlEXT = new PlatformForActivationsControllerEXT(sc);
		ctrlEXT.autoRun();
		
		List<RecordType> testRTs = new List<RecordType>();	//Need to SeeAllData when dealing with RecordTypes
		Account testPlatform = new Account();
		
		testRTs = ctrlEXT.getPlatformRecTypes();
		//test record type list...THIS is why we need SeeAllData!
		for (RecordType rts : testRTs) {
			string namePrefix = rts.DeveloperName.left(9);
			system.assertEquals('Platform_', namePrefix);
		}
		
		for (RecordType rt : testRTs) {
			if (rt.DeveloperName == 'Platform_Demo_Test_Monitor') { //setup a test Platform for SOSL test...
				testPlatform.RecordTypeId = rt.Id;
				testPlatform.Name = 'Test Platform';
				testPlatform.Vessel_IMO__c = '1234567';
				testParent = ([SELECT id, Name FROM Account WHERE Name = 'Airtime Activations in Progress' LIMIT 1]);
				testPlatform.ParentId = testParent.id;
				insert testPlatform;
				
				ctrlEXT.theRecType = rt;
				system.assertEquals(rt, ctrlEXT.gettheRecType());
			}
		}
		testPlatform = [SELECT id, Name, Vessel_IMO__c, RecordTypeId FROM Account WHERE Name = 'Test Platform' LIMIT 1];
		Id [] fixedSearchResults= new Id[1];
		fixedSearchResults[0] = testPlatform.Id;
		
		ctrlEXT.SelectedPlatform.add(testPlatform);
		ctrlEXT.PlatformTable.add(testPlatform);
		system.assertEquals(testPlatform, ctrlEXT.getSelectedPlatform()[0]);
		system.assertEquals(testPlatform, ctrlEXT.getPlatformTable()[0]);
		
		ctrlEXT.thePlatform.Vessel_IMO__c = '1234567';
		ctrlEXT.findIMO();
		string foundName ='';
		for (integer i = 0; i < ctrlEXT.PlatformTable.size(); i++){
			if(ctrlEXT.PlatformTable[i].Name == 'Test Platform'){
				foundName = ctrlEXT.PlatformTable[i].Name;
			}
		}
		system.assertEquals('Test Platform', foundName);	//with SeeAllData, need to mitigate a duplicate IMO#
		ctrlEXT.PlatformTable.clear();
		ctrlEXT.IMOoptions.clear();
		
		ctrlEXT.searchTerm = 'testSearchTerm';
		ctrlEXT.SearchPlatform();
		system.assertEquals('Platform not found!', ctrlEXT.IMOStats);
		
		ctrlEXT.PlatformTable.Clear();	//need to handle the SOSL return thingy
		ctrlEXT.IMOoptions.Clear();
		Test.setFixedSearchResults(fixedSearchResults);
		
		ctrlEXT.searchTerm = 'Platform';
		ctrlEXT.SearchPlatform();
		system.assertEquals('Found 1 matching Vessel Names', ctrlEXT.IMOStats);
		
		List<SelectOption> testSelectOptions = new List<SelectOption>();
		testSelectOptions = ctrlEXT.getIMOoptions();
		system.AssertEquals(1, testSelectOptions.Size());
		
		PageReference FindCreate = new PageReference('Create_new_Platform_for_Activations');
		test.setCurrentPage(FindCreate);
		system.currentPageReference().getParameters().put('RecTypeId', ctrlEXT.theRecType.Id);
		ctrlEXT.selectRecordType();
		
		system.currentPageReference().getParameters().put('PlatId', testPlatform.Id);
		ctrlEXT.selectPlatform();
		
		case testCase = new Case();
		
		insert testCase;
		testCase = [SELECT Id FROM Case Limit 1];
		system.currentPageReference().getParameters().put('CaseId', testCase.Id);
		
		ctrlEXT.useSelectedPlatform();
		testCase = [SELECT id, CaseNumber, Platform_Asset_Account__c, Search_for_or_create_Platform_Account_in__c FROM Case WHERE id =: testCase.Id];
		system.assertEquals(true, testCase.Search_for_or_create_Platform_Account_in__c);
		system.assertEquals(testPlatform.Id, testCase.Platform_Asset_Account__c);
		
		//testPlatform.id=null;	//the Finish() method inserts a records... must remove Id!
		//Create new test Platform, but don't insert to database
		Account testPlatform2 = new Account();
		testPlatform2.RecordTypeId = testPlatform.RecordTypeId;
		testPlatform2.Name = 'Test Platform2';
		testPlatform2.Vessel_IMO__c = '1234567';
		testParent = ([SELECT id, Name FROM Account WHERE Name = 'Airtime Activations in Progress' LIMIT 1]);
		testPlatform2.ParentId = testParent.id;
		//send test Platform2 to page
		ctrlEXT.thePlatform = testPlatform2;
		//Finish platform creation
		ctrlEXT.Finish();
		testPlatform2 = [SELECT id, Name, Vessel_IMO__c FROM Account WHERE Name = 'Test Platform2' LIMIT 1];
		testCase = [SELECT id, CaseNumber, Platform_Asset_Account__c, Search_for_or_create_Platform_Account_in__c FROM Case WHERE id =: testCase.Id];
		system.assertEquals(true, testCase.Search_for_or_create_Platform_Account_in__c);
		system.assertEquals(testPlatform2.Id, testCase.Platform_Asset_Account__c);
		
		//reset case..
		testCase.Search_for_or_create_Platform_Account_in__c = false;
		testCase.Platform_Asset_Account__c = null;
		update testCase;
		system.assertNotEquals(true, testCase.Search_for_or_create_Platform_Account_in__c);
		system.assertNotEquals(testPlatform.Id, testCase.Platform_Asset_Account__c);
		

	}
	
	/*Need to setup a Case to test the finish/update case methods */
	
	static testMethod void testIMOValidator() {
		
		Account testParent = new Account();
		testParent.name = 'Airtime Activations in Progress';
		testParent.BillingCountry = 'Spain';
		insert testParent;
		
		Account testAcct = new Account();
		ApexPages.StandardController sc = new ApexPages.StandardController(testAcct);
		PlatformForActivationsControllerEXT ctrlEXT = new PlatformForActivationsControllerEXT(sc);
		PageReference pageRef = Page.Create_new_Platform_for_Activations;
		Test.setCurrentPage(pageRef);
		ctrlEXT.autoRun();	//run the startup sequence...
		

		
		system.assertEquals('The Vessel IMO# is preferred identifier for commercial ships....', ctrlEXT.IMOStats);
		ctrlEXT.setnoIMO(true);		//test manual override getter setter
		ctrlEXT.findIMO();
		system.assertEquals(true, ctrlEXT.getnoIMO());
		system.assert(ctrlEXT.getnoIMO());
		system.assert(ctrlEXT.showPlatformSearch);
		system.assertEquals('Proceeding without an IMO#...', ctrlEXT.IMOStats);
		ctrlEXT.setnoIMO(false);
		ctrlEXT.showPlatformSearch = false;	//RESET
		
		ctrlEXT.setIMOValidated(true);	//test IMOValidated getter, setter
		system.assert(ctrlEXT.getIMOValidated());
		system.assert(ctrlEXT.showPlatformSearch);
		system.assertEquals('IMO Validated!', ctrlEXT.IMOStats);
		ctrlEXT.setIMOValidated(true);
		ctrlEXT.showPlatformSearch = false;	//RESET
		
		ctrlEXT.thePlatform.Vessel_IMO__c = null;	//test null validation
		ctrlEXT.findIMO();
		system.assertEquals(null, ctrlEXT.thePlatform.Vessel_IMO__c);
		ctrlEXT.thePlatform.Vessel_IMO__c = '123456';	//test 7 digits long validation
		ctrlEXT.findIMO();
		system.assertEquals('Vessel IMO#s must be 7 digits long', ctrlEXT.IMOStats);
		ctrlEXT.thePlatform.Vessel_IMO__c = '123456a';	//test numerid IMO validation
		ctrlEXT.findIMO();
		system.assertEquals('Vessel IMO#s must consist of only numbers', ctrlEXT.IMOStats);
		ctrlEXT.thePlatform.Vessel_IMO__c = '1234568';	//test Invalid Vessel IMO# validation
		ctrlEXT.findIMO();
		system.assertEquals('Invalid Vessel IMO#', ctrlEXT.IMOStats);
		ctrlEXT.thePlatform.Vessel_IMO__c = '1234567';	//test valid Vessel IMO# validation
		ctrlEXT.findIMO();
		system.assert(ctrlEXT.IMOValidated);
		
		ctrlEXT.searchRecordType();
		system.Assert(ctrlEXT.showRecTypeTable);
		
		ctrlEXT.useSelectedRecordType();
		system.assert(ctrlEXT.showCreatePlatform);
	}
	
	static testMethod void testCaseUpdates() {
		
		
	}
}