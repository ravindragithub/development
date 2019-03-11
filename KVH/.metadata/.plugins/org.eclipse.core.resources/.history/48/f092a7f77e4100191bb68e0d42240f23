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
private class CustomerPortalApps_Test {
    
    @testSetup static void setupTestData(){
        PermissionSet objPermissionSet = [SELECT Id FROM PermissionSet WHERE Name = 'Activation_Portal_Users'];
        PermissionSetAssignment objPermissionSetAssignment = new PermissionSetAssignment();
        objPermissionSetAssignment.AssigneeId = userInfo.getUserId();
        objPermissionSetAssignment.PermissionSetId = objPermissionSet.Id;
        insert objPermissionSetAssignment;  
        system.assert(objPermissionSetAssignment != null);
    }
    
    static testMethod void test_CustomerPortalApps() {
        CustomerPortalApps objCustomerPortalApps = new CustomerPortalApps();
        // with Permission set Activation_Portal_Users
        system.assertEquals(true, objCustomerPortalApps.boolRenderPermissionSet);
        List<PermissionSetAssignment> lstPermissionSetAssignment = New List<PermissionSetAssignment>(); 
        lstPermissionSetAssignment = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId =: userInfo.getUserId() AND PermissionSet.Name = 'Activation_Portal_Users'];
        system.assert(lstPermissionSetAssignment.size()>0);
        delete lstPermissionSetAssignment;
        CustomerPortalApps objCustomerPortalApps1 = new CustomerPortalApps();
        // without Permission set Activation_Portal_Users
        system.assertEquals(false, objCustomerPortalApps1.boolRenderPermissionSet);
    }
    
    Static testMethod void testCaseCreation(){
        Test.startTest();
        CustomerPortalApps objCustomerPortalApps1 = new CustomerPortalApps();
        objCustomerPortalApps1.createcaseMethod();
        system.assertEquals(false, objCustomerPortalApps1.boolRenderWarningMessage);
        Test.stopTest();
    }
    
}