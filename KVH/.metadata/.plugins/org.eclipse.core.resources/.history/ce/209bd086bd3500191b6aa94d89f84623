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
private class test_KVHUpdateServices {

    static testMethod void myUnitTest() {
		// TO DO: implement unit test
		//create a test beam....
		for (Integer i = 0; i<5; i++){
			Beam__c testBeam = new beam__c(Name = 'TEST BEAM '+string.valueOf(i),
			//ACU_Name__c = 'Test Beam '+string.valueOf(i), populated by Workflow to match Name
			Map_Name__c = 'Test Map Name '+string.valueOf(i), 
			SAT_Long__c = 90, SAT_Name__c ='Test Sat Name '+string.valueOf(i), 
			Feed_Designator__c = 'TestFD '+string.valueOf(i),
			Frequency_KU_Downlink_MHz__c = 12643);
			insert testBeam;
		}
        // we got beams...
        List<beam__c> Beams = new List<beam__c>([SELECT id, Name FROM beam__c]);
        system.debug(Beams[0].id);
		
		
		//Event currentEvent = new Event(ownerid=currentUser.Id, subject='Test',
		//startdatetime=System.Now(), enddatetime=System.Now());

		ApexPages.StandardController sc = new ApexPages.StandardController(Beams[0]);
		KVHUpdateServices KUs = new KVHUpdateServices(sc);

		PageReference pageRef = Page.BeamDataToKVHUpdate;
		pageRef.getParameters().put('id', String.valueOf(Beams[0].id));
		//PageReference pageRef = new PageReference('/' + currentUser.ID);
		Test.setCurrentPage(pageRef);

		KUs.autorun();	//need to be a little careful with the autoRun method
		String theId = ApexPages.currentPage().getParameters().get('id');
		system.assertEquals(String.valueOf(Beams[0].id), theId);
	}
}