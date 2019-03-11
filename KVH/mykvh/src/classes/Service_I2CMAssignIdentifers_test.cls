@isTest
private class Service_I2CMAssignIdentifers_test {
    //setup testClass variables here. For example:
    //RecordType Ids
    private static final Id ServCloud_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Cloud').getRecordTypeId();

    @testSetup static void setupTestData(){
    //setup common test data here

    //Going to need a couple of I2CM Assets... and maybe parents for them.
    //Going to need an HTS Asset Hierarchy that includes a SatRouter, VTID, and IP Address.
    //LOTS of SOQL :( have to move our startTest to kind of the middle of this setup stuff....
    
    //Setup Lists for inserts/upserts
    list<Account> insertAccts = new list<Account>();
    list<Product2> insertProds = new list<Product2>();
    list<Asset> insertAssets = new list<Asset>();
    //Setup Accounts
    Account defaultAssets = new Account(Name = 'Default Assets');
    insertAccts.add(defaultAssets);
    Account replacedAssets = new Account(Name = 'Replaced Assets');
    insertAccts.add(replacedAssets);
    Account testAccount = new Account(Name = 'Test Account');
    insertAccts.add(testAccount);
    insert insertAccts;
    //Setup Custom Settings....
    DefaultAccounts__c mfgAssets = new DefaultAccounts__c(Name = 'DefaultAssets', Account_ID__c = defaultAssets.Id, Description__c ='Desc1');
    insert mfgAssets;
    DefaultAccounts__c replaced = new DefaultAccounts__c(Name = 'ReplacedAssets', Account_ID__c = replacedAssets.Id, Description__c ='Desc2');
    insert replaced;
    //Setup Product2s
    Product2 systemProd = new Product2(Name = '01-0408-15', ProductCode = '01-0408-15');
    insertProds.add(systemProd);
    Product2 i2cmProd = new Product2(Name = 'PACKAGED I2CM TPV7IP 4/500', ProductCode = '02-2204-02');
    insertProds.add(i2cmProd);
    Product2 coreProd = new Product2(Name = '19-0955', ProductCode = '19-0955');
    insertProds.add(coreProd);
    Product2 ipProd = new Product2(Name = 'HTS IP Address', ProductCode = 'HTS IP Address');
    insertProds.add(ipProd);
    Product2 vtidProd = new Product2(Name = 'Virtual Terminal ID', ProductCode = 'Virtual Terminal ID');
    insertProds.add(vtidProd);
    Product2 ui2cmProd = new Product2(Name = 'PACKAGED I2CM TPV7IP 4/500 refurbished', ProductCode = 'U02-2204-02');
    insertProds.add(ui2cmProd);
    insert insertProds;
    //Start setting up Asset Hierarchies....
    test.startTest();   //with a NEW set of governor limits....
    //Need a single System Asset and two I2CM Assets
    Asset systemAsset = new Asset(Name = 'removedFrom', AccountId = testAccount.Id, Product2Id = systemProd.Id);
    insertAssets.add(systemAsset);
    upsert insertAssets;
    //Need a Product2 references for the Assets. Get it from the Custom Metadata Type
    //We are going to validate test data setup for Asset Hierarchies based on the left 7 chars of Asset.Name.

    Asset installed = new Asset(Name = 'instald', AccountId = defaultAssets.Id, 
                                Product2Id = i2cmProd.Id);
    insertAssets.add(installed);
    Asset removed = new Asset(Name = 'removed', AccountId = testAccount.Id, 
                              Product2Id = i2cmProd.Id, Parent_Asset__c = systemAsset.Id);
    insertAssets.add(removed);
    upsert insertAssets;

    Asset vtid1 = new Asset(Name = 'instaldVTID', Parent_Asset__c = installed.Id, Product2Id = vtidProd.Id);
    insertAssets.add(vtid1);
    Asset vtid2 = new Asset(Name = 'removedVTID', Parent_Asset__c = removed.Id, Product2Id = vtidProd.Id);
    insertAssets.add(vtid2);

    Asset hts_ip1 = new Asset(Name = 'instaldIP', Parent_Asset__c = installed.Id, AccountId = testAccount.Id, Product2Id = ipProd.Id);
    insertAssets.add(hts_ip1);
    Asset hts_ip2 = new Asset(Name = 'removedIP', Parent_Asset__c = removed.Id, AccountId = testAccount.Id, Product2Id = ipProd.Id);
    insertAssets.add(hts_ip2);

    Asset core1 = new Asset(Name = 'instaldCore', Parent_Asset__c = installed.Id, AccountId = testAccount.Id, Product2Id = coreProd.Id);
    insertAssets.add(core1);
    Asset core2 = new Asset(Name = 'removedCore', Parent_Asset__c = removed.Id, AccountId = testAccount.Id, Product2Id = coreProd.Id);
    insertAssets.add(core2);

    upsert insertAssets;

    insert new HTS_IP_Address__c(HTS_IP_HEX_Address__c = '0A.53.53.00', HTS_IP_Address__c = '10.83.83.0', Management_IP_Address__c = '10.242.2.5');
    insert new HTS_Virtual_Terminal_ID__c(Virtual_Terminal_Id__c = '99999901');
    
    insert new HTS_Terminal_Template__c(obj_id__c='CONUS_STANDARD', isDefault__c=true, Name='CONUS_STANDARD');
    test.stopTest();
  }

