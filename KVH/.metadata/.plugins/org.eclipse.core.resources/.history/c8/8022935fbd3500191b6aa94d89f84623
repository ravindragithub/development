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
private class HTSOSS_hts_terminals_status_test {

	@testSetup static void setupTestData(){
		//setup common test data here
	}
	
	static testMethod void testSetupData(){
		//use this method to validate that you have test data setup correctly
	}
  static testMethod void test_getTerminalsStatus(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_status_mocks.mock_terminals_status());
    HTSOSS_hts_terminals_status util = new HTSOSS_hts_terminals_status();
    HTSOSS_hts_terminals term1 = new HTSOSS_hts_terminals();
    term1.obj_id = 3740;
    HTSOSS_hts_terminals_status mockRes = util.getTerminalStatus(term1);
    system.assertEquals(mockRes.response_code, 200);
    system.assertEquals(mockRes.message, 'mock test message');
    
	  system.assertEquals(mockRes.activation_state,'activated');
	  system.assertEquals(mockRes.config_state,'nominal');
	  system.assertEquals(mockRes.detail_message,'');
	  system.assertEquals(mockRes.distress_state,'ok');
	  system.assertEquals(mockRes.obj_id,3238);
	  system.assertEquals(mockRes.obj_name,'KVH-Terminal-AWMTEST14');
	  system.assertEquals(mockRes.obj_parentid,57);
	  system.assertEquals(mockRes.operational_state,'Unknown');
	  system.assertEquals(mockRes.operational_state_detail,'');
	  system.assertEquals(mockRes.operational_state_id,'0');
	  system.assertEquals(mockRes.performance_state,'Unknown');
	  system.assertEquals(mockRes.performance_state_detail,'');
	  system.assertEquals(mockRes.performance_state_id,'0');
	  system.assertEquals(mockRes.state_calculation_done,'1');
	  system.assertEquals(mockRes.update_state,'Unknown');
	  system.assertEquals(mockRes.update_state_detail,'');
	  system.assertEquals(mockRes.update_state_id,'0');
    test.stopTest();
  }
}