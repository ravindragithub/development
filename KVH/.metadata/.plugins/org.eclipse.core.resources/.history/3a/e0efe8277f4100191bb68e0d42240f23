@isTest
public class test_IPMCAssetFlowController {
	
	static testMethod void test_AssetFlowController() {
		//AssetHierarchyTestData.createTestHierarchy();
		AssetTestData.createTestingAccounts();
        Account aPlatform = [SELECT Id, Name FROM Account WHERE Name = 'Hierarchy Test Platform'];
        AssetTestData.createTestingHierarchy(aPlatform);
		test.startTest(); 
		Asset topAsset      = [ Select id, name from Asset where name = 'System Root Asset' limit 1 ];
		Asset mockV3		= [ Select id, parent_Asset__c, name from Asset where name = 'Antenna V3' limit 1 ];
        Asset mockServer   = [ Select id, parent_Asset__c, name from Asset where name = 'ICM' limit 1 ];
        //Asset bottomAsset   = [ Select id, parent_Asset__c, name from Asset where name = 'AssetHierarchyTest9' limit 1 ];
        //Asset[] AssetList   = [ Select id, parent_Asset__c, name from Asset where name like 'AssetHierarchyTest%' ];
        //Need to tweak a couple of these Assets... Create a couple of the Right kinds of Products, an base the Assets on those...
        Product2 mockCBX = new Product2(name = 'CBX LICENSE', Airtime_Group__c = 'CBX', ProductCode = 'CBX LICENSE');
        Product2 mockAntenna = new Product2(name = 'V3 Antenna', Airtime_Group__c = 'V3', ProductCode = '02-0000');
        Database.SaveResult sr = Database.insert(mockCBX);	//use database method to get ID to plug into Asset
		mockServer.Product2Id = sr.Id;
		update mockServer;
		sr = Database.insert(mockAntenna);
		mockV3.Product2Id = sr.Id;
		update mockV3;
		system.debug(mockServer);
		mockServer   = [ Select id, parent_Asset__c, name, Product2Id, Product2.Airtime_Group__c from Asset where name = 'ICM' limit 1 ];
		mockV3		 = [ Select id, parent_Asset__c, name, Product2Id, Product2.Airtime_Group__c from Asset where name = 'Antenna V3' limit 1 ];
		system.AssertEquals('CBX', mockServer.Product2.Airtime_Group__c);
		system.AssertEquals('V3', mockV3.Product2.Airtime_Group__c);
		
		createTestIPMCBundle();
		
        
        
        PageReference IPMCAssetFlow = Page.IPMCAssetFlow;
        Test.setCurrentPage( IPMCAssetFlow );
        ApexPages.currentPage().getParameters().put( 'Asset', mockServer.id );
        

		
        // Instanciate Controller
        IPMCAssetFlowController controller = new IPMCAssetFlowController();
        //test GetTopElement method
        String objId = controller.GetTopElement(mockServer.id);
        system.AssertEquals(topAsset.ID, objId);
        //test autorun
        IPMCAssetFlow = controller.autoRun();
        
		Map<String, Integer> testMap = controller.getInstalledAntennaTypes();
        system.AssertEquals(1,testMap.get('V3'));
        //system.AssertEquals(1,testMap.get('CBX'));
        
        IPMCAssetFlow = controller.getCBXDetails();
        System.assertEquals(false, controller.getRequiresReview());
        System.assertEquals(false, controller.getAcctRequiresReview());		//null pointer... platform needs parent acct with CC acct#
        
        List<AssetStructureEngine.AssetStructureMap> testHierarchy = new List<AssetStructureEngine.AssetStructureMap>();
        testHierarchy = controller.getHierarchy();
        
        Asset testAsset = new Asset();
        testAsset = controller.getServerToActivate();
        
        testAsset = controller.getSystemID();
        system.AssertEquals('System Root Asset', testAsset.name);
        
        test.stopTest();
	}
	static void createTestIPMCBundle() {
		//Create the right Product Family
		//KVH_Product_Family__c KPF = new KVH_Product_Family__c();
		//KPF.Name = 'IPMC Package';
		//insert KPF;
		KVH_Product_Family__c KPF = [SELECT Id, Name FROM KVH_Product_Family__c LIMIT 1];
		//Create a couple of Product2s
		Product2 testBundle1 = new Product2(name = 'testBundle1', Airtime_Group__c = 'CBX,V3', ProductCode = 'testBundle1', KVH_Product_Family__c = KPF.Id);
		Product2 testBundle2 = new Product2(name = 'testBundle2', Airtime_Group__c = 'CBX,V3', ProductCode = 'testBundle2', KVH_Product_Family__c = KPF.Id);
		insert testBundle1;
		insert testBundle2;
		
	}
	static testMethod void testContract() {
		IPMCAssetFlowController ctrl = new IPMCAssetFlowController();
		Contract k = new Contract();
		Contract k2 = new Contract();
		k.ContractTerm = 19;
		ctrl.setexistingContract(k);
		k2 = ctrl.getexistingContract();
		system.assertEquals(19, k2.ContractTerm);
	} 
	static testMethod void testActivateAndMapButton(){
		IPMCAssetFlowController ctrl = new IPMCAssetFlowController();
		ctrl.SelectedSRVR = '123456';	//easy.., but generating a test Asset not so much...
		//to create a test Asset, we need Product + Account. For this Class we also need a parent Account
		Product2 mockCBX = new Product2(name = 'CBX LICENSE', Airtime_Group__c = 'CBX', ProductCode = 'CBX LICENSE');
		insert mockCBX;
		mockCBX = [SELECT ID, Name FROM Product2 WHERE Name = 'CBX LICENSE' LIMIT 1];

		Account mockAcctParent = new Account(name = 'test Parent Acct', Custom_Call_Acct_ID__c = '1234', Account_Effective_Date__c = date.today(),
											 Account_Type__c = 'Customer', Revenue_Category__c = 'VSAT');
		insert mockAcctParent;
		mockAcctParent = [SELECT Id, Name, Custom_Call_Acct_ID__c FROM Account WHERE Name = 'test Parent Acct'];
		
		Account mockAcct = new Account(name= 'test Asset Acct', Parent = mockAcctParent);
		insert mockAcct;
		mockAcct = [SELECT Id, Name FROM Account WHERE Name = 'test Asset Acct'];
		
		Asset mockAsset = new Asset(name = 'mockAsset', AccountId=mockAcct.Id, Product2Id=mockCBX.Id);
		insert mockAsset;		//use database method to get ID to plug into Asset
		mockAsset = [SELECT Id, Name, AccountId, Product2Id FROM Asset WHERE Name = 'mockAsset'];
		
		
		ctrl.test_setSystemID(mockAsset.ID);
		system.assertEquals(mockAsset.Id, ctrl.getSystemID().Id);
		ctrl.test_setServerToActivate(mockAsset.ID);
		system.assertEquals(mockAsset.Id, ctrl.getServerToActivate().Id);
		
		pageReference Service_mappingPage = page.IPMC_Service_mapping;
		Service_mappingPage = ctrl.ActivateAndMap();
		system.assertEquals('123456',Service_mappingPage.getParameters().get('SRVR'));

	}
}