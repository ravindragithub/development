global class Batch_Update_myKVH_Element_Count implements Database.Batchable<sObject>{
	global Database.Querylocator start(Database.BatchableContext context) {
		System.debug('Start');
		/*set the scope of the batch job to Accounts (including Platforms) 
		  That have an associated myKVH Element
		  The initial aggregate query returns an AggregateResult object (yikes!)*/
		List <AggregateResult> results= new List <AggregateResult>();
		results = [SELECT Count(Id) ElCt, Account.Id acctId, Account.name
						FROM Asset 
						WHERE Product2.KVH_Product_Family__r.FCP_Element_Type__c ='Terminal' 
						AND Date_Removed__c = null 
						//AND Account.name LIKE 'Rickey P. Cavalier%' //testing with Ricky
						GROUP BY Account.Id, Account.name];
		//dump all of the aggregated Accounts into a Set to de-duplicate them
		//There shouldn'e be any dupes, but we need to convert these to an ID primitive
		//data type anyway...
		Set<Id> accountIds = new Set<Id>();
		for (AggregateResult ar : results){
			accountIds.Add((ID)ar.get('acctId'));	//watch those type conversions!
		}
		//Collect all the Accounts that already have a myKVH Element Count...
		List <Account> ResetCount = new List<Account>();
		ResetCount = [SELECT myKVH_Element_Count__c, Id, Name, RecordType.DeveloperName
						FROM Account
						WHERE myKVH_Element_Count__c != null];
		for (Account a : ResetCount) {		//Add these to the set to de-duplicate them
			system.debug(a.name+' already has '+a.myKVH_Element_Count__c+' elements...');
			accountIds.add(a.Id);
		}
		system.debug('Aggregate Query List size = '+results.size()); 
		system.debug('Existing Count Value List size = '+ResetCount.size());
		system.debug('De-duplicated Set size = '+accountIds.size());
		//Use the set to drive the Batch Query Locator
		return Database.getQueryLocator([SELECT Id, Name
						FROM Account 
						WHERE Id IN :accountIds]);
	}
	
	global void execute(Database.BatchableContext context, List<sObject> scope) {
		System.debug('Executing');
		/*Instanciate the handler
		  we use the handler so we can re-use the logic like in a trigger...*/
		Update_myKVH_Element_Count handler = new Update_myKVH_Element_Count();
		handler.Update_myKVH_Element_Count(scope); 
	}
	
	global void finish(Database.BatchableContext context) {
		System.Debug('Finish!');
	}
}