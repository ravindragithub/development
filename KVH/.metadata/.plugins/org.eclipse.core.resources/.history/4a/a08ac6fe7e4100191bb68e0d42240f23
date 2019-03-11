@isTest
private class HTS_ltgsvc_termStatus_test {
  static string VTIDstring = '87654321';
  
  @testSetup static void setupTestData(){
    //setup common test data here
    //We need to setup the Custom Setting here... 
    string orgId = UserInfo.getOrganizationId();// This sets up the Current Org as the "Production" Org regardless of instance....
    Production_Org_Ids__c mySetting = Production_Org_Ids__c.getOrgDefaults();
    mySetting.Org_Id_18_char__c = orgId;
    mySetting.Org_Id_15_char__c = orgId.left(15);
    upsert mySetting;
    
    Account insertAccount = new Account(name = 'test Account');
    insert insertAccount;
    Asset insertAsset = new Asset();
    insertAsset.Name = VTIDstring;
    insertAsset.AccountId = insertAccount.Id;
    insert insertAsset;
    
    HTS_Virtual_Terminal_ID__c insertVTID = new HTS_Virtual_Terminal_ID__c();
    insertVTID.Virtual_Terminal_Id__c = VTIDstring;
    insert insertVTID;
  }
  
  static testMethod void testSetupData(){
    //use this method to validate that you have test data setup correctly
    //This just verifies that the Current Org Id (Production or Sandbox) got setup in the Custom Setting as the Production Org Id....
    //Effectively causing the testClass to behave as if it is running in Production.
    string orgId = UserInfo.getOrganizationId();
    Production_Org_Ids__c mySetting = Production_Org_Ids__c.getOrgDefaults();
    system.assertEquals(orgId, mySetting.Org_Id_18_char__c);
    
    list<Asset> readAssets = [SELECT Id, Name FROM Asset];
    system.assertEquals(1,readAssets.size());
    system.assertEquals(VTIDstring,readAssets[0].Name);
    
    list<HTS_Virtual_Terminal_Id__c> readVTIDs = [SELECT Virtual_Terminal_Id__c FROM HTS_Virtual_Terminal_Id__c];
    system.assertEquals(1,readVTIDs.size());
    system.assertEquals(VTIDstring,readVTIDs[0].Virtual_Terminal_Id__c);
  }

