@isTest
private class testAssetHierarchy {

	static testMethod void testAssetHierarchy(){
	//Start here! and follow logic converting Account to Asset as we go!
		//AssetHierarchyTestData.createTestHierarchy();
		//AssetTestData.createTestingAccounts();
		//Account aPlatform = [SELECT Id, Name FROM Account WHERE Name = 'Hierarchy Test Platform'];
		Account aPlatform = new Account(name = 'testAccount');
		insert aPlatform;
		AssetTestData.createTestingHierarchy(aPlatform);
		
		List<Asset> aList = new List<Asset>();
		aList = [SELECT id, AccountID, parent_Asset__c, name FROM Asset WHERE AccountId =: aPlatform.Id];
		
        //Asset topAsset      = [ Select id, name from Asset where name = 'AssetHierarchyTest0' limit 1 ];
        //Asset middleAsset   = [ Select id, parent_Asset__c, name from Asset where name = 'AssetHierarchyTest4' limit 1 ];
        //Asset bottomAsset   = [ Select id, parent_Asset__c, name from Asset where name = 'AssetHierarchyTest9' limit 1 ];
        //Asset[] AssetList   = [ Select id, parent_Asset__c, name from Asset where name like 'AssetHierarchyTest%' ];
        Asset topAsset = new Asset();
        Asset middleAsset = new Asset();
        Asset bottomAsset = new Asset();
        Map<String, Asset> assetMap = new Map<String, Asset>();
        
        for (Asset a : aList){				//Identify Top Asset...
        	if (a.Parent_Asset__c == null){
        		topAsset = a;
        	}
        }
        for (Asset a : aList){				//Identify Middle Asset
        	if(a.Parent_Asset__c == topAsset.Id && middleAsset == null){
        		middleAsset = a;
        	}
        }
        for (Asset a : aList){				//Identify Bottom Asset
        	if(a.Parent_Asset__c == middleAsset.Id && bottomAsset == null){
        		bottomAsset = a;
        	}
        }
        PageReference AssetHierarchyPage = Page.AssetHierarchyPage;
        Test.setCurrentPage( AssetHierarchyPage );
        ApexPages.currentPage().getParameters().put( 'id', topAsset.id );
		
        // Instanciate Controller
        AssetStructure controller = new AssetStructure();
        test.startTest();
        // Call Methodes for top account
        controller.setcurrentId( null );
        AssetStructure.ObjectStructureMap[] smt1 = new AssetStructure.ObjectStructureMap[]{};
        smt1 = controller.getObjectStructure();
        System.Assert( smt1.size() > 0, 'Test failed at Top account, no Id' );
		
        controller.setcurrentId( String.valueOf( topAsset.id ) );
        AssetStructure.ObjectStructureMap[] smt2 = new AssetStructure.ObjectStructureMap[]{};
        smt2 = controller.getObjectStructure();
        System.Assert( smt2.size() > 0, 'Test failed at Top account, with Id: '+smt2.size() );
		
        //Call ObjectStructureMap methodes
        smt2[0].setnodeId( '1234567890' );
        smt2[0].setlevelFlag( true );
        smt2[0].setlcloseFlag( false );
        smt2[0].setnodeType( 'parent' );
        smt2[0].setcurrentNode( false );
        smt2[0].setasset( topAsset );
        
        String nodeId       = smt2[0].getnodeId();
        Boolean[] levelFlag = smt2[0].getlevelFlag();
        Boolean[] closeFlag = smt2[0].getcloseFlag();
        String nodeType     = smt2[0].getnodeType();
        Boolean currentName = smt2[0].getcurrentNode();
        Asset smbAsset  = smt2[0].getasset();
		
        // Call Methodes for middle account
        controller.setcurrentId( String.valueOf( middleAsset.id ) );
        AssetStructure.ObjectStructureMap[] smm = new AssetStructure.ObjectStructureMap[]{};
        smm = controller.getObjectStructure();
        System.Assert( smm.size() > 0, 'Test failed at middle account' );
		
        // Call Methodes for bottom account
        controller.setcurrentId( String.valueOf( bottomAsset.id ) );
        AssetStructure.ObjectStructureMap[] smb = new AssetStructure.ObjectStructureMap[]{};
        smb = controller.getObjectStructure();
        System.Assert( smb.size() > 0, 'Test failed at top account' );
        
        
        test.stopTest();
        
    }
	
