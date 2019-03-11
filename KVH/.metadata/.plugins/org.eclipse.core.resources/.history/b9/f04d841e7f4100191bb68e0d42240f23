public with sharing class Update_myKVH_Element_Count {
	public void Update_myKVH_Element_Count(List<sObject> scope){
		//The Scope List is a list of Account Ids (maybe only one)
		//This would allow us to use this Class in an Asset Trigger by passing Asset.AccountId to the Class.
		Integer BatchSize = scope.size();
		//need a set of Platform Account RecordType Ids to implement a Platform filter
		//start with an AccountUtilities instnace...
		AccountUtilities util = new AccountUtilities();
		Set<Id> PlatRecTypes = new Set<Id>();
		PlatRecTypes = util.getPlatformAccountIds();
		system.debug('Scope size = '+scope.size()+' (Might not match AcctsToUpdate Size!)');
		for (sObject o : scope) { //for dev purposes only...
			system.debug(o);
		}
		//FIRST, run the aggregate query and
		//Create a map of Account.IDs to element counts
		Map<ID, Integer> ElCounts = new Map<Id, Integer>();
		for(sObject a : [SELECT Count(Id) ElementCount, Account.Id acctId, 
						Account.Name//, Account.RecordType.DeveloperName
						FROM Asset 
						WHERE Product2.KVH_Product_Family__r.FCP_Element_Type__c ='Terminal' 
						AND Date_Removed__C = null 
						AND Account.Id IN :scope
						GROUP BY Account.Id, Account.Name//, Account.RecordType.DeveloperName
						LIMIT :BatchSize]) { 
			system.debug(a);
			ElCounts.put( (ID)a.get('acctId'), (Integer)a.get('ElementCount'));	//watch those type conversions!
			system.debug(ElCounts.size());
		}
		//SECOND, Loop through the Accounts
		//checking Element Counts as we go... 
		List<Account> AcctsToUpdate = new List<Account>();
		//Create a List of Accounts to update
		List<Account> AcctsToRemove = new List<Account>();
		//Need to make a list of myKVH_Deleted_Records__c...
		for (Account ac : [SELECT id, Name, myKVH_Element_Count__c, 
									//Need Send Flag and Record Type for trigger handler
									Send_to_myKVH_Physical__c, RecordTypeId
							FROM Account
							WHERE Id IN :scope]) {	// Loop though the scope list
			If (ElCounts.get(ac.Id) == null){		//This account had not Elements to aggregate
				system.debug('Entering NULL Condition statements for ' + ac.Name);
				system.debug('Before Element Count: ' + ac.Send_to_myKVH_Physical__c);
				ac.myKVH_Element_Count__c = null;	//So it needs to have it's count nulled
				system.debug('AFTER Element Count: ' + ac.Send_to_myKVH_Physical__c);
				AcctsToUpdate.add(ac);				//and be added to the update list.
				system.debug(AcctsToUpdate);
				//AND we need to create a deleted object record (Platforms only!)
				if (PlatRecTypes.contains(ac.RecordTypeId)){ //its a Platform
					AcctsToRemove.add(ac);
				}
				system.debug(ac);
			} else if (ElCounts.get(ac.Id) == ac.myKVH_Element_Count__c) {
				system.debug('Entering EQUALS Condition statements for ' + ac.Name);
				//system.debug('Do Nothing... no update required');
			} else if (ElCounts.get(ac.Id) != ac.myKVH_Element_Count__c) {
				system.debug('Entering NOT EQUALS Condition statements for ' + ac.Name);
				ac.myKVH_Element_Count__c = ElCounts.get(ac.Id);	//So it needs to have it's count updated
				AcctsToUpdate.add(ac);								//and be added to the update list.
				system.debug(AcctsToUpdate);
			}
		}
		
		//Use the AccountTriggerHandler to remove the Accounts from myKVH
		AccountTriggerHandler DelHandler = new AccountTriggerHandler(false, BatchSize);
		system.debug(AcctsToRemove);
		DelHandler.OnBeforeDelete(AcctsToRemove, null);
		//We need to do that first since updating the flage clears the Send to myKVH flag.
		system.debug('AcctsToUpdate size = '+AcctsToUpdate.size()+' (Might not match Scope Size!)');
		system.debug(AcctsToUpdate);
		update AcctsToUpdate;
	}
}