public class UAccountShare {

	public static void createAccountShare(set <id> accounts)
	{
		
		List <AccountShare> sharesToCreate = new List <AccountShare>();
		List <AccountShare> sharesToUpdate = new List <AccountShare>();
		
		/* Part 1 - Create manual Sharing rules for all users at the top accout level */
	
	
		// find all the AccountShare users
		Map <id, List<AccountShare>> currentAccountMap = new Map <id, List<AccountShare>>();
		
		/* This aggregate query appears to be causing the following exception message when running a nightly batch job...
		 * "Aggregate query has too many rows for direct assignment, use FOR loop"
		 * refactor code to return a List from the query, and then loop through the list....
		 * jthom 11/24/14
		 
		for(Account a : [Select id, name, 
							    (Select id, UserOrGroupId From Shares) 
						 From Account 
						 where id in :accounts])
		{
			currentAccountMap.put(a.id, a.Shares);	
		}
		*/
		List<Account> AggregateAccts = new List<Account>();
		AggregateAccts = [SELECT id, name, (SELECT id, UserOrGroupId FROM Shares) FROM Account WHERE id in :accounts];
		system.debug('Aggregate Accounts and Shares Size : ' + AggregateAccts.size());
		for(Account a : AggregateAccts){
			currentAccountMap.put(a.id, a.Shares);
		}
		
		// find all the user records associated 
		for(User u : [select id, accountId, profileid
					  from user
					  where	accountId in :accounts
					  		and isPortalEnabled = true
					  		and isActive = true
					  		and contactId != null])
		{
			
			boolean isfound = false;
			id foundId = null;
			
			if(currentAccountMap.containsKey(u.accountId))
			{
				List <AccountShare> shares = currentAccountMap.get(u.AccountId);
				
				for(AccountShare s : shares)
				{
					if(s.UserOrGroupId == u.id)
					{
						isFound = true;
						foundId = s.id;
					}
				}
				
			}
			else
			{
				isFound = false;
			}
			
			if(isFound == false)
			{
				system.debug('Profile = ' + u.profileid);
				AccountShareProfiles__c asp = AccountShareProfiles__c.getInstance(u.profileid);
				
				AccountShare newShare = new AccountShare();
				newShare.UserOrGroupId = u.id;
				newShare.AccountId = u.accountId;
				newShare.CaseAccessLevel = asp.caseAccess__c;
				newShare.AccountAccessLevel = asp.accountAccess__c;
				newShare.OpportunityAccessLevel = asp.opportunityAccess__c;
				sharesToCreate.add(newShare);
				system.debug('------------adding Part #1 ' + u.id);
				system.debug('------------newShare.CaseAccessLevel ' + newShare.CaseAccessLevel);
				system.debug('------------newShare.AccountAccessLevel ' + newShare.AccountAccessLevel);
				system.debug('------------newShare.OpportunityAccessLevel ' + newShare.OpportunityAccessLevel);
				
			}	
			else
			{
				system.debug('Profile = ' + u.profileid);
				AccountShareProfiles__c asp = AccountShareProfiles__c.getInstance(u.profileid);
				
				AccountShare newShare = new AccountShare(id=foundId);
				//newShare.UserOrGroupId = u.id;
				//newShare.AccountId = u.accountId;
				newShare.CaseAccessLevel = asp.caseAccess__c;
				newShare.AccountAccessLevel = asp.accountAccess__c;
				newShare.OpportunityAccessLevel = asp.opportunityAccess__c;
				sharesToUpdate.add(newShare);
				system.debug('------------adding Part #1 ' + u.id);
				system.debug('------------newShare.CaseAccessLevel ' + newShare.CaseAccessLevel);
				system.debug('------------newShare.AccountAccessLevel ' + newShare.AccountAccessLevel);
				system.debug('------------newShare.OpportunityAccessLevel ' + newShare.OpportunityAccessLevel);
				
				
			}
		}
		
		if(sharesToCreate.size() > 0)
		{
			insert sharesToCreate;
		}
		
		if(sharesToUpdate.size() > 0)
		{
			update sharesToUpdate;
		}
		
		
		
		
		
		/* Part 2 */
		
		
		
		sharesToCreate.clear();
		sharesToUpdate.clear();
		 
		Map <id, List<AccountShare>> accountMap = new Map <id, List<AccountShare>>();
		Map <id, Account> childMap = new Map <id, Account>();
		set <id> userIds = new set <id>();
		set <id> children = new set <id>();
		
		
		
		/* This aggregate query appears to be causing the following exception message when running a nightly batch job...
		 * "Aggregate query has too many rows for direct assignment, use FOR loop"
		 * refactor code to return a List from the query, and then loop through the list....
		 * jthom 11/24/14
		 
		for(Account a : [Select id, name, parentId,
							    (Select id, UserOrGroupId From Shares) 
					     From   Account 
					     where  id in :accounts or parentId in :accounts])
		{
			
			accountMap.put(a.id, a.Shares);
			childMap.put(a.id, a);
			for(AccountShare s : a.Shares)
			{
				//system.debug('-----Users: ' + s.UserOrGroupId);
				userIds.add(s.UserOrGroupId);	
			}
		}
		*/
		List<Account> AggregateAccts2 = new List<Account>();
		AggregateAccts2 = [SELECT id, name, parentId, (SELECT id, UserOrGroupId FROM Shares) FROM Account WHERE id in :accounts OR parentId in :accounts];
		for(Account a : AggregateAccts2){
			accountMap.put(a.id, a.Shares);
			childMap.put(a.id, a);
			for(AccountShare s : a.Shares)
			{
				//system.debug('-----Users: ' + s.UserOrGroupId);
				userIds.add(s.UserOrGroupId);	
			}
		}
		
		Map <id, User> UserMap = new Map <id, User>();
		
		for(User u : [Select id, name, profileid from user where isActive = true and id in :userIds and AccountId != null])
		{
			//system.debug('-----User Map:' + u.id);
			userMap.put(u.id, u);
		}
		
		for(id a : accounts)
		{
			//system.debug('-----Parent Account = ' + a);
			
			// loop through all the parents looking for sharing users
			for(AccountShare s : accountMap.get(a))
			{
				// see if the user is qualified to be copied
				if(userMap.containsKey(s.UserOrGroupId))
				{
					//system.debug('----- User = ' + userMap.get(s.UserOrGroupId).name);
					
					// go through the map looking for children
					for(Account child : childMap.values())
					{
					    
						if(child.parentId == a)
						{
							//system.debug('-----child Account = ' + child.name);
							children.add(child.id);
							
							boolean found = false;
							id foundId;
							
							//see is the child has the user mapped.
							for(AccountShare cs : accountMap.get(child.id))
							{
								
								if(cs.UserOrGroupId == s.UserOrGroupId)
								{
									//system.debug('-----found a match' + cs.UserOrGroupId);
									found = true;
									foundId = cs.id;
								}
								
							}
							
							//system.debug('----- Match = ' + found);
							
							if(found == false)
							{
								system.debug('Profile = ' + userMap.get(s.UserOrGroupId).profileId);
								AccountShareProfiles__c asp = AccountShareProfiles__c.getInstance(userMap.get(s.UserOrGroupId).profileId);
								
								AccountShare newShare = new AccountShare();
								newShare.UserOrGroupId = s.UserOrGroupId;
								newShare.AccountId = child.id;
								newShare.CaseAccessLevel = asp.caseAccess__c;
								newShare.AccountAccessLevel = asp.accountAccess__c;
								newShare.OpportunityAccessLevel = asp.opportunityAccess__c;
								sharesToCreate.add(newShare);
								system.debug('-----ADDING Part #2');
								system.debug('------------newShare.CaseAccessLevel ' + newShare.CaseAccessLevel);
								system.debug('------------newShare.AccountAccessLevel ' + newShare.AccountAccessLevel);
								system.debug('------------newShare.OpportunityAccessLevel ' + newShare.OpportunityAccessLevel);
							}
							else
							{
								system.debug('Profile = ' + userMap.get(s.UserOrGroupId).profileId);
								AccountShareProfiles__c asp = AccountShareProfiles__c.getInstance(userMap.get(s.UserOrGroupId).profileId);
								
								AccountShare newShare = new AccountShare(id=foundId);
								//newShare.UserOrGroupId = s.UserOrGroupId;
								//newShare.AccountId = child.id;
								newShare.CaseAccessLevel = asp.caseAccess__c;
								newShare.AccountAccessLevel = asp.accountAccess__c;
								newShare.OpportunityAccessLevel = asp.opportunityAccess__c;
								sharesToUpdate.add(newShare);
								system.debug('-----ADDING Part #2');
								system.debug('------------newShare.CaseAccessLevel ' + newShare.CaseAccessLevel);
								system.debug('------------newShare.AccountAccessLevel ' + newShare.AccountAccessLevel);
								system.debug('------------newShare.OpportunityAccessLevel ' + newShare.OpportunityAccessLevel);
							}
							
						}
					
						
					}
					
				}	
			}	
		}
		
		if(sharesToCreate.size() > 0)
		{
			insert sharesToCreate;
		}
		
		if(sharesToUpdate.size() > 0)
		{
			update sharesToUpdate;
		}
		
		if(children.size() > 0)
		{
			UAccountShare.createAccountShare(children);
		}
		
		
	}

}