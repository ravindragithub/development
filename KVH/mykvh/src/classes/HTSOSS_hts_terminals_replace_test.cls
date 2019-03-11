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
private class HTSOSS_hts_terminals_replace_test {

  @testSetup static void setupTestData(){ 
    //setup common test data here
  }
  
  static testMethod void testSetupData(){
    //use this method to validate that you have test data setup correctly
  }

  static testMethod void test_postTerminalsToReplace_1_OK(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_replace_mocks.mock_terminals_POST_1_OK());
    HTSOSS_hts_terminals_replace util = new HTSOSS_hts_terminals_replace();
    HTSOSS_hts_terminals_asynch term1 = new HTSOSS_hts_terminals_asynch();
    term1.coremodule_id = 1234;
    term1.mgmtipaddress = '10.242.1.14';
    term1.template_id = 'TEMPLATE_1';
    term1.terminal_ip_address = '10.64.14.0/24';
    term1.terminal_id = '12345678';
    term1.terminaltype_id = 1828;
    util.terminals.add(term1);
    HTSOSS_hts_terminals_replace returned = util.postTerminalsToReplace(util);
    test.stopTest();
    system.assertEquals(202, returned.response_code);                  //We got a 202 (per mock)
    system.assert(returned.message.contains('Successfully Created 1 Asynchronous Jobs'), returned.message);
  }
  static testMethod void test_postTerminalsToReplace_4_OK(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_replace_mocks.mock_terminals_POST_4_OK());
    HTSOSS_hts_terminals_replace util = new HTSOSS_hts_terminals_replace();
    for(Integer i = 1; i < 5; i++){
      HTSOSS_hts_terminals_asynch term1 = new HTSOSS_hts_terminals_asynch();
      term1.coremodule_id = Integer.valueOF('123' + i);
      term1.mgmtipaddress = '10.242.' + i + '.14';
      term1.template_id = 'CONUS_STANDARD';
      term1.terminal_ip_address = '10.64.' + i + '.0/24';
      term1.terminal_id = '1234567' + i;  //Can't have a trailing zero!!
      term1.terminaltype_id = 1828;
      util.terminals.add(term1);
    }
    system.debug('Here is the object to be serialized: '+ util.terminals);
    HTSOSS_hts_terminals_replace returned = util.postTerminalsToReplace(util);
    test.stopTest();
    system.assertEquals(202, returned.response_code);                  //We got a 202 (per mock)
    system.assert(returned.message.contains('Successfully Created 4 Asynchronous Jobs'), returned.message);
  }
  static testMethod void test_postTerminalsToReplace_1_FAIL_1(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_replace_mocks.mock_terminals_POST_1_OK());
    HTSOSS_hts_terminals_replace util = new HTSOSS_hts_terminals_replace();
    HTSOSS_hts_terminals_asynch term1 = new HTSOSS_hts_terminals_asynch();
    term1.coremodule_id = 1234;
    term1.mgmtipaddress = '10.242.1.14';
    term1.template_id = 'TEMPLATE_1';
    term1.terminal_ip_address = '10.64.14.0/24';
    //term1.terminal_id = '12345678';
    term1.terminaltype_id = 1828;
    util.terminals.add(term1);
    HTSOSS_hts_terminals_replace returned = util.postTerminalsToReplace(util);
    test.stopTest();
    system.assertEquals(400, returned.response_code);                  //We got a 400 (per mock)
    system.assert(returned.message.contains('FATAL_ERROR Found missing Terminal Id'));
  }
  static testMethod void test_postTerminalsToReplace_1_FAIL_2(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_replace_mocks.mock_terminals_POST_1_OK());
    HTSOSS_hts_terminals_replace util = new HTSOSS_hts_terminals_replace();
    HTSOSS_hts_terminals_asynch term1 = new HTSOSS_hts_terminals_asynch();
    term1.coremodule_id = 1234;
    //term1.mgmtipaddress = '10.242.1.14';
    term1.template_id = 'TEMPLATE_1';
    term1.terminal_ip_address = '10.64.14.0/24';
    term1.terminal_id = '12345678';
    term1.terminaltype_id = 1828;
    util.terminals.add(term1);
    HTSOSS_hts_terminals_replace returned = util.postTerminalsToReplace(util);
    test.stopTest();
    system.assertEquals(400, returned.response_code);                  //We got a 400 (per mock)
    system.assert(returned.message.contains('FATAL_ERROR Input data failed validation!'));
  }
  static testMethod void test_postTerminalsToReplace_FAIL_500(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_replace_mocks.mock_terminals_POST_FAIL());
    HTSOSS_hts_terminals_replace util = new HTSOSS_hts_terminals_replace();
    HTSOSS_hts_terminals_asynch term1 = new HTSOSS_hts_terminals_asynch();
    term1.coremodule_id = 1234;
    term1.mgmtipaddress = '10.242.1.14';
    term1.template_id = 'TEMPLATE_1';
    term1.terminal_ip_address = '10.64.14.0/24';
    term1.terminal_id = '12345678';
    term1.terminaltype_id = 1828;
    util.terminals.add(term1);
    HTSOSS_hts_terminals_replace returned = util.postTerminalsToReplace(util);
    test.stopTest();
    system.assertEquals(500, returned.response_code);                  //We got a 500 (per mock)
    system.assert(returned.message.contains('Failed to Create Asynchronous Jobs'));
  }
  static testMethod void test_postTerminalsToReplace_FAIL_OTHER(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_replace_mocks.mock_terminals_POST_FAIL_400());
    HTSOSS_hts_terminals_replace util = new HTSOSS_hts_terminals_replace();
    HTSOSS_hts_terminals_asynch term1 = new HTSOSS_hts_terminals_asynch();
    term1.coremodule_id = 1234;
    term1.mgmtipaddress = '10.242.1.14';
    term1.template_id = 'TEMPLATE_1';
    term1.terminal_ip_address = '10.64.14.0/24';
    term1.terminal_id = '12345678';
    term1.terminaltype_id = 1828;
    util.terminals.add(term1);
    HTSOSS_hts_terminals_replace returned = util.postTerminalsToReplace(util);
    test.stopTest();
    system.assertEquals(400, returned.response_code);                  //We got a 400 (per mock)
    system.assert(returned.message.contains('Some sort of error message'));
  }
}