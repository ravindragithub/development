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
private class Test_REST_userfields {
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        // First things first, test an 'all' request with no records... should return a 404 status code
        
        //string instance = 'https://cs14.'; //ServCloud Sandbox
        //string instance = 'https://na13.'; //Production
        string instance = ''; //empty string to replace instance....
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        //Need an instance of the Class we are calling
        REST_userfields myClass = new REST_userfields();
        // We need a list to receive the responses... we will reuse this over and over...
        List<myKVH_User_Field__c> restUserFields = new List<myKVH_User_Field__c>();
        
        //let's see if the "all" identifier returns the right number of features (should be zero with a status code of 404!)...
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/userfields/all';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        restUserFields = REST_userfields.doGet();
        System.assertequals(0, restUserFields.size());
        system.assertequals(404, res.statusCode);
        
        // Now we need a Feature to work with...
        myKVH_Feature__c testFeat1 = new myKVH_Feature__c(Name = 'testFeat1', isUpdateable__c = true, isReadable__c = true, isDeleteable__c = true, 
                                    isCreateable__c = true, isBillable__c = false, hasFieldLevelSecurity__c = true, Status__c = 'Planned', 
                                    Description__c = 'This is a test Description');
        insert testFeat1;
        testFeat1 = [SELECT Id, Name, isUpdateable__c, isReadable__c, isDeleteable__c, isCreateable__c, isBillable__c, 
                                    hasFieldLevelSecurity__c, Status__c, Description__c 
                                    FROM myKVH_Feature__c WHERE Name = 'testFeat1'];
        //reset
        myClass = new REST_userfields();
        restUserFields.clear();
        //let's test the "no identifier" response. Should be zero records
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/userfields/';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        //test to ensure an API call with no record ID returns an empty list
        restUserFields = REST_userfields.doGet();
        System.assert(restUserFields.isEmpty());
        system.assertequals(400, res.statusCode);
        
        //reset
        myClass = new REST_userfields();
        restUserFields.clear();
        //let's see if a *Feature* identifier returns the right number of User Fields (should be zero at this point!)...
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/userfields/' + testFeat1.Id;  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        //test to ensure an API call with no record ID returns an empty list
        restUserFields = REST_userfields.doGet();
        System.assertequals(0, restUserFields.size());
        system.assertequals(404, res.statusCode);
        
        // Now we Need a couple of User Fields too....
        myKVH_User_Field__c testUserField1 = new myKVH_User_Field__c (name = 'ReadOnly1', myKVH_Feature__c = testFeat1.Id,
                                                Default_Read__c = true, Default_Edit__c = false);
        insert testUserField1;
        myKVH_User_Field__c testUserField2 = new myKVH_User_Field__c (name = 'ReadWrite1', myKVH_Feature__c = testFeat1.Id,
                                                Default_Read__c = true, Default_Edit__c = true);
        insert testUserField2;
        
        //reset
        myClass = new REST_userfields();
        restUserFields.clear();
        //let's see if the "all" identifier returns the right number of features...
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/userfields/all';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        //test to ensure an API call with no record ID returns an empty list
        restUserFields = REST_userfields.doGet();
        System.assertequals(2, restUserFields.size());
        
        //reset
        myClass = new REST_userfields();
        restUserFields.clear();
        //let's see if a specific identifier returns the right feature...
        testUserField1 = [SELECT id, Name FROM myKVH_User_Field__c WHERE Name = 'ReadOnly1'];
        
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/userfields/' + testUserField1.Id;  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        //test to ensure an API call with no record ID returns an empty list
        restUserFields = REST_userfields.doGet();
        System.assertequals(1, restUserFields.size());
        System.assertequals('ReadOnly1', restUserFields[0].Name);
        
        //reset
        myClass = new REST_userfields(); 
        restUserFields.clear();
        //let's see if an erroneous identifier returns a 404 status code...
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/userfields/a1m000000000000001';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        //test to ensure an API call with no record ID returns an empty list
        restUserFields = REST_userfields.doGet();
        System.assertequals(0, restUserFields.size());
        system.assertequals(404, res.statusCode);
        
        //reset
        myClass = new REST_userfields(); 
        restUserFields.clear();
        //let's see if an erroneous identifier Prefix returns a 400 status code...
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/userfields/a1j000000000000001';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        //test to ensure an API call with no record ID returns an empty list
        restUserFields = REST_userfields.doGet();
        System.assertequals(0, restUserFields.size());
        system.assertequals(400, res.statusCode);
        
        //reset
        myClass = new REST_userfields();
        restUserFields.clear();
        //let's see if a *Feature* identifier returns the right User Fields...
        
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/userfields/' + testFeat1.Id;  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        //test to ensure an API call with no record ID returns an empty list
        restUserFields = REST_userfields.doGet();
        System.assertequals(2, restUserFields.size());
        System.assertequals(testFeat1.Id, restUserFields[0].myKVH_Feature__c);
        
    }
}