	static testMethod void testAssetStructureEngine(){
		
		//AssetHierarchyTestData.createTestHierarchy();
		//AssetTestData.createTestingAccounts();
		Account aPlatform = new Account(name = 'testAccount');
		insert aPlatform;
		AssetTestData.createTestingHierarchy(aPlatform);
		
		List<Asset> aList = new List<Asset>();
		aList = [SELECT id, AccountID, parent_Asset__c, name FROM Asset WHERE AccountId =: aPlatform.Id];
		
        //Asset topAsset      = [ Select id, name from Asset where name = 'AssetHierarchyTest0' limit 1 ];
        //Asset middleAsset   = [ Select id, parent_Asset__c, name from Asset where name = 'AssetHierarchyTest4' limit 1 ];
        //Asset bottomAsset   = [ Select id, parent_Asset__c, name from Asset where name = 'AssetHierarchyTest9' limit 1 ];
        //Asset[] AssetList   = [ Select id, parent_Asset__c, name from Asset where name like 'AssetHierarchyTest%' ];
        Asset topAsset = new Asset();
        Asset middleAsset = new Asset();
        Asset bottomAsset = new Asset();
        Map<String, Asset> assetMap = new Map<String, Asset>();
        
        for (Asset a : aList){				//Identify Top Asset...
        	if (a.Parent_Asset__c == null){
        		topAsset = a;
        	}
        }
        for (Asset a : aList){				//Identify Middle Asset
        	if(a.Parent_Asset__c == topAsset.Id && middleAsset == null){
        		middleAsset = a;
        	}
        }
        for (Asset a : aList){				//Identify Bottom Asset
        	if(a.Parent_Asset__c == middleAsset.Id && bottomAsset == null){
        		bottomAsset = a;
        	}
        }
		test.startTest();
        // Instanciate Controller for Engine
        AssetStructureEngine ENGcontroller = new AssetStructureEngine();
        
        // Call Methodes for top account
        //ENGcontroller.setcurrentId( null );
        AssetStructureEngine.AssetStructureMap[] esmt1 = new AssetStructureEngine.AssetStructureMap[]{};
        esmt1 = AssetStructureEngine.getAssetStructure( String.valueOf( topAsset.id ));
        System.Assert( esmt1.size() > 0, 'Test failed at Top account, no Id' );
		
        //ENGcontroller.setcurrentId( String.valueOf( topAsset.id ) );
        AssetStructureEngine.AssetStructureMap[] esmt2 = new AssetStructureEngine.AssetStructureMap[]{};
        esmt2 = AssetStructureEngine.getAssetStructure( String.valueOf( topAsset.id ));
        System.Assert( esmt2.size() > 0, 'Test failed at Top account, with Id: '+esmt2.size() );
		
        //Call ObjectStructureMap methodes
        esmt2[0].setnodeId( '1234567890' );
        esmt2[0].setlevelFlag( true );
        esmt2[0].setlcloseFlag( false );
        esmt2[0].setnodeType( 'parent' );
        esmt2[0].setcurrentNode( false );
        esmt2[0].setasset( topAsset );
        
        String enodeId       = esmt2[0].getnodeId();
        Boolean[] elevelFlag = esmt2[0].getlevelFlag();
        Boolean[] ecloseFlag = esmt2[0].getcloseFlag();
        String enodeType     = esmt2[0].getnodeType();
        Boolean ecurrentName = esmt2[0].getcurrentNode();
        Asset esmbAsset  = esmt2[0].getasset();
        		
        // Call Methodes for middle account
        //controller.setcurrentId( String.valueOf( middleAsset.id ) );
        /*AssetStructureEngine.AssetStructureMap[] esmm = new AssetStructureEngine.AssetStructureMap[]{};
        esmm = AssetStructureEngine.getAssetStructure(String.valueOf( middleAsset.id ));
        System.Assert( esmm.size() > 0, 'Test failed at middle account' );
		*/
		
        // Call Methodes for bottom account
        //controller.setcurrentId( String.valueOf( bottomAsset.id ) );
        /*AssetStructureEngine.AssetStructureMap[] esmb = new AssetStructureEngine.AssetStructureMap[]{};
        esmb = AssetStructureEngine.getAssetStructure(String.valueOf( bottomAsset.id ));
        System.Assert( esmb.size() > 0, 'Test failed at bottom account' );
        */
	}
}