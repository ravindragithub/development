public class AssetTriggerStatics {

	public static map<Id, AssetStructureEngine.AssetStructureMap[]> HierarchiesMap = new map<Id, AssetStructureEngine.AssetStructureMap[]>();
	public static map<Id, Asset> RootsMap = new map<Id, Asset>();
	
	public static void addRootToMap(List<Asset> assetList){
		Asset RootAsset = new Asset();												//Placeholder for Root Asset (maybe this becomes another static variable...)
		for (Asset A : assetList){													//Loop through the list
			if (A.Parent_Asset__c != null){											//if It's got a Parent Asset...
				system.debug('Adding : ' + A.Name + ' to Roots List as child!...');
				RootAsset = AssetStructureEngine.GetRootAsset(A.Parent_Asset__c);	//Find the Root Asset based on Parent Asset Id..
				RootsMap.Put(A.Id, RootAsset);										//And add it to the Map.
			} else {																//IF it's a Root Asset instead.....
				system.debug('Adding : ' + A.Name + ' to Roots List as root!...');
				RootsMap.Put(A.Id, A);												//Just add it to the Map.
			}
		}
	}
	
	public static void addHierarchyToMap(List<Asset> assetList){
		List<AssetStructureEngine.AssetStructureMap> Hierarchy  = new List<AssetStructureEngine.AssetStructureMap>();			//Placeholder for Asset Hierarchy...
		for (Asset A : assetList){															//should probably make sure that trigger.new contains Assets!!
			if(RootsMap.containsKey(A.Id) != false){										//If the assets Root is not already in the Map...
				system.debug('Adding : ' + A.Name + ' to Hierarchies List...');
				Hierarchy = AssetStructureEngine.getAssetStructure(RootsMap.get(A.Id).Id);	//Get the Hierarchy based on the Asset's root Asset....
				system.debug('Hierarchy size ' + Hierarchy.size());
				system.debug('Hierarchy Summary for Asset with Id : ' + A.Id + ' Named : ' + A.Name);
				for (AssetStructureEngine.AssetStructureMap h : Hierarchy){
					system.debug('Asset Named : ' + h.Asset.Name + ' at node : ' + h.NodeId);
				}
				HierarchiesMap.Put(A.Id, Hierarchy.clone());								//And add a *COPY* to the map DO NOT step on the static list!
				system.debug('Mapped ' + A.Id + ' to : ' + HierarchiesMap.get(A.id));
				system.debug('Hierarchies Map size : ' + HierarchiesMap.size() + ' Keys : ' + HierarchiesMap.keyset());
			}
			Hierarchy.clear();					//Reinitialize...
		}
	}
}