@isTest
private class PartnerLoginController_test {
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
        
        system.runAs(adminUser){            //avoid mixed DML pain and suffering
            insert tu;
        }
    }

    static testMethod void testController() {
        // TO DO: implement unit test
        // Instantiate a new controller with all parameters in the page
        PartnerLoginController controller = new PartnerLoginController ();
        controller.uname = 'test@salesforce.com';
        controller.password = '123456';
                
        System.assertEquals(controller.login(),null);  
        
        controller.firstname = 'Test';
        controller.lastname = 'Test';
        controller.email = 'test@test.com';
        controller.message = 'Testing';
        controller.createCase();
    }
    static testmethod void testgetset(){
        PartnerLoginController controller = new PartnerLoginController ();
        controller.setuname('test1@salesforce.com');
        System.assertEquals(controller.getuname(), 'test1@salesforce.com');
        controller.password = '123456';
        controller.newpassword = '1234567';
        controller.newpassword1 = '1234567';
        PageReference pageref = controller.changepassword();
        System.assertEquals(null, pageref);
    }
    static testmethod void testbademail(){
        PartnerLoginController controller = new PartnerLoginController ();
        controller.uname = 'partneruser2@mock.user';
        PageReference pageref = controller.resetpass();
        System.assertEquals(null, pageref);
    }
    static testmethod void testreset(){
        PartnerLoginController controller = new PartnerLoginController ();
        controller.uname = 'partneruser@mock.user';
        PageReference pageref = controller.resetpass();
        System.assertEquals('PartnerLoginThanks', pageref.getUrl().right(18));
    }
            
}