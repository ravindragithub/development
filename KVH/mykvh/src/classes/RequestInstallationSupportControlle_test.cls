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
private class RequestInstallationSupportControlle_test {
	//need record Types et all....
	private static final Id myKVH_Case_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Airtime Service').getRecordTypeId();
	private static final Id DirectCust_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Customer').getRecordTypeId();
	private static final Id Platform_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Commercial/MIL/GOV Maritime Vessel/Platform').getRecordTypeId();
	
	private static final User adminUser = [SELECT Id, username FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
	
	@testSetup
	static void setupTestData(){
		//need a test User, a Portal User!!
		list<Account> insertAccts = new list<Account>();
		Account testParent = new Account(Name = 'RequestInstallationSupportController Test Parent Account', RecordTypeId = DirectCust_RECORD_TYPE_ID);
		insertAccts.add(testParent);
		Account testPlatform = new Account(Name = 'RequestInstallationSupportController Test Platform Account', RecordTypeId = Platform_RECORD_TYPE_ID);
		insertAccts.add(testPlatform);
		insert insertAccts;
		
		Contact portalContact = new Contact(FirstName = 'Contact', LastName = 'Test', Email = 'installsupport.testuser@mock.user', AccountId = testPlatform.Id);
		insert portalContact;		//associate Contact with PLATFORM to exercise line 82 (getAccounts())
		
		//Need a Profile.... a PORTAL profile! Profiles are Metadata!
		Profile PortalProf = new Profile();
		PortalProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Portal%' Limit 1];
		system.debug(PortalProf);
		//Convert Contact to Portal Users
		
		User tu = new User();
		tu.username = 'installsupport.testuser@mock.user';
		tu.LastName = 'User1';
		tu.Email = 'installsupport.testuser@mock.user';
		tu.Alias = 'AccAdm';
		tu.TimeZoneSidKey = 'America/New_York';
		tu.LocaleSidKey = 'en_US';
		tu.EmailEncodingKey = 'ISO-8859-1';
		tu.ProfileId = PortalProf.id;
        tu.Portal_View__c = 'Leisure Marine Systems';
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
	
    static testMethod void testSetupData() {
    	//Verify that we setup a portal User
        User u = new User();
		u = [SELECT Id, UserName, email FROM User WHERE username = 'installsupport.testuser@mock.user' LIMIT 1];
		system.assertEquals(u.email, 'installsupport.testuser@mock.user');
		//Verify that we loaded Custom Settings (used extensively in the Gears Portal Pages)
		for(PlatformAccountRecordType__c setting: PlatformAccountRecordType__c.getAll().values()){
			system.assertNotEquals(null,setting.RecordTypeId__c);
		}
		for(PortalProductServiceRecordTypeMap__c setting: PortalProductServiceRecordTypeMap__c.getAll().values()){
			system.assertNotEquals(null,setting.RecordTypeId__c);
		}
		for(PortalOrderNewAirtimeSettings__c setting: PortalOrderNewAirtimeSettings__c.getAll().values()){
			system.assertNotEquals(null,setting.ActivationFormLink__c);
		}
    }
    
    static testMethod void testControllerExtension(){
    	User u = new User();
		u = [SELECT Id, UserName, email FROM User WHERE username = 'installsupport.testuser@mock.user' LIMIT 1];
		Case testCase = new Case();
		test.startTest();
		System.runas(u){
			PageReference pageRef = Page.RequestInstallationSupportPage;
			Test.setCurrentPage(pageRef);
			ApexPages.StandardController stdCase= new ApexPages.StandardController(testCase);
			RequestInstallationSupportController ext = new RequestInstallationSupportController(stdCase);
			system.assertEquals(true, ext.FirstPage);										//make sure we start on page 1...
			ext.nextButton();																//should NOT fail...
			system.assertEquals(false, ext.FirstPage);										//and move to page 2
			ext.backButton();																//back to page 1
			system.assertEquals(true, ext.FirstPage);										//make sure we start on page 1...
			ext.nextButton();
			system.assertEquals(false, ext.FirstPage);										//NOW we move to page 2
			list<SelectOption> testPlatList = ext.getAccounts();
			system.debug(testPlatList.size() + ' Accounts returned');						//Note that Contact is associated with Platform for visibility
			ext.srvCase.Subject = 'Subject Line Test';
			ext.srvCase.Description = 'Description Test';
			//Create attachment
			ext.attach.name = 'test attachment name';
			ext.attach.body = Blob.valueof('test attachment body');
			PageReference caseView = ext.createCase();
            system.debug(caseView);
            system.assertEquals('/apex/my_Case_View?id=', caseView.getURL().Left(22));
		}
		test.stopTest();
		list<Case> testCases = [SELECT Id, CaseNumber, RecordTypeId, Subject FROM Case WHERE Subject = 'Subject Line Test'];
		system.debug(testCases);
		system.assertEquals(1, testCases.size());
    }
    static testMethod void testControllerExtension2(){
    	User u = new User();
		u = [SELECT Id, UserName, email FROM User WHERE username = 'installsupport.testuser@mock.user' LIMIT 1];
		Case testCase = new Case();
		test.startTest();
		System.runas(u){
			PageReference pageRef = Page.RequestInstallationSupportPage;
			Test.setCurrentPage(pageRef);
			ApexPages.StandardController stdCase= new ApexPages.StandardController(testCase);
			RequestInstallationSupportController ext = new RequestInstallationSupportController(stdCase);
			system.assertEquals(true, ext.FirstPage);										//make sure we start on page 1...
			ext.nextButton();																//should NOT fail...
			system.assertEquals(false, ext.FirstPage);										//and move to page 2
			ext.backButton();																//back to page 1
			system.assertEquals(true, ext.FirstPage);										//make sure we start on page 1...
			ext.nextButton();
			system.assertEquals(false, ext.FirstPage);										//NOW we move to page 2
			list<SelectOption> testPlatList = ext.getAccounts();
			system.debug(testPlatList.size() + ' Accounts returned');						//Note that Contact is associated with Platform for visibility
			ext.srvCase.Subject = 'Subject Line Test';
			ext.srvCase.Description = 'Description Test';
			//Create attachment
			ext.attach.name = 'test attachment name';
			ext.attach.body = Blob.valueof('test attachment body');
            PageReference caseView2 = ext.CreateCasePartner();
			system.debug(caseView2);
            system.assertEquals(ext.srvCase.Id, caseView2.getURL().Right(18));
		}
		test.stopTest();
    }
}