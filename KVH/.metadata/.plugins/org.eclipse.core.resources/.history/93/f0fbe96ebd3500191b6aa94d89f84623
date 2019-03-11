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
private class REST_cases_test{
    /* typical testClass statics...*/
    static integer MAX_LOOP_COUNTER = 2;
    /* Get the metadata first... */
    private static final Id Case_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('mini-VSAT').getRecordTypeId();
    private static final Profile PortalProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Portal%' Limit 1];
    private static final Profile NOTPortalProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Standard%' Limit 1];
    private static final User adminUser = [SELECT Id, username FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
    private static final User supportUser = [SELECT Id, username FROM User WHERE Profile.Name = 'Support AGent' AND isActive = true LIMIT 1];
    private static Case testCaseReq = new Case();                       //case (no Id, not in database) for POST service tests
    private static CaseComment testCaseCommentReq = new CaseComment();  //CaseComment (no Id, not in database) for POST service tests
    
    @testSetup static void setupTestData(){
        //
        List<Account> testAcctList = new List<Account>();
        for (integer i = 0; i < MAX_LOOP_COUNTER; i++){
            Account a = new Account();
            a.Name = 'Test Account ' + i;
            //a.BillingCountry = 'Spain';     //rhymes with "Pain"....
            testAcctList.add(a); 
            system.debug(testAcctList);
        }
        insert testAcctList;
        
        Contact testCont1 = new Contact(LastName = 'test1', AccountId = testAcctList[0].Id);
        insert testCont1;
        //  testCont1 = [SELECT id, Name FROM Contact WHERE LastName = 'test1'];
        // testUser1 ... is a Contact
        User testUser1 = new User();
        testUser1.username = 'restcases.testUser1@kvh.com';
        testUser1.LastName = 'User1';
        testUser1.Email = 'restcases.testUser1@kvh.com';
        testUser1.Alias = 'tuser1';
        testUser1.TimeZoneSidKey = 'America/New_York';
        testUser1.LocaleSidKey = 'en_US';
        testUser1.EmailEncodingKey = 'ISO-8859-1';
        testUser1.ProfileId = PortalProf.id;
        testUser1.LanguageLocaleKey = 'en_US';
        testUser1.ContactId = testCont1.Id; //must CREATE() user with Contact Id.....
        
        system.runAs(adminUser){            //avoid that mixed DML pain and suffering
            insert testUser1;
        }
        
        list<case> insertCases = new list<case>();      //Cases for GET service
        for (integer i = 0; i < MAX_LOOP_COUNTER; i++){
            case c = new case();
            c.ContactId = testCont1.Id;
            c.Subject = 'Test Subject Line ' + i;
            //c.AccountId = (Should default to Contact's Account!)
            insertCases.add(c);
        }
        insert insertCases;
        
        list<CaseComment> insertComments = new list<CaseComment>();
        for (case c : [SELECT Id, CaseNumber FROM case]){
            CaseComment cc = new CaseComment();
            cc.ParentId = c.Id;
            cc.CommentBody = 'Test Comment for Case Number ' + c.CaseNumber;
            insertComments.add(cc);
        }
        insert insertComments;
        
    }

    static testMethod void testSetupData(){
        list<Account> readAccounts = new list<Account>();
        readAccounts = [SELECT Id, Name FROM Account];
        system.assertEquals(MAX_LOOP_COUNTER, readAccounts.size());
        
        list<case> readCases = new list<case>();
        readCases = [SELECT Id, CaseNumber, Contact.LastName FROM case];
        system.debug(readCases);
        system.assertEquals(MAX_LOOP_COUNTER, readCases.size());
        
        list<CaseComment> readComments = new list<CaseComment>();
        readComments = [SELECT Id, CommentBody FROM CaseComment];
        system.assertEquals(MAX_LOOP_COUNTER, readComments.size());
        
        
    }
    
    static testMethod void testdoPost(){
        //Need a test Case and  a CaseComments string...
        //for the wrapper Class
        //setup case for POST request test
        testCaseReq.RecordTypeId = Case_RECORD_TYPE_ID;
        testCaseReq.OwnerId = supportUser.Id;
        testCaseReq.X3rd_Party_Ticket__c = '1234567890';
        testCaseReq.X3rd_Party_Ticket_Provider__c = 'VIASAT';
        testCaseReq.Type = 'Report a Service or Product Problem';
        testCaseReq.Subject = 'Rebalance- Brazil; Other';
        testCaseReq.Satellite_Beam__c = 'S AMERICA-1 (BRAZIL)';
        testCaseReq.Beam_Not_Applicable__c = true;
        testCaseReq.Product_or_Service__c = 'Beam Loading Change';
        testCaseReq.Product_or_Service_Detail__c = 'Balance Beam';
        testCaseReq.Origin = 'Web';
        testCaseReq.IsEscalated = false;
        testCaseReq.Case_Symptom__c = 'Preventive Maint.';
        testCaseReq.Status = 'Closed';
        testCaseReq.Action_Plan__c = 'Follow-up';
        //setup CaseComment for POST request test
        testCaseCommentReq.CommentBody = 'Please log out the following:\r\n10.61.21.169\r\n10.61.41.20\r\n10.61.20.106\r\n10.61.6.45';
        
        REST_cases.cases_submit case_request = new REST_cases.cases_submit();
        case_request.case_details = testCaseReq;
        case_request.case_comment = testCaseCommentReq;
        //Serialize the wrapper Class for the request..
        system.debug('case_request : ' + case_request);
        String JSONbody = JSON.serialize(case_request);
        system.debug('JSONbody : ' + JSONbody);
        Test.startTest();
        //string instance = 'https://cs9.'; //ServCloud Sandbox
        //string instance = 'https://na13.'; //Production
        string instance = '';   //empty string to replace instance...
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        //This test Class doesn't even really use a request URI... it calls the REST class directly
        //setup the HTTP Request
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/cases/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSONbody);
        RestContext.request = req;
        RestContext.response = res;
        //Test POST request returns successfully
        REST_cases.cases_return POSTresults = REST_cases.doPost(case_request);
        system.assertEquals(true, POSTresults.resultCode.success);
        system.assertEquals('', POSTresults.resultCode.exceptionMessage);
        system.assertEquals('500', POSTresults.case_id.left(3));
        system.assertNotEquals(null, POSTresults.case_number);
        Test.stopTest();
        Case readCase = [SELECT id, Status, CaseNumber FROM Case WHERE Id =: POSTresults.case_id LIMIT 1];
        system.assertEquals(readCase.Status, 'Closed');
    }

