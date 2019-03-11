@isTest
private class HTS_terminal_templates_sync_test {
  //A common Loop Counter for bulikification purposes
  private static final integer MAX_LOOP_COUNTER = 10;

  @testSetup static void setupTestData() {
    //setup common test data here
    HTS_Terminal_Template__c insertTemplates = new HTS_Terminal_Template__c();
    insertTemplates.Name = 'CONUS_STANDARD';
    insertTemplates.obj_id__c = 'CONUS_STANDARD';
    insertTemplates.version__c = '0003';

    insert insertTemplates;
  }
  static testMethod void testSetupData() {
    list < HTS_Terminal_Template__c > readTemplates = [SELECT Id, Name, version__c, obj_id__c FROM HTS_Terminal_Template__c];
    system.assertEquals(1, readTemplates.size());
    //use this method to validate that you have test data setup correctly
    //this will protect you from changes to workflow, process, and validation that break your test code!
  }
  static testMethod void test_execute_PRIVATE1(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //setup mock responses for the method: util.synchronizeHTSPlansWithOss(); (in job that is enqueued!)
    mock.addResponse(getMock_CONUS_4()); 
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    //Sync shaping policies from OSS
    ID jobID = System.enqueueJob(new HTS_terminal_templates_sync());
    system.debug('Enqueued Job with ID: ' + jobID);
    test.stopTest();
    list<FeedItem> readFeeds = [SELECT Id, body FROM FeedItem];
    system.assertEquals(1, readFeeds.size());
    system.assert(readFeeds[0].body.contains('ADDED: 0 new OSS Templates to Salesforce. MODIFIED: 1 existing Templates in Salesforce.'), readFeeds);
  }
  static testMethod void test_execute_PRIVATE2(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //setup mock responses for the method: util.synchronizeHTSPlansWithOss(); (in job that is enqueued!)
    mock.addResponse(getMock_ASIA_added()); 
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    //Sync shaping policies from OSS
    ID jobID = System.enqueueJob(new HTS_terminal_templates_sync());
    system.debug('Enqueued Job with ID: ' + jobID);
    test.stopTest();
    list<FeedItem> readFeeds = [SELECT Id, body FROM FeedItem];
    system.assertEquals(1, readFeeds.size());
    system.assert(readFeeds[0].body.contains('ADDED: 1 new OSS Templates to Salesforce. MODIFIED: 0 existing Templates in Salesforce.'), readFeeds);
  }
  static testMethod void test_execute_PUBLIC(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //setup mock responses for the method: util.synchronizeHTSPlansWithOss(); (in job that is enqueued!)
    mock.addResponse(getMock_CONUS_3()); 
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    //Sync shaping policies from OSS
    ID jobID = System.enqueueJob(new HTS_terminal_templates_sync());
    system.debug('Enqueued Job with ID: ' + jobID);
    test.stopTest();
    list<FeedItem> readFeeds = [SELECT Id, body FROM FeedItem];
    system.assertEquals(1, readFeeds.size());
    system.assert(readFeeds[0].body.contains('ADDED: 0 new OSS Templates to Salesforce. MODIFIED: 0 existing Templates in Salesforce.'), readFeeds);
  }


  /**********************************************************
   * setup methods for commonly used HTTP mock responses....*
   **********************************************************/

