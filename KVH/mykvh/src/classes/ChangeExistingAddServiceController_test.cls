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
private class ChangeExistingAddServiceController_test {
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
		Account testParent = new Account(Name = 'ChangeExistingAddServiceController Test Parent Account', RecordTypeId = DirectCust_RECORD_TYPE_ID);
		insertAccts.add(testParent);
		Account testPlatform = new Account(Name = 'ChangeExistingAddServiceController Test Platform Account', RecordTypeId = Platform_RECORD_TYPE_ID);
		insertAccts.add(testPlatform);
		insert insertAccts;
		
		Contact portalContact = new Contact(FirstName = 'Contact', LastName = 'Test', Email = 'changeaddservice.testuser@mock.user', AccountId = testParent.Id);
		insert portalContact;
		
		//Need a Profile.... a PORTAL profile! Profiles are Metadata!
		Profile PortalProf = new Profile();
		PortalProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Portal%' Limit 1];
		system.debug(PortalProf);
		//Convert Contact to Portal Users
		
		User tu = new User();
		tu.username = 'changeaddservice.testuser@mock.user';
		tu.LastName = 'User1';
		tu.Email = 'changeaddservice.testuser@mock.user';
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
		//Controller uses Custom Settings...
		PortalProductServiceRecordTypeMap__c cs = new PortalProductServiceRecordTypeMap__c();
		cs.Name = 'Change or Add an Airtime Service';
		cs.RecordTypeId__c = myKVH_Case_RECORD_TYPE_ID;
		cs.Record_Type_Name__c = 'Airtime Service';
		insert cs;
		
		PlatformAccountRecordType__c cs2 = new PlatformAccountRecordType__c();
		cs2.Name = 'Platform_Vehicle_Commercial_MIL_GOV';
		cs2.RecordTypeId__c = Platform_RECORD_TYPE_ID;
		insert cs2;
	}
	
	static testMethod void testSetupData(){
		Case readCase = new Case();
		readCase = [SELECT Id, CaseNumber, RecordTypeId FROM Case LIMIT 1];
		system.assertEquals(myKVH_Case_RECORD_TYPE_ID, readCase.RecordTypeId);
		
		User u = new User();
		u = [SELECT Id, UserName, email FROM User WHERE username = 'changeaddservice.testuser@mock.user' LIMIT 1];
		system.assertEquals(u.email, 'changeaddservice.testuser@mock.user');
		
		for(PlatformAccountRecordType__c setting: PlatformAccountRecordType__c.getAll().values()){
			system.assertNotEquals(null,setting.RecordTypeId__c);
		}
		for(PortalProductServiceRecordTypeMap__c setting: PortalProductServiceRecordTypeMap__c.getAll().values()){
			system.assertNotEquals(null,setting.RecordTypeId__c);
		}
		list<Account> readAccts = [SELECT Id, Name, RecordTypeId FROM Account];
		system.assertEquals(2,readAccts.size());
	}

	static testMethod void testControllerExtension(){
		Case testCase = new Case();
		PageReference pageRef = Page.ChangeExistingAddServicePage;
		Test.setCurrentPage(pageRef);
		ApexPages.StandardController stdCase= new ApexPages.StandardController(testCase);
		ChangeExistingAddServiceController ext = new ChangeExistingAddServiceController(stdCase);
		system.Assert(ext.FirstPage);										//make sure we start on page 1...
		ext.nextButton();													//should fail...
		//system.Assert(apexPages.hasMessages(ApexPages.severity.Error));		//creating a page message!
		ext.backButton();
		ext.valueSelected = 'Reactivate a suspended service';									//simulate a selection...
		ext.setSelection();													//this calls "next" again...
		list<SelectOption> testPlatList = ext.getAccounts();
		//system.Assert(apexPages.hasMessages(ApexPages.severity.Error));		//creating a page message!
		ext.srvCase.Subject = 'Subject Line Test';
		ext.srvCase.Description = 'Description Test';
		PageReference caseView = ext.createCase();
		testCase = [SELECT Id, CaseNumber, RecordTypeId FROM Case WHERE Subject = 'Subject Line Test' LIMIT 1];

    }
    
    static testMethod void testAttachment(){
    	Case testCase = new Case();
		PageReference pageRef = Page.myKVHSupportPage;
		Test.setCurrentPage(pageRef);
		ApexPages.StandardController stdCase= new ApexPages.StandardController(testCase);
		ChangeExistingAddServiceController ext = new ChangeExistingAddServiceController(stdCase);
		ext.valueSelected = 'Reactivate a suspended service';									//simulate a selection...
		ext.setSelection();													//this calls "next" again...
		ext.srvCase.Subject = 'Subject Line Test';
		ext.srvCase.Description = 'Description Test';
    	ext.attach.name = 'test attachment name';
		ext.attach.body = Blob.valueof('test attachment body');
		PageReference caseView = ext.createCase();
		testCase = [SELECT Id, CaseNumber, RecordTypeId FROM Case WHERE Subject = 'Subject Line Test' LIMIT 1];
    }
    
    /*static testMethod void testOne()
    {
        Case aCase = UTestData.getCase(); //this does the insert for some reason
        
        Apexpages.Standardcontroller std = new Apexpages.Standardcontroller(aCase);
        
        ChangeExistingAddServiceController testController = new ChangeExistingAddServiceController(std);
        string firstSelection  = 'Reactivate a suspended service';
        
        testController.getAccounts();
        testController.valueSelected = firstSelection;
        testController.nextButton();
        testController.backButton();
        testController.setSelection();
        
        testController.valueSelected = firstSelection;
        testController.CreateCase();
        //string lookup = testController.valueSelectedLookup;
        
    }*/
}