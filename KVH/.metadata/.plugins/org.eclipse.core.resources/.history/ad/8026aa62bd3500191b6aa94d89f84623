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
private class HTS_virtual_terminal_ids_test { 

	@testSetup static void setupTestData(){
	    //setup common test data here... none required
	}
	
	static testMethod void testSetupData(){
	    //use this method to validate that you have test data setup correctly
	}

	static testMethod void test_gererate_VTIDs() {
    // TO DO: implement unit test
    HTS_virtual_terminal_ids util = new HTS_virtual_terminal_ids();
    system.debug('Number Created: ' + util.generateSubscriptionIds(1000));
    list<HTS_Virtual_Terminal_ID__c> delList = [SELECT Id FROM HTS_Virtual_Terminal_ID__c];
    system.assertEquals(1000, delList.size());
	}
	static testMethod void test_too_many_VTIDs(){
	  HTS_virtual_terminal_ids util = new HTS_virtual_terminal_ids();
	system.assertEquals('Generator limited to 1000 or less', util.generateSubscriptionIds(1001));
	}
	static testMethod void test_getNextAvailableVTID(){
    // TO DO: implement unit test
    HTS_virtual_terminal_ids util = new HTS_virtual_terminal_ids();
    system.debug('Number Created: ' + util.generateSubscriptionIds(3));
    list<HTS_Virtual_Terminal_ID__c> delList = [SELECT Id, Virtual_Terminal_Id__c, isReserved__c, Date_Issued__c FROM HTS_Virtual_Terminal_ID__c];
    system.assertEquals(3, delList.size());
    delList[0].isReserved__c = true;
    delList[1].Date_Issued__c = datetime.now();
    string nextAvailable = delList[2].Virtual_Terminal_Id__c;
    update delList;
    HTS_Virtual_Terminal_ID__c nextVTID = util.getNextAvailableVTID();
    system.assertEquals(nextAvailable, nextVTID.Virtual_Terminal_Id__c);
	}
}