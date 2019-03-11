/***********************************************************************************************************************
 Name: BundlerAppUITest 
 Copyright � 2014 KVH Industries | Salesforce Instance : 
========================================================================================================================
 Purpose: This is used to test "BundlerAppUI" class 
------------------------------------------------------------------------------------------------------------------------
 Utilized in(Called in):
-----------------------
                                           
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                        
------------------------------------------------------------------------------------------------------------------------
 VERSION    AUTHOR              DATE             DETAIL                                Mercury Request #
------------------------------------------------------------------------------------------------------------------------
   1.0     Gopi Kishore. K      02/06/2014       Initial Development                                   
   1.1		John Thompson		10/23/2014		refactored for improved coverage
***********************************************************************************************************************/
@isTest

private class BundlerAppUITest {
	
	static testMethod void BundlerAppUI() {
		/*Arrange*/
		test.StartTest();
		Integer RecordVolume = 20;		//Number of records to flush through test, minimum == 3
		KVH_Product_Family__c IPMC = new KVH_Product_Family__c();						//Need the appropriate KVH Product Family to make the IPMC Utilities Class work
		IPMC.Name = 'IPMC Package';
		insert IPMC;
		
		List<Product2> ProdList = new List<Product2>();									//Need some IPMC PRoducts
		for (integer i=0; i<RecordVolume; i++){
			product2 newProduct = new product2();
			newProduct.name = 'test Product' + string.valueOf(i);
			newProduct.KVH_Product_Family__c = IPMC.Id;
			newProduct.IsActive = true;
			ProdList.add(newProduct);
		}
		insert ProdList;

		List<IPMC_Package_Kinds__c> PkgKindList = new List<IPMC_Package_Kinds__c>();	//Need some Package Kinds
		for (integer i=0; i<RecordVolume; i++){
			IPMC_Package_Kinds__c pk = new IPMC_Package_Kinds__c();
			pk.PackageKind__c = 'Unique PackageName' + string.valueOf(i);
			pk.Status__c = 'Active';													//Added a status field, Bundler App filters based on value
			PkgKindList.add(pk);
		}
		insert PkgKindList;

		Package_Kinds_by_Product__c packageKinds = new Package_Kinds_by_Product__c();	//Create one Bundle...
		packageKinds.Product__c = ProdList[0].id;
		packageKinds.IPMC_Package_Kind__c = PkgKindList[0].id;
		system.debug('inserted PkgKind x Product: ' + packageKinds);
		insert packageKinds;
		List<Package_Kinds_by_Product__c > BundleList = new List<Package_Kinds_by_Product__c >();
		BundleList = [SELECT Id, Product__r.Name, IPMC_Package_Kind__r.Name FROM Package_Kinds_by_Product__c];
		system.assertEquals(1, BundleList.Size());			//There should be only one unless other Unit Tests are creating records....

		/*Act*/
		ApexPages.StandardController controller = new ApexPages.StandardController(ProdList[0]);
		PageReference pgRef = Page.BundlerAppUI; 
		Test.setCurrentPage(pgRef); 
		ApexPages.currentPage().getParameters().put('id', ProdList[0].id);
		BundlerAppUI BAUI = new BundlerAppUI(controller);
		/*Assert*/
		List<SelectOption> SelectList = BAUI.getIPMCProducts();
		system.assertEquals(RecordVolume + 1, SelectList.size());	//we add a '- NONE -' value to the list...
		BAUI.populatePackageKinds();
		system.assertEquals(RecordVolume, BAUI.AllValuesForColumns.size());
		BAUI.AllValuesForColumns[0].ValueBoolean = false;
		BAUI.AllValuesForColumns[1].ValueBoolean = true;
		BAUI.AllValuesForColumns[2].ValueBoolean = true;
		BAUI.SaveWithSelected();
		
		BundleList.clear();									//reset
		BundleList = [SELECT Id, Product__r.Name, IPMC_Package_Kind__r.Name FROM Package_Kinds_by_Product__c];
		system.assertEquals(2, BundleList.Size());
		
		test.StopTest();
	}
}