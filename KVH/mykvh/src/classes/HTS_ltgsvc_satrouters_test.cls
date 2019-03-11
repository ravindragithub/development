/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class HTS_ltgsvc_satrouters_test {
  static string SatRouterstring = '12345';
  
	@testSetup static void setupTestData(){
		//setup common test data here
    //We need to setup the Custom Setting here... 
    string orgId = UserInfo.getOrganizationId();// This sets up the Current Org as the "Production" Org regardless of instance....
    Production_Org_Ids__c mySetting = Production_Org_Ids__c.getOrgDefaults();
    mySetting.Org_Id_18_char__c = orgId;
    mySetting.Org_Id_15_char__c = orgId.left(15);
    upsert mySetting;
    
    Account insertAccount = new Account(name = 'test Account');
    insert insertAccount;

    Asset insertAsset = new Asset();
    insertAsset.Name = 'KVH-SR-' + SatRouterstring;
    insertAsset.SerialNumber = SatRouterstring;
    insertAsset.AccountId = insertAccount.Id;
    insert insertAsset;

    Asset insertAsset2 = new Asset();
    insertAsset2.Name = '987654321===';
    insertAsset2.SerialNumber = '987654321===';
    insertAsset2.AccountId = insertAccount.Id;
    insert insertAsset2;

    DefaultAccounts__c insertSetting = new DefaultAccounts__c();
		//insertSetting.Account_ID__c = '001000000000000000';
		insertSetting.Account_ID__c = insertAccount.Id;
		insertSetting.Description__c = 'This is a list of Accounts used for special/default purposes. e.g. Activations in Progress, Default Assets, Replaced Assets....';
		insertSetting.Name = 'DefaultAssets';
		insert insertSetting;
	}
	
	static testMethod void testSetupData(){
		//use this method to validate that you have test data setup correctly
		//This just verifies that the Current Org Id (Production or Sandbox) got setup in the Custom Setting as the Production Org Id....
    //Effectively causing the testClass to behave as if it is running in Production.
    string orgId = UserInfo.getOrganizationId();
    Production_Org_Ids__c mySetting = Production_Org_Ids__c.getOrgDefaults();
    system.assertEquals(orgId, mySetting.Org_Id_18_char__c);
    set<String> assetNames = new set<String>();

    for(Asset a : [SELECT Id, SerialNumber, Name FROM Asset]){
      system.assert(assetNames.add(a.SerialNumber));
    }
    system.assertEquals(2,assetNames.size());
    system.assert(assetNames.contains(SatRouterstring));
    system.assert(assetNames.contains('987654321==='));

    DefaultAccounts__c defAcct =  DefaultAccounts__c.getValues('DefaultAssets');
		Account a = [SELECT Id FROM Account LIMIT 1];
		system.assertEquals(a.id, defAcct.Account_ID__c);
	}

  static testMethod void test_getSatRouterFromSFDC(){
    list<Asset> readAssets = [SELECT Id, Name FROM Asset];
    test.startTest();
    HTS_ltgsvc_satrouters.Helpers util = new HTS_ltgsvc_satrouters.Helpers();
    HTS_ltgsvc_satrouters resultsObj = util.getSatRouterFromSFDC(SatRouterstring);
    system.debug('test_getSatRouterFromSFDC : ' + resultsObj.assetCollection);
    system.assertEquals('12345', resultsObj.assetCollection[0].SerialNumber);
    system.assertEquals('KVH-SR-12345', resultsObj.assetCollection[0].Name);
    test.stopTest();
  }
  static testMethod void test_getSatRouterFromSFDC_multiples(){
    list<Asset> readAssets = [SELECT AccountId, Name, SerialNumber FROM Asset];
    Asset dupeAsset = readAssets[0];
    dupeAsset.Id = null;
    dupeAsset.Name = 'KVH-SR-54321';
    insert dupeAsset;
    readAssets.clear();
    readAssets = [SELECT AccountId, Name, SerialNumber FROM Asset];
    system.assertEquals(3,readAssets.size());
    test.startTest();
    HTS_ltgsvc_satrouters.Helpers util = new HTS_ltgsvc_satrouters.Helpers();
    HTS_ltgsvc_satrouters resultsObj = util.getSatRouterFromSFDC(SatRouterstring);
    system.debug('test_getSatRouterFromSFDC : ' + resultsObj.assetCollection);
    system.assertEquals('ERROR:', resultsObj.statusMessage.left(6));
    system.assertEquals(2, resultsObj.assetCollection.size());
    test.stopTest();
  }

  static testMethod void test_lookupSatRouter_OSSDupe(){ //
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //Need mock response for getSatRouterFromOSS(null, null, null, integer.valueOf(serial), null)
    mock.addResponse(getMock_CoreIdList_OK());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    HTS_ltgsvc_satrouters resultsObj = HTS_ltgsvc_satrouters.lookupSatRouter('12345');
    system.assertEquals('2121', resultsObj.satRouterMap.get('obj_id'));
    system.assertEquals('1', resultsObj.satRouterMap.get('obj_revision'));
    system.assertEquals('KVH-SR-12345', resultsObj.satRouterMap.get('obj_name'));
    system.assertEquals('12345', resultsObj.satRouterMap.get('serialnumber'));
    system.assertEquals(1, resultsObj.assetCollection.size());
    system.assertEquals('ERROR:', resultsObj.statusMessage.left(6));
    test.stopTest();
  }
  static testMethod void test_lookupSatRouter_OSSNoDupe(){ //
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //Need mock response for getSatRouterFromOSS(null, null, null, integer.valueOf(serial), null)
    mock.addResponse(getMock_CoreIdList_EMPTY());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    HTS_ltgsvc_satrouters resultsObj = HTS_ltgsvc_satrouters.lookupSatRouter('54321');
    system.assertEquals('NOT FOUND:', resultsObj.satRouterMap.get('obj_id').left(10));
    system.assertEquals('NOT FOUND:', resultsObj.satRouterMap.get('obj_revision').left(10));
    system.assertEquals('NOT FOUND:', resultsObj.satRouterMap.get('obj_name').left(10));
    system.assertEquals('NOT FOUND:', resultsObj.satRouterMap.get('serialnumber').left(10));
    system.assertEquals(0, resultsObj.assetCollection.size());
    system.assertEquals('SUCCESS:', resultsObj.statusMessage.left(8));
    test.stopTest();
  }
  static testMethod void test_lookupSatRouter_OSS_MULTI(){ //
    //Need mock responses for a whole bunch of things!
    QueueHttpMock mock = new QueueHttpMock();
    //Need mock response for getSatRouterFromOSS(null, null, null, integer.valueOf(serial), null)
    mock.addResponse(getMock_CoreIdList_MULTI());
    Test.setMock(HttpCalloutMock.class, mock);
    test.startTest();
    HTS_ltgsvc_satrouters resultsObj = HTS_ltgsvc_satrouters.lookupSatRouter('54321');
    system.assertEquals('ERROR:', resultsObj.satRouterMap.get('obj_id').left(6));
    system.assertEquals('ERROR:', resultsObj.satRouterMap.get('obj_revision').left(6));
    system.assertEquals('ERROR:', resultsObj.satRouterMap.get('obj_name').left(6));
    system.assertEquals('ERROR:', resultsObj.satRouterMap.get('serialnumber').left(6));
    system.assertEquals(0, resultsObj.assetCollection.size());
    system.assertEquals('ERROR:', resultsObj.statusMessage.left(6));
    test.stopTest();
  }
  static testMethod void test_createSatRouterInOSS(){
    // Use MultiStaticResourceCalloutMock to
    // specify fake response for a certain endpoint and 
    // include response body in a static resource.    
    MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
    multimock.setStaticResource('callout:HTSOSS/hts/satelliterouters/' , 'HTS_GET_SatRouter_MOCK_empty');
    multimock.setStatusCode(201);
    multimock.setHeader('Content-Type', 'application/json');
    // Set the mock callout mode
    test.setMock(HttpCalloutMock.class, multimock);
    map<string, string> testMap = new map<string, string>();
    testMap.put('serialNumber', '12345');
    test.startTest();
    HTS_ltgsvc_satrouters.Helpers util = new HTS_ltgsvc_satrouters.Helpers();
    string resultsString = util.createSatRouterInOSS(testMap);
    system.assertEquals('201', resultsString);
    test.stopTest();
  }
  static testMethod void test_insertSatRouter_OK(){
    // Use MultiStaticResourceCalloutMock to
    // specify fake response for a certain endpoint and 
    // include response body in a static resource.    
    MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
    multimock.setStaticResource('callout:HTSOSS/hts/satelliterouters/' , 'HTS_GET_SatRouter_MOCK_empty');
    multimock.setStatusCode(201);
    multimock.setHeader('Content-Type', 'application/json');
    // Set the mock callout mode
    test.setMock(HttpCalloutMock.class, multimock);
    map<string, string> testMap = new map<string, string>();
    testMap.put('provisioningKey', 'ADFASEVEQQWERAFD===');
    testMap.put('serialNumber', '12345');
    testMap.put('revision', '1');
    test.startTest();
    HTS_ltgsvc_satrouters resultsObj = HTS_ltgsvc_satrouters.insertSatRouter(testMap);
    system.assertEquals('SUCCESS:', resultsObj.statusMessage.left(8));
    system.assertEquals(2, resultsObj.assetCollection.size());
    test.stopTest();
  }
  static testMethod void test_insertSatRouter_FAIL(){
    // Use MultiStaticResourceCalloutMock to
    // specify fake response for a certain endpoint and 
    // include response body in a static resource.    
    MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
    multimock.setStaticResource('callout:HTSOSS/hts/satelliterouters/' , 'HTS_GET_SatRouter_MOCK_empty');
    multimock.setStatusCode(500);
    multimock.setHeader('Content-Type', 'application/json');
    // Set the mock callout mode
    test.setMock(HttpCalloutMock.class, multimock);
    map<string, string> testMap = new map<string, string>();
    testMap.put('provisioningKey', 'ADFASEVEQQWERAFD===');
    testMap.put('serialNumber', '12345');
    testMap.put('revision', '1');
    test.startTest();
    HTS_ltgsvc_satrouters resultsObj = HTS_ltgsvc_satrouters.insertSatRouter(testMap);
    system.assertEquals('ERROR:', resultsObj.statusMessage.left(6));
    test.stopTest();
  }
  static testMethod void test_insertSatRouter_FAIL_2(){
    map<string, string> testMap = new map<string, string>();
    testMap.put('provisioningKey', '987654321===');
    testMap.put('serialNumber', '12345');
    testMap.put('revision', '1');
    test.startTest();
    HTS_ltgsvc_satrouters resultsObj = HTS_ltgsvc_satrouters.insertSatRouter(testMap);
    system.assertEquals('ERROR:', resultsObj.statusMessage.left(6));
    test.stopTest();
  }
  static testMethod void test_checkProvKeyForDupes(){
    HTS_ltgsvc_satrouters.Helpers util = new HTS_ltgsvc_satrouters.Helpers();
    HTS_ltgsvc_satrouters resultsObj = util.checkProvKeyForDupes('9876543210===');
    system.assertEquals('Status pending....', resultsObj.statusMessage);
    resultsObj = util.checkProvKeyForDupes('987654321===');
    system.assertEquals('ERROR:', resultsObj.statusMessage.left(6));
  }

  //setup methods for commonly used HTTP mock responses....

  static HttpResponse getMock_CoreIdList_OK(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    returnMock.setBody('[{"chip_sn": "1111111112", ' +
                          '"model": "X7", ' +
                          '"obj_id": 2121, ' +
                          '"obj_name": "KVH-SR-12345", ' +
                          '"obj_revision": 1, ' +
                          '"serialnumber": 12345}]');
    return returnMock;
  }
  static HttpResponse getMock_CoreIdList_EMPTY(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    returnMock.setBody('[]');
    return returnMock;
  }
  static HttpResponse getMock_CoreIdList_MULTI(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    returnMock.setBody('[{"chip_sn": "1111111112", ' +
                          '"model": "X7", ' +
                          '"obj_id": 2121, ' +
                          '"obj_name": "KVH-SR-12345", ' +
                          '"obj_revision": 1, ' +
                          '"serialnumber": 12345},' +
                          '{"chip_sn": "1111111112", ' +
                          '"model": "X7", ' +
                          '"obj_id": 2121, ' +
                          '"obj_name": "KVH-SR-12346", ' +
                          '"obj_revision": 1, ' +
                          '"serialnumber": 12346}]');
    return returnMock;
  }
  static HttpResponse getMock_CoreId_OK(){
    HttpResponse returnMock = new HttpResponse();
    returnMock.setStatusCode(200);
    returnMock.setBody('{"chip_sn": "1111111112",' + 
                        '"model": "X7",' +
                        '"obj_id": 2121,' +
                        '"obj_name": "A_SROUTE_TEST_0000002",' +
                        '"obj_revision": 1,' +
                        '"serialnumber": 66667}');
    return returnMock;
  }

}