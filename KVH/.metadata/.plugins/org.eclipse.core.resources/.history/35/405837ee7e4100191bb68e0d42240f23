public class AssetBeforeDeleteTriggerHandler extends TriggerHandlerBase{
	
	public override void mainEntry(TriggerParameters tp){
		system.debug('Entering AssetBeforeDeleteTriggerHandler.mainEntry....'); 
		//process((List<Asset>)tp.newList);			//Nothing to Process....
		removeFromMyKVH((List<Asset>)tp.oldList);	//type conversion required....
	}
	
	private static void process(List<Asset> listNewAssets){
	
	}

	public override void inProgressEntry(TriggerParameters tp) {
		system.debug('Entering AssetBeforeDeleteTriggerHandler.inProgressEntry....');
		system.debug('This is an example for reentrant code...');
	}
	
	private void removeFromMyKVH(List<Asset> AssetsToDelete){
		//Some Deleted Assets need to be added to myKVH Deleted Records...
		List<myKVH_Deleted_Records__c> DEL_Assets = new List<myKVH_Deleted_Records__c>();
		//Need to make a list of the assets to add to myKVH_Deleted_Records__c...
		myKVH_Deleted_Records__c DEL_Obj = new myKVH_Deleted_Records__c();
		//and we need an instance of a single Deleted Object....
		system.debug(AssetsToDelete.size());	//how big is the list from the trigger?
		//The following SOQL needs to happen in the *BEFORE* context...
		//...that is *BEFORE* the record is deleted we need to capture the FCP Element Type!
		for (Asset a : [SELECT ID, Name, Product2.KVH_Product_Family__r.FCP_Element_Type__c
						FROM Asset
						WHERE ID IN :AssetsToDelete]){
			//let's just report the FCP Element Type here before any conditional execution...
			system.debug(a.name+' '+a.Product2.KVH_Product_Family__r.FCP_Element_Type__c);
			if (a.Product2.KVH_Product_Family__r.FCP_Element_Type__c != null){	//only Terminals intially... but more now!
				DEL_Obj.Object_Type__c = a.Product2.KVH_Product_Family__r.FCP_Element_Type__c;		//Maybe this becomes the FCP Element Type..
																									//.. rather than the myKVH Object type...
				DEL_Obj.Name = a.name;					//populate the rest of the record...
				DEL_Obj.Deleted_Record_ID__c = a.Id;	//(This is an important foreign key)
				DEL_Assets.Add(DEL_Obj);				//....and add it to a list.
			}
		}
		insert DEL_Assets;								//insert the list into the database.
	}
}