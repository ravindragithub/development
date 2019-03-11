@isTest
private class HTSOSS_hts_terminals_staticips_test {
//setup testClass variables here. For example:
//RecordType Ids
/*private static final Id Customer_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();*/
//A common Loop Counter for bulikification purposes
/*private static final integer MAX_LOOP_COUNTER = 200;*/
  
  @testSetup static void setupTestData(){
    //setup common test data here
  }
  
  static testMethod void testSetupData(){
    //use this method to validate that you have test data setup correctly
    //this will protect you from changes to workflow, process, and validation that break your test code!
  }
  //test DELETE
  static testMethod void test_deleteStaticIp_OK(){
    HTSOSS_hts_terminals_staticips util = new HTSOSS_hts_terminals_staticips();
    HTSOSS_hts_terminals_staticips.staticIp singleStatic = new HTSOSS_hts_terminals_staticips.staticIp();
    singleStatic.obj_id = '12345678-10.83.42.66';
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.obj_id = 1234;
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_staticips_mocks.mock_staticips_NO_BODY(204));
    util = util.deleteStaticIp(testTerm, singleStatic);
    test.stopTest();
    system.assertEquals(204, util.response_code, util);
  }
  static testMethod void test_deleteStaticIp_FAIL_400(){
    HTSOSS_hts_terminals_staticips util = new HTSOSS_hts_terminals_staticips();
    HTSOSS_hts_terminals_staticips.staticIp singleStatic = new HTSOSS_hts_terminals_staticips.staticIp();
    //singleStatic.obj_id = '12345678-10.83.42.66';
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.obj_id = 1234;
    test.startTest();
    util = util.deleteStaticIp(testTerm, singleStatic);
    system.assertEquals(400, util.response_code, util);
    system.assertEquals('Input Static IP missing obj_id', util.message, util);
    //reset
    singleStatic.obj_id = '12345678-10.83.42.66';
    testTerm.obj_id = null;
    util = util.deleteStaticIp(testTerm, singleStatic);
    system.assertEquals(400, util.response_code, util);
    system.assertEquals('Input Terminal missing obj_id', util.message, util);
    test.stopTest();
  }
  static testMethod void test_deleteStaticIp_404(){
    HTSOSS_hts_terminals_staticips util = new HTSOSS_hts_terminals_staticips();
    HTSOSS_hts_terminals_staticips.staticIp singleStatic = new HTSOSS_hts_terminals_staticips.staticIp();
    singleStatic.obj_id = '12345678-10.83.42.66';
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.obj_id = 1234;
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_staticips_mocks.mock_staticips_NO_BODY(404));
    util = util.deleteStaticIp(testTerm, singleStatic);
    test.stopTest();
    system.assertEquals(404, util.response_code, util);
    system.assertEquals('OSS Failed to find the Terminal for Static IP un-mapping', util.message, util);
  }
  static testMethod void test_deleteStaticIp_500(){
    HTSOSS_hts_terminals_staticips util = new HTSOSS_hts_terminals_staticips();
    HTSOSS_hts_terminals_staticips.staticIp singleStatic = new HTSOSS_hts_terminals_staticips.staticIp();
    singleStatic.obj_id = '12345678-10.83.42.66';
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.obj_id = 1234;
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_staticips_mocks.mock_staticips_NO_BODY(500));
    util = util.deleteStaticIp(testTerm, singleStatic);
    test.stopTest();
    system.assertEquals(500, util.response_code, util);
    system.assertEquals('OSS Failed to delete Static IP', util.message, util);
  }
  static testMethod void test_deleteStaticIp_FAIL_ANY(){
    HTSOSS_hts_terminals_staticips util = new HTSOSS_hts_terminals_staticips();
    HTSOSS_hts_terminals_staticips.staticIp singleStatic = new HTSOSS_hts_terminals_staticips.staticIp();
    singleStatic.obj_id = '12345678-10.83.42.66';
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.obj_id = 1234;
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_staticips_mocks.mock_staticips_NO_BODY(501));
    util = util.deleteStaticIp(testTerm, singleStatic);
    test.stopTest();
    system.assertEquals(501, util.response_code, util);
  }
  //test POST
  static testMethod void test_postStaticIp_OK(){
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.obj_id = 1234;
    HTSOSS_hts_terminals_staticips requestObj = new HTSOSS_hts_terminals_staticips();
    requestObj.static_ip_address = '199.244.86.194';
    requestObj.terminal_ip_address = '10.83.83.64';
    requestObj.data_channel_id = 1703;
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_staticips_mocks.mock_staticips_NO_BODY(201));
    HTSOSS_hts_terminals_staticips util = new HTSOSS_hts_terminals_staticips();
    test.startTest();
    util = util.postStaticIp(testTerm, requestObj);
    test.stopTest();
    system.assertEquals(201, util.response_code, util);
  }
  static testMethod void test_postStaticIp_FAIL_400(){
    HTSOSS_hts_terminals_staticips util = new HTSOSS_hts_terminals_staticips();
    HTSOSS_hts_terminals_staticips util2 = new HTSOSS_hts_terminals_staticips();
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.obj_id = 1234;
    HTSOSS_hts_terminals_staticips requestObj = new HTSOSS_hts_terminals_staticips();
    requestObj.static_ip_address = '199.244.86.194';
    requestObj.terminal_ip_address = '10.83..64';
    requestObj.data_channel_id = 1703;
    test.startTest();
    util = util.postStaticIp(testTerm, requestObj);
    system.assertEquals(400, util.response_code, util);
    system.assert(util.message.contains('INVALID'), util);
    testTerm.obj_id = null;
    util2 = util.postStaticIp(testTerm, requestObj);
    system.assertEquals(400, util2.response_code, util2);
    system.assertEquals('Input Terminal missing obj_id', util2.message, util2);
    test.stopTest();
  }
  static testMethod void test_postStaticIp_404(){
    HTSOSS_hts_terminals_staticips util = new HTSOSS_hts_terminals_staticips();
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.obj_id = 1234;
    HTSOSS_hts_terminals_staticips requestObj = new HTSOSS_hts_terminals_staticips();
    requestObj.static_ip_address = '199.244.86.194';
    requestObj.terminal_ip_address = '10.83.83.64';
    requestObj.data_channel_id = 1703;
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_staticips_mocks.mock_staticips_NO_BODY(404));
    test.startTest();
    util = util.postStaticIp(testTerm, requestObj);
    test.stopTest();
    system.assertEquals(404, util.response_code, util);
    system.assertEquals('OSS Failed to find the Terminal for Static IP mapping', util.message, util);
  }
  static testMethod void test_postStaticIp_500(){
    HTSOSS_hts_terminals_staticips util = new HTSOSS_hts_terminals_staticips();
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.obj_id = 1234;
    HTSOSS_hts_terminals_staticips requestObj = new HTSOSS_hts_terminals_staticips();
    requestObj.static_ip_address = '199.244.86.194';
    requestObj.terminal_ip_address = '10.83.83.64';
    requestObj.data_channel_id = 1703;
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_staticips_mocks.mock_staticips_NO_BODY(500));
    test.startTest();
    util = util.postStaticIp(testTerm, requestObj);
    test.stopTest();
    system.assertEquals(500, util.response_code, util);
    system.assertEquals('OSS Failed to map Static IP', util.message, util);
  }
  static testMethod void test_postStaticIp_FAIL_ANY(){
    HTSOSS_hts_terminals_staticips util = new HTSOSS_hts_terminals_staticips();
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.obj_id = 1234;
    HTSOSS_hts_terminals_staticips requestObj = new HTSOSS_hts_terminals_staticips();
    requestObj.static_ip_address = '199.244.86.194';
    requestObj.terminal_ip_address = '10.83.83.64';
    requestObj.data_channel_id = 1703;
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_staticips_mocks.mock_staticips_NO_BODY(501));
    test.startTest();
    util = util.postStaticIp(testTerm, requestObj);
    test.stopTest();
    system.assertEquals(501, util.response_code, util);
  }
  //test GETs
  static testMethod void test_getStaticIps_404(){
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    HTSOSS_hts_terminals_staticips util = new HTSOSS_hts_terminals_staticips();
    HTSOSS_hts_terminals_staticips.staticip_list_wrapper listOfIps = new HTSOSS_hts_terminals_staticips.staticip_list_wrapper();
    testTerm.obj_id = 1234;
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_staticips_mocks.mock_staticips_GET_404());
    listOfIps = util.getStaticIps(testTerm);
    test.stopTest();
    system.assertEquals(404, listOfIps.response_code);
    system.assertEquals('OSS could not find the terminal requested', listOfIps.message);
  }
  static testMethod void test_getStaticIps_500(){
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    HTSOSS_hts_terminals_staticips util = new HTSOSS_hts_terminals_staticips();
    HTSOSS_hts_terminals_staticips.staticip_list_wrapper listOfIps = new HTSOSS_hts_terminals_staticips.staticip_list_wrapper();
    testTerm.obj_id = 1234;
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_staticips_mocks.mock_staticips_GET_500());
    listOfIps = util.getStaticIps(testTerm);
    test.stopTest();
    system.assertEquals(500, listOfIps.response_code);
    system.assertEquals(0,listOfIps.staticip_list.size());
    system.assertEquals('OSS failed to process the request', listOfIps.message);
  }
  static testMethod void test_getStaticIps_200(){ 
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    HTSOSS_hts_terminals_staticips util = new HTSOSS_hts_terminals_staticips();
    HTSOSS_hts_terminals_staticips.staticip_list_wrapper listOfIps = new HTSOSS_hts_terminals_staticips.staticip_list_wrapper();
    testTerm.obj_id = 1234;
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_staticips_mocks.mock_staticips_GET_200());
    listOfIps = util.getStaticIps(testTerm);
    test.stopTest();
    system.assertEquals(200, listOfIps.response_code);
    system.assertEquals(1,listOfIps.staticip_list.size());
    system.assertEquals('199.244.86.192', listOfIps.staticip_list[0].ip_address, listOfIps);
    system.assertEquals('15970894-10.64.10.66', listOfIps.staticip_list[0].obj_id, listOfIps);
  }
  static testMethod void test_getStaticIps_200_multi(){ 
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    HTSOSS_hts_terminals_staticips util = new HTSOSS_hts_terminals_staticips();
    HTSOSS_hts_terminals_staticips.staticip_list_wrapper listOfIps = new HTSOSS_hts_terminals_staticips.staticip_list_wrapper();
    testTerm.obj_id = 1234;
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_staticips_mocks.mock_staticips_GET_200_multi());
    listOfIps = util.getStaticIps(testTerm);
    test.stopTest();
    system.assertEquals(200, listOfIps.response_code);
    system.assertEquals(2,listOfIps.staticip_list.size());
    //TODO: mitigate list order risk... order not guaranteed, but probably stable due to mock
    system.assertEquals('199.244.86.192', listOfIps.staticip_list[0].ip_address, listOfIps);
    system.assertEquals('15970894-10.64.10.66', listOfIps.staticip_list[0].obj_id, listOfIps);
    system.assertEquals('1703', listOfIps.staticip_list[0].channel_id, listOfIps);
    system.assertEquals('199.244.86.193', listOfIps.staticip_list[1].ip_address, listOfIps);
    system.assertEquals('15970894-10.64.10.128', listOfIps.staticip_list[1].obj_id, listOfIps);
    system.assertEquals('1704', listOfIps.staticip_list[1].channel_id, listOfIps);
  }
  static testMethod void test_validateStaticIPForPost_OK(){
    HTSOSS_hts_terminals_staticips util = new HTSOSS_hts_terminals_staticips();
    util.static_ip_address = '199.244.86.194';
    util.terminal_ip_address = '10.83.83.64';
    util.data_channel_id = 1703;
    test.startTest();
    string validationResults = util.validateStaticIPForPost(util);
    system.assertEquals('VALID', validationResults);
    test.stopTest();
  }
  static testMethod void test_validateStaticIPForPost_FAIL(){
    HTSOSS_hts_terminals_staticips util = new HTSOSS_hts_terminals_staticips();
    util.static_ip_address = '199.244..194';
    util.terminal_ip_address = '10.83.83.64';
    util.data_channel_id = 1703;
    test.startTest();
    string validationResults = util.validateStaticIPForPost(util);
    system.assert(validationResults.contains('INVALID'), validationResults);
    test.stopTest();
  }
  static testMethod void test_validateStaticIPForPost_FAIL_2(){
    HTSOSS_hts_terminals_staticips util = new HTSOSS_hts_terminals_staticips();
    //util.static_ip_address = '199.244.86.194';
    //util.terminal_ip_address = '10.83.83.64';
    //util.data_channel_id = 1703;
    test.startTest();
    string validationResults = util.validateStaticIPForPost(util);
    system.assert(validationResults.contains('INVALID'), validationResults);
    system.assert(validationResults.contains('Missing static_ip_address'), validationResults);
    system.assert(validationResults.contains('Missing terminal_ip_address'), validationResults);
    system.assert(validationResults.contains('Missing data_channel_id'), validationResults);
    test.stopTest();
  }
  static testMethod void test_validateStaticIPForPost_FAIL_3(){
    HTSOSS_hts_terminals_staticips util = new HTSOSS_hts_terminals_staticips();
    util.static_ip_address = '199.244.86.194';
    util.terminal_ip_address = '10.83.83.0/24';
    util.data_channel_id = 1703;
    test.startTest();
    string validationResults = util.validateStaticIPForPost(util);
    system.assert(validationResults.contains('INVALID'), validationResults);
    system.assert(validationResults.contains('Invalid terminal_ip_address'), validationResults);
    test.stopTest();
  }
  static testMethod void test_validateStaticIPForPost_FAIL_4(){
    HTSOSS_hts_terminals_staticips util = new HTSOSS_hts_terminals_staticips();
    util.static_ip_address = '199.244.86.194';
    util.terminal_ip_address = '10.83.83.64';
    util.data_channel_id = 1702;
    test.startTest();
    string validationResults = util.validateStaticIPForPost(util);
    system.assert(validationResults.contains('INVALID'), validationResults);
    system.assert(validationResults.contains('Invalid data_channel_id'), validationResults);
    test.stopTest();
  }
  static testMethod void test_validateStaticIPForPost_FAIL_5(){
    HTSOSS_hts_terminals_staticips util = new HTSOSS_hts_terminals_staticips();
    util.static_ip_address = '199.244.86.194';
    util.terminal_ip_address = '10.83.83.64';
    util.data_channel_id = 1709;
    test.startTest();
    string validationResults = util.validateStaticIPForPost(util);
    system.assert(validationResults.contains('INVALID'), validationResults);
    system.assert(validationResults.contains('Invalid data_channel_id'), validationResults);
    test.stopTest();
  }
}