    static testMethod void testdoPostNoComment(){
        //Need a test Case and  a CaseComments string...
        //for the wrapper Class
        testCaseReq.RecordTypeId = Case_RECORD_TYPE_ID;
        testCaseReq.OwnerId = supportUser.Id;
        testCaseReq.X3rd_Party_Ticket__c = '1234567890';
        testCaseReq.X3rd_Party_Ticket_Provider__c = 'VIASAT';
        testCaseReq.Type = 'Report a Service or Product Problem';
        testCaseReq.Subject = 'Rebalance- Brazil; Other';
        testCaseReq.Satellite_Beam__c = 'S AMERICA-1 (BRAZIL)';
        testCaseReq.Beam_Not_Applicable__c = true;
        testCaseReq.Product_or_Service__c = 'Beam Loading Change';
        testCaseReq.Product_or_Service_Detail__c = 'Balance Beam';
        testCaseReq.Origin = 'Web';
        testCaseReq.IsEscalated = false;
        testCaseReq.Case_Symptom__c = 'Preventive Maint.';
        testCaseReq.Status = 'Closed';
        testCaseReq.Action_Plan__c = 'Follow-up';
        
        REST_cases.cases_submit case_request = new REST_cases.cases_submit();
        case_request.case_details = testCaseReq;
        //case_request.case_comment = testCaseCommentReq;
        //Serialize the wrapper Class for the request..
        String JSONbody = JSON.serialize(case_request);
        Test.startTest();
        //string instance = 'https://cs9.'; //ServCloud Sandbox
        //string instance = 'https://na13.'; //Production
        string instance = '';   //empty string to replace instance...
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        //This test Class doesn't even really use a request URI... it calls the REST class directly
        //setup the HTTP Request
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/cases/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSONbody);
        RestContext.request = req;
        RestContext.response = res;
        //Test POST request returns successfully
        REST_cases.cases_return POSTresults = REST_cases.doPost(case_request);
        system.assertEquals(true, POSTresults.resultCode.success);
        system.assertEquals('', POSTresults.resultCode.exceptionMessage);
        system.assertEquals('500', POSTresults.case_id.left(3));
        system.assertNotEquals(null, POSTresults.case_number);
        Test.stopTest();
        Case readCase = [SELECT id, Status, CaseNumber FROM Case WHERE Id =: POSTresults.case_id LIMIT 1];
        system.assertEquals(readCase.Status, 'Closed');
    }
    static testMethod void testdoPostException(){
        //Need a test Case and  a CaseComments string...
        //for the wrapper Class
        REST_cases.cases_submit case_request = new REST_cases.cases_submit();
        testCaseReq.RecordTypeId = '012300000000000000';
        testCaseReq.OwnerId = supportUser.Id;
        testCaseReq.X3rd_Party_Ticket__c = '1234567890';
        testCaseReq.X3rd_Party_Ticket_Provider__c = 'VIASAT';
        testCaseReq.Type = 'Report a Service or Product Problem';
        testCaseReq.Subject = 'Rebalance- Brazil; Other';
        testCaseReq.Satellite_Beam__c = 'S AMERICA-1 (BRAZIL)';
        testCaseReq.Beam_Not_Applicable__c = true;
        testCaseReq.Product_or_Service__c = 'Beam Loading Change';
        testCaseReq.Product_or_Service_Detail__c = 'Balance Beam';
        testCaseReq.Origin = 'Web';
        testCaseReq.IsEscalated = false;
        testCaseReq.Case_Symptom__c = 'Preventive Maint.';
        testCaseReq.Status = 'Closed';
        testCaseReq.Action_Plan__c = 'Follow-up';
        case_request.case_details = testCaseReq;
        //case_request.case_comment = testCaseCommentReq;
        //Serialize the wrapper Class for the request..
        String JSONbody = JSON.serialize(case_request);
        Test.startTest();
        //string instance = 'https://cs9.'; //ServCloud Sandbox
        //string instance = 'https://na13.'; //Production
        string instance = '';   //empty string to replace instance...
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        //This test Class doesn't even really use a request URI... it calls the REST class directly
        //setup the HTTP Request
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/cases/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSONbody);
        RestContext.request = req;
        RestContext.response = res;
        //Test POST request returns successfully
        REST_cases.cases_return POSTresults = REST_cases.doPost(case_request);
        system.assertNotEquals(true, POSTresults.resultCode.success);
        Test.stopTest();
    }
    static testMethod void testGetEmptyAndCaseShares() {
        // TO DO: implement unit test
        //string instance = 'https://cs9.'; //ServCloud Sandbox
        //string instance = 'https://na13.'; //Production
        string instance = '';   //empty string to replace instance...
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        List<sObject> UserCases = new List<sObject>();
        //This test Class doesn't even really use a request URI... it calls the REST class directly
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/cases/';  
        //Test to ensure that a properly formatted API call returns a list of CaseShare records
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        //test to ensure an API call with no record ID returns an empty list
        UserCases = REST_cases.doGet();
        system.assertEquals(400, res.statuscode);
        System.assert(UserCases.isEmpty());
        //reset
        UserCases.Clear();
        User testUser1 = new User();
        testUser1 = [SELECT Id, UserName FROM User WHERE UserName = 'restcases.testUser1@kvh.com' LIMIT 1];
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/cases/' + testUser1.Id;  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        UserCases = REST_cases.doGet();
        system.debug(UserCases);
        system.assertEquals(MAX_LOOP_COUNTER, UserCases.size());
        //reset
        UserCases.Clear();
        //test to ensure that a bogus user returns no records..
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/cases/' + '005000000000000000';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        UserCases = REST_cases.doGet();
        system.debug(UserCases);
        system.assertEquals(0, UserCases.size());
        //reset
        UserCases.Clear();
        //test to ensure that a bogus Case ID returns no records..
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/cases/' + '500000000000000000';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        UserCases = REST_cases.doGet();
        system.debug(UserCases);
        system.assertEquals(0, UserCases.size());
        //reset
        UserCases.Clear();
        //test to ensure that a real Case Id returns the Right Case..
        list<case> readCases = new list<case>();
        readCases = [SELECT Id, CaseNumber, Contact.LastName FROM case];
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/cases/' + readCases[0].Id;  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        UserCases = REST_cases.doGet();
        case testCase = (case)UserCases[0];
        system.debug(testCase);
        system.assertEquals(1, UserCases.size());
        system.assertEquals(readCases[0].CaseNumber, testCase.CaseNumber);
        //reset
        UserCases.Clear();
        //test to ensure that a real Case Id returns the Right Case Comments..
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/cases/' + readCases[0].Id + '/case_comments';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        UserCases = REST_cases.doGet();
        CaseComment testCaseComment = (CaseComment)UserCases[0];
        system.debug(testCaseComment);
        system.assertEquals(1, UserCases.size());
        system.assertEquals(readCases[0].Id, testCaseComment.ParentId);
        //reset
        UserCases.Clear();
        //test to ensure that a bogus Case Id returns zero Case Comments..
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/cases/' + '500000000000000000' + '/case_comments';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        UserCases = REST_cases.doGet();
        system.assertEquals(0, UserCases.size()); 
    }
}