  static testMethod void test_getTerminalFromOSS_OK() {
    // Use MultiStaticResourceCalloutMock to
    // specify fake response for a certain endpoint and 
    // include response body in a static resource.    
    MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
    multimock.setStaticResource('callout:HTSOSS/hts/terminals/?terminal_id=' + VTIDstring, 'HTS_GET_terminal_response_filtered_MOCK');
    multimock.setStatusCode(200);
    multimock.setHeader('Content-Type', 'application/json');
    // Set the mock callout mode
    Test.setMock(HttpCalloutMock.class, multimock);
    test.startTest();
    HTS_ltgsvc_termStatus.Helpers util = new HTS_ltgsvc_termStatus.Helpers();
    map<string,string> resultsMap = util.getTerminalFromOSS(VTIDstring);
    system.assertEquals('3373', resultsMap.get('obj_id'));
    system.assertEquals('6', resultsMap.get('obj_revision'));
    test.stopTest();
  }
  static testMethod void test_getTerminalFromOSS_MULTI() {
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //Simulate unexpected TWO terminals returned! VERY unexpected!
    mock.addResponse(getMock_terminalsList_OK_Multi());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    HTS_ltgsvc_termStatus.Helpers util = new HTS_ltgsvc_termStatus.Helpers();
    map<string,string> resultsMap = util.getTerminalFromOSS(VTIDstring);
    system.assertEquals('ERROR:Multiple Terminals found. This is bad', resultsMap.get('obj_id'));
    system.assertEquals('ERROR:Multiple Terminals found. This is bad', resultsMap.get('obj_revision'));
    system.assertEquals('ERROR:Multiple Terminals found. This is bad', resultsMap.get('configTemplate'));
    test.stopTest();
  }
  static testMethod void test_getAssetIdFromSFDC(){
    list<Asset> readAssets = [SELECT Id, Name FROM Asset];
    test.startTest();
    HTS_ltgsvc_termStatus.Helpers util = new HTS_ltgsvc_termStatus.Helpers();
    map<string,string> resultsMap = util.getAssetIdFromSFDC(VTIDstring);
    system.debug('test_getAssetIdFromSFDC : ' + resultsMap);
    system.assertEquals(readAssets[0].Id, resultsMap.get('asset_id'));
    test.stopTest();
  }
  static testMethod void test_getVTIDidFromSFDC(){
    list<HTS_Virtual_Terminal_Id__c> readVTIDs = [SELECT Id, Virtual_Terminal_Id__c FROM HTS_Virtual_Terminal_Id__c];
    system.debug(readVTIDs);
    test.startTest();
    HTS_ltgsvc_termStatus.Helpers util = new HTS_ltgsvc_termStatus.Helpers();
    map<string,string> resultsMap = util.getVTIDidFromSFDC(VTIDstring);
    system.debug('test_getVTIDidFromSFDC : ' + resultsMap);
    system.assertEquals(readVTIDs[0].Id, resultsMap.get('VTID_id'));
    test.stopTest();
  }
  static testMethod void test_lookupVTID(){
    // Use MultiStaticResourceCalloutMock to
    // specify fake response for a certain endpoint and 
    // include response body in a static resource.    
    MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
    multimock.setStaticResource('callout:HTSOSS/hts/terminals/?terminal_id=' + VTIDstring, 'HTS_GET_terminal_response_filtered_MOCK');
    multimock.setStatusCode(200);
    multimock.setHeader('Content-Type', 'application/json');
    // Set the mock callout mode
    Test.setMock(HttpCalloutMock.class, multimock);
    //Delete the VTID and Asset record (to cover the no record returned thing...)
    list<HTS_Virtual_Terminal_Id__c> readVTIDs = [SELECT Id, Virtual_Terminal_Id__c FROM HTS_Virtual_Terminal_Id__c];
    delete readVTIDs;
    list<Asset> readAssets = [SELECT Id, Name FROM Asset];
    delete readAssets;
    test.startTest();
    map<string,string> resultsMap = HTS_ltgsvc_termStatus.lookupVTID(VTIDstring);
    system.assertEquals('3373',resultsMap.get('obj_id'));
    system.assertEquals('6',resultsMap.get('obj_revision'));
    system.assertEquals('ERROR:',resultsMap.get('asset_id').left(6));
    system.assertEquals('ERROR:',resultsMap.get('VTID_id').left(6));
    test.stopTest();
  }
  static testMethod void test_lookupVTID_fail(){
    // Use MultiStaticResourceCalloutMock to
    // specify fake response for a certain endpoint and 
    // include response body in a static resource.    
    MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
    multimock.setStaticResource('callout:HTSOSS/hts/terminals/?terminal_id=' + VTIDstring, 'HTS_GET_terminal_response_empty_MOCK');
    multimock.setStatusCode(200);
    multimock.setHeader('Content-Type', 'application/json');
    // Set the mock callout mode
    Test.setMock(HttpCalloutMock.class, multimock);
    //Delete the VTID and Asset record (to cover the no record returned thing...)
    list<HTS_Virtual_Terminal_Id__c> readVTIDs = [SELECT Id, Virtual_Terminal_Id__c FROM HTS_Virtual_Terminal_Id__c];
    list<Asset> readAssets = [SELECT Id, Name FROM Asset];
    test.startTest();
    map<string,string> resultsMap = HTS_ltgsvc_termStatus.lookupVTID(VTIDstring);
    system.assertEquals('ERROR:',resultsMap.get('obj_id').left(6));
    system.assertEquals('ERROR:',resultsMap.get('obj_revision').left(6));
    system.assertEquals(readAssets[0].id,resultsMap.get('asset_id'));
    system.assertEquals(readVTIDs[0].id,resultsMap.get('VTID_id'));
    test.stopTest();
  }
  static testMethod void test_getStatusbyID_OK(){
    // Use MultiStaticResourceCalloutMock to
    // specify fake response for a certain endpoint and 
    // include response body in a static resource.    
    MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
    multimock.setStaticResource('callout:HTSOSS/hts/terminals/3605/status' , 'HTS_GET_terminals_status_MOCK');
    multimock.setStatusCode(200);
    multimock.setHeader('Content-Type', 'application/json');
    // Set the mock callout mode
    Test.setMock(HttpCalloutMock.class, multimock);
    test.startTest();
    HTSOSS_hts_terminals_status mockResponse = HTS_ltgsvc_termStatus.getStatusbyId('3605');
    system.assertEquals(200, mockResponse.response_code);
    system.assertEquals('Terminal Status returned from HTSOSS', mockResponse.message);
    test.stopTest();
  }
   static testMethod void test_getStatusbyID_FAIL(){
    // Use MultiStaticResourceCalloutMock to
    // specify fake response for a certain endpoint and 
    // include response body in a static resource.    
    MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
    multimock.setStaticResource('callout:HTSOSS/hts/terminals/3606/status' , 'HTS_GET_terminals_status_MOCK');
    multimock.setStatusCode(404);
    multimock.setHeader('Content-Type', 'application/json');
    // Set the mock callout mode
    Test.setMock(HttpCalloutMock.class, multimock);
    test.startTest();
    HTSOSS_hts_terminals_status mockResponse = HTS_ltgsvc_termStatus.getStatusbyId('3606');
    system.assertEquals(404, mockResponse.response_code);
    system.assertEquals('Terminal Status not found...', mockResponse.message);
    test.stopTest();
  }
  static testMethod void test_getSubscriberFromOSS(){
    //Tests normal execution flow
    //Need mock response from hts/subscribers
    QueueHttpMock mock = new QueueHttpMock();
    HttpResponse res1 = new HttpResponse();
    res1.setStatusCode(404);
    res1.setBody('{"message": "The specified subscriber does not exist. You have requested this URI [/api/1.0/hts/subscribers/] but did you mean /api/1.0/hts/subscribers/<string:id>"}');
    
    HttpResponse res2 = new HttpResponse();
    res2.setStatusCode(200);
    res2.setBody('[{"obj_id": "00000000-0000-0001-0000-0000000000ce","subscriber_id": "12345678-01"}]');
    
    HttpResponse res3 = new HttpResponse();
    res3.setStatusCode(200);
    res3.setBody('{"obj_id": "00000000-0000-0001-0000-0000000000ce","status":"Active","subscriber_id": "12345678-01","subscriber_ip_addresses":["10.64.16.0/24"],"subscriber_plan_id": "OP2K"}');
    
    HttpResponse res4 = new HttpResponse();
    res4.setStatusCode(404);
    res4.setBody('{"message": "The specified subscriber does not exist. You have requested this URI [/api/1.0/hts/subscribers/] but did you mean /api/1.0/hts/subscribers/<string:id>"}');

    mock.addResponse(res1);
    mock.addResponse(res2);
    mock.addResponse(res3);
    mock.addResponse(res4);

    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    //HTS_ltgsvc_termStatus.Helpers util = new HTS_ltgsvc_termStatus.Helpers();
    list<HTSOSS_hts_subscribers> returnedList = HTS_ltgsvc_termStatus.getSubscriberFromOSS('12345678');
    test.stopTest();
    system.assertEquals(1, returnedList.size());
    
  }
  //setup methods for commonly used HTTP mock responses....
  static HttpResponse getMock_terminalsList_OK_Multi(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    string response = '';
    response += '[';
    response += '{"activate": true,"coremodule_id": 7776,"is_active": true,"obj_id": 7864,"obj_revision": 2,"template_id": "CONUS_STANDARD.0001","terminal_id": "77777771"},';
    response += '{"activate": true,"coremodule_id": 7776,"is_active": true,"obj_id": 7864,"obj_revision": 2,"template_id": "CONUS_STANDARD.0001","terminal_id": "77777771"}';
    response += ']';
    returnMock.setBody(response);
    return returnMock;
  }
}