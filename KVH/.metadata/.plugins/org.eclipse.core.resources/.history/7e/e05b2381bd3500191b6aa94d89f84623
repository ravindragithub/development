public class myKVHElementCount {
	@InvocableMethod(label='Update myKVH Element Count' 
					description='Counts all of the Elements related to Assets Account, even if they are in different Asset Hierarchies and if there are Elements, updates the Accounts Element Count Field. If the count > 0, it sets the send flag')
	public static void UpdateElementCounts(List<Asset> AssetList){
		system.debug('Entering myKVHELementCount.UpdateElementCounts....');
		Set<Id> assetAccountIds = new Set<Id>();						//Get a set of Accounts related to the triggered Assets... 
		for (Asset a : assetList){
			system.debug(a);
			assetAccountIds.add(a.AccountId);
		}
		system.debug(assetAccountIds);
		List <AggregateResult> results= new List <AggregateResult>();		//get an aggregate query...
	    /*results = [SELECT Count(Id) ElCt, Account.Id acctId, Account.name
	            	FROM Asset 
	            	WHERE Product2.KVH_Product_Family__r.FCP_Element_Type__c ='Terminal' //maybe CBXs someday too!
	            	AND Date_Removed__c = null 
	            	AND Account.Id IN: assetAccountIds
	            	GROUP BY Account.Id, Account.name];*/						//NOTE: If there are no terminals on an Account, it will not be in the return list!
	            	
	    results = [SELECT Count(Id) ElCt, Account.Id acctId, Account.name
	            	FROM Asset 
	            	WHERE Account.Id IN: assetAccountIds
	            	AND Date_Removed__c = null 
	            	AND Product2.KVH_Product_Family__r.FCP_Element_Type__c ='Terminal'
	            	GROUP BY Account.Id, Account.name];
	            	
	            	
	    List<Account> updateAccts = new List<Account>();					//Define a list for update
	    for (AggregateResult ar : results){									//loop through the aggresults
	    	system.debug('Aggregate Results: ' + ar);
	    	Account acct = new Account();									//create Account with Account.Id, ElementCount, and send flag
	    	acct.Id = (Id)ar.get('acctId');									//aggregate results typically require type conversions
			acct.myKVH_Element_Count__c = (integer)ar.get('ElCt');			//aggregate results typically require type conversions
			acct.Send_to_myKVH_Physical__c = true;							//set the send flag
	    	updateAccts.add(acct);											//add updates to the list...
	    }
		system.debug(updateAccts);
		update updateAccts;													//update the Accounts
	}
}