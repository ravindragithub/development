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
private class test_PortTrigger {
	//Need to create, then delete a Port
	//verify that we create a deleted record
	private static final integer MAX_LOOP_COUNTER = 200;			//use this to control the # of records used for test
	@testSetup static void CreateTestData(){
		list<Port__c> portList = new list<Port__c>();
		for(integer i = 0; i<MAX_LOOP_COUNTER; i++){
			Port__c testPort = new Port__c(Name = 'Test Port' + i);
			portList.add(testPort);
		}
		insert portList;
	}
    static testMethod void testDeleteHandler() {
        // TO DO: implement unit test
        //ARRANGE
        list<Port__c> portList = new list<Port__c>();
        portList = [SELECT Id, Name FROM Port__c WHERE Name LIKE 'Test Port%'];
        system.assertEquals(MAX_LOOP_COUNTER,portList.size());
        //ACT
        delete portList;
        //ASSERT
        list<myKVH_Deleted_Records__c> DelRecs = new list<myKVH_Deleted_Records__c>();
        DelRecs = [SELECT Id, Name FROM myKVH_Deleted_Records__c];
        system.assertEquals(portList.size(), DelRecs.size());
    }
}