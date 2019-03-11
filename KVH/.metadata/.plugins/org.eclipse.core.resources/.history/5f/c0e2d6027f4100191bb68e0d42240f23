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
private class IPMC_Service_Mapping_Controller_test {
    static Asset mockServer = new Asset();
    static Asset topAsset = new Asset();
    //Need to get a couple of Record Types...
    private static final Id testPlatform = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Demo/Test/Monitor').getRecordTypeId();
    private static final Id testDirect = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Customer').getRecordTypeId();
    private static final Id testHardware = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Hardware').getRecordTypeId();
    private static final Id testIdentifier = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Identifier').getRecordTypeId();
    
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
    }
    static testMethod void testSetupData(){
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
    static testMethod void testSiteDeactivate(){    //too many soql...
        /*createTestHierarchy();
        system.debug('Create Test Hierarchy SOQL : ' + Limits.getQueries());
        createTestIPMCBundle();
        system.debug('Create Test Bundles SOQL : ' + Limits.getQueries());
        createMockKCL();
        system.debug('Create Mock KCL : ' + Limits.getQueries());
        configureMockServer('DEACTIVATE');          // make sure mockServer to deactivate Asset has a Site ID!
        system.debug(mockServer);
        system.debug('Update Mock Server SOQL : ' + Limits.getQueries());
        */
        // Instanciate Controller
        IPMC_Service_Mapping_Controller controller = new IPMC_Service_Mapping_Controller(); 
        topAsset      = [ Select id, name from Asset where name = 'System Root Asset' limit 1 ];
        mockServer   = [ Select id, parent_Asset__c, name, IPMC_License_Issued_by__c, IPMC_KenCast_SiteID__c from Asset where name = 'ICM' limit 1 ];
        mockServer.IPMC_KenCast_SiteID__c = '170612';
        mockServer.IPMC_License_Issued_by__c = UserInfo.getUserId();
        update mockServer;
        system.debug('Top Asset in testMethod : ' + topAsset);
        system.debug('Create Controller SOQL : ' + Limits.getQueries());
        
        controller.test_setHierarchy(topAsset.Id);      //Special test method for private method
        //List<AssetStructureEngine.AssetStructureMap> Hierarchy = new List<AssetStructureEngine.AssetStructureMap>();
        //Hierarchy = controller.getHierarchy();
        //system.assertNotEquals(0, Hierarchy.size());
        
        system.debug('After test Data Setup SOQL : ' + Limits.getQueries());
        test.startTest(); 
        system.debug('After startTest Method SOQL : ' + Limits.getQueries());
        //setup Mock Callout...
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('siteActivateOK');                           //uses a static resource...
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);

        controller.setReceiveSite(mockServer.Id);
        controller.test_setBillingAcct('99999');
        system.debug('Invoking Site Deactivate.....');
        controller.SiteDeactivate();
        test.stopTest();
    }
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
    }
}