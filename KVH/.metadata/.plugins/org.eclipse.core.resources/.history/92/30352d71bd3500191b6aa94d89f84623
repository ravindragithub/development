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
private class REST_users_V4_contactRoles_test {
    private static integer MAX_LOOP_COUNTER = 5;
    private static final Id Platform_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Demo/Test/Monitor').getRecordTypeId();
    private static final Profile PortalProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Portal%' Limit 1];
    private static final Profile ChatterFree = [SELECT Id, Name FROM Profile WHERE Name LIKE 'Chatter Free%' Limit 1];
    private static final User adminUser = [SELECT Id, username FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
    @testSetup static void setupTestData(){
        //setup common test data here
        //Going to need Accounts, & Contacts. Maybe AccountContactRoles too...
        //OH! And Users... this IS a User API resource after all!
        list<Account> insertAccountList = new list<Account>();
        for (integer i = 0; i < MAX_LOOP_COUNTER; i++){
            Account a = new Account();
            a.Name = 'Test Account ' + i;
            a.BillingCountry = 'Spain';     //rhymes with "Pain"....
            a.Custom_Call_Acct_ID__c = '1010' + i;
            a.Account_Effective_Date__c  = Date.Today();
            a.Revenue_Category__c = 'VSAT';
            insertAccountList.add(a);
        }
        system.debug(insertAccountList);
        insert insertAccountList;
        
        list<Account> insertPlatformList = new list<Account>();
        for (integer i = 0; i < MAX_LOOP_COUNTER; i++){
            Account a = new Account();
            a.Name = 'Test Platform ' + i;
            
            a.ParentId = insertAccountList[i].Id;
            insertPlatformList.add(a);
        }
        system.debug(insertPlatformList);
        insert insertPlatformList;
        
        
        
        list<Contact> insertContactsList = new list<Contact>();
        for (integer i = 0; i < MAX_LOOP_COUNTER; i++){
            Contact c = new Contact(LastName = 'test' + i, AccountId = insertAccountList[i].Id);
            insertContactsList.add(c);
        }
        system.debug(insertContactsList);
        insert insertContactsList;
        
        list<AccountContactRole> acrInsertList = new list<AccountContactRole>();
        for (integer i = 0; i < MAX_LOOP_COUNTER; i++){
            AccountContactRole acr = new AccountContactRole();
            acr.contactId = insertContactsList[i].Id;
            acr.accountId = insertAccountList[i].Id;
            acr.role = 'made up test role number ' + i;
            acrInsertList.add (acr);
        }
        system.debug(acrInsertList);
        insert acrInsertList;
        
        list<User> insertUserlist = new list<User>();
        for (integer i = 0; i < MAX_LOOP_COUNTER; i++){
            User u = new User();
	        u.username = 'restapi.testUser' + i + '@kvh.com';
	        u.LastName = 'User' + i;
	        u.Email = 'restapi.testUser' + i + '@kvh.com';
	        u.Alias = 'acrUser' + i;
	        u.TimeZoneSidKey = 'America/New_York';
	        u.LocaleSidKey = 'en_US';
	        u.EmailEncodingKey = 'ISO-8859-1';
	        u.ProfileId = PortalProf.id;
	        u.LanguageLocaleKey = 'en_US';
	        u.ContactId = insertContactsList[i].Id; //must CREATE() user with Contact Id
	        insertUserlist.add(u);
        }
        // testUser2 ... is a Chatter Free
        User testUserX = new User();
        testUserX.username = 'restapi.testUserX@kvh.com';
        testUserX.LastName = 'UserX';
        testUserX.Email = 'restapi.testUserX@kvh.com';
        testUserX.Alias = 'tuserX';
        testUserX.TimeZoneSidKey = 'America/New_York';
        testUserX.LocaleSidKey = 'en_US';
        testUserX.EmailEncodingKey = 'ISO-8859-1';
        testUserX.ProfileId = ChatterFree.id;
        testUserX.LanguageLocaleKey = 'en_US';
        insertUserlist.add(testUserX);
        
        test.startTest();
        system.runAs(adminUser){            //avoid that mixed DML pain and suffering
            insert insertUserlist;
	        }
        test.stopTest();
    }
    static testMethod void testSetupData(){
        //use this method to validate that you have test data setup correctly
        list<Account> readAccountList = [SELECT Id, Name FROM Account WHERE Name LIKE 'Test Account%'];
        system.assertEquals(MAX_LOOP_COUNTER, readAccountList.size());
        
        list<Account> readPlatformList = [SELECT Id, Name FROM Account WHERE Name LIKE 'Test Platform%'];
        system.assertEquals(MAX_LOOP_COUNTER, readPlatformList.size());
        
        list<Contact> readContactList = [SELECT Id, LastName FROM Contact];
        system.assertEquals(MAX_LOOP_COUNTER, readContactList.size());
        
        list<AccountContactRole> acrReadList = [SELECT Id, Role FROM AccountContactRole];
        system.assertEquals(MAX_LOOP_COUNTER, acrReadList.size());
        
        list<REST_users_V4.myKVH_User2> userList = new list<REST_users_V4.myKVH_User2>();
        //list<User> UserList = new List<User>();
        
        list<User> readUserlist = [SELECT id, username, profileId, Email FROM User WHERE username LIKE 'restapi.testUser%' AND Alias LIKE 'acrUser%'];
        //test with an accurate User Id....
        system.assertEquals(MAX_LOOP_COUNTER, readUserlist.size());
        readUserlist.clear();
        readUserList = [SELECT id, username, profileId, Email FROM User WHERE username = 'restapi.testUserX@kvh.com'];
        system.assertEquals(1, readUserlist.size());
    }
    static testMethod void test_Constructor() {
        // test static member
        string CustomMetadataBasedQuery = REST_users_V4_contactRoles.loadQueryString(); 
        system.assertEquals('SELECT', CustomMetadataBasedQuery.left(6));
        // test constructor
        REST_users_V4_contactRoles util = new REST_users_V4_contactRoles();
        
    }
    static testMethod void test_basicGet(){
        string instance = ''; //empty string to replace instance....
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        list<AccountContactRole> acrList = new list<AccountContactRole>();
        User testUser1 = [SELECT id, username, Email FROM User WHERE username = 'restapi.testUser1@kvh.com' LIMIT 1];
        //test with an accurate User Id....
        req.requestURI = instance + 'salesforce.com/services/apexrest/V4/users/' + testUser1.Id + '/contact_roles';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        acrList = REST_users_V4_contactRoles.doGet();
        system.assertEquals(1, acrList.size());
        system.assertEquals('made up test role number 1', acrList[0].role);
    }
    
    static testMethod void test_filteredGet(){
        string instance = ''; //empty string to replace instance....
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        list<AccountContactRole> acrList = new list<AccountContactRole>();
        User testUser1 = [SELECT id, username, Email FROM User WHERE username = 'restapi.testUser1@kvh.com' LIMIT 1];
        Account testPlatform = [SELECT Id, Parent_Acct_CC_ID__c, Parent.Name, Parent.Custom_Call_Acct_ID__c FROM Account WHERE Name = 'Test Platform 1'];
        system.debug(testPlatform);
        system.assertEquals('10101',testPlatform.Parent_Acct_CC_ID__c);
        //test with an accurate User Id....
        req.requestURI = instance + 'salesforce.com/services/apexrest/V4/users/' + testUser1.Id + '/contact_roles';  
        req.httpMethod = 'GET';
        req.addParameter('vessel', string.valueOf(testPlatform.Id));
        RestContext.request = req;
        RestContext.response = res;
        acrList = REST_users_V4_contactRoles.doGet();
        system.assertEquals(1, acrList.size());
        system.assertEquals('made up test role number 1', acrList[0].role);
    }
    
    static testMethod void test_noUser(){
        string instance = ''; //empty string to replace instance....
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        list<AccountContactRole> acrList = new list<AccountContactRole>();
        User testUser1 = [SELECT id, username, Email FROM User WHERE username = 'restapi.testUser1@kvh.com' LIMIT 1];
        //test with an accurate User Id....
        req.requestURI = instance + 'salesforce.com/services/apexrest/V4/users/005000000000000/contact_roles';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        acrList = REST_users_V4_contactRoles.doGet();
        system.assertEquals(0, acrList.size());
        system.assertEquals(404, res.statusCode);
    }
    
    static testMethod void test_notPortalUser(){
        string instance = ''; //empty string to replace instance....
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        list<AccountContactRole> acrList = new list<AccountContactRole>();
        User testUser1 = [SELECT id, username, Email FROM User WHERE username = 'restapi.testUserX@kvh.com' LIMIT 1];
        //test with an accurate User Id....
        req.requestURI = instance + 'salesforce.com/services/apexrest/V4/users/' + testUser1.Id + '/contact_roles';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        acrList = REST_users_V4_contactRoles.doGet();
        system.assertEquals(0, acrList.size());
    }
    
    static testMethod void test_notSubResource(){
        string instance = ''; //empty string to replace instance....
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        list<AccountContactRole> acrList = new list<AccountContactRole>();
        User testUser1 = [SELECT id, username, Email FROM User WHERE username = 'restapi.testUser1@kvh.com' LIMIT 1];
        //test with an accurate User Id....
        req.requestURI = instance + 'salesforce.com/services/apexrest/V4/users/' + testUser1.Id + '/messedUp';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        acrList = REST_users_V4_contactRoles.doGet();
        system.assertEquals(0, acrList.size());
    }
}