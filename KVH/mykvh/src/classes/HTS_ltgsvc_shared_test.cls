@isTest
private class HTS_ltgsvc_shared_test {
	static string VTIDstring = '87654321';
	static string SatRouterstring = '12345';

  @testSetup static void setupTestData(){
    //setup common test data here, Need at least ONE HTS IP Address
    list<HTS_IP_Address__c> insertList = new list<HTS_IP_Address__c>();
    insertList.add(new HTS_IP_Address__c(Management_IP_Address__c = '10.242.2.1', HTS_IP_Address__c = '10.65.1.0', HTS_IP_HEX_Address__c = '0A.41.01.00'));
    insertList.add(new HTS_IP_Address__c(Management_IP_Address__c = '10.242.2.2', HTS_IP_Address__c = '10.65.2.0', HTS_IP_HEX_Address__c = '0A.41.02.00'));
    insertList.add(new HTS_IP_Address__c(Management_IP_Address__c = '10.242.2.3', HTS_IP_Address__c = '10.65.3.0', HTS_IP_HEX_Address__c = '0A.41.03.00'));
    insertList.add(new HTS_IP_Address__c(Management_IP_Address__c = '10.242.2.4', HTS_IP_Address__c = '10.65.4.0', HTS_IP_HEX_Address__c = '0A.41.04.00'));
    insertList.add(new HTS_IP_Address__c(Management_IP_Address__c = '10.242.2.5', HTS_IP_Address__c = '10.65.5.0', HTS_IP_HEX_Address__c = '0A.41.05.00'));
    insert insertList;
        //Going to need a couple of I2CM Assets... and maybe parents for them.
    //Going to need an HTS Asset Hierarchy that includes a SatRouter, VTID, and IP Address.
    //LOTS of SOQL :( have to move our startTest to kind of the middle of this setup stuff....
    
    //Setup Lists for inserts/upserts
    list<Account> insertAccts = new list<Account>();
    list<Product2> insertProds = new list<Product2>();
    list<Asset> insertAssets = new list<Asset>();
    //Setup Accounts
    Account defaultAssets = new Account(Name = 'Default Assets');
    insertAccts.add(defaultAssets);
    Account replacedAssets = new Account(Name = 'Replaced Assets');
    insertAccts.add(replacedAssets);
    Account testAccount = new Account(Name = 'Test Account');
    insertAccts.add(testAccount);
    insert insertAccts;
    //Setup Custom Settings....
    DefaultAccounts__c mfgAssets = new DefaultAccounts__c(Name = 'DefaultAssets', Account_ID__c = defaultAssets.Id, Description__c ='Desc1');
    insert mfgAssets;
    DefaultAccounts__c replaced = new DefaultAccounts__c(Name = 'ReplacedAssets', Account_ID__c = replacedAssets.Id, Description__c ='Desc2');
    insert replaced;
    //Setup Product2s
    Product2 systemProd = new Product2(Name = '01-0408-15', ProductCode = '01-0408-15');
    insertProds.add(systemProd);
    Product2 i2cmProd = new Product2(Name = 'PACKAGED I2CM TPV7IP 4/500', ProductCode = '02-2204-02');
    insertProds.add(i2cmProd);
    Product2 coreProd = new Product2(Name = '19-0955', ProductCode = '19-0955');
    insertProds.add(coreProd);
    Product2 ipProd = new Product2(Name = 'HTS IP Address', ProductCode = 'HTS IP Address');
    insertProds.add(ipProd);
    Product2 vtidProd = new Product2(Name = 'Virtual Terminal ID', ProductCode = 'Virtual Terminal ID');
    insertProds.add(vtidProd);
    insert insertProds;
    //Start setting up Asset Hierarchies....
    test.startTest();   //with a NEW set of governor limits....
    //Need a single System Asset and two I2CM Assets
    Asset systemAsset = new Asset(Name = 'removedFrom', AccountId = testAccount.Id, Product2Id = systemProd.Id);
    insertAssets.add(systemAsset);
    upsert insertAssets;
    //Need a Product2 references for the Assets. Get it from the Custom Metadata Type
    //We are going to validate test data setup for Asset Hierarchies based on the left 7 chars of Asset.Name.

    Asset installed = new Asset(Name = 'instald', AccountId = defaultAssets.Id, 
                                Product2Id = i2cmProd.Id);
    insertAssets.add(installed);
    Asset removed = new Asset(Name = 'removed', AccountId = testAccount.Id, 
                              Product2Id = i2cmProd.Id, Parent_Asset__c = systemAsset.Id);
    insertAssets.add(removed);
    upsert insertAssets;

    Asset vtid1 = new Asset(Name = 'instaldVTID', Parent_Asset__c = installed.Id, Product2Id = vtidProd.Id);
    insertAssets.add(vtid1);
    Asset vtid2 = new Asset(Name = 'removedVTID', Parent_Asset__c = removed.Id, Product2Id = vtidProd.Id);
    insertAssets.add(vtid2);

    Asset hts_ip1 = new Asset(Name = 'instaldIP', Parent_Asset__c = installed.Id, AccountId = testAccount.Id, Product2Id = ipProd.Id);
    insertAssets.add(hts_ip1);
    Asset hts_ip2 = new Asset(Name = 'removedIP', Parent_Asset__c = removed.Id, AccountId = testAccount.Id, Product2Id = ipProd.Id);
    insertAssets.add(hts_ip2);

    Asset core1 = new Asset(Name = 'instaldCore', SerialNumber = 'instaldCore', Parent_Asset__c = installed.Id, AccountId = testAccount.Id, Product2Id = coreProd.Id);
    insertAssets.add(core1);
    Asset core2 = new Asset(Name = 'removedCore', SerialNumber = 'removedCore', Parent_Asset__c = removed.Id, AccountId = testAccount.Id, Product2Id = coreProd.Id);
    insertAssets.add(core2);

    upsert insertAssets;

    //insert new HTS_IP_Address__c(HTS_IP_HEX_Address__c = '0A.53.53.00', HTS_IP_Address__c = '10.83.83.0');
    insert new HTS_Virtual_Terminal_ID__c(Virtual_Terminal_Id__c = '99999901');

    insert new HTS_Terminal_Template__c(obj_id__c='CONUS_STANDARD', isDefault__c=true, Name='CONUS_STANDARD');
    test.stopTest();
  }
  
