@isTest
private class HTS_ltgsvc_rebuildTerminal_test {
//setup testClass variables here. For example:
//RecordType Ids
/*private static final Id Customer_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();*/
//A common Loop Counter for bulikification purposes
/*private static final integer MAX_LOOP_COUNTER = 200;*/
  
  @testSetup static void setupTestData(){
    //Going to need an HTS Asset Hierarchy that includes a VTID, and IP Address.
    //Of course we need an Account to hang the Assets off of...
    Account testAccount = new Account(Name = 'Test Account');
    insert testAccount;
    list<Asset> testAssets = new list<Asset>();
    //Need a root Asset
    Default_Identifier_Product__mdt I2CMProd = [SELECT Identifier_Product_reference__c, Legacy_Product_Id__c
                                                    FROM Default_Identifier_Product__mdt 
                                                    WHERE DeveloperName =: 'X02_2204_02'];

    Asset i2cm = new Asset(Name = 'test root', AccountId = testAccount.Id, Product2Id = I2CMProd.Identifier_Product_reference__c);
    insert i2cm;
    //Need a Product2 reference for the Asset. Get it from the Custom Metadata Type
    Default_Identifier_Product__mdt VTIDproduct = [SELECT Identifier_Product_reference__c, Legacy_Product_Id__c
                                                    FROM Default_Identifier_Product__mdt 
                                                    WHERE DeveloperName =: 'Virtual_Terminal_Id'];
    Asset vtid = new Asset(Name = '12345678', Parent_Asset__c = i2cm.Id, AccountId = testAccount.Id, Product2Id = VTIDproduct.Identifier_Product_reference__c);
    testAssets.add(vtid);
    Default_Identifier_Product__mdt HTSipProd = [SELECT Identifier_Product_reference__c, Legacy_Product_Id__c
                                                    FROM Default_Identifier_Product__mdt 
                                                    WHERE DeveloperName =: 'HTS_IP_Address'];
    
    Asset hts_ip = new Asset(Name = '10.64.1.0', Parent_Asset__c = i2cm.Id, AccountId = testAccount.Id, Product2Id = HTSipProd.Identifier_Product_reference__c);
    testAssets.add(hts_ip);

    insert testAssets;
    //setup common test data here
  }
  
  static testMethod void testSetupData(){
    //use this method to validate that you have test data setup correctly
    //this will protect you from changes to workflow, process, and validation that break your test code!
    list<Asset> readAssets = [SELECT Id, Name FROM Asset];
    system.assertEquals(3, readAssets.size());
  }
  static testMethod void test_verifyAssetType(){
    //Need the record Id of the Asset to verify... the VTID in this case
    list<Asset> readAssets = [SELECT Id, Name, Product2Id FROM Asset WHERE Name = '12345678'];
    System.assertEquals(1, readAssets.size());
    System.debug(readAssets);
    HTS_ltgsvc_rebuildTerminal returnObj = HTS_ltgsvc_rebuildTerminal.verifyAssetType(readAssets[0].Id);
    System.assertEquals('SUCCESS: Virtual Terminal Id verified', returnObj.statusMessage);
    readAssets.clear();
    readAssets = [SELECT Id, Name, Product2Id FROM Asset WHERE Name = '10.64.1.0'];
    System.assertEquals(1, readAssets.size());
    System.debug(readAssets);
    returnObj = HTS_ltgsvc_rebuildTerminal.verifyAssetType(readAssets[0].Id);
    System.assertEquals('ERROR: This is not a Virtual Terminal Id', returnObj.statusMessage);
  }
  
  static testMethod void test_getTerminalFromOSS(){
    //need one mock response.... a GET terminals[]
    QueueHttpMock mock = new QueueHttpMock();
    HttpResponse res1 = new HttpResponse();
    res1.setStatusCode(200);
    res1.setBody('[{"activate": true,"is_active": true,"obj_id": 5529,"obj_revision": 2,"terminal_id": "12345678"}]');
    mock.addResponse(res1);
    Test.setMock(HttpCalloutMock.class, mock);
    Test.startTest();
    HTS_ltgsvc_rebuildTerminal returnObj = HTS_ltgsvc_rebuildTerminal.getTerminalFromOSS('12345678');
    System.debug(returnObj);
    //TODO Assert
    System.assertEquals(5529, returnObj.term.obj_id);
    System.assertEquals(2, returnObj.term.obj_revision);
    Test.stopTest();
  }

