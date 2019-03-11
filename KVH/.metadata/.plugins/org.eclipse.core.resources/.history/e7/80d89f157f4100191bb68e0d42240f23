@isTest

private class Service_I2CMFieldSwap_test {
  //setup testClass variables here. For example:
  //RecordType Ids
  private static final Id ServCloud_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Cloud').getRecordTypeId();
  //A common Loop Counter for bulikification purposes
  /*private static final integer MAX_LOOP_COUNTER = 200;*/

  @testSetup static void setupTestData(){
    //setup common test data here
    //Going to need a couple of I2CM Assets... and maybe parents for them.
    //Going to need an HTS Asset Hierarchy that includes a VTID, and IP Address.
    //Of course we need thee Accounts to hang the Assets off of... and two will be listed in the custom setting!
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
    Product2 ui2cmProd = new Product2(Name = 'PACKAGED I2CM TPV7IP 4/500 refurbished', ProductCode = 'U02-2204-02');
    insertProds.add(ui2cmProd);
    Product2 coreProd = new Product2(Name = '19-0955', ProductCode = '19-0955');
    insertProds.add(coreProd);
    Product2 ipProd = new Product2(Name = 'HTS IP Address', ProductCode = 'HTS IP Address');
    insertProds.add(ipProd);
    Product2 vtidProd = new Product2(Name = 'Virtual Terminal ID', ProductCode = 'Virtual Terminal ID');
    insertProds.add(vtidProd);
    insert insertProds;
    //I guess we also need at least one new VTID and one new HTS IP for the Assign Identifiers job....
    HTS_IP_Address__c insertIP = new HTS_IP_Address__c();
    insertIP.HTS_IP_Address__c = '10.10.10.10';
    insertIP.HTS_IP_HEX_Address__c = 'A0.A0.A0.A0';
    insertIP.Management_IP_Address__c = '10.242.10.10';
    insert insertIP;
    HTS_Virtual_Terminal_ID__c insertVTID = new HTS_Virtual_Terminal_ID__c(Virtual_Terminal_Id__c = '99990666');
    insert insertVTID;
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
    Asset vtid2 = new Asset(Name = 'removedVTID', Parent_Asset__c = systemAsset.Id, Product2Id = vtidProd.Id);
    insertAssets.add(vtid2);

    Asset hts_ip1 = new Asset(Name = 'instaldIP', Parent_Asset__c = installed.Id, AccountId = testAccount.Id, Product2Id = ipProd.Id);
    insertAssets.add(hts_ip1);
    Asset hts_ip2 = new Asset(Name = 'removedIP', Parent_Asset__c = systemAsset.Id, AccountId = testAccount.Id, Product2Id = ipProd.Id);
    insertAssets.add(hts_ip2);

    Asset core1 = new Asset(Name = 'instaldCore', Parent_Asset__c = installed.Id, AccountId = testAccount.Id, Product2Id = coreProd.Id);
    insertAssets.add(core1);
    Asset core2 = new Asset(Name = 'removedCore', Parent_Asset__c = removed.Id, AccountId = testAccount.Id, Product2Id = coreProd.Id);
    insertAssets.add(core2);

    upsert insertAssets;

    test.stopTest();
  }

  static testMethod void testSetupData(){
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
    list<HTS_IP_Address__c> readIPs = [SELECT Id FROM HTS_IP_Address__c];
    system.assertEquals(1, readIPs.size());
    list<HTS_Virtual_Terminal_ID__c> readVTID = [SELECT Id FROM HTS_Virtual_Terminal_ID__c];
    system.assertEquals(1, readVTID.size());
  }
  
  static testMethod void test_staticLog(){
    serviceResults logStringResponse = Service_I2CMFieldSwap.getLog();
    system.assert(logStringResponse.message.contains('SERVICE_INITIALIZATION'));
  }

