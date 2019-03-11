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
private class test_AttachmentUploadController {
	private static final integer MAX_LOOP_COUNTER = 5;
	@testSetup static void setupTestData(){
		list<Account> acctList = new list<Account>();
		for(integer i = 0; i < MAX_LOOP_COUNTER; i++){
			Account a = new Account();
			a.Name = i + 'IC test Acct';
			acctList.add(a);
		}
		insert acctList;
		list<Install_Config__c> IClist = new list<Install_Config__c>();
		for(integer i = 0; i < MAX_LOOP_COUNTER; i++){
			Install_Config__c IC = new Install_Config__c();
			IC.Account_Name__c = acctList[i].Id;
			ICList.add(IC);
		}
		insert ICList; 
	}

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        //Need an install and config
        // and an attachment
        // and a page
        list<Install_Config__c> IClist = [SELECT Id, Name FROM Install_Config__c];
        AttachmentUploadController AUC = new AttachmentUploadController();
        Test.setCurrentPageReference(new PageReference('Page.AttachmentUpload')); 
		System.currentPageReference().getParameters().put('retURL', '/home/home.jsp');
		System.currentPageReference().getParameters().put('id', IClist[0].Id);
		
		Attachment att = AUC.attachment;
		
		PageReference home = new PageReference('/home/home.jsp');
		system.assertEquals(home.getUrl(), AUC.cancel().getUrl());
		PageReference Redirect = AUC.upload();
		system.assertEquals(home.getUrl(), Redirect.getUrl());
    }
}