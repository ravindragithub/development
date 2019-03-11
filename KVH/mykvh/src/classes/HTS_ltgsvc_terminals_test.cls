@isTest
private class HTS_ltgsvc_terminals_test {
	static string VTIDstring = '12345678';
	static string SatRouterstring = '77777';
  static string SatRouterstring2 = '77772';

	@testSetup static void setupTestData(){
		//Need that "default Account" custom setting
		Account testAccount = new Account(Name='Default Account');
		insert testAccount;
		DefaultAccounts__c insertSetting = new DefaultAccounts__c();
		//insertSetting.Account_ID__c = '001000000000000000';
		insertSetting.Account_ID__c = testAccount.Id;
		insertSetting.Description__c = 'This is a list of Accounts used for special/default purposes. e.g. Activations in Progress, Default Assets, Replaced Assets....';
		insertSetting.Name = 'DefaultAssets';
		insert insertSetting;
		//Need a buncha  Product Codes 
    list<Product2> testProds = new list<Product2>();
		Product2 satRouterProd = new Product2(Name = 'INTEGRATED ROUTER CX700 I2CM', ProductCode = '19-0955', Product_ID__c='19-0955_US');
    testProds.add(satRouterProd);
    Product2 rootProd = new Product2(Name = 'I2CM', ProductCode = '02-2204-02', Product_ID__c='02-2204-02_US');
    testProds.add(rootProd);
    Product2 macProd = new Product2(Name = 'MTA', ProductCode = '19-0504', Product_ID__c='19-0504_US');
    testProds.add(macProd);
    Product2 child2 = new Product2(Name = 'ADMIN IP', ProductCode = 'ADMIN IP', Product_ID__c='ADMIN IP_US');
    testProds.add(child2);
    Product2 child3 = new Product2(Name = 'CBX LIC', ProductCode = 'CBX LICENSE', Product_ID__c='CBX LICENSE_US');
    testProds.add(child3);
    Product2 htsIpProd = new Product2(Name = 'HTS IP', ProductCode = 'HTS IP Address', Product_ID__c='HTS IP Address_US');
    testProds.add(htsIpProd);
    Product2 vtidProd = new Product2(Name = 'VTID', ProductCode = 'Virtual Terminal ID', Product_ID__c='Virtual Terminal ID_US');
    testProds.add(vtidProd);


		insert testProds;
		//Need an Account for Assets
		Account insertAccount = new Account(name = 'test Account');
		insert insertAccount;
		//Need a Root/Parent Asset
		Asset insertRootAsset = new Asset();
		insertRootAsset.Name = '170300007';
		insertRootAsset.SerialNumber = '170300007';
		insertRootAsset.AccountId = insertAccount.Id;
    insertRootAsset.Product2Id = rootProd.Id;
    insertRootAsset.Asset_Id__c = rootProd.Product_ID__c + '_' + insertRootAsset.Name;
		insert insertRootAsset;
		list<Asset> bulkInsert = new list<Asset>();
		//Need a child VTID asset
		Asset vtidAsset = new Asset();
		vtidAsset.Name = '12345678';
		vtidAsset.SerialNumber = '12345678';
		vtidAsset.AccountId = insertAccount.Id;
		vtidAsset.Parent_Asset__c = insertRootAsset.Id;
    vtidAsset.Product2Id = vtidProd.Id;
    vtidAsset.Asset_Id__c = vtidProd.Product_ID__c + '_' + vtidAsset.Name;
		bulkInsert.add(vtidAsset);
		//Need a SatRouter asset that is in use....
		Asset satRouterAsset = new Asset();
		satRouterAsset.Name = 'KVH-SR-' + SatRouterstring;
		satRouterAsset.SerialNumber = SatRouterstring;
		satRouterAsset.AccountId = insertAccount.Id;
		satRouterAsset.Parent_Asset__c = insertRootAsset.Id;
    satRouterAsset.Product2Id = satRouterProd.Id;
    satRouterAsset.Asset_Id__c = satRouterProd.Product_ID__c + '_' + satRouterAsset.Name;
    bulkInsert.add(satRouterAsset);
    //Need an HTS IP Address...
    Asset HTS_ip = new Asset();
		HTS_ip.Name = '10.83.1.0';
		HTS_ip.SerialNumber = '10.83.1.0';
		HTS_ip.AccountId = insertAccount.Id;
		HTS_ip.Parent_Asset__c = insertRootAsset.Id;
		HTS_ip.Product2Id = htsIpProd.Id;
    HTS_ip.Asset_Id__c = htsIpProd.Product_ID__c + '_' + HTS_ip.Name;
		bulkInsert.add(HTS_ip);
		
    //Need a SatRouter asset that is NOT is use....
    Asset satRouterAsset2 = new Asset();
		satRouterAsset2.Name = 'KVH-SR-' + SatRouterstring2;
		satRouterAsset2.SerialNumber = SatRouterstring2;
		satRouterAsset2.AccountId = insertAccount.Id;
		satRouterAsset2.Product2Id = satRouterProd.Id;
    satRouterAsset2.Asset_Id__c = satRouterProd.Product_ID__c + '_' + satRouterAsset2.Name;
		//satRouterAsset2.Parent_Asset__c = insertRootAsset.Id; NO parent!!
    bulkInsert.add(satRouterAsset2);

    //Need an MTA that is NOT in use
    Asset MTA_asset = new Asset();
    MTA_asset.Name = 'MACAVAILABLE';
		MTA_asset.SerialNumber = 'MACAVAILABLE';
		MTA_asset.AccountId = testAccount.Id;
		//MTA_asset.Parent_Asset__c = insertRootAsset.Id;
		MTA_asset.Product2Id = macProd.Id;
    MTA_asset.Asset_Id__c = macProd.Product_ID__c + '_' + MTA_asset.Name;
    bulkInsert.add(MTA_asset);

    insert bulkInsert;
		//Need VTIDs and HTS IPs... use scripts from HTS IP Addresses project
		//VTIDs
		//Start
		HTS_virtual_terminal_ids util = new HTS_virtual_terminal_ids();
		system.debug('Number Created: ' + util.generateSubscriptionIds(5));
		//Stop
		//HTS IPs (need a seed value)
		HTS_IP_Address__c seedIp = new HTS_IP_Address__c(HTS_IP_Address__c = '10.83.0.0',
														HTS_IP_HEX_Address__c = '0A.53.00.00',
														Management_IP_Address__c = '10.242.20.0');
		insert seedIP;
		//Start
		HTS_ip_addresses util2 = new HTS_ip_addresses();
		system.debug('Number Created: ' + util2.generateIpAddresses(4));
    //Need a default template....
    HTS_Terminal_Template__c insertTemplate = new HTS_Terminal_Template__c(Name='testTemplate', obj_id__c='testTemplate', status__c='Active', isDefault__c=true);
    insert insertTemplate;
		//Stop
	}
	
