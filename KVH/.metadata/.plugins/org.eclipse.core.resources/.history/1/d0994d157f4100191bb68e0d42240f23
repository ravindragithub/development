@isTest
private class Service_HTSRegions_test {
  //setup testClass variables here. For example:
  //RecordType Ids
  private static final Id ServCloud_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Cloud').getRecordTypeId();

  @testSetup static void setupTestData(){

  }

  static testMethod void testSetupData(){
    // Test that your test data is setup correctly

  }
  static testMethod void test_staticLog(){
    serviceResults logStringResponse = Service_HTSRegions.getLog();
    system.assert(logStringResponse.message.contains('SERVICE_INITIALIZATION'));
    system.assert(logStringResponse.message.contains('Initializing HTS Regions Service Service'), logStringResponse);
    system.assertEquals(0, Service_HTSRegions.getWarningCount());
  }
  static testMethod void test_returnFatalError(){
    test.startTest();
    serviceResults returnedLog = Service_HTSRegions.returnFatalError();
    test.stopTest();
    system.debug('log message: ' + returnedLog.message);
    system.assert(returnedLog.message.contains('HTS Regions Service failed ' + 
                                                'to complete successfully. See log for details.'), returnedLog.message);
    Case c = [SELECT ID, Subject, Status, Origin, RecordTypeId, Description, CaseNumber FROM Case LIMIT 1];
    system.assertEquals(ServCloud_RECORD_TYPE_ID, c.RecordTypeId);
    system.assertEquals('Fatal Error in Service_HTSRegions Class', c.Subject);
    system.assertEquals('System Generated', c.Origin);
    system.assertEquals('New', c.Status);
  }
  static testMethod void test_preProcessValidation_OK(){
    list<String> inputVTIDs = new list<String>();
    inputVTIDs.add('12345678');
    test.startTest();
    Service_HTSRegions.preProcessValidation(inputVTIDs);
    serviceResults returnedLog = Service_HTSRegions.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success);
    system.assert(returnedLog.message.contains('1 Valid Terminal IDs submitted'), returnedLog.message);
    system.assert(returnedLog.message.contains('METHOD_EXIT'), returnedLog.message);
  }
  static testMethod void test_preProcessValidation_FAIL_emptyList(){
    list<String> inputVTIDs = new list<String>();
    test.startTest();
    Service_HTSRegions.preProcessValidation(inputVTIDs);
    serviceResults returnedLog = Service_HTSRegions.getLog();
    test.stopTest();
    system.assertEquals(false, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('0 Terminal IDs submitted'), returnedLog.message);
    system.assert(returnedLog.message.contains('FATAL_ERROR'), returnedLog.message);
  }
  static testMethod void test_preProcessValidation_FAIL_BadVTIDs(){
    list<String> inputVTIDs = new list<String>();
    inputVTIDs.add('12345678'); //OK
    inputVTIDs.add('02345678'); //BAD - leading zero
    inputVTIDs.add('12345670'); //BAD - trainling zero
    inputVTIDs.add('123456789'); //BAD - too long
    inputVTIDs.add('1234567'); //BAD - too short
    inputVTIDs.add('a2345678'); //BAD - contains alphas
    test.startTest();
    Service_HTSRegions.preProcessValidation(inputVTIDs);
    serviceResults returnedLog = Service_HTSRegions.getLog();
    test.stopTest();
    system.assertEquals(false, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('5 Out of 6 Terminal IDs invalid!'), returnedLog.message);
    system.assert(returnedLog.message.contains('FATAL_ERROR'), returnedLog.message);
  }
  static testMethod void test_readSubsFromOSS_OK(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //setup mock responses for the method: oneSubscriber.getSubscribersList(null, oneTrafficId);
    mock.addResponse(getMock_subscribersList_OK());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    Service_HTSRegions.readSubsFromOSS('12345678-00');
    serviceResults returnedLog = Service_HTSRegions.getLog();
    Integer warningsGenerated = Service_HTSRegions.getWarningCount();
    test.stopTest();
    system.assert(returnedLog.message.contains('|Returning Subscribers from OSS for Traffic ID: 12345678-00'), returnedLog);
    system.assertEquals(0, warningsGenerated, returnedLog);
  }
  static testMethod void test_readSubsFromOSS_FAIL_emptyList(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //setup mock responses for the method: oneSubscriber.getSubscribersList(null, oneTrafficId);
    mock.addResponse(getMock_subscribersList_emptyList());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    Service_HTSRegions.readSubsFromOSS('12345678-00');
    serviceResults returnedLog = Service_HTSRegions.getLog();
    Integer warningsGenerated = Service_HTSRegions.getWarningCount();
    test.stopTest();
    system.assert(returnedLog.message.contains('INFO'), returnedLog);
    system.assert(returnedLog.message.contains('|No Subscribers in OSS for: '), returnedLog);
    system.assertEquals(0, warningsGenerated, returnedLog);
  }
  static testMethod void test_readSubsFromOSS_FAIL_duplicateSubs(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //setup mock responses for the method: oneSubscriber.getSubscribersList(null, oneTrafficId);
    mock.addResponse(getMock_subscribersList_duplicates());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    Service_HTSRegions.readSubsFromOSS('12345678-00');
    serviceResults returnedLog = Service_HTSRegions.getLog();
    Integer warningsGenerated = Service_HTSRegions.getWarningCount();
    test.stopTest();
    system.assert(returnedLog.message.contains('|2 Duplicate Subscribers in OSS for: '), returnedLog);
    system.assert(returnedLog.message.contains('|Returning Subscribers from OSS for Traffic ID: 12345678-00'), returnedLog);
    system.assertEquals(1, warningsGenerated, returnedLog);
  }
  static testMethod void test_subscriberAnalysis_OK_Enabled(){
    list<HTSOSS_hts_subscribers> subscriberList = new list<HTSOSS_hts_subscribers>();
    HTSOSS_hts_subscribers oneSub = new HTSOSS_hts_subscribers();
    oneSub.subscriber_id = '12345678-00';
    oneSub.subscriber_plan_id = 'Enabled';
    subscriberList.add(oneSub);
    test.startTest();
    Integer warningsGenerated = Service_HTSRegions.subscriberAnalysis(subscriberList, '12345678');
    serviceResults returnedLog = Service_HTSRegions.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('Completed Subscriber Analysis for: 12345678'), returnedLog);
    system.assertEquals(0, warningsGenerated, returnedLog);
  }
  static testMethod void test_subscriberAnalysis_OK_Hybrid(){
    list<HTSOSS_hts_subscribers> subscriberList = new list<HTSOSS_hts_subscribers>();
    HTSOSS_hts_subscribers sub1 = new HTSOSS_hts_subscribers();
    sub1.subscriber_id = '12345678-01';
    sub1.subscriber_plan_id = 'HS_GEN';
    subscriberList.add(sub1);
    HTSOSS_hts_subscribers sub2 = new HTSOSS_hts_subscribers();
    sub2.subscriber_id = '12345678-02';
    sub2.subscriber_plan_id = 'UL1_H';
    subscriberList.add(sub2);
    test.startTest();
    Integer warningsGenerated = Service_HTSRegions.subscriberAnalysis(subscriberList, '12345678');
    serviceResults returnedLog = Service_HTSRegions.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('Completed Subscriber Analysis for: 12345678'), returnedLog);
    system.assertEquals(0, warningsGenerated, returnedLog);
  }
  static testMethod void test_subscriberAnalysis_FAIL_emptyList(){
    list<HTSOSS_hts_subscribers> subscriberList = new list<HTSOSS_hts_subscribers>();
    HTSOSS_hts_subscribers sub1 = new HTSOSS_hts_subscribers();
    test.startTest();
    Integer warningsGenerated = Service_HTSRegions.subscriberAnalysis(subscriberList, '12345678');
    serviceResults returnedLog = Service_HTSRegions.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('WARNING'), returnedLog);
    system.assert(returnedLog.message.contains('|12345678 has ZERO Subscribers in OSS!'), returnedLog);
    system.assert(returnedLog.message.contains('Completed Subscriber Analysis for: 12345678'), returnedLog);
    system.assertEquals(1, warningsGenerated, returnedLog);
  }
  static testMethod void test_subscriberAnalysis_FAIL_abnormalEnabled(){
    list<HTSOSS_hts_subscribers> subscriberList = new list<HTSOSS_hts_subscribers>();
    HTSOSS_hts_subscribers sub1 = new HTSOSS_hts_subscribers();
    sub1.subscriber_id = '12345678-01';
    sub1.subscriber_plan_id = 'Enabled';
    subscriberList.add(sub1);
    test.startTest();
    Integer warningsGenerated = Service_HTSRegions.subscriberAnalysis(subscriberList, '12345678');
    serviceResults returnedLog = Service_HTSRegions.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('WARNING'), returnedLog);
    system.assert(returnedLog.message.contains('|SINGLE Subscriber in OSS for: '), returnedLog);
    system.assert(returnedLog.message.contains('Completed Subscriber Analysis for: 12345678'), returnedLog);
    system.assertEquals(1, warningsGenerated, returnedLog);
  }
  static testMethod void test_subscriberAnalysis_FAIL_duplicateTids(){
    list<HTSOSS_hts_subscribers> subscriberList = new list<HTSOSS_hts_subscribers>();
    HTSOSS_hts_subscribers sub1 = new HTSOSS_hts_subscribers();
    sub1.subscriber_id = '12345678-02';
    sub1.subscriber_plan_id = 'HS_GEN';
    subscriberList.add(sub1);
    HTSOSS_hts_subscribers sub2 = new HTSOSS_hts_subscribers();
    sub2.subscriber_id = '12345678-02';
    sub2.subscriber_plan_id = 'UL1_H';
    subscriberList.add(sub2);
    test.startTest();
    Integer warningsGenerated = Service_HTSRegions.subscriberAnalysis(subscriberList, '12345678');
    serviceResults returnedLog = Service_HTSRegions.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('WARNING'), returnedLog);
    system.assert(returnedLog.message.contains('|Duplicate Traffic Identifiers detected: '), returnedLog);
    system.assert(returnedLog.message.contains('|Abnormal Traffic Identifiers detected: '), returnedLog);
    system.assert(returnedLog.message.contains('Completed Subscriber Analysis for: 12345678'), returnedLog);
    system.assertEquals(2, warningsGenerated, returnedLog);
  }
  static testMethod void test_subscriberAnalysis_FAIL_abnormalTids(){
    list<HTSOSS_hts_subscribers> subscriberList = new list<HTSOSS_hts_subscribers>();
    HTSOSS_hts_subscribers sub1 = new HTSOSS_hts_subscribers();
    sub1.subscriber_id = '12345678-01';
    sub1.subscriber_plan_id = 'HS_GEN';
    subscriberList.add(sub1);
    HTSOSS_hts_subscribers sub2 = new HTSOSS_hts_subscribers();
    sub2.subscriber_id = '12345678-03';
    sub2.subscriber_plan_id = 'UL1_H';
    subscriberList.add(sub2);
    test.startTest();
    Integer warningsGenerated = Service_HTSRegions.subscriberAnalysis(subscriberList, '12345678');
    serviceResults returnedLog = Service_HTSRegions.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('WARNING'), returnedLog);
    system.assert(returnedLog.message.contains('|Abnormal Traffic Identifiers detected: '), returnedLog);
    system.assert(returnedLog.message.contains('Completed Subscriber Analysis for: 12345678'), returnedLog);
    system.assertEquals(1, warningsGenerated, returnedLog);
  }
  static testMethod void test_subscriberAnalysis_FAIL_tooManyTids(){
    list<HTSOSS_hts_subscribers> subscriberList = new list<HTSOSS_hts_subscribers>();
    HTSOSS_hts_subscribers sub1 = new HTSOSS_hts_subscribers();
    sub1.subscriber_id = '12345678-01';
    sub1.subscriber_plan_id = 'HS_GEN';
    subscriberList.add(sub1);
    HTSOSS_hts_subscribers sub2 = new HTSOSS_hts_subscribers();
    sub2.subscriber_id = '12345678-03';
    sub2.subscriber_plan_id = 'UL1_H';
    subscriberList.add(sub2);
    HTSOSS_hts_subscribers sub3 = new HTSOSS_hts_subscribers();
    sub3.subscriber_id = '12345678-00';
    sub3.subscriber_plan_id = 'Enabled';
    subscriberList.add(sub3);
    test.startTest();
    Integer warningsGenerated = Service_HTSRegions.subscriberAnalysis(subscriberList, '12345678');
    serviceResults returnedLog = Service_HTSRegions.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('WARNING'), returnedLog);
    system.assert(returnedLog.message.contains('|Found: 3 Subscribers related to: 12345678 in OSS!'), returnedLog);
    system.assert(returnedLog.message.contains('Completed Subscriber Analysis for: 12345678'), returnedLog);
    system.assertEquals(1, warningsGenerated, returnedLog);
  }
  static testMethod void test_updateShapingPolicy(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //setup mock responses for the method: readSubs.addAll(readSubsFromOSS(vtid + '-02'));
    mock.addResponse(getMock_noBody(204));
    Test.setMock(HttpCalloutMock.class, mock);
    HTSOSS_hts_subscribers sub1 = new HTSOSS_hts_subscribers();
    sub1.subscriber_id = '12345678-01';
    sub1.subscriber_plan_id = 'HS_GEN';
    sub1.obj_id = '00000000-0000-0001-0000-000000000002';
    test.startTest();
    Integer warningsGenerated = Service_HTSRegions.updateShapingPolicy(sub1);
    serviceResults returnedLog = Service_HTSRegions.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('|Sucessfully updated via PUT: 12345678-01'), returnedLog);
    system.assertEquals(0, warningsGenerated, returnedLog);
  }
  static testMethod void test_updateShapingPolicy_unknownError(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //setup mock responses for the method: readSubs.addAll(readSubsFromOSS(vtid + '-02'));
    mock.addResponse(getMock_noBody(418));
    Test.setMock(HttpCalloutMock.class, mock);
    HTSOSS_hts_subscribers sub1 = new HTSOSS_hts_subscribers();
    sub1.subscriber_id = '12345678-01';
    sub1.subscriber_plan_id = 'HS_GEN';
    sub1.obj_id = '00000000-0000-0001-0000-000000000002';
    test.startTest();
    Integer warningsGenerated = Service_HTSRegions.updateShapingPolicy(sub1);
    serviceResults returnedLog = Service_HTSRegions.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('|Unknown Error: 12345678-01'), returnedLog);
    system.assertEquals(1, warningsGenerated, returnedLog);
  }
  static testMethod void test_updateShapingPolicy_400(){
    //Need mock responses for a whole bunch of things!
    //QueueHttpMock mock = new QueueHttpMock();
    //setup mock responses for the method: readSubs.addAll(readSubsFromOSS(vtid + '-02'));
    //mock.addResponse(getMock_noBody(418));
    //Test.setMock(HttpCalloutMock.class, mock);
    HTSOSS_hts_subscribers sub1 = new HTSOSS_hts_subscribers();
    sub1.subscriber_id = '12345678-01';
    sub1.subscriber_plan_id = 'HS_GEN';
    //sub1.obj_id = '00000000-0000-0001-0000-000000000002';
    test.startTest();
    Integer warningsGenerated = Service_HTSRegions.updateShapingPolicy(sub1);
    serviceResults returnedLog = Service_HTSRegions.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('|400 Subscriber details not valid. No Call to OSS was made: '), returnedLog);
    system.assertEquals(1, warningsGenerated, returnedLog);
  }
  static testMethod void test_updateShapingPolicy_404(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //setup mock responses for the method: readSubs.addAll(readSubsFromOSS(vtid + '-02'));
    mock.addResponse(getMock_subscribersPUT_404());
    Test.setMock(HttpCalloutMock.class, mock);
    HTSOSS_hts_subscribers sub1 = new HTSOSS_hts_subscribers();
    sub1.subscriber_id = '12345678-01';
    sub1.subscriber_plan_id = 'HS_GEN';
    sub1.obj_id = '00000000-0000-0001-0000-000000000002';
    test.startTest();
    Integer warningsGenerated = Service_HTSRegions.updateShapingPolicy(sub1);
    serviceResults returnedLog = Service_HTSRegions.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('|404 Subscriber not found in OSS: 12345678-01'), returnedLog);
    system.assert(returnedLog.message.contains('|OSS Returned: Subscriber not found'), returnedLog);
    system.assertEquals(1, warningsGenerated, returnedLog);
  }
  static testMethod void test_updateShapingPolicy_500(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //setup mock responses for the method: readSubs.addAll(readSubsFromOSS(vtid + '-02'));
    mock.addResponse(getMock_subscribersPUT_500());
    Test.setMock(HttpCalloutMock.class, mock);
    HTSOSS_hts_subscribers sub1 = new HTSOSS_hts_subscribers();
    sub1.subscriber_id = '12345678-01';
    sub1.subscriber_plan_id = 'HS_GEN';
    sub1.obj_id = '00000000-0000-0001-0000-000000000002';
    test.startTest();
    Integer warningsGenerated = Service_HTSRegions.updateShapingPolicy(sub1);
    serviceResults returnedLog = Service_HTSRegions.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('|500 OSS Error: 12345678-01'), returnedLog);
    system.assert(returnedLog.message.contains('|OSS Returned: Failed to PUT Subscriber'), returnedLog);
    system.assertEquals(1, warningsGenerated, returnedLog);
  }
  static testMethod void test_getTerminalDetails_OK(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //setup mock responses for the method: terminalList = util.getTerminals(null, VTID);
    mock.addResponse(getMock_terminalListOf1());
    //setup mock responses for the method: returnObj = util.getTerminal(returnObj);
    mock.addResponse(getMock_terminalParams());
    Test.setMock(HttpCalloutMock.class, mock);
    String testVTID = '13728772';
    test.startTest();
    HTSOSS_hts_terminals returnedObj = Service_HTSRegions.getTerminalDetails(testVTID);
    serviceResults returnedLog = Service_HTSRegions.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success);
    system.assert(returnedLog.message.contains('Successfully obtained details for Terminal with identity: 13728772'), returnedLog);
  }
  static testMethod void test_getTerminalDetails_FAIL_DUPE(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //setup mock responses for the method: terminalList = util.getTerminals(null, VTID);
    mock.addResponse(getMock_terminalListOf2());
    //setup mock responses for the method: returnObj = util.getTerminal(returnObj);
    mock.addResponse(getMock_terminalParams());
    Test.setMock(HttpCalloutMock.class, mock);
    String testVTID = '13728772';
    test.startTest();
    HTSOSS_hts_terminals returnedObj = Service_HTSRegions.getTerminalDetails(testVTID);
    serviceResults returnedLog = Service_HTSRegions.getLog();
    test.stopTest();
    system.assertEquals(false, returnedLog.success);
    system.assert(returnedLog.message.contains('2 Terminals with: 13728772 returned from OSS!'), returnedLog);
  }
  static testMethod void test_getTerminalDetails_FAIL_DETAILS(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //setup mock responses for the method: terminalList = util.getTerminals(null, VTID);
    mock.addResponse(getMock_terminalListOf1());
    //setup mock responses for the method: returnObj = util.getTerminal(returnObj);
    mock.addResponse(getMock_terminal404());
    Test.setMock(HttpCalloutMock.class, mock);
    String testVTID = '13728772';
    test.startTest();
    HTSOSS_hts_terminals returnedObj = Service_HTSRegions.getTerminalDetails(testVTID);
    serviceResults returnedLog = Service_HTSRegions.getLog();
    test.stopTest();
    system.assertEquals(false, returnedLog.success);
    system.assert(returnedLog.message.contains('OSS returned: 404'), returnedLog);
  }
  static testMethod void test_convertToAsynch_ALLPARAMS(){
    HTSOSS_hts_terminals termToConvert = new HTSOSS_hts_terminals();
    termToConvert.coremodule_id = 3451;
    termToConvert.mgmtipaddress = '10.242.1.38';
    termToConvert.template_id = 'CONUS_STANDARD';
    termToConvert.terminal_service_ip = '10.64.83.1';
    termToConvert.terminal_id = '13728772';
    termToConvert.terminaltype_id = 1828;
    test.startTest();
    HTSOSS_hts_terminals_asynch returnedObj = Service_HTSRegions.convertToAsynch('10.83.83.0/24', 'ASIA_STANDARD', 1828, termToConvert);
    serviceResults returnedLog = Service_HTSRegions.getLog();
    system.debug('returned Object: ' + returnedObj);
    test.stopTest();
    System.assertEquals('10.83.83.0/24', returnedObj.terminal_ip_address);
    system.assertEquals(true, returnedLog.success);
    system.assert(returnedLog.message.contains('Successfully converted Terminal to asynchronous Object'), returnedLog);
  }
  static testMethod void test_convertToAsynch_NOPARAMS(){
    HTSOSS_hts_terminals termToConvert = new HTSOSS_hts_terminals();
    termToConvert.coremodule_id = 3451;
    termToConvert.mgmtipaddress = '10.242.1.38';
    termToConvert.template_id = 'CONUS_STANDARD';
    termToConvert.terminal_service_ip = '10.64.83.1';
    termToConvert.terminal_id = '13728772';
    termToConvert.terminaltype_id = 1828;
    test.startTest();
    HTSOSS_hts_terminals_asynch returnedObj = Service_HTSRegions.convertToAsynch(null, null, null, termToConvert);
    serviceResults returnedLog = Service_HTSRegions.getLog();
    system.debug('returned Object: ' + returnedObj);
    test.stopTest();
    System.assertEquals('10.64.83.0/24', returnedObj.terminal_ip_address);
    system.assertEquals(true, returnedLog.success);
    system.assert(returnedLog.message.contains('Successfully converted Terminal to asynchronous Object'), returnedLog);
  }
  static testMethod void test_enqueueReplaceJob_OK(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //setup mock responses for the method:  returnObj = util.postTerminalsToReplace(util);;
    mock.addResponse(getMock_replace202());
    Test.setMock(HttpCalloutMock.class, mock);
    HTSOSS_hts_terminals_asynch termToReplace = new HTSOSS_hts_terminals_asynch();
    termToReplace.coremodule_id = 3451;
    termToReplace.mgmtipaddress = '10.242.1.38';
    termToReplace.template_id = 'CONUS_STANDARD';
    termToReplace.terminal_ip_address = '10.64.83.0/24';
    termToReplace.terminal_id = '13728772';
    termToReplace.terminaltype_id = 1828;
    test.startTest();
    HTSOSS_hts_terminals_replace returnedObj = Service_HTSRegions.enqueueReplaceJob(termToReplace);
    serviceResults returnedLog = Service_HTSRegions.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('INFO\tJob ID: a75ac3d8-436f-44cb-9628-9829d5ac0dd6'), returnedLog.message);
  }
  static testMethod void test_enqueueReplaceJob_FAIL500(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //setup mock responses for the method:  returnObj = util.postTerminalsToReplace(util);;
    mock.addResponse(getMock_replace500());
    Test.setMock(HttpCalloutMock.class, mock);
    HTSOSS_hts_terminals_asynch termToReplace = new HTSOSS_hts_terminals_asynch();
    termToReplace.coremodule_id = 3451;
    termToReplace.mgmtipaddress = '10.242.1.38';
    termToReplace.template_id = 'CONUS_STANDARD';
    termToReplace.terminal_ip_address = '10.64.83.0/24';
    termToReplace.terminal_id = '13728772';
    termToReplace.terminaltype_id = 1828;
    test.startTest();
    HTSOSS_hts_terminals_replace returnedObj = Service_HTSRegions.enqueueReplaceJob(termToReplace);
    serviceResults returnedLog = Service_HTSRegions.getLog();
    test.stopTest();
    system.assertEquals(false, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('FATAL_ERROR\tOSS returned: 500'), returnedLog.message);
  }
  static testMethod void test_enqueueReplaceJob_FAILMULTI(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //setup mock responses for the method:  returnObj = util.postTerminalsToReplace(util);;
    mock.addResponse(getMock_replace202_multi());
    Test.setMock(HttpCalloutMock.class, mock);
    HTSOSS_hts_terminals_asynch termToReplace = new HTSOSS_hts_terminals_asynch();
    termToReplace.coremodule_id = 3451;
    termToReplace.mgmtipaddress = '10.242.1.38';
    termToReplace.template_id = 'CONUS_STANDARD';
    termToReplace.terminal_ip_address = '10.64.83.0/24';
    termToReplace.terminal_id = '13728772';
    termToReplace.terminaltype_id = 1828;
    test.startTest();
    HTSOSS_hts_terminals_replace returnedObj = Service_HTSRegions.enqueueReplaceJob(termToReplace);
    serviceResults returnedLog = Service_HTSRegions.getLog();
    test.stopTest();
    system.assertEquals(false, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('FATAL_ERROR\tOSS returned: 2 Terminals'), returnedLog.message);
  }
  /*******************************************
  * Main Method #1 tests                     *
  *******************************************/
  static testMethod void test_QoSupdates(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //setup mock responses for the method: readSubs.addAll(readSubsFromOSS(vtid + '-00'));
    mock.addResponse(getMock_subscribersList_emptyList());
    //setup mock responses for the method: readSubs.addAll(readSubsFromOSS(vtid + '-01'));
    mock.addResponse(getMock_subscribersList_OK());
    //setup mock responses for the method: readSubs.addAll(readSubsFromOSS(vtid + '-02'));
    mock.addResponse(getMock_subscribersList_OK());
    //setup mock responses for the method: updateShapingPolicy(sub);
    mock.addResponse(getMock_noBody(204));
    //setup mock responses for the method: updateShapingPolicy(sub);
    mock.addResponse(getMock_noBody(204));
    Test.setMock(HttpCalloutMock.class, mock);

    list<String> inputVTIDs = new list<String>();
    inputVTIDs.add('12345678');
    test.startTest();
    Service_HTSRegions.QoSupdates(inputVTIDs);
    serviceResults returnedLog = Service_HTSRegions.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success);
    system.assert(returnedLog.message.contains('SUCCESS: HTS QOS Updates Service completed successfully!'));
  }
  static testMethod void test_QoSupdates_emptyList(){
    list<String> inputVTIDs = new list<String>();
    test.startTest();
    Service_HTSRegions.QoSupdates(inputVTIDs);
    serviceResults returnedLog = Service_HTSRegions.getLog();
    test.stopTest();
    system.assertEquals(false, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('ERROR: HTS Regions Service failed to complete successfully. See log for details.'), returnedLog.message);
  }
  /*******************************************
  * Main Method #2 tests                     *
  *******************************************/
  static testMethod void test_updateTerminal(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //setup mock responses for the method: getTerminalDetails(vtid);
    mock.addResponse(getMock_terminalListOf1());
    mock.addResponse(getMock_terminalParams());
    //setup mock responses for the method: enqueueReplaceJob(termToReplaceAsync);
    mock.addResponse(getMock_replace202());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    serviceResults returnedLog = Service_HTSRegions.updateTerminal(
                                    '12345678',
                                    '10.83.83.0/24',
                                    'CONUS_STANDARD',
                                    1828);
    test.stopTest();
    system.assertEquals(true, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('a75ac3d8-436f-44cb-9628-9829d5ac0dd6'), returnedLog);
  }


  /**********************************************************
   * setup methods for commonly used HTTP mock responses....*
   **********************************************************/
  static HttpResponse getMock_subscribersList_OK(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    string response = '';
    response += '[';
    response += '{ "obj_id": "00000000-0000-0001-0000-000000000002", "status": "Active", "subscriber_id": "12345678-00", "subscriber_plan_id": "PLAN_2" }';
    response += ']';
    returnMock.setBody(response);
    return returnMock;
  }
  static HttpResponse getMock_subscribersList_emptyList(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    string response = '';
    response += '[';
    //response += '{ "obj_id": "00000000-0000-0001-0000-000000000002", "status": "Active", "subscriber_id": "12345678-00", "subscriber_plan_id": "PLAN_2" }';
    response += ']';
    returnMock.setBody(response);
    return returnMock;
  }
  static HttpResponse getMock_subscribersList_duplicates(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    string response = '';
    response += '[';
    response += '{ "obj_id": "00000000-0000-0001-0000-000000000002", "status": "Active", "subscriber_id": "12345678-00", "subscriber_plan_id": "PLAN_2" },';
    response += '{ "obj_id": "00000000-0000-0001-0000-000000000002", "status": "Active", "subscriber_id": "12345678-00", "subscriber_plan_id": "PLAN_2" }';
    response += ']';
    returnMock.setBody(response);
    return returnMock;
  }
  static HttpResponse getMock_noBody(Integer responseCode){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(responseCode);
    return returnMock;
  }
  static HttpResponse getMock_subscribersPUT_404(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(404);
    string response = '';
    response += '[';
    response += '{ "message": "The specified subscriber does not exist." }';
    response += ']';
    returnMock.setBody(response);
    return returnMock;
  }
  static HttpResponse getMock_subscribersPUT_500(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(500);
    string response = '';
    response += '[';
    response += '{ "message": "Some bad stuff happened!" }';
    response += ']';
    returnMock.setBody(response);
    return returnMock;
  }
  static HttpResponse getMock_terminalListOf1(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    returnMock.setBody( '[{"activate": false,' +
                          '"obj_id": 2046,' +
                          '"terminal_id": "13728772",' +
                          '"coremodule_id": 3541,' +
                          '"obj_revision": 3}]');
    return returnMock;
  }
  static HttpResponse getMock_terminalListOf2(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    returnMock.setBody( '[{"activate": false,' +
                          '"obj_id": 2046,' +
                          '"terminal_id": "13728772",' +
                          '"coremodule_id": 3541,' +
                          '"obj_revision": 3},' +
                          '{"activate": false,' +
                          '"obj_id": 2047,' +
                          '"terminal_id": "13728773",' +
                          '"coremodule_id": 3542,' +
                          '"obj_revision": 3}]');
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
  static HttpResponse getMock_terminal404(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(404);
    String bodyString = '{"message": "404 Client Error: Not Found for url: https://192.168.224.12/api/1.0/config/element/terminal/2046. ' +
                    'You have requested this URI [/api/1.0/hts/terminals/2046]' + 
                    ' but did you mean /api/1.0/hts/terminals/<int:id> or ' +
                    '/api/1.0/hts/terminals/diff/<int:obj_id1>/<int:obj_id2> or '+
                    '/api/1.0/hts/terminals/async ?", ' +
                    '"remote_message": "{\"errors\":[{\"source\":\"\",\"errors\":[],\"severity\":0,\"silent\":0,\"code\":404,\"message\":\"Requested resource is not found\"}]}"}';
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
  static HttpResponse getMock_replace202_multi(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(202);
    String bodyString = '[{"obj_id": "a75ac3d8-436f-44cb-9628-9829d5ac0dd6",' +
                          '"terminal_id": "18395443"},' + 
                          '{"obj_id": "a75ac3d8-436f-44cb-9628-9829d5ac0dd7",' +
                          '"terminal_id": "18395444"}]';
    returnMock.setBody(bodyString);
    return returnMock;
  }
  static HttpResponse getMock_replace500(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(500);
    String bodyString = '[{"message": "Something Bad Happened",' +
                          '"terminal_id": "18395443"}]';
    returnMock.setBody(bodyString);
    return returnMock;
  }
}