  static testMethod void test_rebuildTerminalInOSS_old(){
    //Need a few responses...
    //First GET terminal{id} returns 200 and a {Terminal...}
    //Second PUT is_active to false returns 204 no content
    //Third DELETE returns 204 no content
    //Fourth POST returns 201 no content
    QueueHttpMock mock = new QueueHttpMock();
    HttpResponse res1 = new HttpResponse();
    res1.setStatusCode(200);
    string responseBody = '{';    //this is a minimalist approach. Many more (unused) attributes.
    responseBody = responseBody + '"coremodule_id": 3541,';
    responseBody = responseBody + '"mgmtipaddress": "10.243.0.1",';
    responseBody = responseBody + '"template_id": "CONUS_STANDARD",';
    responseBody = responseBody + '"terminal_id": "98763456",';
    responseBody = responseBody + '"terminal_service_ip": "10.64.31.1",'; //Different attributes between POST and GET{id}...
    responseBody = responseBody + '"terminaltype_id": 1828,';
    responseBody = responseBody + '"obj_id": 5450,';
    responseBody = responseBody + '"obj_revision": 2';
    responseBody = responseBody + '}';
    res1.setBody(responseBody);
    
    HttpResponse res2 = new HttpResponse();
    res2.setStatusCode(204);

    HttpResponse res3 = new HttpResponse();
    res3.setStatusCode(204);

    HttpResponse res4 = new HttpResponse();
    res4.setStatusCode(201);

    mock.addResponse(res1);
    mock.addResponse(res2);
    mock.addResponse(res3);
    mock.addResponse(res4);

    Test.setMock(HttpCalloutMock.class, mock);
    //setup input map...
    map<String, Decimal> inputMap = new map<String, Decimal>();
    inputMap.put('obj_id', 5450);
    inputMap.put('obj_revision', 2);
    Test.startTest();
    HTS_ltgsvc_rebuildTerminal returnObj = HTS_ltgsvc_rebuildTerminal.rebuildTerminalInOSS_old(inputMap);
    System.debug(returnObj);
    System.assertEquals(5450, returnObj.term.obj_id);
    System.assertEquals(2, returnObj.term.obj_revision);
    Test.stopTest();
  }
  static testMethod void test_rebuildTerminalInOSS(){
    //Need a few responses...
    QueueHttpMock mock = new QueueHttpMock();
    
    //First GET terminal{id} returns 200 and a {Terminal...}
    //terminal = help.getTerminalDetails(terminal);
    HttpResponse res1 = new HttpResponse();
    res1.setStatusCode(200);
    string responseBody = '{';    //this is a minimalist approach. Many more (unused) attributes.
    responseBody = responseBody + '"coremodule_id": 3541,';
    responseBody = responseBody + '"mgmtipaddress": "10.243.0.1",';
    responseBody = responseBody + '"template_id": "CONUS_STANDARD",';
    responseBody = responseBody + '"terminal_id": "98763456",';
    responseBody = responseBody + '"terminal_service_ip": "10.64.31.1",'; //Different attributes between POST and GET{id}...
    responseBody = responseBody + '"terminaltype_id": 1828,';
    responseBody = responseBody + '"obj_id": 5450,';
    responseBody = responseBody + '"obj_revision": 2';
    responseBody = responseBody + '}';
    res1.setBody(responseBody);

    //Second POST to replace endpoint returns 202 and job ID
    //termRepl = termRepl.postTerminalsToReplace(termRepl);
    HttpResponse res2 = new HttpResponse();
    res2.setStatusCode(202);
    res2.setBody('[{"obj_id": "65fda444-84fc-43cf-be80-c2987dc31b2e"}]');

    mock.addResponse(res1);
    mock.addResponse(res2);

    Test.setMock(HttpCalloutMock.class, mock);
    //setup input map...
    map<String, Decimal> inputMap = new map<String, Decimal>();
    inputMap.put('obj_id', 5450);
    inputMap.put('obj_revision', 2);
    test.startTest();
    HTS_ltgsvc_rebuildTerminal returnObj = HTS_ltgsvc_rebuildTerminal.rebuildTerminalInOSS(inputMap);
    test.stopTest();
    system.assertEquals('SUCCESS:', returnObj.statusMessage.left(8));
  }
  static testMethod void test_rebuildTerminalInOSS_multi(){
    //Need a few responses...
    QueueHttpMock mock = new QueueHttpMock();
    
    //First GET terminal{id} returns 200 and a {Terminal...}
    //terminal = help.getTerminalDetails(terminal);
    HttpResponse res1 = new HttpResponse();
    res1.setStatusCode(200);
    string responseBody = '{';    //this is a minimalist approach. Many more (unused) attributes.
    responseBody = responseBody + '"coremodule_id": 3541,';
    responseBody = responseBody + '"mgmtipaddress": "10.243.0.1",';
    responseBody = responseBody + '"template_id": "CONUS_STANDARD",';
    responseBody = responseBody + '"terminal_id": "98763456",';
    responseBody = responseBody + '"terminal_service_ip": "10.64.31.1",'; //Different attributes between POST and GET{id}...
    responseBody = responseBody + '"terminaltype_id": 1828,';
    responseBody = responseBody + '"obj_id": 5450,';
    responseBody = responseBody + '"obj_revision": 2';
    responseBody = responseBody + '}';
    res1.setBody(responseBody);

    //Second POST to replace endpoint returns 202 and job ID
    //termRepl = termRepl.postTerminalsToReplace(termRepl);
    HttpResponse res2 = new HttpResponse();
    res2.setStatusCode(202);
    res2.setBody('[{"obj_id": "65fda444-84fc-43cf-be80-c2987dc31b2e"},{"obj_id": "65fda444-84fc-43cf-be80-c2987dc31b2f"}]');

    mock.addResponse(res1);
    mock.addResponse(res2);

    Test.setMock(HttpCalloutMock.class, mock);
    //setup input map...
    map<String, Decimal> inputMap = new map<String, Decimal>();
    inputMap.put('obj_id', 5450);
    inputMap.put('obj_revision', 2);
    test.startTest();
    HTS_ltgsvc_rebuildTerminal returnObj = HTS_ltgsvc_rebuildTerminal.rebuildTerminalInOSS(inputMap);
    test.stopTest();
    system.assertEquals('SUCCESS:', returnObj.statusMessage.left(8));
  }
  static testMethod void test_getTerminalDetails(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_mocks.mock_terminals_GET_by_id());
    HTSOSS_hts_terminals inputTerm = new HTSOSS_hts_terminals();
    inputTerm.obj_id = 3605; //per mock resource....
    
