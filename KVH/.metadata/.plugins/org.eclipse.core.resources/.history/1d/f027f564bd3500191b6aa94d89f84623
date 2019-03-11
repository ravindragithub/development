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
private class IPMC_Utilities_test {
    private static final Id testPlatform = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Demo/Test/Monitor').getRecordTypeId();
    private static final Id testDirect = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Customer').getRecordTypeId();
    
    @testSetup static void setupTestData(){
        //Need a lot of data...
        //Account hierarchy with Direct Customer AND Platform
        //Asset Hierarchy with Antenna, Server, and system
        //IPMC Package
        //KenCast License
        // Set up a rudimentary Account Hierarchy with Direct Customer and Platform
        list<account> testAcctList = new list<account>();
        Account a1 = new Account();
        a1.Name = 'Direct Customer';
        a1.RecordTypeId = testDirect;
        a1.Custom_Call_Acct_ID__c = '99999';
        a1.Revenue_Category__c = 'VSAT';
        a1.Account_Effective_Date__c = date.today();
        testAcctList.add(a1);

        Account a2 = new Account();
        a2.Name = 'Hierarchy Test Platform';
        a2.RecordTypeId = testPlatform;
        a2.ParentId = a1.Id;
        testAcctList.add(a2);
        insert testAcctList;
        system.debug('createTestIPMCAccounts consumed ' + Limits.getQueries() + ' SOQL Queries');
        AssetTestData.createTestingHierarchy(a2);
        system.debug('AssetTestData.createTestingHierarchy ' + Limits.getQueries() + ' SOQL Queries');
        list<Asset> readAssets = [SELECT Id, Name, Parent_Asset__c FROM Asset];
        system.debug(readAssets);
        //setup a KenCast License
        KenCast_License__c KCL = new KenCast_License__c();
        string mockKCLicense = '<FazztLicense version="1.0">'+
        '<LicenseData>'+
        '<!-- WARNING: DO NOT MODIFY THIS FILE. Modifying this file will invalidate your license. -->'+
        '<!-- You may use this file on ONE COMPUTER ONLY. -->'+
        '<Customer Value="KVH Industries, Inc."/>'+
        '<CustomerID Value="52789"/>'+
        '<LicenseID Value="3CBCB952-0912-4114-98C3-1ECC80123236"/>'+
        '<Created Value="2013-10-24"/>'+
        '<Product Value="Fazzt Professional Client 8.2"/>'+
        '<ProductCode Value="33"/>'+
        '<Evaluation Value="TRUE"/>'+
        '<StartDate Value="2013-10-24"/>'+
        '<StopDate Value="2014-03-31"/>'+
        '<VersionMajor Value="8"/>'+
        '<VersionMinor Value="2"/>'+
        '<RxChannelTypes Value="IP,TCP"/>'+
        '<ChannelLC Value="9,33"/>'+
        '<NetworkID Value="52789"/>'+
        '<SiteID Value="170612"/>'+
        '<EULA><![CDATA[ I like CDATA ]]></EULA>'+
        '</LicenseData>'+
        '<LicenseKey>x</LicenseKey>'+
        '</FazztLicense>';
        KCL.License_File__c = mockKCLicense;
        insert KCL;
        
        
        //Need a couple of KVH_Product_Family__c records, 'IPMC Package' and 'V3'
        KVH_Product_Family__c testProdFam = new KVH_Product_Family__c(Name = 'IPMC Package');
        insert testProdFam;
        //testProdFam = [SELECT Id, Name FROM KVH_Product_Family__c WHERE Name = 'IPMC Package'];
        
        KVH_Product_Family__c testProdFam2 = new KVH_Product_Family__c(Name = 'V3');
        insert testProdFam2;
        //testProdFam2 = [SELECT Id, Name FROM KVH_Product_Family__c WHERE Name = 'V3'];
        
        //Need a couple of products...
        List<product2> pList = new List<Product2>();
        Product2 mockCBX = new Product2(name = 'CBX LICENSE', Airtime_Group__c = 'CBX', ProductCode = 'CBX LICENSE', KVH_Product_Family__c = testProdFam2.Id, isActive = true);
        pList.add(mockCBX);
        //insert mockCBX;
        //mockCBX = [SELECT id, Name, KVH_Product_Family__r.Name FROM Product2 WHERE Name = 'CBX LICENSE'];
        
        Product2 mockAntenna = new Product2(name = 'V3 Antenna', Airtime_Group__c = 'V3', ProductCode = '02-0000', KVH_Product_Family__c = testProdFam2.Id, isActive = true);
        pList.add(mockAntenna);
        //insert mockAntenna;
        //mockAntenna = [SELECT id, Name, KVH_Product_Family__r.Name FROM Product2 WHERE Name = 'V3 Antenna'];
        
        Product2 mockRefurbAntenna = new Product2(name = 'V3 Antenna refurb', Airtime_Group__c = 'V3', ProductCode = 'U02-0000', KVH_Product_Family__c = testProdFam2.Id, isActive = true);
        pList.add(mockRefurbAntenna);
        
        //and a couple of services....
        Product2 mockSVC1 = new Product2(name = 'mockSVC1', Airtime_Group__c = 'CBX', ProductCode = 'mockSVC1', KVH_Product_Family__c = testProdFam.Id);
        pList.add(mockSVC1);
        //insert mockSVC1;
        //mockSVC1 = [SELECT id, Name, KVH_Product_Family__r.Name FROM Product2 WHERE Name = 'mockSVC1'];
        
        Product2 mockSVC2 = new Product2(name = 'mockSVC2', Airtime_Group__c = 'CBX', ProductCode = 'mockSVC2', KVH_Product_Family__c = testProdFam.Id);
        pList.add(mockSVC2);
        //insert mockSVC2;
        //mockSVC2 = [SELECT id, Name, KVH_Product_Family__r.Name FROM Product2 WHERE Name = 'mockSVC2'];
        insert pList;
        
        //Need some mock PkgKinds
        list<IPMC_Package_Kinds__c> PKList = new list<IPMC_Package_Kinds__c>();
        for (integer i = 0; i<4; i++){
            IPMC_Package_Kinds__c PK = new IPMC_Package_Kinds__c(PackageKind__c = 'testPK.' + i);
            PKList.add(PK);
        }
        insert PKList;
        //and some Package Kinds by Product...
        list<Package_Kinds_by_Product__c> PKbPlist = new list<Package_Kinds_by_Product__c>();
        list<Product2> mockSVCs = new List<Product2>([SELECT id, Name, KVH_Product_Family__r.Name FROM Product2 WHERE Name LIKE 'mockSVC%']);
        for(integer i = 0; i<3; i++){
            Package_Kinds_by_Product__c PKbP1 = new Package_Kinds_by_Product__c();
            Package_Kinds_by_Product__c PKbP2 = new Package_Kinds_by_Product__c();
            PKbP1.Product__c = mockSVCs[0].Id;
            PKbP1.IPMC_Package_Kind__c = PKList[i].Id;
            PKbPlist.add(PKbP1);
            
            PKbP2.Product__c = mockSVCs[1].Id;
            PKbP2.IPMC_Package_Kind__c = PKList[i+1].Id;
            PKbPlist.add(PKbP2);
        }
        insert PKbPlist;
    }
    static testMethod void testSetupData(){
        //use this method to validate that you have test data setup correctly
        //use this method to validate that you have test data setup correctly
        //Test a lot of data...
        //Account hierarchy with Direct Customer AND Platform
        //Asset Hierarchy with Antenna, Server, and system
        //IPMC Package
        //KenCast License
        list<Account> readList = new list<Account>();
        readList = [SELECT Id, Name FROM Account];
        system.debug(readList);
        system.assertEquals(2, readList.size());
        
        list<KenCast_License__c> kclList = new list<KenCast_License__c>();
        kclList = [SELECT Id, name FROM KenCast_License__c];
        system.assertEquals(1, kclList.size());
    }
    static testMethod void test_IPMCantennaSet(){
        //IPMC_Utilities util = new IPMC_Utilities();
        list<Product2> readProds = [SELECT Id, Airtime_Group__c FROM Product2
                                    WHERE (Airtime_Group__c IN ('V3', 'V7', 'V11') AND ProductCode Like '_02-%')];
        for(Product2 p : readProds){
            system.assert(IPMC_Utilities.IPMCHardwareMap.containsKey(p.Id));
            system.assertEquals(p.Airtime_Group__c, IPMC_Utilities.IPMCHardwareMap.get(p.Id));
        }
    }
    static testMethod void testSystemCompatibility() {
        //instanciate helper class
        IPMC_Service_Mapping_Controller ctrlhelp = new IPMC_Service_Mapping_Controller();

        //createTestHierarchy();  //This uses way too much SOQL!
        test.startTest();
        System.debug('SOQL: ' + Limits.getQueries()); 
        Asset topAsset      = [ Select id, name from Asset where name = 'System Root Asset' limit 1 ];
        ctrlhelp.test_setHierarchy(topAsset.Id);        //Special test method for private method
        List<AssetStructureEngine.AssetStructureMap> Hierarchy = new List<AssetStructureEngine.AssetStructureMap>();
        Hierarchy = ctrlhelp.getHierarchy();
        system.assertNotEquals(0, Hierarchy.size());
        //OK, so we have a hierarchy... now create an instance of the Class we are testing....
        
        //Need a couple of products...
        //createTestProducts();
        List<Product2> pList = new List<Product2>();
        for (Product2 p : [SELECT id, Name, KVH_Product_Family__r.Name FROM Product2 WHERE Name LIKE 'mockSVC%']){
            p.IsActive = true;
            pList.Add(p);
        }
        update pList;

        IPMC_Utilities testInstance = new IPMC_Utilities();
        List<IPMC_Utilities.EligibleProducts> EPs = new List<IPMC_Utilities.EligibleProducts>();
        EPs = testInstance.getIPMCProducts();
        system.debug('This is the list of Eligible Products : ' + EPs);
        testInstance.systemCompatibility(EPs, Hierarchy);
        test.stopTest();
    }
    static testMethod void test_findExistingSubscriptions(){
        //instanciate helper class
        IPMC_Service_Mapping_Controller ctrlhelp = new IPMC_Service_Mapping_Controller();
        //need a test hierarchy...
        //createTestHierarchy();      //This uses WAY to much SOQL
        test.startTest();
        System.debug('SOQL: ' + Limits.getQueries()); 
        Asset topAsset      = [ Select id, name, Account.Id from Asset where name = 'System Root Asset' limit 1 ];
        ctrlhelp.test_setHierarchy(topAsset.Id);            //Special test method for private method
        List<AssetStructureEngine.AssetStructureMap> Hierarchy = new List<AssetStructureEngine.AssetStructureMap>();
        Hierarchy = ctrlhelp.getHierarchy();
        system.assertNotEquals(0, Hierarchy.size());                        //OK, so we have a hierarchy... 
        List<Asset> simpleAssetList = new List<Asset>();                    //convert the hierarchy to a simple Asset List
        for (AssetStructureEngine.AssetStructureMap a : Hierarchy){
            simpleAssetList.Add(a.asset);
        }
        system.assertEquals(Hierarchy.size(), simpleAssetList.size());      //The simple list should be the same size as the hierarchy!
        //setup contract...
        Contract k = new Contract();
        k.AccountId = topAsset.Account.Id;
        insert k;
        //setup Eligible Product List
        IPMC_Utilities testInstance = new IPMC_Utilities();
        List<IPMC_Utilities.EligibleProducts> EPsIN = new List<IPMC_Utilities.EligibleProducts>();
        List<IPMC_Utilities.EligibleProducts> EPsOUT = new List<IPMC_Utilities.EligibleProducts>();
        EPsIN = testInstance.getIPMCProducts();
        system.debug('This is the input list of Eligible Products : ' + EPsIN);     //Need an input list to the method...
        EPsOUT = testInstance.findExistingSubscriptions(simpleAssetList, EPsIN);
        system.debug('This is the output list of Eligible Products : ' + EPsOUT);   //and an output list from the method
        system.assertEquals(EPsIN.size(), EPsOUT.size());                           //they should be the same size!
        //setup a Contracted Service....
        //Need a couple of products...
        //createTestProducts();
        Product2 mockSVC1 = [SELECT id, Name, KVH_Product_Family__r.Name FROM Product2 WHERE Name = 'mockSVC1'];
        Product2 mockSVC2 = [SELECT id, Name, KVH_Product_Family__r.Name FROM Product2 WHERE Name = 'mockSVC2'];
        mockSVC1.IsActive = true;
        update mockSVC1;
        mockSVC2.IsActive = true;
        update mockSVC2;
        //create a Contracted Service....
        Contracted_Services__c ConServ = new Contracted_Services__c();
        ConServ.Contract__c = k.Id;
        ConServ.Service_Item__c = mockSVC1.Id;
        //need to associate an Asset....
        Asset mockServer   = [ Select id, parent_Asset__c, name from Asset where name = 'ICM' limit 1 ];
        ConServ.Asset__c = mockServer.id;
        insert ConServ;
        //RESET....
        EPsOUT.clear();
        EPsIN.clear();
        EPsIN = testInstance.getIPMCProducts();
        system.debug('This is the input list of Eligible Products : ' + EPsIN);     //Need an input list to the method...
        EPsOUT = testInstance.findExistingSubscriptions(simpleAssetList, EPsIN);
        system.debug('This is the output list of Eligible Products : ' + EPsOUT);   //and an output list from the method
        system.assertEquals(EPsIN.size(), EPsOUT.size());                           //they should be the same size!
        for (IPMC_Utilities.EligibleProducts e : EPsOUT){
            system.debug(e);
            if (e.ContractedService.Service_Item__c == mockSVC1.Id){
                system.debug('Existing Subscription Found!!');
                system.assert(e.Selected);
            }
        }
        test.stopTest();
    }
    static testMethod void test_getPKsByProduct(){
        list<Product2> mockSVCs = new List<Product2>([SELECT id, Name, KVH_Product_Family__r.Name FROM Product2 WHERE Name LIKE 'mockSVC%']);
        map<Id, list<IPMC_Package_Kinds__c>> testMap = new map<Id, list<IPMC_Package_Kinds__c>>();
        IPMC_Utilities util = new IPMC_Utilities();
        testMap = util.getPKsByProduct(MockSVCs);
        list<IPMC_Package_Kinds__c> PKList1 = new list<IPMC_Package_Kinds__c>();
        PKList1 = testMap.get(mockSVCs[0].id);
        system.assertEquals(3, PKList1.size());
        for(IPMC_Package_Kinds__c pk : PKList1){
            system.assert(PK.PackageKind__c.startsWith('testPK.'));
            system.assertNotEquals('3', PK.PackageKind__c.right(1));
        }
        //also test getPkgKindNames
        list<string> testNamesList = new list<string>(util.getPkgKindNames(PKList1));
        for(string s : testNamesList){
            system.assert(s.startsWith('testPK.'));
        }
    }
    static testMethod void test_WrapperClass(){
        //need a product, but maybe not a Contracted Service...
        list<Product2> mockSVCs = [SELECT id, Name, KVH_Product_Family__r.Name FROM Product2 WHERE Name LIKE 'mockSVC%' LIMIT 2];
        IPMC_Utilities.EligibleProducts testEP = new IPMC_Utilities.EligibleProducts(true, mockSVCs[0], true, 'ant', 'srvr', true);
        
        system.assertEquals(true, testEP.getSelected());
        testEP.setSelected(false);
        system.assertEquals(false, testEP.getSelected());
        
        system.assertEquals(mockSVCs[0].Id, testEP.getIPMCPkg().Id);
        testEP.setIPMCPkg(mockSVCs[1]);
        system.assertEquals(mockSVCs[1].Id, testEP.getIPMCPkg().Id);
        
        system.assertEquals(true, testEP.getSystemCompatible());
        testEP.setSystemCompatible(false);
        system.assertEquals(false, testEP.getSystemCompatible());
        
        system.assertEquals('ant', testEP.getAntennaStatus());
        testEP.setAntennaStatus('ant2');
        system.assertEquals('ant2', testEP.getAntennaStatus());
        
        system.assertEquals('srvr', testEP.getServerStatus());
        testEP.setServerStatus('srvr2');
        system.assertEquals('srvr2', testEP.getServerStatus());
        
        system.assertEquals(true, testEP.getis31DayTrial());
        testEP.setis31DayTrial(false);
        system.assertEquals(false, testEP.getis31DayTrial());
    }
}