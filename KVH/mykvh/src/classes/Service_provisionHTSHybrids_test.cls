@isTest
private class Service_provisionHTSHybrids_test {
  //setup testClass variables here. For example:
  //RecordType Ids
  private static final Id Service_Product2_RECORD_TYPE_ID = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Service').getRecordTypeId();
  private static final Id ServCloud_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Cloud').getRecordTypeId();
  private static final Id Platform_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Demo/Test/Monitor').getRecordTypeId();
  private static final Id Customer_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Customer').getRecordTypeId();
  @testSetup static void setupTestData(){
    //Need an Accounts...
    list<Account> insertAccts = new list<Account>();
    Account testAcct = new Account(Name='Test Account', RecordTypeId=Platform_RECORD_TYPE_ID);
    insertAccts.add(testAcct);
    Account defAcct = new Account(Name='Default Assets');
    insertAccts.add(defAcct);
    insert insertAccts;
    //And a Custom Setting...
    DefaultAccounts__c insertCS = new DefaultAccounts__c(Name='DefaultAssets', Account_ID__c=defAcct.Id, Description__c='default account');
    insert insertCS;
    //...and a Kontract with a "K"
    Contract k = new Contract(AccountId = testAcct.Id);
    insert k;
    //Need a couple of Products and a related Shaping Policies....
    list<HTS_Subscriber_Plans__c> shapolList = new list<HTS_Subscriber_Plans__c>();
    HTS_Subscriber_Plans__c testPlanM50 = new HTS_Subscriber_Plans__c(Name='M50', API_Name__c='M50', Status__c='Active');
    shapolList.add(testPlanM50);
    HTS_Subscriber_Plans__c testPlanOP2K = new HTS_Subscriber_Plans__c(Name='OP2K', API_Name__c='OP2K', Status__c='Active');
    shapolList.add(testPlanOP2K);
    HTS_Subscriber_Plans__c testPlanEnabled = new HTS_Subscriber_Plans__c(Name='Enabled', API_Name__c='Enabled', Status__c='Active');
    shapolList.add(testPlanEnabled);
    insert shapolList;

    //Need a couple of SERVICE Products....
    list<Product2> prodList = new list<Product2>();
    Product2 testProd = new Product2(Name='HTS M50', RecordTypeId=Service_Product2_RECORD_TYPE_ID, HTS_Subscriber_Plan__c=testPlanM50.Id);
    prodList.add(testProd);
    Product2 testProd2 = new Product2(Name='HTS Enabled', RecordTypeId=Service_Product2_RECORD_TYPE_ID, HTS_Subscriber_Plan__c=testPlanOP2K.Id);
    prodList.add(testProd2);
    //Need several HARDWARE Products...
    Product2 vtidProd = new Product2(Name = '12345678', ProductCode = 'Virtual Terminal ID', Product_ID__c='Virtual Terminal ID_US');
    prodList.add(vtidProd);
    Product2 ipProd = new Product2(Name = '10.83.83.0', ProductCode = 'HTS IP Address', Product_ID__c='HTS IP Address_US');
    prodList.add(ipProd);
    Product2 i2cmProd = new Product2(Name = 'I2CM', ProductCode = '02-2204-02', Product_ID__c='02-2204-02_US');
    prodList.add(i2cmProd);
    Product2 antProd = new Product2(Name = 'Antenna', ProductCode = '02-1925-01SL', Product_ID__c='02-1925-01SL_US');
    prodList.add(antProd);
    Product2 sysProd = new Product2(Name = 'System', ProductCode = '01-0408-15', Product_ID__c='01-0408-15_US');
    prodList.add(sysProd);
    Product2 ui2cmProd = new Product2(Name = 'PACKAGED I2CM TPV7IP 4/500 refurbished', ProductCode = 'U02-2204-02');
    prodList.add(ui2cmProd);
    insert prodList;

    list<Asset> assetList = new list<Asset>();
    for(Product2 p : [SELECT Id, ProductCode, Name FROM Product2]){
      if(p.Name.left(3) != 'HTS'){  //Exclude services!
        Asset a = new Asset(Name = p.Name, Product2Id = p.Id, AccountId = testAcct.Id);
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
    assetMap.get('I2CM').Parent_Asset__c = assetMap.get('System').Id;
    assetMap.get('10.83.83.0').Parent_Asset__c = assetMap.get('Antenna').Id;
    assetMap.get('12345678').Parent_Asset__c = assetMap.get('Antenna').Id;
    assetList = assetMap.values();
    update assetList;
    //Need a clone for test purposes....
    Asset clone = assetMap.get('12345678').clone(false, true);
    clone.name = '87654321';
    clone.Parent_Asset__c = null;
    clone.AccountId = defAcct.Id;
    insert clone;
    //Need a couple subscriptions for Sure! an SBQQ__Subscription__c in fact
    SBQQ__Subscription__c testSubsc = new SBQQ__Subscription__c(SBQQ__Quantity__c = 1, SBQQ__Contract__c = k.Id, 
                                                                SBQQ__Product__c = testProd.Id, 
                                                                Asset__c = assetMap.get('12345678').Id,
                                                                Traffic_Identifier__c = '12345678-01');
    insert testSubsc;
    SBQQ__Subscription__c testSubsc2 = new SBQQ__Subscription__c(SBQQ__Quantity__c = 1, SBQQ__Contract__c = k.Id, 
                                                                 SBQQ__Product__c = testProd2.Id, 
                                                                 Asset__c = assetMap.get('12345678').Id,
                                                                 Traffic_Identifier__c = '12345678-02');
    insert testSubsc2;
  }

  static testMethod void testSetupData(){
    // Test that your test data is setup correctly
    list<Account> readAccts = [SELECT id, Name, RecordType.DeveloperName FROM Account];
    system.assertEquals(2, readAccts.size());
    DefaultAccounts__c defaultAssets = DefaultAccounts__c.getInstance('DefaultAssets');
    system.assertNotEquals(null, defaultAssets.Account_ID__c);
    system.assertEquals('Platform_', readAccts[0].RecordType.DeveloperName.left(9));
    list<SBQQ__Subscription__c> readRecords = [SELECT Id, Name FROM SBQQ__Subscription__c];
    system.assertEquals(2, readRecords.size());
    list<HTS_Subscriber_Plans__c> readPolicies = [SELECT Id, Name, API_Name__c FROM HTS_Subscriber_Plans__c];
    system.assertEquals(3, readPolicies.size());
    list<Product2> readProds = [SELECT Id, Name FROM Product2];
    system.assertEquals(8, readProds.size());
    list<Asset> readAssets = [SELECT Id, Name FROM ASSET];
    system.assertEquals(7, readAssets.size());
  }
  static testMethod void test_staticLog(){
    serviceResults logStringResponse = Service_provisionHTSHybrids.getLog();
    system.assert(logStringResponse.message.contains('SERVICE_INITIALIZATION'));
    system.assert(logStringResponse.message.contains('Initializing HTS Hybrids Provisioning Service'), logStringResponse);
  }
  static testMethod void test_returnFatalError(){
    test.startTest();
    serviceResults returnedLog = Service_provisionHTSHybrids.returnFatalError();
    test.stopTest();
    system.debug('log message: ' + returnedLog.message);
    system.assert(returnedLog.message.contains('HTS Hybrid Plans Service failed ' + 
                                                'to complete successfully. See log for details.'), returnedLog.message);
    Case c = [SELECT ID, Subject, Status, Origin, RecordTypeId, Description, CaseNumber FROM Case LIMIT 1];
    system.assertEquals(ServCloud_RECORD_TYPE_ID, c.RecordTypeId);
    system.assertEquals('Fatal Error in Service_provisionHTSHybrids Class', c.Subject);
    system.assertEquals('System Generated', c.Origin);
    system.assertEquals('New', c.Status);
  }
  static testMethod void test_getIpRanges(){
    test.startTest();
    map<String, String> readMap = Service_provisionHTSHybrids.getIpRanges();
    serviceResults returnedLog = Service_provisionHTSHybrids.getLog();
    test.stopTest();
    //Adding or removing HTS_Hybrid_Plan_IP_Ranges__mdt record will break this test!
    system.assertEquals(8, readMap.size());
    system.assertEquals(true, returnedLog.success);
    system.assert(returnedLog.message.contains('METHOD_EXIT'));
    system.assert(returnedLog.message.contains('Read 8 IP provisioning ranges from Custom Metadata Type'));
  }
  static testMethod void test_preProcessValidation_FAILforTwos(){
    list<SBQQ__Subscription__c> subsList = [SELECT Id, SBQQ__Product__c, Asset__c 
                                            FROM SBQQ__Subscription__c];
    system.assertEquals(2, subsList.size());
    subsList.remove(1);
    test.startTest();
    Service_provisionHTSHybrids.preProcessValidation(subsList);
    serviceResults returnedLog = Service_provisionHTSHybrids.getLog();
    test.stopTest();
    system.assertEquals(false, returnedLog.success);
  }
  static testMethod void test_preProcessValidation_FAILmissingId(){
    list<SBQQ__Subscription__c> subsList = [SELECT Id, SBQQ__Product__c, Asset__c 
                                            FROM SBQQ__Subscription__c];
    system.assertEquals(2, subsList.size());
    subsList[0].Id = null;
    test.startTest();
    Service_provisionHTSHybrids.preProcessValidation(subsList);
    serviceResults returnedLog = Service_provisionHTSHybrids.getLog();
    test.stopTest();
    system.assertEquals(false, returnedLog.success);
  }
  static testMethod void test_preProcessValidation_OK(){
    list<SBQQ__Subscription__c> subsList = [SELECT Id, SBQQ__Product__c, Asset__c 
                                            FROM SBQQ__Subscription__c];
    system.assertEquals(2, subsList.size());
    test.startTest();
    Service_provisionHTSHybrids.preProcessValidation(subsList);
    serviceResults returnedLog = Service_provisionHTSHybrids.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success);
  }
  static testMethod void test_getCleanSubs_OK(){
    list<SBQQ__Subscription__c> subsList = [SELECT Id, SBQQ__Product__c, Asset__c 
                                            FROM SBQQ__Subscription__c];
    system.assertEquals(2, subsList.size());
    list<SBQQ__Subscription__c> returnList = new list<SBQQ__Subscription__c>();
    test.startTest();
    returnList = Service_provisionHTSHybrids.getCleanSubs(subsList);
    serviceResults returnedLog = Service_provisionHTSHybrids.getLog();
    system.assertEquals(2, returnList.size());
    system.assertEquals(true, returnedLog.success);

  }
  static testMethod void test_getCleanSubs_FAIL_1Row(){
    list<SBQQ__Subscription__c> subsList = [SELECT Id, SBQQ__Product__c, Asset__c 
                                            FROM SBQQ__Subscription__c];
    system.assertEquals(2, subsList.size());
    list<SBQQ__Subscription__c> returnList = new list<SBQQ__Subscription__c>();
    delete subsList[1];
    test.startTest();
    returnList = Service_provisionHTSHybrids.getCleanSubs(subsList);
    serviceResults returnedLog = Service_provisionHTSHybrids.getLog();
    system.assertEquals(1, returnList.size());
    system.assertEquals(false, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('Service requires two and only two Subscriptions!'));
    test.stopTest();
  }
  static testMethod void test_getCleanSubs_FAIL_noShaPol(){
    list<SBQQ__Subscription__c> subsList = [SELECT Asset__r.Name, Asset__r.Parent_Asset__c, 
                                                   Asset__r.Product2.ProductCode, Asset__c, 
                                                   Traffic_Identifier__c, 
                                                   SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                                            FROM SBQQ__Subscription__c];
    system.assertEquals(2, subsList.size());
    list<SBQQ__Subscription__c> returnList = new list<SBQQ__Subscription__c>();
    subsList[1].SBQQ__Product__c = null;
    update subsList[1];
    test.startTest();
    returnList = Service_provisionHTSHybrids.getCleanSubs(subsList);
    serviceResults returnedLog = Service_provisionHTSHybrids.getLog();
    system.assertEquals(2, returnList.size());
    system.assertEquals(false, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('One or Both Subscription Products are missing the Shaping Policy!'));
    test.stopTest();
  }
  static testMethod void test_getCleanSubs_FAIL_noTID(){
    list<SBQQ__Subscription__c> subsList = [SELECT Asset__r.Name, Asset__r.Parent_Asset__c, 
                                                   Asset__r.Product2.ProductCode, Asset__c, 
                                                   Traffic_Identifier__c, 
                                                   SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                                            FROM SBQQ__Subscription__c];
    system.assertEquals(2, subsList.size());
    list<SBQQ__Subscription__c> returnList = new list<SBQQ__Subscription__c>();
    subsList[1].Traffic_Identifier__c = null;
    update subsList[1];
    test.startTest();
    returnList = Service_provisionHTSHybrids.getCleanSubs(subsList);
    serviceResults returnedLog = Service_provisionHTSHybrids.getLog();
    system.assertEquals(2, returnList.size());
    system.assertEquals(false, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('One or Both Subscriptions are missing the Traffic Identifier!'));
    test.stopTest();
  }
  static testMethod void test_getCleanSubs_FAIL_notSameAsset(){
    list<SBQQ__Subscription__c> subsList = [SELECT Asset__r.Name, Asset__r.Parent_Asset__c, 
                                                   Asset__r.Product2.ProductCode, Asset__c, 
                                                   Traffic_Identifier__c, 
                                                   SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                                            FROM SBQQ__Subscription__c];
    system.assertEquals(2, subsList.size());
    list<Asset> assetList = [SELECT Id, Name FROM Asset WHERE Name = '87654321'];
    system.assertEquals(1, assetList.size());
    subsList[1].Asset__c = assetList[0].Id;
    update subsList[1];
    list<SBQQ__Subscription__c> returnList = new list<SBQQ__Subscription__c>();
    test.startTest();
    returnList = Service_provisionHTSHybrids.getCleanSubs(subsList);
    serviceResults returnedLog = Service_provisionHTSHybrids.getLog();
    system.assertEquals(2, returnList.size());
    system.assertEquals(false, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('Both Subscription must have the Same Asset!'));
    test.stopTest();
  }
  static testMethod void test_getCleanSubs_FAIL_noPlatform(){
    list<Asset> assetList = [SELECT Id, Name FROM Asset WHERE Name = 'System']; //Need to move ROOT!
    system.assertEquals(1, assetList.size());
    Account testAcct2 = new Account(Name='Test Customer Account');  //NOTE: no record ID
    insert testAcct2;
    assetList[0].AccountId = testAcct2.Id;
    update assetList[0];
    list<SBQQ__Subscription__c> subsList = [SELECT Asset__r.Name, Asset__r.Parent_Asset__c, 
                                                   Asset__r.Product2.ProductCode, Asset__c, 
                                                   Traffic_Identifier__c, 
                                                   SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                                            FROM SBQQ__Subscription__c];
    system.assertEquals(2, subsList.size());

    list<SBQQ__Subscription__c> returnList = new list<SBQQ__Subscription__c>();
    test.startTest();
    returnList = Service_provisionHTSHybrids.getCleanSubs(subsList);
    serviceResults returnedLog = Service_provisionHTSHybrids.getLog();
    system.assertEquals(2, returnList.size());
    system.assertEquals(false, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('Clean Subscriptions detected Asset not related to Platform!'));
    test.stopTest();
  }
  static testMethod void test_getIPfromVTID_OK(){
    list<SBQQ__Subscription__c> subsList = [SELECT Id, Asset__r.Name, Asset__r.Parent_Asset__r.Id, 
                                                   Asset__r.Product2.ProductCode, Asset__c, 
                                                   Traffic_Identifier__c, 
                                                   SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                                          FROM SBQQ__Subscription__c];
    system.assertEquals(2, subsList.size());
    list<Asset> assetList = [SELECT Id, Name, Parent_Asset__c, Product2.ProductCode FROM Asset ];
    for(Asset a : assetList){
      system.debug(a);
    }
    test.startTest();
    String ipBase = Service_provisionHTSHybrids.getIPfromVTID(subsList[0]);
    serviceResults returnedLog = Service_provisionHTSHybrids.getLog();
    test.stopTest();
    system.assertEquals('10.83.83.0', ipBase, returnedLog);
    system.assertEquals(true, returnedLog.success, returnedLog);
  }
  static testMethod void test_getIPfromVTID_FAIL(){
    list<SBQQ__Subscription__c> subsList = [SELECT Id, Asset__r.Name, Asset__r.Parent_Asset__r.Id, 
                                                   Asset__r.Product2.ProductCode, Asset__c, 
                                                   Traffic_Identifier__c, 
                                                   SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                                          FROM SBQQ__Subscription__c];
    system.assertEquals(2, subsList.size());
    list<Asset> assetList = [SELECT Id, Name, Parent_Asset__c, Product2.ProductCode FROM Asset ];
    for(Asset a : assetList){
      system.debug(a);
    }
    list<Asset> readList = [SELECT Id, Name, Parent_Asset__c, Product2.ProductCode
                            FROM Asset 
                            WHERE Product2.ProductCode = 'HTS IP Address'];
    system.assertEquals(1, readList.size(),'Somthing wrong with the test data... only expected one Asset!');
    Asset rougeIP = readList[0].clone(false, true, false, false);
    rougeIP.Name = '10.83.84.0';
    insert rougeIP;
    //system.assert(false, rougeIP);
    test.startTest();
    String ipBase = Service_provisionHTSHybrids.getIPfromVTID(subsList[0]);
    serviceResults returnedLog = Service_provisionHTSHybrids.getLog();
    test.stopTest();
    system.assert(returnedLog.message.contains('Query returned 2 IP Addresses!'), returnedLog);
    system.assertEquals(false, returnedLog.success, returnedLog);
  }
  static testMethod void test_getSubsMap_OK(){
    list<SBQQ__Subscription__c> subsList = [SELECT Id, Asset__r.Name, Asset__r.Parent_Asset__r.Id, 
                                                Asset__r.Product2.ProductCode, Asset__c, 
                                                Traffic_Identifier__c, 
                                                SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                                          FROM SBQQ__Subscription__c];
    system.assertEquals(2, subsList.size());
    system.debug(subsList);
    test.startTest();
    map<String, HTSOSS_hts_subscribers> subsMap = Service_provisionHTSHybrids.getSubsMap(subsList);
    serviceResults returnedLog = Service_provisionHTSHybrids.getLog();
    test.stopTest();
    system.assertEquals(2, subsMap.size(), subsMap);
  }
  static testMethod void test_getSubsMap_TIDdup(){
    list<SBQQ__Subscription__c> subsList = [SELECT Id, Asset__r.Name, Asset__r.Parent_Asset__r.Id, 
                                                Asset__r.Product2.ProductCode, Asset__c, 
                                                Traffic_Identifier__c, 
                                                SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                                          FROM SBQQ__Subscription__c];
    system.assertEquals(2, subsList.size());
    subsList[0].Traffic_Identifier__c = subsList[1].Traffic_Identifier__c;
    update subsList[0];
    test.startTest();
    map<String, HTSOSS_hts_subscribers> subsMap = Service_provisionHTSHybrids.getSubsMap(subsList);
    serviceResults returnedLog = Service_provisionHTSHybrids.getLog();
    test.stopTest();
    system.assertEquals(1, subsMap.size(), subsMap);
    system.assertEquals(false, returnedLog.success, returnedLog);
  }
  static testMethod void test_getSubsMap_TIDerr(){
    list<SBQQ__Subscription__c> subsList = [SELECT Id, Asset__r.Name, Asset__r.Parent_Asset__r.Id, 
                                                Asset__r.Product2.ProductCode, Asset__c, 
                                                Traffic_Identifier__c, 
                                                SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                                          FROM SBQQ__Subscription__c];
    system.assertEquals(2, subsList.size());
    subsList[1].Traffic_Identifier__c = '12345678-00';
    update subsList[0];
    test.startTest();
    map<String, HTSOSS_hts_subscribers> subsMap = Service_provisionHTSHybrids.getSubsMap(subsList);
    serviceResults returnedLog = Service_provisionHTSHybrids.getLog();
    test.stopTest();
    system.assertEquals(1, subsMap.size(), subsMap);
    system.assertEquals(false, returnedLog.success, returnedLog);
  }
  static testMethod void test_provisionTwoSubs_OK(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_postSubscriber_OK());
    mock.addResponse(getMock_postSubscriber_OK());
    Test.setMock(HttpCalloutMock.class, mock);
    //need test objects...
    HTSOSS_hts_subscribers sub1 = new HTSOSS_hts_subscribers();
    sub1.subscriber_id = '12345678-01';
    sub1.subscriber_plan_id = 'M50';
    sub1.subscriber_ip_addresses = new string[]{'10.83.83.16/28', '10.83.83.64/26'};
    
    HTSOSS_hts_subscribers sub2 = new HTSOSS_hts_subscribers();
    sub2.subscriber_id = '12345678-02';
    sub2.subscriber_plan_id = 'OP2K';
    sub2.subscriber_ip_addresses = new string[]{'10.83.83.32/28', '10.83.83.128/26'};

    list<HTSOSS_hts_subscribers> subsList = new list<HTSOSS_hts_subscribers>();
    subsList.add(sub1);
    subsList.add(sub2);

    test.startTest();
    list<HTSOSS_hts_subscribers> returnList = Service_provisionHTSHybrids.provisionTwoSubs(subsList);
    serviceResults returnedLog = Service_provisionHTSHybrids.getLog();
    test.stopTest();
    system.assertEquals(2, returnList.size(), returnedLog);
    system.assertEquals(true, returnedLog.success, returnedLog);
  }

