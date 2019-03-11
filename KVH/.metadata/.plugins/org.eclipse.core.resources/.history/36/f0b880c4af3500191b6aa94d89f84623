public without sharing class AssetAfterUpdateTriggerHandler extends TriggerHandlerBase { 
    //(Activation Order) Task - AW-610 : "without sharing" keyword is added because of from "Create Acct, etc." flow we are updating asset account.
	public override void mainEntry(TriggerParameters tp) {
		system.debug('Entering AssetAfterUpdateTriggerHandler.mainEntry....');
		//Need to provide an override for BaaN integration - occasionally throws exceptions for too many SOQL....
		if((UserInfo.getUserId() != '00530000004UxCsAAK') ){			//If it's not KVH Admin, don't bypass all the hierarchy related details....
			AssetTriggerStatics.addRootToMap(tp.newList);				//Get the Assets roots....
			AssetTriggerStatics.addHierarchyToMap(tp.newList);			//Get the Asset's hierarchy
			cascadeFieldUpdates(tp.newList);							//Populate Root field in All Assets in Hierarchy (except Root!)
																		//Update Account Fiels in All Assets in Hierarchy (if different from Root's Account!)
		}
		
		/*SECOND*/
		BIG_PopulateModemIP(tp.newlist);								//This was originally an Asset trigger built by BIG
																		//it's real function is not entirely known or understood!
		/*THIRD*/
		myKVHElementCount.UpdateElementCounts(tp.newList);				//run an aggregate query and update Accounts with Element Counts
		
	}
	
	public override void inProgressEntry(TriggerParameters tp) {
		system.debug('Entering AssetAfterUpdateTriggerHandler.inProgressEntry....');
		system.debug('This is an example for reentrant code...');
	}
	/** The methods below are where the actual work for the trigger gets done.
	 *
	 */
	private static void cascadeFieldUpdates(List<Asset> triggeredAssets){
		//Diagnostic...
		//system.debug('Map Retrieval diagnostics...');
		//for (Asset diagA : triggeredAssets){
		//	system.debug('Key : ' + diagA.Id + 'Found=' + AssetTriggerStatics.HierarchiesMap.containsKey(diagA.Id) + ' Value : ' + AssetTriggerStatics.HierarchiesMap.get(diagA.Id));
		//}
		List<AssetStructureEngine.AssetStructureMap> HierarchyCascade;										//Placeholder for Asset Hierarchy...
		Asset rootAsset = new Asset();																		//Placeholder for Root Asset
		map<Id, Asset> AssetsToUpdateMAP = new map<Id, Asset>();											//MAP to de duplicate
		for (Asset a : triggeredAssets){																	//Loop through the triggered Assets
			
			rootAsset = AssetTriggerStatics.RootsMap.get(a.Id);												//Get the Root (should already be there!)
			system.debug('Asset Name : ' + a.Name +' ID : ' + a.Id + ' Asset Account Id : '+ a.AccountId + ' Root Name : ' + rootAsset.Name + ' Root Account Id : '+ RootAsset.AccountId);
			HierarchyCascade = AssetTriggerStatics.HierarchiesMap.get(a.Id);										//Get the Hierarchy (should already be there!)
			system.debug('Map Id : ' + a.Id + ' Map Hierarchy : ' + HierarchyCascade);
			if (HierarchyCascade != null){																			//but check for a null anyway!
				for (AssetStructureEngine.AssetStructureMap h : HierarchyCascade){									//Now loop through the Hierarchy
					system.debug('Hierarchy Node : ' + h);
					if (h.Asset.Parent_Asset__c != null && 													//If it's not a root, AND....
						(h.Asset.Root_Asset__c != rootAsset.Id ||											//It's Root Asset Field needs an update OR
						h.Asset.AccountId != rootAsset.AccountId)){											//It's Account needs an update...
						system.debug('Updating Child : ' + h.Asset.Name);
						h.Asset.Root_Asset__c = rootAsset.Id;												//update the Root field...
						h.Asset.AccountId = rootAsset.AccountId;											//update the Account Field... (Based on Root)
						//h.Asset.Date_Removed__c = a.Date_Removed__c;										//update Date Removed (from Triggered Asset)
						//h.Asset.InstallDate = a.InstallDate;												//update InstallDate (from Triggered Asset)
						//h.Asset.Installed_By__c = a.Installed_By__c;										//update installed by (from Triggered Asset) 
						system.debug('Adding to MAP as KEY : ' + h.Asset.Id + ' VALUE : ' + h.Asset);
						AssetsToUpdateMAP.put(h.Asset.Id, h.Asset);											//add it to the update MAP!
					} else if ((h.Asset.Parent_Asset__c == null) &&											//If it IS the root....
								(h.Asset.Root_Asset__c != null)){											//AND it's Root_Asset__c Field is not nulled out already!
						system.debug('Updating Root : ' + h.Asset.Name);
						h.Asset.Root_Asset__c = null;														//null out it's Root Asset....
						system.debug('Adding to MAP as KEY : ' + h.Asset.Id + ' VALUE : ' + h.Asset);
						AssetsToUpdateMAP.put(h.Asset.Id, h.Asset);											//add it to the update MAP!
					}
				}
				HierarchyCascade.clear();																	//reset the list...
			}
		}
		//AssetsToUpdateLIST.addAll(AssetsToUpdateSET);		//SET has no dupes... copy set to list
		update AssetsToUpdateMAP.values();							//apply the updates, the trigger architecture prevents trigger re-entry for these updates....
	}
	
	private static void BIG_PopulateModemIP (Asset[] newAssets){
        /* This was originally an Asset trigger built by BIG
        *  It has been refactored as a method in the Asset Trigger Handler
        *  it's real function is not entirely known or understood! */
        set<id> asset_ids = new set<id>();
        List<Install_Config__c> l_ic = new List<Install_Config__c>();
        Map<id,Asset> id2asset = new Map<id,Asset>();
        
        //for(Asset a:Trigger.new)
        for(Asset a:newAssets)
        {
            if(a.Item_Description__c!=null && a.Item_Description__c.toLowerCase()=='ip address' && a.Date_Removed__c==null && a.Child_Asset_ID__c!=null)
            {                                   // the 'ip address' description is a little sketchy... maybe starts with 10.61 will be better...
                System.debug('Child asset added');
                asset_ids.add(a.id);    //add to the set
                id2asset.put(a.id,a);   //put in the map
                if(a.Parent_Asset__c!=null)
                { 
                    id2asset.put(a.Parent_Asset__c,a);
                    asset_ids.add(a.Parent_Asset__c);
                }
            }
        }
        
        if(!asset_ids.isEmpty())
        {
            l_ic = [SELECT ID,Modem_IP__c,Asset__c from Install_Config__c WHERE Asset__c in :asset_ids];
            System.debug('size of install configs is '+l_ic.size().format());
            
            if(!l_ic.isEmpty())
            {
                for(Install_Config__c i:l_ic)
                {
                    if(id2asset.containskey(i.Asset__c))
                        i.Modem_IP__c=id2asset.get(i.asset__c).SerialNumber;
                }
                update l_ic;
            }
        }
    }
}