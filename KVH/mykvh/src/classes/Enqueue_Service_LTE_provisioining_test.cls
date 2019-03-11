@isTest
private class Enqueue_Service_LTE_provisioining_test {
  //setup testClass variables here. For example:
  //RecordType Ids
  private static final Id SERVICE_PRODUCT2_RECORD_TYPE_ID = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Service').getRecordTypeId();
  private static final Id SERVCLOUD_CASE_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Cloud').getRecordTypeId();
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
    DefaultAccounts__c insertCS = new DefaultAccounts__c(Name='DefaultAssets', Account_ID__c=defAcct.Id, Description__c='default account');
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
    system.enqueueJob(new Enqueue_Service_LTE_provisioining(readSub));
    test.stopTest();
    readSub.clear();
    readSub = [SELECT Id, Asset__r.Name, Traffic_Identifier__c FROM SBQQ__Subscription__c LIMIT 1];
    system.assertEquals('87654321' + '-11', readSub.Traffic_Identifier__c);
    system.assertEquals('87654321' + '-LTE',readSub.Asset__r.Name, readSub); //need update subscription!
    HTS_Virtual_Terminal_ID__c readVTID = [SELECT Id, Virtual_Terminal_Id__c, Date_Issued__c FROM HTS_Virtual_Terminal_ID__c LIMIT 1];
    system.assertnotEquals(null, readVTID.Date_Issued__c);
    system.assertEquals('87654321', readVTID.Virtual_Terminal_Id__c);
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