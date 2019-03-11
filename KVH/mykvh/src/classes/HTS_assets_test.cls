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
private class HTS_assets_test {
  
	@testSetup static void setupTestData(){
		//setup common test data here
		//Need that "default Account" custom setting
		Account testAccount = new Account(Name='Test Account');
		insert testAccount;
		DefaultAccounts__c insertSetting = new DefaultAccounts__c();
		//insertSetting.Account_ID__c = '001000000000000000';
		insertSetting.Account_ID__c = testAccount.Id;
		insertSetting.Description__c = 'This is a list of Accounts used for special/default purposes. e.g. Activations in Progress, Default Assets, Replaced Assets....';
		insertSetting.Name = 'DefaultAssets';
		insert insertSetting;
		//Need a couple of Products
		//TODO: setup MAX_LOOP_COUNTER and loopify...
		list<Product2> testProds = new list<Product2>();
    testProds.add(new Product2(Name='P1', ProductCode = 'P1', Product_Id__c = 'P1_US'));
    testProds.add(new Product2(Name='P2', ProductCode = 'P2', Product_Id__c = 'P2_US'));
    testProds.add(new Product2(Name='P3', ProductCode = 'P3', Product_Id__c = 'P3_US'));
    insert testProds;
	}
	
	static testMethod void testSetupData(){
		//use this method to validate that you have test data setup correctly
		DefaultAccounts__c defAcct =  DefaultAccounts__c.getValues('DefaultAssets');
		Account a = [SELECT Id FROM Account LIMIT 1];
		system.assertEquals(a.id, defAcct.Account_ID__c);
		list<Product2> testProds = [SELECT Id, Name, ProductCode FROM Product2];
		system.assertEquals(3, testProds.size());
	}
	//GOt an overloaded method here...
	static testMethod void test_create_generic_Asset_1(){
	  Default_Identifier_Product__mdt VTIDproduct = [SELECT Identifier_Product_reference__c, Legacy_Product_Id__c 
                                               FROM Default_Identifier_Product__mdt 
                                               WHERE DeveloperName = 'Virtual_Terminal_Id'];
    Account a = [SELECT Id FROM Account LIMIT 1];
    Asset y = HTS_Assets.create_generic_Asset('Virtual_Terminal_Id', '12345678');
    system.assertEquals('12345678', y.Name);
    system.assertEquals('12345678', y.SerialNumber);
    system.assertEquals(VTIDproduct.Identifier_Product_reference__c, y.Product2Id);
    system.assertEquals(VTIDproduct.Legacy_Product_Id__c + '_12345678', y.Asset_Id__c);
    system.assertEquals(a.Id, y.AccountId);
	}
	static testMethod void test_create_generic_Asset_2(){
    list<Product2> testProds = [SELECT Id, Name, ProductCode, Product_Id__c FROM Product2];
    Account a = [SELECT Id FROM Account LIMIT 1]; 
    Asset y = HTS_Assets.create_generic_Asset(testProds[0], '12345');
    system.assertEquals('12345', y.Name);
    system.assertEquals('12345', y.SerialNumber);
    system.assertEquals(testProds[0].Id, y.Product2Id);
    system.assertEquals(testProds[0].Product_Id__c + '_12345', y.Asset_Id__c);
    system.assertEquals(a.Id, y.AccountId);
  }
	//Got an overloaded method here...
  static testMethod void test_getAssetTemplate_1(){
    Default_Identifier_Product__mdt VTIDproduct = [SELECT Identifier_Product_reference__c 
                                               FROM Default_Identifier_Product__mdt 
                                               WHERE DeveloperName = 'Virtual_Terminal_Id'];
    Account a = [SELECT Id FROM Account LIMIT 1];
    Asset y = HTS_assets.getAssetTemplate('Virtual_Terminal_Id');
    system.assertEquals(a.id, y.AccountId);
    system.assertEquals(VTIDproduct.Identifier_Product_reference__c, y.Product2Id);
  }
  static testMethod void test_getAssetTemplate_2(){ 
    list<Product2> testProds = [SELECT Id, Name, ProductCode, Product_Id__c FROM Product2];
    Account a = [SELECT Id FROM Account LIMIT 1]; 
    Asset testAsset = HTS_assets.getAssetTemplate(testProds[0]);
    system.assertEquals(a.Id, testAsset.AccountId);
    system.assertEquals(testProds[0].Id, testAsset.Product2Id);
    system.assertEquals(testProds[0].ProductCode + '_US', testAsset.Asset_Id__c);
  }  
	static testMethod void test_create_VTIDS_Asset() {
	  Default_Identifier_Product__mdt VTIDproduct = [SELECT Identifier_Product_reference__c, Legacy_Product_Id__c 
	                                                 FROM Default_Identifier_Product__mdt 
	                                                 WHERE DeveloperName = 'Virtual_Terminal_Id'];
    Account a = [SELECT Id FROM Account LIMIT 1];
    HTS_Virtual_Terminal_ID__c x = new HTS_Virtual_Terminal_ID__c(Virtual_Terminal_Id__c = '12345678');
    Asset y = HTS_assets.create_VTIDS_Asset(x);
    system.assertEquals(a.id, y.AccountId);
    system.assertEquals(VTIDproduct.Identifier_Product_reference__c, y.Product2Id);
    system.assertEquals('12345678', y.Name);
    system.assertEquals('12345678', y.SerialNumber);
    system.assertEquals(VTIDproduct.Legacy_Product_Id__c + '_12345678', y.Asset_Id__c);
	}
	static testMethod void test_create_HTS_IP_Asset() {
    Default_Identifier_Product__mdt VTIDproduct = [SELECT Identifier_Product_reference__c, Legacy_Product_Id__c 
                                                   FROM Default_Identifier_Product__mdt 
                                                   WHERE DeveloperName = 'HTS_IP_Address'];
    Account a = [SELECT Id FROM Account LIMIT 1];
    HTS_IP_Address__c x = new HTS_IP_Address__c(HTS_IP_Address__c = '10.66.66.66');
    Asset y = HTS_assets.create_HTS_IP_Asset(x);
    system.assertEquals(a.id, y.AccountId);
    system.assertEquals(VTIDproduct.Identifier_Product_reference__c, y.Product2Id);
    system.assertEquals('10.66.66.66', y.Name);
    system.assertEquals('10.66.66.66', y.SerialNumber);
    system.assertEquals(VTIDproduct.Legacy_Product_Id__c + '_10.66.66.66', y.Asset_Id__c);
  }

  static testMethod void test_getHierarchyTemplate(){
    list<Asset_Hierarchy_Template__mdt> readList = new list<Asset_Hierarchy_Template__mdt>();
    readList = HTS_Assets.getHierarchyTemplate('02-2204-02');
    for(Asset_Hierarchy_Template__mdt h : readList){
      system.assertEquals('02-2204-02',h.Root__c);
    }
  }
  static testMethod void test_getProduct2List(){
    HTS_Assets util = new HTS_Assets();
    list<string> partNums = new list<string>{'P1', 'P2', 'P3'};
    map<string, Product2> readMap = util.getProduct2List(partNums);
    for(string pn : partNums){
      //system.assertEquals(pn, readMap.get(pn).Name); Method does not return Name... who knew!
      system.assertEquals(pn, readMap.get(pn).ProductCode);
      system.assertEquals(pn + '_US', readMap.get(pn).Product_Id__c);
    }
  }
  static testMethod void test_getHierarchyMap(){
    string root = '02-2204-02';
    map<String, Asset_Hierarchy_Template__mdt> resultsMap = HTS_Assets.getHierarchyMap(root);
    for(String s : resultsMap.keySet()){
      system.assertEquals(root, resultsMap.get(s).Root__c);
    }
  }
}