@isTest
private class Service_LTE_activation_provisioning_test {
  //setup testClass variables here. For example:
  //RecordType Ids
  private static final Id SERVICE_PRODUCT2_RECORD_TYPE_ID = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Service').getRecordTypeId();
  private static final Id SERVCLOUD_CASE_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Cloud').getRecordTypeId();
  private static final Id AIRTIME_CASE_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Airtime Service').getRecordTypeId();
  private static final Id TEST_PLATFORM_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Demo/Test/Monitor').getRecordTypeId();
  
  @testSetup static void setupTestData(){
   
    //Need a SBQQ__Subscription__c record with the right attributes (e.g. Product type)
    //Need Accounts...
    list<Account> insertAccts = new list<Account>();
    Account testAcct = new Account(Name='Test Account', RecordTypeId=TEST_PLATFORM_RECORD_TYPE_ID);
    insertAccts.add(testAcct);
    Account defAcct = new Account(Name='Default Assets');
    insertAccts.add(defAcct);
    insert insertAccts;


    //And a Custom Setting...
    DefaultAccounts__c insertCS = new DefaultAccounts__c(Name='ReplacedAssets', Account_ID__c=defAcct.Id, Description__c='default account');
    insert insertCS;
    //...and a Kontract with a "K"
    Contract k = new Contract(AccountId = testAcct.Id);
    insert k;

    //Need an LTE Activation form
    LTE_activation__c testForm = new LTE_activation__c(Contract__c = k.Id);
    insert testForm;

    //Need an appropriate Asset Hierarchy
    //Both of the above need the right Product2 records.
    //Need a single of SERVICE Products....
    list<Product2> prodList = new list<Product2>();
    Product2 testProd = new Product2(Name='LTE20GB', 
                                     ProductCode='LTE20GB', 
                                     RecordTypeId=Service_Product2_RECORD_TYPE_ID);
    prodList.add(testProd);
    //Need several HARDWARE Products...
    Product2 lteModemProduct = new Product2(Name = '19-1027', ProductCode = '19-1027', Product_ID__c='19-1027_US');
    prodList.add(lteModemProduct);
    Product2 lteSIMProduct = new Product2(Name = '19-1035', ProductCode = '19-1035', Product_ID__c='19-1035_US');
    prodList.add(lteSIMProduct);
    Product2 lteDomeProduct = new Product2(Name = '02-2280', ProductCode = '02-2280', Product_ID__c='02-2280_US');
    prodList.add(lteDomePRoduct);
    Product2 lteSystemProduct = new Product2(Name = '01-0419', ProductCode = '01-0419', Product_ID__c='01-0419_US');
    prodList.add(lteSystemProduct);
    Product2 lteVTIDProduct = new Product2(Name = 'Virtual Terminal ID', ProductCode = 'Virtual Terminal ID', Product_ID__c='Virtual Terminal ID_US');
    prodList.add(lteVTIDProduct);
    insert prodList;
    //And we need Assets, in a Hierarhcy
    list<Asset> assetList = new list<Asset>();
    for(Product2 p : [SELECT Id, ProductCode, Name FROM Product2]){
      if(p.Name != 'LTE20GB'){  //Exclude our one service!
        Asset a;
        //User the Product2.Name as the Asset.Name
        //except for VTID
        if(p.Name == 'Virtual Terminal ID'){
          a = new Asset(Name = '87654321', Product2Id = p.Id, AccountId = testAcct.Id);
        } else {
          a = new Asset(Name = p.Name, Product2Id = p.Id, AccountId = testAcct.Id);
        }
        assetList.add(a);
      }
    }  
    insert assetList;
    assetList.clear();
    //now to setup the Hierarchy... start with a map
    assetList = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
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
    //Need a subscription for Sure! an SBQQ__Subscription__c in fact
    SBQQ__Subscription__c testSubsc = new SBQQ__Subscription__c(SBQQ__Quantity__c = 1, SBQQ__Contract__c = k.Id, 
                                                                SBQQ__Product__c = testProd.Id);
                                                                
   
    insert testSubsc;
    
    HTS_Virtual_Terminal_ID__c testVTID = new HTS_Virtual_Terminal_ID__c(Virtual_Terminal_Id__c = '87654321');
    insert testVTID;
  }