    HTS_ltgsvc_rebuildTerminal.Helpers help = new HTS_ltgsvc_rebuildTerminal.Helpers();

    HTSOSS_hts_terminals outputTerm = help.getTerminalDetails(inputTerm);

    System.assertEquals(200, outputTerm.response_code);
    System.assertEquals('10.243.0.1', outputTerm.mgmtipaddress);
    System.assertEquals(3605, outputTerm.obj_id);
    System.assertEquals(2, outputTerm.obj_revision);
    test.stopTest();
  }


  static testMethod void test_putTerminalInActive(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_mocks.mock_terminals_NO_BODY(204));
    HTSOSS_hts_terminals term1 = new HTSOSS_hts_terminals();
    
    term1.obj_id = 12345;
    term1.is_active = false;
    term1.obj_revision = 2;
    HTS_ltgsvc_rebuildTerminal.Helpers help = new HTS_ltgsvc_rebuildTerminal.Helpers();
    HTSOSS_hts_terminals responseTerm = help.putTerminalInActive(term1);          //Does not return a body doc, just a response code
    System.assertEquals(204, responseTerm.response_code);                  //We got a 204 (per mock)

    test.stopTest();
  }
  static testMethod void test_deleteTerminal(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_mocks.mock_terminals_NO_BODY(204)); 
    HTSOSS_hts_terminals term1 = new HTSOSS_hts_terminals();
    HTS_ltgsvc_rebuildTerminal.Helpers help = new HTS_ltgsvc_rebuildTerminal.Helpers();
    term1.obj_id = 12345;
    
    HTSOSS_hts_terminals responseTerm = help.deleteTerminal(term1);          //Does not return a body doc, just a response code
    System.assertEquals(204, responseTerm.response_code);                  //We got a 204 (per mock)
    test.stopTest();
  }
  static testMethod void test_postTerminal(){
    test.startTest();
    test.setMock(HttpCalloutMock.class, new HTSOSS_hts_terminals_mocks.mock_terminals_POST_OK());
    HTSOSS_hts_terminals term1 = new HTSOSS_hts_terminals();
    
    term1.coremodule_id = 1234;
    term1.mgmtipaddress = '10.242.1.14';
    term1.template_id = 'TEMPLATE_1';
    term1.terminal_ip_address = '10.64.14.0/24';
    term1.terminal_id = '12345678';
    term1.terminaltype_id = 1828;
    HTS_ltgsvc_rebuildTerminal.Helpers help = new HTS_ltgsvc_rebuildTerminal.Helpers();

    HTSOSS_hts_terminals responseTerm = help.postTerminal(term1);
    
    system.assertEquals(201, responseTerm.response_code);                  //We got a 201 (per mock)
    test.stopTest();
  }
  
}