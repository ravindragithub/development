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
private class Test_AssetUtilities {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        //Create Account
        Account testAcct = new Account();
        testAcct.Name = 'KVH Default test Acct';
        insert testAcct;
        //Create Products '02-2103', 'MS LICENSE', 'Secure Media ID', 'Host OS ID', 'Omni ID'
        List<String> ProdNames = new List<String> {'02-2143', '02-2104', '02-2103', 'MS LICENSE', 'Secure Media ID', 'Host OS ID', 'Omni ID'};
        List<Product2> ProdList = new List<Product2>();
        for(string s : ProdNames){
        	Product2 p = new Product2();
        	p.Name = s;
        	p.ProductCode = s;
        	ProdList.add(p);
        }
        insert ProdList;
        //Create a MediaServerConfigs
        
        
        
        
    	Media_Server_Configuration__c ms = new Media_Server_Configuration__c();
    	
    	ms.Hardware_Serial_Number__c = '0000MCS001';
    	system.debug(ms.Hardware_Serial_Number__c);
    	insert ms;										//Trigger creates Assets....
        

        //ACT
        test.startTest();
        
        List<Asset> assetList = new List<Asset>();
        assetList = [SELECT Name, Id, Asset_ID__c FROM Asset WHERE Name LIKE '0000MCS%'];
        system.debug(assetList);
        system.assertEquals(1, assetList.size());
        for (Asset a : assetList){
        	system.assertEquals('02-2103_US_0000MCS', a.Asset_ID__c.substring(0,18));
        }
        //now create a SuperYacht version...
        Media_Server_Configuration__c SY = new Media_Server_Configuration__c();
        SY.Hardware_Serial_Number__c = 'Super0001';
        SY.Hardware_Part_Number__c = '02-2104';
        system.debug(SY);
        system.debug('inserting Media Server Config for SuperYacht..............');
        insert SY;		//Trigger creates Assets....
        system.debug('inserted Media Server Config for SuperYacht..............');
        List<Asset> SYassetList = new List<Asset>();
        SYassetList = [SELECT Name, Id, Asset_ID__c, Product2.ProductCode FROM Asset WHERE Name LIKE 'Super00%'];
        system.debug(SYassetList);
        system.assertEquals(1, SYassetList.size());
        system.assertEquals('02-2104', SYassetList[0].Product2.ProductCode);
        //now create an "ABSENT" part number version... 
        Media_Server_Configuration__c ABS = new Media_Server_Configuration__c();
        ABS.Hardware_Serial_Number__c = 'Absent001';
        ABS.Hardware_Part_Number__c = '02-9999';
        system.debug(ABS);
        system.debug('inserting Media Server Config for Bogus Part Number..............');
        insert ABS;		//Trigger creates Assets....
        system.debug('inserted Media Server Config for Bogus Part Number..............');
        List<Asset> BogusAssetList = new List<Asset>();
        BogusAssetList = [SELECT Name, Id, Asset_ID__c, Product2.ProductCode FROM Asset WHERE Name LIKE 'Absent0%'];
        system.debug(BogusAssetList);
        system.assertEquals(1, BogusAssetList.size());
        system.assertEquals('02-2103', BogusAssetList[0].Product2.ProductCode);
        test.stopTest();
    }
    
    static testMethod void testCheckForExisting(){
    	//Create Account
        Account testAcct = new Account();
        testAcct.Name = 'KVH Default test Acct';
        insert testAcct;
        
    	Product2 p = new Product2();
    	p.Name = '02-2103';
    	p.ProductCode = '02-2103';
    	insert p;
        
        
        //Create Asset
        Asset testAsset = new Asset();
        testAsset.name = 'CheckForExistingAsset';
        testAsset.AccountId = testAcct.id;
        testAsset.Product2Id = p.id;
        testAsset.SerialNumber = 'CheckForExistingAsset';
        insert testAsset;
        
        //ACT
        AssetUtilities au = new AssetUtilities();
        List<Asset> assetList2 = new List<Asset>();
        
        //test CheckForExisting method
        assetList2 = au.CheckForExisting('CheckForExistingAsset');
        system.debug(assetList2);
        system.assertEquals(1, assetList2.size());
    }
}