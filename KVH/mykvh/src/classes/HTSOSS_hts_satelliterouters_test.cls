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
private class HTSOSS_hts_satelliterouters_test {

  @testSetup static void setupTestData(){
    //setup common test data here
  }
  
  static testMethod void testSetupData(){
    //use this method to validate that you have test data setup correctly
  }
	
	static testMethod void test_getHttpRequestTemplate(){
	  HTSOSS_hts_satelliterouters util = new HTSOSS_hts_satelliterouters();
	  HttpRequest req = util.getHttpRequestTemplate('POST');
	  system.assertEquals(HTSOSS_hts_satelliterouters.base_endpoint + '/hts/satelliterouters/', req.getEndpoint());
	  system.assertEquals('POST', req.getMethod());
	  system.assertEquals(UserInfo.getUserId(), req.getHeader('x-oss-remote-user'));
	  system.assertEquals('application/json', req.getHeader('Content-Type'));
	}
	
	/*Tests for methods that invoke API operations */
	static testMethod void test_satelliteRouters_GET_success(){
	  test.startTest();
	  test.setMock(HttpCalloutMock.class, new HTSOSS_hts_satelliterouters_mocks.mock_satelliterouters_GET());
	  HTSOSS_hts_satelliterouters util = new HTSOSS_hts_satelliterouters();
	  HTSOSS_hts_satelliterouters.satelliterouters_list_wrapper mockRes = util.getSatelliteRouters();
	  system.assertEquals(2, mockRes.satelliterouters_list.size());                           //we got two (per mock), right?
	  system.assertEquals(200, mockRes.response_code);                  //We got a 200 (per mock)
	  for(HTSOSS_hts_satelliterouters sr : mockRes.satelliterouters_list){ //assertions rely *entirely* on Mock response!
	    system.assertEquals('111111111', sr.chip_sn.left(9));           //*similar* strings....
	    system.assertEquals('X7', sr.model);
	    system.assertEquals('212', string.valueOf(sr.obj_id).left(3)); //convert integer to string, return first three digits!//system.assertEquals('212', sr.obj_id.format().left(3)); //convert integer to string, return first three digits!
	    system.assertEquals('A_SROUTE_TEST_000000', sr.obj_name.left(20));
	    system.assertEquals(1, sr.obj_revision);
	    system.assertEquals('6666', string.valueOf(sr.serialnumber).left(4)); //convert integer to string, return first four digits!
	  }
	  test.stopTest();
	}
	
