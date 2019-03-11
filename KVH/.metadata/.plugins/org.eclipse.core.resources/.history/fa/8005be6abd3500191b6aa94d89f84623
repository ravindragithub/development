@isTest
public class PartnerSupportCaseController_test {
	//need record Types et all....
	private static final Id PartnerPortal_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Partner Portal').getRecordTypeId();
	private static final Id Partner_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Partner').getRecordTypeId();
	//need admin user to insert test user
	private static final User adminUser = [SELECT Id, username FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
	
	@testSetup
	static void setupTestData(){
		//need a test User, a Portal User!!
		Account testPartner = new Account(Name = 'Partner Test Account', RecordTypeId = Partner_RECORD_TYPE_ID, BillingCountry = 'Spain');
		insert testPartner;
		//need a contact before user can be inserted
		Contact portalContact = new Contact(FirstName = 'Contact', LastName = 'Test', Email = 'partneruser@mock.user', AccountId = testPartner.Id);
		insert portalContact;
		
		//Need a Profile.... a PORTAL profile! Profiles are Metadata!
		Profile PortalProf = new Profile();
		PortalProf = [SELECT Id, Name FROM Profile WHERE Name =: 'Partner-Dealer' Limit 1];
		system.debug(PortalProf);
		//Convert Contact to Portal Users
		
		User tu = new User();
		tu.username = 'partneruser@mock.user';
		tu.LastName = 'User1';
		tu.Email = 'partneruser@mock.user';
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
	}
	
    static testMethod void testSetupData() {
    	//Verify that we setup a portal User
        User u = new User();
		u = [SELECT Id, UserName, email FROM User WHERE username = 'partneruser@mock.user' LIMIT 1];
		system.assertEquals(u.email, 'partneruser@mock.user');
    }
    
    static testMethod void testController(){
    	User u = new User();
		u = [SELECT Id, UserName, email FROM User WHERE username = 'partneruser@mock.user' LIMIT 1];
		Case testCase = new Case();
		test.startTest();
		System.runas(u){
			PageReference pageRef = Page.PartnerSupportCase;
			Test.setCurrentPage(pageRef);  // sets the current page so we can test controller
			ApexPages.StandardController stdCase= new ApexPages.StandardController(testCase);
			PartnerSupportCaseController ext = new PartnerSupportCaseController(stdCase);
			system.assertEquals(true, ext.FirstPage); //make sure we start on page 1
			ext.srvCase.Description = 'Description Test';
            ext.srvCase.Subject = 'test subject';
            
			//Create attachment
			ext.attach.name = 'test attachment name';
			ext.attach.body = Blob.valueof('test attachment body');
			PageReference caseView = ext.createCase();
			system.debug(caseView);
			system.assertEquals('/apex/my_Case_ViewPartner?id=', caseView.getURL().Left(29)); 
            //grabs the left side of the shortened URL to compare so that we know it completed successfully and returned
		}
		test.stopTest();
		list<Case> testCases = [SELECT Id, CaseNumber, RecordTypeId, Subject FROM Case WHERE Subject = 'KVH Partner Portal Question/Problem'];
		system.debug(testCases);
		system.assertEquals(1, testCases.size());
    }
    static testMethod void testinvaliddesc(){ //tests the catch block of CreateCase 
        User u = new User();
		u = [SELECT Id, UserName, email FROM User WHERE username = 'partneruser@mock.user' LIMIT 1];
		Case testCase = new Case();
        string descri = 'Description Test.  This must be 32000 ';
        for(Integer i=0; i<10; i++){
            descri = descri + ' ' + descri; //this creates a description that will cause an error on insert
        }
		test.startTest();
		System.runas(u){
			PageReference pageRef = Page.PartnerSupportCase;
			Test.setCurrentPage(pageRef);
			ApexPages.StandardController stdCase= new ApexPages.StandardController(testCase);
			PartnerSupportCaseController ext = new PartnerSupportCaseController(stdCase);
			ext.valueSelected = 'Update your Personal and/or Company Information';  // simulate a selection...
			ext.srvCase.Description = descri;  // add the invalid description
			PageReference caseView = ext.createCase();
            system.assertEquals(null, caseView);
		}
		test.stopTest();
		list<Case> testCases = [SELECT Id, CaseNumber, RecordTypeId, Subject FROM Case WHERE Subject = 'KVH Partner Portal Question/Problems'];
		system.debug(testCases);
		system.assertEquals(0, testCases.size());  // should have no cases  
    }
    static testMethod void testattachinvalid(){ // this method is for complete test coverage.  It covers there being no attachment and running the method 
        User u = new User();
		u = [SELECT Id, UserName, email FROM User WHERE username = 'partneruser@mock.user' LIMIT 1];
		Case testCase = new Case();
		test.startTest();
		System.runas(u){
			PageReference pageRef = Page.PartnerSupportCase;
			Test.setCurrentPage(pageRef);
			ApexPages.StandardController stdCase= new ApexPages.StandardController(testCase);
			PartnerSupportCaseController ext = new PartnerSupportCaseController(stdCase);
			ext.valueSelected = 'Cannot find a document'; // simulate a selection...
			ext.srvCase.Description = 'description 123';
            ext.srvCase.Subject = 'subject 123';
            ext.attach.name = null;
			ext.attach.body = null;
			PageReference caseView = ext.createCase();
            SelectOption valueSelect = ext.buildSelectOption('Cannot find a document');
            SelectOption option1 = new SelectOption('Cannot find a document','Cannot find a document');
            system.assertEquals(valueSelect, option1);
		}
		test.stopTest();
		list<Case> testCases = [SELECT Id, CaseNumber, RecordTypeId, Subject FROM Case WHERE Subject = 'KVH Partner Portal Question/Problem'];
		system.debug(testCases);
		system.assertEquals(1, testCases.size());        
    }
}