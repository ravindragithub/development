global class EquipmentBatch1 implements Database.Batchable<Sobject>{
	//This batch job selects all Assets with an antenna type or a below decks type field,
	//and updates the Asset's Platform "Has_V3", "Has_V7", and "Has_V11" or "Has_ACU__c", "Has_ICM__c", "Has_IPACU__c", and "Has_MediaServer__c" fields...
	
	// START
	global Database.Querylocator start(Database.BatchableContext context) {
		system.debug('*** starting EquipmentBatch1 ***');
		return Database.getQueryLocator([SELECT Id, Name, AccountId, Below_Decks_Type__c, Antenna_Type__c FROM Asset 
										WHERE (Below_Decks_Type__c != null OR Antenna_Type__c != null)
										AND Date_Removed__c = NULL
										AND Account.RecordType.DeveloperName LIKE 'Platform%'
										AND Product2.RecordType.DeveloperName = 'Hardware']);
	}
	// EXECUTE
	global void execute(Database.BatchableContext context, List<Sobject> scope){
		system.debug('*** execute ***');
		List<Account> acctList = new List<Account>();				//Need a list of Accounts to update....
		Map<Id, Account> acctMap = new Map<Id, Account>();			//use a Map for de-duping...
		AssetStructure util = new AssetStructure();					//This Public Class has the GetTopElement method....
		
		for (Sobject rec : scope){									//popuate the map...with empty shell accounts...
			Asset a = (Asset)rec;									//Convert to Asset...FIRST!
			Account acct = new Account(id = a.AccountId);			//create the shell account
			acctMap.put(a.AccountId, acct);							//add to Map... duplicate Ids get overwritten.
		}
		
		for (Sobject rec : scope){ 									//loop through the sObjects....
			Asset a = (Asset)rec;									//Convert to Asset...FIRST!
			String TopAsset = util.GetTopElement((String)a.id);		//Get the Root Asset....
			List<AssetStructureEngine.AssetStructureMap> hierarchy = new List<AssetStructureEngine.AssetStructureMap>();
			hierarchy = AssetStructureEngine.getAssetStructure(TopAsset);	//Get the top down hierarchy...
			
			for (AssetStructureEngine.AssetStructureMap WrappedAsset : hierarchy){	//loop through that hierarchy
				if (WrappedAsset.Asset.Date_Removed__c == null){					//Skip any "removed" assets....
					Account acct = acctMap.get(a.AccountId);
					if (WrappedAsset.Asset.Below_Decks_Type__c != null){			//Handle the Below decks fields....
						system.debug(WrappedAsset.Asset.Name + ' is a ' + WrappedAsset.Asset.Below_Decks_Type__c +' Below Decks Type aboard ' + a.AccountId);
						if (WrappedAsset.Asset.Below_Decks_Type__c == 'ACU'){
							acct.Has_ACU__c = true;
						} else if (WrappedAsset.Asset.Below_Decks_Type__c == 'IPACU'){
							acct.Has_IPACU__c = true;
						} else if (WrappedAsset.Asset.Below_Decks_Type__c == 'ICM'){
							acct.Has_ICM__c = true;
						} else if (WrappedAsset.Asset.Below_Decks_Type__c == 'MEDIA SRVR'){
							acct.Has_MediaServer__c = true;
						}
					} else if (WrappedAsset.Asset.Antenna_Type__c != null) {		//Handle the antenna fields....
						system.debug(WrappedAsset.Asset.Name + ' is a ' + WrappedAsset.Asset.Antenna_Type__c + ' Antenna Type aboard '+ a.AccountId);
						if (WrappedAsset.Asset.Antenna_Type__c == 'V3'){
							acct.Has_V3__c = true;
						} else if (WrappedAsset.Asset.Antenna_Type__c == 'V7'){
							acct.Has_V7__c = true;
						} else if (WrappedAsset.Asset.Antenna_Type__c == 'V11'){
							acct.Has_V11__c = true;
						}
						system.debug('Account details: ' + acct);
					}
				}
			} //end For
			acctList = acctMap.values();
			system.debug(acctList);
			update acctList;
		}
	}
	// FINISH
	global void finish(Database.BatchableContext context) {
		system.debug('*** finish ***');
		EquipmentBatch2 batch = new EquipmentBatch2();
		Id JobId = Database.executeBatch(batch, 4);
		system.debug('Started Batch Apex Job: '+ JobId);
	}
}