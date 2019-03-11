@isTest
private class Update_AssetSubscriptionController_test {
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
    Product2 htsAnteanna = new Product2(Name = '02-1925', ProductCode = '02-1925', Description = '02-1925', Product_ID__c='02-1925_US');
    prodList.add(htsAnteanna);
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
    assetMap.get('02-1925').Parent_Asset__c = assetMap.get('01-0419').Id;
    assetMap.get('19-1027').Parent_Asset__c = assetMap.get('02-2280').Id;
    assetMap.get('19-1035').Parent_Asset__c = assetMap.get('02-2280').Id;
    assetList = assetMap.values();
    update assetList;
    //Need a coupld of subscription for Sure! a SBQQ__Subscription__c in fact
    list<SBQQ__Subscription__c> subsList = new list<SBQQ__Subscription__c>();
    SBQQ__Subscription__c testSubsc = new SBQQ__Subscription__c(SBQQ__Quantity__c = 1, SBQQ__Contract__c = k.Id, 
                                                                SBQQ__Product__c = testProd.Id, Asset__c=assetMap.get('19-1027').Id);
                                                                
    subsList.add(testSubsc);
    SBQQ__Subscription__c testSubsc2 = new SBQQ__Subscription__c(SBQQ__Quantity__c = 1, SBQQ__Contract__c = k.Id, 
                                                                SBQQ__Product__c = testProd.Id, Asset__c=assetMap.get('02-2280').Id);
                                                            
    subsList.add(testSubsc2);
    SBQQ__Subscription__c testSubsc3 = new SBQQ__Subscription__c(SBQQ__Quantity__c = 1, SBQQ__Contract__c = k.Id, 
                                                                SBQQ__Product__c = testProd.Id, Asset__c=assetMap.get('02-2280').Id);
                                                            
    subsList.add(testSubsc3);
    insert subsList;
    
    HTS_Virtual_Terminal_ID__c testVTID = new HTS_Virtual_Terminal_ID__c(Virtual_Terminal_Id__c = '87654321');
    insert testVTID;

