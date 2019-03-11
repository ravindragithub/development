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
private class SendAirtimeConfController_ext_test {
	
	@testSetup static void setupTestData(){
		//Need a Contact...
		Contact co = new Contact();
		co.LastName = 'testContact';
		co.email = 'testContact@airtimeConf.mail';
		insert co;
		//and a case for sure....
		Case c = new case();
		c.Subject = 'Airtime Confirmation Test New Case';
		c.status = 'New';
		//c.RecordTypeId = myKVH_Feedback_RECORD_TYPE_ID;
		insert c;
	}

    static testMethod void testSetupData() {
        // TO DO: implement unit test
        Case readCase = new Case();
        readCase = [SELECT Id, Subject, status FROM Case WHERE Subject = 'Airtime Confirmation Test New Case' LIMIT 1];
        system.assertEquals(readCase.status, 'New');
    }
    
    static testMethod void testCtrlExt_noParams(){
    	Case readCase = new Case();
        readCase = [SELECT Id, Subject, status FROM Case WHERE Subject = 'Airtime Confirmation Test New Case' LIMIT 1];
        system.assertEquals(readCase.status, 'New');
        
    	PageReference pageRef = page.SendAirtimeConfirmationLetter;
        Test.setCurrentPage(pageRef);
		ApexPages.StandardController con = new ApexPages.StandardController(readCase);
        SendAirtimeConfirmationController_ext ctrlExt = new SendAirtimeConfirmationController_ext(con);
        
        PageReference p = ctrlExt.autoRun();
        system.assertEquals(null, p);
        
        //Add Params to page
        ApexPages.currentPage().getParameters().put('Id', readCase.Id);
        con = new ApexPages.StandardController(readCase);
        ctrlExt = new SendAirtimeConfirmationController_ext(con);
        p = ctrlExt.autoRun();
        string URI = p.getUrl();
        system.assertEquals('/_ui/core/email/author/EmailAuthor', URI.left(34));
    }
}