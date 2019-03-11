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
global class AssetTestData {
	
	//Need to get a couple of Record Types...
	private static final Id testPlatform = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Demo/Test/Monitor').getRecordTypeId();
	private static final Id testDirect = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Customer').getRecordTypeId();
	private static final Id testHardware = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Hardware').getRecordTypeId();
	private static final Id testIdentifier = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Identifier').getRecordTypeId();

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        createTestingAccounts();
        Account aPlatform = [SELECT Id, Name FROM Account WHERE Name = 'Hierarchy Test Platform'];
        createTestingHierarchy(aPlatform);
        
    }
    public static void createTestingHierarchy(Account acct){
    	system.debug('Platform Name : ' + acct.Name);
    	//Need a couple of KVH_Product_Family__c records, 'IPMC Package' and 'V3'
        KVH_Product_Family__c IPMCPackage = new KVH_Product_Family__c(Name = 'IPMC Package');
        insert IPMCPackage;
		KVH_Product_Family__c V3antenna = new KVH_Product_Family__c(Name = 'V3');
        insert V3antenna;
        //Need a few Products...
    	List<Product2> pList = new List<Product2>();
    	Product2 SystemRoot = new Product2();
    	SystemRoot.Name = 'SystemRoot';
    	SystemRoot.RecordTypeId = testHardware;
    	pList.add(SystemRoot);
    	Product2 Antenna = new Product2();
    	Antenna.Name = 'Antenna';
    	Antenna.RecordTypeId = testHardware;
    	Antenna.KVH_Product_Family__c = V3antenna.Id;
    	pList.add(Antenna);
    	Product2 ICM = new Product2();
    	ICM.Name = 'ICM';
    	ICM.RecordTypeId = testHardware;
    	pList.add(ICM);
    	Product2 IPAddress = new Product2();
    	IPAddress.Name = 'IP Address';
    	IPAddress.RecordTypeId = testIdentifier;
    	pList.add(IPAddress);
    	Product2 swSerial = new Product2();
    	swSerial.Name = 'swSerial';
    	swSerial.RecordTypeId = testIdentifier;
    	pList.add(swSerial);
    	Product2 MediaServer = new Product2();
    	MediaServer.Name = 'MediaServer';
    	MediaServer.RecordTypeId = testHardware;
    	pList.add(MediaServer);
    	Product2 MSLicense = new Product2();
    	MSLicense.Name = 'MS License';
    	MSLicense.RecordTypeId = testIdentifier;
    	pList.add(MSLicense);
    	insert pList;
    	//Now Create the Asset Hierarchy, top down...
    	Asset Assetroot = new Asset();
    	Assetroot.Name = 'System Root Asset';
    	Assetroot.Product2Id = SystemRoot.Id;
    	Assetroot.AccountId = acct.Id;
    	insert Assetroot;
    	
    	List<Asset> asstList = new List<Asset>();
    	Asset Assetantenna = new Asset();
    	Assetantenna.Name = 'Antenna V3';
    	Assetantenna.Product2Id = Antenna.Id;
    	Assetantenna.Parent_Asset__c = Assetroot.Id;
    	Assetantenna.AccountId = acct.Id;
    	asstList.add(Assetantenna);
    	
    	Asset AssetICM = new Asset();
    	AssetICM.Name = 'ICM';
    	AssetICM.Product2Id = ICM.Id;
    	AssetICM.Parent_Asset__c = Assetroot.Id;
    	AssetICM.AccountId = acct.Id;
    	asstList.add(AssetICM);
    	
    	Asset AssetMS = new Asset();
    	AssetMS.Name = 'Media Server';
    	AssetMS.Product2Id = MediaServer.Id;
    	AssetMS.Parent_Asset__c = Assetroot.Id;
    	AssetMS.AccountId = acct.Id;
    	asstList.add(AssetMS);
    	
    	insert asstList;
    	asstList.clear();			//Reset...
    	
    	Asset AssetIPAddress = new Asset();
    	AssetIPAddress.Name = 'IP Address';
    	AssetIPAddress.Product2Id = IPAddress.Id;
    	AssetIPAddress.Parent_Asset__c = AssetICM.Id;
    	AssetIPAddress.AccountId = acct.Id;
    	asstList.add(AssetIPAddress);
    	
    	Asset AssetswSerial= new Asset();
    	AssetswSerial.Name = 'CBX LICENSE';
    	AssetswSerial.Product2Id = swSerial.Id;
    	AssetswSerial.Parent_Asset__c = AssetICM.Id;
    	AssetswSerial.AccountId = acct.Id;
    	asstList.add(AssetswSerial);
    	
    	Asset AssetMSLic= new Asset();
    	AssetMSLic.Name = 'MS LICENSE';
    	AssetMSLic.Product2Id = MSLicense.Id;
    	AssetMSLic.Parent_Asset__c = AssetMS.Id;
    	AssetMSLic.AccountId = acct.Id;
    	asstList.add(AssetMSLic);
    	
    	insert asstList;
    }
    
    public static void createTestingAccounts(){
    	List<Account> acctList = new List<Account>();
    	Account a1 = new Account();
    	a1.Name = 'Direct Customer';
    	a1.RecordTypeId = testDirect;
    	a1.Custom_Call_Acct_ID__c = '99999';
    	a1.Revenue_Category__c = 'VSAT';
    	a1.Account_Effective_Date__c = date.today();
    	insert a1;
    	//acctList.add(a1);
    	Account a2 = new Account();
    	a2.Name = 'Hierarchy Test Platform';
    	a2.RecordTypeId = testPlatform;
    	a2.ParentId = a1.Id;
    	insert a2;
    	//acctList.add(a2);
    	//insert acctList;
    }
}