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
private class test_TransmissionServiceCallouts {
	static string ProductionOrgId = '00D30000000pQ0zEAE';	//Like *REALLY* Static!
	static string baseURL;
	@testSetup static void setupTestData(){
        //We need to setup the Custom Setting here... 
        string orgId = ProductionOrgId; //NOT UserInfo.getOrganizationId(); In test Class :(
        Production_Org_Ids__c mySetting = Production_Org_Ids__c.getOrgDefaults();
        mySetting.Org_Id_18_char__c = orgId;
        mySetting.Org_Id_15_char__c = orgId.left(15);
        upsert mySetting;
    }
    static testMethod void testSetupData(){
        //use this method to validate that you have test data setup correctly
        string orgId = ProductionOrgId;
        Production_Org_Ids__c mySetting = Production_Org_Ids__c.getOrgDefaults();
        system.assertEquals(orgId, mySetting.Org_Id_18_char__c);
    }
	public test_TransmissionServiceCallouts(){				//no parameter constructor
		system.debug('Invoking Constructor....');
	}
	static string getBaseURL(){
        if(UserInfo.getOrganizationId() == ProductionOrgId){
            baseURL = 'http://199.244.86.5:9081/ts';        //Production instance :9081 is unencrypted server... 
        } else {
            baseURL = 'http://199.244.86.5:9082/ts';        //Development instance :9082 is unencrypted server... 
        }
        return baseURL;
    }
	/* Test Methods, one per TS Callout */
    private static testmethod void testPing() {
    	//Test data not required.....
		HttpCalloutMock mockPing = Mock_tsPing_setup(getBaseURL());	//setup mock Callouts....
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, mockPing);	//must set Mock AFTER Test.startTest()
		system.debug('Starting tsPing Unit Test....');
		TransmissionServiceCallouts TSC = new TransmissionServiceCallouts();	//make the Callout....
		TransmissionServiceCallouts rc = TSC.ping();							//ping does not return a resultCode...
		system.debug(rc);
		system.assertEquals('key', rc.key1);
		system.assertEquals('val', rc.val1);
		test.stopTest();
	}
	private static testmethod void testSiteActivateFAIL() {
		loadTestData();													//load all test data first
		HttpCalloutMock mockSiteActivate = Mock_SiteActivate_setup(getBaseURL());	//setup mock Callouts....
		test.startTest();
		Test.setMock(HttpCalloutMock.class, mockSiteActivate);			//must set Mock AFTER Test.startTest()
		//instanciate a new TSCallout class which includes "resultCode" inner Class
		TransmissionServiceCallouts TSC = new TransmissionServiceCallouts();
		TransmissionServiceCallouts.resultCode rc = new TransmissionServiceCallouts.resultCode(null, null);	//TODO instanciate without params...
		KenCast_License__c KCLread = new KenCast_License__c();			//Instanciate a License...
		KCLread = TSC.getLicense();										//Claim a License...
		Asset toActivate = new Asset();									//Instanciate an Asset
		toActivate = [SELECT id, Name FROM Asset WHERE Name='1401U9999' LIMIT 1];	//This is our Asset from Test Data
		system.assertEquals(170612, KCLread.Site_ID__c); 				//hard coded Site ID (see getXML() below...)
		system.debug(KCLread.Site_ID__c);
		//The following line makes the Mock Callout with the require parameters and collects the returnCode
		rc = TSC.SiteActivate(toActivate.Name, KCLread.Site_ID__c.intValue(), KCLread.License_File__c);
		system.debug(rc); 
		system.assertEquals(false, rc.success);			//our Mock Callout returns a failed response with exception message
		system.assertEquals('site does not exist', rc.exceptionMessage);
		test.stoptest();
	}
	private static testmethod void testSiteActivateSUCCESS() {
		loadTestData();													//load all test data first
		HttpCalloutMock mockSiteActivate = Mock_SiteActivateSuccess_setup(getBaseURL());	//setup mock Callouts....
		test.startTest();
		Test.setMock(HttpCalloutMock.class, mockSiteActivate);			//must set Mock AFTER Test.startTest()
		//instanciate a new TSCallout class which includes "resultCode" inner Class
		TransmissionServiceCallouts TSC = new TransmissionServiceCallouts();
		TransmissionServiceCallouts.resultCode rc = new TransmissionServiceCallouts.resultCode(null, null);	//TODO instanciate without params...
		KenCast_License__c KCLread = new KenCast_License__c();			//Instanciate a License...
		KCLread = TSC.getLicense();										//Claim a License...
		Asset toActivate = new Asset();									//Instanciate an Asset
		toActivate = [SELECT id, Name FROM Asset WHERE Name='1401U9999' LIMIT 1];	//This is our Asset from Test Data
		system.assertEquals(170612, KCLread.Site_ID__c); 				//hard coded Site ID (see getXML() below...)
		system.debug(KCLread.Site_ID__c);
		//The following line makes the Mock Callout with the require parameters and collects the returnCode
		rc = TSC.SiteActivate(toActivate.Name, KCLread.Site_ID__c.intValue(), KCLread.License_File__c);
		system.debug(rc); 
		system.assertEquals(true, rc.success);			//our Mock Callout returns a failed response with exception message
		system.assertEquals('', rc.exceptionMessage);
		test.stoptest();
	}
	private static testMethod void testSiteMapPkgKinds() {
		loadTestData();
		createTestPackage();												//load all test data first
		HttpCalloutMock mockSiteMapPkgKinds = Mock_SiteMapPkgKinds_setup(getBaseURL());	//setup mock Callouts....
		test.startTest();
		Test.setMock(HttpCalloutMock.class, mockSiteMapPkgKinds);		//must set Mock AFTER Test.startTest()
		Asset toMap = new Asset();										//Instanciate an Asset
		toMap = [SELECT id, Name FROM Asset WHERE Name='1401U9999' LIMIT 1];	//This is our Asset from Test Data
		List<String> PkgKnds2Map = new List<string>();		//Need a List of Strings for mapping....
		Product2 Bundle = [SELECT Id, Name FROM Product2 WHERE Name = 'IP-MobileCast Bronze' LIMIT 1];
		Package_Kinds_by_Product__c[] pkgknds = [SELECT Id, Name, Product__c, Package_Kind__c 
													FROM Package_Kinds_by_Product__c
													WHERE Product__c =: Bundle.Id];
		for (Package_Kinds_by_Product__c pk : pkgknds) {
			PkgKnds2Map.add(pk.Package_Kind__c);
		}
		system.debug(PkgKnds2Map);		//This is our list of strings...
		//instanciate a new TSCallout class which includes "resultCode" inner Class
		TransmissionServiceCallouts TSC = new TransmissionServiceCallouts();
		TransmissionServiceCallouts.resultCode rc = new TransmissionServiceCallouts.resultCode(null, null);	//TODO instnaciate without params
		rc = TSC.SiteMapPkgKinds(toMap.Name, PkgKnds2Map);
		system.debug(rc); 
		system.assertEquals(true, rc.success);			//our Mock Callout returns an OK response with exception message
		system.assertEquals('', rc.exceptionMessage);
		Test.stopTest();
    }
	private static testMethod void testSiteDeactivateFAIL() {
		loadTestData();														//load all test data first
		HttpCalloutMock mockSiteDeactivate = Mock_SiteDeactivate_setup(getBaseURL());	//setup mock Callouts....
		test.startTest();
		Test.setMock(HttpCalloutMock.class, mockSiteDeactivate);			//must set Mock AFTER Test.startTest()
		//instanciate a new TSCallout class which includes "resultCode" inner Class
		TransmissionServiceCallouts TSC = new TransmissionServiceCallouts();
		TransmissionServiceCallouts.resultCode rc = new TransmissionServiceCallouts.resultCode(null, null);	//TODO instanciate without params
		Asset toDeactivate = new Asset(Name='1402U9999');					//mock asset from Test Date
		system.debug(toDeactivate);
		//The following line makes the Mock Callout with the require parameters and collects the returnCode
		rc = TSC.SiteDeactivate(toDeactivate.Name);							//Asset.Name == SW serial number...
		system.debug(rc);
		system.assertEquals(false, rc.success);								//our Mock Callout returns a failed response with exception message
		system.assertEquals('MOCK msg...site does not exist', rc.exceptionMessage);
		test.stoptest();
	}
	
	private static testMethod void testSiteDeactivateSUCCESS() {
		loadTestData();														//load all test data first
		HttpCalloutMock mockSiteDeactivate = Mock_SiteDeactivateSuccess_setup(getBaseURL());	//setup mock Callouts....
		test.startTest();
		Test.setMock(HttpCalloutMock.class, mockSiteDeactivate);			//must set Mock AFTER Test.startTest()
		//instanciate a new TSCallout class which includes "resultCode" inner Class
		TransmissionServiceCallouts TSC = new TransmissionServiceCallouts();
		TransmissionServiceCallouts.resultCode rc = new TransmissionServiceCallouts.resultCode(null, null);	//TODO instanciate without params
		Asset toDeactivate = new Asset(Name='1402U9999');					//mock asset from Test Date
		system.debug(toDeactivate);
		//The following line makes the Mock Callout with the require parameters and collects the returnCode
		rc = TSC.SiteDeactivate(toDeactivate.Name);							//Asset.Name == SW serial number...
		system.debug(rc);
		system.assertEquals(true, rc.success);								//our Mock Callout returns a failed response with exception message
		system.assertEquals('', rc.exceptionMessage);
		test.stoptest();
	}	/* End of Test Methods */
	
	/*More tests for non-callout methods */
	/*private static testMethod void test_connectLicenseandAsset(){
		//Need an Asset (with Id), a License (with Id), and a resultCode (mock)
		loadTestData();														//load all test data first
		Asset a = [SELECT id, Name FROM Asset WHERE Name='1401U9999' LIMIT 1];
		
		
	}*/
	
	/* Setup Methods, one per unit test Class */
	private static HttpCalloutMock Mock_tsPing_setup(string testURL) {				//sets up a mock response for the tsPing Callout...
		SingleRequestMock fakePingResp = new SingleRequestMock(200, 'Complete', '{"key1":"key","val1":"val"}', null);
		Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
		system.debug('Base URL : ' + testURL);
		endpoint2TestResp.put(testURL+'/ping',fakePingResp);
		HttpCalloutMock tsPingCalloutMock = new MultiRequestMock(endpoint2TestResp);
		return tsPingCalloutMock;
	}
	private static HttpCalloutMock Mock_SiteActivate_setup(string testURL) {		//sets up a mock response for a failed SiteActivate Callout...
		SingleRequestMock fakeSiteActivateResp = new SingleRequestMock(200,'Complete',
												'{"resultCode":{"success":false,"exceptionMessage":"site does not exist"}}',null);
		Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
		system.debug('Base URL : ' + testURL);
		endpoint2TestResp.put(testURL+'/SiteActivate',fakeSiteActivateResp);
		HttpCalloutMock SiteActivateCalloutMock = new MultiRequestMock(endpoint2TestResp);
		return SiteActivateCalloutMock;
	}
	private static HttpCalloutMock Mock_SiteActivateSuccess_setup(string testURL) {		//sets up a mock response for a successful SiteActivate Callout...
		SingleRequestMock fakeSiteActivateResp = new SingleRequestMock(200,'Complete',
												'{"resultCode":{"success":true,"exceptionMessage":""}}',null);
		Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
		system.debug('Base URL : ' + testURL);
		endpoint2TestResp.put(testURL+'/SiteActivate',fakeSiteActivateResp);
		HttpCalloutMock SiteActivateCalloutMock = new MultiRequestMock(endpoint2TestResp);
		return SiteActivateCalloutMock;
	}
	private static HttpCalloutMock Mock_SiteMapPkgKinds_setup(string testURL) {		//sets up a mock response for the SiteActivate Callout...
		SingleRequestMock fakeSiteMapPkgKindsResp = new SingleRequestMock(200,'Complete',
												'{"resultCode":{"success":true,"exceptionMessage":""}}',null);
		Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
		system.debug('Base URL : ' + testURL);
		endpoint2TestResp.put(testURL+'/SiteMapPkgKinds',fakeSiteMapPkgKindsResp);
		HttpCalloutMock SiteMapPkgKindsCalloutMock = new MultiRequestMock(endpoint2TestResp);
		return SiteMapPkgKindsCalloutMock;
	}
	private static HttpCalloutMock Mock_SiteDeactivate_setup(string testURL) {	//sets up a mock response for the SiteDeactivate Callout...
		SingleRequestMock fakeSiteDeactivateResp = new SingleRequestMock(200, 'Complete',
													'{"resultCode":{"success":false,"exceptionMessage":"MOCK msg...site does not exist"}}', null);
		Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
		system.debug('Base URL : ' + testURL);
		endpoint2TestResp.put(testURL+'/SiteDeactivate',fakeSiteDeactivateResp);
		HttpCalloutMock SiteDeactivateCalloutMock = new MultiRequestMock(endpoint2TestResp);
		return SiteDeactivateCalloutMock;
	}
	private static HttpCalloutMock Mock_SiteDeactivateSuccess_setup(string testURL) {	//sets up a mock response for the SiteDeactivate Callout...
		SingleRequestMock fakeSiteDeactivateResp = new SingleRequestMock(200, 'Complete',
													'{"resultCode":{"success":true,"exceptionMessage":""}}', null);
		Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
		system.debug('Base URL : ' + testURL);
		endpoint2TestResp.put(testURL+'/SiteDeactivate',fakeSiteDeactivateResp);
		HttpCalloutMock SiteDeactivateCalloutMock = new MultiRequestMock(endpoint2TestResp);
		return SiteDeactivateCalloutMock;
	} /* End Setup Methods */

	/* Utility Methods... used to load test data etc.... */
	
	static void loadTestData(){	//test data...
		//?? TransmissionServiceCallouts TSC = new TransmissionServiceCallouts();
		Account WriteAcct = makeMockAcct();	//need a test Account
		Product2 prod = new Product2(Name='CBX LICENSE');	//need a product...
		insert prod;
		prod = [SELECT id, Name FROM Product2 WHERE Name = 'CBX LICENSE' LIMIT 1];
		system.assertEquals('CBX LICENSE', prod.Name);
		//need a test Asset to Activate
		Asset toActivate = new Asset(Name='1401U9999', SerialNumber='1401U9999'); //mock asset
		toActivate.AccountId = WriteAcct.id;
		toActivate.Product2Id = prod.Id;
		insert toActivate; 			//kind of real now...
		toActivate = [SELECT id, Name FROM Asset WHERE Name='1401U9999' LIMIT 1];
		system.debug(toActivate);

		//instanciate a new KenCast License
		KenCast_License__c KCLread = new KenCast_License__c();
		KCLread.License_File__c = getXml();
		//KCLread.Issued_to_Asset__c = toActivate.id;	//This allows the test to pass...
		insert KCLread;
		//KCLread = TSC.issueLicense(toActivate.id);	 
		system.debug(KCLRead);
		//system.assertEquals(toActivate.id, KCLRead.Issued_to_Asset__c);
		toActivate = [SELECT id, Name, IPMC_KenCast_SiteID__c FROM Asset WHERE Name='1401U9999' LIMIT 1];
		//system.assertEquals(string.valueOf(KCLRead.Site_ID__c), toActivate.IPMC_KenCast_SiteID__c);
		//need a test Asset to DE-Activate
		Asset toDEActivate = new Asset(Name='1402U9999', SerialNumber='1402U9999', IPMC_KenCast_SiteID__c = '170612'); //mock asset
		toDEActivate.AccountId = WriteAcct.id;
		toDEActivate.Product2Id = prod.Id;
		insert toDEActivate; 			//kind of real now...
		toDEActivate = [SELECT id, Name FROM Asset WHERE Name='1402U9999' LIMIT 1];
		system.debug(toDEActivate);
	}
	static void createTestPackage() {
		KVH_Product_Family__c fam = new KVH_Product_Family__c();
		fam.Name = 'IPMC Package';
		insert fam;
		fam = [SELECT Id, Name FROM KVH_Product_Family__c];
		Product2 prod2 = new Product2(Name='IP-MobileCast Bronze', KVH_Product_Family__c=fam.Id);		//need a product...
		insert prod2;
		prod2 = [SELECT id, Name from Product2 WHERE Name = 'IP-MobileCast Bronze' LIMIT 1];	
		system.assertEquals('IP-MobileCast Bronze', prod2.Name);		//got a Product!
		
		List<String> pkgKindNames = new List<String> {'kvh.vod.tv.series.bronze',		//Need some Package Kinds...
										'kvh.vod.movie.bronze',
										'kvh.print.news.special_interest',
										'kvh.print.news.international',
										'kvh.vod.music.muzo',
										'kvh.vod.movie.trailer.bronze'};
		List<IPMC_Package_Kinds__c> testPkgKinds = new List<IPMC_Package_Kinds__c>();
		for (string s : PkgKindNames) {
			IPMC_Package_Kinds__c pk = new IPMC_Package_Kinds__c();
			pk.PackageKind__c = s;
			testPkgKinds.add(pk);
		}
		insert testPkgKinds;
		testPkgKinds = [SELECT id, Name, PackageKind__c FROM IPMC_Package_Kinds__c];	//got some Package Kinds!
		
		List<Package_Kinds_by_Product__c> Bundle = new List<Package_Kinds_by_Product__c>();	//Need a Bundle...
		for (IPMC_Package_Kinds__c pk : testPkgKinds) {
			Package_Kinds_by_Product__c Prod_vs_pkgKind = new Package_Kinds_by_Product__c();
			Prod_vs_pkgKind.Product__c = prod2.id;
			Prod_vs_pkgKind.IPMC_Package_Kind__c = pk.Id;
			Bundle.add(Prod_vs_pkgKind);
		}
		insert Bundle;
		Bundle = [SELECT Id, Product__c, IPMC_Package_Kind__c, Package_Kind__c FROM Package_Kinds_by_Product__c];	//got a Bundle!
	}
	static String getXml() { //creates a mock KenCast License
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
		return mockKCLicense;
	}
	static Account makeMockAcct() {
		Account WriteAcct = new Account();
		WriteAcct.Name = 'Positive Flag';
		WriteAcct.Account_Type__c = 'Corporate';
		WriteAcct.Custom_Call_Acct_ID__c = '998';
		WriteAcct.Account_Effective_Date__c = Date.today();
		WriteAcct.Revenue_Category__c = 'VSAT';
		WriteAcct.BillingCountry = 'Italy';
		WriteAcct.Send_to_myKVH_Physical__c = false;	//should change to true
		WriteAcct.Account_Status__c = 'Active';
		Database.Saveresult Parent1 = Database.insert(WriteAcct);
		WriteAcct = [SELECT Id, Name FROM Account WHERE Name = 'Positive Flag' LIMIT 1];
		system.debug(WriteAcct);
		return WriteAcct;
	} /* End of Utility Methods */
}