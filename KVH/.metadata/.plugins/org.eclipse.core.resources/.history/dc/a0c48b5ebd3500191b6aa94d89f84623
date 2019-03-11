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
private class HTSOSS_hts_subscribers_test {

	@testSetup static void setupTestData(){
		//setup common test data here
		
	}
	
	static testMethod void testSetupData(){
		//use this method to validate that you have test data setup correctly
	}
  //Callout test...
	static testMethod void test_getSubscribersList_OK() {
    HTSOSS_hts_subscribers util = new HTSOSS_hts_subscribers();
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_subscribers_mocks.mock_subscribers_GET_OK());
    HTSOSS_hts_subscribers.subscribers_list_wrapper mockRes = util.getSubscribersList(null, null);
    system.assertEquals(2, mockRes.subscribers_list.size());          //we got two (per mock), right?
    system.assertEquals(200, mockRes.response_code);                  //We got a 200 (per mock)
    //sneak in a test using a "limit" qparam....
    mockRes = util.getSubscribersList(2, null);
    system.assertEquals(2, mockRes.subscribers_list.size());          //we got two (per mock), right?
    system.assertEquals(200, mockRes.response_code);                  //We got a 200 (per mock)
    for(HTSOSS_hts_subscribers s: mockRes.subscribers_list){
      system.assertEquals('00000000-0000-0001-0000-00000000000', s.obj_id.left(35));
      system.assertEquals('Active', s.status);
      system.assertEquals('10.64.', s.subscriber_id.left(6));
      system.assertEquals('PLAN_2', s.subscriber_plan_id);
    }
    test.stopTest();
	}
	//00000000-0000-0001-0000-000000000002
	static testMethod void test_getSubscribersList_filtered_OK() {
    HTSOSS_hts_subscribers util = new HTSOSS_hts_subscribers();
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_subscribers_mocks.mock_subscribers_GET_filtered_OK());
    HTSOSS_hts_subscribers.subscribers_list_wrapper mockRes = util.getSubscribersList(null, '00000000-0000-0001-0000-000000000002');
    system.assertEquals(1, mockRes.subscribers_list.size());          //we got two (per mock), right?
    system.assertEquals(200, mockRes.response_code);                  //We got a 200 (per mock)
    for(HTSOSS_hts_subscribers s: mockRes.subscribers_list){
      system.assertEquals('00000000-0000-0001-0000-000000000002', s.obj_id);
      system.assertEquals('Active', s.status);
      system.assertEquals('10.64.1', s.subscriber_id);
      system.assertEquals('PLAN_1', s.subscriber_plan_id);
    }
    test.stopTest();
  }
  static testMethod void test_getSubscribersList_filtered_FAIL() {
    HTSOSS_hts_subscribers util = new HTSOSS_hts_subscribers();
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_subscribers_mocks.mock_subscribers_GET_FAIL());
    HTSOSS_hts_subscribers.subscribers_list_wrapper mockRes = util.getSubscribersList(null, null);
    system.assertEquals(0, mockRes.subscribers_list.size());          //we got 0 (method default), right?
    system.assertEquals(500, mockRes.response_code);                  //We got a 500 (per mock)
    system.assertEquals('The specified subscriber does not exist.', mockRes.message.left(40));
    test.stopTest();
  }
  static testMethod void test_getSubscribersList_filtered_404() {
    HTSOSS_hts_subscribers util = new HTSOSS_hts_subscribers();
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_subscribers_mocks.mock_subscribers_GET_FAIL_404());
    HTSOSS_hts_subscribers.subscribers_list_wrapper mockRes = util.getSubscribersList(null, null);
    system.assertEquals(0, mockRes.subscribers_list.size());          //we got 0 (method default), right?
    system.assertEquals(404, mockRes.response_code);                  //We got a 404 (per mock)
    system.assertEquals('The specified subscriber does not exist.', mockRes.message.left(40));
    test.stopTest();
  }
  static testMethod void test_getSubscriber_OK(){
    HTSOSS_hts_subscribers util = new HTSOSS_hts_subscribers();
    util.obj_id = '00000000-0000-0001-0000-000000000002';
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_subscribers_mocks.mock_subscribers_GET_byId_OK());
    HTSOSS_hts_subscribers mockRes = util.getSubscriber(util);
    system.assertEquals(200, mockRes.response_code);                  //We got a 200 (per mock)
	  system.assertEquals('00000000-0000-0001-0000-000000000002', mockRes.obj_id);
	  system.assertEquals('Active', mockRes.status);
	  system.assertEquals('10.64.1', mockRes.subscriber_id);
	  system.assertEquals('PLAN_1', mockRes.subscriber_plan_id);
	  test.stopTest();
  }
  static testMethod void test_getSubscriber_FAIL_400(){
    HTSOSS_hts_subscribers util = new HTSOSS_hts_subscribers();
    //util.obj_id = '00000000-0000-0001-0000-000000000002';
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_subscribers_mocks.mock_subscribers_NO_BODY(400));
    HTSOSS_hts_subscribers mockRes = util.getSubscriber(util);
    system.assertEquals(400, mockRes.response_code);                  //We got a 400 (method default)
    system.assertEquals('INVALID', mockRes.message.left(7));
    system.assertEquals(true, mockRes.message.contains(' Missing obj_id '));
    
    test.stopTest();
  }
  static testMethod void test_getSubscriber_FAIL_404(){
    HTSOSS_hts_subscribers util = new HTSOSS_hts_subscribers();
    util.obj_id = '00000000-0000-0001-0000-000000000002';
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_subscribers_mocks.mock_subscribers_NO_BODY(404));
    HTSOSS_hts_subscribers mockRes = util.getSubscriber(util);
    system.assertEquals(404, mockRes.response_code);                  //We got a 404 (per mock)
    system.assertEquals('Subscriber not found', mockRes.message);
    test.stopTest();
  }
  static testMethod void test_getSubscriber_FAIL_500(){
    HTSOSS_hts_subscribers util = new HTSOSS_hts_subscribers();
    util.obj_id = '00000000-0000-0001-0000-000000000002';
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_subscribers_mocks.mock_subscribers_NO_BODY(500));
    HTSOSS_hts_subscribers mockRes = util.getSubscriber(util);
    system.assertEquals(500, mockRes.response_code);                  //We got a 500 (per mock)
    system.assertEquals('Failed to GET Subscriber', mockRes.message);
    test.stopTest();
  }
  static testMethod void test_postSubscriber_FAIL_400(){
    HTSOSS_hts_subscribers util = new HTSOSS_hts_subscribers();
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_subscribers_mocks.mock_subscribers_NO_BODY(400));
    HTSOSS_hts_subscribers mockRes = util.postSubscriber(util);
    system.assertEquals(400, mockRes.response_code);                  //We got a 400 (method default)
    system.debug('mockRes.message: ' + mockRes.message);
    system.assertEquals(true, mockRes.message.contains('INVALID'));
    system.assertEquals(true, mockRes.message.contains(' Missing subscriber_id '));
    system.assertEquals(true, mockRes.message.contains(' Missing subscriber_ip_addresses[] '));
    system.assertEquals(true, mockRes.message.contains(' Missing subscriber_plan_id '));
    test.stopTest();
  }
  static testMethod void test_postSubscriber_FAIL_500(){
    HTSOSS_hts_subscribers util = new HTSOSS_hts_subscribers();
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_subscribers_mocks.mock_subscribers_NO_BODY(500));
    util.subscriber_id = '12345678-00';
    util.subscriber_plan_id = 'PLAN_2';
    util.subscriber_ip_addresses = new string[]{'10.64.2.128', '10.64.2.129'};
    HTSOSS_hts_subscribers mockRes = util.postSubscriber(util);
    system.assertEquals(500, mockRes.response_code);                  //We got a 500 (per mock)
    system.assertEquals('Failed to POST Subscriber', mockRes.message);
    test.stopTest();
  }
  static testMethod void test_postSubscriber_OK(){
    HTSOSS_hts_subscribers util = new HTSOSS_hts_subscribers();
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_subscribers_mocks.mock_subscribers_NO_BODY(201));
    util.subscriber_id = '12345678-00';
    util.subscriber_plan_id = 'PLAN_2';
    util.subscriber_ip_addresses = new string[]{'10.64.2.128', '10.64.2.129'};
    HTSOSS_hts_subscribers mockRes = util.postSubscriber(util);
    system.assertEquals(201, mockRes.response_code);                  //We got a 201 (per mock)
    test.stopTest();
  }
  //DELETE Callout Tests...
  static testMethod void test_deleteSubscriber_FAIL_400(){
    HTSOSS_hts_subscribers util = new HTSOSS_hts_subscribers();
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_subscribers_mocks.mock_subscribers_NO_BODY(400));
    HTSOSS_hts_subscribers mockRes = util.deleteSubscriber(util);
    system.assertEquals(400, mockRes.response_code);                  //We got a 400 (method default)
    system.debug('mockRes.message: ' + mockRes.message);
    system.assertEquals(true, mockRes.message.contains('INVALID'));
    system.assertEquals(true, mockRes.message.contains(' Missing obj_id '));
    test.stopTest();
  }
  static testMethod void test_deleteSubscriber_FAIL_404(){
    HTSOSS_hts_subscribers util = new HTSOSS_hts_subscribers();
    util.obj_id = '00000000-0000-0001-0000-000000000002';
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_subscribers_mocks.mock_subscribers_NO_BODY(404));
    HTSOSS_hts_subscribers mockRes = util.deleteSubscriber(util);
    system.assertEquals(404, mockRes.response_code);                  //We got a 404 (per mock)
    system.assertEquals(true, mockRes.message.contains('Subscriber not found'));
    test.stopTest();
  }
  static testMethod void test_deleteSubscriber_FAIL_500(){
    HTSOSS_hts_subscribers util = new HTSOSS_hts_subscribers();
    util.obj_id = '00000000-0000-0001-0000-000000000002';
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_subscribers_mocks.mock_subscribers_NO_BODY(500));
    HTSOSS_hts_subscribers mockRes = util.deleteSubscriber(util);
    system.assertEquals(500, mockRes.response_code);                  //We got a 500 (per mock)
    system.assertEquals(true, mockRes.message.contains('Failed to DELETE Subscriber'));
    test.stopTest();
  }
  static testMethod void test_deleteSubscriber_OK_204(){
    HTSOSS_hts_subscribers util = new HTSOSS_hts_subscribers();
    util.obj_id = '00000000-0000-0001-0000-000000000002';
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_subscribers_mocks.mock_subscribers_NO_BODY(204));
    HTSOSS_hts_subscribers mockRes = util.deleteSubscriber(util);
    system.assertEquals(204, mockRes.response_code);                  //We got a 204 (per mock)
    system.assertEquals('Successfully Deleted Subscriber!', mockRes.message);
    test.stopTest();
  }
  
  
  //PUT Callout Tests...
  static testMethod void test_putSubscriber_FAIL_400(){
    HTSOSS_hts_subscribers util = new HTSOSS_hts_subscribers();
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_subscribers_mocks.mock_subscribers_NO_BODY(400));
    HTSOSS_hts_subscribers mockRes = util.putSubscriber(util);
    system.assertEquals(400, mockRes.response_code);                  //We got a 400 (method default)
    system.debug('mockRes.message: ' + mockRes.message);
    system.assertEquals(true, mockRes.message.contains('INVALID'));
    system.assertEquals(true, mockRes.message.contains(' Missing obj_id '));
    test.stopTest();
  }
  static testMethod void test_putSubscriber_FAIL_404(){
    HTSOSS_hts_subscribers util = new HTSOSS_hts_subscribers();
    util.obj_id = '00000000-0000-0001-0000-000000000002';
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_subscribers_mocks.mock_subscribers_NO_BODY(404));
    HTSOSS_hts_subscribers mockRes = util.putSubscriber(util);
    system.assertEquals(404, mockRes.response_code);                  //We got a 404 (per mock)
    system.assertEquals(true, mockRes.message.contains('Subscriber not found'));
    test.stopTest();
  }
  static testMethod void test_putSubscriber_FAIL_500(){
    HTSOSS_hts_subscribers util = new HTSOSS_hts_subscribers();
    util.obj_id = '00000000-0000-0001-0000-000000000002';
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_subscribers_mocks.mock_subscribers_NO_BODY(500));
    HTSOSS_hts_subscribers mockRes = util.putSubscriber(util);
    system.assertEquals(500, mockRes.response_code);                  //We got a 500 (per mock)
    system.assertEquals(true, mockRes.message.contains('Failed to PUT Subscriber'));
    test.stopTest();
  }
  static testMethod void test_putSubscriber_OK_204(){
    HTSOSS_hts_subscribers util = new HTSOSS_hts_subscribers();
    util.obj_id = '00000000-0000-0001-0000-000000000002';
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_subscribers_mocks.mock_subscribers_NO_BODY(204));
    HTSOSS_hts_subscribers mockRes = util.putSubscriber(util);
    system.assertEquals(204, mockRes.response_code);                  //We got a 204 (per mock)
    system.assertEquals('Successfully Updated Subscriber!', mockRes.message);
    test.stopTest();
  }
  
  
  //Helper methods tests...
  static testMethod void test_validateSubscriberId(){
    HTSOSS_hts_subscribers util = new HTSOSS_hts_subscribers();
    string validationString = util.validateSubscriberId(util);
    system.assertEquals(true, validationString.contains(' Missing obj_id '));
    util.obj_id = '00000000-0000-0001-0000-000000000002';
    validationString = util.validateSubscriberId(util);
    system.assertEquals(true, validationString.contains('VALID'));
  }
  static testMethod void test_validateSubscriberForPost(){
    HTSOSS_hts_subscribers util = new HTSOSS_hts_subscribers();
    string validationString = util.validateSubscriberForPost(util);
    system.assertEquals(true, validationString.contains('INVALID'));
    system.assertEquals(true, validationString.contains(' Missing subscriber_id '));
    system.assertEquals(true, validationString.contains(' Missing subscriber_ip_addresses[] '));
    system.assertEquals(true, validationString.contains(' Missing subscriber_plan_id '));
    util.subscriber_id = '12345678-00';
    util.subscriber_plan_id = 'PLAN_2';
    util.subscriber_ip_addresses = new string[]{'10.64.2.128', '10.64.2.129'};
    validationString = util.validateSubscriberForPost(util);
    system.assertEquals('VALID', validationString);
    //check negative cases
    util.subscriber_id = '1234567-00';
    validationString = util.validateSubscriberForPost(util);
    system.assertEquals('INVALID', validationString.left(7));
    //check negative cases
    util.subscriber_id = ' 1234567-00';
    validationString = util.validateSubscriberForPost(util);
    system.assertEquals('INVALID', validationString.left(7));
    //check negative cases
    util.subscriber_id = '1234567-000';
    validationString = util.validateSubscriberForPost(util);
    system.assertEquals('INVALID', validationString.left(7));
    //check negative cases
    util.subscriber_id = '1234567';
    validationString = util.validateSubscriberForPost(util);
    system.assertEquals('INVALID', validationString.left(7));
  }
}