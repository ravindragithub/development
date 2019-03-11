@isTest
private class HTS_ltgsvc_contract_controls_test {
//setup testClass variables here. For example:
//RecordType Ids
private static final Id Platform_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Demo/Test/Monitor').getRecordTypeId();
//A common Loop Counter for bulikification purposes
private static final integer MAX_LOOP_COUNTER = 6;
  
  @testSetup static void setupTestData(){
    //setup common test data here
    //Need a Contract!, Contracts need Accounts!!
    Account a = new Account(Name = 'Test Account', RecordTypeId=Platform_RECORD_TYPE_ID);
    insert a;
    Contract k = new Contract(AccountId = a.id, Name='Kontrakt');
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
    Product2 vtidProd = new Product2(Name = 'Virtual Terminal ID', ProductCode = 'Virtual Terminal ID', Product_ID__c='Virtual Terminal ID_US');
    insertProds2.add(vtidProd);
    Product2 ipProd = new Product2(Name = 'HTS IP Address', ProductCode = 'HTS IP Address', Product_ID__c='HTS IP Address_US');
    insertProds2.add(ipProd);
    Product2 antProd = new Product2(Name = 'Antenna', ProductCode = '02-1925-01SL', Product_ID__c='02-1925-01SL_US');
    insertProds2.add(antProd);
    Product2 sysProd = new Product2(Name = 'System', ProductCode = '01-0408-15', Product_ID__c='01-0408-15_US');
    insertProds2.add(sysProd);

    insertProds2.addAll(insertProds);
    insert insertProds2;

    list<Asset> assetList = new list<Asset>();
    //System1
    Asset System_1 = new Asset(Name = 'System_1', Product2Id = sysProd.Id, AccountId = a.Id);
    assetList.add(System_1);
    Asset Antenna_1 = new Asset(Name = 'Antenna_1', Product2Id = antProd.Id, AccountId = a.Id);
    assetList.add(Antenna_1);
    Asset VTID_1 = new Asset(Name = '10000001', Product2Id = vtidProd.Id, AccountId = a.Id);
    assetList.add(VTID_1);
    Asset HTSIP_1 = new Asset(Name = '10.83.1.0', Product2Id = ipProd.Id, AccountId = a.Id);
    assetList.add(HTSIP_1);
    //System_2
    Asset System_2 = new Asset(Name = 'System_2', Product2Id = sysProd.Id, AccountId = a.Id);
    assetList.add(System_2);
    Asset Antenna_2 = new Asset(Name = 'Antenna_2', Product2Id = antProd.Id, AccountId = a.Id);
    assetList.add(Antenna_2);
    Asset VTID_2 = new Asset(Name = '10000002', Product2Id = vtidProd.Id, AccountId = a.Id);
    assetList.add(VTID_2);
    Asset HTSIP_2 = new Asset(Name = '10.83.2.0', Product2Id = ipProd.Id, AccountId = a.Id);
    assetList.add(HTSIP_2);

    insert assetList;
    assetList.clear();
    assetList = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
                                 Product2.ProductCode FROM Asset];
    map<String, Asset> assetMap = new map<String, Asset>();
    for(Asset a3 : assetList){
      assetMap.put(a3.Name, a3);
    }
    assetList.clear();
    assetMap.get('Antenna_1').Parent_Asset__c = assetMap.get('System_1').Id;
    assetMap.get('10.83.1.0').Parent_Asset__c = assetMap.get('System_1').Id;
    assetMap.get('10000001').Parent_Asset__c = assetMap.get('System_1').Id;

    assetMap.get('Antenna_2').Parent_Asset__c = assetMap.get('System_2').Id;
    assetMap.get('10.83.2.0').Parent_Asset__c = assetMap.get('System_2').Id;
    assetMap.get('10000002').Parent_Asset__c = assetMap.get('System_2').Id;
    assetList = assetMap.values();
    update assetList;

    //Need a couple subscriptions for Sure! an SBQQ__Subscription__c in fact
    list<SBQQ__Subscription__c> insertSubs = new list<SBQQ__Subscription__c>();
    SBQQ__Subscription__c testSubsc1 = new SBQQ__Subscription__c(SBQQ__Quantity__c = 12, SBQQ__Contract__c = k.Id, 
                                                                SBQQ__Product__c = insertProds[0].Id, 
                                                                Asset__c = assetMap.get('10000001').Id,
                                                                Traffic_Identifier__c = '10000001-01');
    insertSubs.add(testSubsc1);
    SBQQ__Subscription__c testSubsc2 = new SBQQ__Subscription__c(SBQQ__Quantity__c = 12, SBQQ__Contract__c = k.Id, 
                                                                 SBQQ__Product__c = insertProds[1].Id, 
                                                                 Asset__c = assetMap.get('10000001').Id,
                                                                 Traffic_Identifier__c = '10000001-02');
    insertSubs.add(testSubsc2);

