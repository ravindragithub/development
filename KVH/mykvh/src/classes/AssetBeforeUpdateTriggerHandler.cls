public with sharing class AssetBeforeUpdateTriggerHandler extends TriggerHandlerBase{
	/* In the before insert context, no Assets will have children. This is simply due to the fact that,
	 * Before being Inserted to the database, the Asset does not have a record Id that a child can reference.
	 * As such, there is no need to deal with cascading the Root Assets Account to the whole hierarchy.
	 */
	
	public override void mainEntry(TriggerParameters tp){
		system.debug('Entering AssetBeforeUpdateTriggerHandler.mainEntry....'); 
		
		/*FIRST*/
		BaaNIntegrationAccounts();						//This method prevents the BaaN Integration Program from overwriting existing Asset Account.
														//See Issue 25658
	}
	
	
	public override void inProgressEntry(TriggerParameters tp) {
		system.debug('Entering AssetBeforeUpdateTriggerHandler.inProgressEntry....');
		system.debug('This is an example for reentrant code...');
	}
	
	/** The methods below are where the actual work for the trigger gets done.
	 *
	 */
	private static void BaaNIntegrationAccounts(){
		//This method prevents the BaaN Integration Program from overwriting existing Asset Account.
		//See Issue 25658
	    System.debug('Entered myAssetTrigger');
	        
	    //List<Asset> newUpdatedAsset = new List<Asset>();
	    Map<String,String> assetAcctMap = new Map<String, String>();
	    
	    DefaultAccounts__c KUAssets = new DefaultAccounts__c();					//collect default Accounts data from Custom Settings....
	    KUAssets = DefaultAccounts__c.getInstance('DefaultAssets');				//"KVH Default Assets"
	    DefaultAccounts__c KE = new DefaultAccounts__c();
		KE = DefaultAccounts__c.getInstance('KVHEurope');						//"KVH Eurpoe A/S"
		
	   // In a before update trigger, the trigger access the records before
	   // updating trigger.new list.
	
	    for (Asset a : (List<Asset>)Trigger.new) {		//Need type conversion jthom 1/22/15
	            
	        System.debug('Entered myAssetTrigger at Trigger.new');
	        System.debug(' ID :' +a.Id);
	        System.debug(' AccountId: ' +a.AccountId);
	        System.debug(' Created by Integration: ' +a.Created_By_Integration__c);
	        System.debug(' Install Date: ' +a.InstallDate);
	        System.debug(' LastModifiedBy: ' +a.LastModifiedById); 
	        //Need to determine if the trigger is being invoke by the BaaN Integration Program....
	        if ( ((a.Created_By_Integration__c == true) && (a.InstallDate != null)) && (UserInfo.getUserId() == '00530000004UxCsAAK') ) {	//KVH Admin
				System.debug('Entered myAssetTrigger at condition created by integration'); 
	                            
                //Retreive the original and changed Asset from the Trigger Maps so we can compare....
                Asset oldAsset = (Asset)Trigger.oldMap.get(a.ID);    	//Need type conversion
                Asset newAsset = (Asset)Trigger.newMap.get(a.ID); 		//Need type conversion jthom 1/22/15

                //Retrieve the old and new account name            
                //Not needed, we can access the old and new Asset.AccountId directly with dot notation.
                //String oldAssetAcc = oldAsset.AccountId;
                //String newAssetAcc = newAsset.AccountId;

                System.debug('Old Asset.AccountId :' + oldAsset.AccountId);
                System.debug('New Asset.AccountId :' + newAsset.AccountId);
	                        
                //If the fields are different, the account has changed and not KVH Default account or KVH EUROPE A/S
                if (oldAsset.AccountId != newAsset.AccountId) {
                   if (oldAsset.AccountId != KUAssets.Account_ID__c) {						//KVH Default account 
                       if (oldAsset.AccountId != KE.Account_ID__c) {						//KVH EUROPE A/S
                            System.debug('Not matched Old :' + oldAsset.AccountId);
                            System.debug('Not matched New :' + newAsset.AccountId);
                            a.AccountId = oldAsset.AccountId;								//Set old account Id to new account Id (alters Trigger.New)
                            System.debug('Set Old Account  :' + oldAsset.AccountId);
                            //newUpdatedAsset.add(a);
                            System.debug('Asset Account overwrite prevented for :' + a);	//we can visualize.....
                       }
                    }
                }
	        }
	    }
	}
}