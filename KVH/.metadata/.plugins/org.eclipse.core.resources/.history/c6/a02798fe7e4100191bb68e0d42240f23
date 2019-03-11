@isTest
private class HTS_ltgsvc_subscriptions_test {
  //might not need record types...
  //private static final Id AirTime_Contract_RECORD_TYPE_ID = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Airtime Contract').getRecordTypeId();
  private static final Id Service_Product2_RECORD_TYPE_ID = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Service').getRecordTypeId();

  @testSetup static void setupTestData(){
    //Need an Account and a Kontract with a "K"
    Account testAcct = new Account(Name='Test Account');
    insert testAcct;
    Contract k = new Contract(AccountId = testAcct.Id);
    insert k;
    //Need a couple of Products and a related Shaping Policies....
    HTS_Subscriber_Plans__c testPlanM50 = new HTS_Subscriber_Plans__c(Name='M50', API_Name__c='M50', Status__c='Active');
    insert testPlanM50;
    HTS_Subscriber_Plans__c testPlanEnabled = new HTS_Subscriber_Plans__c(Name='Enabled', API_Name__c='Enabled', Status__c='Active');
    insert testPlanEnabled;
    list<Product2> prodList = new list<Product2>();
    //Need a couple of SERVICE Products....
    Product2 testProd = new Product2(Name='HTS M50', RecordTypeId=Service_Product2_RECORD_TYPE_ID, HTS_Subscriber_Plan__c=testPlanM50.Id);
    prodList.add(testProd);
    Product2 testProd2 = new Product2(Name='HTS Enabled', RecordTypeId=Service_Product2_RECORD_TYPE_ID, HTS_Subscriber_Plan__c=testPlanEnabled.Id);
    prodList.add(testProd2);
    //Need several HARDWARE Products...
    Product2 vtidProd = new Product2(Name = '12345678', ProductCode = 'Virtual Terminal ID', Product_ID__c='Virtual Terminal ID_US');
    prodList.add(vtidProd);
    Product2 ipProd = new Product2(Name = 'IP', ProductCode = 'HTS IP Address', Product_ID__c='HTS IP Address_US');
    prodList.add(ipProd);
    Product2 antProd = new Product2(Name = 'Antenna', ProductCode = '02-1925-01SL', Product_ID__c='02-1925-01SL_US');
    prodList.add(antProd);
    Product2 sysProd = new Product2(Name = 'System', ProductCode = '01-0408-15', Product_ID__c='01-0408-15_US');
    prodList.add(sysProd);
    insert prodList;

    list<Asset> assetList = new list<Asset>();
    for(Product2 p : [SELECT Id, ProductCode, Name FROM Product2]){
      if(p.Name.left(3) != 'HTS'){  //Exclude services!
        Asset a = new Asset(Name = p.Name, Product2Id = p.Id);
        assetList.add(a);
      }
    }  
    insert assetList;
    assetList.clear();
    assetList = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
                                 Product2.ProductCode FROM Asset];
    map<String, Asset> assetMap = new map<String, Asset>();
    for(asset a : assetList){
      assetMap.put(a.Name, a);
    }
    assetList.clear();
    assetMap.get('Antenna').Parent_Asset__c = assetMap.get('System').Id;
    assetMap.get('IP').Parent_Asset__c = assetMap.get('Antenna').Id;
    assetMap.get('12345678').Parent_Asset__c = assetMap.get('Antenna').Id;
    assetList = assetMap.values();
    update assetList;
    //Need a couple subscriptions for Sure! an SBQQ__Subscription__c in fact
    SBQQ__Subscription__c testSubsc = new SBQQ__Subscription__c(SBQQ__Quantity__c = 1, SBQQ__Contract__c = k.Id, 
                                                                SBQQ__Product__c = testProd.Id, 
                                                                Traffic_Identifier__c = '12345678-01', 
                                                                Asset__c = assetMap.get('12345678').Id);
    insert testSubsc;
    SBQQ__Subscription__c testSubsc2 = new SBQQ__Subscription__c(SBQQ__Quantity__c = 1, SBQQ__Contract__c = k.Id, 
                                                                 SBQQ__Product__c = testProd2.Id, 
                                                                 Traffic_Identifier__c = '12345678-00', 
                                                                 Asset__c = assetMap.get('12345678').Id);
    insert testSubsc2;
  }
  
  static testMethod void testSetupData() {
    // Test that your test data is setup correctly
    list<SBQQ__Subscription__c> readRecords = [SELECT Id, Name FROM SBQQ__Subscription__c];
    system.assertEquals(2, readRecords.size());
    list<HTS_Subscriber_Plans__c> readPolicies = [SELECT Id, Name, API_Name__c FROM HTS_Subscriber_Plans__c];
    system.assertEquals(2, readPolicies.size());
    list<Product2> readProds = [SELECT Id, Name FROM Product2];
    system.assertEquals(6, readProds.size());
    list<Asset> readAssets = [SELECT Id, Name FROM ASSET];
    system.assertEquals(4, readAssets.size());
  }

  static testMethod void test_getSubscription(){
    list<SBQQ__Subscription__c> readRecords = new list<SBQQ__Subscription__c>();
    readRecords = [SELECT Id, Name FROM SBQQ__Subscription__c];
    system.assertEquals(2, readRecords.size());
    HTS_ltgsvc_subscriptions oneSubscription = HTS_ltgsvc_subscriptions.getSubscription(readRecords[0].Id);
    system.assertEquals(1, oneSubscription.subscriptions.size());
    system.assertEquals('Test Account', oneSubscription.subscriptions[0].SBQQ__Contract__r.Account.Name);
    system.assertEquals('SUCCESS:', oneSubscription.statusMessage.left(8));
    delete readRecords;
    oneSubscription = HTS_ltgsvc_subscriptions.getSubscription(readRecords[0].Id);
    system.assertEquals(0, oneSubscription.subscriptions.size());
    system.assertEquals('ERROR: No records found', oneSubscription.statusMessage);
  }
  static testMethod void test_getSubscriptionList(){
    HTS_ltgsvc_subscriptions util = new HTS_ltgsvc_subscriptions();
    util = HTS_ltgsvc_subscriptions.getSubscriptionList('12345678');
    system.assertEquals(2, util.subscriptions.size());
    system.assertEquals('SUCCESS: More than one record found', util.statusMessage);
    delete util.subscriptions[0];
    util = new HTS_ltgsvc_subscriptions();
    util = HTS_ltgsvc_subscriptions.getSubscriptionList('12345678');
    system.assertEquals(1, util.subscriptions.size());
    system.assertEquals('SUCCESS: Single record found', util.statusMessage);
    delete util.subscriptions[0];
    util = new HTS_ltgsvc_subscriptions();
    util = HTS_ltgsvc_subscriptions.getSubscriptionList('12345678');
    system.assertEquals(0, util.subscriptions.size());
    system.assertEquals('SUCCESS: No records found', util.statusMessage);
  }
  static testMethod void test_updateSubscription_OK_sameTID(){
    //Tests normal execution flow
    //Need a subscription to a '-01' kind of plan...
    list<SBQQ__Subscription__c> readRecords = [SELECT Id, Name, SBQQ__Contract__c, Asset__r.Name, Traffic_Identifier__c, 
                                                      SBQQ__Product__c, SBQQ__Product__r.Name, SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                                                      FROM SBQQ__Subscription__c WHERE SBQQ__Product__r.Name = 'HTS M50'];
    //Need mock response from hts/subscribers PUT service...
    QueueHttpMock mock = new QueueHttpMock();
    HttpResponse res1 = new HttpResponse();
    res1.setStatusCode(204);
    //res1.setStatusCode(200);  //a mock GET response, terminal on enabled-00 plan
    //res1.setBody('{"obj_id":"00000000-0000-0001-0000-000000000f46","status":"Active","subscriber_id":"12345678-01","subscriber_ip_addresses":["10.83.65.0/28","10.83.65.16/28","10.83.65.64/26","10.83.65.192/26"],"subscriber_plan_id":"Suspended"}');
    mock.addResponse(res1);
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    HTS_ltgsvc_subscriptions returnedObj = HTS_ltgsvc_subscriptions.updateSubscription('00000000-0000-0001-0000-000000000f46','12345678-01',readRecords[0]);
    test.stopTest();
    system.assertEquals('SUCCESS: OSS returned: 204', returnedObj.statusMessage);
  }
  static testMethod void test_updateSubscription_OK_changeTID(){
    //Tests normal execution flow
    //Need a subscription to a '-01' kind of plan...
    list<SBQQ__Subscription__c> readRecords = [SELECT Id, Name, SBQQ__Contract__c, Asset__r.Name, Traffic_Identifier__c, 
                                                      SBQQ__Product__c, SBQQ__Product__r.Name, SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                                                      FROM SBQQ__Subscription__c WHERE SBQQ__Product__r.Name = 'HTS M50'];
    //Need mock response from hts/subscribers...queue up GET, POST, DELETE
    QueueHttpMock mock = new QueueHttpMock();
    HttpResponse res1 = new HttpResponse();
    res1.setStatusCode(200);  //a mock GET response, terminal on enabled-00 plan
    res1.setBody('{"obj_id":"00000000-0000-0001-0000-000000000f46","status":"Active","subscriber_id":"12345678-00","subscriber_ip_addresses":["10.64.64.0/24"],"subscriber_plan_id":"Enabled"}');
    mock.addResponse(res1);
    HttpResponse res2 = new HttpResponse();
    res2.setStatusCode(201);
    mock.addResponse(res2);
    HttpResponse res3 = new HttpResponse();
    res3.setStatusCode(204);
    mock.addResponse(res3);
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    HTS_ltgsvc_subscriptions returnedObj = HTS_ltgsvc_subscriptions.updateSubscription('00000000-0000-0001-0000-000000000f46','12345678-00',readRecords[0]);
    test.stopTest();
    system.assertEquals('SUCCESS: OSS returned: 204', returnedObj.statusMessage);
    readRecords.clear();
    readRecords = [SELECT Id, Name, SBQQ__Contract__c, Asset__r.Name, Traffic_Identifier__c, 
                                                      SBQQ__Product__c, SBQQ__Product__r.Name, SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                                                      FROM SBQQ__Subscription__c WHERE SBQQ__Product__r.Name = 'HTS M50'];
    system.assertEquals('12345678-01', readRecords[0].Traffic_Identifier__c);
  }

  static testMethod void test_processResponseCode(){
    HTS_ltgsvc_subscriptions util = new HTS_ltgsvc_subscriptions();
    system.assertEquals('SUCCESS: OSS returned: 201', util.processResponseCode(201));
    system.assertEquals('SUCCESS: OSS returned: 204', util.processResponseCode(204));
    system.assertEquals('ERROR: OSS returned: 404 Subscriber not found!', util.processResponseCode(404));
    system.assertEquals('ERROR: OSS returned: 500 OSS failed to update Subscriber!', util.processResponseCode(500));
  }

  static testMethod void test_generateTID(){
    //Tests normal execution flow
    //Need a subscription
    list<SBQQ__Subscription__c> readRecords = [SELECT Id, Name, SBQQ__Contract__c, Asset__r.Name, Traffic_Identifier__c, 
                                                      SBQQ__Product__c, SBQQ__Product__r.Name, SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                                                      FROM SBQQ__Subscription__c];
    HTS_ltgsvc_subscriptions util = new HTS_ltgsvc_subscriptions();
    for(SBQQ__Subscription__c s : readRecords){
      if(s.SBQQ__Product__r.HTS_Subscriber_Plan__r.Name == 'Enabled'){
        //test Enabled subscription, should return 12345678-00
        string results = util.generateTID( s);
        system.assertEquals('12345678-00', results);
      } else {
        //test M50 subscription, should return 12345678-01
        string results = util.generateTID(s);
        system.assertEquals('12345678-01', results);
      }
    }
  }
  static testMethod void test_moveIdentifiersToChildOfRoot(){
    HTS_ltgsvc_subscriptions util = new HTS_ltgsvc_subscriptions();
    list<Asset> assetList = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
                                 Product2.ProductCode FROM Asset];
    map<String, Asset> assetMap = new map<String, Asset>();
    for(asset a : assetList){
      assetMap.put(a.Name, a);
    }
    //Test pre-condition NOT Equal!
    system.assertNotEquals(assetMap.get('12345678').Parent_Asset__c, assetMap.get('12345678').Root_Asset__c);
    system.assertNotEquals(assetMap.get('IP').Parent_Asset__c, assetMap.get('IP').Root_Asset__c);
    test.startTest();
    util.moveIdentifiersToChildOfRoot('12345678');
    test.stopTest();
    //Test post-condition Equal! Need to re-query and re-map
    assetList.clear();
    assetMap.clear();
    assetList = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
                                 Product2.ProductCode FROM Asset];
    for(asset a : assetList){
      assetMap.put(a.Name, a);
    }
    system.assertEquals(assetMap.get('12345678').Parent_Asset__c, assetMap.get('12345678').Root_Asset__c);
    system.assertEquals(assetMap.get('IP').Parent_Asset__c, assetMap.get('IP').Root_Asset__c);
  }
  static testMethod void test_getIpRangeByTID(){
    HTSOSS_hts_subscribers sub = new HTSOSS_hts_subscribers();
    sub.subscriber_id = '12345678-01';
    list<String> IpRanges = new list<String>();
    IpRanges.add('10.83.83.0/24');
    sub.subscriber_ip_addresses = IpRanges;
    test.startTest();
    list<String> primaryRanges = HTS_ltgsvc_subscriptions.getIpRangeByTID(sub);
    sub.subscriber_id = '12345678-02';
    list<String> secondaryRanges = HTS_ltgsvc_subscriptions.getIpRangeByTID(sub);
    system.debug('Returned List of Primary IP ranges: ' + primaryRanges);
    system.debug('Returned List of Secondary IP ranges: ' + secondaryRanges);
    test.stopTest();
    system.assertEquals(4, primaryRanges.size());
    set<String> rangesSet = new set<String>(primaryRanges);
    system.assert(rangesSet.contains('10.83.83.0/28'));
    system.assert(rangesSet.contains('10.83.83.16/28'));
    system.assert(rangesSet.contains('10.83.83.64/26'));
    system.assert(rangesSet.contains('10.83.83.192/26'));
    rangesSet.clear();
    system.assertEquals(2, secondaryRanges.size());
    rangesSet.addAll(secondaryRanges);
    system.assert(rangesSet.contains('10.83.83.32/28'));
    system.assert(rangesSet.contains('10.83.83.128/26'));
  }
}