    SBQQ__Subscription__c testSubsc3 = new SBQQ__Subscription__c(SBQQ__Quantity__c = 12, SBQQ__Contract__c = k.Id, 
                                                                SBQQ__Product__c = insertProds[0].Id, 
                                                                Asset__c = assetMap.get('10000002').Id,
                                                                Traffic_Identifier__c = '10000002-01');
    insertSubs.add(testSubsc3);
    SBQQ__Subscription__c testSubsc4 = new SBQQ__Subscription__c(SBQQ__Quantity__c = 12, SBQQ__Contract__c = k.Id, 
                                                                 SBQQ__Product__c = insertProds[1].Id, 
                                                                 Asset__c = assetMap.get('10000002').Id,
                                                                 Traffic_Identifier__c = '10000002-02');
    insertSubs.add(testSubsc4);
    insert insertSubs;
  }
  
  static testMethod void testSetupData(){
    //use this method to validate that you have test data setup correctly
    //this will protect you from changes to workflow, process, and validation that break your test code!
    list<Account> readAccts = [SELECT Id, Name FROM Account];
    system.assertEquals(1, readAccts.size());
    list<Contract> readList = [SELECT Id, ContractNumber, AccountId FROM Contract];
    system.assertEquals(1, readList.size());
    list<HTS_Subscriber_Plans__c> readPols = [SELECT Id, API_Name__c FROM HTS_Subscriber_Plans__c];
    system.assertEquals(MAX_LOOP_COUNTER, readPols.size());
    list<Product2> readProds = [SELECT Id, ProductCode, HTS_Subscriber_Plan__c FROM Product2];
    system.assertEquals(MAX_LOOP_COUNTER + 4, readProds.size());
    list<Asset> readAssets = [SELECT Id, Name FROM Asset];
    system.assertEquals(8, readAssets.size());
    list<SBQQ__Subscription__c> readRecords = [SELECT Id, Name FROM SBQQ__Subscription__c];
    system.assertEquals(4, readRecords.size());
  }

  static testMethod void test_getSubscriptions(){
    Contract k = [SELECT Id, Name FROM Contract LIMIT 1];
    test.startTest();
    list<SBQQ__Subscription__c> returnList = HTS_ltgsvc_contract_controls.getSubscriptions(k);
    test.stopTest();
    system.assertEquals(4, returnList.size());
  }
  static testMethod void test_getCleanContract(){
    Contract k = [SELECT Id, Name, ContractNumber FROM Contract LIMIT 1];
    String recId = (String)k.Id;
    test.startTest();
    Contract returnContract = HTS_ltgsvc_contract_controls.getCleanContract(recId);
    test.stopTest();
    system.assertEquals(k.ContractNumber, returnContract.ContractNumber);
  }

  static testMethod void test_getControlObject(){
    list<SBQQ__Subscription__c> readList = new list<SBQQ__Subscription__c>();
    readList = [SELECT Id, SBQQ__Product__c, Asset__c, Asset__r.Name, Traffic_Identifier__c
                  FROM SBQQ__Subscription__c];
    Contract k = [SELECT Id FROM Contract LIMIT 1];
    String recId = (String)k.Id;
    test.startTest();
    HTS_ltgsvc_contract_controls returnObj = HTS_ltgsvc_contract_controls.getControlObject(recId);
    test.stopTest();
    system.assertEquals('SUCCESS:', returnObj.statusMessage.left(8), returnObj);
    system.assertEquals(k.Id, returnObj.parentContract.Id);
    system.assertEquals(4, returnObj.subsList.size());
  }
  static testMethod void test_setupStaticIP(){
    SBQQ__Subscription__c testSub = new SBQQ__Subscription__c();
    //No record ID... this will fail pre-process validation
    test.startTest();
    HTS_ltgsvc_contract_controls returnObj = HTS_ltgsvc_contract_controls.setupStaticIP(testSub);
    test.stopTest();
    system.assert(returnObj.statusMessage.contains('Pre-process validation failed. Database query inhibited'), returnObj);
  }
}