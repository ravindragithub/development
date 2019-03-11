@isTest
private class HTS_ltgsvc_region_selector_test {
	
  @testSetup static void setupTestData(){
    //setup common test data here
    //Need some config templates/regions...
    list<HTS_Terminal_Template__c> insertRegions = new list<HTS_Terminal_Template__c>();
    HTS_Terminal_Template__c CONUS = new HTS_Terminal_Template__c(
      Name='CONUS_STANDARD',
      obj_id__c='CONUS_STANDARD',
      Region__c='CONUS',
      Status__c='Updated from OSS',
      Version__c='0001',
      isReleased__c=True);
    HTS_Terminal_Template__c EMEA = new HTS_Terminal_Template__c(
      Name='EMEA_STANDARD',
      obj_id__c='EMEA_STANDARD',
      Region__c='EMEA',
      Status__c='New from OSS',
      Version__c='0001',
      isReleased__c=True);
    HTS_Terminal_Template__c APAC = new HTS_Terminal_Template__c(
      Name='APAC_STANDARD',
      obj_id__c='APAC_STANDARD',
      Region__c='APAC',
      Status__c='New from OSS',
      Version__c='0001',
      isReleased__c=True);
    insertRegions.add(CONUS);
    insertRegions.add(EMEA);
    insertRegions.add(APAC);
    insert insertRegions;
  }
  static testMethod void testSetupData(){
    //use this method to validate that you have test data setup correctly
    //this will protect you from changes to workflow, process, and validation that break your test code!
    list<HTS_Terminal_Template__c> readRegions = [SELECT Id, obj_id__c FROM HTS_Terminal_Template__c];
    system.assertEquals(3, readRegions.size());
  }
  static testMethod void test_getRegions(){
    list<HTS_Terminal_Template__c> readRegions = new list<HTS_Terminal_Template__c>();
    test.startTest();
    readRegions = HTS_ltgsvc_region_selector.getRegions();
    system.assertEquals(3, readRegions.size());

    readRegions[0].Region__c = null;
    update readRegions[0];
    readRegions.clear();
    readRegions = HTS_ltgsvc_region_selector.getRegions();
    test.stopTest();
    system.assertEquals(2, readRegions.size());
  }
  static testMethod void test_getTerminal(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //setup mock responses for the method:  returnObj = util.postTerminalsToReplace(util);;
    mock.addResponse(getMock_terminalListOf1());
    mock.addResponse(getMock_terminalParams());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    HTSOSS_hts_terminals returnedObj = HTS_ltgsvc_region_selector.getTerminal('12345678');
    test.stopTest();
    system.assertEquals('13728772', returnedObj.terminal_id);
    system.assertEquals('CONUS_STANDARD', returnedObj.template_id);
    system.assertEquals(3541, returnedObj.coremodule_id);
  }
  static testMethod void test_updateTerminal(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //setup mock responses for the method: Service_HTSRegions.updateTerminal(...);
    //setup mock responses for the method: getTerminalDetails(vtid);
    mock.addResponse(getMock_terminalListOf1());
    mock.addResponse(getMock_terminalParams());
    //setup mock responses for the method: enqueueReplaceJob(termToReplaceAsync);
    mock.addResponse(getMock_replace202());
    Test.setMock(HttpCalloutMock.class, mock);
    String template_id = 'CONUS_STANDARD';
    String terminal_ip_address = '10.64.83.0/24';
    String terminal_id = '13728772';
    Decimal terminaltype_id = 1828;
    test.startTest();
    String returnedJobId = HTS_ltgsvc_region_selector.updateTerminal(
                              terminal_id,
                              terminal_ip_address,
                              template_id,
                              terminaltype_id);
    serviceResults returnedLog = Service_HTSRegions.getLog();
    test.stopTest();
    System.assertEquals('a75ac3d8-436f-44cb-9628-9829d5ac0dd6', returnedJobId, returnedLog);
  }

  /**********************************************************
   * setup methods for commonly used HTTP mock responses....*
   **********************************************************/
  static HttpResponse getMock_terminalListOf1(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    returnMock.setBody( '[{"activate": true,' +
                          '"contactnote": "CONUS_STANDARD.0003",' +
                          '"coremodule_id": 7424,' +
                          '"customer_id": "",' +
                          '"is_active": true,' +
                          '"obj_id": 10641,' +
                          '"obj_revision": 2,' +
                          '"template_id": "CONUS_STANDARD",' +
                          '"template_version": "0003",' +
                          '"terminal_id": "99992048"}]');
    return returnMock;
  }
  static HttpResponse getMock_terminalParams(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    String bodyString = '{"obj_id": 2046,' +
                        '"obj_revision": 3,' +
                        '"mgmtipaddress": "10.242.1.38",' +
                        '"terminal_id": "13728772",' +
                        '"terminal_service_ip": "10.64.38.1",' +
                        '"terminaltype_id": 1828,' + 
                        '"template_id": "CONUS_STANDARD",' +
                        '"coremodule_id": 3541,' +
                        '"message": "",' +
                        '"response_code":200}';
    returnMock.setBody(bodyString);
    return returnMock;
  }
  static HttpResponse getMock_replace202(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(202);
    String bodyString = '[{"obj_id": "a75ac3d8-436f-44cb-9628-9829d5ac0dd6",' +
                          '"terminal_id": "18395443"}]';
    returnMock.setBody(bodyString);
    return returnMock;
  }
}