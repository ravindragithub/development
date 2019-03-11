@isTest
private class HTS_ltgsvc_hybrids_test {
//setup testClass variables here. For example:
//RecordType Ids
private static final Id Platform_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Demo/Test/Monitor').getRecordTypeId();
//A common Loop Counter for bulikification purposes
private static final integer MAX_LOOP_COUNTER = 6;
  
  @testSetup static void setupTestData(){
    //setup common test data here
    //Need a Contract!, Contracts need Accounts!!
    //Account a = new Account(Name = 'Test Account', RecordTypeId=Platform_RECORD_TYPE_ID);
    //insert a;


    list<Account> insertAccts = new list<Account>();
    Account testAcct = new Account(Name='Test Account', RecordTypeId=Platform_RECORD_TYPE_ID);
    insertAccts.add(testAcct);
    Account defAcct = new Account(Name='Default Assets');
    insertAccts.add(defAcct);
    insert insertAccts;
    //And a Custom Setting...
    DefaultAccounts__c insertCS = new DefaultAccounts__c(Name='DefaultAssets', Account_ID__c=defAcct.Id, Description__c='default account');
    insert insertCS;


    Contract k = new Contract(AccountId = testAcct.id, Name='Kontrakt');
    insert k;
    //Need some Product2s and HTS Shaping Policies....
    list<HTS_Subscriber_Plans__c> insertList = new list<HTS_Subscriber_Plans__c>();
    for(integer i = 0; i < MAX_LOOP_COUNTER; i++){
      HTS_Subscriber_Plans__c shaPol = new HTS_Subscriber_Plans__c(API_Name__c = 'PLAN_' + i, Name = 'PLAN_' + i, status__c = 'Active');
      insertList.add(shaPol);
    }
    insert insertList;

    list<Product2> insertProds = new list<Product2>();
    //setup service plans first...
    for(HTS_Subscriber_Plans__c sp : insertList){
      Product2 prod = new Product2(ProductCode = 'PROD_' + sp.Name.substringAfter('_'), 
                                   Name = 'PROD_' + sp.Name.substringAfter('_'), 
                                   HTS_Subscriber_Plan__c = sp.Id);
      insertProds.add(prod);
    }
    //Then hardware products...
    list<Product2> insertProds2 = new list<Product2>();
    Product2 vtidProd = new Product2(Name = '12345678', ProductCode = 'Virtual Terminal ID', Product_ID__c='Virtual Terminal ID_US');
    insertProds2.add(vtidProd);
    Product2 ipProd = new Product2(Name = '10.83.83.0', ProductCode = 'HTS IP Address', Product_ID__c='HTS IP Address_US');
    insertProds2.add(ipProd);
    Product2 antProd = new Product2(Name = 'Antenna', ProductCode = '02-1925-01SL', Product_ID__c='02-1925-01SL_US');
    insertProds2.add(antProd);
    Product2 sysProd = new Product2(Name = 'System', ProductCode = '01-0408-15', Product_ID__c='01-0408-15_US');
    insertProds2.add(sysProd);

    insertProds2.addAll(insertProds);
    insert insertProds2;

    list<Asset> assetList = new list<Asset>();
    for(Product2 p : [SELECT Id, ProductCode, Name FROM Product2]){
      if(p.Name.left(5) != 'PROD_'){  //Exclude services!
        Asset a2 = new Asset(Name = p.Name, Product2Id = p.Id, AccountId = testAcct.Id);
        assetList.add(a2);
      }
    }  
    insert assetList;
    assetList.clear();
    assetList = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
                                 Product2.ProductCode FROM Asset];
    map<String, Asset> assetMap = new map<String, Asset>();
    for(Asset a3 : assetList){
      assetMap.put(a3.Name, a3);
    }
    assetList.clear();
    assetMap.get('Antenna').Parent_Asset__c = assetMap.get('System').Id;
    assetMap.get('10.83.83.0').Parent_Asset__c = assetMap.get('Antenna').Id;
    assetMap.get('12345678').Parent_Asset__c = assetMap.get('Antenna').Id;
    assetList = assetMap.values();
    update assetList;

    Asset a4 = [SELECT Id FROM Asset WHERE Name = '12345678' LIMIT 1];

