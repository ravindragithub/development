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
private class REST_platforms_test {
    //need a platform account (positive assertion)
    //and a not-a-platform account (negative assertion) 
    
    /* Begin setup test data.
     * Sequence of events is critical. Please proceed with caution when making changes!
     */
    private static final Id Platform_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Demo/Test/Monitor').getRecordTypeId();
    private static final Id Direct_Customer_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Customer').getRecordTypeId();
    private static Account testPlatformPatch = new Account();   //Account (no ID, for creating the JSON body for PATCH)
    
    @testSetup static void setupTestData(){
        //setup common test data here
        Account PlatformAcct = new Account(Name = 'TestAcct_Platform', RecordTypeId = Platform_RECORD_TYPE_ID, BillingCountry = 'Platform');
        insert PlatformAcct;
        Account DirCustAcct = new Account(Name = 'TestAcct_Customer', RecordTypeId = Direct_Customer_RECORD_TYPE_ID);
        insert DirCustAcct;
        
        testPlatformPatch.User_Defined_Account_Name__c = 'Test Frendly Name Patch';
    }
    static testMethod void testSetupData(){
        //use this method to validate that you have test data setup correctly
        list<Account> readPlatform = [SELECT Id, Name, RecordTypeId FROM Account WHERE Name = 'TestAcct_Platform'];
        system.assertEquals(1, readPlatform.size());
        system.assertEquals('TestAcct_Platform', readPlatform[0].Name);
        list<Account> readAccount = [SELECT Id, Name, RecordTypeId FROM Account WHERE Name = 'TestAcct_Customer'];
        system.assertEquals(1, readAccount.size());
        system.assertEquals('TestAcct_Customer', readAccount[0].Name);
    }
    static testMethod void testDoGet() {
        // TO DO: implement unit test
        // We can create Accounts for test purposes without inserting them into the database for UNIT test
        // integration and system tests will probably require cross-object and DML operations
        //string instance = 'https://cs9.'; //ServCloud Sandbox
        //string instance = 'https://na13.'; //Production
        string instance = ''; //empty string to replace instance....
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
         
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/platforms/';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        //test to ensure an API call with no record ID returns an empty list
        List<Account> Platforms = new List<Account>();
        Platforms = REST_platforms.doGet();
        System.assert(Platforms.isEmpty());
        
        //reset
        Platforms.clear();
        //test to ensure that API only returns Platforms and not other record types.
        Account testAccount = new Account();
        testAccount = [SELECT Id, Name FROM Account WHERE Name = 'TestAcct_Customer' LIMIT 1]; //NOT a platform!
        Id TestCustID = testAccount.Id;
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/platforms/' + testAccount.Id;  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        Platforms = REST_platforms.doGet(); //We shouldn't get anything back here....
        Integer size = Platforms.size();
        system.assertEquals(size, 0);
        
        //reset
        Platforms.clear();
        //test to ensure that API will return Platforms.
        //this also tests a.myKVH_Parent_Override__c == false
        //Account testAccount = new Account();
        testAccount = [SELECT Id, Name FROM Account WHERE Name = 'TestAcct_Platform' LIMIT 1]; //A platform!
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/platforms/' + testAccount.Id;  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        Platforms = REST_platforms.doGet(); //We should get 1 record back here....
        size = Platforms.size();
        system.assertEquals(size, 1);
        //test a.myKVH_Parent_Override__c == true
        testAccount.myKVH_Parent_Override__c = true;
        testAccount.myKVH_Parent_Manual_Selection__c = TestCustID;
        update testAccount;
        Platforms = REST_platforms.doGet(); //We should get 1 record back here....
        size = Platforms.size();
        system.assertEquals(size, 1);
    }
    
    static testMethod void testdoPatch(){
        //Need a platform_patch Class to generate a JSON body
        REST_platforms.platform_patch patchBody = new REST_platforms.platform_patch();
        patchBody.platform_update_fields = testPlatformPatch;
        //Serialize the wrapper Class for the request..
        String JSONbody = JSON.serialize(patchBody);
        list<Account> readPlatform = [SELECT Id, Name, RecordTypeId FROM Account WHERE Name = 'TestAcct_Platform'];
        string identifier = readPlatform[0].Id;
        Test.startTest();
        //string instance = 'https://cs9.'; //ServCloud Sandbox
        //string instance = 'https://na13.'; //Production
        string instance = '';   //empty string to replace instance...
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        //setup the HTTP Request
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/platforms/' + identifier;  
        req.httpMethod = 'PATCH';
        req.requestBody = Blob.valueOf(JSONbody);
        RestContext.request = req;
        RestContext.response = res;
        REST_platforms.platforms_return PATCHresults = REST_platforms.doPatch(patchBody);
        system.assertEquals(true, PATCHresults.resultCode.success);
        system.assertEquals('', PATCHresults.resultCode.exceptionMessage);
        system.assertEquals(testPlatformPatch.User_Defined_Account_Name__c, PATCHresults.friendly_name);
        test.stopTest();
    }
    static testMethod void testdoPatch_nonPlatform(){
        //Need a platform_patch Class to generate a JSON body
        REST_platforms.platform_patch patchBody = new REST_platforms.platform_patch();
        patchBody.platform_update_fields = testPlatformPatch;
        //Serialize the wrapper Class for the request..
        String JSONbody = JSON.serialize(patchBody);
        list<Account> readPlatform = [SELECT Id, Name, RecordTypeId FROM Account WHERE Name = 'TestAcct_Customer'];
        string identifier = readPlatform[0].Id;
        Test.startTest();
        //string instance = 'https://cs9.'; //ServCloud Sandbox
        //string instance = 'https://na13.'; //Production
        string instance = '';   //empty string to replace instance...
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        //setup the HTTP Request
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/platforms/' + identifier;  
        req.httpMethod = 'PATCH';
        req.requestBody = Blob.valueOf(JSONbody);
        RestContext.request = req;
        RestContext.response = res;
        REST_platforms.platforms_return PATCHresults = REST_platforms.doPatch(patchBody);
        system.assertEquals(false, PATCHresults.resultCode.success);
        system.assertEquals('Platform was not found with Id == ', PATCHresults.resultCode.exceptionMessage.left(34));
        test.stopTest();
    }
    static testMethod void testdoPatch_nonAccount(){
        //Need a platform_patch Class to generate a JSON body
        REST_platforms.platform_patch patchBody = new REST_platforms.platform_patch();
        patchBody.platform_update_fields = testPlatformPatch;
        //Serialize the wrapper Class for the request..
        String JSONbody = JSON.serialize(patchBody);
        string identifier = '003000000000000000';
        Test.startTest();
        //string instance = 'https://cs9.'; //ServCloud Sandbox
        //string instance = 'https://na13.'; //Production
        string instance = '';   //empty string to replace instance...
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        //setup the HTTP Request
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/platforms/' + identifier;  
        req.httpMethod = 'PATCH';
        req.requestBody = Blob.valueOf(JSONbody);
        RestContext.request = req;
        RestContext.response = res;
        REST_platforms.platforms_return PATCHresults = REST_platforms.doPatch(patchBody);
        system.assertEquals(false, PATCHresults.resultCode.success);
        system.assertEquals('Not a Platform or Account Id == ', PATCHresults.resultCode.exceptionMessage.left(32));
        test.stopTest();
    }
    
}