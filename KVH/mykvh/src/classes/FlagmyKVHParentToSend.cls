/*This class is a handler that does the actual work of setting the send flags on Accounts
  Implmenting the worker in this way allows this class to be executed
  by any action, Apex batch, Trigger, etc....
*/ 
public with sharing class FlagmyKVHParentToSend {
	public void FlagmyKVHParentToSend(List<sObject> scope){
		//The Scope List is a list of Account Ids (maybe only one)
		//Accounts and Platforms with a myKVH Parent OR Accounts with a send flag sent.
		//this helper class seperates those two groups and compares them to each other, allowing flags to be set or cleared
		//and also allows this code to be re-used in a trigger
		Integer BatchSize = scope.size();
		system.debug('Scope size = '+scope.size()+' (Might not match AcctsToUpdate Size!)');
		for (sObject o : scope) { //for dev purposes only...
			system.debug(o);
		}
		List<Account> AcctsToUpdate = new List<Account>();		//Create a List of Accounts to update
		Set<Account> ObjectsToDelete = new Set<Account>();	//Create a List of Accounts to *remove*
		Map<ID, Boolean> isParent = new Map<Id, Boolean>();	//Create a map of Account.IDs to Send Flags base on the isParent condition
		//WE need to conver the Parent Account Ids to Strings for use in the Aggregate Query...
		List<Account> ParentAccts = new List<Account>([SELECT Id, Name, Send_to_myKVH_Physical__c, RecordType.DeveloperName
														FROM Account
														WHERE Id IN :scope]);
														//AND (NOT RecordType.DeveloperName LIKE 'Platform%')]);
		Set<String> AcctSet = new Set<String>();	//Use a set
		for (Account pa : ParentAccts) {			//to collect all the ParentAcct Ids
			AcctSet.Add((String)pa.Id);				//and convert them to String
		}											//To use in the aggregate query
		for(AggregateResult ar : [SELECT Count(Id) ChildCount, myKVH_Parent_Account__c, Send_to_myKVH_Physical__c
					FROM Account a
					WHERE a.myKVH_Parent_Account__c !='' 
					AND a.Account_Status__c != 'Inactive'
					//AND a.myKVH_Parent_Account__c IN :AcctSet
					GROUP BY a.myKVH_Parent_Account__c, a.Send_to_myKVH_Physical__c
					/*LIMIT :BatchSize*/]) {//IMPORTANT need to collect ALL the myKVH_Parent_Accounts even beyond "scope"!!
			//system.debug('Aggregate Result =' + ar);
			isParent.put( (Id)ar.Get('myKVH_Parent_Account__c'), (Boolean)ar.Get('Send_to_myKVH_Physical__c'));	//watch those type conversions!
		}																										//as we populate the Map
		system.debug('isParent Aggregate Query size = '+isParent.size()+' (Might not match AcctsToUpdate Size!)');
		//Must remove Inactive Parents from the Map
		//Convert map keys to a set and run a SOQL query loop
		Set <ID> isParentSet = new Set <Id>();
		isParentSet = isParent.keySet();
		for (Account InactiveParents : [SELECT Id, Name, Account_Status__c FROM Account WHERE ID IN :isParentSet]){
			If (InactiveParents.Account_Status__c == 'Inactive'){
				isParent.remove(InactiveParents.Id);
			}
		}
		//system.debug(isParent);
		system.debug('*ACTIVE* isParent size = '+isParent.size());
		//Loop through the Accounts (Skip Platforms) checking isParent as we go...
		for (Account ac : [SELECT Id, Name, Send_to_myKVH_Physical__c, RecordType.DeveloperName 
							FROM Account
							WHERE Id IN :scope
							/*AND (NOT RecordType.DeveloperName LIKE 'Platform%')*/]) {
			system.debug(ac);
			If ((isParent.get(ac.Id) == null) && (ac.Send_to_myKVH_Physical__c == true)){			//This account is NOT a myKVH Parent
				ac.Send_to_myKVH_Physical__c = false;	//So it needs to have it's send flag cleared
				AcctsToUpdate.add(ac);					//and be added to the update list.
				ObjectsToDelete.add(ac);				//as well as the Object to Delete set!!
				system.debug('Clear Flag on ' + ac);
			} else if ((isParent.get(ac.Id) == null) && (ac.Send_to_myKVH_Physical__c == false)){
				system.debug('Flag OK on ' + ac + '(inactive Parent)');
			} else if (ac.Send_to_myKVH_Physical__c == isParent.get(ac.Id)) {
				system.debug('Flag OK on ' + ac);
			} else if (ac.Send_to_myKVH_Physical__c != isParent.get(ac.Id)) {	//This Account is a parent, but the flag is not set
				ac.Send_to_myKVH_Physical__c = true;							//So it needs to have it's Send Flag set
				AcctsToUpdate.add(ac);											//and be added to the update list.
				system.debug('Set Flag on ' + ac);
			}
		}
		system.debug('AcctsToUpdate size = '+AcctsToUpdate.size()+' (Might not match Scope Size!)');
		system.debug('ObjectsToDelete size = '+ObjectsToDelete.size());
		update AcctsToUpdate;
		// need to find the deleted Accounts, identify which ones go to myKVH,
        // and segregate the Platforms
        // start with a set of Platform record IDs
        // by design, the RecordType.DeveloperName *MUST* start with 'Platform'
		Set<Id> RTIds = new Set<Id>();
		for (RecordType RT : [SELECT id, DeveloperName FROM RecordType WHERE DeveloperName LIKE 'Platform%']){
			RTIds.Add(RT.Id);
		}
		//System.debug(RTIds); //This set contains all the "Platform" Record Type Ids.
		Boolean IsPlatform = false;	//need a platform flag....
		List<myKVH_Deleted_Records__c> DEL_Accts = new List<myKVH_Deleted_Records__c>();
		//Need to make a list of myKVH_Deleted_Records__c...
		//myKVH_Deleted_Records__c DEL_Obj = new myKVH_Deleted_Records__c();
		// and an instance of a single Deleted Object....
		system.debug(ObjectsToDelete);
		for (Account a : ObjectsToDelete){	// Loop through the deletedObjects and add them to the list
			system.debug(a);
			myKVH_Deleted_Records__c DEL_Obj = new myKVH_Deleted_Records__c();
			//DEL_Obj.clear();				//reset our single instace deleted object
			//DEL_Obj = null; 
			IsPlatform = false;				//reste our platform flag
			IsPlatform = RTIds.contains(a.RecordTypeId);	//is the deleted object a platform?
			//system.debug(IsPlatform);
			if (IsPlatform){							//YES, it's a Plaform
				DEL_Obj.Object_Type__c = 'Platform';	//tag the single instance object as a Platform
			} else {									//NO it's an Account
				DEL_Obj.Object_Type__c = 'Account';		//tag the single instance as an Account
			}
			DEL_Obj.Name = a.name;					//populate the rest of the record...
			DEL_Obj.Deleted_Record_ID__c = a.Id;
			DEL_Accts.Add(DEL_Obj);					//and add it to a list.
			system.debug(DEL_Accts);
        }
        system.debug(DEL_Accts);
        insert DEL_Accts;							//insert the list into the database.
	}
}