@isTest
private class LTEOSS_lte_devices_test {
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

  static testMethod void test_getLTEDevices_OK(){
    //Need mock response from /lte/devices/{org_id}/{group_id}
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_getLTEDevices_OK());
    Test.setMock(HttpCalloutMock.class, mock);
    LTEOSS_lte_devices.Devices_list_wrapper returnedObj 
      = new LTEOSS_lte_devices.Devices_list_wrapper();
    test.startTest();
    returnedObj = LTEOSS_lte_devices.getLTEDevices('defaul', 92);
    test.stopTest();
    system.assertEquals(200, returnedObj.response_code);
    system.assertEquals(1, returnedObj.devices.size());
    system.assertEquals('7.1.0 build 2860',returnedObj.devices[0].fw_ver);
    system.assertEquals(92,returnedObj.devices[0].group_id);
    system.assertEquals(7,returnedObj.devices[0].id);
    system.assertEquals('2018-04-10T11:44:31',returnedObj.devices[0].last_online);
    system.assertEquals('98765432',returnedObj.devices[0].name);
    system.assertEquals('',returnedObj.devices[0].offline_at);
    system.assertEquals('ONLINE',returnedObj.devices[0].onlineStatus);
    system.assertEquals('2934-B1B5-FFB4',returnedObj.devices[0].sn);
    system.assertEquals('online',returnedObj.devices[0].status);
    system.assertEquals('98765432',returnedObj.devices[0].virtual_device_id);
  }
  static testMethod void test_getLTEDevices_500(){
    //Need mock response from /lte/devices/{org_id}/{group_id}
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_error_500());
    Test.setMock(HttpCalloutMock.class, mock);
    LTEOSS_lte_devices.Devices_list_wrapper returnedObj 
      = new LTEOSS_lte_devices.Devices_list_wrapper();
    test.startTest();
    returnedObj = LTEOSS_lte_devices.getLTEDevices('defaul', 92);
    test.stopTest();
    system.assertEquals(500, returnedObj.response_code);
    system.assertEquals('this is a mock error message', returnedObj.message);
  }

  static testMethod void test_getLTEDevice_OK(){
    //Need mock response from /lte/devices/{org_id}/{group_id}
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_getLTEDevice_OK());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    LTEOSS_lte_devices device = LTEOSS_lte_devices.getLTEDevice('defaul', 92, 7);
    test.stopTest();
    system.assertEquals('7.1.0 build 2860', device.fw_ver);
    system.assertEquals(130, device.group_id);
    system.assertEquals(7, device.id);
    system.assertEquals(1, device.ssid_profiles_applied.size());
    system.assertEquals(1, device.ssid_profiles_applied[0].id);
    system.assertEquals('TracPhone LTE1-FFB4', device.ssid_profiles_applied[0].ssid);
    system.assertEquals(1, device.interfaces.size());
    system.assertEquals('M2MGLOBAL', device.interfaces[0].apn);
    system.assertEquals('T-Mobile', device.interfaces[0].carrier_name);
    system.assertEquals(22017, device.interfaces[0].cell_id);
    system.assertEquals(310260, device.interfaces[0].cell_plmn);
    system.assertEquals(-87, device.interfaces[0].cellular_signals.rsrp);
    system.assertEquals(-12, device.interfaces[0].cellular_signals.rsrq);
    system.assertEquals('LTE Band 4 (AWS 1700/2100 MHz)', device.interfaces[0].gobi_band_class_name);
    system.assertEquals('LTE', device.interfaces[0].gobi_data_tech);
    system.assertEquals('359072061719460', device.interfaces[0].imei);
    system.assertEquals('10.30.188.41', device.interfaces[0].ip);
    system.assertEquals('Cellular', device.interfaces[0].name);
    system.assertEquals('LTE-A', device.interfaces[0].s2g3glte);
    system.assertEquals(-87, device.interfaces[0].signal);
    system.assertEquals(4, device.interfaces[0].signal_bar);
    system.assertEquals(-12, device.interfaces[0].signal_quality);
    system.assertEquals(2, device.interfaces[0].sims.size());
    system.assertEquals('8901260882225943783', device.interfaces[0].sims[0].sims_iccid);
    system.assertEquals('310260882594378', device.interfaces[0].sims[0].sims_imsi);
    system.assertEquals('Active', device.interfaces[0].sims[0].sims_status);
    system.assertEquals('Connected to T-Mobile', device.interfaces[0].status);
    system.assertEquals('green', device.interfaces[0].status_led);
  }
  static testMethod void test_getLTEDevice_500(){
    //Need mock response from /lte/devices/{org_id}/{group_id}
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_error_500());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    LTEOSS_lte_devices device = LTEOSS_lte_devices.getLTEDevice('defaul', 92, 7);
    test.stopTest();
    system.assertEquals(500, device.response_code);
    system.assertEquals('this is a mock error message', device.message);
  }
  static testMethod void test_getLTEDevice_CATCH(){
    //Need mock response from /lte/devices/{org_id}/{group_id}
    //Exercises catch block due to deliberate NULL REFERENCE exception
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_noBodyNullCode());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    LTEOSS_lte_devices device = LTEOSS_lte_devices.getLTEDevice('defaul', 92, 7);
    test.stopTest();
    list<Case> caseList = [SELECT Id FROM Case];
    system.assertEquals(1, caseList.size());
    CalloutLogs.commitLogs();
    list<Callout_Log__c> logsList = [SELECT Id FROM Callout_Log__c];
    system.assertEquals(1, logsList.size());
  }
  static testMethod void test_updateLTEDevice_OK(){
    //Need mock response from /lte/devices/{org_id}/{group_id}/{id}
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_noBody(204));
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    LTEOSS_lte_devices device = LTEOSS_lte_devices.updateLTEDevice('defaul', 92, 7, '99991234');
    test.stopTest();
    list<Case> caseList = [SELECT Id FROM Case];
    system.assertEquals(0, caseList.size());
  }
  static testMethod void test_updateLTEDevice_CATCH(){
    //Need mock response from /lte/devices/{org_id}/{group_id}/{id}
    //Exercises catch block due to deliberate NULL REFERENCE exception
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_noBodyNullCode());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    LTEOSS_lte_devices device = LTEOSS_lte_devices.updateLTEDevice('defaul', 92, 7, '99991234');
    test.stopTest();
    //exception should have created a case
    list<Case> caseList = [SELECT Id FROM Case];
    system.assertEquals(1, caseList.size());
    CalloutLogs.commitLogs();
    list<Callout_Log__c> logsList = [SELECT Id FROM Callout_Log__c];
    system.assertEquals(1, logsList.size());
  }
  static testMethod void test_updateLTEDevice_500(){
    //Need mock response from /lte/devices/{org_id}/{group_id}/{id}
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_error_500());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    LTEOSS_lte_devices device = LTEOSS_lte_devices.updateLTEDevice('defaul', 92, 7, '99991234');
    test.stopTest();
    list<Case> caseList = [SELECT Id FROM Case];
    system.assertEquals(0, caseList.size());
  }
  static testMethod void test_postLTEDevice_OK(){
    //Need mock response from /lte/devices/{org_id}/{group_id}
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_noBody(201));
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    LTEOSS_lte_devices device = LTEOSS_lte_devices.postLTEDevice('defaul', 92, '2322-BAD9-AE01', '99991234');
    test.stopTest();
    system.assertEquals(201, device.response_code);
    list<Case> caseList = [SELECT Id FROM Case];
    system.assertEquals(0, caseList.size());
  }
  static testMethod void test_postLTEDevice_500(){
    //Need mock response from /lte/devices/{org_id}/{group_id}
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_error_500());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    LTEOSS_lte_devices device = LTEOSS_lte_devices.postLTEDevice('defaul', 92, '2322-BAD9-AE01', '99991234');
    test.stopTest();
    system.assertEquals(500, device.response_code);
    list<Case> caseList = [SELECT Id FROM Case];
    system.assertEquals(0, caseList.size());
  }
  static testMethod void test_postLTEDevice_CATCH(){
    //Need mock response from /lte/devices/{org_id}/{group_id}
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_noBodyNullCode());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    LTEOSS_lte_devices device = LTEOSS_lte_devices.postLTEDevice('defaul', 92, '2322-BAD9-AE01', '99991234');
    test.stopTest();
    list<Case> caseList = [SELECT Id FROM Case];
    system.assertEquals(1, caseList.size());
    CalloutLogs.commitLogs();
    list<Callout_Log__c> logsList = [SELECT Id FROM Callout_Log__c];
    system.assertEquals(1, logsList.size());
    
  }
  static testMethod void test_deleteLTEDevice_OK(){
    //Need mock response from /lte/devices/{org_id}/{group_id}/{id}
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_noBody(204));
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    LTEOSS_lte_devices device = LTEOSS_lte_devices.deleteLTEDevice('defaul', 130, 7);
    test.stopTest();
    system.assertEquals(204, device.response_code);
    list<Case> caseList = [SELECT Id FROM Case];
    system.assertEquals(0, caseList.size());
  }
  static testMethod void test_deleteLTEDevice_500(){
    //Need mock response from /lte/devices/{org_id}/{group_id}/{id}
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_error_500());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    LTEOSS_lte_devices device = LTEOSS_lte_devices.deleteLTEDevice('defaul', 130, 7);
    test.stopTest();
    system.assertEquals(500, device.response_code);
    list<Case> caseList = [SELECT Id FROM Case];
    system.assertEquals(0, caseList.size());
  }
  static testMethod void test_deleteLTEDevice_CATCH(){
    //Need mock response from /lte/devices/{org_id}/{group_id}/{id}
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_noBodyNullCode());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    LTEOSS_lte_devices device = LTEOSS_lte_devices.deleteLTEDevice('defaul', 130, 7);
    test.stopTest();
    list<Case> caseList = [SELECT Id FROM Case];
    system.assertEquals(1, caseList.size());
    CalloutLogs.commitLogs();
    list<Callout_Log__c> logsList = [SELECT Id FROM Callout_Log__c];
    system.assertEquals(1, logsList.size());
  }
  static testMethod void test_generateDefaultKey(){
    test.startTest();
    // 'fR5hvy0I' is the known output of the alogrithm with input as specificed
    // BUT! with replaceConfusingCharacters applied it becomes fR5hvyxx!
    system.assertEquals('fR5hvyxx', LTEOSS_lte_devices.generateDefaultKey('2933-BAD9-E505'));
    test.stopTest();
  }
  
  static testMethod void test_replaceConfusingCharacters(){
    String s1 = 'O,o,0,i,I,l,L,1';
    test.startTest();
    String s2 = LTEOSS_lte_devices.replaceConfusingCharacters(s1);
    test.stopTest();
    System.assertEquals('x,x,x,x,x,x,x,x', s2);
  }
  /*********************************************************
   *setup methods for commonly used HTTP mock responses....*
   *********************************************************/
  static HttpResponse getMock_getLTEDevices_OK(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    returnMock.setBody('[{'+
                          '"fw_ver": "7.1.0 build 2860",' + 
                          '"group_id": 92,' + 
                          '"id": 7,' + 
                          '"last_online": "2018-04-10T11:44:31",' + 
                          '"name": "98765432",' + 
                          '"offline_at": "",' + 
                          '"onlineStatus": "ONLINE",' + 
                          '"sn": "2934-B1B5-FFB4",' + 
                          '"status": "online",' + 
                          '"virtual_device_id": "98765432"'+
                          '}]');
    return returnMock;
  }
  static HttpResponse getMock_error_500(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(500);
    returnMock.setBody('{"message": "this is a mock error message"}');
    return returnMock;
  }
  static HttpResponse getMock_getLTEDevice_OK(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    returnMock.setBody('{ "fw_ver": "7.1.0 build 2860",' +
                          '"group_id": 130,' +
                          '"id": 7,' +
                          '"interfaces":' +
                            '[{' +
                              '"apn": "M2MGLOBAL",' +
                              '"carrier_name": "T-Mobile",' +
                              '"cell_id": 22017,' +
                              '"cell_plmn": 310260,' +
                              '"cellular_signals": {' +
                                '"rsrp": -87,' +
                                '"rsrq": -12' +
                              '},' +
                              '"gobi_band_class_name": "LTE Band 4 (AWS 1700/2100 MHz)",' +
                              '"gobi_data_tech": "LTE",' +
                              '"imei": "359072061719460",' +
                              '"ip": "10.30.188.41",' +
                              '"name": "Cellular",' +
                              '"s2g3glte": "LTE-A",' +
                              '"signal": -87,' +
                              '"signal_bar": 4,' +
                              '"signal_quality": -12,' +
                              '"sims":' +
                                '[{ '+
                                  '"sims_iccid": "8901260882225943783",' +
                                  '"sims_imsi": "310260882594378",' +
                                  '"sims_status": "Active" },' +
                                '{}],' +
                              '"status": "Connected to T-Mobile",' +
                              '"status_led": "green"' +
                            '}],' +
                          '"last_online": "2018-04-17T11:08:32",' +
                          '"name": "19238472",' +
                          '"offline_at": "2018-04-17T11:10:16",' +
                          '"onlineStatus": "ONLINE",' +
                          '"sn": "2934-B1B5-FFB4",' +
                          '"ssid_profiles_applied":' +
                            '[{' +
                              '"id": 1,' +
                              '"ssid": "TracPhone LTE1-FFB4"'+
                            '}],'+
                          '"status": "online",' +
                          '"virtual_device_id": "19238472"}');
    return returnMock;
  }
  static HttpResponse getMock_noBody(Integer responseCode){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(responseCode);
    return returnMock;
  }
  static HttpResponse getMock_noBodyNullCode(){
    HttpResponse returnMock = new HttpResponse();
    //The platform appears to default the response code 0 when a value is not set.
    return returnMock;
  }
}