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
@isTest //(SeeAllData=true)	//Need to See all data because the trigger handlers create records which is what we are testing!
private class Test_myKVH_RandP_Triggers {

    static testMethod void myUnitTest() {
        // TO DO: enhance test Class to test bulk operations...
		//Need some test data....
        //a couple of User Fields, and a couple of permission sets (and addition required fields...)
        //Need a Role, and Feature
        //One Role
        myKVH_Role__c testRole1 = new myKVH_Role__c(Name = 'myKVH:testRole1', Description__c = 'This is a Test Description');
        insert testRole1;
        testRole1 = [SELECT id, Name, Description__c FROM myKVH_Role__c WHERE Name = 'myKVH:testRole1'];
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
        testPermSet1 = [SELECT Id, Name, myKVH_Role__c, myKVH_Feature__c, myKVH_Feature__r.Name, canUpdate__c, canRead__c, canDelete__c, canCreate__c
                        FROM myKVH_Permission_Set__c WHERE Name LIKE '%testFeat1']; // Workflow renames PermSet
        system.debug(testPermSet1);

        // Now we Need a couple of User Fields too....
        myKVH_User_Field__c testUserField1 = new myKVH_User_Field__c (name = 'ReadOnly1', myKVH_Feature__c = testFeat1.Id,
                                                Default_Read__c = true, Default_Edit__c = false);
        insert testUserField1;
        testUserField1 = [SELECT id, Name FROM myKVH_User_Field__c WHERE Name = 'ReadOnly1'];
        
        //and finally a couple of Field Permissions...
        myKVH_Field_Permission__c testFldPerm1 = new myKVH_Field_Permission__c(myKVH_Permission_Set__c = testPermSet1.id, 
                                                        myKVH_User_Field__c = testUserField1.Id, permissionEdit__c = true, permissionRead__c = true);
        insert testFldPerm1;
        testFldPerm1 = [SELECT Id, Name, myKVH_User_Field__c, myKVH_Permission_Set__c,  permissionRead__c, permissionEdit__c FROM myKVH_Field_Permission__c WHERE Name LIKE '%ReadOnly1'];
        system.debug(testFldPerm1);
        
        //Field Permission Names look like "role.feature.field

        //That should exercise all of the insert contexts.... now we can do the update contexts....
        update testRole1;
        update testFeat1;
        update testPermSet1;
        update testUserField1;
        update testFldPerm1;
        
        //Now to exercise the delete contexts. The data models require deletions from the bottom up (IE you can't delete a role until all features and field perms are deleted)
        myKVH_Deleted_Records__c dltd = new myKVH_Deleted_Records__c();		//Need to query for the record...
        //First
        delete testFldPerm1;
        
		dltd = [SELECT id, Name, Deleted_Record_ID__c, Object_Type__c FROM myKVH_Deleted_Records__c WHERE  Deleted_Record_ID__c =: testFldPerm1.Id LIMIT 1];
		system.assertEquals(testFldPerm1.Name, dltd.Name);
		system.assertEquals('myKVH_Field_Permission__c', dltd.Object_Type__c);
		
		//Second
		delete testPermSet1;
		dltd = [SELECT id, Name, Deleted_Record_ID__c, Object_Type__c FROM myKVH_Deleted_Records__c WHERE Deleted_Record_ID__c =: testPermSet1.Id LIMIT 1];
		system.assertEquals(testPermSet1.Name, dltd.Name);
		system.assertEquals('myKVH_Permission_Set__c', dltd.Object_Type__c);

		//Third
		delete testUserField1;
		dltd = [SELECT id, Name, Deleted_Record_ID__c, Object_Type__c FROM myKVH_Deleted_Records__c WHERE Deleted_Record_ID__c =: testUserField1.Id LIMIT 1];
		system.assertEquals(testUserField1.Name, dltd.Name);
		system.assertEquals('myKVH_User_Field__c', dltd.Object_Type__c);
		
		//Fourth
		delete testFeat1;
		dltd = [SELECT id, Name, Deleted_Record_ID__c, Object_Type__c FROM myKVH_Deleted_Records__c WHERE Deleted_Record_ID__c =: testFeat1.Id LIMIT 1];
		system.assertEquals(testFeat1.Name, dltd.Name);
		system.assertEquals('myKVH_Feature__c', dltd.Object_Type__c);
		
		//Fifth
		delete testRole1;
		dltd = [SELECT id, Name, Deleted_Record_ID__c, Object_Type__c FROM myKVH_Deleted_Records__c WHERE Deleted_Record_ID__c =: testRole1.Id LIMIT 1];
		system.assertEquals(testRole1.Name, dltd.Name);
		system.assertEquals('myKVH_Role__c', dltd.Object_Type__c);
    }
}