  static testMethod void testSetupData(){
    // Test that your test data is setup correctly
    //Should be 5 Product2 records
    list<Product2> readList = [SELECT Id, Name FROM Product2];
    system.assertEquals(6, readList.size());
    list<Asset> assetReadList = [SELECT Id, Name FROM Asset];
    system.assertEquals(5, assetReadList.size());
    list<Account> acctReadList = [SELECT Id, Name FROM Account];
    system.assertEquals(2, acctReadList.size());
    list<Contract> kontractReadList = [SELECT Id, Name FROM Contract];
    system.assertEquals(1, kontractReadList.size()); 
    list<HTS_Virtual_Terminal_ID__c> readVTIDs = [SELECT Id, Virtual_Terminal_Id__c FROM HTS_Virtual_Terminal_ID__c];
    system.assertEquals(1, readVTIDs.size()); 
    //Process Builder should automatically create a Case when an LTE Activation form is inserted (see line 29 above)
    //See Process Builder - LTE activation case creation
    list<Case> caseList = [SELECT Id FROM Case];
    system.assertEquals(1,caseList.size());
    list<LTE_activation__c> testForms = [SELECT Id, Name FROM LTE_activation__c];
    system.assertEquals(1, testForms.size());
  }
  //Static block output tests
  static testMethod void test_staticLog(){
    serviceResults logStringResponse = Service_LTE_activation_provisioning.getLog();
    system.assert(logStringResponse.message.contains('SERVICE_INITIALIZATION'));
    system.assert(logStringResponse.message.contains('Initializing LTE Activation Provisioning Service'), logStringResponse);
  }  
  //Method tests
  static testMethod void test_returnFatalError(){
    test.startTest();
    serviceResults returnedLog = Service_LTE_activation_provisioning.returnFatalError();
    test.stopTest();
    system.debug('log message: ' + returnedLog.message);
    system.assert(returnedLog.message.contains('LTE Activation Provisioning Service failed ' + 
                                                'to complete successfully. See log for details.'), returnedLog.message);
    Case c = [SELECT ID, Subject, Status, Origin, RecordTypeId, Description, CaseNumber 
              FROM Case 
              WHERE RecordTypeId =: SERVCLOUD_CASE_RECORD_TYPE_ID
              LIMIT 1];
    system.assertEquals(SERVCLOUD_CASE_RECORD_TYPE_ID, c.RecordTypeId);
    system.assertEquals('Fatal Error in Service_LTE_activation_provisioning Class', c.Subject);
    system.assertEquals('System Generated', c.Origin);
    system.assertEquals('New', c.Status);
  }
  static testMethod void test_postSubscriberToOss_OK(){
    list<Asset> assetList = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
                                 Product2.ProductCode FROM Asset];
    map<String, Asset> assetMap = new map<String, Asset>();
    for(asset a : assetList){
      assetMap.put(a.Name, a);
    }
    //add the VTID Asset to the map!
    Product2 readVTID = [SELECT Id, Name FROM Product2 WHERE Name = 'Virtual Terminal ID' LIMIT 1];
    Asset lteVTID = new Asset(Name = '12345678-LTE', Product2Id = readVTID.Id);
    assetMap.put('Virtual Terminal ID', lteVTID);
    //Need mock response from lte/devices etc...
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_noBody(201));
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    LTEOSS_lte_subscribers returnObj = Service_LTE_activation_provisioning.postSubscriberToOss(assetMap);
    serviceResults logStringResponse = Service_LTE_activation_provisioning.getLog();
    test.stopTest();
    system.assert(logStringResponse.message.contains('METHOD_EXIT'));
    system.assert(logStringResponse.message.contains('Successfully POSTed LTE Subscriber to OSS'), logStringResponse);
  }
  static testMethod void test_postSubscriberToOss_500(){
    list<Asset> assetList = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
                                 Product2.ProductCode FROM Asset];
    map<String, Asset> assetMap = new map<String, Asset>();
    for(asset a : assetList){
      assetMap.put(a.Name, a);
    }
    //add the VTID Asset to the map!
    Product2 readVTID = [SELECT Id, Name FROM Product2 WHERE Name = 'Virtual Terminal ID' LIMIT 1];
    Asset lteVTID = new Asset(Name = '12345678-LTE', Product2Id = readVTID.Id);
    assetMap.put('Virtual Terminal ID', lteVTID);
    //Need mock response from lte/devices etc...
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_error_500());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    LTEOSS_lte_subscribers returnObj = Service_LTE_activation_provisioning.postSubscriberToOss(assetMap);
    serviceResults logStringResponse = Service_LTE_activation_provisioning.getLog();
    test.stopTest();
    system.assert(logStringResponse.message.contains('FATAL_ERROR'));
    system.assert(logStringResponse.message.contains('Could not POST LTE Subscriber with ICCID'), logStringResponse);
  }
  static testMethod void test_getSubscriberState_OK(){
    list<Asset> assetList = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
                                 Product2.ProductCode FROM Asset];
    map<String, Asset> assetMap = new map<String, Asset>();
    for(asset a : assetList){
      assetMap.put(a.Name, a);
    }
    //Need mock response from lte/devices etc...
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_getLTESubscriberInfo_OK_active());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    LTEOSS_lte_subscribers returnObj = Service_LTE_activation_provisioning.getSubscriberState(assetMap);
    serviceResults logStringResponse = Service_LTE_activation_provisioning.getLog();
    test.stopTest();
    system.assertEquals('active', returnObj.status, returnObj);
    system.assert(logStringResponse.message.contains('METHOD_EXIT'), logStringResponse);
    system.assert(logStringResponse.message.contains('OSS reports ICCID state for: 19-1035 as active'), logStringResponse);
  }
  static testMethod void test_getSubscriberState_404(){
    list<Asset> assetList = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
                                 Product2.ProductCode FROM Asset];
    map<String, Asset> assetMap = new map<String, Asset>();
    for(asset a : assetList){
      assetMap.put(a.Name, a);
    }
    //Need mock response from lte/devices etc...
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_getLTESubscriberInfo_404());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    LTEOSS_lte_subscribers returnObj = Service_LTE_activation_provisioning.getSubscriberState(assetMap);
    serviceResults logStringResponse = Service_LTE_activation_provisioning.getLog();
    test.stopTest();
    system.assert(logStringResponse.message.contains('ERROR'), logStringResponse);
    system.assert(logStringResponse.message.contains('ERROR: OSS returned 404'), logStringResponse);
    
    system.assertEquals(false, logStringResponse.success, logStringResponse);
  }
  static testMethod void test_getSubscriberState_500(){
    list<Asset> assetList = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
                                 Product2.ProductCode FROM Asset];
    map<String, Asset> assetMap = new map<String, Asset>();
    for(asset a : assetList){
      assetMap.put(a.Name, a);
    }
    //Need mock response from lte/devices etc...
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_error_500());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    LTEOSS_lte_subscribers returnObj = Service_LTE_activation_provisioning.getSubscriberState(assetMap);
    serviceResults logStringResponse = Service_LTE_activation_provisioning.getLog();
    test.stopTest();
    system.assert(logStringResponse.message.contains('ERROR'), logStringResponse);
    system.assert(logStringResponse.message.contains('ERROR: OSS returned 500'), logStringResponse);
    system.assertEquals(false, logStringResponse.success, logStringResponse);
  }
  static testMethod void test_updateLTEDevice_OK(){
    list<Asset> assetList = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
                                 Product2.ProductCode FROM Asset];
    map<String, Asset> assetMap = new map<String, Asset>();
    for(asset a : assetList){
      assetMap.put(a.Name, a);
    }
    //add the VTID Asset to the map!
    Product2 readVTID = [SELECT Id, Name FROM Product2 WHERE Name = 'Virtual Terminal ID' LIMIT 1];
    Asset lteVTID = new Asset(Name = '12345678-LTE', Product2Id = readVTID.Id);
    assetMap.put('Virtual Terminal ID', lteVTID);
    //Need mock response from lte/devices etc...
    QueueHttpMock mock = new QueueHttpMock();
    //need response for GET group_id from /lte/organizations/{org_id}/groups
    mock.addResponse(getMock_getGroupByOrgId_FILTERED_OK());
    //need response for GET /lte/devices/{org_id}/{group_id} for device Id
    mock.addResponse(getMock_getLTEDevices_OK());
    //need response for PUT /lte/devices/{org_id}/{group_id}/{id}
    mock.addResponse(getMock_noBody(204));
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    LTEOSS_lte_devices returnObj = Service_LTE_activation_provisioning.updateLTEDevice(assetMap);
    serviceResults logStringResponse = Service_LTE_activation_provisioning.getLog();
    test.stopTest();
    system.assert(logStringResponse.message.contains('METHOD_EXIT'), logStringResponse);
    system.assert(logStringResponse.message.contains('LTE device successfully updated'), logStringResponse);
  }
  static testMethod void test_updateLTEDevice_500(){
    list<Asset> assetList = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
                                 Product2.ProductCode FROM Asset];
    map<String, Asset> assetMap = new map<String, Asset>();
    for(asset a : assetList){
      assetMap.put(a.Name, a);
    }
    //add the VTID Asset to the map!
    Product2 readVTID = [SELECT Id, Name FROM Product2 WHERE Name = 'Virtual Terminal ID' LIMIT 1];
    Asset lteVTID = new Asset(Name = '12345678-LTE', Product2Id = readVTID.Id);
    assetMap.put('Virtual Terminal ID', lteVTID);
    //Need mock response from lte/devices etc...
    QueueHttpMock mock = new QueueHttpMock();
    //need response for GET group_id from /lte/organizations/{org_id}/groups
    mock.addResponse(getMock_getGroupByOrgId_FILTERED_OK());
    //need response for GET /lte/devices/{org_id}/{group_id} for device Id
    mock.addResponse(getMock_getLTEDevices_OK());
    //need response for PUT /lte/devices/{org_id}/{group_id}/{id}
    mock.addResponse(getMock_noBody(500));
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    LTEOSS_lte_devices returnObj = Service_LTE_activation_provisioning.updateLTEDevice(assetMap);
    serviceResults logStringResponse = Service_LTE_activation_provisioning.getLog();
    test.stopTest();
    system.assert(logStringResponse.message.contains('METHOD_EXIT'), logStringResponse);
    system.assert(logStringResponse.message.contains('OSS returned: 500'), logStringResponse);
    system.assertEquals(false, logStringResponse.success);
  }
  static testMethod void test_updateLTEDevice_MULTI_GROUP(){
    list<Asset> assetList = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
                                 Product2.ProductCode FROM Asset];
    map<String, Asset> assetMap = new map<String, Asset>();
    for(asset a : assetList){
      assetMap.put(a.Name, a);
    }
    //add the VTID Asset to the map!
    Product2 readVTID = [SELECT Id, Name FROM Product2 WHERE Name = 'Virtual Terminal ID' LIMIT 1];
    Asset lteVTID = new Asset(Name = '12345678-LTE', Product2Id = readVTID.Id);
    assetMap.put('Virtual Terminal ID', lteVTID);
    //Need mock response from lte/devices etc...
    QueueHttpMock mock = new QueueHttpMock();
    //need response for GET group_id from /lte/organizations/{org_id}/groups
    mock.addResponse(getMock_getGroupByOrgId_OK());
    //need response for GET /lte/devices/{org_id}/{group_id} for device Id
    mock.addResponse(getMock_getLTEDevices_OK());
    //need response for PUT /lte/devices/{org_id}/{group_id}/{id}
    mock.addResponse(getMock_noBody(500));
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    LTEOSS_lte_devices returnObj = Service_LTE_activation_provisioning.updateLTEDevice(assetMap);
    serviceResults logStringResponse = Service_LTE_activation_provisioning.getLog();
    test.stopTest();
    system.assert(logStringResponse.message.contains('METHOD_EXIT'), logStringResponse);
    system.assert(logStringResponse.message.contains('OSS did not return one and only one Group ID for device:'), logStringResponse);
    system.assertEquals(false, logStringResponse.success);
  }
  static testMethod void test_updateLTEDevice_NO_DEVICE(){
    list<Asset> assetList = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
                                 Product2.ProductCode FROM Asset];
    map<String, Asset> assetMap = new map<String, Asset>();
    for(asset a : assetList){
      assetMap.put(a.Name, a);
    }
    //add the VTID Asset to the map!
    Product2 readVTID = [SELECT Id, Name FROM Product2 WHERE Name = 'Virtual Terminal ID' LIMIT 1];
    Asset lteVTID = new Asset(Name = '12345678-LTE', Product2Id = readVTID.Id);
    assetMap.put('Virtual Terminal ID', lteVTID);
    //Need mock response from lte/devices etc...
    QueueHttpMock mock = new QueueHttpMock();
    //need response for GET group_id from /lte/organizations/{org_id}/groups
    mock.addResponse(getMock_getGroupByOrgId_FILTERED_OK());
    //need response for GET /lte/devices/{org_id}/{group_id} for device Id
    mock.addResponse(getMock_getLTEDevices_EMPTY());
    //need response for PUT /lte/devices/{org_id}/{group_id}/{id}
    mock.addResponse(getMock_noBody(204));
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    LTEOSS_lte_devices returnObj = Service_LTE_activation_provisioning.updateLTEDevice(assetMap);
    serviceResults logStringResponse = Service_LTE_activation_provisioning.getLog();
    test.stopTest();
    system.assert(logStringResponse.message.contains('METHOD_EXIT'), logStringResponse);
    system.assert(logStringResponse.message.contains('Could not isolate Device Id by Group Id'), logStringResponse);
    system.assertEquals(false, logStringResponse.success);
  }
  static testMethod void test_updateLTEDevice_EXCEPTION(){
    list<Asset> assetList = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
                                 Product2.ProductCode FROM Asset];
    map<String, Asset> assetMap = new map<String, Asset>();
    for(asset a : assetList){
      assetMap.put(a.Name, a);
    }
    //add the VTID Asset to the map!
    Product2 readVTID = [SELECT Id, Name FROM Product2 WHERE Name = 'Virtual Terminal ID' LIMIT 1];
    Asset lteVTID = new Asset(Name = '12345678-LTE', Product2Id = readVTID.Id);
    assetMap.put('Virtual Terminal ID', lteVTID);
    //Need mock response from lte/devices etc...
    QueueHttpMock mock = new QueueHttpMock();
    //need response for GET group_id from /lte/organizations/{org_id}/groups
    mock.addResponse(getMock_getGroupByOrgId_FILTERED_OK());
    //need response for GET /lte/devices/{org_id}/{group_id} for device Id
    mock.addResponse(getMock_noBody(404)); // <--- throws exception
    //need response for PUT /lte/devices/{org_id}/{group_id}/{id}
    mock.addResponse(getMock_noBody(204));
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    LTEOSS_lte_devices returnObj = Service_LTE_activation_provisioning.updateLTEDevice(assetMap);
    serviceResults logStringResponse = Service_LTE_activation_provisioning.getLog();
    test.stopTest();
    system.assert(logStringResponse.message.contains('METHOD_EXIT'), logStringResponse);
    system.assert(logStringResponse.message.contains('Could not update LTE Device in OSS'), logStringResponse);
    system.assertEquals(false, logStringResponse.success);
  }
  static testMethod void test_updateHibernatedDevice_OK(){
    list<Asset> assetList = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
                                 Product2.ProductCode FROM Asset];
    map<String, Asset> assetMap = new map<String, Asset>();
    for(asset a : assetList){
      assetMap.put(a.Name, a);
    }
    //add the VTID Asset to the map!
    Product2 readVTID = [SELECT Id, Name FROM Product2 WHERE Name = 'Virtual Terminal ID' LIMIT 1];
    Asset lteVTID = new Asset(Name = '12345678-LTE', Product2Id = readVTID.Id);
    assetMap.put('Virtual Terminal ID', lteVTID);
    //Need mock response from lte/devices etc...
    QueueHttpMock mock = new QueueHttpMock();
    //need response for GET group_id from /lte/organizations/{org_id}/groups
    mock.addResponse(getMock_getGroupByOrgId_FILTERED_OK());
    //need response for GET /lte/devices/{org_id}/{group_id} for device Id
    mock.addResponse(getMock_getLTEDevices_OK());
    //need response for PUT /lte/devices/{org_id}/{group_id}/{id}
    mock.addResponse(getMock_noBody(204));
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    LTEOSS_lte_devices returnObj = Service_LTE_activation_provisioning.updateHibernatedDevice(assetMap, true);
    serviceResults log = Service_LTE_activation_provisioning.getLog();
    test.stopTest();
    system.assert(log.success, log);
    system.assert(log.message.contains('METHOD_EXIT'), log);
    system.assert(log.message.contains('Successfully Updated LTE Device in OSS'), log);
  }
  static testMethod void test_updateHibernatedDevice_ISTERMINATION(){
    list<Asset> assetList = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
                                 Product2.ProductCode FROM Asset];
    map<String, Asset> assetMap = new map<String, Asset>();
    for(asset a : assetList){
      assetMap.put(a.Name, a);
    }
    //add the VTID Asset to the map!
    Product2 readVTID = [SELECT Id, Name FROM Product2 WHERE Name = 'Virtual Terminal ID' LIMIT 1];
    Asset lteVTID = new Asset(Name = '12345678-LTE', Product2Id = readVTID.Id);
    assetMap.put('Virtual Terminal ID', lteVTID);
    //No callouts for this path...
    test.startTest();
    LTEOSS_lte_devices returnObj = Service_LTE_activation_provisioning.updateHibernatedDevice(assetMap, false);
    serviceResults log = Service_LTE_activation_provisioning.getLog();
    test.stopTest();
    system.assert(log.success, log);
    system.assert(log.message.contains('INFO'), log);
    system.assert(log.message.contains('No Update to LTE Device required'), log);
  }
  static testMethod void test_updateHibernatedDevice_500(){
    list<Asset> assetList = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
                                 Product2.ProductCode FROM Asset];
    map<String, Asset> assetMap = new map<String, Asset>();
    for(asset a : assetList){
      assetMap.put(a.Name, a);
    }
    //add the VTID Asset to the map!
    Product2 readVTID = [SELECT Id, Name FROM Product2 WHERE Name = 'Virtual Terminal ID' LIMIT 1];
    Asset lteVTID = new Asset(Name = '12345678-LTE', Product2Id = readVTID.Id);
    assetMap.put('Virtual Terminal ID', lteVTID);
    //Need mock response from lte/devices etc...
    QueueHttpMock mock = new QueueHttpMock();
    //need response for GET group_id from /lte/organizations/{org_id}/groups
    mock.addResponse(getMock_getGroupByOrgId_FILTERED_OK());
    //need response for GET /lte/devices/{org_id}/{group_id} for device Id
    mock.addResponse(getMock_getLTEDevices_OK());
    //need response for PUT /lte/devices/{org_id}/{group_id}/{id}
    mock.addResponse(getMock_noBody(500));
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    LTEOSS_lte_devices returnObj = Service_LTE_activation_provisioning.updateHibernatedDevice(assetMap, true);
    serviceResults log = Service_LTE_activation_provisioning.getLog();
    test.stopTest();
    system.assert(log.message.contains('METHOD_EXIT'), log);
    system.assert(log.message.contains('OSS returned: 500'), log);
    system.assertEquals(false, log.success, log);
  }
  static testMethod void test_updateHibernatedDevice_MULTI_GROUP(){
    list<Asset> assetList = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
                                 Product2.ProductCode FROM Asset];
    map<String, Asset> assetMap = new map<String, Asset>();
    for(asset a : assetList){
      assetMap.put(a.Name, a);
    }
    //add the VTID Asset to the map!
    Product2 readVTID = [SELECT Id, Name FROM Product2 WHERE Name = 'Virtual Terminal ID' LIMIT 1];
    Asset lteVTID = new Asset(Name = '12345678-LTE', Product2Id = readVTID.Id);
    assetMap.put('Virtual Terminal ID', lteVTID);
    //Need mock response from lte/devices etc...
    QueueHttpMock mock = new QueueHttpMock();
    //need response for GET group_id from /lte/organizations/{org_id}/groups
    mock.addResponse(getMock_getGroupByOrgId_OK());
    //need response for GET /lte/devices/{org_id}/{group_id} for device Id
    mock.addResponse(getMock_getLTEDevices_OK());
    //need response for PUT /lte/devices/{org_id}/{group_id}/{id}
    mock.addResponse(getMock_noBody(500));
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    LTEOSS_lte_devices returnObj = Service_LTE_activation_provisioning.updateHibernatedDevice(assetMap, true);
    serviceResults log = Service_LTE_activation_provisioning.getLog();
    test.stopTest();
    system.assert(log.message.contains('METHOD_EXIT'), log);
    system.assert(log.message.contains('OSS did not return one and only one Group ID for device:'), log);
    system.assertEquals(false, log.success);
  }
  static testMethod void test_updateHibernatedDevice_NO_DEVICE(){
    list<Asset> assetList = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
                                 Product2.ProductCode FROM Asset];
    map<String, Asset> assetMap = new map<String, Asset>();
    for(asset a : assetList){
      assetMap.put(a.Name, a);
    }
    //add the VTID Asset to the map!
    Product2 readVTID = [SELECT Id, Name FROM Product2 WHERE Name = 'Virtual Terminal ID' LIMIT 1];
    Asset lteVTID = new Asset(Name = '12345678-LTE', Product2Id = readVTID.Id);
    assetMap.put('Virtual Terminal ID', lteVTID);
    //Need mock response from lte/devices etc...
    QueueHttpMock mock = new QueueHttpMock();
    //need response for GET group_id from /lte/organizations/{org_id}/groups
    mock.addResponse(getMock_getGroupByOrgId_FILTERED_OK());
    //need response for GET /lte/devices/{org_id}/{group_id} for device Id
    mock.addResponse(getMock_getLTEDevices_EMPTY());
    //need response for PUT /lte/devices/{org_id}/{group_id}/{id}
    mock.addResponse(getMock_noBody(204));
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    LTEOSS_lte_devices returnObj = Service_LTE_activation_provisioning.updateHibernatedDevice(assetMap, true);
    serviceResults log = Service_LTE_activation_provisioning.getLog();
    test.stopTest();
    system.assert(log.message.contains('METHOD_EXIT'), log);
    system.assert(log.message.contains('Could not isolate Device Id by Group Id'), log);
    system.assertEquals(false, log.success);
  }
  static testMethod void test_updateHibernatedDevice_EXCEPTION(){
    list<Asset> assetList = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
                                 Product2.ProductCode FROM Asset];
    map<String, Asset> assetMap = new map<String, Asset>();
    for(asset a : assetList){
      assetMap.put(a.Name, a);
    }
    //add the VTID Asset to the map!
    Product2 readVTID = [SELECT Id, Name FROM Product2 WHERE Name = 'Virtual Terminal ID' LIMIT 1];
    Asset lteVTID = new Asset(Name = '12345678-LTE', Product2Id = readVTID.Id);
    assetMap.put('Virtual Terminal ID', lteVTID);
    //Need mock response from lte/devices etc...
    QueueHttpMock mock = new QueueHttpMock();
    //need response for GET group_id from /lte/organizations/{org_id}/groups
    mock.addResponse(getMock_getGroupByOrgId_FILTERED_OK());
    //need response for GET /lte/devices/{org_id}/{group_id} for device Id
    mock.addResponse(getMock_noBody(404)); // <--- throws exception
    //need response for PUT /lte/devices/{org_id}/{group_id}/{id}
    mock.addResponse(getMock_noBody(204));
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    LTEOSS_lte_devices returnObj = Service_LTE_activation_provisioning.updateHibernatedDevice(assetMap, true);
    serviceResults log = Service_LTE_activation_provisioning.getLog();
    test.stopTest();
    system.assert(log.message.contains('METHOD_EXIT'), log);
    system.assert(log.message.contains('Could not update LTE Device in OSS'), log);
    system.assertEquals(false, log.success);
  }
  static testMethod void test_restoreLTESubscriber_OK(){
    list<Asset> assetList = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
                                 Product2.ProductCode FROM Asset];
    map<String, Asset> assetMap = new map<String, Asset>();
    for(asset a : assetList){
      assetMap.put(a.Name, a);
    }
    //add the VTID Asset to the map!
    Product2 readVTID = [SELECT Id, Name FROM Product2 WHERE Name = 'Virtual Terminal ID' LIMIT 1];
    Asset lteVTID = new Asset(Name = '12345678-LTE', Product2Id = readVTID.Id);
    assetMap.put('Virtual Terminal ID', lteVTID);
    //Need mock response from lte/devices etc...
    QueueHttpMock mock = new QueueHttpMock();
    //need response for PUT /lte/subscribers/restore
    mock.addResponse(getMock_noBody(204));
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    LTEOSS_lte_subscribers returnObj = Service_LTE_activation_provisioning.restoreLTESubscriber(assetMap);
    serviceResults logStringResponse = Service_LTE_activation_provisioning.getLog();
    test.stopTest();
    system.assert(logStringResponse.message.contains('METHOD_EXIT'), logStringResponse);
    system.assert(logStringResponse.message.contains('Successfully restored service to LTE Subscriber'), logStringResponse);
  }
  static testMethod void test_restoreLTESubscriber_404(){
    list<Asset> assetList = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
                                 Product2.ProductCode FROM Asset];
    map<String, Asset> assetMap = new map<String, Asset>();
    for(asset a : assetList){
      assetMap.put(a.Name, a);
    }
    //add the VTID Asset to the map!
    Product2 readVTID = [SELECT Id, Name FROM Product2 WHERE Name = 'Virtual Terminal ID' LIMIT 1];
    Asset lteVTID = new Asset(Name = '12345678-LTE', Product2Id = readVTID.Id);
    assetMap.put('Virtual Terminal ID', lteVTID);
    //Need mock response from lte/devices etc...
    QueueHttpMock mock = new QueueHttpMock();
    //need response for PUT /lte/subscribers/restore
    mock.addResponse(getMock_error_500());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    LTEOSS_lte_subscribers returnObj = Service_LTE_activation_provisioning.restoreLTESubscriber(assetMap);
    serviceResults logStringResponse = Service_LTE_activation_provisioning.getLog();
    test.stopTest();
    system.assert(logStringResponse.message.contains('FATAL_ERROR'), logStringResponse);
    system.assert(logStringResponse.message.contains('Unable to restore LTE Service via OSS'), logStringResponse);
    system.assertEquals(false, logStringResponse.success);
  }
  static testMethod void test_restoreLTESubscriber_EXCEPTION(){
    list<Asset> assetList = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
                                 Product2.ProductCode FROM Asset];
    map<String, Asset> assetMap = new map<String, Asset>();
    for(asset a : assetList){
      assetMap.put(a.Name, a);
    }
    //add the VTID Asset to the map!
    Product2 readVTID = [SELECT Id, Name FROM Product2 WHERE Name = 'Virtual Terminal ID' LIMIT 1];
    Asset lteVTID = new Asset(Name = '12345678-LTE', Product2Id = readVTID.Id);
    assetMap.put('Virtual Terminal ID', lteVTID);
    //Need mock response from lte/devices etc...
    QueueHttpMock mock = new QueueHttpMock();
    //need response for PUT /lte/subscribers/restore
    mock.addResponse(getMock_noBody(404));
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    LTEOSS_lte_subscribers returnObj = Service_LTE_activation_provisioning.restoreLTESubscriber(assetMap);
    serviceResults logStringResponse = Service_LTE_activation_provisioning.getLog();
    test.stopTest();
    system.assert(logStringResponse.message.contains('FATAL_ERROR'), logStringResponse);
    system.assert(logStringResponse.message.contains('Could not restore LTE Service via OSS: '), logStringResponse);
    system.assertEquals(false, logStringResponse.success);
  }
  static testMethod void test_hibernateLTESubscriber_OK(){
    list<Asset> assetList = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
                              Product2.ProductCode FROM Asset];
    map<String, Asset> assetMap = new map<String, Asset>();
    for(asset a : assetList){
      assetMap.put(a.Name, a);
    }
    //add the VTID Asset to the map!
    Product2 readVTID = [SELECT Id, Name FROM Product2 WHERE Name = 'Virtual Terminal ID' LIMIT 1];
    Asset lteVTID = new Asset(Name = '12345678-LTE', Product2Id = readVTID.Id);
    assetMap.put('Virtual Terminal ID', lteVTID);
    //Need mock response from lte/devices etc...
    QueueHttpMock mock = new QueueHttpMock();
    //need response for PUT /lte/subscribers/restore
    mock.addResponse(getMock_noBody(204));
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    LTEOSS_lte_subscribers returnObj = Service_LTE_activation_provisioning.hibernateLTESubscriber(assetMap, false);
    serviceResults log = Service_LTE_activation_provisioning.getLog();
    test.stopTest();
    system.assert(log.message.contains('Successfully hibernated LTE susbscriber. Termination: false'), log);
    system.assertEquals(true, log.success, log);
  }
  static testMethod void test_hibernateLTESubscriber_FAIL(){
    list<Asset> assetList = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
                              Product2.ProductCode FROM Asset];
    map<String, Asset> assetMap = new map<String, Asset>();
    for(asset a : assetList){
      assetMap.put(a.Name, a);
    }
    //add the VTID Asset to the map!
    Product2 readVTID = [SELECT Id, Name FROM Product2 WHERE Name = 'Virtual Terminal ID' LIMIT 1];
    Asset lteVTID = new Asset(Name = '12345678-LTE', Product2Id = readVTID.Id);
    assetMap.put('Virtual Terminal ID', lteVTID);
    //Need mock response from lte/devices etc...
    QueueHttpMock mock = new QueueHttpMock();
    //need response for PUT /lte/subscribers/restore
    mock.addResponse(getMock_error_500());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    LTEOSS_lte_subscribers returnObj = Service_LTE_activation_provisioning.hibernateLTESubscriber(assetMap, false);
    serviceResults log = Service_LTE_activation_provisioning.getLog();
    test.stopTest();
    system.assert(log.message.contains('OSS returned: 500'), log);
    system.assertEquals(false, log.success, log);
  }
  //See HTSSF-595...
   static testMethod void test_preProcessValidation_ok(){
       SBQQ__Subscription__c rawSubscription = [Select id from SBQQ__Subscription__c limit 1];
       list<Asset> assetList = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
                                 Product2.ProductCode FROM Asset limit 1];
       Service_LTE_activation_provisioning.preProcessValidation(rawSubscription,assetList[0]);  
       
       system.assertEquals(Service_LTE_activation_provisioning.log.success,true);       
       system.assertEquals(Service_LTE_activation_provisioning.log.message.endswith('successful!'),true);                     
   }
   
   //See HTSSF-595...
   static testMethod void test_preProcessValidation_NullSubscription(){       
       list<Asset> assetList = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
                                 Product2.ProductCode FROM Asset limit 1];
       Service_LTE_activation_provisioning.preProcessValidation(new SBQQ__Subscription__c(),assetList[0]); 
       system.assertEquals(Service_LTE_activation_provisioning.log.success,false);       
       system.assertEquals(Service_LTE_activation_provisioning.log.message.endswith('Input SBQQ__Subscription__c does not include record Ids'),true);                      
   }
   
   //See HTSSF-595...
   static testMethod void test_preProcessValidation_NullRawAssets(){       
       SBQQ__Subscription__c rawSubscription = [Select id from SBQQ__Subscription__c limit 1];
       Service_LTE_activation_provisioning.preProcessValidation(rawSubscription,new Asset()); 
       system.assertEquals(Service_LTE_activation_provisioning.log.success,false);       
       system.assertEquals(Service_LTE_activation_provisioning.log.message.endswith('Input Asset does not include record Ids'),true);                                            
   }

  //preProcess validation overloads...
  static testMethod void test_preProcessValidation2_OK(){
    SBQQ__Subscription__c rawSubscription = [Select id from SBQQ__Subscription__c limit 1];
    test.startTest();
    Service_LTE_activation_provisioning.preProcessValidation(rawSubscription);
    serviceResults log = Service_LTE_activation_provisioning.getLog();
    test.stopTest();
    system.assertEquals(log.success,true);
    system.assertEquals(log.message.endswith('successful!'),true);
  }
  static testMethod void test_preProcessValidation2_FAIL(){
    SBQQ__Subscription__c rawSubscription = new SBQQ__Subscription__c();
    test.startTest();
    Service_LTE_activation_provisioning.preProcessValidation(rawSubscription);
    serviceResults log = Service_LTE_activation_provisioning.getLog();
    test.stopTest();
    system.assertEquals(log.success,false);
    system.assert(log.message.contains('Input SBQQ__Subscription__c missing record Id!'), log);
  }

   //See HTSSF-606...
   static testMethod void test_getCleanSubscription_ok(){       
       SBQQ__Subscription__c rawSubscription = [Select id from SBQQ__Subscription__c limit 1];
       SBQQ__Subscription__c cleanSubscription = Service_LTE_activation_provisioning.getCleanSubscription(rawSubscription);  
       system.assertEquals(cleanSubscription.Id, rawSubscription.Id);        
       system.assertEquals(Service_LTE_activation_provisioning.log.success,true);       
       system.assertEquals(Service_LTE_activation_provisioning.log.message.endswith('cleaned subscription retunred with needed fields.'),true);                                                         
   }
   
   //See HTSSF-606...
   static testMethod void test_getCleanSubscription_Exception(){            
       SBQQ__Subscription__c cleanSubscription = Service_LTE_activation_provisioning.getCleanSubscription(new SBQQ__Subscription__c());  
       system.assertEquals(cleanSubscription, NULL);    
       system.assertEquals(Service_LTE_activation_provisioning.log.success,false);       
       system.assertEquals(Service_LTE_activation_provisioning.log.message.contains('CleanSubscription failed.'),true);                                                                          
   }
   
   //See HTSSF-608...
   static testMethod void test_verifySubscription_ok(){       
       SBQQ__Subscription__c cleanSubscription = [Select id,SBQQ__Product__r.ProductCode,Asset__c,Traffic_Identifier__c from SBQQ__Subscription__c limit 1];
       Service_LTE_activation_provisioning.verifySubscription(cleanSubscription); 
       system.assertEquals(Service_LTE_activation_provisioning.log.success,true);       
       system.assertEquals(Service_LTE_activation_provisioning.log.message.endswith('successful!'),true);                                             
   }
   
   //See HTSSF-608...
   static testMethod void test_verifySubscription_LTE20GB_CProductCode(){       
       SBQQ__Subscription__c cleanSubscription = [Select id,SBQQ__Product__r.ProductCode,Asset__c,Traffic_Identifier__c from SBQQ__Subscription__c limit 1];
       Product2 prod = [Select id from Product2 where ProductCode != 'LTE20GB' limit 1];
       system.debug('@@ =>'+cleanSubscription.SBQQ__Product__r.ProductCode );
       cleanSubscription.SBQQ__Product__c = prod.Id;
       update cleanSubscription;
       cleanSubscription = [Select id,SBQQ__Product__r.ProductCode,Asset__c,Traffic_Identifier__c from SBQQ__Subscription__c limit 1];
       Service_LTE_activation_provisioning.verifySubscription(cleanSubscription);  
       
       system.assertEquals(Service_LTE_activation_provisioning.log.success,false);       
       system.assertEquals(Service_LTE_activation_provisioning.log.message.endswith('Subscription verification failed.Product code associated with this subscription is not related with the service.'),true);
   }
   
   //See HTSSF-608...
   static testMethod void test_verifySubscription_WithTrafficId(){       
       SBQQ__Subscription__c cleanSubscription = [Select id,SBQQ__Product__r.ProductCode,Asset__c,Traffic_Identifier__c from SBQQ__Subscription__c limit 1];
       cleanSubscription.Traffic_Identifier__c = '1234569';
       Service_LTE_activation_provisioning.verifySubscription(cleanSubscription);  
       
       system.assertEquals(Service_LTE_activation_provisioning.log.success,false);       
       system.assertEquals(Service_LTE_activation_provisioning.log.message.endswith('Subscription verification failed. Subscription record has already been associated with traffic identifier.'),true);  
   }
   
    //See HTSSF-607...
   static testMethod void test_getAssetHierarchy_ok(){   
       Asset rawDomeAsset = [SELECT Id FROM Asset where name = '02-2280' limit 1];       
       list<Asset> assetHierarchy = Service_LTE_activation_provisioning.getAssetHierarchy(rawDomeAsset); 
       system.assertEquals(assetHierarchy.size(),4);
       system.assertEquals(Service_LTE_activation_provisioning.log.success,true);       
       system.assertEquals(Service_LTE_activation_provisioning.log.message.endsWith('getAssetHierarchy queried successfully.'),true);
       
   }
   
    //See HTSSF-607...
   static testMethod void test_getAssetHierarchy_Exception(){   
           
       list<Asset> assetHierarchy = Service_LTE_activation_provisioning.getAssetHierarchy(NULL); 
       system.assertEquals(assetHierarchy,NULL);  
       system.assertEquals(Service_LTE_activation_provisioning.log.success,false);       
       system.assertEquals(Service_LTE_activation_provisioning.log.message.contains('getAssetHierarchy failed.'),true);
   }
   
     //See HTSSF-610...
   static testMethod void test_createAssetMap_ok(){   
       List<Asset> assetHierarchy = [SELECT Id,Product2.ProductCode FROM Asset];       
       map<String, Asset> assetMap = Service_LTE_activation_provisioning.createAssetMap(assetHierarchy); 
       system.assertEquals(assetMap.size(),assetHierarchy.size());  
       
       system.assertEquals(Service_LTE_activation_provisioning.log.success,true);       
       system.assertEquals(Service_LTE_activation_provisioning.log.message.endswith('createAssetMap successfully completed.'),true);
   }
   
    //See HTSSF-610...
   static testMethod void test_createAssetMap_Exception(){   
       List<Asset> assetHierarchy = [SELECT Id FROM Asset];       
       map<String, Asset> assetMap = Service_LTE_activation_provisioning.createAssetMap(assetHierarchy); 
       system.assertEquals(assetMap,NULL);  
       
       system.assertEquals(Service_LTE_activation_provisioning.log.success,false);       
       system.assertEquals(Service_LTE_activation_provisioning.log.message.contains('createAssetMap failed.'),true);
   }
   
    //See HTSSF-610...
   static testMethod void test_createAssetMap_DuplicateProductId(){  
       Asset tempAsset = [Select Product2Id  from Asset limit 1];
       Account acc = [Select id from Account limit 1]; 
       Asset a = new Asset(Name = 'Duplicate Asset', Product2Id = tempAsset.Product2Id, AccountId = acc.Id);
       insert a;
       List<Asset> assetHierarchy = [SELECT Id,Product2.ProductCode FROM Asset];   
                
       map<String, Asset> assetMap = Service_LTE_activation_provisioning.createAssetMap(assetHierarchy); 
       system.assertEquals(assetMap,NULL);  
       
       system.assertEquals(Service_LTE_activation_provisioning.log.success,false);       
       system.assertEquals(Service_LTE_activation_provisioning.log.message.endswith('createAssetMap failed. Duplicate asset comes in the asset hierarchy.'),true);
   }
   
    //See HTSSF-610...
   static testMethod void test_createAssetMap_FATALError(){  
      
       List<Asset> assetHierarchy = [SELECT Id,Product2.ProductCode FROM Asset];   
       assetHierarchy.remove(0);
       map<String, Asset> assetMap = Service_LTE_activation_provisioning.createAssetMap(assetHierarchy); 
       system.assertEquals(assetMap,NULL);  
       
       system.assertEquals(Service_LTE_activation_provisioning.log.success,false);       
       system.assertEquals(Service_LTE_activation_provisioning.log.message.endswith('createAssetMap failed. the actual hierarchy does not contain one of the required components.'),true);
   }
   
   //See HTSSF-611...
   static testMethod void test_validateAssetHierarchy_ok(){  
      Asset rawDomeAsset = [SELECT Id FROM Asset where name = '02-2280' LIMIT 1];       
      list<Asset> assetHierarchy = Service_LTE_activation_provisioning.getAssetHierarchy(rawDomeAsset); 
      
      map<String, Asset> assetMap = Service_LTE_activation_provisioning.createAssetMap(assetHierarchy); 
      Service_LTE_activation_provisioning.validateAssetHierarchy(assetMap);
      
      system.assertEquals(Service_LTE_activation_provisioning.log.success,true);       
      system.assertEquals(Service_LTE_activation_provisioning.log.message.endswith('validateAssetHierarchy successfully completed.'),true);
   }
   static testMethod void test_validateAssetHierarchy_bad_ProductCode(){  
      Asset rawDomeAsset = [SELECT Id FROM Asset where name = '02-2280' LIMIT 1];       
      list<Asset> assetHierarchy = Service_LTE_activation_provisioning.getAssetHierarchy(rawDomeAsset); 
      
      map<String, Asset> assetMap = Service_LTE_activation_provisioning.createAssetMap(assetHierarchy); 
      Asset a = assetMap.get('19-1035');
      a.Product2 = null;
      assetMap.put('19-1035', a);
      test.startTest();
      Service_LTE_activation_provisioning.validateAssetHierarchy(assetMap);
      serviceResults log = Service_LTE_activation_provisioning.getLog();
      test.stopTest();
      system.assertEquals(false, log.success, log);       
      system.assert(log.message.contains(' does not have a Product Code reference.'), log);
   }
  static testMethod void test_validateAssetHierarchy_FATAL_ERROR_Invalid_hierarchy(){  

    Asset rawDomeAsset = [SELECT Id, Parent_Asset__c FROM Asset where name = '02-2280' LIMIT 1];    
    //Break the correct parenting....
    Asset badParent = [SELECT Id, Parent_Asset__c FROM Asset WHERE Name = '19-1035' LIMIT 1];
    badParent.Parent_Asset__c = rawDomeAsset.Parent_Asset__c;
    update badParent;

    list<Asset> assetHierarchy = Service_LTE_activation_provisioning.getAssetHierarchy(rawDomeAsset); 
    map<String, Asset> assetMap = Service_LTE_activation_provisioning.createAssetMap(assetHierarchy); 

    test.startTest();
    Service_LTE_activation_provisioning.validateAssetHierarchy(assetMap);
    serviceResults log = Service_LTE_activation_provisioning.getLog();
    test.stopTest();
    system.assertEquals(false, log.success);       
    system.assert(log.message.contains(' hierarchy is not correct.'));
  }


   //See HTSSF-611...
   static testMethod void test_validateAssetHierarchy_FATAL_ERROR_Virtual_TerminalID(){  
       Asset rawDomeAsset = [SELECT Id,Name,Product2.ProductCode,Parent_Asset__r.name FROM Asset where name = '87654321' limit 1];       
       
       
       map<String, Asset> assetMap = new map<String,Asset>();
       assetMap.put('Virtual Terminal ID',rawDomeAsset); 

       Service_LTE_activation_provisioning.validateAssetHierarchy(assetMap);
       
       system.assertEquals(Service_LTE_activation_provisioning.log.success,false);       
       system.assertEquals(Service_LTE_activation_provisioning.log.message.endswith('validateAssetHierarchy failed. asset hierarchy contains Virtual Terminal ID'),true);
   }
   
   //See HTSSF-611...
   static testMethod void test_validateAssetHierarchy_FATAL_ERROR_NullName(){  
       Asset rawDomeAsset = [SELECT Id,Name,Product2.ProductCode,Parent_Asset__r.name FROM Asset where name != 'Virtual Terminal ID' limit 1];       
       
       rawDomeAsset.name = null;
       map<String, Asset> assetMap = new map<String,Asset>();
       assetMap.put(rawDomeAsset.Product2.ProductCode,rawDomeAsset); 

       Service_LTE_activation_provisioning.validateAssetHierarchy(assetMap);
       
       system.assertEquals(Service_LTE_activation_provisioning.log.success,false);       
       system.assertEquals(Service_LTE_activation_provisioning.log.message.endswith('validateAssetHierarchy failed. asset ' + rawDomeAsset.Id + ' name is blank'),true);
   }
   



   
   //See HTSSF-615...
   static testMethod void test_getNextVTID_ok(){  

       HTS_Virtual_Terminal_ID__c claimedVTID = Service_LTE_activation_provisioning.getNextVTID();
       
       system.assertnotEquals(claimedVTID.Virtual_Terminal_Id__c,NULL);
       
       system.assertnotEquals(claimedVTID.Date_Issued__c,NULL);
       
       system.assertEquals(Service_LTE_activation_provisioning.log.success,true);       
       system.assertEquals(Service_LTE_activation_provisioning.log.message.endswith('getNextVTID successfully completed.'),true);
   }
   
   
   
   //See HTSSF-615...
   static testMethod void test_getNextVTID_Exception(){  
       List<HTS_Virtual_Terminal_ID__c> terminalIds = [Select id from HTS_Virtual_Terminal_ID__c];
       delete terminalIds;
       Service_LTE_activation_provisioning.getNextVTID();
       
       system.assertEquals(Service_LTE_activation_provisioning.log.success,false);       
       system.assertEquals(Service_LTE_activation_provisioning.log.message.contains('getNextVTID failed.'),true);
   }
   
   //See HTSSF-619...
   static testMethod void test_createVTIDAsset_ok(){  
       List<HTS_Virtual_Terminal_ID__c> terminalIds = [Select id,Virtual_Terminal_Id__c from HTS_Virtual_Terminal_ID__c];
       Asset rootAsset = [Select id,name from Asset where Root_Asset__c = NULL limit 1];
       Map<String,Asset> assetMap = new Map<String,Asset>();
       for(Asset a : [Select id,name from Asset]){
           assetMap.put(a.name,a);
       }
       Asset vtidAsset = Service_LTE_activation_provisioning.createVTIDAsset(terminalIds[0],assetMap);
       system.assertEquals('87654321-LTE', vtidAsset.Name, vtidAsset);
       system.assertEquals(Service_LTE_activation_provisioning.log.success,true);       
       system.assertEquals(Service_LTE_activation_provisioning.log.message.endswith('createVTIDAsset successfully completed.'),true);
   }
   
   //See HTSSF-619...
   static testMethod void test_createVTIDAsset_Exception(){  
       List<HTS_Virtual_Terminal_ID__c> terminalIds = [Select id,Virtual_Terminal_Id__c from HTS_Virtual_Terminal_ID__c];
      
       Map<String,Asset> assetMap = new Map<String,Asset>();
       for(Asset a : [Select id,name, Product2.PRoductCode from Asset]){
         if(a.Product2.ProductCode != '01-0419'){
           assetMap.put(a.name,a);
         }
       }
       Asset vtidAsset = Service_LTE_activation_provisioning.createVTIDAsset(terminalIds[0],assetMap);
       
       system.assertEquals(Service_LTE_activation_provisioning.log.success,false);       
       system.assertEquals(Service_LTE_activation_provisioning.log.message.contains('Could not create VTIDAsset : '),true);
   }
   
   //See HTSSF-643...
   static testMethod void test_updateSubscription_ok(){  
       SBQQ__Subscription__c cleanSubscription = [Select id,Asset__c,Traffic_Identifier__c from SBQQ__Subscription__c limit 1];
      
       Map<String,Asset> assetMap = new Map<String,Asset>();
       Asset a = [Select id,name from Asset where name = '87654321'];
       test.startTest();
       Service_LTE_activation_provisioning.updateSubscription(cleanSubscription, a);
       serviceResults log = Service_LTE_activation_provisioning.getLog();
       test.stopTest();
       system.assertEquals(true, log.success, log);       
       system.assert(log.message.endswith('update subscription successfully completed.'),log.message);
       SBQQ__Subscription__c readSub = [SELECT Id, Asset__r.Name, Traffic_Identifier__c FROM SBQQ__Subscription__c LIMIT 1];
       system.assertEquals('87654321', readSub.Asset__r.Name, readSub);
   }
   
   //See HTSSF-643...
   static testMethod void test_updateSubscription_exception(){  
       SBQQ__Subscription__c cleanSubscription = [Select id,Asset__c,Traffic_Identifier__c from SBQQ__Subscription__c limit 1];
      
       Asset a = new Asset();
       
       Service_LTE_activation_provisioning.updateSubscription(cleanSubscription ,a);
       
       system.assertEquals(Service_LTE_activation_provisioning.log.success,false);       
       system.assertEquals(Service_LTE_activation_provisioning.log.message.contains('update subscription failed'),true);
   }
   
   //See HTSSF-615...
   static testMethod void test_updateVTID_ok(){  

       HTS_Virtual_Terminal_ID__c claimedVTID = [Select id,Date_Issued__c,Virtual_Terminal_Id__c  from HTS_Virtual_Terminal_ID__c limit 1];
       claimedVTID.Date_Issued__c = Datetime.now();
       
       Service_LTE_activation_provisioning.updateVTID(claimedVTID);
       
       system.assertEquals(Service_LTE_activation_provisioning.log.success,true);       
       system.assertEquals(Service_LTE_activation_provisioning.log.message.endswith('updateVTID successfully completed.'),true);
   }

  static testMethod void test_updateVTID_NODATE(){
    HTS_Virtual_Terminal_ID__c claimedVTID = [SELECT id,Date_Issued__c,Virtual_Terminal_Id__c FROM HTS_Virtual_Terminal_ID__c LIMIT 1];
    claimedVTID.Date_Issued__c = null;
    test.startTest();
    Service_LTE_activation_provisioning.updateVTID(claimedVTID);
    serviceResults log = Service_LTE_activation_provisioning.getLog();
    test.stopTest();
    system.assertEquals(false, log.success, log);
    system.assert(log.message.contains('Date issued is blank'), log);
  }
  static testMethod void test_updateVTID_NOVTID(){
    HTS_Virtual_Terminal_ID__c claimedVTID = [SELECT id,Date_Issued__c,Virtual_Terminal_Id__c FROM HTS_Virtual_Terminal_ID__c LIMIT 1];
    claimedVTID.Date_Issued__c = Datetime.now();
    claimedVTID.Virtual_Terminal_Id__c = null;
    test.startTest();
    Service_LTE_activation_provisioning.updateVTID(claimedVTID);
    serviceResults log = Service_LTE_activation_provisioning.getLog();
    test.stopTest();
    system.assertEquals(false, log.success, log);
    system.assert(log.message.contains('Virtual Terminal Id is blank'), log);
  }
  static testMethod void test_updateCaseFields_OK(){
    SBQQ__Subscription__c cleanSubscription = [SELECT id, Name, SBQQ__Product__r.ProductCode, Asset__c, 
                                          Traffic_Identifier__c, SBQQ__Contract__r.Id 
                                          FROM SBQQ__Subscription__c];
    test.startTest();
    Case returnedCase = Service_LTE_activation_provisioning.updateCaseFields(cleanSubscription);
    serviceResults log = Service_LTE_activation_provisioning.getLog();
    test.stopTest();
    system.assertEquals(true, log.success, log);       
    system.assert(log.message.contains('|Successfully updated Case: '),log);
    system.assertEquals('Success', returnedCase.LTE_Provision_Status__c);
    system.assertEquals(AIRTIME_CASE_RECORD_TYPE_ID, returnedCase.RecordTypeId);
  }
  static testMethod void test_updateCaseFields_FAILNOFORM(){
    SBQQ__Subscription__c cleanSubscription = [SELECT id, Name, SBQQ__Product__r.ProductCode, Asset__c, 
                                          Traffic_Identifier__c, SBQQ__Contract__r.Id 
                                          FROM SBQQ__Subscription__c];
    list<Case> caseList = [SELECT Id, CaseNumber, RecordTypeId, Contract__r.Id, 
                                LTE_Transform_Status__c, LTE_Provision_Status__c
                            FROM Case
                            WHERE RecordTypeId =: AIRTIME_CASE_RECORD_TYPE_ID];
    list<LTE_activation__c> forms = [SELECT Id FROM LTE_activation__c];
    delete forms;
    test.startTest();
    Case returnedCase = Service_LTE_activation_provisioning.updateCaseFields(cleanSubscription);
    serviceResults log = Service_LTE_activation_provisioning.getLog();
    test.stopTest();
    //it's not a fatal error, just a warning!
    system.assert(log.message.contains('|Unable to isolate Activation form related to '),log);
  }
  static testMethod void test_updateCaseFields_FAILNOCASE(){
    SBQQ__Subscription__c cleanSubscription = [SELECT id, Name, SBQQ__Product__r.ProductCode, Asset__c, 
                                          Traffic_Identifier__c, SBQQ__Contract__r.Id 
                                          FROM SBQQ__Subscription__c];
    list<Case> caseList = [SELECT Id, CaseNumber, RecordTypeId, Contract__r.Id, 
                                LTE_Transform_Status__c, LTE_Provision_Status__c
                            FROM Case
                            WHERE RecordTypeId =: AIRTIME_CASE_RECORD_TYPE_ID];
    delete caseList[0];
    test.startTest();
    Case returnedCase = Service_LTE_activation_provisioning.updateCaseFields(cleanSubscription);
    serviceResults log = Service_LTE_activation_provisioning.getLog();
    test.stopTest();
    //it's not a fatal error, just a warning!
    system.assert(log.message.contains('|Unable to isolate Case related to '),log);
  }
  static testMethod void test_updateHibernatedSubscription_OK_Term(){
    list<Asset> assetList = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
                              Product2.ProductCode FROM Asset];
    map<String, Asset> assetMap = new map<String, Asset>();
    for(asset a : assetList){
      assetMap.put(a.Name, a);
    }
    //add the VTID Asset to the map!
    Asset vtidAsset = [SELECT Id, Name, Product2.ProductCode FROM Asset WHERE Product2.ProductCode = 'Virtual Terminal ID'];
    assetMap.put(vtidAsset.Product2.ProductCode, vtidAsset);
    SBQQ__Subscription__c cleanSubscription = [SELECT id, Name, SBQQ__Product__r.ProductCode, Asset__c, 
                                      Traffic_Identifier__c, SBQQ__Contract__r.Id 
                                      FROM SBQQ__Subscription__c];
    test.startTest();
    Service_LTE_activation_provisioning.updateHibernatedSubscription(assetMap, true, cleanSubscription);
    serviceResults log = Service_LTE_activation_provisioning.getLog();
    test.stopTest();
    cleanSubscription = [SELECT id, Name, SBQQ__Product__r.ProductCode, Asset__c, 
                                      Traffic_Identifier__c, SBQQ__Contract__r.Id, 
                                      SBQQ__TerminatedDate__c 
                                      FROM SBQQ__Subscription__c];
    system.assertEquals(date.today(), cleanSubscription.SBQQ__TerminatedDate__c, cleanSubscription);
    system.assert(log.message.contains('|Subscription successfully updated'),log);
  }
  /*****************************************************************************
   * Public Method tests
   ****************************************************************************/
  static testMethod void test_provisionLTE_shipped(){
    //Need a Subscription
    SBQQ__Subscription__c readSub = [SELECT Id FROM SBQQ__Subscription__c LIMIT 1];
    //Subscription needs to have a DOME as the Asset
    Asset domeAsset = [SELECT Id FROM Asset WHERE Product2.ProductCode = '02-2280' LIMIT 1];
    readSub.Asset__c = domeAsset.Id;
    update readSub;
    //Need mock response from lte/devices etc...
    QueueHttpMock mock = new QueueHttpMock();
    //need response for GET /lte/subscribers/info
    mock.addResponse(getMock_getLTESubscriberInfo_OK_shipped());
    //need response for POST /lte/subscribers/activate
    mock.addResponse(getMock_noBody(201));
    //need response for GET group_id from /lte/organizations/{org_id}/groups
    mock.addResponse(getMock_getGroupByOrgId_FILTERED_OK());
    //need response for GET /lte/devices/{org_id}/{group_id} for device Id
    mock.addResponse(getMock_getLTEDevices_OK());
    //need response for PUT /lte/devices/{org_id}/{group_id}/{id}
    mock.addResponse(getMock_noBody(204));
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    serviceResults log = Service_LTE_activation_provisioning.provisionLTE(readSub, domeAsset);
    test.stopTest();
    system.debug('Heres the log! ' + log);
    system.assertEquals(true, log.success, log);
    readSub.clear();
    readSub = [SELECT Id, Asset__r.Name, SBQQ__Contract__r.Id,
               Traffic_Identifier__c FROM SBQQ__Subscription__c LIMIT 1];
    system.assertEquals('87654321' + '-11', readSub.Traffic_Identifier__c, log);
    system.assertEquals('87654321' + '-LTE',readSub.Asset__r.Name, readSub); //need update subscription!
    
    HTS_Virtual_Terminal_ID__c readVTID = [SELECT Id, Virtual_Terminal_Id__c, Date_Issued__c FROM HTS_Virtual_Terminal_ID__c LIMIT 1];
    system.assertnotEquals(null, readVTID.Date_Issued__c);
    system.assertEquals('87654321', readVTID.Virtual_Terminal_Id__c);
    
    list<Case> caseList = [SELECT Id, CaseNumber, RecordTypeId, Contract__r.Id, 
                                LTE_Transform_Status__c, LTE_Provision_Status__c
                            FROM Case
                            WHERE RecordTypeId =: AIRTIME_CASE_RECORD_TYPE_ID];
    system.assert(log.message.contains('|Successfully updated Case: '),log);
    system.assertEquals('Success', caseList[0].LTE_Provision_Status__c);
    system.assertEquals(AIRTIME_CASE_RECORD_TYPE_ID, caseList[0].RecordTypeId);
  }
  static testMethod void test_provisionLTE_hibernate(){
    //Need a Subscription
    SBQQ__Subscription__c readSub = [SELECT Id FROM SBQQ__Subscription__c LIMIT 1];
    //Subscription needs to have a DOME as the Asset
    Asset domeAsset = [SELECT Id FROM Asset WHERE Product2.ProductCode = '02-2280' LIMIT 1];
    readSub.Asset__c = domeAsset.Id;
    update readSub;
    //Need mock response from lte/devices etc...
    QueueHttpMock mock = new QueueHttpMock();
    //need response for GET /lte/subscribers/info
    mock.addResponse(getMock_getLTESubscriberInfo_OK_hibernate());
    //need response for POST /lte/subscribers/activate
    mock.addResponse(getMock_noBody(204));
    //need response for GET group_id from /lte/organizations/{org_id}/groups
    mock.addResponse(getMock_getGroupByOrgId_FILTERED_OK());
    //need response for GET /lte/devices/{org_id}/{group_id} for device Id
    mock.addResponse(getMock_getLTEDevices_OK());
    //need response for PUT /lte/devices/{org_id}/{group_id}/{id}
    mock.addResponse(getMock_noBody(204));
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    serviceResults log = Service_LTE_activation_provisioning.provisionLTE(readSub, domeAsset);
    test.stopTest();
    system.debug('Heres the log! ' + log);
    system.assertEquals(true, log.success, log);

    readSub.clear();
    readSub = [SELECT Id, Asset__r.Name, SBQQ__Contract__r.Id, 
              Traffic_Identifier__c FROM SBQQ__Subscription__c LIMIT 1];
    system.assertEquals('87654321' + '-11', readSub.Traffic_Identifier__c, log);
    system.assertEquals('87654321' + '-LTE',readSub.Asset__r.Name, readSub); //need update subscription!
    
    HTS_Virtual_Terminal_ID__c readVTID = [SELECT Id, Virtual_Terminal_Id__c, Date_Issued__c FROM HTS_Virtual_Terminal_ID__c LIMIT 1];
    system.assertnotEquals(null, readVTID.Date_Issued__c);
    system.assertEquals('87654321', readVTID.Virtual_Terminal_Id__c);

    list<Case> caseList = [SELECT Id, CaseNumber, RecordTypeId, Contract__r.Id, 
                                LTE_Transform_Status__c, LTE_Provision_Status__c
                            FROM Case
                            WHERE RecordTypeId =: AIRTIME_CASE_RECORD_TYPE_ID];
    system.assert(log.message.contains('|Successfully updated Case: '),log);
    system.assertEquals('Success', caseList[0].LTE_Provision_Status__c);
    system.assertEquals(AIRTIME_CASE_RECORD_TYPE_ID, caseList[0].RecordTypeId);
  }
  static testMethod void test_provisionLTE_active(){
    //Need a Subscription
    SBQQ__Subscription__c readSub = [SELECT Id FROM SBQQ__Subscription__c LIMIT 1];
    //Subscription needs to have a DOME as the Asset
    Asset domeAsset = [SELECT Id FROM Asset WHERE Product2.ProductCode = '02-2280' LIMIT 1];
    readSub.Asset__c = domeAsset.Id;
    update readSub;
    //Need mock response from lte/devices etc...
    QueueHttpMock mock = new QueueHttpMock();
    //need response for GET /lte/subscribers/info
    mock.addResponse(getMock_getLTESubscriberInfo_OK_active());
    //need response for POST /lte/subscribers/activate
    mock.addResponse(getMock_noBody(204));
    //need response for GET group_id from /lte/organizations/{org_id}/groups
    mock.addResponse(getMock_getGroupByOrgId_FILTERED_OK());
    //need response for GET /lte/devices/{org_id}/{group_id} for device Id
    mock.addResponse(getMock_getLTEDevices_OK());
    //need response for PUT /lte/devices/{org_id}/{group_id}/{id}
    mock.addResponse(getMock_noBody(204));
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    serviceResults log = Service_LTE_activation_provisioning.provisionLTE(readSub, domeAsset);
    test.stopTest();
    readSub.clear();
    system.assertEquals(false, log.success);
    system.assert(log.message.contains('FATAL_ERROR'));
  }
  static testMethod void test_provisionLTE_overload(){
    //Need a Subscription
    SBQQ__Subscription__c readSub = [SELECT Id FROM SBQQ__Subscription__c LIMIT 1];
    //Subscription needs to have a DOME as the Asset
    Asset domeAsset = [SELECT Id FROM Asset WHERE Product2.ProductCode = '02-2280' LIMIT 1];
    readSub.Asset__c = domeAsset.Id;
    update readSub;
    //Need mock response from lte/devices etc...
    QueueHttpMock mock = new QueueHttpMock();
    //need response for GET /lte/subscribers/info
    mock.addResponse(getMock_getLTESubscriberInfo_OK_shipped());
    //need response for POST /lte/subscribers/activate
    mock.addResponse(getMock_noBody(201));
    //need response for GET group_id from /lte/organizations/{org_id}/groups
    mock.addResponse(getMock_getGroupByOrgId_FILTERED_OK());
    //need response for GET /lte/devices/{org_id}/{group_id} for device Id
    mock.addResponse(getMock_getLTEDevices_OK());
    //need response for PUT /lte/devices/{org_id}/{group_id}/{id}
    mock.addResponse(getMock_noBody(204));
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    serviceResults log = Service_LTE_activation_provisioning.provisionLTE(readSub); //The overloaded method!
    test.stopTest();
    system.debug('Heres the log! ' + log);
    readSub.clear();
    readSub = [SELECT Id, Asset__r.Name, Traffic_Identifier__c FROM SBQQ__Subscription__c LIMIT 1];
    system.assertEquals('87654321' + '-11', readSub.Traffic_Identifier__c, log);
    system.assertEquals('87654321' + '-LTE',readSub.Asset__r.Name, readSub); //need update subscription!
    HTS_Virtual_Terminal_ID__c readVTID = [SELECT Id, Virtual_Terminal_Id__c, Date_Issued__c FROM HTS_Virtual_Terminal_ID__c LIMIT 1];
    system.assertnotEquals(null, readVTID.Date_Issued__c);
    system.assertEquals('87654321', readVTID.Virtual_Terminal_Id__c);
  }
  /*****************************************************************************
   *Test methods for hibernateLTE main method 2
   ****************************************************************************/
  static testMethod void test_hibernateLTE_OK(){
    //Need a Subscription
    SBQQ__Subscription__c readSub = [SELECT Id FROM SBQQ__Subscription__c LIMIT 1];
    //Subscription needs to have a DOME as the Asset
    Asset domeAsset = [SELECT Id, Parent_Asset__c FROM Asset WHERE Product2.ProductCode = '02-2280' LIMIT 1];
    readSub.Asset__c = domeAsset.Id;
    update readSub;
    //add the VTID Asset to the Hierarchy!
    Asset vtidAsset = [SELECT Id FROM Asset WHERE Product2.ProductCode = 'Virtual Terminal ID' LIMIT 1];
    vtidAsset.Parent_Asset__c = domeAsset.Parent_Asset__c;
    update vtidAsset;
    //Need mock response from lte/devices etc...
    QueueHttpMock mock = new QueueHttpMock();
    //need response for GET /lte/subscribers/info
    mock.addResponse(getMock_getLTESubscriberInfo_OK_active());
    //need response for POST /lte/subscribers/hibernate
    mock.addResponse(getMock_noBody(204));
    //need response for GET group_id from /lte/organizations/{org_id}/groups
    mock.addResponse(getMock_getGroupByOrgId_FILTERED_OK());
    //need response for GET /lte/devices/{org_id}/{group_id} for device Id
    mock.addResponse(getMock_getLTEDevices_OK());
    //need response for PUT /lte/devices/{org_id}/{group_id}/{id}
    mock.addResponse(getMock_noBody(204));
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    serviceResults log = Service_LTE_activation_provisioning.hibernateLTE(readSub, true);
    test.stopTest();
    system.debug('Heres the log! ' + log);
    system.assertEquals(true, log.success, log);
    readSub.clear();
    readSub = [SELECT Id, Asset__r.Name, SBQQ__Contract__r.Id,
               Traffic_Identifier__c, SBQQ__TerminatedDate__c,SBQQ__Product__c
               FROM SBQQ__Subscription__c LIMIT 1];
    system.assertEquals(Date.today(), readSub.SBQQ__TerminatedDate__c, log);
    system.assert(log.message.contains('SERVICE_FINISHED'),log);
    system.assert(log.message.contains('SUCCESS: LTE Suspension Service completed successfully!'),log);
  }
   /**********************************************************
   * setup methods for commonly used HTTP mock responses....*
   **********************************************************/
  static HttpResponse getMock_noBody(Integer responseCode){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(responseCode);
    return returnMock;
  }
  static HttpResponse getMock_error_500(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(500);
    returnMock.setBody('{"message": "this is a mock error message"}');
    return returnMock;
  }
  static HttpResponse getMock_getLTESubscriberInfo_OK_active(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    returnMock.setBody('{"activation_date": "2018-03-10T00:00:00", ' +
                        '  "apn": "m2mglobal", ' +
                        '  "call_plan": "2GBUSTMO", ' +
                        '  "contract_end_date": "2019-03-10T00:00:00", ' +
                        '  "current_usage": 9999, ' +
                        '  "ipaddress": "99.99.99.99", ' +
                        '  "is_online": false, ' +
                        '  "last_seen": "2018-05-14T19:52:48.8363681Z", ' +
                        '  "last_seen_carrier": "T-Mobile", ' +
                        '  "status": "active", ' +
                        '  "subscriber": { ' +
                        '    "iccid": "8901260882225943783", ' +
                        '    "imsi": "310260761056018" ' +
                        '  }, ' +
                        '  "subscriber_id": "99991234-11"}');
    return returnMock;
  }
  static HttpResponse getMock_getLTESubscriberInfo_OK_shipped(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    returnMock.setBody('{"activation_date": "2018-03-10T00:00:00", ' +
                        '  "apn": "m2mglobal", ' +
                        '  "call_plan": "2GBUSTMO", ' +
                        '  "contract_end_date": "2019-03-10T00:00:00", ' +
                        '  "current_usage": 9999, ' +
                        '  "ipaddress": "99.99.99.99", ' +
                        '  "is_online": false, ' +
                        '  "last_seen": "2018-05-14T19:52:48.8363681Z", ' +
                        '  "last_seen_carrier": "T-Mobile", ' +
                        '  "status": "shipped", ' +
                        '  "subscriber": { ' +
                        '    "iccid": "8901260882225943783", ' +
                        '    "imsi": "310260761056018" ' +
                        '  }, ' +
                        '  "subscriber_id": "99991234-11"}');
    return returnMock;
  }
  static HttpResponse getMock_getLTESubscriberInfo_OK_hibernate(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    returnMock.setBody('{"activation_date": "2018-03-10T00:00:00", ' +
                        '  "apn": "m2mglobal", ' +
                        '  "call_plan": "2GBUSTMO", ' +
                        '  "contract_end_date": "2019-03-10T00:00:00", ' +
                        '  "current_usage": 9999, ' +
                        '  "ipaddress": "99.99.99.99", ' +
                        '  "is_online": false, ' +
                        '  "last_seen": "2018-05-14T19:52:48.8363681Z", ' +
                        '  "last_seen_carrier": "T-Mobile", ' +
                        '  "status": "hibernate", ' +
                        '  "subscriber": { ' +
                        '    "iccid": "8901260882225943783", ' +
                        '    "imsi": "310260761056018" ' +
                        '  }, ' +
                        '  "subscriber_id": "99991234-11"}');
    return returnMock;
  }
  static HttpResponse getMock_getLTESubscriberInfo_404(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(404);
    returnMock.setBody('{"message": "404 Client Error: Not Found for url: '+
                          'https://testapi.datablaze.com/SIM/GetInfo'+
                          '?subscriber.iCCID=8944501312171077550. '+
                          'You have requested this URI '+
                          '[/api/1.0/lte/subscribers/info] but did you mean '+
                          '/api/1.0/lte/subscribers/info or '+
                          '/api/1.0/lte/subscribers/ or '+
                          '/api/1.0/lte/subscribers/terminate ?",'+
                          '"remote_message": ""}');
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
  static HttpResponse getMock_getLTEDevices_OK(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    returnMock.setBody('[{'+
                          '"fw_ver": "7.1.0 build 2860",' + 
                          '"group_id": 131,' + 
                          '"id": 7,' + 
                          '"last_online": "2018-04-10T11:44:31",' + 
                          '"name": "98765432",' + 
                          '"offline_at": "",' + 
                          '"onlineStatus": "ONLINE",' + 
                          '"sn": "2933-BAD9-E505",' + 
                          '"status": "online",' + 
                          '"virtual_device_id": "98765432-LTE"'+
                          '}]');
    return returnMock;
  }
  static HttpResponse getMock_getLTEDevices_EMPTY(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    returnMock.setBody('[]');
    return returnMock;
  }
}