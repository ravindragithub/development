@istest
public class SiteLoginPageController_test {
    public static final User adminUser = [SELECT Id, username FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
    public static final User testUser1 = [SELECT Id FROM User WHERE Profile.Name = 'Product Registration Profile' AND isActive= true LIMIT 1]; 
	public static final Id Platform_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Demo/Test/Monitor').getRecordTypeId();

    @testSetup static void setupUsers(){
        
        Profile NOTPortalProf = new Profile();
		NOTPortalProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Standard%' Limit 1];
		system.debug(NOTPortalProf);
            
        User testUser2 = new User();
		testUser2.username = 'LoginCtrlr.testUser2@kvh.com';
		testUser2.LastName = 'User2';
		testUser2.Email = 'LoginCtrlr.testUser2@kvh.com';	
		testUser2.Alias = 'tuser2';
		testUser2.TimeZoneSidKey = 'America/New_York';
		testUser2.LocaleSidKey = 'en_US';
		testUser2.EmailEncodingKey = 'ISO-8859-1';
		testUser2.ProfileId = NOTPortalProf.id;  
		testUser2.LanguageLocaleKey = 'en_US';
		system.runAs(adminUser){			//avoid mixed DML pain and suffering
		insert testUser2;
        }
    }
    public static testmethod void test1() { 
        system.runAs(testUser1) {
            PageReference pageRef1 = new PageReference('prodreg/SiteLoginProduct');
            pageRef1.setRedirect(true);
            Test.setCurrentPage(pageRef1);
            SiteLoginPageController control = new SiteLoginPageController();
            pageref1 = control.isUserLoggedIn();        
            system.assertEquals(pageRef1, null);
            
        }
    }
    public static testmethod void test2() {
        User testUser2 = [SELECT Id FROM User WHERE Email = 'LoginCtrlr.testUser2@kvh.com' LIMIT 1];
        system.runAs(adminUser) {
            PageReference pageRef2 = new PageReference('prodreg/SiteLoginProduct');
            pageRef2.setRedirect(true);
            Test.setCurrentPage(pageRef2);
            SiteLoginPageController control = new SiteLoginPageController();
            pageref2 = control.isUserLoggedIn(); 
            system.assertNotEquals(pageRef2, ApexPages.currentPage());            
        }        
    }
}