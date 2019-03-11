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
private class test_EquipmentBatch {
		
	private static final Id Platform_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Demo/Test/Monitor').getRecordTypeId();
	private static final Id Direct_Customer_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Customer').getRecordTypeId();
	private static final Id Product2_Hardware_RECORD_TYPE_ID = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Hardware').getRecordTypeId();
	
    @testSetup static void setupTestData() {
        // An Account and a Platform or two...
        // Need to use that read record type sObject.describe call
        List<Account> AcctList = new List<Account>();
        Account Platform1 = new Account();
        Platform1.RecordTypeId = Platform_RECORD_TYPE_ID;
        Platform1.name = 'Platform 1';
        AcctList.Add(Platform1);
        
        Account Platform2 = new Account();
        Platform2 = Platform1.clone(false, true, false, false);
        Platform2.name = 'Platform 2';
        AcctList.Add(Platform2);
        
        Account Account1 = new Account();
        Account1.RecordTypeId = Direct_Customer_RECORD_TYPE_ID;
        Account1.name = 'Account 1';
        Account1.BillingCountry = 'Spain'; 		//rhymes with "Pain"....
        AcctList.Add(Account1);
        
        Account Account2 = new Account();
        Account2 = Account1.clone(false, true, false, false);
        Account2.name = 'Account 2';
        AcctList.Add(Account2);
        
        Account Account3 = new Account();
        Account3 = Account2.clone(false, true, false, false);
        Account3.name = 'Account 3';
        AcctList.Add(Account3);
        
        Account Account4 = new Account();
        Account4 = Account3.clone(false, true, false, false);
        Account4.name = 'Account 4';
        AcctList.Add(Account4);
        
        Account Account5 = new Account();
        Account5 = Account4.clone(false, true, false, false);
        Account5.name = 'Account 5';
        AcctList.Add(Account5);
        
        insert AcctList;
        
        AcctList.clear();
        // Need to update Platforms with Parent Account Ids
        Platform1.ParentId = Account1.Id;
        AcctList.add(Platform1);
        Platform2.ParentId = Account1.Id;
        AcctList.add(Platform2);
        Account1.ParentId = Account2.Id;
        Account2.ParentId = Account3.Id;
        Account3.ParentId = Account4.Id;
        Account4.ParentId = Account5.Id;
        AcctList.add(Account1);
        AcctList.add(Account2);
        AcctList.add(Account3);
        AcctList.add(Account4);
        update AcctList;
        // Need to use that read record type sObject.describe call 

        // Going to need Assets with the right antenna types
        // probably the products they are based on
        list<string> ProdCodes = new list<String>{'02-1860','02-1982','02-1563','02-1809','02-1925','02-1562','02-1875','02-2008','02-2103','02-2104'};
        list<Product2> ProdList = new list<Product2>();
       
        for (string pn : ProdCodes){
        	Product2 prod = new Product2();
        	prod.Name = 'test ' + pn;
        	prod.ProductCode = pn;
        	prod.RecordTypeId = Product2_Hardware_RECORD_TYPE_ID;
        	ProdList.add(prod);
        }
        insert ProdList;
        system.debug(ProdList);
        
        list<Asset> assetList = new list<Asset>();
        for (product2 p : [SELECT Id, Name, ProductCode FROM Product2 WHERE Name LIKE 'test 02-%']){
        	Asset a = new Asset();
        	a.Name = 'Asset from ' + p.Name;
        	a.AccountId = Platform1.Id;
        	a.Product2Id = p.Id;
        	assetList.add(a);
        }
        insert assetList;
        system.debug(assetList);
    }
    
    static testMethod void testBatch(){
    	Test.startTest();
    	EquipmentBatch1 batch = new EquipmentBatch1();
		Id JobId = Database.executeBatch(batch);
		system.debug('Started Batch Apex Job: '+ JobId);
    	test.stopTest();
    	Account testAcct = [Select a.Id, a.Name, a.Has_V7__c, a.Has_V3__c, a.Has_V11__c, a.Has_MediaServer__c, a.Has_IPACU__c, a.Has_ICM__c, a.Has_ACU__c
    						From Account a Where Name = 'Account 5'];
    	system.assert(testAcct.Has_V7__c);
    	system.assert(testAcct.Has_V3__c);
    	system.assert(testAcct.Has_V11__c);
    	system.assert(testAcct.Has_MediaServer__c);
    	system.assert(testAcct.Has_IPACU__c);
    	system.assert(testAcct.Has_ICM__c);
    	system.assert(testAcct.Has_ACU__c);
    	
    }
}