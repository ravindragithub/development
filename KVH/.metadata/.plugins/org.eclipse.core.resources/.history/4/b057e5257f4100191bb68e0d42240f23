@isTest
private class myKVHprofileController_Test{
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
    
    static testMethod void unittest() {
        User partnerUser = [Select id from User where username = 'partneruser@mock.user'];
        
        system.runAs(partnerUser){  
            ProfileWrapper ud = myKVHprofileController.getUserDetails();
            ud.con.firstname = 'Testing';
            ud.con.email = 'testingpartner@kvh.com';
            ud.con.Phone = '1234567898';
            ud.con.Title = 'Mr.';
            ud.con.MailingStreet = 'test';
            ud.con.MailingCity = 'test';
            ud.con.MailingState = 'test';
            ud.con.MailingCountry = 'USA';
            ud.con.MailingPostalCode = '1234';
            ud.con.Salutation = 'Mr.';
            ud.con.Job_Function__c = 'Technical Manager';
            
            myKVHprofileController.updateUserRecord(JSON.serialize(ud));
            myKVHprofileController.getstateOptions('IN');
        }
    }
    
   
}