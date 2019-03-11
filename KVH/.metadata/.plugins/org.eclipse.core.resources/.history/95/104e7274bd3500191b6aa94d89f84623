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
private class SelfRegRegisterController_test {
    private static final User adminUser = [SELECT Id, username FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
    private static final Id Prospect_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
    @testSetup static void setupTestData(){
        //Need to create a prospect Account, and add it to Custom Settings.
        Account selfRegMock = new Account(Name='Self Registered Mock', RecordTypeId = Prospect_RECORD_TYPE_ID);
        insert selfRegMock;
        Contact con = new Contact(LastName = 'george', Email = 'test@testing.com', MailingCountry = 'Spain', AccountId = selfRegMock.Id);
        insert con;
        Contact con1 = new Contact(LastName = 'george', Email = 'testing@testing.com', MailingCountry = 'Spain', AccountId = selfRegMock.Id);
        insert con1;
        Profile Community = new Profile();
        Community = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Community Base%' LIMIT 1];
        User guestUser = new User(LastName = 'guest user 1', 
                                  Username = 'test@testing.com',
                                  ContactId = con.Id,
                                  CommunityNickname = 'nicky',
                                  Email = 'test@testing.com', 
                                  Alias = 'guestu1', 
                                  TimeZoneSidKey = 'GMT', 
                                  LocaleSidKey = 'en_GB', 
                                  EmailEncodingKey = 'ISO-8859-1', 
                                  ProfileId = Community.id, 
                                  LanguageLocaleKey = 'en_US'); 
        system.runAs(adminUser) {
            insert guestUser;
        }
        DefaultAccounts__c selfRegAcctSetting = new DefaultAccounts__c();
        selfRegAcctSetting.Name = 'SelfRegisteredAccount';
        selfRegAcctSetting.Account_ID__c = selfRegMock.Id;
        selfRegAcctSetting.Description__c = 'SelfRegisteredAccount';
        insert selfRegAcctSetting;
        //Need a Profile.... a COMMUNITY profile to add to a Custom Setting! Profiles are Metadata!
        list<Profile> CommunityProf = new list<Profile>();
        CommunityProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Community Base%'];
        system.debug(CommunityProf);
        myKVH_new_User_Defaults__c defaultSettings = new myKVH_new_User_Defaults__c();
        defaultSettings.Name = 'SelfRegisteredDefaults';
        defaultSettings.SF_Profile_Id__c = CommunityProf[0].id;
        insert defaultSettings;
        myKVH_new_User_Defaults__c defaultSettings1 = new myKVH_new_User_Defaults__c();
        defaultSettings1.Name = 'LimitedCustomerUser';
        defaultSettings1.SF_Profile_Id__c = CommunityProf[0].id;//[SELECT Id, Name FROM Profile WHERE Name LIKE '%Limited Customer%'].Id;
        insert defaultSettings1;
    }
    
    static testMethod void testSetupData() {
        // TO DO: implement unit test
        system.debug('Invoking testSetupData...');
        list<Account> acctList = [SELECT Id, Name FROM Account];
        system.assertEquals(1, acctList.size());
        DefaultAccounts__c READselfRegAcctSetting = DefaultAccounts__c.getInstance('SelfRegisteredAccount');
        system.assertEquals(acctList[0].Id, READselfRegAcctSetting.Account_ID__c);
    }
    
    static testMethod void testgetCountriesList(){
        SelfRegRegisterController util = new SelfRegRegisterController();
        list<SelectOption> readCountriesList = util.getCountrieslist();
        system.assert(readCountriesList.size() > 2);
        list<SelectOption> readStatesList = util.getStatesList();
        util.componentCountryChangeHandlerBilling();
        util.componentStateChangeHandlerBilling();
    }
    
    static testMethod void testcreateCommunityContact(){
        Test.startTest();
        SelfRegRegisterController util = new SelfRegRegisterController();
        Account a = [SELECT Id FROM Account WHERE Name = 'Self Registered Mock' LIMIT 1];
        //util.accountId = a.Id;
        util.country = 'Spain';
        util.firstName = 'Test';
        util.lastName = 'Contact';
        util.username = 'testcontact@selfreg.com';
        Contact returnedContact = util.createCommunityContact(a.id);
        system.assertEquals('testcontact@selfreg.com', returnedContact.email);
        // contact catch statement
        util.country = 'Spain';
        util.firstName = 'Test';
        util.lastName = '';
        util.username = 'testcontact@selfreg.com';
        Contact returnedContact1 = util.createCommunityContact(a.id);  
        util.country = 'Spanish Fake';
        util.firstName = 'Test';
        util.lastName = 'Contact';
        util.username = 'testcontact@selfreg.com';      
        PageReference pageref = util.registerUser();
        Test.stopTest();
        List<case> caselist = [SELECT Id FROM Case];
        system.assertEquals(caselist.size(), 1);
    }
    
    static testMethod void testregisterUser(){
        Test.startTest();
        Id selfRegAcctId = DefaultAccounts__c.getInstance('SelfRegisteredAccount').Account_ID__c;
        SelfRegRegisterController util = new SelfRegRegisterController();
        util.country = 'Spain';
        util.firstName = 'Test';
        util.lastName = 'Contact';
        util.username = 'testcontact@selfreg.com';
        util.registerUser();
        Contact c = [SELECT Id, email FROM Contact WHERE accountId =: selfRegAcctId AND LastName = 'Contact' LIMIT 1];
        system.assertEquals('testcontact@selfreg.com', c.email);
        Test.stopTest();
    }
    
    static testMethod void testcreateCommunityUser(){
        Test.startTest();
        //TODO add Profile Id to Custom Setting myKVH_new_User_Defaults__c 'SelfRegisteredDefaults'
        SelfRegRegisterController util = new SelfRegRegisterController();
        Account a = [SELECT Id FROM Account WHERE Name = 'Self Registered Mock' LIMIT 1];
        util.country = 'Spain';
        util.firstName = 'Test';
        util.lastName = 'Contact';
        util.username = 'testcontact@selfreg.com';
        Contact returnedContact = util.createCommunityContact(a.id);
        User u = util.createCommunityUser(returnedContact.Id, 'SelfRegisteredDefaults');
        system.debug(u);
        system.assertEquals('testcontact@selfreg.com', u.username);
        Test.stopTest();
    }
    
    static testMethod void testCreateCase(){
        //List<user> portalUsers = [SELECT Id, username, ContactId, Contact.AccountId FROM User WHERE username LIKE '%Admin.testUser@mock.user' AND ContactId != null];
        Test.startTest();
        string testCaseID;
        //Need a Profile.... a GUEST profile Profiles are Metadata!
        list<Profile> GuestProf = new list<Profile>();
        GuestProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%System Admin%' LIMIT 1];//myKVH 2.0 Profile
        system.debug(GuestProf);
        User guestUser = new User(LastName = 'guest user 1', 
                                  Username = 'guest.user.1@example.com', 
                                  CommunityNickname = 'nickname',
                                  Email = 'guest.1@example.com', 
                                  Alias = 'guestu1', 
                                  TimeZoneSidKey = 'GMT', 
                                  LocaleSidKey = 'en_GB', 
                                  EmailEncodingKey = 'ISO-8859-1', 
                                  ProfileId = GuestProf[0].id, 
                                  LanguageLocaleKey = 'en_US'); 
        system.runAs(guestUser){                          //test as Guest User
            SelfRegRegisterController ctrl1 = new SelfRegRegisterController();
            testCaseID = ctrl1.createCase('Case Created in Test Class','New User Request','');  //private Method is @testVisible
        }
        list<Case> caseList = [SELECT Id, Subject, CaseNumber FROM Case];      //Query results.... 
        system.assertEquals(1, caseList.size());                  //should only be one...
        system.assertEquals(testCaseId, caseList[0].Id);        //with this Case number...
        system.assertEquals('Case Created in Test Class', caseList[0].Subject.right(26));    //And this subject!!
        Test.stopTest();    
    }
    
    static testMethod void testanalyzeFoundUsers(){
        Test.startTest();
        list<User> userList = new list<User>();
        //Need a Profile.... a COMMUNITY profile to add to a Custom Setting! Profiles are Metadata!
        list<Profile> CommunityProf = new list<Profile>();
        CommunityProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Community Base%'];
        Account a = [SELECT Id FROM Account WHERE Name = 'Self Registered Mock' LIMIT 1];
        SelfRegRegisterController ctrl1 = new SelfRegRegisterController();
        
        //util.accountId = a.Id;
        ctrl1.country = 'Spain';
        ctrl1.firstName = 'Test';
        ctrl1.lastName = 'Contact';
        ctrl1.username = 'guest.user.0@example.com';
        Contact returnedContact = ctrl1.createCommunityContact(a.id);
        returnedContact.Inactive_Contact__c = true;
        update returnedContact;
        for(integer i = 0; i < 2; i++){
            User guestUser = new User(LastName = 'guest user ' + i, 
                                      Username = 'guest.user.'+i+'@example.com', 
                                      CommunityNickname = 'nickname',
                                      Email = 'guest.user.'+i+'@example.com',
                                      Alias = 'guestu' + i, 
                                      TimeZoneSidKey = 'GMT', 
                                      LocaleSidKey = 'en_GB', 
                                      ContactId= returnedContact.Id,
                                      EmailEncodingKey = 'ISO-8859-1', 
                                      ProfileId = CommunityProf[0].id, 
                                      LanguageLocaleKey = 'en_US');
            userList.add(guestUser);           
        }
        system.assertEquals(2, userList.size());    //make sure that we have two users
        PageReference pageRef = page.SelfRegException;
        pageRef.getParameters().put('showError','moreUsers');
        system.assertEquals(pageRef.getUrl(), ctrl1.analyzeFoundUsers(userList).getUrl());  //TWO users
        
        userList.remove(1);
        pageRef.getParameters().clear();
        pageRef.getParameters().put('showError','userUpdateFail');
        system.assertEquals(pageRef.getUrl(), ctrl1.analyzeFoundUsers(userList).getUrl());  //ONE user
        
        //insert userList;
        returnedContact.Inactive_Contact__c = false;
        update returnedContact;
        userList[0].contactId = returnedContact.Id;

        pageRef = page.SelfRegException;
        pageRef.getParameters().put('showError','noContact');
        system.assertEquals(pageRef.getUrl(), ctrl1.analyzeFoundUsers(userList).getUrl());  //ONE user
        
        userList[0].isActive = false;
        pageRef = page.SelfRegException;
        pageRef.getParameters().put('showError','userUpdateFail');
        system.assertEquals(pageRef.getUrl(), ctrl1.analyzeFoundUsers(userList).getUrl());  //ONE user
        
        returnedContact.Inactive_Contact__c = true;
        update returnedContact;
        
        userList[0].isActive = false;
        userList[0].contactId = returnedContact.Id;
        pageRef = page.SelfRegRegisterConfirm;
        pageRef.getParameters().put('login','true');
        //system.assertEquals(pageRef.getUrl(), ctrl1.analyzeFoundUsers(userList).getUrl());  //ONE user
        
        userList[0].contact = null;
        pageRef = page.SelfRegException;
        pageRef.getParameters().put('showError','noContact');
       // system.assertEquals(pageRef.getUrl(), ctrl1.analyzeFoundUsers(userList).getUrl());  //ONE user
        
        userList[0].Email = 'testEmamil@test.com';
        pageRef.getParameters().put('showError','userMismatch');
       // system.assertEquals(pageRef.getUrl(), ctrl1.analyzeFoundUsers(userList).getUrl());  //ONE user
        Test.stopTest();
    } 
    
    static testMethod void testanalyzeFoundContacts(){
        Test.startTest();
        list<Contact> contactList = new list<Contact>();
        //Need to create NEW prospect Account
        Account notSelffReg = new Account(Name='NOT Self Registered Mock', RecordTypeId = Prospect_RECORD_TYPE_ID);
        insert notSelffReg;
        list<Account> acctList = [SELECT Id, Name FROM Account WHERE Name LIKE 'NOT%'];
        for(integer i = 0; i < 2; i++){
            Contact c = new Contact(
                email = 'testCont' + i + '@example.com',
                LastName = 'Last Name' + i,
                firstName = 'first Name' + i,
                MailingCountry = 'Spain');
            contactList.add(c);
        }
        system.assertEquals(2, contactList.size());    //make sure that we have two contacts
        SelfRegRegisterController ctrl1 = new SelfRegRegisterController();
        ctrl1.firstName = 'Test contact First';
        ctrl1.lastName = 'Test contact Last';
        PageReference pageRef = page.SelfRegException;
        pageRef.getParameters().put('showError','moreContacts');
        system.assertEquals(pageRef.getUrl(), ctrl1.analyzeFoundContacts(contactList).getUrl());  //TWO Contacts
        contactList.remove(1);
        system.assertEquals(1, contactList.size());    //make sure that we have ONE contacts
        insert contactList;
        pageRef = page.SelfRegRegisterConfirm;
        pageRef.getParameters().put('login','true');
        system.assertEquals(pageRef.getUrl(), ctrl1.analyzeFoundContacts(contactList).getUrl());  //ONE Contact
        contactList.clear();
        for(integer i = 0; i < 1; i++){
            Contact c = new Contact(AccountId =acctList[0].id,
                                    email = 'testCont123' + i + '@example.com',
                                    LastName = 'Last Name' + i,
                                    firstName = 'first Name' + i,
                                    MailingCountry = 'Spain');
            contactList.add(c);
        }
        insert contactList;
        system.assertEquals(pageRef.getUrl(), ctrl1.analyzeFoundContacts(contactList).getUrl());  //ONE Contact
        Test.stopTest();
    }
    
    static testMethod void testanalyzeFoundLeads(){
        Test.startTest();
        list<Lead> LeadList = new list<Lead>();
        //Need to create NEW prospect Account
        
        for(integer i = 0; i < 2; i++){
            Lead c = new Lead(email = 'testLead' + i + '@example.com',
                              LastName = 'Last ' + i,
                              firstName = 'first' + i,
                              Country = 'India');
            LeadList.add(c);
        }
        system.assertEquals(2, LeadList.size());    //make sure that we have two contacts
        SelfRegRegisterController ctrl1 = new SelfRegRegisterController();
        PageReference pageRef = page.SelfRegException;
        pageRef.getParameters().put('showError','moreLeads');
        system.assertEquals(pageRef.getUrl(), ctrl1.analyzeFoundLeads(LeadList).getUrl());  //TWO Leads
        LeadList.remove(1);
        system.assertEquals(1, LeadList.size());    //make sure that we have ONE contacts
        insert LeadList;
        pageRef.getParameters().clear();
        pageRef.getParameters().put('showError','leadFail');
        //pageRef = page.SelfRegRegisterConfirm;
        system.assertEquals(pageRef.getUrl(), ctrl1.analyzeFoundLeads(LeadList).getUrl());  //ONE Lead
        Test.stopTest();
    }
    
    static testMethod void testinsertNewUser(){
        Test.startTest();
        Profile CommunityProf = new Profile();
        Contact con = [SELECT Id FROM Contact WHERE Email = 'testing@testing.com' LIMIT 1];
        CommunityProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Community Base%' LIMIT 1];
        User guestUser = new User(LastName = 'guest user 1', 
                                  Username = 'guest.user.1@example.com', 
                                  ProfileId = CommunityProf.Id,
                                  ContactId = con.Id,
                                  CommunityNickname = 'nickname',
                                  Email = 'guest.1@example.com', 
                                  Alias = 'guestu1', 
                                  TimeZoneSidKey = 'GMT', 
                                  LocaleSidKey = 'en_GB', 
                                  EmailEncodingKey = 'ISO-8859-1', 
                                  LanguageLocaleKey = 'en_US'); 
      SelfRegRegisterController ctrl1 = new SelfRegRegisterController();
      PageReference pageRef = page.selfregregisterconfirm;
      pageRef.getParameters().put('login','true');
      system.assertEquals(pageRef.getUrl(), ctrl1.insertNewUser(guestUser).getUrl());
        Test.stopTest();
    }
    static testmethod void testleadcontact () {
        Account acc = new Account(Name = 'fake company', BillingCountry = 'Spain');
        insert acc;
        
        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.Email = 'ldemail@test.com';
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        insert con;
        
        Lead ld = new Lead();
        ld.Company = 'company';
        ld.Country = 'Spain';
        ld.Email = 'ldemail@test.com';
        ld.FirstName = 'Test';
        ld.LastName = 'Lead';
        insert ld;
        
        Lead ld2 = new Lead();
        ld2.Company = 'company';
        ld2.Country = 'Spain';
        ld2.Email = 'ldemail@test.com';
        ld2.FirstName = 'Test';
        ld2.LastName = 'Lead';
        insert ld2;
        
        SelfRegRegisterController ctrl = new SelfRegRegisterController();       
        ctrl.username = 'ldemail@test.com';
        ctrl.firstName = 'joe';
        ctrl.lastName = 'bob';
        ctrl.country = 'Spain';
        ctrl.state = '';
 
        PageReference pageref = ctrl.registerUser();
        string subj = ctrl.strSubject;
        string symp = ctrl.strSymptom;
        string des = ctrl.strDescription;
        List <Case> caselist = new List<Case>();
        caselist = [SELECT Id FROM Case WHERE Subject LIKE '%Review Multiple Contacts and Leads%'];
        system.assertEquals(caselist.size(), 1);
    }
    static testmethod void convertleadtest() {
        Lead ld = new Lead();
        ld.Company = 'company';
        ld.Country = 'Spain';
        ld.Email = 'ldemail@test.com';
        ld.FirstName = 'Test';
        ld.LastName = 'Lead';
        insert ld;
        
        SelfRegRegisterController ctrl = new SelfRegRegisterController();
        ctrl.username = 'ldemail@test.com';
        PageReference pageref = ctrl.registerUser();
        List<Contact> contactList = [SELECT Id FROM Contact WHERE Email = 'ldemail@test.com'];
        system.assertEquals(contactList.size(), 1);
    }
    static testmethod void founduserstest(){
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Contact con = [SELECT Id FROM Contact WHERE Email = 'testing@testing.com' LIMIT 1];
        User u = [SELECT Id, Username, Email, IsActive, ContactId, Contact.Id FROM User LIMIT 1];
                       
        SelfRegRegisterController ctrl = new SelfRegRegisterController();
        ctrl.username = u.username;
        PageReference pageref = ctrl.registerUser();
        List<User> userList = [SELECT Id, UserName, Email, ContactId, Contact.Id, IsActive FROM User WHERE Username = 'test@testing.com'];
        pageref = ctrl.analyzeFoundUsers(userList);
        List<Case> caselist = [SELECT Id FROM Case];
        system.assertEquals(caselist.size(), 1);
        
    }
    static testmethod void inactiveuserstest(){
        User u = [SELECT Id, Name, Username, Email, ContactId, IsActive FROM User WHERE Email = 'test@testing.com' LIMIT 1];
        u.IsActive = FALSE;
        System.runAs(adminUser){
            update u;
        }        
        SelfRegRegisterController ctrl = new SelfRegRegisterController();
        ctrl.username = u.username;
        List<User> ulist = new List<User>();
        ulist.add(u);
        PageReference pageref = ctrl.analyzeFoundUsers(ulist);
        PageReference pagereftest = new PageReference('/apex/selfregregisterconfirm?login=true');
        string subj = ctrl.strSubject;
        system.assertEquals(pageref.getUrl(), pagereftest.getUrl());
    }
    static testmethod void inactiveuserscontacttest(){
        User u = [SELECT Id, Name, Username, Email, Contact.Id, Contact.Inactive_Contact__c, IsActive FROM User WHERE Email = 'test@testing.com' LIMIT 1];
        u.Contact.Inactive_Contact__c = TRUE;
        Contact con = [SELECT Id, Inactive_Contact__c FROM Contact WHERE Id =: u.Contact.Id];
        con.Inactive_Contact__c = TRUE;
        update con;
        system.debug('iNACTIVE cONTACT = ' + con.Inactive_Contact__c);
        u.IsActive = FALSE;
        system.runAs(adminUser) {
            update u;
        }
        system.debug('iNACTIVE cONTACT = ' + con.Inactive_Contact__c);
        system.debug('iNACTIVE cONTACT ON USER = ' + u.Contact.Inactive_Contact__c);
        SelfRegRegisterController ctrl = new SelfRegRegisterController();
        List<User> ulist = new List<User>();
        ulist.add(u);
        PageReference pageref = ctrl.analyzeFoundUsers(ulist);
        string subj = ctrl.strSubject;
        system.assertEquals(subj, 'Review Contact creation Error for the user Email :_test@testing.com');
    }
    static testmethod void contactusertest() {
        Test.startTest();
        //TODO add Profile Id to Custom Setting myKVH_new_User_Defaults__c 'SelfRegisteredDefaults'
        SelfRegRegisterController util = new SelfRegRegisterController();
        Account a = [SELECT Id FROM Account WHERE Name = 'Self Registered Mock' LIMIT 1];
        util.country = 'Iran';
        util.firstName = 'Test';
        util.lastName = 'Contact';
        util.username = 'testcontact123@selfreg.com';
        PageReference pageref = util.registerUser();
        string subj = util.strSymptom;
        system.assertEquals('New User Request', subj);
        Test.stopTest();
    }
    static testmethod void foundusersinvalidtest(){
        User u = [SELECT Id, Name, Username, Email, Contact.Id, Contact.Inactive_Contact__c, IsActive FROM User WHERE Email = 'test@testing.com' LIMIT 1];
        Contact con = [SELECT Name, Email, Inactive_Contact__c FROM Contact WHERE Id =: u.Contact.Id];
        con.Inactive_Contact__c = TRUE;
        update con;
        u = [SELECT Id, Name, Username, Email, Contact.Id, Contact.Inactive_Contact__c, IsActive FROM User WHERE Email = 'test@testing.com' LIMIT 1];
        system.debug('current user active ' + u.IsActive);
        u.IsActive = FALSE;
        system.runAs(adminUser) {
            update u;
        }
        u = [SELECT Id, Name, Username, Email, ContactId, Contact.Id, Contact.Inactive_Contact__c, IsActive FROM User WHERE Email = 'test@testing.com' LIMIT 1];
        system.debug('user contact '+ u.ContactId);
        u.IsActive = TRUE;
        u.Contact.Id = null;
        system.runAs(adminUser) {
            update u;
        }
        system.debug('contact id ' + u.ContactId);
        SelfRegRegisterController ctrl = new SelfRegRegisterController();
        List<User> ulist = new List<User>();
        ulist.add(u);
        PageReference pageref = ctrl.analyzeFoundUsers(ulist);
        PageReference pagecompare = new PageReference('/apex/selfregexception?showError=noContact');
        string subj = ctrl.strSubject;
        system.assertEquals(pageref.getUrl(), pagecompare.getUrl());
        
    }
    

    
}