	static testMethod void test_satelliteRouters_GET_by_name_success(){
	  test.startTest();
	  test.setMock(HttpCalloutMock.class, new HTSOSS_hts_satelliterouters_mocks.mock_satelliterouters_GET_by_name());
	  HTSOSS_hts_satelliterouters util = new HTSOSS_hts_satelliterouters();
	  HTSOSS_hts_satelliterouters.satelliterouters_list_wrapper mockRes = util.getSatelliteRouters('A_SROUTE_TEST_0000002');
	  system.assertEquals(1, mockRes.satelliterouters_list.size());                           //we got two (per mock), right?
	  system.assertEquals(200, mockRes.response_code);                  //We got a 200 (per mock)
	  for(HTSOSS_hts_satelliterouters sr : mockRes.satelliterouters_list){ //assertions rely *entirely* on Mock response!
	    system.assertEquals('111111111', sr.chip_sn.left(9));           //*similar* strings....
	    system.assertEquals('X7', sr.model);
	    system.assertEquals('212', string.valueOf(sr.obj_id).left(3)); //convert integer to string, return first three digits!//system.assertEquals('212', sr.obj_id.format().left(3)); //convert integer to string, return first three digits!
	    system.assertEquals('A_SROUTE_TEST_000000', sr.obj_name.left(20));
	    system.assertEquals(1, sr.obj_revision);
	    system.assertEquals('6666', string.valueOf(sr.serialnumber).left(4)); //convert integer to string, return first four digits!
	  }
	  test.stopTest();
	}
	static testMethod void test_satelliteRouters_GET_by_serialnumber_success(){
	  test.startTest();
	  test.setMock(HttpCalloutMock.class, new HTSOSS_hts_satelliterouters_mocks.mock_satelliterouters_GET_by_name());
	  HTSOSS_hts_satelliterouters util = new HTSOSS_hts_satelliterouters();
	  HTSOSS_hts_satelliterouters.satelliterouters_list_wrapper mockRes = util.getSatelliteRouters('null', 1, 'null', 6666, 'null');
	  system.assertEquals(1, mockRes.satelliterouters_list.size());                           //we got one (per mock), right?
	  system.assertEquals(200, mockRes.response_code);                  //We got a 200 (per mock)
	  for(HTSOSS_hts_satelliterouters sr : mockRes.satelliterouters_list){ //assertions rely *entirely* on Mock response!
	    system.assertEquals('111111111', sr.chip_sn.left(9));           //*similar* strings....
	    system.assertEquals('X7', sr.model);
	    system.assertEquals('212', string.valueOf(sr.obj_id).left(3)); //convert integer to string, return first three digits!//system.assertEquals('212', sr.obj_id.format().left(3)); //convert integer to string, return first three digits!
	    system.assertEquals('A_SROUTE_TEST_000000', sr.obj_name.left(20));
	    system.assertEquals(1, sr.obj_revision);
	    system.assertEquals('6666', string.valueOf(sr.serialnumber).left(4)); //convert integer to string, return first four digits!
	  }
	  test.stopTest();
	}
	static testMethod void test_satelliteRouters_GET_by_obj_id_success(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_satelliterouters_mocks.mock_satelliterouters_GET_by_Id_success());
    HTSOSS_hts_satelliterouters util = new HTSOSS_hts_satelliterouters();
    util.obj_id = 2120;
    HTSOSS_hts_satelliterouters mockRes = util.getSatelliteRouter(util);
    system.assertEquals(200, mockRes.response_code);                  //We got a 200 (per mock)

      system.assertEquals('1111111111', mockRes.chip_sn);
      system.assertEquals('X7', mockRes.model);
      system.assertEquals(2120, mockRes.obj_id); 
      system.assertEquals('A_SROUTE_TEST_0000001', mockRes.obj_name);
      system.assertEquals(1, mockRes.obj_revision);
      system.assertEquals(66666, mockRes.serialnumber); 
    
