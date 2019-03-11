@isTest
private class I2CMAssignIdentifiers_queueable_test {
  @testSetup static void setupTestData(){
    //setup common test data here
    //Going to need a single I2CM Asset, without a VTID or HTS IP
    
    //Setup Lists for inserts/upserts
    list<Account> insertAccts = new list<Account>();
    list<Product2> insertProds = new list<Product2>();
    list<Asset> insertAssets = new list<Asset>();
    //Setup Accounts
    Account defaultAssets = new Account(Name = 'Default Assets');
    insertAccts.add(defaultAssets);
    Account replacedAssets = new Account(Name = 'Replaced Assets');
    insertAccts.add(replacedAssets);
    insert insertAccts;
    //Setup Custom Settings....
    DefaultAccounts__c mfgAssets = new DefaultAccounts__c(Name = 'DefaultAssets', Account_ID__c = defaultAssets.Id, Description__c ='Desc1');
    insert mfgAssets;
    DefaultAccounts__c replaced = new DefaultAccounts__c(Name = 'ReplacedAssets', Account_ID__c = replacedAssets.Id, Description__c ='Desc2');
    insert replaced;
    //Setup Product2s
    Product2 i2cmProd = new Product2(Name = 'PACKAGED I2CM TPV7IP 4/500', ProductCode = '02-2204-02');
    insertProds.add(i2cmProd);
    Product2 coreProd = new Product2(Name = '19-0955', ProductCode = '19-0955');
    insertProds.add(coreProd);
    Product2 ipProd = new Product2(Name = 'HTS IP Address', ProductCode = 'HTS IP Address');
    insertProds.add(ipProd);
    Product2 vtidProd = new Product2(Name = 'Virtual Terminal ID', ProductCode = 'Virtual Terminal ID');
    insertProds.add(vtidProd);
    insert insertProds;
    //Start setting up Asset Hierarchies....
    //Need a single  I2CM Assets

    Asset removed = new Asset(Name = 'removed', AccountId = replacedAssets.Id, Product2Id = i2cmProd.Id);
    insertAssets.add(removed);
    upsert insertAssets;

    Asset core2 = new Asset(Name = 'removedCore', Parent_Asset__c = removed.Id, Product2Id = coreProd.Id);
    insertAssets.add(core2);

    upsert insertAssets;

    insert new HTS_IP_Address__c(HTS_IP_HEX_Address__c = '0A.53.53.00', HTS_IP_Address__c = '10.83.83.0', Management_IP_Address__c = '10.242.2.5');
    insert new HTS_Virtual_Terminal_ID__c(Virtual_Terminal_Id__c = '99999901');
    
    insert new HTS_Terminal_Template__c(obj_id__c='CONUS_STANDARD', isDefault__c=true, Name='CONUS_STANDARD');
  }

  static testMethod void testSetupData(){
    list<Account> readAccts = [SELECT Id FROM Account];
    system.assertEquals(2, readAccts.size());
    map<String, DefaultAccounts__c> settingsMap = DefaultAccounts__c.getAll();
    system.assertEquals(2, settingsMap.size());
    list<Asset> readAssets = [SELECT Id, Name, Parent_Asset__c, Parent_Asset__r.Name FROM Asset];
    system.assertEquals(2, readAssets.size());
    for(Asset a : readAssets){
      if(a.Parent_Asset__c != null){
        system.assertEquals(a.name.left(7), a.Parent_Asset__r.Name.left(7));
      }
    }
    list<HTS_IP_Address__c> readHTSIPs = [SELECT Id, HTS_IP_HEX_Address__c, HTS_IP_Address__c FROM HTS_IP_Address__c];
    system.assertEquals(1, readHTSIPs.size());
    list<HTS_Virtual_Terminal_ID__c> readVTIDs = [SELECT Id, Name, Virtual_Terminal_Id__c FROM HTS_Virtual_Terminal_ID__c];
    system.assertEquals(1, readVTIDs.size());
  }
  static testMethod void test_queueable(){
    //Need mock response from hts/satelliterouters etc...
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_CoreIdList_OK());
    mock.addResponse(getMock_postTermAsynch_OK());
    mock.addResponse(getMock_postSubscriber_OK());
    Test.setMock(HttpCalloutMock.class, mock);
    list<Asset> readList = [SELECT Id, Name, Parent_Asset__c FROM Asset WHERE Parent_Asset__c = ''];
    system.assertEquals(1, readList.size(), readList);
    test.startTest();
    system.enqueueJob(new I2CMAssignIdentifiers_queueable(readList[0]));
    test.stopTest();
    map<String, Asset> assetMap = new map<String, Asset>();
    for(Asset a : [SELECT Id, Name, Parent_Asset__c, Product2.ProductCode FROM Asset]){
      assetMap.put(a.Name, a);
    }
    system.assertEquals(4, assetMap.size(), assetMap);
    system.assert(assetMap.containsKey('99999901'));
    system.assert(assetMap.containsKey('10.83.83.0'));
    system.debug(assetMap);
  }
  //setup methods for commonly used HTTP mock responses....
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
  static HttpResponse getMock_postSubscriber_OK(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(201);
    returnMock.setBody('{"subscriber_plan_id":"Enabled","subscriber_ip_addresses":["10.83.7.0/24"],"subscriber_id":"99997101-00"}');
    return returnMock;
  }
  static HttpResponse getMock_postSubscriber_FAIL(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(500);
    returnMock.setBody('{"mock error"}');
    return returnMock;
  }
}