  static testMethod void testSetupData(){
    list<Account> readAccts = [SELECT Id FROM Account];
    system.assertEquals(3, readAccts.size());
    map<String, DefaultAccounts__c> settingsMap = DefaultAccounts__c.getAll();
    system.assertEquals(2, settingsMap.size());
    list<Asset> readAssets = [SELECT Id, Name, Parent_Asset__c, Parent_Asset__r.Name FROM Asset];
    system.assertEquals(9, readAssets.size());
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

  static testMethod void test_staticLog(){
    serviceResults logStringResponse = Service_I2CMAssignIdentifers.getLog();
    system.assert(logStringResponse.message.contains('SERVICE_INITIALIZATION'));
    system.assert(logStringResponse.message.contains('Initializing I2CM Identifier Assignment Service'));
  }
  static testMethod void test_returnFatalError(){
    test.startTest();
    serviceResults returnedLog = Service_I2CMAssignIdentifers.returnFatalError();
    test.stopTest();
    system.debug('log message: ' + returnedLog.message);
    system.assert(returnedLog.message.contains('I2CM Identifier Assignment Service failed ' + 
                                                'to complete successfully. See log for details.'), returnedLog.message);
    Case c = [SELECT ID, Subject, Status, Origin, RecordTypeId, Description, CaseNumber FROM Case LIMIT 1];
    system.assertEquals(ServCloud_RECORD_TYPE_ID, c.RecordTypeId);
    system.assertEquals('Fatal Error in Service_I2CMAssignIdentifers Class', c.Subject);
    system.assertEquals('System Generated', c.Origin);
    system.assertEquals('New', c.Status);
  }
  static testMethod void test_preProcessValidation_OK(){
    Asset testAsset = [SELECT Id, Name FROM Asset WHERE Name = 'instald' LIMIT 1];
    test.startTest();
    Service_I2CMAssignIdentifers.preProcessValidation(testAsset);
    serviceResults returnedLog = Service_I2CMAssignIdentifers.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success);
    system.assert(returnedLog.message.contains('METHOD_EXIT'));
    system.assert(returnedLog.message.contains('Input OK'));
  }
  static testMethod void test_preProcessValidation_FAIL(){
    Asset testAsset = [SELECT Id, Name FROM Asset WHERE Name = 'instald' LIMIT 1];
    testAsset.Id = null;
    test.startTest();
    Service_I2CMAssignIdentifers.preProcessValidation(testAsset);
    serviceResults returnedLog = Service_I2CMAssignIdentifers.getLog();
    test.stopTest();
    system.assertEquals(false, returnedLog.success);
    system.assert(returnedLog.message.contains('FATAL_ERROR'));
    system.assert(returnedLog.message.contains('Null Asset Record Id detected!'));
  }