    test.stopTest();
  }
  
	static testMethod void test_satelliteRouters_GET_by_ID_fail(){
	  test.startTest();
	  test.setMock(HttpCalloutMock.class, new HTSOSS_hts_satelliterouters_mocks.mock_satelliterouters_GET_by_Id_fail());
	  HTSOSS_hts_satelliterouters util = new HTSOSS_hts_satelliterouters();
	  util.obj_id = 2120;
	  
	  HTSOSS_hts_satelliterouters mockRes = util.getSatelliteRouter(util);
	
	/*system.assertEquals('111111111', mockRes.chip_sn.left(9));
	  system.assertEquals('X7', mockRes.model);
	  system.assertEquals(2120, mockRes.obj_id); 
	  system.assertEquals('A_SROUTE_TEST_0000001', mockRes.obj_name);
	  system.assertEquals(1, mockRes.obj_revision);
	  system.assertEquals(66666, mockRes.serialnumber); */
	  system.assertEquals(500, mockRes.response_code);
	  system.assertEquals('500 Server Error: Internal Server Error', mockRes.message.left(39));
	  test.stopTest();
	}
	
	static testMethod void test_satelliteRouters_GET_fail(){
	  test.startTest();
	  test.setMock(HttpCalloutMock.class, new HTSOSS_hts_satelliterouters_mocks.mock_satelliterouters_GET_by_Id_fail());
	  HTSOSS_hts_satelliterouters util = new HTSOSS_hts_satelliterouters();
	  HTSOSS_hts_satelliterouters.satelliterouters_list_wrapper mockRes = util.getSatelliteRouters();
	  system.assertEquals(0, mockRes.satelliterouters_list.size());     //should get an empty list
	  system.assertEquals(500, mockRes.response_code);                  //We got a 200 (per mock)
	  system.assertEquals('500 Server Error: Internal Server Error', mockRes.message.left(39));
	  test.stopTest();
	}
	
	static testMethod void test_satelliteRouters_POST_success(){
      test.startTest();
      test.setMock(HttpCalloutMock.class, new HTSOSS_hts_satelliterouters_mocks.mock_satelliterouters_POST_success());
      HTSOSS_hts_satelliterouters util = new HTSOSS_hts_satelliterouters();
      util.chip_sn = '12345';
      util.model = 'X7';
      util.obj_name = 'string2';
      util.serialnumber = 12347;
      
      HTSOSS_hts_satelliterouters mockRes = util.postSatelliteRouter(util);

      system.assertEquals('12345', mockRes.chip_sn);
      system.assertEquals('X7', mockRes.model);
      //system.assertEquals(2120, mockRes.obj_id); 
      system.assertEquals('string2', mockRes.obj_name);
      //system.assertEquals(1, mockRes.obj_revision);
      system.assertEquals(12347, mockRes.serialnumber); 
      system.assertEquals(201, mockRes.response_code);
      system.assertEquals('Successfully created Satellite Router', mockRes.message);
      test.stopTest();
    }
    static testMethod void test_satelliteRouters_POST_fail(){
      test.startTest();
      test.setMock(HttpCalloutMock.class, new HTSOSS_hts_satelliterouters_mocks.mock_satelliterouters_POST_fail());
      HTSOSS_hts_satelliterouters util = new HTSOSS_hts_satelliterouters();
      util.chip_sn = '12345';
      util.model = 'X7';
      util.obj_name = 'string2';
      util.serialnumber = 12347;
      
      HTSOSS_hts_satelliterouters mockRes = util.postSatelliteRouter(util);

      system.assertEquals(500, mockRes.response_code);
      system.assertEquals('Failed', mockRes.message.left(6));
      system.assertEquals('12345', mockRes.chip_sn);
      system.assertEquals('X7', mockRes.model);
      system.assertEquals(null, mockRes.obj_id); 
      system.assertEquals('string2', mockRes.obj_name);
      system.assertEquals(null, mockRes.obj_revision);
      system.assertEquals(12347, mockRes.serialnumber); 
      test.stopTest();
    }
    
    static testMethod void test_satelliteRouters_PUT_success(){
      integer expected_response_code = 204;
      test.startTest();
      test.setMock(HttpCalloutMock.class, new HTSOSS_hts_satelliterouters_mocks.mock_satelliterouters_NO_BODY_success(expected_response_code));
      HTSOSS_hts_satelliterouters util = new HTSOSS_hts_satelliterouters();
      util.chip_sn = '12345';
      util.model = 'X7';
      util.obj_name = 'string2';
      util.serialnumber = 12347;
      
      HTSOSS_hts_satelliterouters mockRes = util.deleteSatelliteRouter(util);
      system.assertEquals(expected_response_code, mockRes.response_code);
      test.stopTest();
    }
    
    static testMethod void test_satelliteRouters_DELETE_success(){
      integer expected_response_code = 204;
      test.startTest();
      test.setMock(HttpCalloutMock.class, new HTSOSS_hts_satelliterouters_mocks.mock_satelliterouters_NO_BODY_success(expected_response_code));
      HTSOSS_hts_satelliterouters util = new HTSOSS_hts_satelliterouters();
      util.chip_sn = '12345';
      util.model = 'X7';
      util.obj_name = 'string2';
      util.serialnumber = 12347;
      
      HTSOSS_hts_satelliterouters mockRes = util.putSatelliteRouter(util);
      system.assertEquals(expected_response_code, mockRes.response_code);
      test.stopTest();
    }
}