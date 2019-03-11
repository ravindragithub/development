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
private class test_CMS_Link_ctrlEXT {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        //create a password
        Security__c pw = new Security__c();
        pw.Name = 'CMS Link';
        pw.Key__c = 'testPW';
        insert pw;
        //create test page
        PageReference testPage = Page.CMS_Link;
        //test constructor
        CMS_Link_ctrlEXT ctrl = new CMS_Link_CtrlEXT();
        //test with no params
        test.setCurrentPage(testPage);
        system.Assert(ctrl.autoRun() == null);
        //test with correct param
        ApexPages.currentPage().getParameters().put('swserial', '123456789');
        system.Assert(ctrl.autoRun() != null);
        
    }
}