@isTest
private class HTS_terminal_templates_test {
  //A common Loop Counter for bulikification purposes
  private static final integer MAX_LOOP_COUNTER = 10;

  @testSetup static void setupTestData() {
    //setup common test data here
    list < HTS_Terminal_Template__c > insertTemplates = new list < HTS_Terminal_Template__c > ();
    for (integer i = 0; i < MAX_LOOP_COUNTER; i++) {
      insertTemplates.add(new HTS_Terminal_Template__c(Name = 'Plan' + i, obj_id__c = 'Plan' + i));
    }
    insert insertTemplates;
  }
  static testMethod void testSetupData() {
    list < HTS_Terminal_Template__c > readTemplates = [SELECT Id, Name, obj_id__c FROM HTS_Terminal_Template__c];
    system.assertEquals(MAX_LOOP_COUNTER, readTemplates.size());
    //use this method to validate that you have test data setup correctly
    //this will protect you from changes to workflow, process, and validation that break your test code!
  }
	static testMethod void test_getCollectionsFromOss() { //TODO base Class candidate!
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
    HTSOSS_hts_collections.rtp s = util.getCollectionsFromOss();
    system.assertEquals(200, s.response_code);                    //expected results based on Static Resource MOCK
    system.assertEquals(4, s.satellite_router_types.size());
    system.assertEquals(33, s.subscriber_plans.size());
    system.assertEquals(2, s.terminal_templates.size());
    system.assertEquals(1, s.terminal_types.size());
    //system.assertEquals(3, s.regions.size());	//not implemented yet...
    test.stopTest();
  }
  static testMethod void test_getTerminalTemplatesFromOSS() {
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
    HTS_terminal_templates util = new HTS_terminal_templates();
    list < HTSOSS_hts_collections.terminal_templates > s = util.getTerminalTemplatesFromOSS();
    system.assertEquals(2, s.size());
  }
  static testMethod void test_getTerminalTemplatesFromSalesforce() {
    test.startTest();
    HTS_terminal_templates util = new HTS_terminal_templates();
    list < HTS_Terminal_Template__c > sfPlans = util.getTerminalTemplatesFromSalesforce();
    system.assertEquals(MAX_LOOP_COUNTER, sfPlans.size());
  }
  static testMethod void test_synchronizeHTSTemplatesWithOSS(){
    // Use MultiStaticResourceCalloutMock to
    // specify fake response for a certain endpoint and 
    // include response body in a static resource.    
    StaticResourceCalloutMock singleMock = new StaticResourceCalloutMock();
    singleMock.setStaticResource('HTS_GET_collections_MOCK');
    singleMock.setStatusCode(200);
    singleMock.setHeader('Content-Type', 'application/json');
    // Set the mock callout mode
    Test.setMock(HttpCalloutMock.class, singleMock);
    list < HTS_Terminal_Template__c > readTemplates = [SELECT Id, Name, status__c, obj_id__c FROM HTS_Terminal_Template__c];
    system.assertEquals(MAX_LOOP_COUNTER, readTemplates.size());
    for(integer i = 0; i < readTemplates.size(); i++) {
      system.assertEquals('New from OSS', readTemplates[i].status__c);  //And it should only have this status...
    }
    test.startTest();
    HTS_terminal_templates util = new HTS_terminal_templates();
    string results = util.synchronizeHTSTemplatesWithOSS();
    string expectedResults = 'Synchronize HTS Templates with OSS Job Complete. ADDED: 2 new OSS Templates to Salesforce. DEPRECATED: '+MAX_LOOP_COUNTER+' existing Templates in Salesforce.';
    for(HTS_Terminal_Template__c p : [SELECT Id, Name, status__c FROM HTS_Terminal_Template__c]){
      if(p.Name.left(4) == 'Plan'){
        system.assertEquals('Deprecated', p.status__c);
      } else {
        system.assertEquals('New from OSS', p.status__c);
      }
    }
  }
}