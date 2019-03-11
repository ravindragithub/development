public with sharing class AssetUtilities { 
	/* Create Media Server Assets will create Media Server Asset Hierarchies from a List of Media Server Configurations
	 * an important detail is that the Asset_ID__c field must be populated for Asseets based on BaaN items.
	 * failure to correctly populate this field will result in the BaaN integration program creating duplicate Assets
	 */
	public List<Asset> CreateMediaServerAssets(List<Media_Server_Configuration__c> MSList){ 
		system.debug(MSList);
		List<Asset> returnList = new List<Asset>();
		Account DefaultAcct = new Account();				//need the account to assign these Assets too... 
		DefaultAcct = [SELECT Id, Name FROM Account WHERE Name LIKE 'KVH Default%' LIMIT 1];
		system.debug(DefaultAcct);
		
		Map<String, Id> MSProducts = new Map<String, Id>();	//need to map products to Id for Asset creation
		for (Product2 p : [SELECT Id, Name, ProductCode FROM Product2 WHERE ProductCode IN ('02-2143', '02-2104', '02-2103', 'MS LICENSE', 'Secure Media ID', 'Host OS ID', 'Omni ID')]){
			// added '02-2104','02-2103-01' for SuperYacht and Media Server Demo support 11/17/14
			// added '02-2143' for Demo support and removed 02-2103-01 jthom 1/20/15
			MSProducts.put(p.ProductCode, P.Id);
		}
		system.debug(MSProducts);
		
		List<Asset> TopAssetsList = new List<Asset>();
		for (Media_Server_Configuration__c msc : MSList){
			system.debug('Media Server Data : '+msc);
			Asset a = new Asset();
			a.name = msc.Hardware_Serial_Number__c;								//Use the Hardware serial number as the Asset.Name
			a.SerialNumber = msc.Hardware_Serial_Number__c;						//Use the Hardware serial number as the Asset.SerialNumber
			a.AccountId = DefaultAcct.Id;										//Associate it with the "kvh default" account...
			if (msc.Hardware_Part_Number__c == null ){							//If there is no hardware part number...
				system.debug('NULL Hardware Part number logic');
				a.Product2Id = MSProducts.get('02-2103');						//then use the commercial hardware product ID as default...
				a.Asset_ID__c = '02-2103_US_' + msc.Hardware_Serial_Number__c;	//This field prevents dupes from BaaN Integration
			} else if (MSProducts.get(msc.Hardware_Part_Number__c) == null) {	//This accomodates a hardware part number not integrated from SF yet...
				system.debug('ABSENT Hardware Part number logic');
				a.Product2Id = MSProducts.get('02-2103');						//then use the commercial hardware product ID as default...
				a.Asset_ID__c = '02-2103_US_' + msc.Hardware_Serial_Number__c;	//This field prevents dupes from BaaN Integration
			} else {															//otherwise...
				system.debug('MSC Hardware Part Number available!');			
				a.Product2Id = MSProducts.get(msc.Hardware_Part_Number__c);		//use the hardware product ID provided
				a.Asset_ID__c = msc.Hardware_Part_Number__c + '_US_' + msc.Hardware_Serial_Number__c;	//This field prevents dupes from BaaN Integration
			}
			system.debug(a);
			TopAssetsList.add(a);								//Add it to the List
		}
		
		Database.DMLOptions dmo = new database.DMLOptions();				// not an all or nothing transaction
		dmo.optAllOrNone = false;											
		Database.Saveresult[] srList = Database.insert(TopAssetsList, dmo);	//Insert the TOP assets, and save the results
		
		map<String, Id> TopAssetsMap = new map<String, Id>();				//Need to create a map of Id to Hardware serial numbers
		for (Asset a : TopAssetsList){
			TopAssetsMap.put(a.name, a.id);									//Map the Hardware Asset IDs to the serial numbers so we can assign Children later
		}
		system.debug(TopAssetsMap);
		
		TopAssetsList.clear();												//refresh the TopAssetsList
		TopAssetsList = [SELECT Id, Name, SerialNumber, AccountId, PRoduct2Id FROM Asset WHERE Id IN :TopAssetsMap.values()];
		system.debug(TopAssetsList);
		
		
		MSList = [Select Secure_Media_ID__c, Omni_ID__c, Host_OS_ID__c, Hardware_Serial_Number__c, Guest_CommBox_ID__c From Media_Server_Configuration__c 
						WHERE Id IN :MSList];								//refresh the list with the swSerialNumbers...
		system.debug(MSList);

		List<Asset> ChildAssetList = new List<Asset>();
		for (Media_Server_Configuration__c msc : MSList){		//4 children, 'MS LICENSE', 'Secure Media ID', 'Host OS ID', 'Omni ID'
			//ONE 'MS LICENSE'
			Asset aMSlic = new Asset();
			aMSlic.name = msc.Guest_CommBox_ID__c;				//Use the Software serial number as the Asset.Name
			aMSlic.SerialNumber = msc.Guest_CommBox_ID__c;				//Use the Software serial number as the Asset.Name
			aMSlic.AccountId = DefaultAcct.Id;					//Associate it with the "kvh default" account...
			aMSlic.Product2Id = MSProducts.get('MS LICENSE');	//the SW Serial Number product ID
			aMSlic.Parent_Asset__c = TopAssetsMap.get(msc.Hardware_Serial_Number__c);	//Assign a Parent Asset....
			system.debug(aMSlic);
			ChildAssetList.add(aMSlic);							//Add it to the List
			//TWO 'Secure Media ID'
			Asset aDRM = new Asset();
			aDRM.name = msc.Secure_Media_ID__c;				//Use the Software serial number as the Asset.Name
			aDRM.SerialNumber = msc.Secure_Media_ID__c;				//Use the Software serial number as the Asset.Name
			aDRM.AccountId = DefaultAcct.Id;					//Associate it with the "kvh default" account...
			aDRM.Product2Id = MSProducts.get('Secure Media ID');//the SW Serial Number product ID
			aDRM.Parent_Asset__c = TopAssetsMap.get(msc.Hardware_Serial_Number__c);	//Assign a Parent Asset....
			system.debug(aDRM);
			ChildAssetList.add(aDRM);							//Add it to the List
			//THREE 'Host OS ID'
			Asset aHOST = new Asset();
			aHOST.name = msc.Host_OS_ID__c;				//Use the Software serial number as the Asset.Name
			aHOST.SerialNumber = msc.Host_OS_ID__c;				//Use the Software serial number as the Asset.Name
			aHOST.AccountId = DefaultAcct.Id;					//Associate it with the "kvh default" account...
			aHOST.Product2Id = MSProducts.get('Host OS ID');		//the SW Serial Number product ID
			aHOST.Parent_Asset__c = TopAssetsMap.get(msc.Hardware_Serial_Number__c);	//Assign a Parent Asset....
			system.debug(aHOST);
			ChildAssetList.add(aHOST);							//Add it to the List
			//FOUR 'Omni ID'
			Asset aOMNI = new Asset();
			aOMNI.name = msc.Omni_ID__c;				//Use the Software serial number as the Asset.Name
			aOMNI.SerialNumber = msc.Omni_ID__c;				//Use the Software serial number as the Asset.Name
			aOMNI.AccountId = DefaultAcct.Id;					//Associate it with the "kvh default" account...
			aOMNI.Product2Id = MSProducts.get('Omni ID');		//the SW Serial Number product ID
			aOMNI.Parent_Asset__c = TopAssetsMap.get(msc.Hardware_Serial_Number__c);	//Assign a Parent Asset....
			system.debug(aOMNI);
			ChildAssetList.add(aOMNI);							//Add it to the List
		}
		insert ChildAssetList;
		/*for (integer i = 0; i < srList.Size(); i++) {		// Iterate through each returned result, use an integer loop Database.SaveResult sr : srList
		    if (srList[i].isSuccess()) {									// Operation was successful, so get the ID of the record that was processed
		        System.debug('Successfully inserted Asset. Asset ID: ' + srList[i].getId());
		    }
		    else {														// Operation failed, so get all errors
		        for(Database.Error err : srList[i].getErrors()) {				//review the results for errors
		            System.debug('The following error has occurred.');	//handle the errors
		            System.debug(err.getStatusCode() + ': ' + err.getMessage());
		            System.debug('Account fields that affected this error: ' + err.getFields());
		        }
		    }
		}*/
		//map the asset name to the ID as a foreign key...
		system.debug(ChildAssetList);
		
		return TopAssetsList;
	}
	public List<Asset> CheckForExisting(string assetName){
		system.debug(assetName);
		List<Asset> existingAssets = new List<Asset>();
		existingAssets = [SELECT Id, Name, Product2.ProductCode FROM Asset WHERE Name =: assetName];
		system.debug(existingAssets);
		return existingAssets;	//OK to return an empty list!
	}
}