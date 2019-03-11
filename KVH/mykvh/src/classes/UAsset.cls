public class UAsset 
{
	public static void UpdateCaseAssetAccountParentNameText(List<Asset> records, Map<ID,Asset> oldMap)
	{
		Boolean isUpdate = (oldMap != null);
		
		Set<ID> AssetIds = new Set<ID>();

		for(Asset a : records)
		{
			if ((!isUpdate && a.AccountID != null) ||
				(isUpdate && a.AccountID != oldMap.get(a.id).AccountID))
			{
				AssetIds.add(a.id);
			}
		}
		
		list<Case> toUpdate = new list<Case>(); 
		
		Map<ID, Case> caseMap = new Map<ID, Case>
											(
												[Select Id, AssetId, Asset.AccountId,
													Asset.Account.Name,
													Asset.Account.Parent_Account_Text__c
												  from Case where 
												  AssetID in :AssetIDs]
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