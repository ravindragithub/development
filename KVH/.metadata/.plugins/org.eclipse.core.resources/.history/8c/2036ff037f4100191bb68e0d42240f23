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
private class JKT_myKVHPermissionsMatrixTest {

    static testMethod void JKT_myKVHPermissionsMatrixTest1() {
       myKVH_Role__c oRole = new myKVH_Role__c();
       oRole.Name = 'Test-Role';
       insert oRole;
       
       myKVH_Feature__c oFeature1 = new myKVH_Feature__c();
       oFeature1.Name = 'Test-Feature1';
       insert oFeature1;
       
       myKVH_Feature__c oFeature2 = new myKVH_Feature__c();
       oFeature2.Name = 'Test-Feature2';
       insert oFeature2;
       
       myKVH_Permission_Set__c oPermission = new myKVH_Permission_Set__c();
       oPermission.Name = 'Test-Permission';
       oPermission.myKVH_Role__c = oRole.Id;
       oPermission.myKVH_Feature__c = oFeature1.Id;
       insert oPermission;
       
       JKT_myKVHPermissionsMatrix objPermissionMatrix = new JKT_myKVHPermissionsMatrix();
    }
}