@isTest
private class LTE_devices_mfg_test {
  static string lteRootString = '01-0419';
  
  @testSetup static void setupTestData(){
    //setup common test data here
    //Need that "default Account" custom setting
    Account testAccount = new Account(Name='Test Account');
    insert testAccount;
    DefaultAccounts__c insertSetting = new DefaultAccounts__c();
    //insertSetting.Account_ID__c = '001000000000000000';
    insertSetting.Account_ID__c = testAccount.Id;
    insertSetting.Description__c = 'This is a list of Accounts used for special/default purposes. e.g. Activations in Progress, Default Assets, Replaced Assets....';
    insertSetting.Name = 'DefaultAssets';
    insert insertSetting;
    //Need a couple of Products
    //TODO: setup MAX_LOOP_COUNTER and loopify...
    list<Product2> testProds = new list<Product2>();
    //There is a dependancy on the Custom Metadata details
    testProds.add(new Product2(Name='01-0419', ProductCode = '01-0419', Product_Id__c = '01-0419_US'));
    testProds.add(new Product2(Name='02-2280', ProductCode = '02-2280', Product_Id__c = '02-2280_US'));
    testProds.add(new Product2(Name='19-1027', ProductCode = '19-1027', Product_Id__c = '19-1027_US'));
    testProds.add(new Product2(Name='19-1035', ProductCode = '19-1035', Product_Id__c = '19-1035_US'));
    insert testProds;

    list<Asset> insertList = new list<Asset>();
    for(Product2 p : [SELECT id, Name, ProductCode, Product_Id__c FROM Product2]){
      insertList.add(new Asset(Name = p.Name,
                               Product2Id = p.id,
                               Asset_Id__c = p.Product_Id__c + '_' + p.Name,
                               AccountId = testAccount.Id));
    }
    insert insertList;
    //now to setup the Hierarchy... start with a map
    list<Asset> assetList = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
                                 Product2.ProductCode FROM Asset];
    map<String, Asset> assetMap = new map<String, Asset>();
    for(asset a : assetList){
      assetMap.put(a.Name, a);
    }
    //now arrange Parents and children
    assetList.clear();
    assetMap.get('02-2280').Parent_Asset__c = assetMap.get('01-0419').Id;
    assetMap.get('19-1027').Parent_Asset__c = assetMap.get('02-2280').Id;
    assetMap.get('19-1035').Parent_Asset__c = assetMap.get('02-2280').Id;
    assetList = assetMap.values();
    update assetList;
  }

  static testMethod void testSetupData(){
    //use this method to validate that you have test data setup correctly
    //use this method to validate that you have test data setup correctly
    DefaultAccounts__c defAcct =  DefaultAccounts__c.getValues('DefaultAssets');
    Account a = [SELECT Id FROM Account LIMIT 1];
    system.assertEquals(a.id, defAcct.Account_ID__c);
    list<Product2> testProds = [SELECT Id, Name, ProductCode FROM Product2];
    system.assertEquals(4, testProds.size());
    list<Asset> readAssets = [SELECT Id, Name FROM Asset];
    system.assertEquals(4, readAssets.size());
  }

  static testMethod void test_templateSearch(){
    test.startTest();
    list<Asset_Hierarchy_Template__mdt> returnList 
      = LTE_devices_mfg.templateSearch(lteRootString);
    test.stopTest();
    system.assert(returnList.size() > 1);
  }
  static testMethod void test_populatePartNumSet(){
    //Need a list of an AssetDetails Class...
    list<LTE_devices_mfg.AssetDetails> inputList
      = getMockUserInput();
    test.startTest();
    set<String> returnedSet 
      = LTE_devices_mfg.populatePartNumSet(inputList);
    test.stopTest();
    system.assert(returnedSet.contains('01-0419'));
    system.assert(returnedSet.contains('02-2280'));
    system.assert(returnedSet.contains('19-1027'));
    system.assert(returnedSet.contains('19-1035'));
    system.assert(LTE_devices_mfg.partNumSet.contains('01-0419'));
    system.assert(LTE_devices_mfg.partNumSet.contains('02-2280'));
    system.assert(LTE_devices_mfg.partNumSet.contains('19-1027'));
    system.assert(LTE_devices_mfg.partNumSet.contains('19-1035'));
  }
  static testMethod void test_populateProductMap(){
    set<String> inputSet = new set<String>{'01-0419', '02-2280'};
    test.startTest();
    map<String, Product2> returnedMap 
      = LTE_devices_mfg.populateProductMap(inputSet);
    test.stopTest();
    system.assert(returnedMap.containsKey('01-0419'));
    system.assert(returnedMap.containsKey('02-2280'));
    system.assertEquals('01-0419_US', 
      LTE_devices_mfg.productMap.get('01-0419').Product_Id__c);
    system.assertEquals('02-2280_US', 
      LTE_devices_mfg.productMap.get('02-2280').Product_Id__c);
  }
  static testMethod void test_generateOneAsset(){
    //Need a list of an AssetDetails Class...
    list<LTE_devices_mfg.AssetDetails> inputList
      = getMockUserInput();
    LTE_devices_mfg.populatePartNumSet(inputList);
    map<String, Product2> testProdMap 
      = LTE_devices_mfg.populateProductMap(LTE_devices_mfg.partNumSet);
    test.startTest();
    Asset returnedAsset = LTE_devices_mfg.GenerateOneAsset(inputList[1]);
    test.stopTest();
    system.assertEquals('180400002',returnedAsset.name);
    system.assertEquals('180400002',returnedAsset.SerialNumber);
    system.assertEquals('02-2280_US_180400002',returnedAsset.Asset_Id__c);
    system.assertEquals(testProdMap.get('02-2280').Id,returnedAsset.Product2Id);
  }
  static testMethod void test_setupHierarchy(){
    //Need a list of Asset for input
    list<Asset> assetList = [SELECT id, Name, Product2.ProductCode, Asset_ID__c,
                                    Parent_Asset__c
                             FROM Asset];
    //Need a list of an AssetDetails Class...
    list<LTE_devices_mfg.AssetDetails> inputList
      = getMockUserInput();
    test.startTest();
    list<Asset> outputList = LTE_devices_mfg.setupHierarchy(assetList, inputList);
    test.stopTest();
    map<String, Asset> assetMap = new map<String, Asset>();
    for(Asset a : outputList){
      assetMap.put(a.Asset_Id__c.substringBefore('_US_'), a);
    }
    for(Asset a : outputList){
      if(a.Asset_Id__c.substringBefore('_US_') == '01-0419'){
        system.assertEquals(null, a.Parent_Asset__c);
      } else if(a.Asset_Id__c.substringBefore('_US_') == '02-2280'){
        system.assertEquals(assetMap.get('01-0419').id, a.Parent_Asset__c);
      } else if(a.Asset_Id__c.substringBefore('_US_') == '19-1035'){
        system.assertEquals(assetMap.get('02-2280').id, a.Parent_Asset__c);
      } else if(a.Asset_Id__c.substringBefore('_US_') == '19-1027'){
        system.assertEquals(assetMap.get('02-2280').id, a.Parent_Asset__c);
      } else {
        system.assert(false, a.Asset_Id__c); //something went terribly wrong!!
      }
    }
  }
  static testMethod void test_createAssets_OK(){
    string inputJSON = '';
    inputJSON = inputJSON + '[';
    inputJSON = inputJSON + '  {"partNumber":"01-0419","description":"System","name":"180400001"},';
    inputJSON = inputJSON + '  {"partNumber":"02-2280","description":"Antenna","parentPartNumber":"01-0419","name":"180400002"},';
    inputJSON = inputJSON + '  {"partNumber":"19-1027","description":"Modem","parentPartNumber":"02-2280","name":"2934-B1B5-FFB4"},';
    inputJSON = inputJSON + '  {"partNumber":"19-1035","description":"SIM","parentPartNumber":"02-2280","name":"8901260882223505766F"}';
    inputJSON = inputJSON + ']';
    //Need to clear out all the Asset before proceeding....
    list<Asset> delList = [SELECT Id FROM Asset];
    delete delList;
    test.startTest();
    LTE_devices_mfg returnedObj = LTE_devices_mfg.createAssets(inputJSON);
    test.stopTest();
    //test returned list....
    map<String, Asset> assetMap = new map<String, Asset>();
    for(Asset a : returnedObj.lteAssets){
      assetMap.put(a.Asset_Id__c.substringBefore('_US_'), a);
    }
    for(Asset a : returnedObj.lteAssets){
      if(a.Asset_Id__c.substringBefore('_US_') == '01-0419'){
        system.assertEquals(null, a.Parent_Asset__c);
      } else if(a.Asset_Id__c.substringBefore('_US_') == '02-2280'){
        system.assertEquals(assetMap.get('01-0419').id, a.Parent_Asset__c);
      } else if(a.Asset_Id__c.substringBefore('_US_') == '19-1035'){
        system.assertEquals(assetMap.get('02-2280').id, a.Parent_Asset__c);
      } else if(a.Asset_Id__c.substringBefore('_US_') == '19-1027'){
        system.assertEquals(assetMap.get('02-2280').id, a.Parent_Asset__c);
      } else {
        system.assert(false, a.Asset_Id__c); //something went terribly wrong!!
      }
    }
    //test inserted list
    list<Asset> readList = new list<Asset>();
    assetMap.clear();
    readList = [SELECT id, Name, Product2.ProductCode, Asset_ID__c,
                                    Parent_Asset__c
                             FROM Asset];
    for(Asset a : readList){
      assetMap.put(a.Asset_Id__c.substringBefore('_US_'), a);
    }
    for(Asset a : readList){
      if(a.Asset_Id__c.substringBefore('_US_') == '01-0419'){
        system.assertEquals(null, a.Parent_Asset__c, a);
      } else if(a.Asset_Id__c.substringBefore('_US_') == '02-2280'){
        //system.assertEquals(assetMap.get('01-0419').id, a.Parent_Asset__c, a);
      } else if(a.Asset_Id__c.substringBefore('_US_') == '19-1035'){
        system.assertEquals(assetMap.get('02-2280').id, a.Parent_Asset__c, a);
      } else if(a.Asset_Id__c.substringBefore('_US_') == '19-1027'){
        system.assertEquals(assetMap.get('02-2280').id, a.Parent_Asset__c, a);
      } else {
        system.assert(false, a.Asset_Id__c); //something went terribly wrong!!
      }
    }
  }
  static testMethod void test_createAssets_DUPE(){
    Asset dupe = [SELECT Id, Name FROM Asset LIMIT 1];
    dupe.name = '2934-B1B5-FFB4';
    update dupe;
    string inputJSON = '';
    inputJSON = inputJSON + '[';
    inputJSON = inputJSON + '  {"partNumber":"01-0419","description":"System","name":"180400001"},';
    inputJSON = inputJSON + '  {"partNumber":"02-2280","description":"Antenna","parentPartNumber":"01-0419","name":"180400002"},';
    inputJSON = inputJSON + '  {"partNumber":"19-1027","description":"Modem","parentPartNumber":"02-2280","name":"2934-B1B5-FFB4"},';
    inputJSON = inputJSON + '  {"partNumber":"19-1035","description":"SIM","parentPartNumber":"02-2280","name":"8901260882223505766F"}';
    inputJSON = inputJSON + ']';
    //Need to clear out all the Asset before proceeding....
    //list<Asset> delList = [SELECT Id FROM Asset];
    //delete delList;
    test.startTest();
    LTE_devices_mfg returnedObj = LTE_devices_mfg.createAssets(inputJSON);
    test.stopTest();
    //test returned list....
    system.assertEquals(1, returnedObj.lteAssets.size());
  }
  static testMethod void test_postLTEDevice_OK(){
    QueueHttpMock mock = new QueueHttpMock();
    //Need mock response from /lte/organizations/{org_id}/groups?name=...
    mock.addResponse(getMock_getGroupByOrgId_FILTERED_OK());
    //Need mock response from POST /lte/devices/{org_id}/{group_id}...
    mock.addResponse(getMock_postToOSS_OK());
    Test.setMock(HttpCalloutMock.class, mock);
    string inputJSON = '';
    inputJSON = inputJSON + '[';
    inputJSON = inputJSON + '  {"partNumber":"01-0419","description":"System","name":"180400001"},';
    inputJSON = inputJSON + '  {"partNumber":"02-2280","description":"Antenna","parentPartNumber":"01-0419","name":"180400002"},';
    inputJSON = inputJSON + '  {"partNumber":"19-1027","description":"Modem","parentPartNumber":"02-2280","name":"2934-B1B5-FFB4"},';
    inputJSON = inputJSON + '  {"partNumber":"19-1035","description":"SIM","parentPartNumber":"02-2280","name":"8901260882223505766F"}';
    inputJSON = inputJSON + ']';
    LTE_devices_mfg returnedObj = LTE_devices_mfg.createAssets(inputJSON);
    test.startTest();
    String returnedString = LTE_devices_mfg.postLTEDevice(returnedObj.lteAssets);
    test.stopTest();
    system.assertEquals('SUCCESS:', returnedString.left(8));
  }
  static testMethod void test_postLTEDevice_500(){
    QueueHttpMock mock = new QueueHttpMock();
    //Need mock response from /lte/organizations/{org_id}/groups?name=...
    mock.addResponse(getMock_error_500());
    Test.setMock(HttpCalloutMock.class, mock);
    string inputJSON = '';
    inputJSON = inputJSON + '[';
    inputJSON = inputJSON + '  {"partNumber":"01-0419","description":"System","name":"180400001"},';
    inputJSON = inputJSON + '  {"partNumber":"02-2280","description":"Antenna","parentPartNumber":"01-0419","name":"180400002"},';
    inputJSON = inputJSON + '  {"partNumber":"19-1027","description":"Modem","parentPartNumber":"02-2280","name":"2934-B1B5-FFB4"},';
    inputJSON = inputJSON + '  {"partNumber":"19-1035","description":"SIM","parentPartNumber":"02-2280","name":"8901260882223505766F"}';
    inputJSON = inputJSON + ']';
    LTE_devices_mfg returnedObj = LTE_devices_mfg.createAssets(inputJSON);
    test.startTest();
    String returnedString = LTE_devices_mfg.postLTEDevice(returnedObj.lteAssets);
    test.stopTest();
    system.assertEquals('ERROR:', returnedString.left(6));
  }
  static testMethod void test_checkForDupeAssets(){
    Asset dupe = [SELECT Id, Name FROM Asset LIMIT 1];
    dupe.name = '2934-B1B5-FFB4';
    update dupe;
    string inputJSON = '';
    inputJSON = inputJSON + '[';
    inputJSON = inputJSON + '  {"partNumber":"01-0419","description":"System","name":"180400001"},';
    inputJSON = inputJSON + '  {"partNumber":"02-2280","description":"Antenna","parentPartNumber":"01-0419","name":"180400002"},';
    inputJSON = inputJSON + '  {"partNumber":"19-1027","description":"Modem","parentPartNumber":"02-2280","name":"2934-B1B5-FFB4"},';
    inputJSON = inputJSON + '  {"partNumber":"19-1035","description":"SIM","parentPartNumber":"02-2280","name":"8901260882223505766F"}';
    inputJSON = inputJSON + ']';
    list<LTE_devices_mfg.AssetDetails> detailsList 
     = (list<LTE_devices_mfg.AssetDetails>)JSON.deserialize(inputJSON, list<LTE_devices_mfg.AssetDetails>.class);
    test.startTest();
    list<Asset> returnList = LTE_devices_mfg.checkForDupeAssets(detailsList);
    test.stopTest();
    system.assertEquals(1, returnList.size());
  }
  static testMethod void test_getHierarchy_OK(){
    Asset inputAsset = [SELECT Id FROM Asset LIMIT 1];
    test.startTest();
    LTE_devices_mfg returnedObj = LTE_devices_mfg.getHierarchy(inputAsset.Id);
    test.stopTest();
    system.assertEquals(4, returnedObj.lteAssets.size());
  }
  static testMethod void test_getHierarchy_FAIL(){
    Asset inputAsset = [SELECT Id FROM Asset LIMIT 1];
    String inputId = inputAsset.Id;
    delete inputAsset;
    test.startTest();
    LTE_devices_mfg returnedObj = LTE_devices_mfg.getHierarchy(inputId);
    test.stopTest();
    system.assertEquals(0, returnedObj.lteAssets.size());
    system.assertEquals('COULD NOT ISOLATE INPUT ASSET!', returnedObj.serverResults);
  }

  //helper methods
  static list<LTE_devices_mfg.AssetDetails> getMockUserInput(){
    //Need a list of an AssetDetails Class...
    list<LTE_devices_mfg.AssetDetails> inputList
      = new list<LTE_devices_mfg.AssetDetails>();
    
    LTE_devices_mfg.AssetDetails inputObj1
      = new LTE_devices_mfg.AssetDetails();
    inputObj1.partNumber = '01-0419';
    inputObj1.description = 'LTE System';
    inputObj1.name = '180400001';
    inputList.add(inputObj1);

    LTE_devices_mfg.AssetDetails inputObj2
      = new LTE_devices_mfg.AssetDetails();
    inputObj2.partNumber = '02-2280'; 
    inputObj2.description = 'LTE Dome';
    inputObj2.parentPartNumber = '01-0419';
    inputObj2.name = '180400002';
    inputList.add(inputObj2);

    LTE_devices_mfg.AssetDetails inputObj3
      = new LTE_devices_mfg.AssetDetails();
    inputObj3.partNumber = '19-1027'; 
    inputObj3.description = 'LTE Modem';
    inputObj3.parentPartNumber = '02-2280';
    inputObj3.name = '2934-B1B5-FFB4';
    inputList.add(inputObj3);

    LTE_devices_mfg.AssetDetails inputObj4
      = new LTE_devices_mfg.AssetDetails();
    inputObj4.partNumber = '19-1035'; 
    inputObj4.description = 'LTE SIM';
    inputObj4.parentPartNumber = '02-2280';
    inputObj4.name = '8901260882223505766F';
    inputList.add(inputObj4);

    return inputList;
  }
  /*****************************************************************************
   * setup methods for commonly used HTTP mock responses....
   ****************************************************************************/
  static HttpResponse getMock_getGroupByOrgId_FILTERED_OK(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    returnMock.setBody('[{"id": 131,"name": "2933-BAD9-E505"}]');
    return returnMock;
  }
  static HttpResponse getMock_postToOSS_OK(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(201);
    return returnMock;
  }
  static HttpResponse getMock_error_500(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(500);
    returnMock.setBody('{"message": "this is a mock error message"}');
    return returnMock;
  }
}