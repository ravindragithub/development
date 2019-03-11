@isTest
private class HTS_ltgsvc_diagnostics_test {
  //might not need record types...
  //private static final Id AirTime_Contract_RECORD_TYPE_ID = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Airtime Contract').getRecordTypeId();

  @testSetup static void setupTestData(){
    //Gonna need an Asset Hierarchy....
    //Which means we are gonna need Products and such
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
    Product2 systemLevel = new Product2(Name = 'TPV7-HTS W/I2CM ANT W/LBL', ProductCode = '01-0408-15', Product_ID__c='01-0408-15_US');
    testProds.add(systemLevel);

    Product2 htsAntenna = new Product2(Name = 'ASSY ANT PKG W/LBL V7IP HTS', ProductCode = '02-1925-01SL', Product_ID__c='02-1925-01SL_US');
    testProds.add(htsAntenna);
    Product2 gprsModule = new Product2(Name = 'ASSY GPRS MODEM TVHD11', ProductCode = '02-1858', Product_ID__c='02-1858_US');
    testProds.add(gprsModule);

    Product2 i2cmProd = new Product2(Name = 'I2CM', ProductCode = '02-2204-02', Product_ID__c='02-2204-02_US');
    testProds.add(i2cmProd);
    Product2 satRouterProd = new Product2(Name = 'INTEGRATED ROUTER CX700 I2CM', ProductCode = '19-0955', Product_ID__c='19-0955_US');
    testProds.add(satRouterProd);
    Product2 child1 = new Product2(Name = 'MTA', ProductCode = '19-0504', Product_ID__c='19-0504_US');
    testProds.add(child1);
    Product2 child2 = new Product2(Name = 'ADMIN IP', ProductCode = 'ADMIN IP', Product_ID__c='ADMIN IP_US');
    testProds.add(child2);
    Product2 child3 = new Product2(Name = 'CBX LIC', ProductCode = 'CBX LICENSE', Product_ID__c='CBX LICENSE_US');
    testProds.add(child3);
    Product2 htsIpProd = new Product2(Name = 'HTS IP', ProductCode = 'HTS IP Address', Product_ID__c='HTS IP Address_US');
    testProds.add(htsIpProd);
    Product2 vtidProd = new Product2(Name = 'VTID', ProductCode = 'Virtual Terminal ID', Product_ID__c='Virtual Terminal ID_US');
    testProds.add(vtidProd);

    Product2 provKeyProd = new Product2(Name = 'iDirect Provisioning Key', ProductCode = 'iDirect Provisioning Key', Product_ID__c='iDirect Provisioning Key_US');
    testProds.add(provKeyProd);
    insert testProds;

    //start creating Assets
    list<Asset> insertList = new list<Asset>();
    map<String, Asset> updateMap = new map<String, Asset>();
    for(Product2 p : [SELECT Id, Name, ProductCode FROM Product2]){
      Asset insertAsset = new Asset(Name = p.Name, Product2Id = p.Id);
      insertList.add(insertAsset);
      updateMap.put(p.ProductCode, insertAsset);
    }
    insert insertList;
    //Re-arrange into Asset Hierarchy using updateMap
    //Antenna first...
    list<Asset> updateList = new list<Asset>();
    Asset antAsset = updateMap.get('02-1925-01SL');
    antAsset.HTS_REady__c = true;
    antAsset.Parent_Asset__c = updateMap.get('01-0408-15').Id;
    updateList.add(antAsset);
    //Now the GPRS
    Asset gprsAsset = updateMap.get('02-1858');
    gprsAsset.Parent_Asset__c = updateMap.get('02-1925-01SL').Id;
    updateList.add(gprsAsset);
    //Now the i2cm
    Asset i2cmAsset = updateMap.get('02-2204-02');
    i2cmAsset.Parent_Asset__c = updateMap.get('01-0408-15').Id;
    updateList.add(i2cmAsset);
    list<String> mapKeys = new list<String> {'19-0955', '19-0504', 'ADMIN IP', 'CBX LICENSE', 'HTS IP Address', 'Virtual Terminal ID'};
    //now all the i2cm children
    for(String k : mapKeys){
      Asset childAsset = updateMap.get(k);
      childAsset.Parent_Asset__c = updateMap.get('02-2204-02').Id;
      updateList.add(childAsset);
    }
    //Now the Provisioning Key
    Asset provKeyAsset = updateMap.get('iDirect Provisioning Key');
    provKeyAsset.Parent_Asset__c = updateMap.get('19-0955').Id;
    updateList.add(provKeyAsset);
    update updateList;
  }
  
