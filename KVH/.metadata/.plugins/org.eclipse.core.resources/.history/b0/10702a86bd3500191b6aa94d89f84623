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
@isTest //RecordTypes are metadata... don't need to SeeAllData
private class test_AccountUtilities {

    static testMethod void myUnitTest() {
		AccountUtilities util = new AccountUtilities();
		Set<Id> testSet = new Set<Id>();
		List<RecordType> testList = new List<RecordType>();
		testList = [SELECT Id, DeveloperName, sObjectType FROM RecordType];
		testSet = util.getPlatformAccountIds();
		system.assertNotEquals(testSet.size(), testList.Size());
		for (RecordType rt : testList){
			if (testSet.contains(rt.Id) == true){ //test to ensure that set contains only platforms..
				system.debug(rt.Id+rt.DeveloperName);
				system.assertEquals('Platform', rt.DeveloperName.left(8));
			} else if (testSet.contains(rt.Id) != true){ //test to ensure that set contains ALL platforms..
				system.debug(rt.Id+rt.DeveloperName);
				system.assertNotEquals('Platform', rt.DeveloperName.left(8));
			}
		}
		List<RecordType> testPlatRecTypes = new List<RecordType>();
		testPlatRecTypes = util.getPlatformRecordTypes();
		for (RecordType rt2 : testPlatRecTypes) {
			system.assertEquals('Platform', rt2.DeveloperName.left(8));
		}
    }
    static testMethod void test_getgetPlatformRecTypeIds(){
    	List<RecordType> testList = new List<RecordType>();
		testList = [SELECT Id, DeveloperName, sObjectType FROM RecordType];
		
    	AccountUtilities util = new AccountUtilities();
		Set<Id> testSet = new Set<Id>();
		testSet = util.getPlatformRecTypeIds();
		system.assertNotEquals(testSet.size(), testList.Size());
		for (RecordType rt : testList){
			if (testSet.contains(rt.Id) == true){ //test to ensure that set contains only platforms..
				system.debug(rt.Id+rt.DeveloperName);
				system.assertEquals('Platform', rt.DeveloperName.left(8));
			} else if (testSet.contains(rt.Id) != true){ //test to ensure that set contains ALL platforms..
				system.debug(rt.Id+rt.DeveloperName);
				system.assertNotEquals('Platform', rt.DeveloperName.left(8));
			}
		}
    }
}