public class UCase 
{
	public static void setAccount (List<Case> records, Map<ID,Case> oldMap)
	{
		boolean isInsert = (oldMap == null);
		
		set <id> assetIds = new set <id>();
		
		for(Case c : records)
		{
			if(c.AssetId != null)
			//&& c.Platform_asset_account__c == null)
			{
				assetIds.add(c.assetId);	
			}
		}
		
		Map <id, Asset> assetMap = new Map <id, Asset>();
		
		for(Asset a : [select accountId, id from Asset where id in :assetIds])
		{
			assetMap.put(a.id, a);
		}
		
		for(Case c : records)
		{
			if(c.AssetId != null && c.Platform_asset_account__c == null && assetMap.containsKey(c.assetId))
			{
				c.Platform_Asset_Account__c = assetMap.get(c.assetId).accountId;
			}
			
		}
	
	}
	
	
	
	
	public static void UpdateAssetAccountNameText(List<Case> records, Map<ID,Case> oldMap)
	{
		Boolean isUpdate = (oldMap != null);
		
		Set<ID> caseIDs = new Set<ID>();

		for(Case c : records)
		{
			if ((!isUpdate && c.AssetId != null) ||
				(isUpdate && c.AssetId != oldMap.get(c.id).AssetId))
			{
				caseIDs.add(c.id);
			}
		}
		
		list<Case> toUpdate = new list<Case>(); 
		
		Map<ID, Case> caseMap = new Map<ID, Case>
											(
												[Select Id,AssetId, Asset.AccountId,
													Asset.Account.Name,
													Asset.Account.Parent_Account_Text__c
												  from Case where 
												  ID in :caseIDs]
											  );
		
		for(Case aCase : caseMap.values() )
		{
			aCase.Asset_Account_Name_Parent_Text__c = aCase.AssetId==null ? '' : aCase.Asset.Account.Parent_Account_Text__c;
			toUpdate.add(aCase);
		}
		
		if (!toUpdate.IsEmpty())
		{
			update toUpdate;
		}
	}

}