  static testMethod void testSetupData() {
    //use this method to validate that you have test data setup correctly
    DefaultAccounts__c defAcct =  DefaultAccounts__c.getValues('DefaultAssets');
    Account a = [SELECT Id FROM Account LIMIT 1];
    system.assertEquals(a.id, defAcct.Account_ID__c);
    list<Product2> readProds = [SELECT Id, ProductCode FROM Product2];
    system.assertEquals(11, readProds.size());
    list<Asset> readAssets = [SELECT Id, Product2Id, Product2.ProductCode, Parent_Asset__c FROM Asset];
    system.assertEquals(11, readAssets.size());

    map<String, list<Asset>> returnMap = new map<String, list<Asset>>();
    for(Asset ass : readAssets){
      list<Asset> tempList = new list<Asset>();
      if(returnMap.containsKey(ass.Product2.ProductCode)){  //In case there is already one or more in the hierarchy
        tempList = returnMap.get(ass.Product2.ProductCode); //get the existing list
      }
      tempList.add(ass);
      returnMap.put(ass.Product2.ProductCode, tempList);
    }

    system.assertEquals(returnMap.get('01-0408-15')[0].Id, returnMap.get('02-1925-01SL')[0].Parent_Asset__c); //antenna
    system.assertEquals(returnMap.get('01-0408-15')[0].Id, returnMap.get('02-2204-02')[0].Parent_Asset__c);   //i2cm
    system.assertEquals(returnMap.get('02-1925-01SL')[0].Id, returnMap.get('02-1858')[0].Parent_Asset__c);    //gprs in antenna
    list<String> mapKeys = new list<String> {'19-0955', '19-0504', 'ADMIN IP', 'CBX LICENSE', 'HTS IP Address', 'Virtual Terminal ID'};
    for(String k : mapKeys){
      system.assertEquals(returnMap.get('02-2204-02')[0].Id, returnMap.get(k)[0].Parent_Asset__c);
    }
    system.assertEquals(returnMap.get('19-0955')[0].Id, returnMap.get('iDirect Provisioning Key')[0].Parent_Asset__c); //antenna
  }
  
  static testMethod void test_getActiveSubscriptions_OK(){
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
    HTS_ltgsvc_diagnostics returnedObj = HTS_ltgsvc_diagnostics.getActiveSubscriptions('12345678');
    test.stopTest();
    system.assertEquals(1, returnedObj.activeSubscriptions.size());
    system.assertEquals('SUCCESS: analysis returned: 1 active subscriptions', returnedObj.statusMessage);
  }
  
  static testMethod void test_getActiveSubscriptions_EXCEPTION(){
    //This tests the catch block by deliberately throwing an exception...
    test.startTest();
    HTS_ltgsvc_diagnostics returnedObj = HTS_ltgsvc_diagnostics.getActiveSubscriptions(null);
    test.stopTest();
    system.assertEquals('EXCEPTION:', returnedObj.statusMessage.left(10));
  }

  static testMethod void test_getSystemStatus_EXCEPTION(){
    test.startTest();
    HTS_ltgsvc_diagnostics returned = HTS_ltgsvc_diagnostics.getSystemStatus('12345678');
    test.stopTest();
    system.assertEquals('EXCEPTION: ', returned.statusMessage.left(11));
  }

