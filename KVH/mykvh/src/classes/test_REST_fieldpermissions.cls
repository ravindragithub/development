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
private class test_REST_fieldpermissions {
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        // First things first, test an 'all' request with no records... should return a 404 status code
        
        //string instance = 'https://cs14.'; //ServCloud Sandbox
        //string instance = 'https://na13.'; //Production
        string instance = ''; //empty string to replace instance....
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        // We need a list to receive the responses... we will reuse this over and over...
        List<myKVH_Field_Permission__c> restFieldPermissions = new List<myKVH_Field_Permission__c>();
        
        //let's see if the "all" identifier returns the right number of features (should be zero with a status code of 404!)...
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/fieldpermissions/all';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        restFieldPermissions = REST_fieldpermissions.doGet();
        System.assertequals(0, restFieldPermissions.size());
        system.assertequals(404, res.statusCode);
        
        //Need some test data....
        //a couple of User Fields, and a couple of permission sets (and addition required fields...)
        //Need a Role, and Feature
        //One Role
        myKVH_Role__c testRole1 = new myKVH_Role__c(Name = 'myKVH:testRole1', Description__c = 'This is a Test Description');
        insert testRole1;
        testRole1 = [SELECT id, Name, Description__c FROM myKVH_Role__c];
        //one Feature
        myKVH_Feature__c testFeat1 = new myKVH_Feature__c(Name = 'testFeat1', isUpdateable__c = true, isReadable__c = true, isDeleteable__c = true, 
                                    isCreateable__c = true, isBillable__c = false, hasFieldLevelSecurity__c = true, Status__c = 'Planned', 
                                    Description__c = 'This is a test Description');
        insert testFeat1;
        testFeat1 = [SELECT Id, Name, isUpdateable__c, isReadable__c, isDeleteable__c, isCreateable__c, isBillable__c, 
                                    hasFieldLevelSecurity__c, Status__c, Description__c 
                                    FROM myKVH_Feature__c WHERE Name = 'testFeat1'];
        //And now a couple of permission sets....
        myKVH_Permission_Set__c testPermSet1 = new myKVH_Permission_set__c(Name = 'testPermSet1', myKVH_Role__c = testRole1.Id, 
                                                myKVH_Feature__c = testFeat1.Id, canUpdate__c = true, canRead__c = true, 
                                                canDelete__c = true, canCreate__c = true);
        insert testPermSet1;
        system.debug(testPermSet1);
        testPermSet1 = [SELECT Id, Name, myKVH_Role__c, myKVH_Feature__c, myKVH_Feature__r.Name, canUpdate__c, canRead__c, canDelete__c, canCreate__c
                        FROM myKVH_Permission_Set__c WHERE Name LIKE '%testFeat1']; // Workflow renames PermSet
        system.debug(testPermSet1);

        // Now we Need a couple of User Fields too....
        myKVH_User_Field__c testUserField1 = new myKVH_User_Field__c (name = 'ReadOnly1', myKVH_Feature__c = testFeat1.Id,
                                                Default_Read__c = true, Default_Edit__c = false);
        insert testUserField1;
        testUserField1 = [SELECT id, Name FROM myKVH_User_Field__c WHERE Name = 'ReadOnly1'];
        myKVH_User_Field__c testUserField2 = new myKVH_User_Field__c (name = 'ReadWrite1', myKVH_Feature__c = testFeat1.Id,
                                                Default_Read__c = true, Default_Edit__c = true);
        insert testUserField2;
        testUserField2 = [SELECT id, Name FROM myKVH_User_Field__c WHERE Name = 'ReadWrite1'];
        //and finally a couple of Field Permissions...
        myKVH_Field_Permission__c testFldPerm1 = new myKVH_Field_Permission__c(myKVH_Permission_Set__c = testPermSet1.id, 
                                                        myKVH_User_Field__c = testUserField1.Id, permissionEdit__c = true, permissionRead__c = true);
        insert testFldPerm1;
        testFldPerm1 = [SELECT Id, Name, myKVH_User_Field__c, myKVH_Permission_Set__c,  permissionRead__c, permissionEdit__c FROM myKVH_Field_Permission__c WHERE Name LIKE '%ReadOnly1'];
        //Field Permission Names look like "role.feature.field
        myKVH_Field_Permission__c testFldPerm2 = new myKVH_Field_Permission__c(name = 'testFldPerm2', myKVH_Permission_Set__c = testPermSet1.id, 
                                                        myKVH_User_Field__c = testUserField2.Id, permissionEdit__c = true, permissionRead__c = true);
        insert testFldPerm2;
        testFldPerm2 = [SELECT Id, Name, myKVH_User_Field__c, myKVH_Permission_Set__c,  permissionRead__c, permissionEdit__c FROM myKVH_Field_Permission__c WHERE Name LIKE '%ReadWrite1'];
        
        //reset 
        restFieldPermissions.clear();
        //let's see if a proper identifier returns the right Permission Set...
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/fieldpermissions/' + testFldPerm1.Id;  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        restFieldPermissions = REST_fieldpermissions.doGet();
        System.assertequals(1, restFieldPermissions.size());
        
        //reset 
        restFieldPermissions.clear();
        //let's see if a bogus identifier returns the right stuff.
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/fieldpermissions/a1j000000000000001';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        restFieldPermissions = REST_fieldpermissions.doGet();
        System.assertequals(0, restFieldPermissions.size());
        system.assertequals(404, res.statusCode);
        
        //reset 
        restFieldPermissions.clear();
        //let's see if a missing identifier returns the right stuff.
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/fieldpermissions/';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        restFieldPermissions = REST_fieldpermissions.doGet();
        System.assertequals(0, restFieldPermissions.size());
        system.assertequals(400, res.statusCode);
        
        //reset 
        restFieldPermissions.clear();
        //let's see if a Permission Set identifier returns the right stuff.
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/fieldpermissions/' + testPermSet1.id;  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        restFieldPermissions = REST_fieldpermissions.doGet();
        System.assertequals(2, restFieldPermissions.size());
        
        //reset 
        restFieldPermissions.clear();
        //let's see if a bogus Permission Set identifier returns an empty list.
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/fieldpermissions/a1k000000000000001';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        restFieldPermissions = REST_fieldpermissions.doGet();
        System.assertequals(0, restFieldPermissions.size());
        system.assertequals(404, res.statusCode);
        
        //reset 
        restFieldPermissions.clear();
        //let's see if a bogus Permission Set identifier returns an empty list
        //let's see if the "all" identifier returns the right number of features (should be zero with a status code of 404!)...
        req.requestURI = instance + 'salesforce.com/services/apexrest/V1/fieldpermissions/all';  
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        restFieldPermissions = REST_fieldpermissions.doGet();
        System.assertequals(2, restFieldPermissions.size());
    }
}