public class AssetBeforeInsertTriggerHandler extends TriggerHandlerBase { 
	/* In the before insert context, no Assets will have children. This is simply due to the fact that,
	 * Before being Inserted to the database, the Asset does not have a record Id that a child can reference.
	 * As such, there is no need to deal with cascading the Root Assets Account to the whole hierarchy.
	 */
	
	public override void mainEntry(TriggerParameters tp) { 
		system.debug('Entering AssetBeforeInsertTriggerHandler.mainEntry....'); 
		AssetTriggerStatics.addRootToMap(tp.newList);	//Get the Assets roots.... don't need to populate the Hierarchies map
		/*FIRST*/
		AssumeParentAccount();							//This method ensures that new additions to an Asset hierarchy will have the Root Assets Account
														//this ensures that the Asset appears on the Account detail page Asset Related List
		/*SECOND*/
		PopulateRootField();							//This method automatically populates the Root Asset Field 
		
		
	}
	
	public override void inProgressEntry(TriggerParameters tp) {
		system.debug('Entering AssetBeforeInsertTriggerHandler.inProgressEntry....');
		system.debug('This is an example for reentrant code...');
	}
	
	/** The methods below are where the actual work for the trigger gets done.
	 *
	 */
	 
	private static void AssumeParentAccount(){ //In an Insert Context, the Asset will not have any Childern... no need to cascade down through the Hierarchy.
		// AssetTriggerHandler.BIG_PopulateModemIP(newAssets); // It's in the original trigger... not too sure what it does. Related to Install and Configs..
		//This method ensures that new additions to an Asset hierarchy will have the Root Assets Account
		//this ensures that the Asset appears on the Account detail page Asset Related List
		for(Asset a : (List<Asset>)trigger.new){
			//system.debug('Iteration : ' + a.Name +' Parent ID : ' + a.Parent_Asset__c);
			if(a.Parent_Asset__c != null){								//This "triggered" Asset has a Parent Asset! Must assume that Parent Asset's AccountId
				a.AccountId = AssetTriggerStatics.RootsMap.get(a.Id).AccountId;
			} else {
				//system.debug('Triggered Asset has no Parent Asset (is Root!)');
			}
		}
	}
	
	private static void PopulateRootField(){
		//This method automatically populates the Root Asset Field 
		for(Asset a : (List<Asset>)trigger.new){
			if(a.Parent_Asset__c != null){								//This "triggered" Asset has a Parent Asset! Must Populate the Root Asset Field!
				a.Root_Asset__c = AssetTriggerStatics.RootsMap.get(a.Id).Id;
			} else {
				//system.debug('Triggered Asset has no Parent Asset (is Root!)');
			}
		}
	}
	
}