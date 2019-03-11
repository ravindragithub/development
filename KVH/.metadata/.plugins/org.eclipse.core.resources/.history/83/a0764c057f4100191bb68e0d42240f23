@isTest
private class LTEOSS_lte_subscribers_test {
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

  static testMethod void test_getLTESubscribers_OK(){
    //Need mock response from /lte/subscribers/
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_getLTESubscribers_OK());
    Test.setMock(HttpCalloutMock.class, mock);
    LTEOSS_lte_subscribers.Subscribers_list_wrapper returnedObj 
      = new LTEOSS_lte_subscribers.Subscribers_list_wrapper();
    test.startTest();
    returnedObj = LTEOSS_lte_subscribers.getLTESubscribers();
    test.stopTest();
    system.assertEquals(200, returnedObj.response_code);
    system.assertEquals(3, returnedObj.subscribers.size());
  }
  static testMethod void test_getLTESubscribers_500(){
    //Need mock response from /lte/subscribers/
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_error_500());
    Test.setMock(HttpCalloutMock.class, mock);
    LTEOSS_lte_subscribers.Subscribers_list_wrapper returnedObj 
      = new LTEOSS_lte_subscribers.Subscribers_list_wrapper();
    test.startTest();
    returnedObj = LTEOSS_lte_subscribers.getLTESubscribers();
    test.stopTest();
    system.assertEquals(500, returnedObj.response_code);
    system.assertEquals('this is a mock error message', returnedObj.message);
    system.assertEquals(0, returnedObj.subscribers.size());
  }
  static testMethod void test_getLTESubscriberInfo_OK(){
    //Need mock response from /lte/subscribers/info
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_getLTESubscriberInfo_OK());
    LTEOSS_lte_subscribers returnedObj = new LTEOSS_lte_subscribers();
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    returnedObj = LTEOSS_lte_subscribers.getLTESubscriberInfo(null, '8901260882225943783');
    test.stopTest();
    system.assertEquals(200, returnedObj.response_code);
    system.assertEquals('2018-03-10T00:00:00', returnedObj.activation_date);
    system.assertEquals('m2mglobal', returnedObj.apn);
    system.assertEquals('2GBUSTMO', returnedObj.call_plan);
    system.assertEquals('2019-03-10T00:00:00', returnedObj.contract_end_date);
    //system.assertEquals(9999, returnedObj.current_usage);
    system.assertEquals('99.99.99.99', returnedObj.ipaddress);
    //system.assertEquals(false, returnedObj.is_online);
    system.assertEquals('2018-05-14T19:52:48.8363681Z', returnedObj.last_seen);
    system.assertEquals('T-Mobile', returnedObj.last_seen_carrier);
    system.assertEquals('active', returnedObj.status);
    system.assertEquals('8901260882225943783', returnedObj.subscriber.iccid);
    system.assertEquals('310260761056018', returnedObj.subscriber.imsi);
    system.assertEquals('99991234-11', returnedObj.subscriber_id);
  }
  static testMethod void test_getLTESubscriberInfo_500(){
    //Need mock response from /lte/subscribers/info
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_error_500());
    LTEOSS_lte_subscribers returnedObj = new LTEOSS_lte_subscribers();
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    returnedObj = LTEOSS_lte_subscribers.getLTESubscriberInfo('99991234-11', '8901260882225943783');
    test.stopTest();
    system.assertEquals(500, returnedObj.response_code);
    system.assertEquals('this is a mock error message', returnedObj.message);
  }
  static testMethod void test_postLTESubscriber_OK(){
    //Need mock response from /lte/subscribers/activate
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_noBody(201));
    LTEOSS_lte_subscribers returnedObj = new LTEOSS_lte_subscribers();
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    returnedObj = LTEOSS_lte_subscribers.postLTESubscriber('2GBUSTMO', '8901260882225943783', 'CONUS', '99991234-11');
    test.stopTest();
    system.assertEquals(201, returnedObj.response_code);
  }
  static testMethod void test_postLTESubscriber_500(){
    //Need mock response from /lte/subscribers/activate
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_error_500());
    LTEOSS_lte_subscribers returnedObj = new LTEOSS_lte_subscribers();
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    returnedObj = LTEOSS_lte_subscribers.postLTESubscriber('2GBUSTMO', '8901260882225943783', 'CONUS', '99991234-11');
    test.stopTest();
    system.assertEquals(500, returnedObj.response_code);
    system.assertEquals('this is a mock error message', returnedObj.message);
  }
  static testMethod void test_postLTESubscriber_invalid(){
    //No mock response needed, invalid request handled by Class
    /*QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_error_500());
    Test.setMock(HttpCalloutMock.class, mock);*/
    LTEOSS_lte_subscribers returnedObj = new LTEOSS_lte_subscribers();
    test.startTest();
    returnedObj = LTEOSS_lte_subscribers.postLTESubscriber('2GBUSTMO', '8901260882225943783', 'CONUS', null);
    test.stopTest();
    system.assertEquals(500, returnedObj.response_code);
    system.assertEquals('Bad request, one or more input parameters is NULL', returnedObj.message);
  }
  static testMethod void test_putLTESubscriberHibernate_OK(){
    //Need mock response from /lte/subscribers/hibernate
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_noBody(204));
    LTEOSS_lte_subscribers returnedObj = new LTEOSS_lte_subscribers();
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    returnedObj = LTEOSS_lte_subscribers.putLTESubscriberHibernate('8901260882225943783', '99991234-11');
    test.stopTest();
    system.assertEquals(204, returnedObj.response_code);
  }
  static testMethod void test_putLTESubscriberHibernate_500(){
    //Need mock response from /lte/subscribers/hibernate
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_error_500());
    LTEOSS_lte_subscribers returnedObj = new LTEOSS_lte_subscribers();
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    returnedObj = LTEOSS_lte_subscribers.putLTESubscriberHibernate('8901260882225943783', '99991234-11');
    test.stopTest();
    system.assertEquals(500, returnedObj.response_code);
    system.assertEquals('this is a mock error message', returnedObj.message);
  }
  static testMethod void test_putLTESubscriberHibernate_invalid(){
    //No mock response needed, invalid request handled by Class
    /*QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_error_500());
    Test.setMock(HttpCalloutMock.class, mock);*/
    LTEOSS_lte_subscribers returnedObj = new LTEOSS_lte_subscribers();
    test.startTest();
    returnedObj = LTEOSS_lte_subscribers.putLTESubscriberHibernate('8901260882225943783', null);
    test.stopTest();
    system.assertEquals(500, returnedObj.response_code);
    system.assertEquals('Bad request, one or more input parameters is NULL', returnedObj.message);
  }
  static testMethod void test_putLTESubscriberRestore_OK(){
    //Need mock response from /lte/subscribers/restore
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_noBody(204));
    LTEOSS_lte_subscribers returnedObj = new LTEOSS_lte_subscribers();
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    returnedObj = LTEOSS_lte_subscribers.putLTESubscriberRestore('8901260882225943783', '99991234-11');
    test.stopTest();
    system.assertEquals(204, returnedObj.response_code);
  }
  static testMethod void test_putLTESubscriberRestore_500(){
    //Need mock response from /lte/subscribers/restore
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_error_500());
    LTEOSS_lte_subscribers returnedObj = new LTEOSS_lte_subscribers();
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    returnedObj = LTEOSS_lte_subscribers.putLTESubscriberRestore('8901260882225943783', '99991234-11');
    test.stopTest();
    system.assertEquals(500, returnedObj.response_code);
    system.assertEquals('this is a mock error message', returnedObj.message);
  }
  static testMethod void test_putLTESubscriberRestore_invalid(){
    //No mock response needed, invalid request handled by Class
    /*QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_error_500());
    Test.setMock(HttpCalloutMock.class, mock);*/
    LTEOSS_lte_subscribers returnedObj = new LTEOSS_lte_subscribers();
    test.startTest();
    returnedObj = LTEOSS_lte_subscribers.putLTESubscriberRestore('8901260882225943783', null);
    test.stopTest();
    system.assertEquals(500, returnedObj.response_code);
    system.assertEquals('Bad request, one or more input parameters is NULL', returnedObj.message);
  }
  static testMethod void test_putLTESubscriberTerminate_OK(){
    //Need mock response from /lte/subscribers/restore
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_noBody(204));
    LTEOSS_lte_subscribers returnedObj = new LTEOSS_lte_subscribers();
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    returnedObj = LTEOSS_lte_subscribers.putLTESubscriberTerminate('8901260882225943783');
    test.stopTest();
    system.assertEquals(204, returnedObj.response_code);
  }
  static testMethod void test_putLTESubscriberTerminate_500(){
    //Need mock response from /lte/subscribers/restore
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_error_500());
    LTEOSS_lte_subscribers returnedObj = new LTEOSS_lte_subscribers();
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    returnedObj = LTEOSS_lte_subscribers.putLTESubscriberTerminate('8901260882225943783');
    test.stopTest();
    system.assertEquals(500, returnedObj.response_code);
    system.assertEquals('this is a mock error message', returnedObj.message);
  }
  static testMethod void test_putLTESubscriberTerminate_invalid(){
    //No mock response needed, invalid request handled by Class
    /*QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_error_500());
    Test.setMock(HttpCalloutMock.class, mock);*/
    LTEOSS_lte_subscribers returnedObj = new LTEOSS_lte_subscribers();
    test.startTest();
    returnedObj = LTEOSS_lte_subscribers.putLTESubscriberTerminate(null);
    test.stopTest();
    system.assertEquals(500, returnedObj.response_code);
    system.assertEquals('Bad request, one or more input parameters is NULL', returnedObj.message);
  }
  static testMethod void test_putLTESubscriberSetUdf_OK(){
    //Need mock response from PUT /lte/subscribers/{iccid}/setudf
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_noBody(204));
    LTEOSS_lte_subscribers returnedObj = new LTEOSS_lte_subscribers();
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    returnedObj = LTEOSS_lte_subscribers.putLTESubscriberSetUdf('8901260521490885564',null);
    test.stopTest();
    system.assertEquals(204, returnedObj.response_code);
  }
  static testMethod void test_putLTESubscriberSetUdf_500(){
    //Need mock response from PUT /lte/subscribers/{iccid}/setudf
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_error_500());
    LTEOSS_lte_subscribers returnedObj = new LTEOSS_lte_subscribers();
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    returnedObj = LTEOSS_lte_subscribers.putLTESubscriberSetUdf('8901260521490885564',null);
    test.stopTest();
    system.assertEquals(500, returnedObj.response_code);
    system.assertEquals('this is a mock error message', returnedObj.message);
  }
  static testMethod void test_putLTESubscriberSetUdf_BADINPUT(){
    //Need mock response from PUT /lte/subscribers/{iccid}/setudf
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_error_500());
    LTEOSS_lte_subscribers returnedObj = new LTEOSS_lte_subscribers();
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    returnedObj = LTEOSS_lte_subscribers.putLTESubscriberSetUdf(null,'12345678-11');
    test.stopTest();
    system.assertEquals(500, returnedObj.response_code);
    system.assertEquals('Bad request, one or more input parameters is NULL', returnedObj.message);
  }
  /*********************************************************
   *setup methods for commonly used HTTP mock responses....*
   *********************************************************/
  static HttpResponse getMock_getLTESubscribers_OK(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    returnMock.setBody('[{"iccid": "8901260762210560182", ' +
                        ' "imsi": "310260761056018", ' +
                        ' "status": "Not Active"}, '+
                        '{"iccid": "8901260762259448919", ' +
                        ' "imsi": "", ' +
                        ' "status": "Not Active"}, '+
                        '{"iccid": "8901260762259449602", ' +
                        ' "imsi": "", ' +
                        ' "status": "Active"}]');
    return returnMock;
  }
  static HttpResponse getMock_getLTESubscriberInfo_OK(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    returnMock.setBody('{"activation_date": "2018-03-10T00:00:00", ' +
                        '  "apn": "m2mglobal", ' +
                        '  "call_plan": "2GBUSTMO", ' +
                        '  "contract_end_date": "2019-03-10T00:00:00", ' +
                        '  "current_usage": 9999, ' +
                        '  "ipaddress": "99.99.99.99", ' +
                        '  "is_online": "", ' +
                        '  "last_seen": "2018-05-14T19:52:48.8363681Z", ' +
                        '  "last_seen_carrier": "T-Mobile", ' +
                        '  "status": "active", ' +
                        '  "subscriber": { ' +
                        '    "iccid": "8901260882225943783", ' +
                        '    "imsi": "310260761056018" ' +
                        '  }, ' +
                        '  "subscriber_id": "99991234-11"}');
    return returnMock;
  }
  static HttpResponse getMock_error_500(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(500);
    returnMock.setBody('{"message": "this is a mock error message"}');
    return returnMock;
  }
  static HttpResponse getMock_noBody(Integer responseCode){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(responseCode);
    return returnMock;
  }
}