@istest
public class CommentPartnerExt_test {
    private static final Id PartnerPortal_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Partner Portal').getRecordTypeId();
	private static final Id Partner_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Partner').getRecordTypeId();	
	private static final User adminUser = [SELECT Id, username FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
	@testSetup
	static void setupTestData(){
		//need a test User, a Portal User!!
		Account testPartner = new Account(Name = 'Partner Test Account', RecordTypeId = Partner_RECORD_TYPE_ID, BillingCountry = 'Spain');
		insert testPartner;
		
		Contact portalContact = new Contact(FirstName = 'Contact', LastName = 'Test', Email = 'partneruser@mock.user', AccountId = testPartner.Id);
		insert portalContact;
		
		Profile PortalProf = new Profile();
		PortalProf = [SELECT Id, Name FROM Profile WHERE Name =: 'Partner-Dealer' Limit 1];
		system.debug(PortalProf);
				
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
		// Controller uses Custom Settings...
		// Load the test accounts from the corresponding static resource (named "<customSettingName>_testResource")
		List<sObject> cs = Test.loadData(PortalProductServiceRecordTypeMap__c.sObjectType, 'PortalProductServiceRecordTypeMap_testResource');
		system.debug(cs.size() + ' Custom Setting Records Loaded');
	}
    static testMethod void testController(){
    	User u = new User();
		u = [SELECT Id, UserName, email, ContactId FROM User WHERE username = 'partneruser@mock.user' LIMIT 1];
		test.startTest();
		System.runas(u){
            Case testcase = new Case();
        	testcase.ContactId = u.ContactId;
        	testcase.Type = 'Partner Portal';
        	testcase.Subject = 'testcase';
        	testcase.Status = 'New';
        	testcase.Origin = 'Web';
        	testcase.RecordTypeId = PartnerPortal_RECORD_TYPE_ID;
        	insert testcase;
            
			PageReference pageRef = new PageReference('/apex/CommentPartner?id='+testcase.Id);
			Test.setCurrentPage(pageRef);
			ApexPages.StandardController stdCase= new ApexPages.StandardController(testCase);
			CommentPartnerExtension ext = new CommentPartnerExtension(stdCase);
            ext.caseId = testcase.Id;
            ext.newcommentbody = '12345';
			PageReference caseView = ext.saveComment();
			system.debug(caseView);
			system.assertEquals('/apex/my_Case_ViewPartner?id=', caseView.getURL().Left(29));
            caseView = ext.cancelling();
            system.assertEquals('/apex/my_Case_ViewPartner?id=', caseView.getURL().Left(29));
		}
		test.stopTest();
		List<CaseComment> testcomments = new List<CaseComment>();
        Case testcase = [SELECT Id FROM Case WHERE ContactId =: u.ContactId];
        testcomments = [SELECT Id FROM CaseComment WHERE ParentId =: testcase.Id];
		system.assertEquals(1, testcomments.size());
    }
    static testMethod void testcatch(){
        string catchme = 'djzhbv iunpiwenvclhblisudbk ';
        for (Integer i=0; i<10; i++){
            catchme = catchme + catchme;
        }
    	User u = new User();
		u = [SELECT Id, UserName, email, ContactId FROM User WHERE username = 'partneruser@mock.user' LIMIT 1];
		test.startTest();
		System.runas(u){
            Case testcase = new Case();
        	testcase.ContactId = u.ContactId;
        	testcase.Type = 'Partner Portal';
        	testcase.Subject = 'testcase';
        	testcase.Status = 'New';
        	testcase.Origin = 'Web';
        	testcase.RecordTypeId = PartnerPortal_RECORD_TYPE_ID;
        	insert testcase;
            
			PageReference pageRef = Page.CommentPartner;
            System.currentPageReference().getParameters().put('id', testcase.Id);
			Test.setCurrentPage(pageRef);
			ApexPages.StandardController stdCase= new ApexPages.StandardController(testCase);
			CommentPartnerExtension ext = new CommentPartnerExtension(stdCase);
            ext.setcaseId();
            ext.caseId = testcase.Id;
            string test123 = ext.getcaseId();
            system.assertEquals(testcase.Id, test123);
            
            ext.newcommentbody = catchme;
			PageReference caseView = ext.saveComment();
			system.debug(caseView);
			system.assertEquals(caseView, null);
		}
		test.stopTest();
    }
}