  static testMethod void testSetupData(){
    //use this method to validate that you have test data setup correctly
    list<HTS_IP_Address__c> readList = [SELECT Id, HTS_IP_Address__c, Management_IP_Address__c, HTS_IP_HEX_Address__c 
                                  FROM HTS_IP_Address__c 
                                  WHERE HTS_IP_HEX_Address__c != '' 
                                  ORDER BY HTS_IP_HEX_Address__c ASC]; //difficult query to optimize....
    system.assertEquals(5, readList.size());
    system.assertEquals('10.65.1.0', readList[0].HTS_IP_Address__c);
    list<Account> readAccts = [SELECT Id FROM Account];
    system.assertEquals(3, readAccts.size());
    map<String, DefaultAccounts__c> settingsMap = DefaultAccounts__c.getAll();
    system.assertEquals(2, settingsMap.size());
    list<Asset> readAssets = [SELECT Id, Name, Parent_Asset__c, Parent_Asset__r.Name FROM Asset];
    system.assertEquals(9, readAssets.size());
    for(Asset a : readAssets){
      if(a.Parent_Asset__c != null){
        system.assertEquals(a.name.left(7), a.Parent_Asset__r.Name.left(7));
      }
    }
    list<HTS_Virtual_Terminal_ID__c> readVTIDs = [SELECT Id, Name, Virtual_Terminal_Id__c FROM HTS_Virtual_Terminal_ID__c];
    system.assertEquals(1, readVTIDs.size());
    list<HTS_Terminal_Template__c> readTemplates = [SELECT Id, Name, isDefault__c, obj_id__c FROM HTS_Terminal_Template__c];
    system.assertEquals(1,readTemplates.size());
  }

  static testMethod void test_getMgmtIPs(){    
    map<String, String> returnedMap = new map<String, String>();
    list<String> inputList = new list<String>();
    inputList.add('10.65.1.0');
    inputList.add('10.65.2.0');
    inputList.add('10.65.3.0');
    inputList.add('10.65.4.0');
    inputList.add('10.65.5.0');
    test.startTest();
    returnedMap = HTS_ltgsvc_shared.getMgmtIPs(inputList);
    test.stopTest();
    system.assertEquals('10.242.2.1', returnedMap.get('10.65.1.0'));
    system.assertEquals('10.242.2.2', returnedMap.get('10.65.2.0'));
    system.assertEquals('10.242.2.3', returnedMap.get('10.65.3.0'));
    system.assertEquals('10.242.2.4', returnedMap.get('10.65.4.0'));
    system.assertEquals('10.242.2.5', returnedMap.get('10.65.5.0'));
  }

