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
private class REST_platforms_V2_test {
    //need a platform account (positive assertion)
    //and a not-a-platform account (negative assertion) 
    
    /* Begin setup test data.
     * Sequence of events is critical. Please proceed with caution when making changes!
     */
    private static final Id Platform_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Demo/Test/Monitor').getRecordTypeId();
    private static final Id Direct_Customer_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Customer').getRecordTypeId();
    private static Account testPlatformPatch = new Account();   //Account (no ID, for creating the JSON body for PATCH)
    private static integer MAX_LOOP_COUNTER = 5;
    
    @testSetup static void setupTestData(){
        //setup common test data here
        list<Account> insert_list = new list<Account>();
        Account PlatformAcct = new Account(Name = 'TestAcct_Platform', RecordTypeId = Platform_RECORD_TYPE_ID, BillingCountry = 'Platform');
        insert_list.add(PlatformAcct);
        Account DirCustAcct = new Account(Name = 'TestAcct_Customer', RecordTypeId = Direct_Customer_RECORD_TYPE_ID);
        insert_list.add(DirCustAcct);
        for(integer i = 0; i < MAX_LOOP_COUNTER; i++){
            Account Platform = new Account(Name = 'TestAcct_Platform' + i, RecordTypeId = Platform_RECORD_TYPE_ID, BillingCountry = 'Platform');
            insert_list.add(Platform);
        }
        insert insert_list;
        testPlatformPatch.User_Defined_Account_Name__c = 'Test Friendly Name Patch';
    }
    static testMethod void testSetupData(){
        //use this method to validate that you have test data setup correctly
        list<Account> readPlatform = [SELECT Id, Name, RecordTypeId FROM Account WHERE Name = 'TestAcct_Platform'];
        system.assertEquals(1, readPlatform.size());
        system.assertEquals('TestAcct_Platform', readPlatform[0].Name);
        list<Account> readAccount = [SELECT Id, Name, RecordTypeId FROM Account WHERE Name = 'TestAcct_Customer'];
        system.assertEquals(1, readAccount.size());
        system.assertEquals('TestAcct_Customer', readAccount[0].Name);
        list<Account> read_all_accounts = [SELECT Id, Name, RecordTypeId FROM Account];
        system.debug(read_all_accounts);
        system.assertEquals(MAX_LOOP_COUNTER + 2, read_all_accounts.size());
    }
    static testMethod void test_apply_patch_security(){
        list<Account> readPlatforms = [SELECT Id, Name, RecordTypeId FROM Account];
        system.assertEquals(MAX_LOOP_COUNTER + 2, readPlatforms.size()); //not all are platform!
        for(integer i = 0; i < readPlatforms.size(); i++){
            readPlatforms[i].User_Defined_Account_Name__c = 'Test Friendly Name Patch';
            readPlatforms[i].Premium_Tracking_Enabled__c = true;
        }
        list<Account> security_applied = REST_platforms_V2.apply_patch_security(readPlatforms);
        system.assertEquals(MAX_LOOP_COUNTER + 1, security_applied.size()); //filtered to return ONLY platforms!
        for(Account a : security_applied){
            system.assertEquals(null, a.Name);
            system.assertEquals(true, a.Premium_Tracking_Enabled__c);
            system.assertEquals('Test Friendly Name Patch', a.User_Defined_Account_Name__c);
        }
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
         
        req.requestURI = instance + 'salesforce.com/services/apexrest/V2/platforms/';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        //test to ensure an API call with no record ID returns an empty list
        List<Account> Platforms = new List<Account>();
        Platforms = REST_platforms_V2.doGet();
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
        Platforms = REST_platforms_V2.doGet(); //We shouldn't get anything back here....
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
        Platforms = REST_platforms_V2.doGet(); //We should get 1 record back here....
        size = Platforms.size();
        system.assertEquals(size, 1);
        //test a.myKVH_Parent_Override__c == true
        testAccount.myKVH_Parent_Override__c = true;
        testAccount.myKVH_Parent_Manual_Selection__c = TestCustID;
        update testAccount;
        Platforms = REST_platforms_V2.doGet(); //We should get 1 record back here....
        size = Platforms.size();
        system.assertEquals(size, 1);
    }
    static testMethod void testDoPatch_OK(){
        //Need a platform_patch Class to generate a JSON body
        REST_platforms_V2.platform_patch patchBody = new REST_platforms_V2.platform_patch();
        //list<Account> acctList = new list<Account>();
        //acctList = [SELECT Id, Name, RecordTypeId FROM Account]; 
        patchBody.platforms_to_update = [SELECT Id, Name, RecordTypeId FROM Account];
        system.assertEquals(MAX_LOOP_COUNTER + 2, patchBody.platforms_to_update.size()); //not all are platform!
        //Serialize the wrapper Class for the request..
        for(integer i = 0; i < patchBody.platforms_to_update.size(); i++){
            patchBody.platforms_to_update[i].User_Defined_Account_Name__c = 'Test Friendly Name Patch';
            patchBody.platforms_to_update[i].Premium_Tracking_Enabled__c = true;
        }
        
        String JSONbody = JSON.serialize(patchBody);
        system.debug(JSONbody);
        
        Test.startTest();
        //string instance = 'https://cs9.'; //ServCloud Sandbox
        //string instance = 'https://na13.'; //Production
        string instance = '';   //empty string to replace instance...
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        //setup the HTTP Request
        req.requestURI = instance + 'salesforce.com/services/apexrest/V2/platforms/';  
        req.httpMethod = 'PATCH';
        req.requestBody = Blob.valueOf(JSONbody);
        RestContext.request = req;
        RestContext.response = res;
        REST_platforms_V2.platforms_return PATCHresults = REST_platforms_V2.doPatch(patchBody);
        system.assertEquals(true, PATCHresults.resultCode.success);
        system.assertEquals('', PATCHresults.resultCode.exceptionMessage);
        system.assertEquals(MAX_LOOP_COUNTER + 1, PATCHresults.platforms_updated.size()); //non-platforms filtered out!
        for(integer i = 0; i < PATCHresults.platforms_updated.size(); i++){
            PATCHresults.platforms_updated[i].User_Defined_Account_Name__c = 'Test Friendly Name Patch';
            PATCHresults.platforms_updated[i].Premium_Tracking_Enabled__c = true;
        }
        test.stopTest();
    }
    static testMethod void testDoPatch_FAIL(){
        //Need a platform_patch Class to generate a JSON body
        REST_platforms_V2.platform_patch patchBody = new REST_platforms_V2.platform_patch();
        //list<Account> acctList = new list<Account>();
        //acctList = [SELECT Id, Name, RecordTypeId FROM Account]; 
        patchBody.platforms_to_update = [SELECT Id, Name, RecordTypeId FROM Account WHERE Name = 'TestAcct_Customer'];
        system.assertEquals(1, patchBody.platforms_to_update.size()); //not all are platform!
        //Serialize the wrapper Class for the request..
        for(integer i = 0; i < patchBody.platforms_to_update.size(); i++){
            patchBody.platforms_to_update[i].User_Defined_Account_Name__c = 'Test Friendly Name Patch';
            patchBody.platforms_to_update[i].Premium_Tracking_Enabled__c = true;
        }
        
        String JSONbody = JSON.serialize(patchBody);
        system.debug(JSONbody);
        
        Test.startTest();
        //string instance = 'https://cs9.'; //ServCloud Sandbox
        //string instance = 'https://na13.'; //Production
        string instance = '';   //empty string to replace instance...
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        //setup the HTTP Request
        req.requestURI = instance + 'salesforce.com/services/apexrest/V2/platforms/';  
        req.httpMethod = 'PATCH';
        req.requestBody = Blob.valueOf(JSONbody);
        RestContext.request = req;
        RestContext.response = res;
        REST_platforms_V2.platforms_return PATCHresults = REST_platforms_V2.doPatch(patchBody);
        system.assertEquals(false, PATCHresults.resultCode.success);
        system.assertEquals('The request body did not include any Platform records', PATCHresults.resultCode.exceptionMessage);
        system.assertEquals(400, res.statusCode);
        system.assertEquals(0, PATCHresults.platforms_updated.size()); //non-platforms filtered out!
        test.stopTest();
    }


}