  static testMethod void test_provisionTwoSubs_FAIL(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_postSubscriber_OK());
    mock.addResponse(getMock_postSubscriber_FAIL());
    Test.setMock(HttpCalloutMock.class, mock);
    //need test objects...
    HTSOSS_hts_subscribers sub1 = new HTSOSS_hts_subscribers();
    sub1.subscriber_id = '12345678-01';
    sub1.subscriber_plan_id = 'M50';
    sub1.subscriber_ip_addresses = new string[]{'10.83.83.16/28', '10.83.83.64/26'};
    
    HTSOSS_hts_subscribers sub2 = new HTSOSS_hts_subscribers();
    sub2.subscriber_id = '12345678-02';
    sub2.subscriber_plan_id = 'OP2K';
    sub2.subscriber_ip_addresses = new string[]{'10.83.83.32/28', '10.83.83.128/26'};

    list<HTSOSS_hts_subscribers> subsList = new list<HTSOSS_hts_subscribers>();
    subsList.add(sub1);
    subsList.add(sub2);

    test.startTest();
    list<HTSOSS_hts_subscribers> returnList = Service_provisionHTSHybrids.provisionTwoSubs(subsList);
    serviceResults returnedLog = Service_provisionHTSHybrids.getLog();
    test.stopTest();
    system.assertEquals(2, returnList.size(), returnedLog);
    system.assertEquals(false, returnedLog.success, returnedLog);
  }

  static testMethod void test_deleteEnabledTID_OK(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_subscribersList_OK());
    mock.addResponse(getMock_noBody(204));
    Test.setMock(HttpCalloutMock.class, mock);
    //Need a subscription to submit..
    list<SBQQ__Subscription__c> subsList = [SELECT Id, Asset__r.Name, Asset__r.Parent_Asset__r.Id, 
                                            Asset__r.Product2.ProductCode, Asset__c, 
                                            Traffic_Identifier__c, 
                                            SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                                      FROM SBQQ__Subscription__c];
    
    system.assertEquals(2, subsList.size());
    test.startTest();
    String resultsString = Service_provisionHTSHybrids.deleteEnabledTID(subsList[0]);
    serviceResults returnedLog = Service_provisionHTSHybrids.getLog();
    test.stopTest();
    System.assert(returnedLog.message.contains('Successfully Deleted:'), returnedLog);
  }
  static testMethod void test_deleteEnabledTID_unexpected(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_subscribersList_OK());
    mock.addResponse(getMock_noBody(420));
    Test.setMock(HttpCalloutMock.class, mock);
    //Need a subscription to submit..
    list<SBQQ__Subscription__c> subsList = [SELECT Id, Asset__r.Name, Asset__r.Parent_Asset__r.Id, 
                                            Asset__r.Product2.ProductCode, Asset__c, 
                                            Traffic_Identifier__c, 
                                            SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                                      FROM SBQQ__Subscription__c];
    
    system.assertEquals(2, subsList.size());
    test.startTest();
    String resultsString = Service_provisionHTSHybrids.deleteEnabledTID(subsList[0]);
    serviceResults returnedLog = Service_provisionHTSHybrids.getLog();
    test.stopTest();
    system.assertEquals('OSS error related to: ', resultsString.left(22));
    System.assert(returnedLog.message.contains('Unexpected Behavior, OSS returned '), returnedLog);
  }
  static testMethod void test_deleteEnabledTID_MULTI(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_subscribersList_OK_Multi());
    Test.setMock(HttpCalloutMock.class, mock);
    //Need a subscription to submit..
    list<SBQQ__Subscription__c> subsList = [SELECT Id, Asset__r.Name, Asset__r.Parent_Asset__r.Id, 
                                            Asset__r.Product2.ProductCode, Asset__c, 
                                            Traffic_Identifier__c, 
                                            SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                                      FROM SBQQ__Subscription__c];
    
    system.assertEquals(2, subsList.size());
    test.startTest();
    String resultsString = Service_provisionHTSHybrids.deleteEnabledTID(subsList[0]);
    serviceResults returnedLog = Service_provisionHTSHybrids.getLog();
    test.stopTest();
    System.assert(resultsString.contains('Found multiple instances of'), returnedLog);
  }
  static testMethod void test_deleteEnabledTID_Empty(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_subscribersList_Empty());
    Test.setMock(HttpCalloutMock.class, mock);
    //Need a subscription to submit..
    list<SBQQ__Subscription__c> subsList = [SELECT Id, Asset__r.Name, Asset__r.Parent_Asset__r.Id, 
                                            Asset__r.Product2.ProductCode, Asset__c, 
                                            Traffic_Identifier__c, 
                                            SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                                      FROM SBQQ__Subscription__c];
    
    system.assertEquals(2, subsList.size());
    test.startTest();
    String resultsString = Service_provisionHTSHybrids.deleteEnabledTID(subsList[0]);
    serviceResults returnedLog = Service_provisionHTSHybrids.getLog();
    test.stopTest();
    System.assert(resultsString.contains('Failed to find'), returnedLog);
  }
  static testMethod void test_moveIdentifiersToChildOfRoot(){
    map<String, Asset> assetMap = new map<String, Asset>();
    for(Asset a : [SELECT Id, Name, Parent_Asset__c FROM Asset]){
      assetMap.put(a.Name, a);
    }
    Asset sys = assetMap.get('System');
    system.assertNotEquals(sys.Id, assetMap.get('12345678').Parent_Asset__c);
    system.assertNotEquals(sys.Id, assetMap.get('10.83.83.0').Parent_Asset__c);
    test.startTest();
    list<Asset> returnList = Service_provisionHTSHybrids.moveIdentifiersToChildOfRoot('12345678');
    test.stopTest();
    assetMap.clear();
    for(Asset a : returnList){
      assetMap.put(a.Name, a);
    }
    system.assertEquals(sys.Id, assetMap.get('12345678').Parent_Asset__c);
    system.assertEquals(sys.Id, assetMap.get('10.83.83.0').Parent_Asset__c);
  }
  static testMethod void test_retireIdentifiers_OK(){
    DefaultAccounts__c defaultAssets = DefaultAccounts__c.getInstance('DefaultAssets');
    map<String, Asset> assetMap = new map<String, Asset>();
    for(Asset a : [SELECT Id, Name, AccountId, Parent_Asset__c FROM Asset]){
      assetMap.put(a.Name, a);
    }
    Asset sys = assetMap.get('System');
    system.assertEquals(sys.AccountId, assetMap.get('12345678').AccountId);
    system.assertEquals(sys.AccountId, assetMap.get('10.83.83.0').AccountId);
    test.startTest();
    list<Asset> returnList = Service_provisionHTSHybrids.retireIdentifiers('12345678');
    test.stopTest();
    system.assertEquals(3,returnList.size(),returnList);
    assetMap.clear();
    for(Asset a : returnList){
      assetMap.put(a.Name, a);
    }
    system.assertNotEquals(defaultAssets.Account_ID__c, sys.AccountId);
    system.assertEquals(defaultAssets.Account_ID__c, assetMap.get('12345678').AccountId);
    system.assertEquals(defaultAssets.Account_ID__c, assetMap.get('10.83.83.0').AccountId);
  }
  static testMethod void test_retireIdentifiers_OK_Upart(){
    DefaultAccounts__c defaultAssets = DefaultAccounts__c.getInstance('DefaultAssets');
    map<String, Asset> assetMap = new map<String, Asset>();
    for(Asset a : [SELECT Id, Name, AccountId, Parent_Asset__c FROM Asset]){
      assetMap.put(a.Name, a);
    }
    Asset sys = assetMap.get('System');
    system.assertEquals(sys.AccountId, assetMap.get('12345678').AccountId);
    system.assertEquals(sys.AccountId, assetMap.get('10.83.83.0').AccountId);
    //inject "U" part into hierarchy by converting I2CM to U02-2204-02
    list<Product2> uParts = [SELECT Id FROM Product2 WHERE ProductCode = 'U02-2204-02'];
    system.assertEquals(1, uParts.size(), 'Something wrong with test data, only expected a single "U" part');
    Asset uPart = new Asset();
    uPart.Id = assetMap.get('I2CM').Id;
    uPart.Product2Id = uParts[0].Id;
    update uPart;
    list<Asset> reviewList = new list<Asset>();
    reviewList.add(assetMap.get('I2CM'));
    reviewList.add(uPart);
    //system.assert(false, reviewList);
    test.startTest();
    list<Asset> returnList = Service_provisionHTSHybrids.retireIdentifiers('12345678');
    test.stopTest();
    system.assertEquals(3,returnList.size(),returnList);
    assetMap.clear();
    for(Asset a : returnList){
      assetMap.put(a.Name, a);
    }
    system.assertNotEquals(defaultAssets.Account_ID__c, sys.AccountId);
    system.assertEquals(defaultAssets.Account_ID__c, assetMap.get('12345678').AccountId);
    system.assertEquals(defaultAssets.Account_ID__c, assetMap.get('10.83.83.0').AccountId);
  }
  static testMethod void test_deleteTerminal_OK(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_terminalListOf1());
    mock.addResponse(getMock_noBody(204));
    mock.addResponse(getMock_noBody(204));
    Test.setMock(HttpCalloutMock.class, mock);
    //Need a subscription to submit..
    
    test.startTest();
    Service_provisionHTSHybrids.deleteTerminal('12345678');
    serviceResults returnedLog = Service_provisionHTSHybrids.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success);
    system.assert(returnedLog.message.contains('Successfully DELETE-ed Terminal: '), returnedLog);
  }
  static testMethod void test_deleteTerminal_MULTI(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_terminalListOf2());
    mock.addResponse(getMock_noBody(204));
    mock.addResponse(getMock_noBody(204));
    Test.setMock(HttpCalloutMock.class, mock);
    //Need a subscription to submit..
    
    test.startTest();
    Service_provisionHTSHybrids.deleteTerminal('12345678');
    serviceResults returnedLog = Service_provisionHTSHybrids.getLog();
    test.stopTest();
    system.assertEquals(false, returnedLog.success);
    system.assert(returnedLog.message.contains('2 Terminals found in OSS!'), returnedLog);
  }
  static testMethod void test_deleteTerminal_PUT_FAIL(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_terminalListOf1());
    mock.addResponse(getMock_noBody(420));
    mock.addResponse(getMock_noBody(204));
    Test.setMock(HttpCalloutMock.class, mock);
    //Need a subscription to submit..
    
    test.startTest();
    Service_provisionHTSHybrids.deleteTerminal('12345678');
    serviceResults returnedLog = Service_provisionHTSHybrids.getLog();
    test.stopTest();
    system.assertEquals(false, returnedLog.success);
    system.assert(returnedLog.message.contains('Unable to PUT inactive state to Terminal: '), returnedLog);
  }
  static testMethod void test_deleteTerminal_DELETE_FAIL(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_terminalListOf1());
    mock.addResponse(getMock_noBody(204));
    mock.addResponse(getMock_noBody(420));
    Test.setMock(HttpCalloutMock.class, mock);
    //Need a subscription to submit..
    
    test.startTest();
    Service_provisionHTSHybrids.deleteTerminal('12345678');
    serviceResults returnedLog = Service_provisionHTSHybrids.getLog();
    test.stopTest();
    system.assertEquals(false, returnedLog.success);
    system.assert(returnedLog.message.contains('Could not DELETE Terminal!'), returnedLog);
  }
  static testMethod void test_removeSubsFromOSS_OK(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //get the list (loop #1)
    mock.addResponse(getMock_subscribersList_OK());
    //delete the sub
    mock.addResponse(getMock_noBody(204));
    //get the list (loop #2)
    mock.addResponse(getMock_subscribersList_OK());
    //delete the sub
    mock.addResponse(getMock_noBody(204));
    Test.setMock(HttpCalloutMock.class, mock);
    //Need a subscription list to submit..
    list<SBQQ__Subscription__c> subsList = [SELECT Id, Asset__r.Name, Asset__r.Parent_Asset__r.Id, 
                                            Asset__r.Product2.ProductCode, Asset__c, 
                                            Traffic_Identifier__c, 
                                            SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                                      FROM SBQQ__Subscription__c];
    
    system.assertEquals(2, subsList.size());
    test.startTest();
    Service_provisionHTSHybrids.removeSubsFromOSS(subsList);
    serviceResults returnedLog = Service_provisionHTSHybrids.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success);
    system.assert(returnedLog.message.contains('Successfully DELETE-ed subscriber'));
  }
  static testMethod void test_removeSubsFromOSS_500_420(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //get the list (loop #1)
    mock.addResponse(getMock_subscribersList_OK());
    //delete the sub
    mock.addResponse(getMock_noBody(500));
    //get the list (loop #2)
    mock.addResponse(getMock_subscribersList_OK());
    //delete the sub
    mock.addResponse(getMock_noBody(420));
    Test.setMock(HttpCalloutMock.class, mock);
    //Need a subscription list to submit..
    list<SBQQ__Subscription__c> subsList = [SELECT Id, Asset__r.Name, Asset__r.Parent_Asset__r.Id, 
                                            Asset__r.Product2.ProductCode, Asset__c, 
                                            Traffic_Identifier__c, 
                                            SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                                      FROM SBQQ__Subscription__c];
    
    system.assertEquals(2, subsList.size());
    test.startTest();
    Service_provisionHTSHybrids.removeSubsFromOSS(subsList);
    serviceResults returnedLog = Service_provisionHTSHybrids.getLog();
    test.stopTest();
    system.assertEquals(false, returnedLog.success);
    system.assert(returnedLog.message.contains('An Unexpected Error has Occurred '));
    system.assert(returnedLog.message.contains('Cound not DELETE Subscriber: '));
  }
  static testMethod void test_removeSubsFromOSS_TIDNOTFOUND(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //get the list (loop #1)
    mock.addResponse(getMock_subscribersList_Empty());
    //delete the sub
    mock.addResponse(getMock_noBody(204));
    //get the list (loop #2)
    mock.addResponse(getMock_subscribersList_OK());
    //delete the sub
    mock.addResponse(getMock_noBody(204));
    Test.setMock(HttpCalloutMock.class, mock);
    //Need a subscription list to submit..
    list<SBQQ__Subscription__c> subsList = [SELECT Id, Asset__r.Name, Asset__r.Parent_Asset__r.Id, 
                                            Asset__r.Product2.ProductCode, Asset__c, 
                                            Traffic_Identifier__c, 
                                            SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                                      FROM SBQQ__Subscription__c];
    
    system.assertEquals(2, subsList.size());
    test.startTest();
    Service_provisionHTSHybrids.removeSubsFromOSS(subsList);
    serviceResults returnedLog = Service_provisionHTSHybrids.getLog();
    test.stopTest();
    system.assertEquals(false, returnedLog.success);
    system.assert(returnedLog.message.contains('Found 0 Terminals named:'), returnedLog);
  }
  static testMethod void test_applyTerminatedDate(){
    list<SBQQ__Subscription__c> subsList = [SELECT Id, Asset__r.Name, Asset__r.Parent_Asset__r.Id, 
                                        Asset__r.Product2.ProductCode, Asset__c, 
                                        Traffic_Identifier__c, SBQQ__TerminatedDate__c,
                                        SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                                  FROM SBQQ__Subscription__c];
    system.assertEquals(2, subsList.size());
    for(SBQQ__Subscription__c s : subsList){
      system.assertEquals(null, s.SBQQ__TerminatedDate__c);
    }
    test.startTest();
    list<SBQQ__Subscription__c> returnedList = Service_provisionHTSHybrids.applyTerminatedDate(subsList);
    test.stopTest();
    for(SBQQ__Subscription__c s : returnedList){
      system.assertEquals(date.today(), s.SBQQ__TerminatedDate__c);
    }
  }
  static testMethod void test_applyActiveFlag(){
    list<SBQQ__Subscription__c> subsList = [SELECT Id, Asset__r.Name, Asset__r.Parent_Asset__r.Id, 
                                        Asset__r.Product2.ProductCode, Asset__c, Status__c, 
                                        Traffic_Identifier__c, SBQQ__TerminatedDate__c,
                                        SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                                  FROM SBQQ__Subscription__c];
    system.assertEquals(2, subsList.size());
    for(SBQQ__Subscription__c s : subsList){
      system.assertEquals(null, s.Status__c);
    }
    test.startTest();
    list<SBQQ__Subscription__c> returnedList = Service_provisionHTSHybrids.applyActiveFlag(subsList);
    test.stopTest();
    for(SBQQ__Subscription__c s : returnedList){
      system.assertEquals('Active', s.Status__c);
    }
  }
  static testMethod void test_enqueueIdentifiersJob(){
    //Need mock response from hts/satelliterouters etc...
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_CoreIdList_OK());
    mock.addResponse(getMock_postTermAsynch_OK());
    mock.addResponse(getMock_postSubscriber_OK());
    Test.setMock(HttpCalloutMock.class, mock);
    list<Asset> readList = [SELECT Id, Name, Parent_Asset__c FROM Asset WHERE Name = 'I2CM'];
    system.assertEquals(1, readList.size(), readList);
    
    insert new HTS_IP_Address__c(HTS_IP_HEX_Address__c = '0A.53.53.00', HTS_IP_Address__c = '10.83.83.0', Management_IP_Address__c = '10.242.2.5');
    insert new HTS_Virtual_Terminal_ID__c(Virtual_Terminal_Id__c = '99999901');
    insert new HTS_Terminal_Template__c(obj_id__c='CONUS_STANDARD', isDefault__c=true, Name='CONUS_STANDARD');
    
    test.startTest();
    Id returnedJob = Service_provisionHTSHybrids.enqueueIdentifiersJob(readList[0]);
    serviceResults returnedLog = Service_provisionHTSHybrids.getLog();
    test.stopTest();
    
    system.assert(returnedLog.message.contains('METHOD_EXIT'));
    system.assert(returnedLog.message.contains('Successful Job ID: '), returnedLog.message); 
    system.debug(returnedLog);
  }
  /*******************************************
   * Main Method #1 test                     *
   *******************************************/
  static testMethod void test_provisionHybrid(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //setup mock responses for the method: provisionTwoSubs(provisioningMap.values());
    mock.addResponse(getMock_postSubscriber_OK());
    mock.addResponse(getMock_postSubscriber_OK());
    //Then find the "Enabled" sub...
    mock.addResponse(getMock_subscribersList_OK());
    //Then delete it!
    mock.addResponse(getMock_noBody(204));
    Test.setMock(HttpCalloutMock.class, mock);
    //Need a subscription list to submit..
    list<SBQQ__Subscription__c> subsList = [SELECT Id, Asset__r.Name, Asset__r.Parent_Asset__r.Id, 
                                            Asset__r.Product2.ProductCode, Asset__c, 
                                            Traffic_Identifier__c, 
                                            SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                                      FROM SBQQ__Subscription__c];
    
    system.assertEquals(2, subsList.size());
    test.startTest();
    Service_provisionHTSHybrids.provisionHybrid(subsList);
    serviceResults returnedLog = Service_provisionHTSHybrids.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success);
    system.assert(returnedLog.message.contains('SUCCESS: HTS Hybrids Provisioning Service completed successfully!'));
  }
  /*******************************************
   * Main Method #2 test                     *
   *******************************************/
  static testMethod void test_terminateHybrid(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //setup mock responses for the method: removeSubsFromOSS(cleanSubs); 
    mock.addResponse(getMock_subscribersList_OK());
    mock.addResponse(getMock_noBody(204));
    mock.addResponse(getMock_subscribersList_OK());    
    mock.addResponse(getMock_noBody(204));
    //setup mock responses for the method: deleteTerminal(cleanSubs[0].Asset__r.Name);
    //Get the list of (One) Terminals
    mock.addResponse(getMock_terminalListOf1());
    //Put the one Terminal off-line
    mock.addResponse(getMock_noBody(204));
    //Then delete it!
    mock.addResponse(getMock_noBody(204));
    Test.setMock(HttpCalloutMock.class, mock);
    //Need a subscription list to submit..
    list<SBQQ__Subscription__c> subsList = [SELECT Id, Asset__r.Name, Asset__r.Parent_Asset__r.Id, 
                                            Asset__r.Product2.ProductCode, Asset__c, 
                                            Traffic_Identifier__c, 
                                            SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                                      FROM SBQQ__Subscription__c];
    
    system.assertEquals(2, subsList.size());
    test.startTest();
    Service_provisionHTSHybrids.terminateHybrid(subsList);
    serviceResults returnedLog = Service_provisionHTSHybrids.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('SUCCESS: HTS Hybrids Termination Service completed successfully!'), returnedLog);
  }
  /*******************************************
   * Main Method #2 test #2                  *
   *******************************************/
  static testMethod void test_terminateHybrid_uPart(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //setup mock responses for the method: removeSubsFromOSS(cleanSubs); 
    mock.addResponse(getMock_subscribersList_OK());
    mock.addResponse(getMock_noBody(204));
    mock.addResponse(getMock_subscribersList_OK());    
    mock.addResponse(getMock_noBody(204));
    //setup mock responses for the method: deleteTerminal(cleanSubs[0].Asset__r.Name);
    //Get the list of (One) Terminals
    mock.addResponse(getMock_terminalListOf1());
    //Put the one Terminal off-line
    mock.addResponse(getMock_noBody(204));
    //Then delete it!
    mock.addResponse(getMock_noBody(204));
    Test.setMock(HttpCalloutMock.class, mock);
    //Need a subscription list to submit..
    list<SBQQ__Subscription__c> subsList = [SELECT Id, Asset__r.Name, Asset__r.Parent_Asset__r.Id, 
                                            Asset__r.Product2.ProductCode, Asset__c, 
                                            Traffic_Identifier__c, 
                                            SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                                      FROM SBQQ__Subscription__c];
    
    system.assertEquals(2, subsList.size());
    //inject "U" part into hierarchy by converting I2CM to U02-2204-02
    list<Product2> uParts = [SELECT Id FROM Product2 WHERE ProductCode = 'U02-2204-02'];
    system.assertEquals(1, uParts.size(), 'Something wrong with test data, only expected a single "U" part');
    list<Asset> i2cmAsset = [SELECT Id, Product2Id, Product2.PRoductCode 
                             FROM Asset 
                             WHERE Product2.ProductCode = '02-2204-02'];
    system.assertEquals(1, i2cmAsset.size(), 'Something wrong with test data, only expected a single "U" part');
    i2cmAsset[0].Product2Id = uParts[0].Id;
    update i2cmAsset;

    test.startTest();
    Service_provisionHTSHybrids.terminateHybrid(subsList);
    serviceResults returnedLog = Service_provisionHTSHybrids.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('SUCCESS: HTS Hybrids Termination Service completed successfully!'), returnedLog);
  }
  /*******************************************
   * Main Method #3 test                     *
   *******************************************/
  static testMethod void test_convertHybrid(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //setup mock responses for the method: removeSubsFromOSS(cleanSubs); 
    mock.addResponse(getMock_subscribersList_OK());
    mock.addResponse(getMock_noBody(204));
    mock.addResponse(getMock_subscribersList_OK());    
    mock.addResponse(getMock_noBody(204));
    //setup mock responses for the method: provisionTwoSubs(provisioningMap.values());
    mock.addResponse(getMock_postSubscriber_OK());
    mock.addResponse(getMock_postSubscriber_OK());
    Test.setMock(HttpCalloutMock.class, mock);
    //Need a subscription list to submit..
    list<SBQQ__Subscription__c> subsList = [SELECT Id, Asset__r.Name, Asset__r.Parent_Asset__r.Id, 
                                            Asset__r.Product2.ProductCode, Asset__c, 
                                            Traffic_Identifier__c, 
                                            SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                                      FROM SBQQ__Subscription__c];
    
    system.assertEquals(2, subsList.size());
    test.startTest();
    Service_provisionHTSHybrids.convertHybrid(subsList);
    serviceResults returnedLog = Service_provisionHTSHybrids.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('SUCCESS: HTS Hybrids Conversion Service completed successfully!'), returnedLog);
  }

  /**********************************************************
   * setup methods for commonly used HTTP mock responses....*
   **********************************************************/

  static HttpResponse getMock_postSubscriber_OK(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(201);
    returnMock.setBody('{"subscriber_plan_id":"Enabled","subscriber_ip_addresses":["10.83.7.0/24"],"subscriber_id":"99997101-00"}');
    return returnMock;
  }
  static HttpResponse getMock_postSubscriber_FAIL(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(500);
    returnMock.setBody('{"message": "Supplied plan (string) does not exist or is not active."}');
    return returnMock;
  }
  static HttpResponse getMock_subscribersList_Empty(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    string response = '';
    response += '[';
    response += ']';
    returnMock.setBody(response);
    return returnMock;
  }
  static HttpResponse getMock_subscribersList_OK(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    string response = '';
    response += '[';
    response += '{ "obj_id": "00000000-0000-0001-0000-000000000002", "status": "Active", "subscriber_id": "12345678-00", "subscriber_plan_id": "PLAN_2" }';
    response += ']';
    returnMock.setBody(response);
    return returnMock;
  }
  static HttpResponse getMock_subscribersList_OK_Multi(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    string response = '';
    response += '[';
    response += '{ "obj_id": "00000000-0000-0001-0000-000000000002", "status": "Active", "subscriber_id": "12345678-01", "subscriber_plan_id": "OP2K" },';
    response += '{ "obj_id": "00000000-0000-0001-0000-000000000003", "status": "Active", "subscriber_id": "12345678-02", "subscriber_plan_id": "FX1_H" }';
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
  static HttpResponse getMock_terminalListOf2(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    returnMock.setBody( '[{"activate": false,' +
                          '"obj_id": 2046,' +
                          '"terminal_id": "13728772",' +
                          '"coremodule_id": 3541,' +
                          '"obj_revision": 3},' +
                          '{"activate": false,' +
                          '"obj_id": 2047,' +
                          '"terminal_id": "13728773",' +
                          '"coremodule_id": 3542,' +
                          '"obj_revision": 3}]');
    return returnMock;
  }
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
  static HttpResponse getMock_postTermAsynch_OK(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    returnMock.setBody('{"obj_id": "14264295-7d0e-4a66-b7bb-9c37fab821e5"}');
    return returnMock;
  }
}