  static testMethod void test_getSystemStatus_SUCCESS(){
    test.startTest();
    HTS_ltgsvc_diagnostics returned = HTS_ltgsvc_diagnostics.getSystemStatus('VTID');
    test.stopTest();
    system.assertEquals('SUCCESS: ', returned.statusMessage.left(9));
  }
  static testMethod void test_getSystemMap(){
    //There should be ten Lists in the Map
    //each list should only have one member
    list<Asset> inputList = [SELECT Id, Product2.ProductCode FROM Asset];
    map<String, list<Asset>> resultsMap = new map<String, list<Asset>>();
    HTS_ltgsvc_diagnostics util = new HTS_ltgsvc_diagnostics();
    test.startTest();
    resultsMap = util.getSystemMap(inputList);
    system.assertEquals(11, resultsMap.size());   //ten lists in the map?
    for(Asset a : inputList){                     //each list only one member?
      system.assertEquals(true, resultsMap.containsKey(a.Product2.ProductCode));
      system.assertEquals(1, resultsMap.get(a.Product2.ProductCode).size());
    }
    test.stopTest();
  }
  static testMethod void test_getSystemTemplate(){
    HTS_ltgsvc_diagnostics util = new HTS_ltgsvc_diagnostics();
    list<Asset_Hierarchy_Template__mdt> readMdt = new list<Asset_Hierarchy_Template__mdt>();
    test.startTest();
    readMdt = util.getSystemTemplate('01-0408');
    test.stopTest();
    system.assertEquals(7,readMdt.size());
  }
  static testMethod void test_getAssetDiagnostics(){
    list<Asset> readAssets = [SELECT Id, Product2Id, Product2.ProductCode, Parent_Asset__c, HTS_REady__c FROM Asset];
    system.assertEquals(11, readAssets.size());
    test.startTest();
    HTS_ltgsvc_diagnostics results = HTS_ltgsvc_diagnostics.getAssetDiagnostics(readAssets);
    test.stopTest();
    system.assertEquals(7, results.validationResults.size(), results.validationResults);
    for(string s : results.validationResults){
      system.assertEquals('OK: ', s.left(4));
    }
  }
  static testMethod void test_validateSystemIsComplete_OK(){
    HTS_ltgsvc_diagnostics util = new HTS_ltgsvc_diagnostics();
    list<Asset> readAssets = [SELECT Id, Product2Id, Product2.ProductCode, Parent_Asset__c, HTS_REady__c FROM Asset];
    system.assertEquals(11, readAssets.size());
    test.startTest();
    list<String> results = util.validateSystemIsComplete(readAssets);
    test.stopTest();
    system.assertEquals(7, results.size(), results);
    for(string s : results){
      system.assertEquals('OK: ', s.left(4));
    }
  }

  static testMethod void test_validateSystemIsComplete_ERROR(){
    //add redundant VTID
    list<Asset> readAssets2 = [SELECT Id, Product2Id, Product2.ProductCode, Parent_Asset__c 
                          FROM Asset WHERE Name = 'VTID'];
    Asset dupe = readAssets2[0];
    dupe.id = null;
    dupe.Name = dupe.Name + '2';
    insert dupe;
    HTS_ltgsvc_diagnostics util = new HTS_ltgsvc_diagnostics();
    list<Asset> readAssets = [SELECT Id, Product2Id, Product2.ProductCode, Parent_Asset__c, HTS_REady__c FROM Asset];
    system.assertEquals(12, readAssets.size());
    test.startTest();
    list<String> results = util.validateSystemIsComplete(readAssets);
    test.stopTest();
    system.assertEquals(7, results.size(), results);
    Integer okCount = 0;
    Integer errorCount = 0;
    for(string s : results){
      if(s.left(4) == 'OK: '){
        okCount = okCount + 1;
      } else if(s.left(7) == 'ERROR: '){
        errorCount = errorCount + 1;
      }
    }
    system.assertEquals(6, okCount);
    system.assertEquals(1, errorCount);
  }

  static testMethod void test_validateTermInNetwork(){
    //Tests normal execution flow
    //Need mock response from hts/subscribers
    QueueHttpMock mock = new QueueHttpMock();
    HttpResponse res0 = new HttpResponse();
    res0.setStatusCode(200);
    res0.setBody('[{"activate": true,"coremodule_id": 6093,"is_active": true,"obj_id": 6094,"obj_revision": 2,"terminal_id": "99997931"}]');
    mock.addResponse(res0);
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    HTS_ltgsvc_diagnostics util = new HTS_ltgsvc_diagnostics();
    String returned = util.validateTermInNetwork('VTID');
    test.stopTest();

  }
  static testMethod void test_runDiagnostics(){
    //Tests normal execution flow
    //Need mock response from hts/subscribers... sequence is kind of CRITICAL!
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

    HttpResponse res5 = new HttpResponse();
    res5.setStatusCode(200);
    res5.setBody('[{"activate": true,"coremodule_id": 6093,"is_active": true,"obj_id": 6094,"obj_revision": 2,"terminal_id": "99997931"}]');
    
    mock.addResponse(res1);
    mock.addResponse(res2);
    mock.addResponse(res3);
    mock.addResponse(res4);
    mock.addResponse(res5);

    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    HTS_ltgsvc_diagnostics returnedObj = HTS_ltgsvc_diagnostics.runDiagnostics('VTID');
    test.stopTest();
    system.assertEquals(1, returnedObj.activeSubscriptions.size());
    system.assertEquals('SUCCESS: Diagnostics completed!', returnedObj.statusMessage);

    system.assertEquals(8, returnedObj.validationResults.size(), returnedObj.validationResults);

    system.assertEquals(11, returnedObj.systemCollection.size());
  }
}