  static HttpResponse getMock_CONUS_3(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    String body = '';
    body = body + '{';
      body = body + '"terminal_types": [';
        body = body + '{';
          body = body + '"obj_id": 2931,';
          body = body + '"obj_name": "KVH-TT-0.6M-v7-101"';
        body = body + '}';
      body = body + '],';
      body = body + '"satellite_router_types": [';
        body = body + '{';
          body = body + '"obj_id": "X7",';
          body = body + '"obj_name": "X7"';
        body = body + '}';
      body = body + '],';
      body = body + '"terminal_templates": [';
        body = body + '{';
          body = body + '"obj_id": "CONUS_STANDARD",';
          body = body + '"obj_name": "CONUS_STANDARD",';
          body = body + '"version": "0003"';
        body = body + '}';
      body = body + '],';
      body = body + '"subscriber_plans": [';
        body = body + '{';
          body = body + '"download_cir": "1.0000",';
          body = body + '"obj_id": "OP20K_RES",';
          body = body + '"out_bmc_download_mir": "10.0000",';
          body = body + '"upload_cir": "0.2560",';
          body = body + '"in_bmc_download_mir": "1.0000",';
          body = body + '"obj_name": "OP20K_RES",';
          body = body + '"out_bmc_upload_mir": "3.0000",';
          body = body + '"in_bmc_upload_mir": "0.2560"';
        body = body + '},';
        body = body + '{';
          body = body + '"download_cir": "1.0000",';
          body = body + '"obj_id": "OP2K",';
          body = body + '"out_bmc_download_mir": "10.0000",';
          body = body + '"upload_cir": "0.5120",';
          body = body + '"in_bmc_download_mir": "1.0000",';
          body = body + '"obj_name": "OP2K",';
          body = body + '"out_bmc_upload_mir": "3.0000",';
          body = body + '"in_bmc_upload_mir": "0.2560"';
        body = body + '}';
      body = body + ']';
    body = body + '}';
    returnMock.setBody(body);
    return returnMock;
  }
  static HttpResponse getMock_ASIA_added(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    String body = '';
    body = body + '{';
      body = body + '"terminal_types": [';
        body = body + '{';
          body = body + '"obj_id": 2931,';
          body = body + '"obj_name": "KVH-TT-0.6M-v7-101"';
        body = body + '}';
      body = body + '],';
      body = body + '"satellite_router_types": [';
        body = body + '{';
          body = body + '"obj_id": "X7",';
          body = body + '"obj_name": "X7"';
        body = body + '}';
      body = body + '],';
      body = body + '"terminal_templates": [';
        body = body + '{';
          body = body + '"obj_id": "CONUS_STANDARD",';
          body = body + '"obj_name": "CONUS_STANDARD",';
          body = body + '"version": "0003"';
        body = body + '},';
        body = body + '{';
          body = body + '"obj_id": "ASIA_STANDARD",';
          body = body + '"obj_name": "ASIA_STANDARD",';
          body = body + '"version": "0001"';
        body = body + '}';
      body = body + '],';
      body = body + '"subscriber_plans": [';
        body = body + '{';
          body = body + '"download_cir": "1.0000",';
          body = body + '"obj_id": "OP2K",';
          body = body + '"out_bmc_download_mir": "10.0000",';
          body = body + '"upload_cir": "0.2560",';
          body = body + '"in_bmc_download_mir": "1.0000",';
          body = body + '"obj_name": "OP2K",';
          body = body + '"out_bmc_upload_mir": "3.0000",';
          body = body + '"in_bmc_upload_mir": "0.2560"';
        body = body + '}';
      body = body + ']';
    body = body + '}';
    returnMock.setBody(body);
    return returnMock;
  }
  static HttpResponse getMock_CONUS_4(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    String body = '';
    body = body + '{';
      body = body + '"terminal_types": [';
        body = body + '{';
          body = body + '"obj_id": 2931,';
          body = body + '"obj_name": "KVH-TT-0.6M-v7-101"';
        body = body + '}';
      body = body + '],';
      body = body + '"satellite_router_types": [';
        body = body + '{';
          body = body + '"obj_id": "X7",';
          body = body + '"obj_name": "X7"';
        body = body + '}';
      body = body + '],';
      body = body + '"terminal_templates": [';
        body = body + '{';
          body = body + '"obj_id": "CONUS_STANDARD",';
          body = body + '"obj_name": "CONUS_STANDARD",';
          body = body + '"version": "0004"';
        body = body + '}';
      body = body + '],';
      body = body + '"subscriber_plans": [';
        body = body + '{';
          body = body + '"obj_name": "OP2K",';
          body = body + '"obj_id": "OP2K",';
          body = body + '"download_cir": "1.0000",';
          body = body + '"in_bmc_download_mir": "1.0000",';
          body = body + '"in_bmc_upload_mir": "0.2560",';
          body = body + '"out_bmc_download_mir": "10.0000",';
          body = body + '"out_bmc_upload_mir": "3.0000",';
          body = body + '"upload_cir": "0.5120"';
        body = body + '}';
      body = body + ']';
    body = body + '}';
    returnMock.setBody(body);
    return returnMock;
  }
}