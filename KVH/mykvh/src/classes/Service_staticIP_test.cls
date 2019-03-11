@isTest
private class Service_staticIP_test {
  //setup testClass variables here. For example:
  //RecordType Ids
  private static final Id Service_Product2_RECORD_TYPE_ID = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Service').getRecordTypeId();
  private static final Id ServCloud_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Cloud').getRecordTypeId();
  private static final Id Platform_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Demo/Test/Monitor').getRecordTypeId();
  private static final Id Customer_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Customer').getRecordTypeId();
  private static final integer MAX_LOOP_COUNTER = 5;

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
                                                                HTS_Egress_Region__c = 'CONUS_STANDARD',
                                                                Traffic_Identifier__c = '12345678-01');
    insert testSubsc;
    SBQQ__Subscription__c testSubsc2 = new SBQQ__Subscription__c(SBQQ__Quantity__c = 1, SBQQ__Contract__c = k.Id, 
                                                                 SBQQ__Product__c = testProd2.Id, 
                                                                 Asset__c = assetMap.get('12345678').Id,
                                                                 HTS_Egress_Region__c = 'CONUS_STANDARD',
                                                                 Traffic_Identifier__c = '12345678-02');
    insert testSubsc2;

    //Need a bunch of HTS_Static_IPs__c....
    String baseIP = '66.66.66.';
    list<HTS_Static_IPs__c> insertList = new list<HTS_Static_IPs__c>();
    for(integer i = 1; i < MAX_LOOP_COUNTER; i++) { /// be VERY careful with this... don't make a bogus IPs!!
      HTS_Static_IPs__c ip = new HTS_Static_IPs__c();
      if(i < MAX_LOOP_COUNTER / 2){
        ip.Channel_Id__c = '1703';
      } else {
        ip.Channel_Id__c = '1704';
      }
      ip.Name = baseIP + i;
      ip.Region__c = 'CONUS';
      ip.HTS_IP_HEX_Address__c = '40.40.40.' + String.valueOf(i).leftPad(2,'0');
      insertList.add(ip);
    }
    system.debug('--->' + insertList);
    insert insertList;
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
    system.assertEquals(7, readProds.size());
    list<Asset> readAssets = [SELECT Id, Name FROM ASSET];
    system.assertEquals(6, readAssets.size());
    list<HTS_Static_IPs__c> readList = [SELECT Id, Name FROM HTS_Static_IPs__c];
    system.assertEquals(MAX_LOOP_COUNTER - 1, readList.size());
  }
  static testMethod void test_staticLog(){
    serviceResults logStringResponse = Service_staticIP.getLog();
    system.assert(logStringResponse.message.contains('SERVICE_INITIALIZATION'));
    system.assert(logStringResponse.message.contains('Initializing HTS Static IP Management Service'), logStringResponse);
  }
  static testMethod void test_returnFatalError(){
    test.startTest();
    serviceResults returnedLog = Service_staticIP.returnFatalError();
    test.stopTest();
    system.debug('log message: ' + returnedLog.message);
    system.assert(returnedLog.message.contains('HTS Static IP Management Service failed ' + 
                                                'to complete successfully. See log for details.'), returnedLog.message);
    Case c = [SELECT ID, Subject, Status, Origin, RecordTypeId, Description, CaseNumber FROM Case LIMIT 1];
    system.assertEquals(ServCloud_RECORD_TYPE_ID, c.RecordTypeId);
    system.assertEquals('Fatal Error in Service_staticIP Class', c.Subject);
    system.assertEquals('System Generated', c.Origin);
    system.assertEquals('New', c.Status);
  }
  static testMethod void test_preProcessValidation_OK(){
    list<SBQQ__Subscription__c> readRecords = [SELECT Id, Name FROM SBQQ__Subscription__c];
    test.startTest();
    Service_staticIP.preProcessValidation(readRecords[0]);
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success);
  }
  static testMethod void test_preProcessValidation_FAIL(){
    list<SBQQ__Subscription__c> readRecords = [SELECT Id, Name FROM SBQQ__Subscription__c];
    readRecords[0].Id = null;
    test.startTest();
    Service_staticIP.preProcessValidation(readRecords[0]);
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    system.assertEquals(false, returnedLog.success);
  }
  static testMethod void test_getCleanSub_OK(){
    list<SBQQ__Subscription__c> readRecords = [SELECT Id, Name FROM SBQQ__Subscription__c];
    test.startTest();
    SBQQ__Subscription__c returnedSub = Service_staticIP.getCleanSub(readRecords[0]);
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    system.assertEquals(readRecords[0].Id, returnedSub.Id, returnedLog);
    system.assertEquals(true, returnedLog.success, returnedLog);
  }
  static testMethod void test_getCleanSub_NOSUBSCRIPTION(){
    list<SBQQ__Subscription__c> readRecords = [SELECT Id, Name FROM SBQQ__Subscription__c];
    SBQQ__Subscription__c singleSub = readRecords[0];
    singleSub.Id = null;
    test.startTest();
    SBQQ__Subscription__c returnedSub = Service_staticIP.getCleanSub(singleSub);
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    system.assertEquals(readRecords[0].Id, returnedSub.Id, returnedLog);
    system.assertEquals(false, returnedLog.success, returnedLog);
  }
  static testMethod void test_getCleanSub_NO_SHAPING_POLICY(){
    list<SBQQ__Subscription__c> readRecords = [SELECT Id, SBQQ__Product__r.Id FROM SBQQ__Subscription__c];
    Product2 prod = new Product2();
    prod.Id = readRecords[0].SBQQ__Product__r.Id;
    prod.HTS_Subscriber_Plan__c = null;
    update prod;
    test.startTest();
    SBQQ__Subscription__c returnedSub = Service_staticIP.getCleanSub(readRecords[0]);
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    system.assertEquals(readRecords[0].Id, returnedSub.Id, returnedLog);
    system.assertEquals(false, returnedLog.success, returnedLog);
  }
  static testMethod void test_getCleanSub_NO_TRAFFIC_ID(){
    list<SBQQ__Subscription__c> readRecords = [SELECT Id, Traffic_Identifier__c FROM SBQQ__Subscription__c];
    SBQQ__Subscription__c singleSub = readRecords[0];
    singleSub.Traffic_Identifier__c = null;
    update singleSub;
    test.startTest();
    SBQQ__Subscription__c returnedSub = Service_staticIP.getCleanSub(readRecords[0]);
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    system.assertEquals(readRecords[0].Id, returnedSub.Id, returnedLog);
    system.assertEquals(false, returnedLog.success, returnedLog);
  }
  static testMethod void test_getCleanSub_NO_PLATFORM(){
    list<SBQQ__Subscription__c> readRecords = [SELECT Id, Asset__r.Root_Asset__r.Id FROM SBQQ__Subscription__c];
    list<Account> readAccts = [SELECT Id, RecordType.DeveloperName FROM Account WHERE Name = 'Default Assets'];
    system.assertNotEquals('Platform_', readAccts[0].RecordType.DeveloperName, readAccts[0]);
    Account a = readAccts[0];
    //Must move ROOT Asset since all child Assets assume the ROOT's Account...
    Asset ass = new Asset();
    ass.Id = readRecords[0].Asset__r.Root_Asset__r.Id;
    ass.AccountId = a.Id;
    update ass;
    test.startTest();
    SBQQ__Subscription__c returnedSub = Service_staticIP.getCleanSub(readRecords[0]);
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    system.assertEquals(readRecords[0].Id, returnedSub.Id, returnedLog);
    system.assertEquals(false, returnedLog.success, returnedLog);
  }
  static testMethod void test_secondaryValidation_OK(){
    list<SBQQ__Subscription__c> readRecords = new list<SBQQ__Subscription__c>();
    readRecords = [SELECT Name, Asset__r.Name, Asset__r.Parent_Asset__c, Asset__r.Parent_Asset__r.Id,
                         Asset__r.Product2.ProductCode, Asset__c, Asset__r.Account.RecordType.DeveloperName,
                         Traffic_Identifier__c, SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                  FROM SBQQ__Subscription__c];
    
    test.startTest();
    Service_staticIP.secondaryValidation(readRecords[0]);
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success, returnedLog);
  }
  static testMethod void test_secondaryValidation_FAIL_BAD_TID(){
    list<SBQQ__Subscription__c> readRecords = new list<SBQQ__Subscription__c>();
    readRecords = [SELECT Name, Asset__r.Name, Asset__r.Parent_Asset__c, Asset__r.Parent_Asset__r.Id,
                         Asset__r.Product2.ProductCode, Asset__c, Asset__r.Account.RecordType.DeveloperName,
                         Traffic_Identifier__c, SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                  FROM SBQQ__Subscription__c];
    
    test.startTest();
    readRecords[0].Traffic_Identifier__c = '12345678-00';
    Service_staticIP.secondaryValidation(readRecords[0]);
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    system.assertEquals(false, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('The Subscription Traffic Identifier appears to be non-standard: 12345678-00'), returnedLog);
  }
  static testMethod void test_secondaryValidation_FAIL_BAD_virTerm(){
    list<SBQQ__Subscription__c> readRecords = new list<SBQQ__Subscription__c>();
    readRecords = [SELECT Name, Asset__r.Name, Asset__r.Parent_Asset__c, Asset__r.Parent_Asset__r.Id,
                         Asset__r.Product2.ProductCode, Asset__c, Asset__r.Account.RecordType.DeveloperName,
                         Traffic_Identifier__c, SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                  FROM SBQQ__Subscription__c];
    Id oneSubscription = readRecords[0].Id;
    Asset a = [SELECT Id FROM Asset WHERE Product2.ProductCode = '02-2204-02' LIMIT 1];
    test.startTest();
    readRecords[0].Asset__c = a.Id;
    update readRecords[0];
    readRecords.clear();
    readRecords = [SELECT Name, Asset__r.Name, Asset__r.Parent_Asset__c, Asset__r.Parent_Asset__r.Id,
                      Asset__r.Product2.ProductCode, Asset__c, Asset__r.Account.RecordType.DeveloperName,
                      Traffic_Identifier__c, SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                   FROM SBQQ__Subscription__c WHERE Id =: oneSubscription];

    Service_staticIP.secondaryValidation(readRecords[0]);
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    system.assertEquals(false, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('The Subscription Asset does not appear to be a Virtual Terminal Id!'), returnedLog);
  }
  static testMethod void test_getDataChannel_OK(){
    list<SBQQ__Subscription__c> readRecords = new list<SBQQ__Subscription__c>();
    readRecords = [SELECT Name, Asset__r.Name, Asset__r.Parent_Asset__c, Asset__r.Parent_Asset__r.Id,
                         Asset__r.Product2.ProductCode, Asset__c, Asset__r.Account.RecordType.DeveloperName,
                         Traffic_Identifier__c, SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                  FROM SBQQ__Subscription__c];
    SBQQ__Subscription__c oneSub = readRecords[0];
    test.startTest();
    oneSub.HTS_Egress_Region__c = 'CONUS_STANDARD';
    oneSub.Traffic_Identifier__c = '12345678-01';
    system.assertEquals(1703, Service_staticIP.getDataChannel(oneSub));
    oneSub.HTS_Egress_Region__c = 'EMEA_STANDARD';
    system.assertEquals(1705, Service_staticIP.getDataChannel(oneSub));
    oneSub.HTS_Egress_Region__c = 'ASIA_STANDARD';
    system.assertEquals(1707, Service_staticIP.getDataChannel(oneSub));

    oneSub.HTS_Egress_Region__c = 'CONUS_STANDARD';
    oneSub.Traffic_Identifier__c = '12345678-02';
    system.assertEquals(1704, Service_staticIP.getDataChannel(oneSub));
    oneSub.HTS_Egress_Region__c = 'EMEA_STANDARD';
    system.assertEquals(1706, Service_staticIP.getDataChannel(oneSub));
    oneSub.HTS_Egress_Region__c = 'ASIA_STANDARD';
    system.assertEquals(1708, Service_staticIP.getDataChannel(oneSub));
    test.stopTest();
  }
  static testMethod void test_getDataChannel_FAIL(){
    list<SBQQ__Subscription__c> readRecords = new list<SBQQ__Subscription__c>();
    readRecords = [SELECT Name, Asset__r.Name, Asset__r.Parent_Asset__c, Asset__r.Parent_Asset__r.Id,
                         Asset__r.Product2.ProductCode, Asset__c, Asset__r.Account.RecordType.DeveloperName,
                         Traffic_Identifier__c, SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                  FROM SBQQ__Subscription__c];
    SBQQ__Subscription__c oneSub = readRecords[0];
    oneSub.HTS_Egress_Region__c = 'APAC_STANDARD';
    oneSub.Traffic_Identifier__c = '12345678-01';
    test.startTest();
    system.assertEquals(0, Service_staticIP.getDataChannel(oneSub));
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    system.assertEquals(false, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('Data Channel Indeterminate'), returnedLog);
  }
  static testMethod void test_getActiveTerminal_OK(){
    //Need mock response from hts/terminals
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_getTerminalsList());
    mock.addResponse(getMock_getTerminal());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    HTSOSS_hts_terminals returnObj = Service_staticIP.getActiveTerminal('12345678');
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('Found Terminal in Network, obj_id: 9118'), returnedLog);
  }
  static testMethod void test_getActiveTerminal_FAIL(){
    //Need mock response from hts/terminals
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_getTerminalsList());
    mock.addResponse(getMock_ossResponse_BAD());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    HTSOSS_hts_terminals returnObj = Service_staticIP.getActiveTerminal('12345678');
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    system.assertEquals(false, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('Could not GET Terminal from OSS'), returnedLog);
  }
  static testMethod void test_getActiveTerminal_EMPTY(){
    //Need mock response from hts/terminals
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_getTerminalsList_EMPTY());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    HTSOSS_hts_terminals returnObj = Service_staticIP.getActiveTerminal('12345678');
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    system.assertEquals(false, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('Could not GET Terminal from OSS'), returnedLog);
  }
  static testMethod void test_getActiveTerminal_BAD(){
    //Need mock response from hts/terminals
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_ossResponse_BAD());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    HTSOSS_hts_terminals returnObj = Service_staticIP.getActiveTerminal('12345678');
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    system.assertEquals(false, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('Something bad has happened'), returnedLog);
  }
  static testMethod void test_getDataChannelStatus_OK(){
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.terminal_id = '12345678';
    list<HTSOSS_hts_terminals.channel> testChannels = new list<HTSOSS_hts_terminals.channel>();
    HTSOSS_hts_terminals.channel channel1703 = new HTSOSS_hts_terminals.channel();
    channel1703.enablestaticroutes = true;
    channel1703.obj_id = '1703';
    testChannels.add(channel1703);
    HTSOSS_hts_terminals.channel channel1704 = new HTSOSS_hts_terminals.channel();
    channel1704.enablestaticroutes = true;
    channel1704.obj_id = '1704';
    testChannels.add(channel1704);
    testTerm.data_channels = testChannels;
    test.startTest();
    Boolean results = Service_staticIP.getDataChannelStatus(1704, testTerm);
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    system.assert(results);
    system.assertEquals(true, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('Data Channel: 1704 for: 12345678 is already enabled'), returnedLog);
  }
  static testMethod void test_getDataChannelStatus_OK_2(){
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.terminal_id = '12345678';
    list<HTSOSS_hts_terminals.channel> testChannels = new list<HTSOSS_hts_terminals.channel>();
    HTSOSS_hts_terminals.channel channel1703 = new HTSOSS_hts_terminals.channel();
    channel1703.enablestaticroutes = true;
    channel1703.obj_id = '1703';
    testChannels.add(channel1703);
    HTSOSS_hts_terminals.channel channel1704 = new HTSOSS_hts_terminals.channel();
    channel1704.enablestaticroutes = true;
    channel1704.obj_id = '1704';
    testChannels.add(channel1704);
    testTerm.data_channels = testChannels;
    test.startTest();
    Boolean results = Service_staticIP.getDataChannelStatus(1703, testTerm);
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    system.assert(results);
    system.assertEquals(true, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('Data Channel: 1703 for: 12345678 is already enabled'), returnedLog);
  }
  static testMethod void test_getDataChannelStatus_BAD_REGION(){
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.terminal_id = '12345678';
    list<HTSOSS_hts_terminals.channel> testChannels = new list<HTSOSS_hts_terminals.channel>();
    HTSOSS_hts_terminals.channel channel1703 = new HTSOSS_hts_terminals.channel();
    channel1703.enablestaticroutes = true;
    channel1703.obj_id = '1703';
    testChannels.add(channel1703);
    HTSOSS_hts_terminals.channel channel1704 = new HTSOSS_hts_terminals.channel();
    channel1704.enablestaticroutes = true;
    channel1704.obj_id = '1704';
    testChannels.add(channel1704);
    testTerm.data_channels = testChannels;
    test.startTest();
    Boolean results = Service_staticIP.getDataChannelStatus(1705, testTerm);
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    system.assert(!results);
    system.assertEquals(false, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('OSS Data Channels do not correspond with input Data Channel!'), returnedLog);
  }
  static testMethod void test_getDataChannelStatus_EMPTY_ARRAY(){
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.terminal_id = '12345678';
    list<HTSOSS_hts_terminals.channel> testChannels = new list<HTSOSS_hts_terminals.channel>();
    HTSOSS_hts_terminals.channel channel1703 = new HTSOSS_hts_terminals.channel();
    //channel1703.enablestaticroutes = true;
    //channel1703.obj_id = '1703';
    //testChannels.add(channel1703);
    HTSOSS_hts_terminals.channel channel1704 = new HTSOSS_hts_terminals.channel();
    //channel1704.enablestaticroutes = true;
    //channel1704.obj_id = '1704';
    //testChannels.add(channel1704);
    testTerm.data_channels = testChannels;
    test.startTest();
    Boolean results = Service_staticIP.getDataChannelStatus(1705, testTerm);
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    system.assert(!results);
    system.assertEquals(true, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('OSS returned empty Data Channel array!'), returnedLog);
  }
  static testMethod void test_updateDataChannel_OK(){
    //Need mock response from hts/terminals
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_noBody(204));
    Test.setMock(HttpCalloutMock.class, mock);
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.terminal_id = '12345678';
    testTerm.obj_id = 9118;
    testTerm.obj_revision = 3;
    test.startTest();
    testTerm = Service_staticIP.updateDataChannel(1703, testTerm, true);
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('Successfully Enabled Static Data Channel for Terminal: 12345678'), returnedLog);
  }
  static testMethod void test_updateDataChannel_BAD(){
    //Need mock response from hts/terminals
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_ossResponse_BAD());
    Test.setMock(HttpCalloutMock.class, mock);
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.terminal_id = '12345678';
    testTerm.obj_id = 9118;
    testTerm.obj_revision = 3;
    test.startTest();
    testTerm = Service_staticIP.updateDataChannel(1703, testTerm, true);
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    system.assertEquals(false, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('Could not PUT Terminal to OSS. Response Code: '), returnedLog);
  }
  static testMethod void test_getExistingStatics_OK(){
    //Need mock response from hts/terminals
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_getStaticsList_1703_2());
    Test.setMock(HttpCalloutMock.class, mock);
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.terminal_id = '12345678';
    test.startTest();
    HTSOSS_hts_terminals_staticips.staticip_list_wrapper returnObj = Service_staticIP.getExistingStatics(testTerm);
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success, returnedLog);
    system.assertEquals(2, returnObj.staticip_list.size());
    system.assert(returnedLog.message.contains('2 Static IPs obtained'), returnedLog);
  }
  static testMethod void test_getExistingStatics_404(){
    //Need mock response from hts/terminals
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_notFound());
    Test.setMock(HttpCalloutMock.class, mock);
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.terminal_id = '12345678';
    test.startTest();
    HTSOSS_hts_terminals_staticips.staticip_list_wrapper returnObj = Service_staticIP.getExistingStatics(testTerm);
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    system.assertEquals(false, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('Cannot find Terminal in OSS'), returnedLog);
  }
  static testMethod void test_getExistingStatics_500(){
    //Need mock response from hts/terminals
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_ossResponse_BAD());
    Test.setMock(HttpCalloutMock.class, mock);
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.terminal_id = '12345678';
    test.startTest();
    HTSOSS_hts_terminals_staticips.staticip_list_wrapper returnObj = Service_staticIP.getExistingStatics(testTerm);
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    system.assertEquals(false, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('Failed to GET Static IPs for Terminal'), returnedLog);
  }
  static testMethod void test_getNextPrivateIP_1703_OK(){
    //Need a Terminal, a vlan(int), and a staticIP list wrapper
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.terminal_service_ip = '10.83.101.1';
    Integer vlan = 1703;
    list<HTSOSS_hts_terminals_staticips.staticIp> staticsList = new list<HTSOSS_hts_terminals_staticips.staticIp>();
    HTSOSS_hts_terminals_staticips.staticIp singleIP = new HTSOSS_hts_terminals_staticips.staticIp();
    singleIP.channel_id = '1703';
    singleIP.ip_address = '66.66.66.65';
    singleIP.obj_id = '99994563-10.83.101.82';
    staticsList.add(singleIP);
    test.startTest();
    String returnString = Service_staticIP.getNextPrivateIP(vlan, testTerm, staticsList);
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success, returnedLog);
    system.assertEquals('10.83.101.83', returnString);
  }
  static testMethod void test_getNextPrivateIP_1704_OK(){
    //Need a Terminal, a vlan(int), and a staticIP list wrapper
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.terminal_service_ip = '10.83.101.1';
    Integer vlan = 1704;
    list<HTSOSS_hts_terminals_staticips.staticIp> staticsList = new list<HTSOSS_hts_terminals_staticips.staticIp>();
    HTSOSS_hts_terminals_staticips.staticIp singleIP = new HTSOSS_hts_terminals_staticips.staticIp();
    singleIP.channel_id = '1703';
    singleIP.ip_address = '66.66.66.65';
    singleIP.obj_id = '99994563-10.83.101.82';
    staticsList.add(singleIP);
    test.startTest();
    String returnString = Service_staticIP.getNextPrivateIP(vlan, testTerm, staticsList);
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success, returnedLog);
    system.assertEquals('10.83.101.146', returnString);
  }
  static testMethod void test_getNextPrivateIP_BAD_VLAN(){
    //Need a Terminal, a vlan(int), and a staticIP list wrapper
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.terminal_service_ip = '10.83.101.1';
    Integer vlan = 1701;
    list<HTSOSS_hts_terminals_staticips.staticIp> staticsList = new list<HTSOSS_hts_terminals_staticips.staticIp>();
    HTSOSS_hts_terminals_staticips.staticIp singleIP = new HTSOSS_hts_terminals_staticips.staticIp();
    singleIP.channel_id = '1703';
    singleIP.ip_address = '66.66.66.65';
    singleIP.obj_id = '99994563-10.83.101.82';
    staticsList.add(singleIP);
    test.startTest();
    String returnString = Service_staticIP.getNextPrivateIP(vlan, testTerm, staticsList);
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    system.assertEquals(false, returnedLog.success, returnedLog);
    system.assertEquals('0.0.0.0', returnString);
    system.assert(returnedLog.message.contains('Input VLAN: 1701 is out of range.'), returnedLog);
  }
  static testMethod void test_getNextPrivateIP_1703_OK_MIDDLE(){
    //Need a Terminal, a vlan(int), and a staticIP list wrapper
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.terminal_service_ip = '10.83.101.1';
    Integer vlan = 1703;
    list<HTSOSS_hts_terminals_staticips.staticIp> staticsList = new list<HTSOSS_hts_terminals_staticips.staticIp>();
    HTSOSS_hts_terminals_staticips.staticIp singleIP1 = new HTSOSS_hts_terminals_staticips.staticIp();
    singleIP1.channel_id = '1703';
    singleIP1.ip_address = '66.66.66.65';
    singleIP1.obj_id = '99994563-10.83.101.82';
    staticsList.add(singleIP1);

    HTSOSS_hts_terminals_staticips.staticIp singleIP2 = new HTSOSS_hts_terminals_staticips.staticIp();
    singleIP2.channel_id = '1703';
    singleIP2.ip_address = '66.66.66.66';
    singleIP2.obj_id = '99994563-10.83.101.83';
    staticsList.add(singleIP2);

    HTSOSS_hts_terminals_staticips.staticIp singleIP3 = new HTSOSS_hts_terminals_staticips.staticIp();
    singleIP3.channel_id = '1703';
    singleIP3.ip_address = '66.66.66.68';
    singleIP3.obj_id = '99994563-10.83.101.85';
    staticsList.add(singleIP3);

    system.debug(staticsList);
    test.startTest();   //we should get back the one we skipped...
    String returnString = Service_staticIP.getNextPrivateIP(vlan, testTerm, staticsList);
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success, returnedLog);
    system.assertEquals('10.83.101.84', returnString);
  }
  static testMethod void test_getNextPrivateIP_1703_TOO_MANY(){
    //Need a Terminal, a vlan(int), and a staticIP list wrapper
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.terminal_service_ip = '10.83.101.1';
    testTerm.terminal_id = '99994563';
    Integer vlan = 1703;
    list<HTSOSS_hts_terminals_staticips.staticIp> staticsList = new list<HTSOSS_hts_terminals_staticips.staticIp>();
    for(Integer i = 0; i < 13; i++){
      HTSOSS_hts_terminals_staticips.staticIp singleIP1 = new HTSOSS_hts_terminals_staticips.staticIp();
      singleIP1.channel_id = '1703';
      singleIP1.ip_address = '66.66.66.' + String.valueOf(65 + i);
      singleIP1.obj_id = '99994563-10.83.101.' + String.valueOf(82 + i);
      staticsList.add(singleIP1);
    }
    system.debug(staticsList);
    test.startTest();   //we should get back the one we skipped...
    String returnString = Service_staticIP.getNextPrivateIP(vlan, testTerm, staticsList);
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    system.assertEquals(false, returnedLog.success, returnedLog);
    system.assertEquals('0.0.0.0', returnString);
    system.assert(returnedLog.message.contains('No More Static IPs available for channel!'), returnedLog);
  }
  static testMethod void test_getPublicStaticIp(){
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.terminal_service_ip = '10.83.101.1';
    testTerm.terminal_id = '99994563';
    testTerm.template_id = 'CONUS_STANDARD';
    test.startTest();
    HTS_Static_IPs__c returnedObj = Service_staticIP.getPublicStaticIP(1703, testTerm.template_id.substringBefore('_'));
    serviceResults returnedLog = Service_staticIP.getLog();
    Case warningCase = Service_staticIP.getwarningCase();
    test.stopTest();
    system.assertEquals('66.66.66.1', returnedObj.Name);
    system.assertEquals(true, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('Returning Public Static IP: 66.66.66.1'), returnedLog);
    system.assert(returnedLog.message.contains('WARNING'), returnedLog);
    system.assert(warningCase.subject.contains('WARNING! Only '), warningCase);
  }
  static testMethod void test_getPublicStaticIp_NONE_AVAILABLE(){
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.terminal_service_ip = '10.83.101.1';
    testTerm.terminal_id = '99994563';
    testTerm.template_id = 'EMEA_STANDARD';
    test.startTest();
    HTS_Static_IPs__c returnedObj = Service_staticIP.getPublicStaticIP(1706, testTerm.template_id.substringBefore('_'));
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    system.assertEquals(null, returnedObj.Name);
    system.assertEquals(false, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('Could not claim Public Static IP for Terminal.'), returnedLog);
  }
  static testMethod void test_postStaticIp_OK(){
    //Need mock response from hts/terminals
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_noBody(201));
    Test.setMock(HttpCalloutMock.class, mock);
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.terminal_service_ip = '10.83.101.1';
    testTerm.obj_id = 9118;
    testTerm.template_id = 'CONUS_STANDARD';
    test.startTest();
    HTSOSS_hts_terminals_staticips returnObj = Service_staticIP.postStaticIp(1703, testTerm, '66.66.66.64', '10.83.101.82');
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    system.assertEquals(201, returnObj.response_code);  //per Mock
    system.assertEquals(true, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('Successfully POSTed Static IP details to OSS'), returnedLog);
  }
  static testMethod void test_postStaticIp_FAIL(){
    //Need mock response from hts/terminals
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_noBody(500));
    Test.setMock(HttpCalloutMock.class, mock);
    HTSOSS_hts_terminals testTerm = new HTSOSS_hts_terminals();
    testTerm.terminal_service_ip = '10.83.101.1';
    testTerm.obj_id = 9118;
    testTerm.template_id = 'CONUS_STANDARD';
    test.startTest();
    HTSOSS_hts_terminals_staticips returnObj = Service_staticIP.postStaticIp(1703, testTerm, '66.66.66.64', '10.83.101.82');
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    system.assertEquals(500, returnObj.response_code);  //per Mock
    system.assertEquals(false, returnedLog.success, returnedLog);
    system.assert(returnedLog.message.contains('Could not POST Static IP details to OSS'), returnedLog);
  }
  static testMethod void test_updateSFStaticIP(){
    list<HTS_Static_IPs__c> readList = [SELECT Id, Name, Date_Issued__c, Private_Static_IP__c
                                        FROM HTS_Static_IPs__c];
    HTS_Static_IPs__c testStatic = readList[0];
    system.assertEquals(null, testStatic.Date_Issued__c);
    system.assertEquals(null, testStatic.Private_Static_IP__c);
    test.startTest();
    HTS_Static_IPs__c returnObj = Service_staticIP.updateSFStaticIP(testStatic, '10.83.83.82');
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    HTS_Static_IPs__c readBack = [SELECT Id, Name, Date_Issued__c, Private_Static_IP__c
                                  FROM HTS_Static_IPs__c 
                                  WHERE Id =: readList[0].Id
                                  LIMIT 1];
    system.assertNotEquals(null, readBack.Date_Issued__c);
    system.assertEquals('10.83.83.82', readBack.Private_Static_IP__c);
  }
  static testMethod void test_createAsset(){
    //Need a Product2 reference for the Asset. Get it from the Custom Metadata Type
    Default_Identifier_Product__mdt GSIPproduct = [SELECT Identifier_Product_reference__c, Legacy_Product_Id__c
                                                    FROM Default_Identifier_Product__mdt 
                                                    WHERE DeveloperName = 'Global_Static_IP'];

    HTSOSS_hts_terminals_staticips testObj = new HTSOSS_hts_terminals_staticips();
    testObj.data_channel_id = 1703;
    testObj.static_ip_address = '66.66.66.64';
    testObj.terminal_ip_address = '10.83.83.82';
    list<Asset> assetList = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
                                 Product2.ProductCode FROM Asset];
    map<String, Asset> assetMap = new map<String, Asset>();
    for(asset a : assetList){
      assetMap.put(a.Name, a);
    }
    Asset testAsset = assetMap.get('12345678');
    system.debug(testAsset);
    test.startTest();
    Asset returnObj = Service_staticIP.createAsset(testAsset, testObj);
    system.debug(returnObj);
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    system.assertEquals(GSIPproduct.Identifier_Product_reference__c, returnObj.Product2Id, returnObj);
    system.assertEquals('10.83.83.82 - 66.66.66.64', returnObj.Name, returnObj);
  }
  static testMethod void test_createSubscription(){
    //Need a Product2 reference for the Asset. Get it from the Custom Metadata Type
    Default_Identifier_Product__mdt GSIPproduct = [SELECT Identifier_Product_reference__c, Legacy_Product_Id__c
                                                    FROM Default_Identifier_Product__mdt 
                                                    WHERE DeveloperName = 'Global_Static_IP'];

    list<SBQQ__Subscription__c> readRecords = new list<SBQQ__Subscription__c>();
    readRecords = [SELECT Name, Asset__r.Name, Asset__r.Parent_Asset__c, Asset__r.Parent_Asset__r.Id,
                         Asset__r.Product2.ProductCode, Asset__c, Asset__r.Account.RecordType.DeveloperName,
                         SBQQ__Quantity__c, 
                         Traffic_Identifier__c, SBQQ__Product__r.HTS_Subscriber_Plan__r.Name 
                  FROM SBQQ__Subscription__c];
    SBQQ__Subscription__c testSub = readRecords[0];
    Asset testAsset = new Asset(Name = '10.83.83.82 - 66.66.66.64',
                                Product2Id = GSIPproduct.Identifier_Product_reference__c);
    insert testAsset;
    test.startTest();
    SBQQ__Subscription__c returnObj = Service_staticIP.createSubscription(testSub, testAsset);
    serviceResults returnedLog = Service_staticIP.getLog();
    test.stopTest();
    system.assertEquals(GSIPproduct.Identifier_Product_reference__c, returnObj.SBQQ__Product__c, returnObj);
    system.assertEquals(readRecords[0].Traffic_Identifier__c, returnObj.Traffic_Identifier__c, returnObj);
  }
  /*******************************************
   * Main Method #1 test                     *
   *******************************************/
  static testMethod void test_provisionStaticIP(){
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //setup mock responses for the method: getActiveTerminal(cleanSub.Asset__r.Name);
    mock.addResponse(getMock_getTerminalsList());
    mock.addResponse(getMock_getTerminal());
    //setup mock responses for the method: updateDataChannel(dataChannel, activeTerminal, true);
    mock.addResponse(getMock_noBody(204));
    //setup mock responses for the method: getExistingStatics(activeTerminal);
    mock.addResponse(getMock_getStaticsList_1703_2());
    //setup mock responses for the method: postStaticIP(dataChannel, activeTerminal, publicIP.Name, privateIP);
    mock.addResponse(getMock_noBody(201));
    Test.setMock(HttpCalloutMock.class, mock);
    list<SBQQ__Subscription__c> readRecords = [SELECT Id, Name 
                                               FROM SBQQ__Subscription__c
                                               WHERE Traffic_Identifier__c = '12345678-02'];
    test.startTest();
    serviceResults returnedLog = Service_staticIP.provisionStaticIP(readRecords[0]);
    test.stopTest();
    system.assertEquals(true, returnedLog.success, returnedLog);
  }
  /**********************************************************
   * setup methods for commonly used HTTP mock responses....*
   **********************************************************/
  static HttpResponse getMock_getTerminalsList(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    String body = '';
    body = body + '[';
    body = body +   '{';
    body = body +     '"activate": true,';
    body = body +     '"coremodule_id": 8238,';
    body = body +     '"is_active": true,';
    body = body +     '"obj_id": 9118,';
    body = body +     '"obj_revision": 2,';
    body = body +     '"template_id": "CONUS_STANDARD.0003",';
    body = body +     '"terminal_id": "99994563"';
    body = body +   '}';
    body = body + ']';
    returnMock.setBody(body);
    return returnMock;
  }
  static HttpResponse getMock_getTerminal(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    String body = '';
    body = body +   '{';
    body = body +     '"activate": true,';
    body = body +     '"coremodule_id": 8238,';
    body = body +     '"is_active": true,';
    body = body +     '"obj_id": 9118,';
    body = body +     '"obj_revision": 2,';
    body = body +     '"template_id": "CONUS_STANDARD.0003",';
    body = body +     '"terminal_id": "99994563",';
    body = body +     '"terminal_service_ip": "10.83.101.1",';
    body = body +     '"data_channels": [';
    body = body +       '{"enablestaticroutes": true,';
    body = body +       '"obj_id": "1703"},';
    body = body +       '{"enablestaticroutes": false,';
    body = body +       '"obj_id": "1704"}';
    body = body +     ']';
    body = body +   '}';
    returnMock.setBody(body);
    return returnMock;
  }
  static HttpResponse getMock_getTerminalsList_EMPTY(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    String body = '';
    body = body + '[';
    body = body + ']';
    returnMock.setBody(body);
    return returnMock;
  }
  static HttpResponse getMock_ossResponse_BAD(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(500);
    String body = '';
    body = body + '{"message":"Something bad has happened"}';
    returnMock.setBody(body);
    return returnMock;
  }
  static HttpResponse getMock_notFound(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(404);
    String body = '';
    body = body + '{"message":"404 Client Error: Not Found"}';
    returnMock.setBody(body);
    return returnMock;
  }
  static HttpResponse getMock_emptyArray(integer statusCode){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(statusCode);
    String bodyString = '[]';
    returnMock.setBody(bodyString);
    return returnMock;
  }
  static HttpResponse getMock_noBody(integer statusCode){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(statusCode);
    return returnMock;
  }
  static HttpResponse getMock_getStaticsList_1703_2(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    String body = '';
    body = body + '[';
    body = body +   '{';
    body = body +     '"channel_id": "1703",';
    body = body +     '"ip_address": "66.66.66.65",';
    body = body +     '"obj_id": "99994563-10.83.101.82"';
    body = body +    '},{';
    body = body +     '"channel_id": "1703",';
    body = body +     '"ip_address": "66.66.66.66",';
    body = body +     '"obj_id": "99994563-10.83.101.83"';
    body = body +   '}';
    body = body + ']';
    returnMock.setBody(body);
    return returnMock;
  }
}