	static testMethod void testSetupData() {
		//use this method to validate that you have test data setup correctly
		DefaultAccounts__c defAcct =  DefaultAccounts__c.getValues('DefaultAssets');
		Account a = [SELECT Id FROM Account LIMIT 1];
		system.assertEquals(a.id, defAcct.Account_ID__c);
		list<Asset> readAssets = [SELECT Id, SerialNumber, Name FROM Asset];
    system.assertEquals(6,readAssets.size());
    //system.assertEquals(VTIDstring,readAssets[0].SerialNumber);
		list<HTS_Virtual_Terminal_ID__c> vtidList = [SELECT Id, Virtual_Terminal_Id__c FROM HTS_Virtual_Terminal_ID__c ];
		system.assertEquals(5, vtidList.size());
		list<HTS_IP_Address__c> htsIPList = [SELECT Id, HTS_IP_Address__c FROM HTS_IP_Address__c];
		system.assertEquals(5, htsIPList.size());
    list<HTS_Terminal_Template__c> readTemplates = [SELECT Name FROM HTS_Terminal_Template__c];
    system.assertEquals(1, readTemplates.size());
  }
  static testMethod void test_createTerminal_OK(){
    map<String, String> inputMap = new map<String, String>();
    inputMap.put('satRouter', SatRouterstring2); //Should be OK....
    inputMap.put('systemSerialNumber', '170400001');
    inputMap.put('swSerialNumber', '1704U0001');
    inputMap.put('adminIP', '10.242.1.1');
    inputMap.put('MTAMAC', 'MACAVAILABLE');
    test.startTest();
    HTS_ltgsvc_terminals returnObj = HTS_ltgsvc_terminals.createTerminal(inputMap);
    system.assertEquals('SUCCESS:', returnObj.statusMessage.left(8));
    system.assertEquals(7, returnObj.assetCollection.size());
    test.stopTest();
  }
  static testMethod void test_createTerminal_FAIL1(){
    map<String, String> inputMap = new map<String, String>();
    inputMap.put('satRouter', SatRouterstring); //Already in use ERROR!
    inputMap.put('systemSerialNumber', '170400001');
    inputMap.put('swSerialNumber', '1704U0001');
    inputMap.put('adminIP', '10.242.1.1');
    inputMap.put('MTAMAC', '0011223344');
    HTS_ltgsvc_terminals returnObj = HTS_ltgsvc_terminals.createTerminal(inputMap);
    system.assertEquals('ERROR:', returnObj.statusMessage.left(6));
  }
  static testMethod void test_createTerminal_FAIL2(){
    map<String, String> inputMap = new map<String, String>();
    inputMap.put('satRouter', SatRouterstring2); 
    inputMap.put('systemSerialNumber', '170400001');
    inputMap.put('swSerialNumber', '1704U0001');
    inputMap.put('adminIP', '10.242.1.1');
    inputMap.put('MTAMAC', 'MACAVAILABLE');
    DefaultAccounts__c insertSetting = DefaultAccounts__c.getValues('DefaultAssets');
		insertSetting.Account_ID__c = '001000000000000000';
		//insertSetting.Account_ID__c = testAccount.Id;
    update insertSetting;
    test.startTest();
    HTS_ltgsvc_terminals returnObj = HTS_ltgsvc_terminals.createTerminal(inputMap);
    system.assertEquals('ERROR: Duplicates detected, MTA in use!', returnObj.statusMessage.left(39));
    system.assertEquals(1, returnObj.assetCollection.size());
    test.stopTest();
  }
  static testMethod void test_createTerminal_FAIL3(){
    map<String, String> inputMap = new map<String, String>();
    inputMap.put('satRouter', SatRouterstring2);      //Should be OK....
    inputMap.put('systemSerialNumber', '170300007');  //Already in use ERROR!
    inputMap.put('swSerialNumber', '1704U0001');
    inputMap.put('adminIP', '10.242.1.1');
    inputMap.put('MTAMAC', '0011223344');
    HTS_ltgsvc_terminals returnObj = HTS_ltgsvc_terminals.createTerminal(inputMap);
    system.assertEquals('ERROR:', returnObj.statusMessage.left(6));
  }
  static testMethod void test_getDefaultTerminalTemplate(){
    //HTS_ltgsvc_terminals.Helpers help = new HTS_ltgsvc_terminals.Helpers();
    String defaultTemplate = HTS_ltgsvc_shared.getDefaultTerminalTemplate();
    system.assertEquals('testTemplate', defaultTemplate);
  }

