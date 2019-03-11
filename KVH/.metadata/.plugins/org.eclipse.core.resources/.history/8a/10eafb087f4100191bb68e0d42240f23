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
private class OrderNewAirtimeServiceController_test {
	//need record Types et all....
	private static final Id myKVH_Case_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Airtime Service').getRecordTypeId();
	private static final Id DirectCust_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Customer').getRecordTypeId();
	private static final Id Platform_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Commercial/MIL/GOV Maritime Vessel/Platform').getRecordTypeId();
	
	private static final User adminUser = [SELECT Id, username FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
	
	@testSetup
	static void setupTestData(){
		//Need a case
		Case testCase = new Case();
		testCase.RecordTypeId = myKVH_Case_RECORD_TYPE_ID;
		insert testCase;
		//need a test User, a Portal User!!
		list<Account> insertAccts = new list<Account>();
		Account testParent = new Account(Name = 'OrderNewAirtimeServiceController Test Parent Account', RecordTypeId = DirectCust_RECORD_TYPE_ID);
		insertAccts.add(testParent);
		Account testPlatform = new Account(Name = 'OrderNewAirtimeServiceController Test Platform Account', RecordTypeId = Platform_RECORD_TYPE_ID);
		insertAccts.add(testPlatform);
		insert insertAccts;
		
		Contact portalContact = new Contact(FirstName = 'Contact', LastName = 'Test', Email = 'ordernewservice.testuser@mock.user', AccountId = testParent.Id);
		insert portalContact;
		
		//Need a Profile.... a PORTAL profile! Profiles are Metadata!
		Profile PortalProf = new Profile();
		PortalProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Portal%' Limit 1];
		system.debug(PortalProf);
		//Convert Contact to Portal Users
		
		User tu = new User();
		tu.username = 'ordernewservice.testuser@mock.user';
		tu.LastName = 'User1';
		tu.Email = 'ordernewservice.testuser@mock.user';
		tu.Alias = 'AccAdm';
		tu.TimeZoneSidKey = 'America/New_York';
		tu.LocaleSidKey = 'en_US';
		tu.EmailEncodingKey = 'ISO-8859-1';
		tu.ProfileId = PortalProf.id;
		tu.LanguageLocaleKey = 'en_US';
		tu.ContactId = portalContact.Id; //must CREATE() user with Contact Id.....

		system.runAs(adminUser){			//avoid mixed DML pain and suffering
			insert tu;
		}
		// Controller uses Custom Settings...
		// Load the test accounts from the corresponding static resource (named "<customSettingName>_testResource")
		List<sObject> cs = Test.loadData(PortalProductServiceRecordTypeMap__c.sObjectType, 'PortalProductServiceRecordTypeMap_testResource');
		system.debug(cs.size() + ' Custom Setting Records Loaded');
		
		List<sObject> cs2 = Test.loadData(PortalOrderNewAirtimeSettings__c.sObjectType, 'PortalOrderNewAirtimeSettings_testResource');
		system.debug(cs2.size() + ' Custom Setting Records Loaded');
		
		List<sObject> cs3 = Test.loadData(PlatformAccountRecordType__c.sObjectType, 'PlatformAccountRecordType_testResource');
		system.debug(cs3.size() + ' Custom Setting Records Loaded');
	}
	
	static testMethod void testSetupData(){
		Case readCase = new Case();
		readCase = [SELECT Id, CaseNumber, RecordTypeId FROM Case LIMIT 1];
		system.assertEquals(myKVH_Case_RECORD_TYPE_ID, readCase.RecordTypeId);
		
		User u = new User();
		u = [SELECT Id, UserName, email FROM User WHERE username = 'ordernewservice.testuser@mock.user' LIMIT 1];
		system.assertEquals(u.email, 'ordernewservice.testuser@mock.user');
		
		for(PlatformAccountRecordType__c setting: PlatformAccountRecordType__c.getAll().values()){
			system.assertNotEquals(null,setting.RecordTypeId__c);
		}
		for(PortalProductServiceRecordTypeMap__c setting: PortalProductServiceRecordTypeMap__c.getAll().values()){
			system.assertNotEquals(null,setting.RecordTypeId__c);
		}
		for(PortalOrderNewAirtimeSettings__c setting: PortalOrderNewAirtimeSettings__c.getAll().values()){
			system.assertNotEquals(null,setting.ActivationFormLink__c);
		}
		
		list<Account> readAccts = [SELECT Id, Name, RecordTypeId FROM Account];
		system.assertEquals(2,readAccts.size());
	}
	static testMethod void testControllerExtension(){
		User u = new User();
		u = [SELECT Id, UserName, email FROM User WHERE username = 'ordernewservice.testuser@mock.user' LIMIT 1];
		Case testCase = new Case();
		test.startTest();
		System.runas(u){
			PageReference pageRef = Page.OrderNewAirtimeServicePage;
			Test.setCurrentPage(pageRef);
			ApexPages.StandardController stdCase= new ApexPages.StandardController(testCase);
			OrderNewAirtimeServiceController ext = new OrderNewAirtimeServiceController(stdCase);
			system.Assert(ext.FirstPage);										//make sure we start on page 1...
			ext.nextButton();													//should fail...
			//system.Assert(apexPages.hasMessages(ApexPages.severity.Error));		//creating a page message!
			ext.backButton();
			ext.valueSelected = 'Iridium Airtime Service Activation';									//simulate a selection...
			ext.setSelection();													//this calls "next" again...
			list<SelectOption> testPlatList = ext.getAccounts();
			//system.Assert(apexPages.hasMessages(ApexPages.severity.Error));		//creating a page message!
			ext.srvCase.Subject = 'Subject Line Test';
			ext.srvCase.Description = 'Description Test';
			PageReference caseView = ext.createCase();
		}
		test.stopTest();
		testCase = [SELECT Id, CaseNumber, RecordTypeId, Subject FROM Case WHERE subject = 'Order a New Airtime Service' LIMIT 1];
		system.debug(testCase);
    }
    
    static testMethod void testAttachment(){
    	User u = new User();
		u = [SELECT Id, UserName, email FROM User WHERE username = 'ordernewservice.testuser@mock.user' LIMIT 1];
		Case testCase = new Case();
		test.startTest();
		System.runas(u){
			PageReference pageRef = Page.OrderNewAirtimeServicePage;
			Test.setCurrentPage(pageRef);
			ApexPages.StandardController stdCase= new ApexPages.StandardController(testCase);
			OrderNewAirtimeServiceController ext = new OrderNewAirtimeServiceController(stdCase);
			ext.valueSelected = 'mini-VSAT Broadband Airtime Service Activation';									//simulate a selection...
			ext.setSelection();													//this calls "next" again...
			ext.srvCase.Subject = 'Subject Line Test';
			ext.srvCase.Description = 'Description Test';
	    	ext.attach.name = 'test attachment name';
			ext.attach.body = Blob.valueof('test attachment body');
			PageReference caseView = ext.createCase();
			system.debug(caseView);
		}
		test.stopTest();
		testCase = [SELECT Id, CaseNumber, RecordTypeId, subject FROM Case WHERE subject = 'mini-VSAT Broadband Airtime Service Activation' LIMIT 1];
		system.debug(testCase);
    }
}