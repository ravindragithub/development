@isTest(SeeAllData = true)
public with sharing class myKVH_LightningSelfRegisterController_t {
    /* Verifies that IsValidPassword method with various password combinations. */
    @IsTest
    static void testIsValidPassword() {
        System.assert(myKVH_LightningSelfRegisterController.isValidPassword('password?@12334', 'password?@12334') == true);
        System.assert(myKVH_LightningSelfRegisterController.isValidPassword('password?@12334', 'dummyPassword') == false);
        System.assert(myKVH_LightningSelfRegisterController.isValidPassword('password?@12334', null) == false);
        System.assert(myKVH_LightningSelfRegisterController.isValidPassword(null, 'fakePwd') == false);
    }
    
    @IsTest
    static void testSiteAsContainerEnabled() {
        System.assertNotEquals(null, myKVH_LightningSelfRegisterController.siteAsContainerEnabled('https://portaleu1-developer-edition.eu11.force.com'));
    }
    
    /* Verifies the selfRegistration method flow with various invalid inputs */
    @IsTest
    static void testSelfRegistration() {
        Map < String, String > paramsMap = initializeParams();
        System.assertNotEquals(null, paramsMap);
        System.assertEquals(Label.Site.lastname_is_required, myKVH_LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), '', paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), true, '123456789', false,false,false,false,'United States','Texus', null));
        System.assertEquals(Label.Site.email_is_required, myKVH_LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), '', paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), true,  '123456789', false,false,false,false,'United States','Texus', null));
        System.assertEquals(Label.Site.email_is_required, myKVH_LightningSelfRegisterController.selfRegister(null, paramsMap.get('lastName'), '', null, paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), true,  '123456789', false,false,false,false,'United States','Texus', null));
        System.assertEquals(Label.site.passwords_dont_match, myKVH_LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordWrong'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), true,  '123456789', false,false,false,false,'United States','Texus', null));
        System.assertNotEquals(null, myKVH_LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), '', paramsMap.get('password'), paramsMap.get('confirmPasswordWrong'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), false,  '123456789', false,false,false,false,'United States','Texus', null));
    }
    
    
    /* Verifies the selfRegistration flow for valid inputs */
    @IsTest
    static void testSelfRegisterWithProperCredentials() {
        Map < String, String > paramsMap = initializeParams();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email=paramsMap.get('email'), 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName=paramsMap.get('email'));
        contact c = new contact();
        c.LastName = 'testcontact';
        
        insert c;
        insert u;
        //c.Id = u.contact.id
        //u.Contact.Id = c.Id;
        
        
        
        
        test.startTest();
        //String results = LTE_LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), true,  '123456789', false,false,false,false);
        test.stopTest();
        User createdUser = [SELECT Id, username FROM User WHERE username = 'lteselfreg@kvh.com'];
        system.debug('User: ' + createdUser);
        //Contact createdContact = [SELECT Id, email FROM Contact WHERE email = 'lteselfreg@kvh.com'];  
        
        //system.assert(createdContact.Email_Opted_In__c == 'false');
        //add more
        
    }
    
    /* Verifies SelfRegistration flow with an accounId that is created within the test */
    @IsTest
    static void testSelfRegisterWithCreatedAccount() {
        Account acc = new Account(name = 'test acc');
        insert acc;
        user u = new User();
        contact c = new contact();
        
        u.ContactId = c.Id;
        List < Account > accounts = [SELECT Id FROM Account LIMIT 1];
        //System.assert(!accounts.isEmpty(), 'There must be at least one account in this environment!');
        //String accountId = accounts[0].Id;
        //system.debug('accountId in test method: ' + accountId);
        Map < String, String > paramsMap = initializeParams();
        //System.assertEquals(null, LTE_LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), accountId, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), false,  '123456789', false,false,false,false));
        
    }
    
    @IsTest
    static void testGetNullExtraFields() {
        System.assertEquals(new List < Map < String, Object >> (), LTE_LightningSelfRegisterController.getExtraFields(null));
    }
    
    @IsTest
    static void testGetNonEmptyExtraFields() {
        System.assertEquals(new List < Map < String, Object >> (), LTE_LightningSelfRegisterController.getExtraFields('field1'));
    }
    
    /* Verifies validation of extraFields within the Self Registration flow */
    @IsTest
    static void testGetExtraFieldsInSelfRegistration() {
        List < Map < String, Object >> fieldlist = new List < Map < String, Object >> ();
        Map < String, String > paramsMap = initializeParams();
        Map < String, Object > fieldMap = new Map < String, Object > ();
        fieldMap.put('description', 'new field');
        fieldMap.put('fieldPath', 'dummyPath');
        fieldlist.add(fieldMap);
        String extraFields = JSON.serialize(fieldlist);
        System.assertNotEquals(null, LTE_LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), extraFields, paramsMap.get('startUrl'), true,  '123456789', false,false,false,false,'United States','Texus'));
    }
    
    @IsTest
    static void LTE_LightningSelfRegisterControllerInstantiation() {
        LTE_LightningSelfRegisterController controller = new LTE_LightningSelfRegisterController();
        System.assertNotEquals(controller, null);
    }
    @IsTest
    static void LTE_LightningSelfRegisterControllerUpdateContact(){
        contact c = new contact();
        c.email = 'test@kvh.com';
        c.FirstName = 'first name';
        c.LastName = 'last name';
        insert c;
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US');
        insert u;
        Account acc = new Account();
        acc.name = 'Testing name';
        insert acc;
        String userId = Site.createExternalUser(u, acc.Id, 'password123!!');
        
        test.startTest();
        LTE_LightningSelfRegisterController.updateContact(c.email, c.FirstName, c.LastName,false, true, false, false, '1234','United States','Texus');
        LTE_LightningSelfRegisterController.updateContact(c.email,c.FirstName,c.LastName, false, false, true, false, '1234','United States','Texus');
        LTE_LightningSelfRegisterController.updateContact(c.email,c.FirstName, c.LastName,false, false, false, true, '1234','United States','Texus');
        LTE_LightningSelfRegisterController.updateContact(c.email,c.FirstName, c.LastName,true, false, false, false, '1234','United States','Texus');
        LTE_LightningSelfRegisterController.updateContact(c.email, c.FirstName,c.LastName,false, true, false, true, '1234','United States','Texus');
        test.stopTest();
        
        
    }
    
    /* Helper method to initialize the parameters required for SelfRegistration. */
    private static Map < String, String > initializeParams() {
        Map < String, String > paramsMap = new Map < String, String > ();
        String firstName = 'test';
        String lastName = 'User';
        String email = 'lteselfreg@kvh.com';
        String password = 'testuser123';
        String confirmPasswordCorrect = 'testuser123';
        String confirmPasswordWrong = 'wrongpassword';
        String accountId = 'testuser123';
        String regConfirmUrl = 'http://registration-confirm.com';
        String startUrl = 'http://my.company.salesforce.com';
        paramsMap.put('firstName', firstName);
        paramsMap.put('lastName', lastName);
        paramsMap.put('email', email);
        paramsMap.put('password', password);
        paramsMap.put('confirmPasswordCorrect', confirmPasswordCorrect);
        paramsMap.put('confirmPasswordWrong', confirmPasswordWrong);
        paramsMap.put('accountId', accountId);
        paramsMap.put('regConfirmUrl', regConfirmUrl);
        paramsMap.put('startUrl', startUrl);
        return paramsMap;
    }
    static testMethod void test_getCountry() {
        List<KVH_Countries__mdt> countryValues = LTEAct_Controller.getCountry();
        for(KVH_Countries__mdt i: countryValues){
            System.assertEquals(i.TrimmedName__c.length() > 0, True);
            System.assertEquals(i.IsoCode_2__c.length() > 0, True);
            System.assertEquals(i.IsoCode_3__c.length() > 0, True);
        }
    }

    static testMethod void test_getState() {
        List<string> stateValues = LTEAct_Controller.getStateMap('IN');
        for(string i: stateValues){
            System.assertEquals(i.length() > 0, True);
        }        
    }
}