@isTest
private class HTS_subscriber_plans_test {
  //A common Loop Counter for bulikification purposes
  private static final integer MAX_LOOP_COUNTER = 10;

  @testSetup static void setupTestData() {
    //setup common test data here
    list < HTS_subscriber_plans__c > insertPlans = new list < HTS_subscriber_plans__c > ();
    for (integer i = 0; i < MAX_LOOP_COUNTER; i++) {
      insertPlans.add(new HTS_subscriber_plans__c(Name = 'Plan' + i, API_Name__c = 'Plan' + i));
    }
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
    system.assertEquals(MAX_LOOP_COUNTER + 1, readPlans.size());
    //use this method to validate that you have test data setup correctly
    //this will protect you from changes to workflow, process, and validation that break your test code!
  }
  static testMethod void test_getCollectionsFromOss() {
    // Use MultiStaticResourceCalloutMock to
    // specify fake response for a certain endpoint and 
    // include response body in a static resource.    
    StaticResourceCalloutMock singleMock = new StaticResourceCalloutMock();
    singleMock.setStaticResource('HTS_GET_collections_mircir_MOCK');
    singleMock.setStatusCode(200);
    singleMock.setHeader('Content-Type', 'application/json');
    // Set the mock callout mode
    Test.setMock(HttpCalloutMock.class, singleMock);
    test.startTest();
    HTS_subscriber_plans util = new HTS_subscriber_plans();
    HTSOSS_hts_collections.rtp s = util.getCollectionsFromOss();
    system.assertEquals(200, s.response_code);                    //expected results based on Static Resource MOCK
    system.assertEquals(6, s.satellite_router_types.size());
    system.assertEquals(34, s.subscriber_plans.size());
    system.assertEquals(3, s.terminal_templates.size());
    system.assertEquals(2, s.terminal_types.size());
    //system.assertEquals(3, s.regions.size());	//not implemented yet...
    test.stopTest();
  }
  static testMethod void test_getSubscriberPlansFromOSS() {
    // Use MultiStaticResourceCalloutMock to
    // specify fake response for a certain endpoint and 
    // include response body in a static resource.    
    StaticResourceCalloutMock singleMock = new StaticResourceCalloutMock();
    singleMock.setStaticResource('HTS_GET_collections_MOCK');
    singleMock.setStatusCode(200);
    singleMock.setHeader('Content-Type', 'application/json');
    // Set the mock callout mode
    Test.setMock(HttpCalloutMock.class, singleMock);
    test.startTest();
    HTS_subscriber_plans util = new HTS_subscriber_plans();
    list < HTSOSS_hts_collections.subscriber_plans > s = util.getSubscriberPlansFromOSS();
    system.assertEquals(33, s.size());
  }
  static testMethod void test_getSuscriberPlansFromSalesforce() {
    test.startTest();
    HTS_subscriber_plans util = new HTS_subscriber_plans();
    list < HTS_subscriber_plans__c > sfPlans = util.getSuscriberPlansFromSalesforce();
    system.assertEquals(MAX_LOOP_COUNTER + 1, sfPlans.size());
  }
  static testMethod void test_synchronizeHTSPlansWithOss (){
    // Use MultiStaticResourceCalloutMock to
    // specify fake response for a certain endpoint and 
    // include response body in a static resource.    
    StaticResourceCalloutMock singleMock = new StaticResourceCalloutMock();
    singleMock.setStaticResource('HTS_GET_collections_MOCK');
    singleMock.setStatusCode(200);
    singleMock.setHeader('Content-Type', 'application/json');
    // Set the mock callout mode
    Test.setMock(HttpCalloutMock.class, singleMock);
    list<HTS_subscriber_plans__c> readPlans = [SELECT Id, status__c FROM HTS_subscriber_plans__c];
    system.assertEquals(MAX_LOOP_COUNTER + 1, readPlans.size());        //There should only be test data
    for(integer i = 0; i < readPlans.size(); i++) {
      system.assertEquals('New from OSS', readPlans[i].status__c);  //And it should only have this status...
    }
    test.startTest();
    HTS_subscriber_plans util = new HTS_subscriber_plans();
    string results = util.synchronizeHTSPlansWithOss();
    string expectedResults = 'Synchronize HTS Plans with OSS Job Complete. ADDED: 32 new OSS Plans to Salesforce. MODIFIED: '+ (MAX_LOOP_COUNTER + 1) +' existing Plans in Salesforce.';
    system.assertEquals(expectedResults, results);
    for(HTS_subscriber_plans__c p : [SELECT Id, status__c, API_Name__c FROM HTS_subscriber_plans__c]){
      if(p.API_Name__c.left(4) == 'Plan'){
        system.assertEquals('Deprecated', p.status__c);
      } else if(p.API_Name__c == 'OP2K'){
        system.assertEquals('Updated from OSS', p.status__c);
      } else {
        system.assertEquals('New from OSS', p.status__c);
      }
    }
    test.stopTest();
  }
}