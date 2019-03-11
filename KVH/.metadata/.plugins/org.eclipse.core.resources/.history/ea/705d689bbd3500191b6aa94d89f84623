trigger BIG_PopulateModemIPInstallConfig on Install_Config__c (before insert, before update) {
	
	List<id> asset_ids = new List<id>();
	Map<id,Asset> child_assets = new Map<id,Asset>();
	Map<id,Asset> parent_assets = new Map<id,Asset>();
	List<Asset> children_of_parent_assets = new List<Asset>();
	
	for(Install_Config__c i:Trigger.new)
		if(i.Asset__C!=null) asset_ids.add(i.Asset__c);
		
	
	child_assets= new Map<id,Asset>([SELECT ID,SerialNumber from Asset where id in :asset_ids and Child_Asset_ID__c!=null and Item_Description__c='ip address' and Date_Removed__c=null]);
	
	if(!child_assets.isEmpty())
	{
		for(Install_Config__c i:Trigger.new)
			if(child_assets.containsKey(i.Asset__C))
				i.Modem_IP__c=child_assets.get(i.Asset__c).SerialNumber;
			
	}
			
			
	parent_assets= new Map<id,Asset>([SELECT ID from Asset where id in :asset_ids and 	Asset_ID__c!=null]);		
	
	if(!parent_assets.isEmpty())
	{
		children_of_parent_assets = [SELECT ID,SerialNumber,Parent_Asset__c from Asset where Parent_Asset__c in :asset_ids and Item_description__c='ip address' and Child_Asset_ID__c!=null and Date_Removed__c=null];
		if(!children_of_parent_assets.isEmpty())
		{
			child_assets.clear();
			for(Asset a:children_of_parent_assets)
				child_assets.put(a.Parent_Asset__c,a);
			
			for(Install_Config__c i:Trigger.new)
				if(parent_assets.containsKey(i.Asset__C))
					if(child_assets.containskey(parent_assets.get(i.Asset__c).id))
						i.Modem_IP__c=child_assets.get(parent_assets.get(i.Asset__c).id).SerialNumber;
			
			
			
		}
	
	}

	

}