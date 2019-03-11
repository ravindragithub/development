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
private class HTSOSS_hts_collections_test {

  @testSetup static void setupTestData(){
    //setup common test data here 
  }
  
  static testMethod void testSetupData(){
    //use this method to validate that you have test data setup correctly
  }

	static testMethod void test_inner_class_constructors() {
    // TO DO: implement unit test
    // test terminal_plan
    HTSOSS_hts_collections.subscriber_plans test_subscriber_plans = new HTSOSS_hts_collections.subscriber_plans();
    test_subscriber_plans.obj_id = 'ID is now a string';
    test_subscriber_plans.obj_name = 'Everyone has a Name';
    system.assertEquals('ID is now a string', test_subscriber_plans.obj_id);
    system.assertEquals('Everyone has a Name', test_subscriber_plans.obj_name);
    
    // test satellite_router_type
    HTSOSS_hts_collections.satellite_router_type test_satellite_router_type = new HTSOSS_hts_collections.satellite_router_type();
    test_satellite_router_type.obj_id = '1';
    test_satellite_router_type.obj_name = 'Everyone has a Name';
    system.assertEquals('1', test_satellite_router_type.obj_id);
    system.assertEquals('Everyone has a Name', test_satellite_router_type.obj_name);
    
    // test terminal_type
    HTSOSS_hts_collections.terminal_type test_terminal_type = new HTSOSS_hts_collections.terminal_type();
    test_terminal_type.obj_id = 1;
    test_terminal_type.obj_name = 'Everyone has a Name';
    system.assertEquals(1, test_terminal_type.obj_id);
    system.assertEquals('Everyone has a Name', test_terminal_type.obj_name);
    
    // test terminalnetwork
    HTSOSS_hts_collections.terminalnetwork test_termnet = new HTSOSS_hts_collections.terminalnetwork();
    test_termnet.obj_parentid = 12345;
    test_termnet.eth0ip = '10.64.12.1';
    system.assertEquals(12345, test_termnet.obj_parentid);
    system.assertEquals('10.64.12.1', test_termnet.eth0ip);
	}
	
	static testMethod void test_getRtp(){
	  test.startTest();
	  test.setMock(HttpCalloutMock.class, new HTSOSS_hts_collections_mocks.mock_rtp());
	  HTSOSS_hts_collections util = new HTSOSS_hts_collections();
	  HTSOSS_hts_collections.rtp mockRes = util.getRtp();
	  
	  system.assertEquals(2, mockRes.terminal_types.size()); //we got two, right?
	  for(HTSOSS_hts_collections.terminal_type htstt : mockRes.terminal_types){
	    system.assertEquals('KVH-Lab TermType', htstt.obj_name.left(16));
	  }
	  
	  system.assertEquals(4, mockRes.satellite_router_types.size()); //we got four, right?
	  //TODO Figure out a way to process and assert values from MOCK
	  system.assertEquals(1, mockRes.subscriber_plans.size()); //There is ONE in the Mock response
	  for(HTSOSS_hts_collections.subscriber_plans htstt : mockRes.subscriber_plans){
      system.assertEquals('OP2K', htstt.obj_name);
      system.assertEquals('OP2K', htstt.obj_id);
      system.assertEquals(0.2560, htstt.upload_cir);
      system.assertEquals(10.0000, htstt.out_bmc_download_mir);
      system.assertEquals(1.0000, htstt.download_cir);
      system.assertEquals(1.0000, htstt.in_bmc_download_mir);
      system.assertEquals(3.0000, htstt.out_bmc_upload_mir);
      system.assertEquals(0.2560, htstt.in_bmc_upload_mir);
	  }
	  
	  system.assertEquals(2, mockRes.terminal_templates.size()); //we got two, right?
    for(HTSOSS_hts_collections.terminal_templates htstt : mockRes.terminal_templates){
      system.assertEquals('TEMPLATE_', htstt.obj_name.left(9));
      system.assertEquals('TEMPLATE_', htstt.obj_id.left(9));
    }

	  system.assertEquals(200, mockRes.response_code);
	  test.stopTest();
	}
	static testMethod void test_getTerminalNetworks(){
	  test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_collections_mocks.mock_terminalnetworks());
    HTSOSS_hts_collections util = new HTSOSS_hts_collections();
    HTSOSS_hts_collections.terminalnetworks mockRes = util.getTerminalNetworks();
    system.assertEquals(200, mockRes.response_code);
    system.assertEquals('OK', mockRes.message);
    system.assertEquals(24, mockRes.terminalnetworks.size());
    test.stopTest();
	}
}