    //Apparently we need a custom setting for 
    Warranty_Asset_Field__c cs1 = new Warranty_Asset_Field__c(Name = 'something',
                                                              Warranty_Period_Months__c = '12',
                                                              Warranty_Type__c = 'something');
    Warranty_Asset_Field__c cs2 = new Warranty_Asset_Field__c(Name = 'nothing',
                                                              Warranty_Type__c = 'nothing');
    //need a Warranty_Asset_Field__c with a null Warranty_Type__c
    //This appears to be unused in Production
    insert cs1;
    insert cs2;
  }

  static testMethod void testSetupData(){
    // Test that your test data is setup correctly
    //Should be 5 Product2 records
    list<Product2> readList = [SELECT Id, Name FROM Product2];
    system.assertEquals(7, readList.size());
    list<Asset> assetReadList = [SELECT Id, Name FROM Asset];
    system.assertEquals(6, assetReadList.size());
    list<Account> acctReadList = [SELECT Id, Name FROM Account];
    system.assertEquals(2, acctReadList.size());
    list<Contract> kontractReadList = [SELECT Id, Name FROM Contract];
    system.assertEquals(1, kontractReadList.size()); 
    list<HTS_Virtual_Terminal_ID__c> readVTIDs = [SELECT Id, Virtual_Terminal_Id__c FROM HTS_Virtual_Terminal_ID__c];
    system.assertEquals(1, readVTIDs.size());
    list<SBQQ__Subscription__c> readSubs = [SELECT Id FROM SBQQ__Subscription__c];
    system.assertEquals(3, readSubs.size());
    list<Warranty_Asset_Field__c> csList = Warranty_Asset_Field__c.getAll().values();
    system.assertEquals(2, csList.size());
  }

  static testMethod void test_getSubscriptionStatus(){
    list<String> fieldLables = new list<String>();
    test.startTest();
    fieldLables = Update_AssetSubscriptionController.getSubscriptionStatus();
    test.stopTest();
    //this is kind of brittle... if we change the picklist and remove one of 
    // these states, this test Class will fail!
    system.assertEquals(true, fieldLables.contains('Active'));
    system.assertEquals(true, fieldLables.contains('Suspended'));
    system.assertEquals(true, fieldLables.contains('Terminated'));
  }
  static testMethod void test_getAllSubscription(){
    list<Asset> indirectAsset = [SELECT Id FROM Asset WHERE Name = '19-1035'];
    system.assertEquals(1, indirectAsset.size(), 'Something wrong with test data, expecting one and only one Asset!');
    test.startTest();
    Map<string,List<SBQQ__Subscription__c>> subByAsset = Update_AssetSubscriptionController.getAllSubscription(indirectAsset[0].Id);
    test.stopTest();
    system.assertEquals(5, subByAsset.size(), subByAsset);
    system.assertEquals(2, subByAsset.get('02-2280').size(), subByAsset);
  }
  static testMethod void test_getAssetHierarchyAndSubs_ok(){   
    Asset rawDomeAsset = [SELECT Id FROM Asset where name = '02-2280' limit 1];       
    list<Asset> assetHierarchy = Update_AssetSubscriptionController.getAssetHierarchyAndSubs(rawDomeAsset); 
    system.assertEquals(5, assetHierarchy.size());
    list<SBQQ__Subscription__c> subsListForDome = new list<SBQQ__Subscription__c>();
    list<SBQQ__Subscription__c> subsListForSystem = new list<SBQQ__Subscription__c>();
    for(Asset oneAsset : assetHierarchy){
      if(oneAsset.Name == '02-2280'){
        for(SBQQ__Subscription__c objSubscription : oneAsset.Subscriptions__r){
          subsListForDome.add(objSubscription);
        }
      } else if(oneAsset.Name == '19-1027'){
        for(SBQQ__Subscription__c objSubscription : oneAsset.Subscriptions__r){
          subsListForSystem.add(objSubscription);
        }
      }
    }
    system.assertEquals(2, subsListForDome.size(), subsListForDome);
    system.assertEquals(1, subsListForSystem.size(), subsListForSystem);
  }
  static testMethod void test_getAssetHierarchyAndSubs_ok2(){   
    Asset rawDomeAsset = [SELECT Id FROM Asset where name = '01-0419' limit 1];       
    list<Asset> assetHierarchy = Update_AssetSubscriptionController.getAssetHierarchyAndSubs(rawDomeAsset); 
    system.assertEquals(5, assetHierarchy.size());
  }
  static testMethod void test_getAssetHierarchyAndSubs_EXCEPTION(){   
    Asset rawDomeAsset = new Asset();       
    list<Asset> assetHierarchy = Update_AssetSubscriptionController.getAssetHierarchyAndSubs(rawDomeAsset); 
    list<Case> insertedCases = [SELECT Id, Subject, Description FROM Case];
    system.assertEquals(1, insertedCases.size(), insertedCases);
    system.assert(insertedCases[0].Subject.contains('Exception caught in Update_AssetSubscriptionController.getAssetHierarchyAndSubs(Asset rawDomeAsset)'), insertedCases[0]);
  }
  static testMethod void test_validateHTSAsset_READY(){
    list<Asset> assetList = [SELECT Id, Item__c, Parent_Asset__c, Root_Asset__c, Product2.ProductCode, Name FROM Asset];
    Map<String,Asset> assetMap = new Map<String,Asset>();
    for(Asset a: assetList){
      assetMap.put(a.Product2.ProductCode, a);        
    }
    Asset antAsset = assetMap.get('02-1925');
    antAsset.HTS_Conversion_Kit__c = 'KVH Part No. 72-0797';
    antAsset.HTS_REady__c = true;
    update antAsset;
    system.debug('antAsset: ' + antAsset);
    //system.assertEquals(1, assetList.size(), 'Something wrong with test data, expecting one and only one Asset!');
    test.startTest();
    Map<string,Asset> returnMap = Update_AssetSubscriptionController.validateHTSAsset(assetMap.get('19-1035').Id);
    test.stopTest();
    system.assertEquals(1, returnMap.size());
    system.assert(returnMap.containsKey('ready'), returnMap);
  }
  static testMethod void test_validateHTSAsset_NOT_READY(){
    list<Asset> assetList = [SELECT Id, Item__c, Parent_Asset__c, Root_Asset__c, Product2.ProductCode, Name FROM Asset];
    Map<String,Asset> assetMap = new Map<String,Asset>();
    for(Asset a: assetList){
      assetMap.put(a.Product2.ProductCode, a);        
    }
    Asset antAsset = assetMap.get('02-1925');
    antAsset.HTS_Conversion_Kit__c = 'KVH Part No. 72-0797';
    antAsset.HTS_REady__c = false;
    update antAsset;
    system.debug('antAsset: ' + antAsset);
    //system.assertEquals(1, assetList.size(), 'Something wrong with test data, expecting one and only one Asset!');
    test.startTest();
    Map<string,Asset> returnMap = Update_AssetSubscriptionController.validateHTSAsset(assetMap.get('19-1035').Id);
    test.stopTest();
    system.assertEquals(1, returnMap.size());
    system.assert(returnMap.containsKey('not ready'), returnMap);
  }
  static testMethod void test_getWarrantypeValues(){
    test.startTest();
    Map<String,String> warrTypeMap = Update_AssetSubscriptionController.getWarrantypeValues();
    test.stopTest();
    system.assertEquals(2, warrTypeMap.size(), warrTypeMap);
    system.assertEquals('12', warrTypeMap.get('something'), warrTypeMap);
    system.assertEquals('', warrTypeMap.get('nothing'), warrTypeMap);
  }
}