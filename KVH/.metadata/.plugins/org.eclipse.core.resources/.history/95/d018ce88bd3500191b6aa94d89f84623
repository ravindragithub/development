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
@isTest (SeeAllData=true)
private class test_platform_record_type_controller {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
		Map<Id, String> PlatformRecordTypes = new Map<Id, String>();
		
		List<RecordType> AllRecTypes = new List<RecordType>();
		AllRecTypes = [SELECT Id, DeveloperName, Name, SobjectType FROM RecordType];
		for (RecordType RT : AllRecTypes){
			if (RT.DeveloperName.left(9) == 'Platform_' ){
				PlatformRecordTypes.put(RT.Id, RT.DeveloperName);
			}
		}
		system.debug(PlatformRecordTypes);
		system.debug(AllRecTypes); //This List contains all the Record Type Ids.
		List<String> DevNames = new List<String>();
		DevNames = PlatformRecordTypes.values();
		for (String RTDN : DevNames) {
			system.AssertEquals('Platform_', RTDN.left(9) );
		}
		
		platform_record_type_controller ctrlr = new platform_record_type_controller();
		PageReference pageRef = Page.platform_record_types;
		Test.setCurrentPage(pageRef);
		List<RecordType> PageRecTypes = new List<RecordType>();
		PageRecTypes = ctrlr.getItems();
		for (RecordType PageRT : PageRecTypes) {
			system.assertEquals('Platform_', PageRT.DeveloperName.left(9));
		}
    }
}