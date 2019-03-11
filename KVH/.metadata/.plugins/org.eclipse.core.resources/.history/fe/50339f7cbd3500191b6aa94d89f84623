public class UAccount 
{
	public static void UpdateParentAccountText(List<Account> records, Map<ID,Account> oldMap)
	{
		Boolean isUpdate = (oldMap != null);
		 
		Set<ID> accountIDs = new Set<ID>();
		Map<ID,string> acctParentIDs = new Map<ID,string>();
		  
		for(Account a : records) 
		{
			 //look for accounts that have been assigned a parent
			 // or have had their parent 'changed'
			if ((!isUpdate && a.ParentId != null) ||
				(isUpdate && a.ParentId != oldMap.get(a.id).ParentId))
			{
				accountIDs.add(a.id);
			}
			
			// If an account Name changes... and that Account is a Parent
			// account then need to update Parent_Account_Text on its children
			if (isUpdate && a.Name != oldMap.get(a.Id).Name)
			{
				acctParentIDs.put(a.Id,a.Name);
			}
		}
		
		list<Account> toUpdate = new list<Account>(); 
		
		Map<ID, Account> parentAcctNameChangeMap = new Map<ID,Account>
												(
													[Select Id,ParentId, Parent.Name 
												  		from Account where 
												  		ParentID in : acctParentIDs.KeySet()]
												);
												
		for(Account accRefParent : parentAcctNameChangeMap.values())
		{
			accRefParent.Parent_Account_Text__c = acctParentIDs.get(accRefParent.ParentId);
			toUpdate.add(accRefParent);
		}
		
		Map<ID, Account> accountMap = new Map<ID, Account>
											(
												[Select Id,ParentId, Parent.Name 
												  from Account where 
												  ID in :accountIDs]
											  );
		
		for(Account acc : accountMap.values() )
		{
			acc.Parent_Account_Text__c = acc.ParentId==null ? '' : acc.Parent.Name;
			toUpdate.add(acc);
		}
		
		if (!toUpdate.IsEmpty())
		{
			update toUpdate;
		}
	}
	
	public static void UpdateCaseAssetAccountName(List<Account> records, Map<ID,Account> oldMap)
	{
		Boolean isUpdate = (oldMap != null);
		
		Set<ID> accountIds = new set<ID>();
		Map<ID,string> acctParentIDs = new Map<ID,string>();
		 
		for(Account a : records)
		{
			// If an account Name changes... and that Account is on 
			// an Asset need to update any Case.Asset_Account_Name__c
			if (isUpdate && a.Name != oldMap.get(a.Id).Name)							
			{
				acctParentIDs.put(a.Id,a.Name);
			}
			
			if ((!isUpdate && a.ParentId != null) ||
				(isUpdate && a.ParentId != oldMap.get(a.id).ParentId))
			{
				accountIDs.add(a.id);
			}
		}
		
		list<Case> toUpdate = new list<Case>(); 
		
		//see if this account name change has any children accounts...
		Map<ID, Account> accountMap = new Map<ID, Account>
											(
												[Select Id,ParentId, Parent.Name 
												  from Account where 
												  ParentID in :acctParentIDs.keyset()]
											  );
		
		//and if those accound are linked to assets
		Map<ID, Case> parentAcctNameChangeMap = new Map<ID,Case>
												(
													[Select Id, AssetId, Asset.AccountId, 
														Asset.Account.ParentId, 
														Asset.Account.Parent.Name
												  		from Case where 
												  		Asset.AccountId in : accountMap.KeySet()]
												);
												
		for(Case c : parentAcctNameChangeMap.values())
		{
			c.Asset_Account_Name_Parent_Text__c = acctParentIDs.get(c.Asset.Account.ParentId);
			toUpdate.add(c);
		}
		
		parentAcctNameChangeMap = new Map<ID,Case>
												(
													[Select Id, AssetId, Asset.AccountId, 
														Asset.Account.ParentId, 
														Asset.Account.Parent.Name
												  		from Case where 
												  		Asset.AccountId in : accountIDs]
												);
		
		for(Case c : parentAcctNameChangeMap.values())
		{
			c.Asset_Account_Name_Parent_Text__c = c.asset.account.Parent.Name;
			toUpdate.add(c);
		}
		
		if (!toUpdate.IsEmpty())
		{
			update toUpdate;
		}
	}
	
	//resett Parent Account Text - one time backfil;
	public static void BackFillParentAccountInfo(List<Account> records)
	{
		//get the right records in here... probably all accounts... that have parent accounts..
		//[Select Id,ParentId,Parent.Name, Name 
	  	//	from Account where 
	  	//	ParentID != null]
		
		UpdateAccounts(records);
		UpdateCaseFields(records);
	}
	
	private static void UpdateAccounts(List<Account> records)
	{
		list<Account> toUpdate = new list<Account>(); 
		for(Account a : records)
		{
			a.Parent_Account_Text__c = a.Parent.Name;
			toUpdate.add(a);
		}
				
		if (!toUpdate.IsEmpty())
		{
			update toUpdate;
		}
	}
	
	private static void UpdateCaseFields(List<Account> records)
	{
		set<id> accountIDs = new set<ID>();
		List<Case> toUpdate = new list<Case>();
		for(Account a : records)
		{
			accountIDs.add(a.id);
		}	
		
		Map<ID,Case> parentAcctNameChangeMap = new Map<ID,Case>
												(
													[Select Id, AssetId, Asset.AccountId, 
														Asset.Account.ParentId, 
														Asset.Account.Parent.Name
												  		from Case where 
												  		Asset.AccountId in : accountIDs]
												);
		
		for(Case c : parentAcctNameChangeMap.values())
		{
			c.Asset_Account_Name_Parent_Text__c = c.asset.account.Parent.Name;
			toUpdate.add(c);
		}
		
		if (!toUpdate.IsEmpty())
		{
			update toUpdate;
		}
	}
	
	
	public static void setApplyCustomSharingonReparent (List <Account> accounts, map <id, Account> oldMap)
	{
		boolean isInsert = false;
		
		if(oldMap == null) 
		{
			isInsert = true;
		}
		
		set <id> parents = new set <id>();
		Map <id, Account> parentMap = new Map <id, Account>();
		
		for(Account a : accounts)
		{
			if((isInsert == true && a.parentId != null)
		 	 ||(isInsert == false &&a.parentId != null && a.parentId != oldMap.get(a.id).parentId))
			{
				system.debug('---------------------------here1');
		 		parents.add(a.parentId);
			}
		}
		
		for(Account a : [select id, Apply_Custom_Sharing__c from account where id in :parents])
		{
			parentMap.put(a.id, a);
			system.debug('---------------------------here2');
		}
		
		for(Account a : accounts)
		{
			if((isInsert == true && a.parentId != null)
		 	 ||(isInsert == false &&a.parentId != null && a.parentId != oldMap.get(a.id).parentId))
			{
				system.debug('---------------------------here3' + parentMap.get(a.parentId).Apply_Custom_Sharing__c);
		 		a.Apply_Custom_Sharing__c = parentMap.get(a.parentId).Apply_Custom_Sharing__c;
			}
		}
		
	}
		
	/*
	1) Push the parent flag value down to the children
	*/
	
	public static void setApplyCustomSharing (List <Account> accounts, map <id, Account> oldMap)
	{
		
		boolean isInsert = false;
		
		if(oldMap == null) 
		{
			isInsert = true;
		}
		
		Map <id, Account> accountMap = new Map <id, Account>();
		
		for(Account a : Accounts)
		{
			// on insert, there will be no children, so no need to check
			if(isInsert == false && a.Apply_Custom_Sharing__c != oldMap.get(a.id).Apply_Custom_Sharing__c)
			{
			  	accountMap.put(a.id, a);
			  	system.debug('----here ' +  a.id + + accountMap.get(a.id).Apply_Custom_Sharing__c);
			}
						
		}
		
		List <Account> accountsToupdate = new List <Account>();
		
		if(accountMap.size() > 0)
		{
			for(Account a : [Select id, Apply_Custom_Sharing__c, parentId, name from Account where parentId in :accountMap.keySet()])
			{
				system.debug('-----' + a.Apply_Custom_Sharing__c);
				system.debug('-----' + a.id);
				system.debug('-----' + accountMap.get(a.parentId).Apply_Custom_Sharing__c);
				if(a.Apply_Custom_Sharing__c != accountMap.get(a.parentId).Apply_Custom_Sharing__c)
				{
					system.debug('-----Updating Apply_Custom_Sharing__c for ' + a.name + ' ' + a.parentId);
					a.Apply_Custom_Sharing__c = accountMap.get(a.parentId).Apply_Custom_Sharing__c;
					accountsToUpdate.add(a);
				}
			}
		}
		
		if(accountsToUpdate.size() > 0)
		{
			update accountsToUpdate;
		}
	
		
	}
	
}