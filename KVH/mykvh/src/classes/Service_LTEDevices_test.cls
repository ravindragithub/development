@isTest
private class Service_LTEDevices_test {
  //setup testClass variables here. For example:
  //RecordType Ids
  private static final Id Service_Product2_RECORD_TYPE_ID = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Service').getRecordTypeId();
  private static final Id ServCloud_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Cloud').getRecordTypeId();
  private static final Id Platform_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Demo/Test/Monitor').getRecordTypeId();
  
  @testSetup static void setupTestData(){
    //Need an Accounts...
    list<Account> insertAccts = new list<Account>();
    Account testAcct = new Account(Name='Test Account', RecordTypeId=Platform_RECORD_TYPE_ID);
    insertAccts.add(testAcct);
    insert insertAccts;

    list<Product2> prodList = new list<Product2>();
    //Need several HARDWARE Products...
    Product2 sysProd = new Product2(Name = 'System', ProductCode = '01-0419', Product_ID__c='01-0419_US');
    prodList.add(sysProd);
    Product2 antProd = new Product2(Name = 'Dome', ProductCode = '02-2280', Product_ID__c='02-2280_US');
    prodList.add(antProd);
    Product2 lteProd = new Product2(Name = 'LTE Device', ProductCode = '19-1027', Product_ID__c='19-1027_US');
    prodList.add(lteProd);
    Product2 simProd = new Product2(Name = 'SIM', ProductCode = '19-1035', Product_ID__c='19-1035_US');
    prodList.add(simProd);
    insert prodList;

    list<Asset> assetList = new list<Asset>();
    for(Product2 p : [SELECT Id, Product_ID__c, ProductCode, Name FROM Product2]){
      Asset a = new Asset(Name = p.Name, 
                          Product2Id = p.Id, 
                          AccountId = testAcct.Id,
                          Asset_Id__c = p.Product_ID__c + '_' + p.Name);
      assetList.add(a);
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
    assetMap.get('Dome').Parent_Asset__c = assetMap.get('System').Id;
    assetMap.get('LTE Device').Parent_Asset__c = assetMap.get('Dome').Id;
    assetMap.get('SIM').Parent_Asset__c = assetMap.get('Dome').Id;
    assetList = assetMap.values();
    update assetList;
  }

  static testMethod void testSetupData(){
    // Test that your test data is setup correctly
    list<Account> readAccts = [SELECT id, Name, RecordType.DeveloperName FROM Account];
    system.assertEquals(1, readAccts.size());
    list<Product2> readProds = [SELECT Id, Name FROM Product2];
    system.assertEquals(4, readProds.size());
    list<Asset> readAssets = [SELECT Id, Name FROM ASSET];
    system.assertEquals(4, readAssets.size());
  }
  //Static block output tests
  static testMethod void test_staticLog(){
    serviceResults logStringResponse = Service_LTEDevices.getLog();
    system.assert(logStringResponse.message.contains('SERVICE_INITIALIZATION'));
    system.assert(logStringResponse.message.contains('Initializing LTE Devices Management Service'), logStringResponse);
  }
  static testMethod void test_getlteHierarchyTemplate(){
    test.startTest();
    list<Asset_Hierarchy_Template__mdt> lteHierarchyTemplate 
      = Service_LTEDevices.getlteHierarchyTemplate();
    test.stopTest();
    system.assertEquals(4, lteHierarchyTemplate.size(), lteHierarchyTemplate);
  }
  //Method tests
  static testMethod void test_returnFatalError(){
    test.startTest();
    serviceResults returnedLog = Service_LTEDevices.returnFatalError();
    Case warningCase = Service_LTEDevices.getWarningCase();
    test.stopTest();
    system.debug('log message: ' + returnedLog.message);
    system.assert(returnedLog.message.contains('LTE Devices Service failed ' + 
                                                'to complete successfully. See log for details.'), returnedLog.message);
    Case c = [SELECT ID, Subject, Status, Origin, RecordTypeId, Description, CaseNumber FROM Case LIMIT 1];
    system.assertEquals(ServCloud_RECORD_TYPE_ID, c.RecordTypeId);
    system.assertEquals('Fatal Error in Service_LTEDevices Class', c.Subject);
    system.assertEquals('System Generated', c.Origin);
    system.assertEquals('New', c.Status);
  }
  static testMethod void test_preProcessValidation_OK(){
    list<Asset> inputList = [SELECT Id FROM Asset];
    test.startTest();
    Service_LTEDevices.preProcessValidation(inputList);
    test.stopTest();
    serviceResults log = Service_LTEDevices.getLog();
    system.assert(log.success);
    system.assert(log.message.contains('METHOD_EXIT'), log);
    system.assert(log.message.contains('Pre-Process Validation of Asset Hierarchy Complete'), log);
  }
  static testMethod void test_preProcessValidation_FAIL_INCOMPLETE(){
    list<Asset> inputList = [SELECT Id, Name FROM Asset LIMIT 1];
    test.startTest();
    Service_LTEDevices.preProcessValidation(inputList);
    test.stopTest();
    serviceResults log = Service_LTEDevices.getLog();
    system.assertEquals(false, log.success);
    system.assert(log.message.contains('FATAL_ERROR'), log);
    system.assert(log.message.contains('Input Asset Hierarchy has only 1 members!'), log);
  }
  static testMethod void test_preProcessValidation_FAIL_NOID(){
    list<Asset> inputList = [SELECT Id, Name FROM Asset];
    inputList[0].Id = null;
    test.startTest();
    Service_LTEDevices.preProcessValidation(inputList);
    test.stopTest();
    serviceResults log = Service_LTEDevices.getLog();
    system.assertEquals(false, log.success);
    system.assert(log.message.contains('FATAL_ERROR'), log);
    system.assert(log.message.contains('Input Asset Hierarchy does not include record Ids'), log);
  }
  static testMethod void test_getCleanAssets_OK(){
    list<Asset> inputList = [SELECT Id FROM Asset];
    test.startTest();
    list<Asset> outputList = Service_LTEDevices.getCleanAssets(inputList);
    test.stopTest();
    for(Asset a : outputList){
      system.assertNotEquals(null, a.Name);
    }
    serviceResults log = Service_LTEDevices.getLog();
    system.assert(log.success);
    system.assert(log.message.contains('METHOD_EXIT'), log);
    system.assert(log.message.contains('Successfully obtained clean list of Assets from Salesforce'), log);
  }
  static testMethod void test_getCleanAssets_EXCEPTION(){
    list<Asset> inputList = [SELECT Id FROM Asset];
    inputList[1].Id = inputList[0].Id;
    test.startTest();
    list<Asset> outputList = Service_LTEDevices.getCleanAssets(inputList);
    test.stopTest();
    for(Asset a : outputList){
      system.assertNotEquals(null, a.Name);
    }
    serviceResults log = Service_LTEDevices.getLog();
    system.assertEquals(false, log.success);
    system.assert(log.message.contains('METHOD_EXIT'), log);
    system.assert(log.message.contains('Could not obtain clean list of Assets from Salesforce'), log);
    
    Case srCase = log.srCase;
    system.assertEquals(ServCloud_RECORD_TYPE_ID, srCase.RecordTypeId);
    system.assertEquals('System Generated', srCase.Origin);
    system.assertEquals('New', srCase.Status);
  }
  static testMethod void test_validateCleanHierarchy_OK(){
    list<Asset> inputList = [SELECT Id, Name, Asset_Id__c, Product2.ProductCode,
                            Parent_Asset__c, Parent_Asset__r.Product2.ProductCode 
                            FROM Asset];
    test.startTest();
    Boolean validationResults = Service_LTEDevices.validateCleanHierarchy(inputList);
    test.stopTest();
    system.assert(validationResults);
  }

  static testMethod void test_validateCleanHierarchy_FAIL(){
    list<Asset> inputList = [SELECT Id, Name, Asset_Id__c, Product2.ProductCode,
                            Parent_Asset__c, Parent_Asset__r.Product2.ProductCode 
                            FROM Asset];
    //Mess up the Hierarchy structure...
    map<String, Asset> assetMap = new map<String, Asset>();
    for(asset a : inputList){
      assetMap.put(a.Name, a);
    }
    assetMap.get('Dome').Parent_Asset__c = assetMap.get('System').Id;
    assetMap.get('LTE Device').Parent_Asset__c = assetMap.get('System').Id;
    assetMap.get('SIM').Parent_Asset__c = assetMap.get('System').Id;
    update assetMap.values();

    inputList.clear();
    //re-query for messed up hierarhcy
    inputList = [SELECT Id, Name, Asset_Id__c, Product2.ProductCode,
                  Parent_Asset__c, Parent_Asset__r.Product2.ProductCode 
                  FROM Asset];
    test.startTest();
    Boolean validationResults = Service_LTEDevices.validateCleanHierarchy(inputList);
    test.stopTest();
    system.assertEquals(false, validationResults);
    serviceResults log = Service_LTEDevices.getLog();
    system.assertEquals(false, log.success);
    system.assert(log.message.contains('METHOD_EXIT'), log);
    system.assert(log.message.contains('LTE Asset Hierarchy Parent-Child relationships incorrect.'), log);
  }

  static testMethod void test_validateCleanHierarchy_EXCEPTION(){
    list<Asset> inputList = [SELECT Id, Name, Asset_Id__c, Product2.ProductCode,
                            Parent_Asset__c/*, Parent_Asset__r.Product2.ProductCode*/
                            FROM Asset];
    //Should throw null exception
    test.startTest();
    Boolean validationResults = Service_LTEDevices.validateCleanHierarchy(inputList);
    test.stopTest();
    system.assertEquals(false, validationResults);
    serviceResults log = Service_LTEDevices.getLog();
    system.assertEquals(false, log.success);
    system.assert(log.message.contains('METHOD_EXIT'), log);
    system.assert(log.message.contains('An Exception has been caught'), log);
    
    Case srCase = log.srCase;
    system.assertEquals(ServCloud_RECORD_TYPE_ID, srCase.RecordTypeId);
    system.assertEquals('System Generated', srCase.Origin);
    system.assertEquals('New', srCase.Status);
  }
  static testMethod void test_isolateLTEDevice_OK(){
    list<Asset> inputList = [SELECT Id, Name, Asset_Id__c, Product2.ProductCode,
                        Parent_Asset__c, Parent_Asset__r.Product2.ProductCode 
                        FROM Asset];
    test.startTest();
    Asset returnedAsset = Service_LTEDevices.isolateLTEDevice(inputList);
    test.stopTest();
    system.assertEquals('19-1027', returnedAsset.Product2.ProductCode);
    system.assertEquals('LTE Device', returnedAsset.Name);
  }
  static testMethod void test_isolateLTEDevice_OK_FAIL1(){
    list<Asset> inputList = [SELECT Id, Name, Asset_Id__c, Product2.ProductCode,
                        Parent_Asset__c, Parent_Asset__r.Product2.ProductCode 
                        FROM Asset];
    for(Asset a : inputList){
      if(a.Product2.ProductCode == '19-1027'){ //Found it!
        a.name = '';
        break;                        //break out of this loop, we are DONE!
      }
    }
    test.startTest();
    Asset returnedAsset = Service_LTEDevices.isolateLTEDevice(inputList);
    test.stopTest();
    serviceResults log = Service_LTEDevices.getLog();
    system.assertEquals(false, log.success);
    system.assert(log.message.contains('FATAL_ERROR'), log);
    system.assert(log.message.contains('LTE Device Serial number missing or blank!'), log);
  }
  static testMethod void test_isolateLTEDevice_OK_FAIL2(){
    list<Asset> inputList = [SELECT Id, Name, Asset_Id__c, Product2.ProductCode,
                        Parent_Asset__c, Parent_Asset__r.Product2.ProductCode 
                        FROM Asset];
    for(Integer i = 0; i < inputList.size(); i++){
      if(inputList[i].Product2.ProductCode == '19-1027'){ //Found it!
        inputList.remove(i);
        break;                        //break out of this loop, we are DONE!
      }
    }
    test.startTest();
    Asset returnedAsset = Service_LTEDevices.isolateLTEDevice(inputList);
    test.stopTest();
    serviceResults log = Service_LTEDevices.getLog();
    system.assertEquals(false, log.success);
    system.assert(log.message.contains('FATAL_ERROR'), log);
    system.assert(log.message.contains('INFO'), log);
    system.assert(log.message.contains('Failed to find LTE Device in Asset Hierarchy!'), log);
  }
  static testMethod void test_getGroupId_OK(){
    //Need mock response from /lte/organizations/{org_id}/groups?name=...
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_getGroupByOrgId_FILTERED_OK());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    Integer returnedInt = Service_LTEDevices.getGroupId('2933-BAD9-E505');
    test.stopTest();
    serviceResults log = Service_LTEDevices.getLog();
    system.assertEquals(131, returnedInt, log);
    system.assertEquals(true, log.success, log);
    system.assert(log.message.contains('METHOD_EXIT'), log);
    system.assert(log.message.contains('Successfully obtained Group ID from OSS'), log);
  }
  static testMethod void test_getGroupId_500(){
    //Need mock response from /lte/organizations/{org_id}/groups?name=...
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_error_500());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    Integer returnedInt = Service_LTEDevices.getGroupId('2933-BAD9-E505');
    test.stopTest();
    serviceResults log = Service_LTEDevices.getLog();
    system.assertEquals(-1, returnedInt, log);
    system.assertEquals(false, log.success, log);
    system.assert(log.message.contains('FATAL_ERROR'), log);
    system.assert(log.message.contains('OSS Return Code: 500'), log);
  }
  static testMethod void test_getGroupId_EMPTY(){
    //Need mock response from /lte/organizations/{org_id}/groups?name=...
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_getGroupByOrgId_FILTERED_EMPTY());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    Integer returnedInt = Service_LTEDevices.getGroupId('2933-BAD9-E505');
    test.stopTest();
    serviceResults log = Service_LTEDevices.getLog();
    system.assertEquals(-1, returnedInt, log);
    system.assertEquals(false, log.success, log);
    system.assert(log.message.contains('FATAL_ERROR'), log);
    system.assert(log.message.contains('Unable to find Group within Oganization:'), log);
    system.assert(log.message.contains('named: 2933-BAD9-E505'), log);
  }
  static testMethod void test_getGroupId_MULTI(){
    //Need mock response from /lte/organizations/{org_id}/groups?name=...
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_getGroupByOrgId_MULTI());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    Integer returnedInt = Service_LTEDevices.getGroupId('2933-BAD9-E505');
    test.stopTest();
    serviceResults log = Service_LTEDevices.getLog();
    system.assertEquals(-1, returnedInt, log);
    system.assertEquals(false, log.success, log);
    system.assert(log.message.contains('FATAL_ERROR'), log);
    system.assert(log.message.contains('Multiple Groups within Organization:'), log);
    system.assert(log.message.contains('named: 2933-BAD9-E505'), log);
  }
  static testMethod void test_getGroupId_EXCEPTION(){
    //Need mock response from /lte/organizations/{org_id}/groups?name=...
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_noBodyNullCode());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    Integer returnedInt = Service_LTEDevices.getGroupId('2933-BAD9-E505');
    test.stopTest();
    serviceResults log = Service_LTEDevices.getLog();
    system.assertEquals(-1, returnedInt, log);
    system.assertEquals(false, log.success, log);
    system.assert(log.message.contains('FATAL_ERROR'), log);
    system.assert(log.message.contains('An Exception has been caught.'), log);
    Case exceptionCase = log.srCase;
    system.assertEquals('Salesforce Error', exceptionCase.Case_Symptom__c, exceptionCase);
    //list<Case> caseList = [SELECT Id FROM Case]; //see HTSSF-486
    //system.assertEquals(1, caseList.size());
    //CalloutLogs.commitLogs(); //see HTSSF-486
    //list<Callout_Log__c> logsList = [SELECT Id FROM Callout_Log__c];
    //system.assertEquals(1, logsList.size());
  }
  static testMethod void test_importNewDevice_OK(){
    //Need mock response from POST /lte/organizations/importdevices
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_postToImportDevices_OK_SINGLE());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    Integer returnedInt = Service_LTEDevices.importNewDevice('2934-B1AE-EE0E');
    test.stopTest();
    serviceResults log = Service_LTEDevices.getLog();
    system.assertEquals(true, log.success, log);
    system.assertEquals(160, returnedInt);
    system.assert(log.message.contains('METHOD_EXIT'), log);
    system.assert(log.message.contains('Device Importation Successful'), log);
  }
  static testMethod void test_importNewDevice_FAIL(){
    //Need mock response from POST /lte/organizations/importdevices
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_postToImportDevices_500_SINGLE());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    Integer returnedInt = Service_LTEDevices.importNewDevice('2934-B1AE-EE0E');
    test.stopTest();
    serviceResults log = Service_LTEDevices.getLog();
    system.assertEquals(false, log.success, log);
    system.assertEquals(-1, returnedInt);
    system.assert(log.message.contains('FATAL_ERROR'), log);
    system.assert(log.message.contains('failed lookup'), log);
  }
  static testMethod void test_importNewDevice_EXCEPTION(){
    //Need mock response from POST /lte/organizations/importdevices
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_noBodyNullCode());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    Integer returnedInt = Service_LTEDevices.importNewDevice('2934-B1AE-EE0E');
    test.stopTest();
    serviceResults log = Service_LTEDevices.getLog();
    system.assertEquals(false, log.success, log);
    system.assertEquals(-1, returnedInt);
    system.assert(log.message.contains('FATAL_ERROR'), log);
    system.assert(log.message.contains('Exception while Importing LTE Device:'), log);
  }
  static testMethod void test_postToOSS_OK(){
    //Need mock response from POST /lte/devices/{org_id}/{group_id}...
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_postToOSS_OK());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    LTEOSS_lte_devices returnedObj = Service_LTEDevices.postToOSS(5, '2933-BAD9-E505');
    test.stopTest();
    serviceResults log = Service_LTEDevices.getLog();
    system.assertEquals(201, returnedObj.response_code, log);
    system.assertEquals(true, log.success, log);
    system.assert(log.message.contains('METHOD_EXIT'), log);
    system.assert(log.message.contains('Successfully POSTed Device to OSS'), log);
  }
  static testMethod void test_postToOSS_ERROR(){
    //Need mock response from POST /lte/devices/{org_id}/{group_id}...
    QueueHttpMock mock = new QueueHttpMock();
    mock.addResponse(getMock_error_500());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    LTEOSS_lte_devices returnedObj = Service_LTEDevices.postToOSS(5, '2933-BAD9-E505');
    test.stopTest();
    serviceResults log = Service_LTEDevices.getLog();
    system.assertEquals(500, returnedObj.response_code, log);
    system.assertEquals(false, log.success, log);
    system.assert(log.message.contains('FATAL_ERROR'), log);
    system.assert(log.message.contains('Unable to POST LTE Device to OSS'), log);

  }
  /*****************************************************************************
   * Main Method tests
   ****************************************************************************/
  static testMethod void test_postLTEDeviceToOSS_OK(){
    QueueHttpMock mock = new QueueHttpMock();
    //Need mock response from /lte/organizations/{org_id}/groups?name=...
    mock.addResponse(getMock_getGroupByOrgId_FILTERED_EMPTY());
    //Need mock response from POST /lte/organizations/importdevices
    mock.addResponse(getMock_postToImportDevices_OK_SINGLE());
    //Need mock response from POST /lte/devices/{org_id}/{group_id}...
    mock.addResponse(getMock_postToOSS_OK());
    Test.setMock(HttpCalloutMock.class, mock);
    list<Asset> inputList = [SELECT Id, Name, Asset_Id__c, Product2.ProductCode,
                            Parent_Asset__c, Parent_Asset__r.Product2.ProductCode 
                            FROM Asset];
    test.startTest();
    serviceResults log = Service_LTEDevices.postLTEDeviceToOSS(inputList);
    test.stopTest();
    system.assert(log.success);
    system.assert(log.message.contains('SERVICE_FINISHED'), log);
    system.assert(log.message.contains('LTE Device POSTing Process completed successfully!'), log);
  }
  /*static testMethod void test_postLTEDeviceToOSS_FAIL(){
    QueueHttpMock mock = new QueueHttpMock();
    //Need mock response from /lte/organizations/{org_id}/groups?name=...
    mock.addResponse(getMock_getGroupByOrgId_FILTERED_OK());
    //Need mock response from POST /lte/devices/{org_id}/{group_id}...
    mock.addResponse(getMock_error_500());
    Test.setMock(HttpCalloutMock.class, mock);
    list<Asset> inputList = [SELECT Id, Name, Asset_Id__c, Product2.ProductCode,
                            Parent_Asset__c, Parent_Asset__r.Product2.ProductCode 
                            FROM Asset];
    test.startTest();
    serviceResults log = Service_LTEDevices.postLTEDeviceToOSS(inputList);
    test.stopTest();
    system.assertEquals(false, log.success, log);
    system.assert(log.message.contains('SERVICE_FINISHED'), log);
    system.assert(log.message.contains('LTE Devices Service failed to complete successfully. See log for details.'), log);
  }*/

  /*****************************************************************************
   * setup methods for commonly used HTTP mock responses....
   ****************************************************************************/
  static HttpResponse getMock_error_500(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(500);
    returnMock.setBody('{"message": "this is a mock error message"}');
    return returnMock;
  }
  static HttpResponse getMock_getGroupByOrgId_MULTI(){
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
  static HttpResponse getMock_getGroupByOrgId_FILTERED_EMPTY(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    returnMock.setBody('[]');
    return returnMock;
  }
  static HttpResponse getMock_noBodyNullCode(){ //This response with cause an Exception
    //Good for testing catch(Exception e){ ... } blocks!
    HttpResponse returnMock = new HttpResponse();
    //The platform appears to default the response code 0 when a value is not set.
    return returnMock;
  }
  static HttpResponse getMock_postToOSS_OK(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(201);
    return returnMock;
  }
  static HttpResponse getMock_badBodyNullCode(){ //This response with cause an Exception
    //Good for testing catch(Exception e){ ... } blocks!
    HttpResponse returnMock = new HttpResponse();
    returnMock.setBody('{');
    //The platform appears to default the response code 0 when a value is not set.
    return returnMock;
  }
  static HttpResponse getMock_postToImportDevices_OK_SINGLE(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(201);
    returnMock.setBody('{"imported_devices": [' +
                            '{"group_id": 160,' +
                            '"sn": "2934-B1AE-EE0E"} ' +
                           ']}');
    return returnMock;
  }
  static HttpResponse getMock_postToImportDevices_500_SINGLE(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(500);
    returnMock.setBody('{"message": ' +
    '"The following serial numbers ([\'1234-5678-3210\']) failed lookup."}');
    return returnMock;
  }
}