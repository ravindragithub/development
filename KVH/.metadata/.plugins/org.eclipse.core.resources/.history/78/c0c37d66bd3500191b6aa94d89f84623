@isTest
private class LTEOSS_lte_organizations_test {
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

  static testMethod void test_getLTEOrganizations_OK(){
    //Need mock response from /lte/organizations/
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_getLTEOrganizations_OK());
    Test.setMock(HttpCalloutMock.class, mock);
    LTEOSS_lte_organizations.Organizations_list_wrapper orgsList 
      = new LTEOSS_lte_organizations.Organizations_list_wrapper();
    test.startTest();
    orgsList = LTEOSS_lte_organizations.getLTEOrganizations();
    test.stopTest();
    system.assertEquals(200, orgsList.response_code);
    system.assertEquals(1, orgsList.orgs.size());
    system.assertEquals('defaul', orgsList.orgs[0].id);
    system.assertEquals('kvh-industries', orgsList.orgs[0].name);
    system.assertEquals(true, orgsList.orgs[0].primary);
    system.assertEquals('active', orgsList.orgs[0].status);
  }
  static testMethod void test_getLTEOrganizations_500(){
    //Need mock response from /lte/organizations/
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_error_500());
    Test.setMock(HttpCalloutMock.class, mock);
    LTEOSS_lte_organizations.Organizations_list_wrapper orgsList 
      = new LTEOSS_lte_organizations.Organizations_list_wrapper();
    test.startTest();
    orgsList = LTEOSS_lte_organizations.getLTEOrganizations();
    test.stopTest();
    system.assertEquals(500, orgsList.response_code);
    system.assertEquals(0, orgsList.orgs.size());
    system.assertEquals('this is a mock error message', orgsList.message);
  }
  static testMethod void test_getGroupByOrgId_OK(){
    //Need mock response from /lte/organizations/{org_id}/groups
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_getGroupByOrgId_OK());
    Test.setMock(HttpCalloutMock.class, mock);
    LTEOSS_lte_organizations.Groups_list_wrapper groupsList 
      = new LTEOSS_lte_organizations.Groups_list_wrapper();
    test.startTest();
    groupsList = LTEOSS_lte_organizations.getGroupByOrgId('defaul');
    test.stopTest();
    system.assertEquals(200, groupsList.response_code);
    system.assertEquals(2, groupsList.groups.size());
    for(LTEOSS_lte_organizations.Groups g : groupsList.groups){
      system.assert(g.Id > 89 && g.id < 92);
      system.assertEquals(14, g.name.length());
    }
  }
  static testMethod void test_getGroupByOrgId_OK2(){
    //Need mock response from /lte/organizations/{org_id}/groups
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_getGroupByOrgId_FILTERED_OK());
    Test.setMock(HttpCalloutMock.class, mock);
    LTEOSS_lte_organizations.Groups_list_wrapper groupsList 
      = new LTEOSS_lte_organizations.Groups_list_wrapper();
    test.startTest();
    groupsList = LTEOSS_lte_organizations.getGroupByOrgId('defaul', '2933-BAD9-E505');
    test.stopTest();
    system.assertEquals(200, groupsList.response_code);
    system.assertEquals(1, groupsList.groups.size());
    system.assertEquals(131, groupsList.groups[0].Id);
    system.assertEquals(14, groupsList.groups[0].name.length());
  }
  static testMethod void test_getGroupByOrgId_500(){
    //Need mock response from /lte/organizations/{org_id}/groups
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_error_500());
    Test.setMock(HttpCalloutMock.class, mock);
    LTEOSS_lte_organizations.Groups_list_wrapper groupsList 
      = new LTEOSS_lte_organizations.Groups_list_wrapper();
    test.startTest();
    groupsList = LTEOSS_lte_organizations.getGroupByOrgId('defaul');
    test.stopTest();
    system.assertEquals(500, groupsList.response_code);
    system.assertEquals(0, groupsList.groups.size());
    system.assertEquals('this is a mock error message', groupsList.message);
  }
  static testMethod void test_postToImportDevices_OK(){
    //Need mock response from POST /lte/organizations/importdevices
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_postToImportDevices_OK_SINGLE());
    Test.setMock(HttpCalloutMock.class, mock);
    LTEOSS_lte_organizations.ImportedDeviceWrapper returnedWrapper
      = new LTEOSS_lte_organizations.ImportedDeviceWrapper();
    test.startTest();
    returnedWrapper = LTEOSS_lte_organizations.postToImportDevices('2934-B1AE-EE0E');
    test.stopTest();
    system.assertEquals(201, returnedWrapper.response_code);
    system.assertEquals(1, returnedWrapper.imported_devices.size());
    system.assertEquals('2934-B1AE-EE0E', returnedWrapper.imported_devices[0].sn);
    system.assertEquals(160, returnedWrapper.imported_devices[0].group_id);
  }
  static testMethod void test_postToImportDevices_FAIL(){
    //Need mock response from POST /lte/organizations/importdevices
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_postToImportDevices_500_SINGLE());
    Test.setMock(HttpCalloutMock.class, mock);
    LTEOSS_lte_organizations.ImportedDeviceWrapper returnedWrapper
      = new LTEOSS_lte_organizations.ImportedDeviceWrapper();
    test.startTest();
    returnedWrapper = LTEOSS_lte_organizations.postToImportDevices('2934-B1AE-EE0E');
    test.stopTest();
    system.assertEquals(500, returnedWrapper.response_code);
    system.assertEquals(0, returnedWrapper.imported_devices.size());
    system.assert(returnedWrapper.message.contains('failed lookup'));
  }
  //setup methods for commonly used HTTP mock responses....
  static HttpResponse getMock_getLTEOrganizations_OK(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    returnMock.setBody('[{'+
                            '"id": "defaul",' +
                            '"name": "kvh-industries",' +
                            '"primary": true,' +
                            '"status": "active"' +
                          '}]');
    return returnMock;
  }
  static HttpResponse getMock_error_500(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(500);
    returnMock.setBody('{"message": "this is a mock error message"}');
    return returnMock;
  }
  static HttpResponse getMock_getGroupByOrgId_OK(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    returnMock.setBody('[{"id": 90,"name": "2935-0A29-CC61"},' +
                       '{"id": 91,"name": "2934-B1B5-FFB4"}]');
    return returnMock;
  }
  static HttpResponse getMock_getGroupByOrgId_FILTERED_OK(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    returnMock.setBody('[{"id": 131,"name": "2933-BAD9-E505"}]');
    return returnMock;
  }
  static HttpResponse getMock_postToImportDevices_OK_SINGLE(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(201);
    returnMock.setBody('{"imported_devices": [' +
                            '{"group_id": 160,' +
                            '"sn": "2934-B1AE-EE0E"} ' +
                           ']}');
    return returnMock;
  }
  static HttpResponse getMock_postToImportDevices_500_SINGLE(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(500);
    returnMock.setBody('{"message": ' +
    '"The following serial numbers ([\'1234-5678-3210\']) failed lookup."}');
    return returnMock;
  }
}