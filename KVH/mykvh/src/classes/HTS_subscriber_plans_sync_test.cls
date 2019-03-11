@isTest
private class HTS_subscriber_plans_sync_test {
  //A common Loop Counter for bulikification purposes
  private static final integer MAX_LOOP_COUNTER = 10;

  @testSetup static void setupTestData() {
    //setup common test data here
    list < HTS_subscriber_plans__c > insertPlans = new list < HTS_subscriber_plans__c > ();
    HTS_subscriber_plans__c op2K = new HTS_subscriber_plans__c();
    op2K.Name = 'OP2K';
    op2K.API_Name__c = 'OP2K';
    op2K.download_cir__c = 1.0000;
    op2K.in_bmc_download_mir__c = 1.0000;
    op2K.in_bmc_upload_mir__c = 0.2560;
    op2K.out_bmc_download_mir__c = 10.0000;
    op2K.out_bmc_upload_mir__c = 3.0000;
    op2K.upload_cir__c = 0.5120;  //altered value

    insertPlans.add(op2k);
    insert insertPlans;
  }

  static testMethod void testSetupData() {
    list < HTS_subscriber_plans__c > readPlans = [SELECT Id, Name, API_Name__c FROM HTS_subscriber_plans__c];
    system.assertEquals(1, readPlans.size());
    //use this method to validate that you have test data setup correctly
    //this will protect you from changes to workflow, process, and validation that break your test code!
  }

  static testMethod void test_execute_PUBLIC(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //setup mock responses for the method: util.synchronizeHTSPlansWithOss(); (in job that is enqueued!)
    mock.addResponse(getMock_OP2K_MODIFIED()); 
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    //Sync shaping policies from OSS
    ID jobID = System.enqueueJob(new HTS_subscriber_plans_sync());
    system.debug('Enqueued Job with ID: ' + jobID);
    test.stopTest();
    list<FeedItem> readFeeds = [SELECT Id, body FROM FeedItem];
    system.assertEquals(1, readFeeds.size());
    system.assert(readFeeds[0].body.contains('ADDED: 0 new OSS Plans to Salesforce. MODIFIED: 1 existing Plans in Salesforce.'), readFeeds);
  }
  static testMethod void test_execute_PUBLIC2(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //setup mock responses for the method: util.synchronizeHTSPlansWithOss(); (in job that is enqueued!)
    mock.addResponse(getMock_OP2K_PLUS1()); 
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    //Sync shaping policies from OSS
    ID jobID = System.enqueueJob(new HTS_subscriber_plans_sync());
    system.debug('Enqueued Job with ID: ' + jobID);
    test.stopTest();
    list<FeedItem> readFeeds = [SELECT Id, body FROM FeedItem];
    system.assertEquals(1, readFeeds.size());
    system.assert(readFeeds[0].body.contains('ADDED: 1 new OSS Plans to Salesforce. MODIFIED: 0 existing Plans in Salesforce.'), readFeeds);
  }
  static testMethod void test_execute_PRIVATE(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //setup mock responses for the method: util.synchronizeHTSPlansWithOss(); (in job that is enqueued!)
    mock.addResponse(getMock_OP2K_UNCHANGED()); 
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    //Sync shaping policies from OSS
    ID jobID = System.enqueueJob(new HTS_subscriber_plans_sync());
    system.debug('Enqueued Job with ID: ' + jobID);
    test.stopTest();
    list<FeedItem> readFeeds = [SELECT Id, body FROM FeedItem];
    system.assertEquals(1, readFeeds.size());
    system.assert(readFeeds[0].body.contains('ADDED: 0 new OSS Plans to Salesforce. MODIFIED: 0 existing Plans in Salesforce.'), readFeeds);
  }
  /**********************************************************
   * setup methods for commonly used HTTP mock responses....*
   **********************************************************/

  static HttpResponse getMock_OP2K_PLUS1(){
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
          body = body + '"obj_name": "CONUS_STANDARD"';
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
  static HttpResponse getMock_OP2K_MODIFIED(){
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
          body = body + '"obj_name": "CONUS_STANDARD"';
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
  static HttpResponse getMock_OP2K_UNCHANGED(){
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
          body = body + '"obj_name": "CONUS_STANDARD"';
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