  static testMethod void test_getCoreIdList_OK(){
    //Tests normal execution flow
    //Need an Asset
    list<Asset> readList = [SELECT Id FROM Asset WHERE Name = 'instald'];
    //Need mock response from hts/satelliterouters
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_CoreIdList_OK());
    mock.addResponse(getMock_CoreId_OK());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    integer returnedInt = Service_I2CMFieldSwap.getCoreId(readList[0]);
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    test.stopTest();
    system.assertEquals(2121, returnedInt);
  }
  static testMethod void test_getCoreId_NOCORE(){
    //Need an Asset
    list<Asset> readList = [SELECT Id FROM Asset WHERE Name = 'instald'];
    Asset delAsset = [SELECT Id FROM Asset WHERE Name = 'instaldCore' LIMIT 1];
    delete delAsset;

    test.startTest();
    integer returnedInt = Service_I2CMFieldSwap.getCoreId(readList[0]);
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    test.stopTest();

    system.assertEquals(-1, returnedInt);
    system.assertEquals(false, returnedLog.success);
    system.assert(returnedLog.message.contains('FATAL_ERROR'));
    system.assert(returnedLog.message.contains('Missing iDirect Modem!'));
  }
  static testMethod void test_getCoreId_DUPECORE(){
    //Tests normal execution flow
    //Need an Asset
    list<Asset> readList = [SELECT Id FROM Asset WHERE Name = 'instald'];
    Asset dupeAsset = [SELECT Id FROM Asset WHERE Name = 'removedCore' LIMIT 1];
    dupeAsset.Parent_Asset__c = readList[0].Id;
    update dupeAsset;

    test.startTest();
    integer returnedInt = Service_I2CMFieldSwap.getCoreId(readList[0]);
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    test.stopTest();

    system.assertEquals(-1, returnedInt);
    system.assertEquals(false, returnedLog.success);
    system.assert(returnedLog.message.contains('FATAL_ERROR'));
    system.assert(returnedLog.message.contains('Multiple iDirect Modems!'));
  }
  static testMethod void test_getOSSTerminalParams(){
    //Need mock responses from hts/terminals
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_terminalListOf1());
    mock.addResponse(getMock_terminalParams());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    HTSOSS_hts_terminals returnedTerm = Service_I2CMFieldSwap.getOSSTerminalParams(3541);
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    test.stopTest();
    //TODO: add assertions!!
    system.assert(returnedLog.message.contains('Returning Terminal Parameters: '));
  }
  static testMethod void test_getOSSTerminalParams_FAIL(){
    //Need mock response from hts/terminals
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_emptyArray(200));
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    HTSOSS_hts_terminals returnedTerm = Service_I2CMFieldSwap.getOSSTerminalParams(3541);
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    test.stopTest();
    //TODO: add assertions!!
    system.assert(returnedLog.message.contains('Failed to GET one and only one Terminal with Core Module Id: '));
  }
  static testMethod void test_putTerminalInactive(){
    //Need mock response from hts/terminals
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_emptyArray(204));
    Test.setMock(HttpCalloutMock.class, mock);
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.obj_id = 2046;
    testTerm.obj_revision = 4;
    test.startTest();
    testTerm = Service_I2CMFieldSwap.putTerminalInactive(testTerm);
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    test.stopTest();
    system.assertEquals(204, testTerm.response_code);
    system.assert(returnedLog.message.contains('METHOD_EXIT'));
    system.assert(returnedLog.message.contains('Returning Terminal Parameters: '));
  }
  static testMethod void test_putTerminalUpdate(){
    //Need mock response from hts/terminals
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_emptyArray(204));
    Test.setMock(HttpCalloutMock.class, mock);
    HTSOSS_hts_terminals testRemoved = new HTSOSS_hts_terminals();
    HTSOSS_hts_terminals testInstalled = new HTSOSS_hts_terminals();
    testRemoved.obj_id = 2046;
    testRemoved.obj_revision = 4;
    testInstalled.coremodule_id = 4321;
    test.startTest();
    testRemoved = Service_I2CMFieldSwap.updateTerminal(testRemoved, testInstalled);
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    test.stopTest();
    system.assertEquals(204, testRemoved.response_code,returnedLog.message);
    system.assert(returnedLog.message.contains('METHOD_EXIT'));
    system.assert(returnedLog.message.contains('Successfully updated terminal'), returnedLog.message);
  }
  static testMethod void test_putTerminalUpdate404(){
    //Need mock response from hts/terminals
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_terminal404());
    Test.setMock(HttpCalloutMock.class, mock);
    HTSOSS_hts_terminals testRemoved = new HTSOSS_hts_terminals();
    HTSOSS_hts_terminals testInstalled = new HTSOSS_hts_terminals();
    testRemoved.obj_id = 2046;
    testRemoved.obj_revision = 4;
    testInstalled.coremodule_id = 4321;
    test.startTest();
    testRemoved = Service_I2CMFieldSwap.updateTerminal(testRemoved, testInstalled);
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    test.stopTest();
    system.assertEquals(404, testRemoved.response_code,returnedLog.message);
    system.assert(returnedLog.message.contains('FATAL_ERROR'));
    system.assert(returnedLog.message.contains('OSS returned: 404'), returnedLog.message);
  }
  static testMethod void test_putTerminalUpdate_FAIL(){
    //Need mock response from hts/terminals
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_emptyArray(500));
    Test.setMock(HttpCalloutMock.class, mock);
    HTSOSS_hts_terminals testRemoved = new HTSOSS_hts_terminals();
    HTSOSS_hts_terminals testInstalled = new HTSOSS_hts_terminals();
    testRemoved.obj_id = 2046;
    testRemoved.obj_revision = 4;
    testInstalled.coremodule_id = 4321;
    test.startTest();
    testRemoved = Service_I2CMFieldSwap.updateTerminal(testRemoved, testInstalled);
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    test.stopTest();
    system.assertEquals(500, testRemoved.response_code,returnedLog.message);
    system.assert(returnedLog.message.contains('FATAL_ERROR'));
    system.assert(returnedLog.message.contains('OSS returned: 500'), returnedLog.message);
  }
  static testMethod void test_putTerminalInactive_FAIL(){
    //Need mock response from hts/terminals
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_emptyArray(404));
    Test.setMock(HttpCalloutMock.class, mock);
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.obj_id = 2046;
    testTerm.obj_revision = 4;
    test.startTest();
    testTerm = Service_I2CMFieldSwap.putTerminalInactive(testTerm);
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    test.stopTest();
    system.assertEquals(404, testTerm.response_code);
    system.assertEquals(false, returnedLog.success);
    system.assert(returnedLog.message.contains('FATAL_ERROR'));
    system.assert(returnedLog.message.contains('Could not PUT Terminal to inactive state!'));
  }
  static testMethod void test_deleteTerminal(){
    //Need mock response from hts/terminals
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_emptyArray(204));
    Test.setMock(HttpCalloutMock.class, mock);
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.obj_id = 2046;
    test.startTest();
    testTerm = Service_I2CMFieldSwap.deleteTerminal(testTerm);
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    test.stopTest();
    system.assertEquals(204, testTerm.response_code);
    system.assert(returnedLog.message.contains('METHOD_EXIT'));
    system.assert(returnedLog.message.contains('Returning Terminal Parameters: '));
  }
  static testMethod void test_deleteTerminal_FAIL(){
    //Need mock response from hts/terminals
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_emptyArray(404));
    Test.setMock(HttpCalloutMock.class, mock);
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.obj_id = 2046;
    test.startTest();
    testTerm = Service_I2CMFieldSwap.deleteTerminal(testTerm);
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    test.stopTest();
    system.assertEquals(404, testTerm.response_code);
    system.assertEquals(false, returnedLog.success);
    system.assert(returnedLog.message.contains('FATAL_ERROR'));
    system.assert(returnedLog.message.contains('Could not DELETE Terminal!'));
  }
  static testMethod void test_deleteSubscriber(){
    //Need mock response from hts/terminals
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_emptyArray(204));
    Test.setMock(HttpCalloutMock.class, mock);
    HTSOSS_hts_subscribers testSub = new HTSOSS_hts_subscribers();
    testSub.obj_id = '00000000-0000-0001-0000-000000000001';
    test.startTest();
    testSub = Service_I2CMFieldSwap.deleteSubscriber(testSub);
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    test.stopTest();
    system.assertEquals(204, testSub.response_code);
    system.assertEquals(true, returnedLog.success);
    system.assert(returnedLog.message.contains('METHOD_EXIT'));
    system.assert(returnedLog.message.contains('|Returning Subscriber'));
  }
  static testMethod void test_deleteSubscriber_FAIL(){
    //Need mock response from hts/terminals
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_emptyArray(404));
    Test.setMock(HttpCalloutMock.class, mock);
    HTSOSS_hts_subscribers testSub = new HTSOSS_hts_subscribers();
    testSub.obj_id = '00000000-0000-0001-0000-000000000001';
    test.startTest();
    testSub = Service_I2CMFieldSwap.deleteSubscriber(testSub);
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    test.stopTest();
    system.assertEquals(404, testSub.response_code);
    system.assertEquals(false, returnedLog.success);
    system.assert(returnedLog.message.contains('FATAL_ERROR'));
    system.assert(returnedLog.message.contains('Could not DELETE Subscriber!'));
  }
  static testMethod void test_deleteExistingSubscribers(){
    //Need mock response from hts/subscribers
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_subscribers200());
    mock.addResponse(getMock_subscriberById200());
    mock.addResponse(getMock_subscribers404());
    mock.addResponse(getMock_subscribers404());
    mock.addResponse(getMock_emptyArray(204));

    Test.setMock(HttpCalloutMock.class, mock);
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.terminal_id = '12345678';
    test.startTest();
    Integer i = Service_I2CMFieldSwap.deleteExistingSubscribers(testTerm);
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    test.stopTest();
    system.assertEquals(1, i);
    system.assertEquals(true, returnedLog.success);
    system.assert(returnedLog.message.contains('METHOD_EXIT'));
    system.assert(returnedLog.message.contains('deleteExistingSubscribers(HTSOSS_hts_terminals installedTerminal)|Processed 1 Subscriber Deletions for: '));
    system.assert(returnedLog.message.contains('deleteSubscriber(HTSOSS_hts_subscribers subToDelete)|Returning Subscriber Attributes: '));
  }
  static testMethod void test_deleteExistingSubscribers_ZERO(){
    //Need mock response from hts/terminals
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_subscribers404());
    mock.addResponse(getMock_subscribers404());
    mock.addResponse(getMock_subscribers404());
    Test.setMock(HttpCalloutMock.class, mock);
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.terminal_id = '12345678';
    test.startTest();
    Integer i = Service_I2CMFieldSwap.deleteExistingSubscribers(testTerm);
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    test.stopTest();
    system.assertEquals(0, i);
    system.assertEquals(true, returnedLog.success);
    system.assert(returnedLog.message.contains('WARNING'));
    system.assert(returnedLog.message.contains('Found zero existing subscriptions for: '));
  }
  static testMethod void test_deleteExistingSubscribers_MULTI(){
    //Need mock response from hts/terminals
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_subscribers200());     //GET xxxxxxxx-00
    mock.addResponse(getMock_subscriberById200());  //GET by ID xxxxxxxx-00
    mock.addResponse(getMock_subscribers200());     //GET xxxxxxxx-01
    mock.addResponse(getMock_subscriberById200());  //GET by ID xxxxxxxx-01
    mock.addResponse(getMock_subscribers404());     //GET xxxxxxxx-02
    mock.addResponse(getMock_emptyArray(204));      //DELETE xxxxxxxx-00
    mock.addResponse(getMock_emptyArray(204));      //DELETE xxxxxxxx-01

    Test.setMock(HttpCalloutMock.class, mock);
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.terminal_id = '12345678';
    test.startTest();
    Integer i = Service_I2CMFieldSwap.deleteExistingSubscribers(testTerm);
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    test.stopTest();
    system.assertEquals(2, i);
    system.assertEquals(true, returnedLog.success);
    system.assert(returnedLog.message.contains('WARNING'));
    system.assert(returnedLog.message.contains('Found 2 existing subscriptions for: '));
    system.assert(returnedLog.message.contains('METHOD_EXIT'));
    system.assert(returnedLog.message.contains('deleteExistingSubscribers(HTSOSS_hts_terminals installedTerminal)|Processed 2 Subscriber Deletions for: '));
    system.assert(returnedLog.message.contains('deleteSubscriber(HTSOSS_hts_subscribers subToDelete)|Returning Subscriber Attributes: '));
  }
  static testMethod void test_swapEnabledHardware(){
    map<String, Asset> assetMap = new map<String, Asset>();
    for(Asset a : [SELECT Id, Parent_Asset__c, AccountId, Name 
                            FROM Asset]){
      assetMap.put(a.Name, a);
    }
    //Make the test system look like it's never been provisioned for service....
    list<Asset> updateList = new list<Asset>();
    Asset enabledVTID = assetMap.get('removedVTID');
    enabledVTID.Parent_Asset__c = assetMap.get('removed').Id;
    updateList.add(enabledVTID);
    Asset enabledIP = assetMap.get('removedIP');
    enabledIP.Parent_Asset__c = assetMap.get('removed').Id;
    updateList.add(enabledIP);
    update updateList;
    test.startTest();
    list<Asset> returnedList = Service_I2CMFieldSwap.swapEnabledHardware(
                              assetMap.get('removed'), assetMap.get('instald'));
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    update returnedList;
    test.stopTest();
    map<String, DefaultAccounts__c> settingsMap = DefaultAccounts__c.getAll();
    Id replacedAssets = settingsMap.get('ReplacedAssets').Account_ID__c;
    //Check that all the removed/old Assets are in the replaced Assets Account
    for(Asset a: [SELECT Id, Name, AccountId FROM Asset WHERE Name LIKE 'removed%']){
      if(a.Name == 'removedCore' || a.Name == 'removed'){ //...well except the system!
        system.assertEquals(replacedAssets, a.AccountId, a);
      }
    }
    //Check that all the installed/new Assets are children of the system, and the identifiers are NOT
    map<String, Asset> assetMap2 = new map<String, Asset>();
    for(Asset a : [SELECT Id, Name, AccountId, Parent_Asset__c, Root_Asset__c FROM Asset]){
      assetMap2.put(a.Name, a);
    }
    Asset systemAsset = assetMap2.get('removedFrom');
    system.assertEquals(systemAsset.Id, assetMap2.get('instald').Parent_Asset__c); //Verify installed I2CM is child of system...
    system.assertNotEquals(replacedAssets, assetMap2.get('instald').AccountId);    //Verify installed I2CM is NOT in replaced Assets Account
    system.assertEquals(assetMap2.get('instald').Id, assetMap2.get('instaldCore').Parent_Asset__c);
                                                                                      //Verify that Core Module is child of I2CM...

    Asset removedAsset = assetMap2.get('removed');  //verify removed I2CM remains intact
    system.assertEquals(removedAsset.Id, assetMap2.get('removedVTID').Parent_Asset__c);
    system.assertEquals(removedAsset.Id, assetMap2.get('removedIP').Parent_Asset__c);
    system.assertEquals(removedAsset.Id, assetMap2.get('removedCore').Parent_Asset__c);
  }

  static testMethod void test_swapAssetHardware(){
    map<String, Asset> assetMap = new map<String, Asset>();
    for(Asset a : [SELECT Id, Parent_Asset__c, AccountId, Name 
                            FROM Asset 
                            WHERE Name IN ('instald', 'removed')]){
      assetMap.put(a.Name, a);
    }
    test.startTest();
    list<Asset> returnedList = Service_I2CMFieldSwap.swapAssetHardware(
                              assetMap.get('removed'), assetMap.get('instald'));
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    update returnedList;
    test.stopTest();
    system.debug(returnedList);
    system.debug(returnedLog.message);
    map<String, DefaultAccounts__c> settingsMap = DefaultAccounts__c.getAll();
    Id replacedAssets = settingsMap.get('ReplacedAssets').Account_ID__c;
    //Check that all the removed/old Assets are in the replaced Assets Account
    for(Asset a: [SELECT Id, Name, AccountId FROM Asset WHERE Name LIKE 'removed%']){
      if(a.Name == 'removedCore' || a.Name == 'removed'){ //...well except the system!
        system.assertEquals(replacedAssets, a.AccountId, a);
      }
    }
    //Check that all the installed/new Assets are children of the system, and the identifiers are NOT
    map<String, Asset> installedMap = new map<String, Asset>();
    for(Asset a : [SELECT Id, Name, AccountId, Parent_Asset__c, Root_Asset__c FROM Asset WHERE Name LIKE 'instald%']){
      installedMap.put(a.Name, a);
    }
    Asset systemAsset = [SELECT Id FROM Asset WHERE Name = 'removedFrom' LIMIT 1];
    system.assertEquals(systemAsset.Id, installedMap.get('instald').Parent_Asset__c); //Verify installed I2CM is child of system...
    system.assertNotEquals(replacedAssets, installedMap.get('instald').AccountId);    //Verify installed I2CM is NOT in replaced Assets Account
    system.assertEquals(installedMap.get('instald').Id, installedMap.get('instaldCore').Parent_Asset__c);
                                                                                      //Verify that Core Module is child of I2CM...
    system.assertEquals(replacedAssets, installedMap.get('instaldIP').AccountId);     //Verify IP was removed from installed I2CM...
    system.assertEquals(replacedAssets, installedMap.get('instaldVTID').AccountId);   //Verify IP was removed from installed I2CM...
    system.assertEquals(null, installedMap.get('instaldVTID').Parent_Asset__c);       //Verify VTID has no Parent...
    system.assertEquals(null, installedMap.get('instaldIP').Parent_Asset__c);         //Verify IP has no Parent...
    
  }

  static testMethod void test_retireIdentifiers(){
    Asset instald = [SELECT Id, Parent_Asset__c, AccountId, Name 
                            FROM Asset 
                            WHERE Name = 'instald' LIMIT 1];
    map<String, DefaultAccounts__c> settingsMap = DefaultAccounts__c.getAll();
    Id replacedAssets = settingsMap.get('ReplacedAssets').Account_ID__c;
    test.startTest();
    list<Asset> returnedAssets = Service_I2CMFieldSwap.retireIdentifiers(instald, replacedAssets);
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    
    test.stopTest();
    system.assertEquals(2, returnedAssets.size());
    system.assert(returnedLog.message.contains('Identifiers for ' + 'instald' + ' Retired!'));
  }
  static testMethod void test_retireIdentifiers_WARN(){
    Asset instald = new Asset();
    for(Asset a : [SELECT Id, Parent_Asset__c, AccountId, Name 
                            FROM Asset 
                            WHERE Name LIKE 'instald%']){
      if(a.Name.contains('IP')){
        delete a;
      } else if(a.Name == 'instald'){
        instald = a;
      }
    }
    map<String, DefaultAccounts__c> settingsMap = DefaultAccounts__c.getAll();
    Id replacedAssets = settingsMap.get('ReplacedAssets').Account_ID__c;
    test.startTest();
    list<Asset> returnedAssets = Service_I2CMFieldSwap.retireIdentifiers(instald, replacedAssets);
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    test.stopTest();
    system.assertEquals(1, returnedAssets.size());
    system.assert(returnedLog.message.contains('WARNING'));
    system.assert(returnedLog.message.contains('Found 1 Identifiers (should be 2)!'));
    system.assert(returnedLog.message.contains('Identifiers for ' + 'instald' + ' Retired!'));
  }
  static testMethod void test_validateOldI2CM_ENABLED(){
    system.debug('Testing validateNewI2CM:');
    list<Asset> readList = [SELECT Id, Name FROM Asset 
                        WHERE Name = 'instald'];
    Asset remv = new Asset();
    remv = readList[0];
    test.startTest();
    String resultsString = Service_I2CMFieldSwap.validateOldI2CM(remv);
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success, returnedLog);
    system.assertEquals('Enabled', resultsString);
    system.assert(returnedLog.message.contains('Replacing an un-activated I2CM!'), returnedLog);
  }
  static testMethod void test_validateOldI2CM_ACTIVE(){
    system.debug('Testing validateNewI2CM:');
    list<Asset> readList = [SELECT Id, Name FROM Asset 
                        WHERE Name = 'removed'];
    Asset remv = new Asset();
    remv = readList[0];
    test.startTest();
    String resultsString = Service_I2CMFieldSwap.validateOldI2CM(remv);
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success, returnedLog);
    system.assertEquals('Active', resultsString);
    system.assert(returnedLog.message.contains('Replacing an activated I2CM!'), returnedLog);
  }
  static testMethod void test_validateOldI2CM_ERROR(){
    system.debug('Testing validateNewI2CM:');
    list<Asset> readList = [SELECT Id, Product2.ProductCode, Name FROM Asset 
                        WHERE Name LIKE 'removed%'];
    Asset remv = new Asset();
    
    list<Asset> delList = new list<Asset>();
    for(Asset a : readList){
      if(a.Product2.ProductCode == '19-0955'){
        delList.add(a);
      }
      if(a.Product2.ProductCode == '02-2204-02'){
        remv = a;
      }
    }
    delete(delList);
    test.startTest();
    String resultsString = Service_I2CMFieldSwap.validateOldI2CM(remv);
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    test.stopTest();
    system.assertEquals(false, returnedLog.success, returnedLog);
    system.assertEquals('Error', resultsString);
    system.assert(returnedLog.message.contains('Removed/old I2CM missing 19-0955 (iDirect PCB)'), returnedLog);
  }
  static testMethod void test_validateNewI2CM_OK(){
    system.debug('Testing validateNewI2CM:');
    list<Asset> readList = [SELECT Id, Name FROM Asset 
                        WHERE Name = 'instald'];
    Asset inst = new Asset();
    inst = readList[0];
    test.startTest();
    Boolean resultsBool = Service_I2CMFieldSwap.validateNewI2CM(inst);
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    test.stopTest();
    system.assert(resultsBool);
    system.assert(returnedLog.message.contains('Replacement I2CM Validated OK: '));
  }
  static testMethod void test_validateNewI2CM_FAIL(){
    system.debug('Testing validateNewI2CM:');
    list<Asset> readList = [SELECT Id, Name, Product2.ProductCode FROM Asset 
                        WHERE Name LIKE 'instald%'];
    Asset inst = new Asset();
    inst = readList[0];
    list<Asset> delList = new list<Asset>();
    for(Asset a : readList){
      if(a.Product2.ProductCode != '02-2204-02'){
        delList.add(a);
      }
    }
    delete(delList);
    test.startTest();
    Boolean resultsBool = Service_I2CMFieldSwap.validateNewI2CM(inst);
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    test.stopTest();
    system.assertEquals(false, resultsBool);
    system.assert(returnedLog.message.contains('FATAL_ERROR'));
    system.assert(returnedLog.message.contains('Replacement I2CM missing Virtual Terminal Id'));
    system.assert(returnedLog.message.contains('Replacement I2CM missing HTS IP Address'));
    system.assert(returnedLog.message.contains('Replacement I2CM missing 19-0955 (iDirect PCB)'));
    system.assert(returnedLog.message.contains('Replacement I2CM Validation Failed, missing key components!'));
  }
  static testMethod void test_buildAssetMap_OK(){
    //Need a couple of Assets...
    list<Asset> readList = [SELECT Id, Name FROM Asset 
                            WHERE Name IN ('instald','removed')];
    Asset inst = new Asset();
    Asset remv = new Asset();
    for(Asset a : readList){
      if(a.Name == 'instald'){
        inst.Id = a.Id;
      } else if(a.Name == 'removed'){
        remv.Id = a.Id;
      }
    }
    test.startTest();
    map<String, Asset> returnedMap = Service_I2CMFieldSwap.buildAssetMap(remv, inst);
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    test.stopTest();
    system.assertEquals(2, returnedMap.size());
  }
  static testMethod void test_buildAssetMap_OK_Upart(){
    //Need a couple of Assets...
    list<Asset> readList = [SELECT Id, Name FROM Asset 
                            WHERE Name IN ('instald','removed')];
    list<Product2> uParts = [SELECT Id FROM Product2 WHERE ProductCode = 'U02-2204-02'];
    system.assertEquals(1, uParts.size(), 'Something wrong with test data, only expected a single "U" part');
    Asset inst = new Asset();
    Asset remv = new Asset();
    for(Asset a : readList){
      if(a.Name == 'instald'){
        inst.Id = a.Id;
        inst.Product2Id = uParts[0].Id;
      } else if(a.Name == 'removed'){
        remv.Id = a.Id;
      }
    }
    update inst;
    test.startTest();
    map<String, Asset> returnedMap = Service_I2CMFieldSwap.buildAssetMap(remv, inst);
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    test.stopTest();
    system.assertEquals(2, returnedMap.size());
  }
  static testMethod void test_buildAssetMap_NOTI2CM(){
    //Need a couple of Assets...
    list<Asset> readList = [SELECT Id, Name FROM Asset];
    Asset inst = new Asset();
    Asset remv = new Asset();
    for(Asset a : readList){
      if(a.Name == 'instald'){
        inst = a;
      } else if(a.Name == 'removedFrom'){
        remv = a;
      }
    }
    test.startTest();
    map<String, Asset> returnedMap = Service_I2CMFieldSwap.buildAssetMap(remv, inst);
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    test.stopTest();
    system.assertNotEquals(2, returnedMap.size());
    system.assert(returnedLog.message.contains('FATAL_ERROR'));
    system.assert(returnedLog.message.contains('Input Parameter is not an I2CM: '), returnedLog.message);    
  }
  static testMethod void test_buildAssetMap_NOSYSTEM(){
    //Need a couple of Assets...
    list<Asset> readList = [SELECT Id, Name FROM Asset];
    Asset inst = new Asset();
    Asset remv = new Asset();
    for(Asset a : readList){
      if(a.Name == 'instald'){
        inst = a;
      } else if(a.Name == 'removed'){
        a.Parent_Asset__c = null;
        remv = a;
      }
    }
    update readList;
    test.startTest();
    map<String, Asset> returnedMap = Service_I2CMFieldSwap.buildAssetMap(remv, inst);
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    test.stopTest();
    system.assertNotEquals(2, returnedMap.size());
    system.assert(returnedLog.message.contains('FATAL_ERROR'));
    system.assert(returnedLog.message.contains('is not the Child of an HTS System: '), returnedLog.message);    
  }
  static testMethod void test_buildAssetMap_MAPOF1(){
    //Need a couple of Assets...
    list<Asset> readList = [SELECT Id, Name FROM Asset];
    Asset inst = new Asset();
    Asset remv = new Asset();
    for(Asset a : readList){
      if(a.Name == 'instald'){
        inst = a;
      } else if(a.Name == 'removed'){
        remv = a;
      }
    }
    inst.id = null;
    test.startTest();
    map<String, Asset> returnedMap = Service_I2CMFieldSwap.buildAssetMap(remv, inst);
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    test.stopTest();
    system.assertNotEquals(2, returnedMap.size());
    system.assert(returnedLog.message.contains('FATAL_ERROR'));
    system.assert(returnedLog.message.contains('Could not build Asset Map with exactly 2 members!'), returnedLog.message);    
  }
  static testMethod void test_buildAssetMap_NOTTOP(){
    //Need a couple of Assets...
    list<Asset> readList = [SELECT Id, Name, Parent_Asset__c FROM Asset];
    Asset inst = new Asset();
    Asset remv = new Asset();
    for(Asset a : readList){
      if(a.Name == 'instald'){
        inst = a;
      } else if(a.Name == 'removed'){
        remv = a;
      }
    }
    inst.Parent_Asset__c = remv.Parent_Asset__c;
    update inst;
    test.startTest();
    map<String, Asset> returnedMap = Service_I2CMFieldSwap.buildAssetMap(remv, inst);
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    test.stopTest();
    system.assertNotEquals(2, returnedMap.size());
    system.assert(returnedLog.message.contains('FATAL_ERROR'));
    system.assert(returnedLog.message.contains('is not a Top Level Asset!'), returnedLog.message);    
  }
  static testMethod void test_preProcessValidation_NULLID(){
    //Need a couple of Assets...
    list<Asset> readList = [SELECT Id, Name FROM Asset];
    Asset inst = new Asset();
    Asset remv = new Asset();
    for(Asset a : readList){
      if(a.Name == 'instald'){
        inst = a;
      } else if(a.Name == 'removed'){
        remv = a;
      }
    }
    inst.id = null;
    test.startTest();
    Service_I2CMFieldSwap.preProcessValidation(remv, inst);
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    test.stopTest();
    system.assert(returnedLog.message.contains('FATAL_ERROR'));
    system.assert(returnedLog.message.contains('Null Asset Record Id detected!'), returnedLog.message);    
  }
  static testMethod void test_preProcessValidation_SAMEASSET(){
    //Need a couple of Assets...
    list<Asset> readList = [SELECT Id, Name FROM Asset];
    Asset inst = new Asset();
    Asset remv = new Asset();
    for(Asset a : readList){
      if(a.Name == 'instald'){
        inst = a;
      } else if(a.Name == 'removed'){
        remv = a;
      }
    }
    test.startTest();
    Service_I2CMFieldSwap.preProcessValidation(remv, remv);
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    test.stopTest();
    system.assert(returnedLog.message.contains('FATAL_ERROR'));
    system.assert(returnedLog.message.contains('Removed and Installed Assets cannot be the same Asset!'), returnedLog.message);    
  }
  static testMethod void test_preProcessValidation_OK(){
    //Need a couple of Assets...
    list<Asset> readList = [SELECT Id, Name FROM Asset];
    Asset inst = new Asset();
    Asset remv = new Asset();
    for(Asset a : readList){
      if(a.Name == 'instald'){
        inst = a;
      } else if(a.Name == 'removed'){
        remv = a;
      }
    }
    test.startTest();
    Service_I2CMFieldSwap.preProcessValidation(remv, inst);
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    test.stopTest();
    system.assert(returnedLog.message.contains('METHOD_EXIT'));
    system.assert(returnedLog.message.contains('Validation complete for removed: '), returnedLog.message);
  }
  static testMethod void test_returnFatalError(){
    test.startTest();
    serviceResults returnedLog = Service_I2CMFieldSwap.returnFatalError();
    test.stopTest();
    system.assert(returnedLog.message.contains('I2CM Field Swap Service failed'+
                            ' to complete successfully. See log for details.'), returnedLog.message);
    Case c = [SELECT ID, Subject, Status, Origin, RecordTypeId, Description, CaseNumber FROM Case LIMIT 1];
    system.assertEquals(ServCloud_RECORD_TYPE_ID, c.RecordTypeId);
    system.assertEquals('Fatal Error in Service_I2CMFieldSwap Class', c.Subject);
    system.assertEquals('System Generated', c.Origin);
    system.assertEquals('New', c.Status);
  }
  static testMethod void test_enqueueIdentifiersJob(){
    //Need mock response from hts/satelliterouters etc...
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_CoreIdList_OK());
    mock.addResponse(getMock_postTermAsynch_OK());
    mock.addResponse(getMock_postSubscriber_OK());
    Test.setMock(HttpCalloutMock.class, mock);
    list<Asset> readList = [SELECT Id, Name, Parent_Asset__c FROM Asset WHERE Name = 'removed'];
    system.assertEquals(1, readList.size(), readList);
    
    insert new HTS_IP_Address__c(HTS_IP_HEX_Address__c = '0A.53.53.00', HTS_IP_Address__c = '10.83.83.0', Management_IP_Address__c = '10.242.2.5');
    insert new HTS_Virtual_Terminal_ID__c(Virtual_Terminal_Id__c = '99999901');
    
    insert new HTS_Terminal_Template__c(obj_id__c='CONUS_STANDARD', isDefault__c=true, Name='CONUS_STANDARD');
    test.startTest();
    Id returnedJob = Service_I2CMFieldSwap.enqueueIdentifiersJob(readList[0]);
    serviceResults returnedLog = Service_I2CMFieldSwap.getLog();
    test.stopTest();
    system.assert(returnedLog.message.contains('METHOD_EXIT'));
    system.assert(returnedLog.message.contains('Successful Job ID: '), returnedLog.message); 
    system.debug(returnedLog);
  }
  
  //test methods for integration testing...
  static testMethod void test_swapI2CMs(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //get Core Id (installed)...
    mock.addResponse(getMock_CoreIdList_OK());
    //get OSS Terminal Parameters (installed)...
    mock.addResponse(getMock_terminalListOf1());
    mock.addResponse(getMock_terminalParams());
    //put Terminal Inactive (installed)...
    mock.addResponse(getMock_emptyArray(204));
    //delete Terminal (installed)...
    mock.addResponse(getMock_emptyArray(204));
    //delete existing subscribers (installed)...
    mock.addResponse(getMock_subscribers200());
    mock.addResponse(getMock_subscriberById200());
    mock.addResponse(getMock_subscribers404());
    mock.addResponse(getMock_subscribers404());
    //(followed by delete subscriber (installed))
    mock.addResponse(getMock_emptyArray(204));
    //get Core Id (removed)...
    mock.addResponse(getMock_CoreIdList_OK());
    //get OSS Terminal Parameters (removed)...
    mock.addResponse(getMock_terminalListOf1());
    mock.addResponse(getMock_terminalParams());
    //update Terminal via PUT (removed)...
    mock.addResponse(getMock_emptyArray(204));
    //Callouts for enqueued job
    mock.addResponse(getMock_CoreIdList_OK());
    mock.addResponse(getMock_postTermAsynch_OK());
    mock.addResponse(getMock_postSubscriber_OK());
    Test.setMock(HttpCalloutMock.class, mock);
    //PHEW!
    //Now get some Assets...
    list<Asset> readList = [SELECT Id, Name FROM Asset 
                            WHERE Name IN ('instald','removed')];
    Asset inst = new Asset();
    Asset remv = new Asset();
    for(Asset a : readList){
      if(a.Name == 'instald'){
        inst.Id = a.Id;
      } else if(a.Name == 'removed'){
        remv.Id = a.Id;
      }
    }
    test.startTest();
    serviceResults returnedLog = Service_I2CMFieldSwap.swapI2CMs(remv, inst);
    test.stopTest();
    system.assert(returnedLog.success, returnedLog.message);
  }
  static testMethod void test_swapI2CMs_uPart(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //get Core Id (installed)...
    mock.addResponse(getMock_CoreIdList_OK());
    //get OSS Terminal Parameters (installed)...
    mock.addResponse(getMock_terminalListOf1());
    mock.addResponse(getMock_terminalParams());
    //put Terminal Inactive (installed)...
    mock.addResponse(getMock_emptyArray(204));
    //delete Terminal (installed)...
    mock.addResponse(getMock_emptyArray(204));
    //delete existing subscribers (installed)...
    mock.addResponse(getMock_subscribers200());
    mock.addResponse(getMock_subscriberById200());
    mock.addResponse(getMock_subscribers404());
    mock.addResponse(getMock_subscribers404());
    //(followed by delete subscriber (installed))
    mock.addResponse(getMock_emptyArray(204));
    //get Core Id (removed)...
    mock.addResponse(getMock_CoreIdList_OK());
    //get OSS Terminal Parameters (removed)...
    mock.addResponse(getMock_terminalListOf1());
    mock.addResponse(getMock_terminalParams());
    //update Terminal via PUT (removed)...
    mock.addResponse(getMock_emptyArray(204));
    //Callouts for enqueued job
    mock.addResponse(getMock_CoreIdList_OK());
    mock.addResponse(getMock_postTermAsynch_OK());
    mock.addResponse(getMock_postSubscriber_OK());
    Test.setMock(HttpCalloutMock.class, mock);
    //PHEW!
    //Now get some Assets...
    list<Asset> readList = [SELECT Id, Name FROM Asset 
                            WHERE Name IN ('instald','removed')];
    list<Product2> uParts = [SELECT Id FROM Product2 WHERE ProductCode = 'U02-2204-02'];
    system.assertEquals(1, uParts.size(), 'Something wrong with test data, only expected a single "U" part');
    Asset inst = new Asset();
    Asset remv = new Asset();
    for(Asset a : readList){
      if(a.Name == 'instald'){
        inst.Id = a.Id;
        inst.Product2Id = uParts[0].Id;
      } else if(a.Name == 'removed'){
        remv.Id = a.Id;
      }
    }
    update inst;
    test.startTest();
    serviceResults returnedLog = Service_I2CMFieldSwap.swapI2CMs(remv, inst);
    test.stopTest();
    system.assert(returnedLog.success, returnedLog.message);
  }
  static testMethod void test_swapI2CMs_ENABLED(){
    map<String, Asset> assetMap = new map<String, Asset>();
    for(Asset a : [SELECT Id, Parent_Asset__c, AccountId, Name 
                            FROM Asset]){
      assetMap.put(a.Name, a);
    }
    //Make the test system look like it's never been provisioned for service....
    list<Asset> updateList = new list<Asset>();
    Asset enabledVTID = assetMap.get('removedVTID');
    enabledVTID.Parent_Asset__c = assetMap.get('removed').Id;
    updateList.add(enabledVTID);
    Asset enabledIP = assetMap.get('removedIP');
    enabledIP.Parent_Asset__c = assetMap.get('removed').Id;
    updateList.add(enabledIP);
    update updateList;
    Asset inst = new Asset();
    Asset remv = new Asset();
    inst.Id = assetMap.get('instald').Id;
    remv.Id = assetMap.get('removed').Id;
    test.startTest();
    serviceResults returnedLog = Service_I2CMFieldSwap.swapI2CMs(remv, inst);
    test.stopTest();
    system.assert(returnedLog.success, returnedLog.message);
  }

  /********************************************************
   *setup methods for commonly used HTTP mock responses....
   ********************************************************/
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
  static HttpResponse getMock_CoreId_OK(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    returnMock.setBody('{"chip_sn": "1111111112",' + 
                        '"model": "X7",' +
                        '"obj_id": 2121,' +
                        '"obj_name": "A_SROUTE_TEST_0000002",' +
                        '"obj_revision": 1,' +
                        '"serialnumber": 66667}');
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
  static HttpResponse getMock_emptyArray(integer statusCode){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(statusCode);
    String bodyString = '[]';
    returnMock.setBody(bodyString);
    return returnMock;
  }
  static HttpResponse getMock_subscribers404(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(404);
    String bodyString = '{"message": "The specified subscriber does not exist.'+
                    ' You have requested this URI [/api/1.0/hts/subscribers/]' +
                    ' but did you mean /api/1.0/hts/subscribers/<string:id> ' +
                    'or /api/1.0/hts/cacher/subscribers or ' +
                    '/api/1.0/hts/cacher/subscriberattributes ?"}';
    returnMock.setBody(bodyString);
    return returnMock;
  }
  static HttpResponse getMock_subscribers200(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    String bodyString = '[{"subscriber_plan_id": "Enabled", ' +
                          '"subscriber_id": "12345678-00", ' +
                          '"obj_id": "00000000-0000-0001-0000-000000000f4a"}]';
    returnMock.setBody(bodyString);
    return returnMock;
  }
  static HttpResponse getMock_subscriberById200(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    String bodyString =  '{"subscriber_plan_id": "Enabled", ' +
                          '"subscriber_id": "12345678-00", ' +
                          '"subscriber_ip_addresses": ["10.64.64.0/24"], ' +
                          '"obj_id": "00000000-0000-0001-0000-000000000001", ' +
                          '"status": "Active"}';
    returnMock.setBody(bodyString);
    return returnMock;
  }
  static HttpResponse getMock_postTermAsync(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    String bodyString = '{"obj_id": "27ac7732-ef79-40b5-a634-1a2bf950aefe"}';
    returnMock.setBody(bodyString);
    return returnMock;
  }
  static HttpResponse getMock_postTermAsynch_OK(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    returnMock.setBody('{"obj_id": "14264295-7d0e-4a66-b7bb-9c37fab821e5"}');
    return returnMock;
  }
  static HttpResponse getMock_postSubscriber_OK(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(201);
    returnMock.setBody('{"subscriber_plan_id":"Enabled","subscriber_ip_addresses":["10.83.7.0/24"],"subscriber_id":"99997101-00"}');
    return returnMock;
  }
}