	static testMethod void test_lookupAssets(){
		String[] srchList = new String[]{'170300007', '12345678'};
		//Asset[] readList = new Asset[]{};
		HTS_ltgsvc_terminals readList = HTS_ltgsvc_terminals.lookupAssets(srchList);
		system.assertEquals(2, readList.assetCollection.size());
		srchList.clear();
		srchList.add('87654321');
		readList = HTS_ltgsvc_terminals.lookupAssets(srchList);
		system.assertEquals(0, readList.assetCollection.size());
	}
	static testMethod void test_findSatRouterBySerial(){
		String searchStr = '77777';
		//list<Asset> readList = new list<Asset>();
		HTS_ltgsvc_terminals readList = HTS_ltgsvc_terminals.findSatRouterBySerial(searchStr);
		system.assertEquals(1, readList.assetCollection.size());
	}
	static testMethod void test_getCoreModuleId_OK(){
		// Use MultiStaticResourceCalloutMock to
		// specify fake response for a certain endpoint and 
		// include response body in a static resource.    
		StaticResourceCalloutMock singleMock = new StaticResourceCalloutMock();
		singleMock.setStaticResource('HTS_GET_SatRouter_MOCK');
		singleMock.setStatusCode(200);
		singleMock.setHeader('Content-Type', 'application/json');
		// Set the mock callout mode
		Test.setMock(HttpCalloutMock.class, singleMock);
		test.startTest();
		integer resultsInt = 0;
		HTS_ltgsvc_terminals.Helpers help = new HTS_ltgsvc_terminals.Helpers();
		resultsInt = help.getCoreModuleId(SatRouterstring);
		system.debug(resultsInt); 
		system.assertEquals(3065, resultsInt);
		test.stopTest();
	}
	static testMethod void test_getCoreModuleId_FAIL(){
		// Use MultiStaticResourceCalloutMock to
		// specify fake response for a certain endpoint and 
		// include response body in a static resource.    
		StaticResourceCalloutMock singleMock = new StaticResourceCalloutMock();
		singleMock.setStaticResource('HTS_GET_SatRouter_MOCK_empty');
		singleMock.setStatusCode(200);
		singleMock.setHeader('Content-Type', 'application/json');
		// Set the mock callout mode
		Test.setMock(HttpCalloutMock.class, singleMock);
		test.startTest();
		integer resultsInt = 0;
		HTS_ltgsvc_terminals.Helpers help = new HTS_ltgsvc_terminals.Helpers();
		resultsInt = help.getCoreModuleId(SatRouterstring);
		system.debug(resultsInt); 
		system.assertEquals(-1, resultsInt);
		test.stopTest();
	}
	static testMethod void test_getTerminalType_OK(){
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
		integer resultsInt = 0;
		HTS_ltgsvc_terminals.Helpers help = new HTS_ltgsvc_terminals.Helpers();
		resultsInt = help.getTerminalType();
		system.debug(resultsInt); 
		system.assertEquals(1828, resultsInt);
		test.stopTest();
	}
	static testMethod void test_handleSatRouter(){
		list<Asset> readList = [SELECT Id, Name, SerialNumber, Parent_Asset__c FROM Asset
		                        WHERE SerialNumber =: SatRouterstring];
		HTS_ltgsvc_terminals.Helpers help = new HTS_ltgsvc_terminals.Helpers();
		HTS_ltgsvc_terminals satRouters = help.handleSatRouter(SatRouterstring);
		system.assertEquals('ERROR:', satRouters.statusMessage.left(6));
		readList[0].Parent_Asset__c = null;
		update readList[0];
		satRouters = help.handleSatRouter(SatRouterstring);
		system.assertEquals('SUCCESS:', satRouters.statusMessage.left(8));
		system.assertEquals('KVH-SR-77777', satRouters.assetCollection[0].Name);
		delete readList[0];
		satRouters = help.handleSatRouter(SatRouterstring);
		system.assertEquals('ERROR:', satRouters.statusMessage.left(6));

	}
	static testMethod void test_handleHTSIp(){
		HTS_ltgsvc_terminals.Helpers help = new HTS_ltgsvc_terminals.Helpers();
		Asset resultsAsset = help.handleHTSIp();
		system.assertEquals('10.83.0.0', resultsAsset.Name);
	}
	static testMethod void test_handleVTID(){
		HTS_ltgsvc_terminals.Helpers help = new HTS_ltgsvc_terminals.Helpers();
		Asset resultsAsset = help.handleVTID();
		system.assertEquals(true, resultsAsset.Name.isNumeric());
  }
  //TODO implement new Mocking framework 
  //https://salesforce.stackexchange.com/questions/105322/callout-mock-responses-multiple-http-status-code-values
  static testMethod void test_provisionForTest_OK(){
    //Need a few mock responses...
    QueueHttpMock mock = new QueueHttpMock();
    HttpResponse res1 = new HttpResponse();
    //FIRST get a core module ID
    res1.setStatusCode(200);
    string responseBody = '[{"chip_sn": "1111111","model": "X7","obj_id": 5825,"obj_name": "KVH-SR-99992","obj_revision": 1,"serialnumber": 99992}]';
    res1.setBody(responseBody);
    //SECOND get the terminal type
    HttpResponse res2 = new HttpResponse();
    res2.setStatusCode(200);
    responseBody = '{"satellite_router_types":[],"subscriber_plans":[],"terminal_templates":[{"obj_id":"CONUS_STANDARD","obj_name":"CONUS_STANDARD"}],"terminal_types":[{"obj_id":1828,"obj_name":"KVH-Lab TermType"}]}';
    res2.setBody(responseBody);
    //THIRD post the terminal
    HttpResponse res3 = new HttpResponse();
    res3.setStatusCode(201);
    //FOURTH post a subscriber
    HttpResponse res4 = new HttpResponse();
    res4.setStatusCode(201);

    mock.addResponse(res1);
    //mock.addResponse(res2);
    mock.addResponse(res3);
    mock.addResponse(res4);

    Test.setMock(HttpCalloutMock.class, mock);
    //Mock responses setup!
    //Need an Asset Hierarchy, complete with SatRouter
    list<Asset> readList = [SELECT Id, Name, SerialNumber, Asset_Id__c, Parent_Asset__c FROM Asset
                        WHERE SerialNumber !=: SatRouterstring2];
    system.assertEquals(5,readList.size());
    test.startTest();
    HTS_ltgsvc_terminals results = new HTS_ltgsvc_terminals();
    results = HTS_ltgsvc_terminals.provisionForTest(readList, true);
    system.assertEquals('SUCCESS:', results.statusMessage.left(8));
    test.stopTest();
  }
  static testMethod void test_provisionForTest_FAIL_1(){
    //Need a few mock responses...
    QueueHttpMock mock = new QueueHttpMock();
    HttpResponse res1 = new HttpResponse();
    //FIRST get a core module ID
    res1.setStatusCode(200);
    string responseBody = '[{"chip_sn": "1111111","model": "X7","obj_id": 5825,"obj_name": "KVH-SR-99992","obj_revision": 1,"serialnumber": 99992}]';
    res1.setBody(responseBody);
    //SECOND get the terminal type
    HttpResponse res2 = new HttpResponse();
    res2.setStatusCode(200);
    responseBody = '{"satellite_router_types":[],"subscriber_plans":[],"terminal_templates":[{"obj_id":"CONUS_STANDARD","obj_name":"CONUS_STANDARD"}],"terminal_types":[{"obj_id":1828,"obj_name":"KVH-Lab TermType"}]}';
    res2.setBody(responseBody);
    //THIRD post the terminal
    HttpResponse res3 = new HttpResponse();
    res3.setStatusCode(500);
    //FOURTH post a subscriber
    HttpResponse res4 = new HttpResponse();
    res4.setStatusCode(201);

    mock.addResponse(res1);
    mock.addResponse(res2);
    mock.addResponse(res3);
    mock.addResponse(res4);

    Test.setMock(HttpCalloutMock.class, mock);
    //Mock responses setup!
    //Need an Asset Hierarchy, complete with SatRouter
    list<Asset> readList = [SELECT Id, Name, SerialNumber, Asset_Id__c, Parent_Asset__c FROM Asset
                        WHERE SerialNumber !=: SatRouterstring2];
    system.assertEquals(5,readList.size());
    test.startTest();
    HTS_ltgsvc_terminals results = new HTS_ltgsvc_terminals();
    results = HTS_ltgsvc_terminals.provisionForTest(readList, true);
    test.stopTest();
    system.assertEquals('EXCEPTION:', results.statusMessage.left(10));
  }
  static testMethod void test_provisionForTest_Asynch_FAIL_1(){
    //Need a few mock responses...
    QueueHttpMock mock = new QueueHttpMock();
    HttpResponse res1 = new HttpResponse();
    //FIRST get a core module ID
    res1.setStatusCode(200);
    string responseBody = '[{"chip_sn": "1111111","model": "X7","obj_id": 5825,"obj_name": "KVH-SR-99992","obj_revision": 1,"serialnumber": 99992}]';
    res1.setBody(responseBody);
    //SECOND get the terminal type
    HttpResponse res2 = new HttpResponse();
    res2.setStatusCode(200);
    responseBody = '{"satellite_router_types":[],"subscriber_plans":[],"terminal_templates":[{"obj_id":"CONUS_STANDARD","obj_name":"CONUS_STANDARD"}],"terminal_types":[{"obj_id":1828,"obj_name":"KVH-Lab TermType"}]}';
    res2.setBody(responseBody);
    //THIRD post the terminal
    HttpResponse res3 = new HttpResponse();
    res3.setStatusCode(500);
    //FOURTH post a subscriber
    HttpResponse res4 = new HttpResponse();
    res4.setStatusCode(201);

    mock.addResponse(res1);
    mock.addResponse(res2);
    mock.addResponse(res3);
    mock.addResponse(res4);

    Test.setMock(HttpCalloutMock.class, mock);
    //Mock responses setup!
    //Need an Asset Hierarchy, complete with SatRouter
    list<Asset> readList = [SELECT Id, Name, SerialNumber, Asset_Id__c, Parent_Asset__c FROM Asset
                        WHERE SerialNumber !=: SatRouterstring2];
    system.assertEquals(5,readList.size());
    test.startTest();
    HTS_ltgsvc_terminals results = new HTS_ltgsvc_terminals();
    results = HTS_ltgsvc_terminals.provisionForTest(readList, false);
    test.stopTest();
    system.assertEquals('EXCEPTION:', results.statusMessage.left(10));
  }
  static testMethod void test_provisionForTest_FAIL_2(){
    //Need a few mock responses...
    QueueHttpMock mock = new QueueHttpMock();
    HttpResponse res1 = new HttpResponse();
    //FIRST get a core module ID
    res1.setStatusCode(200);
    string responseBody = '[{"chip_sn": "1111111","model": "X7","obj_id": 5825,"obj_name": "KVH-SR-99992","obj_revision": 1,"serialnumber": 99992}]';
    res1.setBody(responseBody);
    //SECOND get the terminal type
    HttpResponse res2 = new HttpResponse();
    res2.setStatusCode(200);
    responseBody = '{"satellite_router_types":[],"subscriber_plans":[],"terminal_templates":[{"obj_id":"CONUS_STANDARD","obj_name":"CONUS_STANDARD"}],"terminal_types":[{"obj_id":1828,"obj_name":"KVH-Lab TermType"}]}';
    res2.setBody(responseBody);
    //THIRD post the terminal
    HttpResponse res3 = new HttpResponse();
    res3.setStatusCode(201);
    //FOURTH post a subscriber
    HttpResponse res4 = new HttpResponse();
    res4.setStatusCode(500);

    mock.addResponse(res1);
    mock.addResponse(res2);
    mock.addResponse(res3);
    mock.addResponse(res4);

    Test.setMock(HttpCalloutMock.class, mock);
    //Mock responses setup!
    //Need an Asset Hierarchy, complete with SatRouter
    list<Asset> readList = [SELECT Id, Name, SerialNumber, Asset_Id__c, Parent_Asset__c FROM Asset
                        WHERE SerialNumber !=: SatRouterstring2];
    system.assertEquals(5,readList.size());
    test.startTest();
    HTS_ltgsvc_terminals results = new HTS_ltgsvc_terminals();
    results = HTS_ltgsvc_terminals.provisionForTest(readList, true);
    system.assertEquals('EXCEPTION:', results.statusMessage.left(10));
    test.stopTest();
  }
  static testMethod void test_provisionForTest_FAIL_3(){
    //Need a few mock responses...
    QueueHttpMock mock = new QueueHttpMock();
    HttpResponse res1 = new HttpResponse();
    //FIRST get a core module ID
    res1.setStatusCode(200);
    string responseBody = '[{"chip_sn": "1111111","model": "X7","obj_id": 5825,"obj_name": "KVH-SR-99992","obj_revision": 1,"serialnumber": 99992}]';
    res1.setBody(responseBody);
    //SECOND get the terminal type
    HttpResponse res2 = new HttpResponse();
    res2.setStatusCode(200);
    responseBody = '{"satellite_router_types":[],"subscriber_plans":[],"terminal_templates":[{"obj_id":"CONUS_STANDARD","obj_name":"CONUS_STANDARD"}],"terminal_types":[{"obj_id":1828,"obj_name":"KVH-Lab TermType"}]}';
    res2.setBody(responseBody);
    //THIRD post the terminal
    HttpResponse res3 = new HttpResponse();
    res3.setStatusCode(201);
    //FOURTH post a subscriber
    HttpResponse res4 = new HttpResponse();
    res4.setStatusCode(500);

    mock.addResponse(res1);
    mock.addResponse(res2);
    mock.addResponse(res3);
    mock.addResponse(res4);

    Test.setMock(HttpCalloutMock.class, mock);
    //Mock responses setup!

    //Need an Asset Hierarchy, complete with SatRouter
    list<Asset> readList = [SELECT Id, Name, SerialNumber, Asset_Id__c, Parent_Asset__c FROM Asset
                        WHERE SerialNumber !=: SatRouterstring2];
    system.assertEquals(5,readList.size());
    readList[0].Asset_Id__c = '';
    update readlist[0];

    test.startTest();
    HTS_ltgsvc_terminals results = new HTS_ltgsvc_terminals();
    results = HTS_ltgsvc_terminals.provisionForTest(readList, true);
    system.assertEquals('EXCEPTION:', results.statusMessage.left(10));

    readList[0].Asset_Id__c = null;
    update readlist[0];
    results = HTS_ltgsvc_terminals.provisionForTest(readList, true);
    test.stopTest();

    system.assertEquals('EXCEPTION:', results.statusMessage.left(10));
  }
  static testMethod void test_postTerminalSynchronous_OK(){
    //Need a few mock responses...
    QueueHttpMock mock = new QueueHttpMock();
    //FIRST and only... post the terminal
    HttpResponse res3 = new HttpResponse();
    res3.setStatusCode(201);

    mock.addResponse(res3);

    Test.setMock(HttpCalloutMock.class, mock);
    //Mock responses setup!
    map<String,String> attributeMap = new map<String,String>();
    attributeMap.put('coremodule_id', '1234');    //Will need to convert back to Int
    attributeMap.put('mgmtipaddress', '10.224.1.64');
    attributeMap.put('terminal_ip_address', '10.64.64.0/24');
    attributeMap.put('template_id', 'CONUS_STANDARD');
    attributeMap.put('terminal_id', '12345678');
    attributeMap.put('terminaltype_id', '2981');  //Will need to convert back to Int
    HTS_ltgsvc_terminals.Helpers help = new HTS_ltgsvc_terminals.Helpers();
    test.startTest();
    HTS_ltgsvc_terminals results = help.postTerminalSynchronous(attributeMap);
    test.stopTest();
    system.assertEquals('SUCCESS:', results.statusMessage.left(8));
  }
  static testMethod void test_postTerminalAsynchronous_OK(){
    //Need a few mock responses...
    QueueHttpMock mock = new QueueHttpMock();
    //FIRST and only... post the terminal
    HttpResponse res3 = new HttpResponse();
    res3.setStatusCode(200);
    res3.setBody('{"complete": true,"obj_id": "b96e0041-676b-4728-97cf-9f1b1a73f7c0","result": true}');

    mock.addResponse(res3);

    Test.setMock(HttpCalloutMock.class, mock);
    //Mock responses setup!
    map<String,String> attributeMap = new map<String,String>();
    attributeMap.put('coremodule_id', '1234');    //Will need to convert back to Int
    attributeMap.put('mgmtipaddress', '10.224.1.64');
    attributeMap.put('terminal_ip_address', '10.64.64.0/24');
    attributeMap.put('template_id', 'CONUS_STANDARD');
    attributeMap.put('terminal_id', '12345678');
    attributeMap.put('terminaltype_id', '2981');  //Will need to convert back to Int
    HTS_ltgsvc_terminals.Helpers help = new HTS_ltgsvc_terminals.Helpers();
    test.startTest();
    HTS_ltgsvc_terminals results = help.postTerminalAsynchronous(attributeMap);
    test.stopTest();
    system.assertEquals('SUCCESS:', results.statusMessage.left(8));
  }
  static testMethod void test_postTerminalAsynchronous_FAIL_500(){
    //Need a few mock responses...
    QueueHttpMock mock = new QueueHttpMock();
    //FIRST and only... post the terminal
    HttpResponse res3 = new HttpResponse();
    res3.setStatusCode(500);
    mock.addResponse(res3);

    Test.setMock(HttpCalloutMock.class, mock);
    //Mock responses setup!
    map<String,String> attributeMap = new map<String,String>();
    attributeMap.put('coremodule_id', '1234');    //Will need to convert back to Int
    attributeMap.put('mgmtipaddress', '10.224.1.64');
    attributeMap.put('terminal_ip_address', '10.64.64.0/24');
    attributeMap.put('template_id', 'CONUS_STANDARD');
    attributeMap.put('terminal_id', '12345678');
    attributeMap.put('terminaltype_id', '2981');  //Will need to convert back to Int
    HTS_ltgsvc_terminals.Helpers help = new HTS_ltgsvc_terminals.Helpers();
    test.startTest();
    HTS_ltgsvc_terminals results = help.postTerminalAsynchronous(attributeMap);
    test.stopTest();
    system.assertEquals('EXCEPTION:', results.statusMessage.left(10));
  }
  static testMethod void test_buildAssetMap(){
    list<Asset> readlist = [SELECT Id, Name, Product2.ProductCode, Asset_Id__c FROM Asset];
    HTS_ltgsvc_terminals.Helpers help = new HTS_ltgsvc_terminals.Helpers();
    test.startTest();
    map<String, Asset> assetMap = help.buildAssetMap(readlist);
    test.stopTest();
    for(String pn : assetMap.keySet()){
      Asset a = assetMap.get(pn);                       //Get the Asset from the map...
      system.assertEquals(pn, a.Product2.ProductCode);  //Verify that the map key and the Asset match
    }
  }

}