  static testMethod void test_assetAnalysis_OK(){
    Asset testAsset = [SELECT Id, Name, Parent_Asset__c FROM Asset WHERE Name = 'instald' LIMIT 1];
    test.startTest();
    Service_I2CMAssignIdentifers.assetAnalysis(testAsset); 
    serviceResults returnedLog = Service_I2CMAssignIdentifers.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success);
    system.assert(returnedLog.message.contains('METHOD_EXIT'));
    system.assert(returnedLog.message.contains('Ready for further processing'));
  }
  static testMethod void test_assetAnalysis_OK_Upart(){
    Asset testAsset = [SELECT Id, Name, Parent_Asset__c FROM Asset WHERE Name = 'instald' LIMIT 1];
    list<Product2> uParts = [SELECT Id FROM Product2 WHERE ProductCode = 'U02-2204-02'];
    system.assertEquals(1, uParts.size(), 'Something wrong with test data, only expected a single "U" part');
    Asset inst = new Asset();
    inst.Id = testAsset.Id;
    inst.Product2Id = uParts[0].Id;
    update inst;
    test.startTest();
    Service_I2CMAssignIdentifers.assetAnalysis(inst); 
    serviceResults returnedLog = Service_I2CMAssignIdentifers.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success);
    system.assert(returnedLog.message.contains('METHOD_EXIT'));
    system.assert(returnedLog.message.contains('Ready for further processing'));
  }
  static testMethod void test_assetAnalysis_FAIL_ZERO(){
    Asset testAsset = [SELECT Id, Name, Parent_Asset__c FROM Asset WHERE Name = 'instald' LIMIT 1];
    delete testAsset;
    test.startTest();
    Service_I2CMAssignIdentifers.assetAnalysis(testAsset); 
    serviceResults returnedLog = Service_I2CMAssignIdentifers.getLog();
    test.stopTest();
    system.assertEquals(false, returnedLog.success);
    system.assert(returnedLog.message.contains('FATAL_ERROR'));
    system.assert(returnedLog.message.contains('Could not obtain Asset record from database'));
  }
  static testMethod void test_assetAnalysis_FAIL_NOTI2CM(){
    Asset testAsset = [SELECT Id, Name, Parent_Asset__c FROM Asset WHERE Name = 'instaldCore' LIMIT 1];
    testAsset.Parent_Asset__c = null;
    update testAsset;
    test.startTest();
    Service_I2CMAssignIdentifers.assetAnalysis(testAsset); 
    serviceResults returnedLog = Service_I2CMAssignIdentifers.getLog();
    test.stopTest();
    system.assertEquals(false, returnedLog.success);
    system.assert(returnedLog.message.contains('FATAL_ERROR'));
    system.assert(returnedLog.message.contains('Identifiers can only be assigned to I2CMs'), returnedLog.message);
  }

  static testMethod void test_assetHierarchyAnalysis_OK(){
    map<String, Asset> assetMap = new map<String, Asset>();
    for(Asset a : [SELECT Id, Name, Parent_Asset__c, Product2.ProductCode,
                    Parent_Asset__r.Product2.ProductCode
                   FROM Asset WHERE Name LIKE 'instald%' ]){
      assetMap.put(a.Product2.ProductCode, a);
    }
    list<Asset> delList = new list<Asset>();
    delList.add(assetMap.get('Virtual Terminal ID'));
    delList.add(assetMap.get('HTS IP Address'));
    delete delList;
    test.startTest();
    map<String, Asset> returnedMap = Service_I2CMAssignIdentifers.assetHierarchyAnalysis(assetMap.get('02-2204-02'));
    serviceResults returnedLog = Service_I2CMAssignIdentifers.getLog();
    test.stopTest();
    system.assertEquals(true, returnedLog.success);
    system.assert(returnedLog.message.contains('METHOD_EXIT'));
    system.assert(returnedLog.message.contains('I2CM Asset Hierarchy OK'), returnedLog.message);
  }
  static testMethod void test_assetHierarchyAnalysis_FAIL_VTID(){
    map<String, Asset> assetMap = new map<String, Asset>();
    for(Asset a : [SELECT Id, Name, Parent_Asset__c, Product2.ProductCode,
                    Parent_Asset__r.Product2.ProductCode
                   FROM Asset WHERE Name LIKE 'instald%' ]){
      assetMap.put(a.Product2.ProductCode, a);
    }
    list<Asset> delList = new list<Asset>();
    //delList.add(assetMap.get('Virtual Terminal ID'));
    delList.add(assetMap.get('HTS IP Address'));
    delete delList;
    test.startTest();
    map<String, Asset> returnedMap = Service_I2CMAssignIdentifers.assetHierarchyAnalysis(assetMap.get('02-2204-02'));
    serviceResults returnedLog = Service_I2CMAssignIdentifers.getLog();
    test.stopTest();
    system.assertEquals(false, returnedLog.success);
    system.assert(returnedLog.message.contains('FATAL_ERROR'));
    system.assert(returnedLog.message.contains('I2CM must not have a Virtual Terminal Id'), returnedLog.message);
  }
  static testMethod void test_assetHierarchyAnalysis_FAIL_HTSIP(){
    map<String, Asset> assetMap = new map<String, Asset>();
    for(Asset a : [SELECT Id, Name, Parent_Asset__c, Product2.ProductCode,
                    Parent_Asset__r.Product2.ProductCode
                   FROM Asset WHERE Name LIKE 'instald%' ]){
      assetMap.put(a.Product2.ProductCode, a);
    }
    list<Asset> delList = new list<Asset>();
    delList.add(assetMap.get('Virtual Terminal ID'));
    //delList.add(assetMap.get('HTS IP Address'));
    delete delList;
    test.startTest();
    map<String, Asset> returnedMap = Service_I2CMAssignIdentifers.assetHierarchyAnalysis(assetMap.get('02-2204-02'));
    serviceResults returnedLog = Service_I2CMAssignIdentifers.getLog();
    test.stopTest();
    system.assertEquals(false, returnedLog.success);
    system.assert(returnedLog.message.contains('FATAL_ERROR'));
    system.assert(returnedLog.message.contains('I2CM must not have an HTS IP Address'), returnedLog.message);
  }
  static testMethod void test_assetHierarchyAnalysis_FAIL_NOCORE(){
    map<String, Asset> assetMap = new map<String, Asset>();
    for(Asset a : [SELECT Id, Name, Parent_Asset__c, Product2.ProductCode,
                    Parent_Asset__r.Product2.ProductCode
                   FROM Asset WHERE Name LIKE 'instald%' ]){
      assetMap.put(a.Product2.ProductCode, a);
    }
    list<Asset> delList = new list<Asset>();
    delList.add(assetMap.get('Virtual Terminal ID'));
    delList.add(assetMap.get('HTS IP Address'));
    delList.add(assetMap.get('19-0955'));
    delete delList;
    test.startTest();
    map<String, Asset> returnedMap = Service_I2CMAssignIdentifers.assetHierarchyAnalysis(assetMap.get('02-2204-02'));
    serviceResults returnedLog = Service_I2CMAssignIdentifers.getLog();
    test.stopTest();
    system.assertEquals(false, returnedLog.success);
    system.assert(returnedLog.message.contains('FATAL_ERROR'));
    system.assert(returnedLog.message.contains('I2CM does not have an installed iDirect Modem!'), returnedLog.message);
  }

  static testMethod void test_buildAttributeMap_OK(){
    //Need mock response from hts/satelliterouters
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_CoreIdList_OK());
    Test.setMock(HttpCalloutMock.class, mock);
    map<String, Asset> assetMap = new map<String, Asset>();
    for(Asset a : [SELECT Id, Name, Parent_Asset__c, Product2.ProductCode,
                    Parent_Asset__r.Product2.ProductCode, SerialNumber
                   FROM Asset WHERE Name LIKE 'instald%' ]){
      if(a.Name == 'instaldIP'){  
        a.Name = '10.83.83.0';
      }
      assetMap.put(a.Product2.ProductCode, a);
    }
    test.startTest();
    map<String, String> returnedMap = Service_I2CMAssignIdentifers.buildAttributeMap(assetMap);
    serviceResults returnedLog = Service_I2CMAssignIdentifers.getLog();
    test.stopTest();
    system.assert(returnedLog.message.contains('METHOD_EXIT'));
    system.assert(returnedLog.message.contains('Returning Attribute Map built from Assets'), returnedLog.message);
    system.assert(!returnedLog.message.contains('FATAL_ERROR'));
    system.assertEquals('2121', returnedMap.get('coremodule_id'));
    system.assertEquals('10.83.83.0/24', returnedMap.get('terminal_ip_address'));
    system.assertEquals('10.242.2.5', returnedMap.get('mgmtipaddress'));
    system.assertEquals('CONUS_STANDARD', returnedMap.get('template_id'));
    system.assertEquals('instaldVTID', returnedMap.get('terminal_id'));
    system.assertEquals('2931', returnedMap.get('terminaltype_id'));
  }
  static testMethod void test_buildAttributeMap_FAIL(){
    //Need mock response from hts/satelliterouters
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_CoreIdList_OK());
    Test.setMock(HttpCalloutMock.class, mock);
    map<String, Asset> assetMap = new map<String, Asset>();
    for(Asset a : [SELECT Id, Name, Parent_Asset__c, Product2.ProductCode,
                    Parent_Asset__r.Product2.ProductCode, SerialNumber
                   FROM Asset WHERE Name LIKE 'instald%' ]){
      if(a.Name == 'instaldIP'){  
        //a.Name = '10.83.83.0';
      }
      assetMap.put(a.Product2.ProductCode, a);
    }
    assetMap.remove('coremodule_id'); //This will throw an exception!
    test.startTest();
    map<String, String> returnedMap = Service_I2CMAssignIdentifers.buildAttributeMap(assetMap);
    serviceResults returnedLog = Service_I2CMAssignIdentifers.getLog();
    test.stopTest();
    system.assert(returnedLog.message.contains('METHOD_EXIT'));
    system.assert(returnedLog.message.contains('An Exception has been caught.'), returnedLog.message);
    system.assert(returnedLog.message.contains('FATAL_ERROR'));
  }
  static testMethod void test_buildAsynchTerminal(){
    map<String, String> testMap = new map<String, String>();
    /*{
        "coremodule_id": 0,
        "terminal_ip_address": "string",
        "mgmtipaddress": "string",
        "template_id": "string",
        "terminal_id": "string",
        "terminaltype_id": 0
    }*/
    testMap.put('coremodule_id', '2121');
    testMap.put('terminal_ip_address', '10.65.5.0/24');
    testMap.put('mgmtipaddress', '10.242.2.5');
    testMap.put('template_id', 'CONUS_STANDARD');
    testMap.put('terminal_id', '12345678');
    testMap.put('terminaltype_id', '2931');
    test.startTest();
    HTSOSS_hts_terminals_asynch returnedTerm = Service_I2CMAssignIdentifers.buildAsynchTerminal(testMap);
    serviceResults returnedLog = Service_I2CMAssignIdentifers.getLog();
    test.stopTest();
    system.assert(returnedLog.message.contains('METHOD_EXIT'));
    system.assert(returnedLog.message.contains('Returning an HTS Terminal for Asynchronous POSTing'), returnedLog.message);
    system.assertEquals('12345678', returnedTerm.terminal_id);
    //assertions for asynch terminal....
  }
  static testMethod void test_getVirtualTerminalId(){
    Asset a = new Asset(Id = '02i0m0000001vm2');
    test.startTest();
    Asset returnedAsset = Service_I2CMAssignIdentifers.getVirtualTerminalId(a);
    serviceResults returnedLog = Service_I2CMAssignIdentifers.getLog();
    test.stopTest();
    system.assertEquals('02i0m0000001vm2', returnedAsset.Parent_Asset__c);
    system.assertEquals('99999901', returnedAsset.Name);
    system.assert(returnedLog.message.contains('METHOD_EXIT'));
    system.assert(returnedLog.message.contains('Returning VTID Asset:'));
    system.assert(returnedLog.message.contains('99999901'));
  }
  static testMethod void test_getHTSIp(){
    Asset a = new Asset(Id = '02i0m0000001vm2');
    test.startTest();
    Asset returnedAsset = Service_I2CMAssignIdentifers.getHTSIp(a);
    serviceResults returnedLog = Service_I2CMAssignIdentifers.getLog();
    test.stopTest();
    system.assertEquals('02i0m0000001vm2', returnedAsset.Parent_Asset__c);
    system.assertEquals('10.83.83.0', returnedAsset.Name);
    system.assert(returnedLog.message.contains('METHOD_EXIT'));
    system.assert(returnedLog.message.contains('Returning HTS IP Asset: '));
    system.assert(returnedLog.message.contains('10.83.83.0'));
  }
  static testMethod void test_postTerminalAsynch(){
    //Need mock response from hts/terminals/async
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_postTermAsynch_OK());
    Test.setMock(HttpCalloutMock.class, mock);
    HTSOSS_hts_terminals_asynch testTerm = new HTSOSS_hts_terminals_asynch();
    testTerm.coremodule_id = 2121;
    testTerm.terminal_ip_address = '10.65.5.0/24';
    testTerm.mgmtipaddress = '10.242.2.5';
    testTerm.template_id = 'CONUS_STANDARD';
    testTerm.terminal_id = '12345678';
    testTerm.terminaltype_id = 2931;
    test.startTest();
    HTSOSS_hts_terminals_asynch returnedTerm = Service_I2CMAssignIdentifers.postTerminalAsynch(testTerm);
    serviceResults returnedLog = Service_I2CMAssignIdentifers.getLog();
    test.stopTest();
    system.assert(returnedLog.message.contains('METHOD_EXIT'));
    system.assert(returnedLog.message.contains('POSTed HTS Terminal to OSS Asynchronous job ID: '));
    system.assert(returnedLog.message.contains('14264295-7d0e-4a66-b7bb-9c37fab821e5'));
  }
  static testMethod void test_postDefaultSubscriber_OK(){
    //Need mock response from hts/subscribers
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_postSubscriber_OK());
    Test.setMock(HttpCalloutMock.class, mock);
    HTSOSS_hts_terminals_asynch testTerm = new HTSOSS_hts_terminals_asynch();
    testTerm.coremodule_id = 2121;
    testTerm.terminal_ip_address = '10.65.5.0/24';
    testTerm.mgmtipaddress = '10.242.2.5';
    testTerm.template_id = 'CONUS_STANDARD';
    testTerm.terminal_id = '12345678';
    testTerm.terminaltype_id = 2931;
    test.startTest();
    HTSOSS_hts_subscribers returnedSub = Service_I2CMAssignIdentifers.postDefaultSubscriber(testTerm);
    serviceResults returnedLog = Service_I2CMAssignIdentifers.getLog();
    test.stopTest();
    system.assert(returnedLog.message.contains('METHOD_EXIT'), returnedLog.message);
    system.assert(returnedLog.message.contains('Successfully POSTed subscriber with Id: '), returnedLog.message);
    system.assert(returnedLog.message.contains('12345678-00'), returnedLog.message);
  }
  static testMethod void test_postDefaultSubscriber_FAIL(){
    //Need mock response from hts/subscribers
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_postSubscriber_FAIL());
    Test.setMock(HttpCalloutMock.class, mock);
    HTSOSS_hts_terminals_asynch testTerm = new HTSOSS_hts_terminals_asynch();
    testTerm.coremodule_id = 2121;
    testTerm.terminal_ip_address = '10.65.5.0/24';
    testTerm.mgmtipaddress = '10.242.2.5';
    testTerm.template_id = 'CONUS_STANDARD';
    testTerm.terminal_id = '12345678';
    testTerm.terminaltype_id = 2931;
    test.startTest();
    HTSOSS_hts_subscribers returnedSub = Service_I2CMAssignIdentifers.postDefaultSubscriber(testTerm);
    serviceResults returnedLog = Service_I2CMAssignIdentifers.getLog();
    test.stopTest();
    system.assert(returnedLog.message.contains('FATAL_ERROR'), returnedLog.message);
    system.assert(returnedLog.message.contains('Could not POST Subscriber to OSS.'), returnedLog.message);
  }
  /*****************************************************************************
   *Main Method tests
   ****************************************************************************/
  static testMethod void test_assignIdentifiers_OK(){
    //Need mock response from hts/satelliterouters
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_CoreIdList_OK());
    mock.addResponse(getMock_postTermAsynch_OK());
    mock.addResponse(getMock_postSubscriber_OK());
    Test.setMock(HttpCalloutMock.class, mock);
    map<String, Asset> assetMap = new map<String, Asset>();
    for(Asset a : [SELECT Id, Name, Parent_Asset__c, Product2.ProductCode,
                    Parent_Asset__r.Product2.ProductCode, SerialNumber
                   FROM Asset WHERE Name LIKE 'instald%' ]){
      assetMap.put(a.Product2.ProductCode, a);
    }
    list<Asset> delList = new list<Asset>();
    delList.add(assetMap.get('Virtual Terminal ID'));
    delList.add(assetMap.get('HTS IP Address'));
    delete delList;
    test.startTest();
    serviceResults returnedLog = Service_I2CMAssignIdentifers.assignIdentifiers(assetMap.get('02-2204-02'));
    test.stopTest();
    system.assertEquals(true, returnedLog.success);
    system.assert(returnedLog.message.contains('SERVICE_FINISHED'));
    system.assert(returnedLog.message.contains('SUCCESS: I2CM Identifier Assignment Service completed!'), returnedLog.message);
  }
  static testMethod void test_assignIdentifiers_OK_Upart(){
    //Need mock response from hts/satelliterouters
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_CoreIdList_OK());
    mock.addResponse(getMock_postTermAsynch_OK());
    mock.addResponse(getMock_postSubscriber_OK());
    Test.setMock(HttpCalloutMock.class, mock);
    //apply "U" part number to I2CM
    Asset testAsset = [SELECT Id, Name, Parent_Asset__c FROM Asset WHERE Name = 'instald' LIMIT 1];
    list<Product2> uParts = [SELECT Id FROM Product2 WHERE ProductCode = 'U02-2204-02'];
    system.assertEquals(1, uParts.size(), 'Something wrong with test data, only expected a single "U" part');
    Asset inst = new Asset();
    inst.Id = testAsset.Id;
    inst.Product2Id = uParts[0].Id;
    update inst;
    //remove VTID and HTS IP so asset looks like it needs identifiers
    map<String, Asset> assetMap = new map<String, Asset>();
    for(Asset a : [SELECT Id, Name, Parent_Asset__c, Product2.ProductCode,
                    Parent_Asset__r.Product2.ProductCode, SerialNumber
                   FROM Asset WHERE Name LIKE 'instald%' ]){
      assetMap.put(a.Product2.ProductCode, a);
    }
    list<Asset> delList = new list<Asset>();
    delList.add(assetMap.get('Virtual Terminal ID'));
    delList.add(assetMap.get('HTS IP Address'));
    delete delList;

    test.startTest();
    serviceResults returnedLog = Service_I2CMAssignIdentifers.assignIdentifiers(assetMap.get('U02-2204-02'));
    test.stopTest();
    system.assertEquals(true, returnedLog.success);
    system.assert(returnedLog.message.contains('SERVICE_FINISHED'));
    system.assert(returnedLog.message.contains('SUCCESS: I2CM Identifier Assignment Service completed!'), returnedLog.message);
  }
  /*****************************************************************************
   *setup methods for commonly used HTTP mock responses....
   ****************************************************************************/
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