	static testMethod void test_getTerminalFromOSS() {
		// Use MultiStaticResourceCalloutMock to
		// specify fake response for a certain endpoint and 
		// include response body in a static resource.    
		StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
		multimock.setStaticResource('HTS_GET_terminal_response_filtered_MOCK');
		multimock.setStatusCode(200);
		multimock.setHeader('Content-Type', 'application/json');
		// Set the mock callout mode
		Test.setMock(HttpCalloutMock.class, multimock);
		test.startTest();
		HTS_ltgsvc_shared util = new HTS_ltgsvc_shared();
		map<string,string> resultsMap = util.getTerminalFromOSS(VTIDstring);
		system.assertEquals('3373', resultsMap.get('obj_id'));
		system.assertEquals('6', resultsMap.get('obj_revision'));
		test.stopTest();
	}
  static testMethod void test_getSatRouterFromOSS() {
    // Use MultiStaticResourceCalloutMock to
    // specify fake response for a certain endpoint and 
    // include response body in a static resource.    
    StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
    multimock.setStaticResource('HTS_GET_SatRouter_MOCK');
    multimock.setStatusCode(200);
    multimock.setHeader('Content-Type', 'application/json');
    // Set the mock callout mode
    Test.setMock(HttpCalloutMock.class, multimock);
    test.startTest();
    HTS_ltgsvc_shared util = new HTS_ltgsvc_shared();
    HTS_ltgsvc_satrouters resultsObj = util.getSatRouterFromOSS(SatRouterstring);
    system.assertEquals('3065', resultsObj.satRouterMap.get('obj_id'));
    system.assertEquals('1', resultsObj.satRouterMap.get('obj_revision'));
    system.assertEquals('KVH-SR-12345', resultsObj.satRouterMap.get('obj_name'));
    system.assertEquals('12345', resultsObj.satRouterMap.get('serialnumber'));
    system.assertEquals(0, resultsObj.assetCollection.size());
    system.assertEquals('SUCCESS:', resultsObj.statusMessage.left(8));
    test.stopTest();
  }
  static testMethod void test_getSatRouterFromOSS_multiples() {
    // Use MultiStaticResourceCalloutMock to
    // specify fake response for a certain endpoint and 
    // include response body in a static resource.    
    StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
    multimock.setStaticResource('HTS_GET_SatRouter_MOCK_multiples');
    multimock.setStatusCode(200);
    multimock.setHeader('Content-Type', 'application/json');
    // Set the mock callout mode
    Test.setMock(HttpCalloutMock.class, multimock);
    test.startTest();
    HTS_ltgsvc_shared util = new HTS_ltgsvc_shared();
    HTS_ltgsvc_satrouters resultsObj = util.getSatRouterFromOSS(SatRouterstring);
    system.assertEquals('ERROR:', resultsObj.satRouterMap.get('obj_id').left(6));
    system.assertEquals('ERROR:', resultsObj.satRouterMap.get('obj_revision').left(6));
    system.assertEquals('ERROR:', resultsObj.satRouterMap.get('obj_name').left(6));
    system.assertEquals('ERROR:', resultsObj.satRouterMap.get('serialnumber').left(6));
    system.assertEquals(0, resultsObj.assetCollection.size());
    system.assertEquals('ERROR:', resultsObj.statusMessage.left(6));
    test.stopTest();
  }
  static testMethod void test_getSatRouterFromOSS_NotFound() {
    // Use MultiStaticResourceCalloutMock to
    // specify fake response for a certain endpoint and 
    // include response body in a static resource.    
    StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
    multimock.setStaticResource('HTS_GET_SatRouter_MOCK_empty');
    multimock.setStatusCode(200);
    multimock.setHeader('Content-Type', 'application/json');
    // Set the mock callout mode
    Test.setMock(HttpCalloutMock.class, multimock);
    test.startTest();
    HTS_ltgsvc_shared util = new HTS_ltgsvc_shared();
    HTS_ltgsvc_satrouters resultsObj = util.getSatRouterFromOSS(SatRouterstring);
    system.assertEquals('NOT FOUND:', resultsObj.satRouterMap.get('obj_id').left(10));
    system.assertEquals('NOT FOUND:', resultsObj.satRouterMap.get('obj_revision').left(10));
    system.assertEquals('NOT FOUND:', resultsObj.satRouterMap.get('obj_name').left(10));
    system.assertEquals('NOT FOUND:', resultsObj.satRouterMap.get('serialnumber').left(10));
    system.assertEquals(0, resultsObj.assetCollection.size());
    system.assertEquals('NOT FOUND:', resultsObj.statusMessage.left(10));
  }
  static testMethod void test_createTerminalFromAssets_OK(){
    //Need mock response from hts/satelliterouters
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_CoreIdList_OK());
    Test.setMock(HttpCalloutMock.class, mock);
    map<String, Asset> assetMap = new map<String, Asset>();
    for(Asset a : [SELECT Id, Name, Parent_Asset__c, Product2.ProductCode,
                    SerialNumber, Parent_Asset__r.Product2.ProductCode
                   FROM Asset WHERE Name LIKE 'instald%' ]){
      assetMap.put(a.Product2.ProductCode, a);
    }
    Asset setupAsset = assetMap.get('HTS IP Address');
    setupAsset.Name = '10.65.5.0';
    assetMap.put('HTS IP Address', setupAsset);
    ///list<Asset> delList = new list<Asset>();
    //delete delList;
    test.startTest();
    HTSOSS_hts_terminals createdTerm = HTS_ltgsvc_shared.createTerminalFromAssets(assetMap.values());
    test.stopTest();  //check for 6 attributes...
    system.assertEquals('instaldVTID', createdTerm.terminal_id);
    system.assertEquals('10.242.2.5', createdTerm.mgmtipaddress);
    system.assertEquals('10.65.5.0/24', createdTerm.terminal_ip_address);
    system.assertEquals(2931, createdTerm.terminaltype_id);
    system.assertEquals(2121, createdTerm.coremodule_id);
    system.assertEquals('CONUS_STANDARD', createdTerm.template_id);
  }
  static testMethod void test_createTerminalFromAssets_NOCOREOSS(){
    //Need mock response from hts/satelliterouters
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_CoreIdList_EMPTY());
    Test.setMock(HttpCalloutMock.class, mock);
    map<String, Asset> assetMap = new map<String, Asset>();
    for(Asset a : [SELECT Id, Name, Parent_Asset__c, Product2.ProductCode,
                    SerialNumber, Parent_Asset__r.Product2.ProductCode
                   FROM Asset WHERE Name LIKE 'instald%' ]){
      assetMap.put(a.Product2.ProductCode, a);
    }
    Asset setupAsset = assetMap.get('HTS IP Address');
    setupAsset.Name = '10.65.5.0';
    assetMap.put('HTS IP Address', setupAsset);
    ///list<Asset> delList = new list<Asset>();
    //delete delList;
    test.startTest();
    HTSOSS_hts_terminals createdTerm = HTS_ltgsvc_shared.createTerminalFromAssets(assetMap.values());
    test.stopTest();
    system.assertEquals(400, createdTerm.response_code);
    system.assertEquals('NOT FOUND: SatRouter not found in OSS', createdTerm.message );
  }
  static testMethod void test_createTerminalFromAssets_NOPRODCODE(){
    //Need mock response from hts/satelliterouters
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_CoreIdList_OK());
    Test.setMock(HttpCalloutMock.class, mock);
    map<String, Asset> assetMap = new map<String, Asset>();
    for(Asset a : [SELECT Id, Name, Parent_Asset__c, Product2.ProductCode,
                    SerialNumber, Parent_Asset__r.Product2.ProductCode
                   FROM Asset WHERE Name LIKE 'instald%' ]){
      assetMap.put(a.Product2.ProductCode, a);
    }
    Asset setupAsset = assetMap.get('HTS IP Address');
    setupAsset.Product2.ProductCode = null;
    assetMap.put('HTS IP Address', setupAsset);
    ///list<Asset> delList = new list<Asset>();
    //delete delList;
    test.startTest();
    HTSOSS_hts_terminals createdTerm = HTS_ltgsvc_shared.createTerminalFromAssets(assetMap.values());
    test.stopTest();  //check for 6 attributes...
    system.assertEquals(400, createdTerm.response_code);
    system.assertEquals('ERROR: Input Assets must have Product2.ProductCode populated', createdTerm.message );
  }
  static testMethod void test_createTerminalFromAssets_NOCOREMODULE(){
    //Need mock response from hts/satelliterouters
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_CoreIdList_OK());
    Test.setMock(HttpCalloutMock.class, mock);
    map<String, Asset> assetMap = new map<String, Asset>();
    for(Asset a : [SELECT Id, Name, Parent_Asset__c, Product2.ProductCode,
                    SerialNumber, Parent_Asset__r.Product2.ProductCode
                   FROM Asset WHERE Name LIKE 'instald%' ]){
      assetMap.put(a.Product2.ProductCode, a);
    }
    assetMap.remove('19-0955');
    test.startTest();
    HTSOSS_hts_terminals createdTerm = HTS_ltgsvc_shared.createTerminalFromAssets(assetMap.values());
    test.stopTest();  //check for 6 attributes...
    system.assertEquals(400, createdTerm.response_code);
    system.assertEquals('ERROR: iDirect Modem part number 19-0955 required', createdTerm.message );
  }
  static testMethod void test_createTerminalFromAssets_NOCORESERIAL(){
    //Need mock response from hts/satelliterouters
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_CoreIdList_OK());
    Test.setMock(HttpCalloutMock.class, mock);
    map<String, Asset> assetMap = new map<String, Asset>();
    for(Asset a : [SELECT Id, Name, Parent_Asset__c, Product2.ProductCode,
                    SerialNumber, Parent_Asset__r.Product2.ProductCode
                   FROM Asset WHERE Name LIKE 'instald%' ]){
      assetMap.put(a.Product2.ProductCode, a);
    }
    Asset setupAsset = assetMap.get('19-0955');
    setupAsset.SerialNumber = null;
    assetMap.put('19-0955', setupAsset);
    ///list<Asset> delList = new list<Asset>();
    //delete delList;
    test.startTest();
    HTSOSS_hts_terminals createdTerm = HTS_ltgsvc_shared.createTerminalFromAssets(assetMap.values());
    test.stopTest();  //check for 6 attributes...
    system.assertEquals(400, createdTerm.response_code);
    system.assertEquals('ERROR: iDirect Modem 19-0955 requires Serial Number field to be populated', createdTerm.message );
  }
  static testMethod void test_createTerminalFromAssets_NOVTID(){
    //Need mock response from hts/satelliterouters
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_CoreIdList_OK());
    Test.setMock(HttpCalloutMock.class, mock);
    map<String, Asset> assetMap = new map<String, Asset>();
    for(Asset a : [SELECT Id, Name, Parent_Asset__c, Product2.ProductCode,
                    SerialNumber, Parent_Asset__r.Product2.ProductCode
                   FROM Asset WHERE Name LIKE 'instald%' ]){
      assetMap.put(a.Product2.ProductCode, a);
    }
    assetMap.remove('Virtual Terminal ID');
    test.startTest();
    HTSOSS_hts_terminals createdTerm = HTS_ltgsvc_shared.createTerminalFromAssets(assetMap.values());
    test.stopTest();  //check for 6 attributes...
    system.assertEquals(400, createdTerm.response_code);
    system.assertEquals('ERROR: Virtual Terminal Id required', createdTerm.message );
  }
  static testMethod void test_createTerminalFromAssets_NOHTSIP(){
    //Need mock response from hts/satelliterouters
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_CoreIdList_OK());
    Test.setMock(HttpCalloutMock.class, mock);
    map<String, Asset> assetMap = new map<String, Asset>();
    for(Asset a : [SELECT Id, Name, Parent_Asset__c, Product2.ProductCode,
                    SerialNumber, Parent_Asset__r.Product2.ProductCode
                   FROM Asset WHERE Name LIKE 'instald%' ]){
      assetMap.put(a.Product2.ProductCode, a);
    }
    assetMap.remove('HTS IP Address');
    test.startTest();
    HTSOSS_hts_terminals createdTerm = HTS_ltgsvc_shared.createTerminalFromAssets(assetMap.values());
    test.stopTest();  //check for 6 attributes...
    system.assertEquals(400, createdTerm.response_code);
    system.assertEquals('ERROR: HTS IP Address required', createdTerm.message );
  }
  static testMethod void test_getDefaultTerminalTypeId(){
    test.startTest();
    Integer testTermType = HTS_ltgsvc_shared.getDefaultTerminalTypeId();
    test.stopTest();
    system.assertEquals(2931, testTermType);
  }
  //setup methods for commonly used HTTP mock responses....
  static HttpResponse getMock_CoreIdList_OK(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    returnMock.setBody('[{"chip_sn": "1111111112", ' +
                          '"model": "X7", ' +
                          '"obj_id": 2121, ' +
                          '"obj_name": "A_SROUTE_TEST_0000002", ' +
                          '"obj_revision": 1, ' +
                          '"serialnumber": 66667}]');
    return returnMock;
  }
  static HttpResponse getMock_CoreIdList_EMPTY(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    returnMock.setBody('[]');
    return returnMock;
  }
}