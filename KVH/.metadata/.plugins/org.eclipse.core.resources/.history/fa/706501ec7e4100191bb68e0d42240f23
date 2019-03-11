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
private class ActivationsController_test {

    static testMethod void testselfActivation() {
        // TO DO: implement unit test
        PageReference thePage = page.Activations;
		Test.setCurrentPage(thePage);
		ActivationsController ctrl = new ActivationsController();
		PageReference response;
		Activation_Order__c ActOrder;
		
		//Verify that the selfActivation button returns appropriate value
		response = ctrl.selfActivation();										//This should create a new Activation_Order__c record
		list<Activation_Order__c> ActOrdList = new list<Activation_Order__c>();	//Let's get all ACtivation_Orders from the database....
		ActOrdList = [SELECT ID, Name FROM Activation_Order__c];				
		system.assertEquals(1,ActOrdList.size());								//but there should be ONLY one!
		ActOrder = ActOrdList[0];												//the one we just created!
		system.assertEquals('/apex/account_setup', response.getURL().left(19));
		system.assertEquals(ActOrder.Id, response.getParameters().get('order'));
		
	}
	static testMethod void testdealerActivation(){
		PageReference thePage = page.Activations;
        thePage.getParameters().put('accountType', 'customer');
		Test.setCurrentPage(thePage);
		ActivationsController ctrl = new ActivationsController();
		PageReference response;
		Activation_Order__c ActOrder;
		
		//Verify that the selfActivation button returns appropriate value
		response = ctrl.dealerActivation();										//This should create a new Activation_Order__c record
		list<Activation_Order__c> ActOrdList = new list<Activation_Order__c>();	//Let's get all ACtivation_Orders from the database....
		ActOrdList = [SELECT ID, Name FROM Activation_Order__c];				
		system.assertEquals(1,ActOrdList.size());								//but there should be ONLY one!
		ActOrder = ActOrdList[0];												//the one we just created!
       
		system.assertEquals('/apex/account_setup', response.getURL().left(19));
		system.assertEquals(ActOrder.Id, response.getParameters().get('order'));
	}
}