    //Need a couple subscriptions for Sure! an SBQQ__Subscription__c in fact
    SBQQ__Subscription__c testSubsc = new SBQQ__Subscription__c(SBQQ__Quantity__c = 12, SBQQ__Contract__c = k.Id, 
                                                                SBQQ__Product__c = insertProds[0].Id, 
                                                                Asset__c = a4.Id,
                                                                Traffic_Identifier__c = '99995678-01');
    insert testSubsc;
    SBQQ__Subscription__c testSubsc2 = new SBQQ__Subscription__c(SBQQ__Quantity__c = 12, SBQQ__Contract__c = k.Id, 
                                                                 SBQQ__Product__c = insertProds[1].Id, 
                                                                 Asset__c = a4.Id,
                                                                 Traffic_Identifier__c = '99995678-02');
    insert testSubsc2;

    //Need some config tempaltes/regions...
    list<HTS_Terminal_Template__c> insertRegions = new list<HTS_Terminal_Template__c>();
    HTS_Terminal_Template__c CONUS = new HTS_Terminal_Template__c(
      Name='CONUS_STANDARD',
      obj_id__c='CONUS_STANDARD',
      Region__c='CONUS',
      Status__c='Updated from OSS',
      Version__c='0001',
      isReleased__c=True);
    HTS_Terminal_Template__c EMEA = new HTS_Terminal_Template__c(
      Name='EMEA_STANDARD',
      obj_id__c='EMEA_STANDARD',
      Region__c='EMEA',
      Status__c='New from OSS',
      Version__c='0001',
      isReleased__c=True);
    HTS_Terminal_Template__c APAC = new HTS_Terminal_Template__c(
      Name='APAC_STANDARD',
      obj_id__c='APAC_STANDARD',
      Region__c='APAC',
      Status__c='New from OSS',
      Version__c='0001',
      isReleased__c=True);
    insertRegions.add(CONUS);
    insertRegions.add(EMEA);
    insertRegions.add(APAC);
    insert insertRegions;
  }
  
  static testMethod void testSetupData(){
    //use this method to validate that you have test data setup correctly
    //this will protect you from changes to workflow, process, and validation that break your test code!
    list<Account> readAccts = [SELECT Id, Name FROM Account];
    system.assertEquals(2, readAccts.size());
    DefaultAccounts__c defaultAssets = DefaultAccounts__c.getInstance('DefaultAssets');
    system.assertNotEquals(null, defaultAssets.Account_ID__c);
    list<Contract> readList = [SELECT Id, ContractNumber, AccountId FROM Contract];
    system.assertEquals(1, readList.size());
    list<HTS_Subscriber_Plans__c> readPols = [SELECT Id, API_Name__c FROM HTS_Subscriber_Plans__c];
    system.assertEquals(MAX_LOOP_COUNTER, readPols.size());
    list<Product2> readProds = [SELECT Id, ProductCode, HTS_Subscriber_Plan__c FROM Product2];
    system.assertEquals(MAX_LOOP_COUNTER + 4, readProds.size());
    list<Asset> readAssets = [SELECT Id, Name FROM Asset];
    system.assertEquals(4, readAssets.size());
    list<SBQQ__Subscription__c> readRecords = [SELECT Id, Name FROM SBQQ__Subscription__c];
    system.assertEquals(2, readRecords.size());
    list<HTS_Terminal_Template__c> readRegions = [SELECT Id, obj_id__c FROM HTS_Terminal_Template__c];
    system.assertEquals(3, readRegions.size());
  }

  static testMethod void test_getContract(){
    Contract k = [SELECT Id, ContractNumber, AccountId FROM Contract WHERE Name = 'Kontrakt' LIMIT 1];
    String goodId = (String)k.Id;
    String badId = '800000000000AAA';
    test.startTest();
    HTS_ltgsvc_hybrids hybrids = new HTS_ltgsvc_hybrids();
    system.assertEquals('INITIALIZED...', hybrids.statusMessage);
    hybrids = HTS_ltgsvc_hybrids.getContract(goodId);
    system.assertEquals('SUCCESS:', hybrids.statusMessage.left(8), hybrids.statusMessage);
    system.assertNotEquals(null, hybrids.parentContr);
    system.assertEquals('Kontrakt', hybrids.parentContr.Name);
    hybrids = new HTS_ltgsvc_hybrids();
    system.assertEquals('INITIALIZED...', hybrids.statusMessage);
    hybrids = HTS_ltgsvc_hybrids.getContract(badId);
    system.assertEquals('ERROR:', hybrids.statusMessage.left(6), hybrids.statusMessage);
    system.assertEquals(null, hybrids.parentContr.Id);
    test.stopTest();
  }

  static testMethod void test_getHTSPlans(){
    test.startTest();
    list<Product2> readProds = HTS_ltgsvc_hybrids.getHTSPlans();
    test.stopTest();
    system.assertEquals(MAX_LOOP_COUNTER, readProds.size());
    for(Product2 p : readProds){
      system.assertEquals('PROD_', p.name.left(5));
    }
  }
  static testMethod void test_getTerminal(){
    test.startTest();
    HTS_ltgsvc_hybrids returnObj = HTS_ltgsvc_hybrids.getTerminal('12345678');
    
    system.assertEquals('SUCCESS:', returnObj.statusMessage.left(8));
    system.assertEquals('12345678', returnObj.virtualTerminal.Name);
    Asset a = returnObj.virtualTerminal;
    delete a;
    HTS_ltgsvc_hybrids returnObj2 = HTS_ltgsvc_hybrids.getTerminal('12345678');
    system.assertEquals('ERROR:', returnObj2.statusMessage.left(6));
    test.stopTest();
  }
  static testMethod void test_createOneSub(){
    Contract k = [SELECT Id, Name FROM Contract LIMIT 1];
    Asset a = [SELECT Id, Name FROM Asset WHERE Name = '12345678' LIMIT 1];
    Product2 p = [SELECT Id, Name FROM Product2 WHERE NAME LIKE 'PROD_%' LIMIT 1];
    String tid = '12345678-01';
    String pId = (String)p.Id;
    String reg = 'CONUS_STANDARD';
    test.startTest();
    SBQQ__Subscription__c returnObj = HTS_ltgsvc_hybrids.createOneSub(k,a,pId,tid,reg);
    insert returnObj; //just to test....
    test.stopTest();
    system.debug(returnObj);
  }
  static testMethod void test_createTwoSubs(){
    Contract k = [SELECT Id, Name FROM Contract LIMIT 1];
    Asset a = [SELECT Id, Name FROM Asset WHERE Name = '12345678' LIMIT 1];
    list<Product2> pList = [SELECT Id, Name FROM Product2 WHERE NAME LIKE 'PROD_%' LIMIT 2];
    String p0 = (String)pList[0].Id;
    String p1 = (String)pList[1].Id;
    String reg = 'CONUS_STANDARD';
    test.startTest();
    HTS_ltgsvc_hybrids returnObj = HTS_ltgsvc_hybrids.createTwoSubs(k, a, p0, p1, reg);
    test.stopTest();
    system.debug(returnObj);
    list<SBQQ__Subscription__c> readList = [SELECT Id, Name, Traffic_Identifier__c, Asset__r.Name, 
                                            Asset__r.Product2.ProductCode 
                                            FROM SBQQ__Subscription__c
                                            WHERE Traffic_Identifier__c LIKE '12345678%'];
    system.assertEquals(2, readList.size());
    for(SBQQ__Subscription__c q : readList){
      system.debug('Traffic ID: ' + q.Traffic_Identifier__c);
    }
  }
  static testMethod void test_invokeServiceClass_FAIL(){
    //Need to collect subs, and setup mocks
    map<String, SBQQ__Subscription__c> subsMap = new map<String, SBQQ__Subscription__c>();
    for(SBQQ__Subscription__c s : [SELECT Id, Name, Traffic_Identifier__c, Asset__r.Name, 
                                        Asset__r.Product2.ProductCode 
                                        FROM SBQQ__Subscription__c
                                        WHERE Traffic_Identifier__c LIKE '99995678%']){
      subsMap.put(s.Traffic_Identifier__c, s);
    }
    test.startTest();
    HTS_ltgsvc_hybrids returnObj = HTS_ltgsvc_hybrids.invokeServiceClass(subsMap.get('99995678-01'), subsMap.get('99995678-02'));
    test.stopTest();
    system.assertEquals('ERROR:', returnObj.statusMessage.left(6), returnObj);
  }
  static testMethod void test_invokeServiceClass_SUCCESS(){
    //Need to collect subs, and setup mocks
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //Provision two subs, one at a time...
    mock.addResponse(getMock_postSubscriber_OK());
    mock.addResponse(getMock_postSubscriber_OK());
    //Then find the "Enabled" sub...
    mock.addResponse(getMock_subscribersList_OK());
    //Then delete it!
    mock.addResponse(getMock_noBody(204));
    Test.setMock(HttpCalloutMock.class, mock);
    map<String, SBQQ__Subscription__c> subsMap = new map<String, SBQQ__Subscription__c>();
    for(SBQQ__Subscription__c s : [SELECT Id, Name, Traffic_Identifier__c, Asset__r.Name, 
                                        Asset__r.Product2.ProductCode 
                                        FROM SBQQ__Subscription__c
                                        WHERE Traffic_Identifier__c LIKE '99995678%']){
      subsMap.put(s.Traffic_Identifier__c, s);
    }
    test.startTest();
    HTS_ltgsvc_hybrids returnObj = HTS_ltgsvc_hybrids.invokeServiceClass(subsMap.get('99995678-01'), subsMap.get('99995678-02'));
    test.stopTest();
    system.assertEquals('SUCCESS:', returnObj.statusMessage.left(8), returnObj);
  }
  static testMethod void test_invokeTerminateService(){
    //Need to collect subs, and setup mocks
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //mock response for removeSubsFromOSS(cleanSubs);
    mock.addResponse(getMock_terminalListOf1());
    mock.addResponse(getMock_noBody(204));
    mock.addResponse(getMock_terminalListOf1());
    mock.addResponse(getMock_noBody(204));
    //mock response for deleteTerminal(cleanSubs[0].Asset__r.Name);
    mock.addResponse(getMock_terminalListOf1());
    mock.addResponse(getMock_noBody(204));
    mock.addResponse(getMock_noBody(204));
    Test.setMock(HttpCalloutMock.class, mock);map<String, SBQQ__Subscription__c> subsMap = new map<String, SBQQ__Subscription__c>();
    for(SBQQ__Subscription__c s : [SELECT Id, Name, Traffic_Identifier__c, Asset__r.Name, 
                                        Asset__r.Product2.ProductCode 
                                        FROM SBQQ__Subscription__c
                                        WHERE Traffic_Identifier__c LIKE '99995678%']){
      subsMap.put(s.Traffic_Identifier__c, s);
    }
    test.startTest();
    HTS_ltgsvc_hybrids returnObj = HTS_ltgsvc_hybrids.invokeTerminateService(subsMap.get('99995678-01'), subsMap.get('99995678-02'));
    serviceResults returnedLog = Service_provisionHTSHybrids.getLog();
    test.stopTest();
    system.assertEquals('SUCCESS:', returnObj.statusMessage.left(8), returnedLog);
  }
  static testMethod void test_getRegions(){
    list<HTS_Terminal_Template__c> readRegions = new list<HTS_Terminal_Template__c>();
    test.startTest();
    readRegions = HTS_ltgsvc_hybrids.getRegions();
    system.assertEquals(3, readRegions.size());

    readRegions[0].Region__c = null;
    update readRegions[0];
    readRegions.clear();
    readRegions = HTS_ltgsvc_hybrids.getRegions();
    test.stopTest();
    system.assertEquals(2, readRegions.size());
  }

  //setup methods for commonly used HTTP mock responses....
  static HttpResponse getMock_postSubscriber_OK(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(201);
    returnMock.setBody('{"subscriber_plan_id":"Enabled","subscriber_ip_addresses":["10.83.7.0/24"],"subscriber_id":"99997101-00"}');
    return returnMock;
  }

  static HttpResponse getMock_subscribersList_OK(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    string response = '';
    response += '[';
    response += '{ "obj_id": "00000000-0000-0001-0000-000000000001", "status": "Active", "subscriber_id": "99995678-00", "subscriber_plan_id": "PLAN_1" },';
    response += '{ "obj_id": "00000000-0000-0001-0000-000000000002", "status": "Active", "subscriber_id": "99995678-01", "subscriber_plan_id": "PLAN_2" },';
    response += '{ "obj_id": "00000000-0000-0001-0000-000000000003", "status": "Active", "subscriber_id": "99995678-02", "subscriber_plan_id": "PLAN_2" }';
    response += ']';
    returnMock.setBody(response);
    return returnMock;
  }

  static HttpResponse getMock_noBody(Integer responseCode){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(responseCode);
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
}