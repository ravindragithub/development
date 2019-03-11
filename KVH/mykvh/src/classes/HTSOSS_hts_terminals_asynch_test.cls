@isTest
private class HTSOSS_hts_terminals_asynch_test {

  @testSetup static void setupTestData(){ 
    //setup common test data here
  }
  
  static testMethod void testSetupData(){
    //use this method to validate that you have test data setup correctly
  }
  static testMethod void test_validationMethods(){
    HTSOSS_hts_terminals_asynch testTerminal = new HTSOSS_hts_terminals_asynch();
    string validationResults = testTerminal.validateTerminalForPOST(testTerminal);
    system.assertEquals('INVALID', validationResults.left(7));
    validationResults = testTerminal.validateTerminalForGET(testTerminal);
    system.assertEquals('INVALID', validationResults.left(7));
  }
  /* Test GET services */
  static testMethod void test_getAsyncStatus_OK(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_asynch_mocks.mock_terminals_asynch_GET_OK());
    HTSOSS_hts_terminals_asynch term1 = new HTSOSS_hts_terminals_asynch();
    
    term1.obj_id = 'b96e0041-676b-4728-97cf-9f1b1a73f7c0';
    term1 = term1.getAsyncStatus(term1);
    CalloutLogs.commitLogs();
    test.stopTest();
    list<Callout_Log__c> logList = [SELECT Id, Req_Endpoint__c FROM Callout_Log__c];
    system.assertEquals('?obj_id=' + 'b96e0041-676b-4728-97cf-9f1b1a73f7c0', logList[0].Req_Endpoint__c.right(44));
    system.assertEquals(200, term1.response_code);                  //We got a 200 (per mock)
    system.assertEquals('b96e0041-676b-4728-97cf-9f1b1a73f7c0', term1.obj_id);
    system.assertEquals(true, term1.complete);
    system.assertEquals(true, term1.result);
  }
  static testMethod void test_getAsyncStatus_404(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_asynch_mocks.mock_terminals_asynch_GET_404());
    HTSOSS_hts_terminals_asynch term1 = new HTSOSS_hts_terminals_asynch();
    
    term1.obj_id = 'b96e0041-676b-4728-97cf-9f1b1a73f7c0';
    term1 = term1.getAsyncStatus(term1);
    test.stopTest();
    system.assertEquals(404, term1.response_code);                  //We got a 200 (per mock)
    system.assertEquals('Task obj_id does not exist.', term1.message.left(27));
  }
  static testMethod void test_terminals_GET_FAIL_500(){
    test.startTest();
    //Borrow a mock from hts_terminals for this test Method....
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_mocks.mock_terminals_general_fail(500));
    HTSOSS_hts_terminals_asynch term1 = new HTSOSS_hts_terminals_asynch();
    
    term1.obj_id = 'b96e0041-676b-4728-97cf-9f1b1a73f7c0';
    term1 = term1.getAsyncStatus(term1);
    
    system.assertEquals(500, term1.response_code);                  //We got a 400 (per validation method)
    test.stopTest();
  }
  static testMethod void test_terminals_GET_Validation_FAIL(){
    test.startTest();
    //Borrow a mock from hts_terminals for this test Method....
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_mocks.mock_terminals_general_fail(500));
    HTSOSS_hts_terminals_asynch term1 = new HTSOSS_hts_terminals_asynch();
    
    //term1.obj_id = 'b96e0041-676b-4728-97cf-9f1b1a73f7c0';
    term1 = term1.getAsyncStatus(term1);
    
    system.assertEquals(400, term1.response_code);                  //We got a 400 (per validation method)
    test.stopTest();
  }
  static testMethod void test_terminals_GET_Validation_FAIL_2(){
    test.startTest();
    //Borrow a mock from hts_terminals for this test Method....
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_mocks.mock_terminals_general_fail(500));
    HTSOSS_hts_terminals_asynch term1 = new HTSOSS_hts_terminals_asynch();
    
    term1.obj_id = '96e0041-676b-4728-97cf-9f1b1a73f7c0';
    term1 = term1.getAsyncStatus(term1);
    
    system.assertEquals(400, term1.response_code);                  //We got a 400 (per validation method)
    test.stopTest();
  }
  /* Test POST services */
	static testMethod void test_terminals_POST_OK(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_asynch_mocks.mock_terminals_asynch_POST_OK());
    HTSOSS_hts_terminals_asynch term1 = new HTSOSS_hts_terminals_asynch();
    
    term1.coremodule_id = 1234;
    term1.mgmtipaddress = '10.242.1.14';
    term1.template_id = 'CONUS_STANDARD';
    term1.terminal_ip_address = '10.64.14.0/24';
    term1.terminal_id = '12345678';
    term1.terminaltype_id = 1828;
    term1 = term1.postTerminalAsynch(term1);
    test.stopTest();
    system.assertEquals(200, term1.response_code);                  //We got a 200 (per mock)
    system.assertEquals('2a501c37-09cf-474a-93f5-198d47b17680', term1.obj_id);
  }
  static testMethod void test_terminals_POST_Validation_FAIL(){
    test.startTest();
    //Don't really need a mock for this test Method....
    //test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_asynch_mocks.mock_terminals_asynch_POST_OK());
    HTSOSS_hts_terminals_asynch term1 = new HTSOSS_hts_terminals_asynch();
    
    term1.coremodule_id = 1234;
    term1.mgmtipaddress = '10.242.1.14';
    term1.template_id = 'CONUS_STANDARD';
    term1.terminal_ip_address = '10.64.14.0/24';
    //term1.terminal_id = '12345678';
    term1.terminaltype_id = 1828;
    term1 = term1.postTerminalAsynch(term1);
    
    system.assertEquals(400, term1.response_code);                  //We got a 400 (per validation method)
    test.stopTest();
  }
  static testMethod void test_terminals_POST_FAIL_500(){
    test.startTest();
    //Borrow a mock from hts_terminals for this test Method....
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_mocks.mock_terminals_general_fail(500));
    HTSOSS_hts_terminals_asynch term1 = new HTSOSS_hts_terminals_asynch();
    
    term1.coremodule_id = 1234;
    term1.mgmtipaddress = '10.242.1.14';
    term1.template_id = 'CONUS_STANDARD';
    term1.terminal_ip_address = '10.64.14.0/24';
    term1.terminal_id = '12345678';
    term1.terminaltype_id = 1828;
    term1 = term1.postTerminalAsynch(term1);
    
    system.assertEquals(500, term1.response_code);                  //We got a 400 (per validation method)
    test.stopTest();
  }
  static testMethod void test_terminals_POST_FAIL_304(){
    test.startTest();
    //Borrow a mock from hts_terminals for this test Method....
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_mocks.mock_terminals_general_fail(304));
    HTSOSS_hts_terminals_asynch term1 = new HTSOSS_hts_terminals_asynch();
    
    term1.coremodule_id = 1234;
    term1.mgmtipaddress = '10.242.1.14';
    term1.template_id = 'CONUS_STANDARD';
    term1.terminal_ip_address = '10.64.14.0/24';
    term1.terminal_id = '12345678';
    term1.terminaltype_id = 1828;
    term1 = term1.postTerminalAsynch(term1);
    
    system.assertEquals(304, term1.response_code);                  //We got a 400 (per validation method)
    test.stopTest();
  }
}