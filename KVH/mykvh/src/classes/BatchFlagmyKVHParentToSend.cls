global class BatchFlagmyKVHParentToSend implements Database.Batchable<sObject>{
	global Database.Querylocator start(Database.BatchableContext context) {
		System.debug('Start');
		/*We need...
		  All of the Accounts and Platforms that have "claimed" a myKVH Parent
		  All of the Accounts that have a send flag set
		  These will be combined into a set that is used for the scope of the Batch*/
		//Start with a list of all Accounts that have "claimed" a myKVH Parent...
		//Aggregate these by the number of children as below
		List <AggregateResult> results= new List <AggregateResult>();
		results = [SELECT Count(Id) ChildCount, myKVH_Parent_Account__c, Send_to_myKVH_Physical__c
					FROM Account 
					WHERE myKVH_Parent_Account__c !='' 
					AND Account_Status__c != 'Inactive'
					//AND Account.name LIKE 'Harvey%' //testing with scope limited to Harvey Gulf
					GROUP BY myKVH_Parent_Account__c, Send_to_myKVH_Physical__c];
		//dump all of the Accounts into a Set to de-duplicate them 
		//There shouldn'e be any dupes, but we need to use a Set anyway...
		system.debug('Accounts and Platforms with a myKVH Parent = '+results.size());
		Set<Id> accountIds = new Set<Id>();
		for (AggregateResult ar : results){
			system.debug(ar);
			accountIds.Add( (Id)ar.Get('myKVH_Parent_Account__c'));	//Type conversion, string to ID
		}
		system.debug('Unique Accounts and Platforms with a myKVH Parent = '+accountIds.size());
		//Collect a list of accounts that already have their send flags set, skip the Platforms
		List<Account> FlaggedAccts = new List<Account>();
		FlaggedAccts = [Select a.myKVH_Parent_Account__c, a.Send_to_myKVH_Physical__c, a.Name, a.Id, a.RecordType.DeveloperName 
						FROM Account a 
						WHERE a.Send_to_myKVH_Physical__c = true
						//AND Account.name LIKE 'Harvey%' //testing with scope limited to Harvey Gulf
						AND (NOT RecordType.DeveloperName LIKE 'Platform%')];	//Skip all the Platforms...(flags controlled otherwise)
		system.debug('Accounts (NOT Platforms) with a send flag set = '+FlaggedAccts.size());
		for (Account ac : FlaggedAccts){	//Add these account IDs to the set...
			System.debug(ac.Name + ' ' + ac.Send_to_myKVH_Physical__c + ' '+ ac.myKVH_Parent_Account__c);
			accountIds.add(ac.Id);
		}
		system.debug('Unique Accounts and Platforms with a myKVH Parent OR Accounts with a send flag = '+accountIds.size());
		//Now use that set to drive the batch scope.
		return Database.getQueryLocator([SELECT Id, Name, Send_to_myKVH_Physical__c, myKVH_Parent_Account__c
				FROM Account
				WHERE Id IN :accountIds]);
	}
	
	global void execute(Database.BatchableContext context, List<sObject> scope) {
		System.debug('Executing');
		//Loop through the collection of Accounts (scope), and update the record
		FlagmyKVHParentToSend handler = new FlagmyKVHParentToSend(); 
		handler.FlagmyKVHParentToSend(scope); 
	}
	
	global void finish(Database.BatchableContext context) {
		System.Debug('Finish!');
	}
}