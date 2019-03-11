public with sharing class AccountTriggerHandler {
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    
    public AccountTriggerHandler(boolean isExecuting, Integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    public void OnBeforeInsert(List<Account> newAccounts){
        // EXECUTE BEFORE INSERT LOGIC
        //Probably need to start by identifying the "Platform" Record Types
        //by design, the RecordType.DeveloperName *MUST* start with 'Platform'
        Set<Id> RTIds = new Set<Id>();
        for (RecordType RT : [SELECT id, DeveloperName FROM RecordType WHERE DeveloperName LIKE 'Platform%']){
            RTIds.Add(RT.Id);
        }
        System.debug(RTIds); //This set contains all the "Platform" Record Type Ids.
        
        Boolean IsPlatform = false;
        
        for (Account a : newAccounts){
            IsPlatform = false;
            system.debug(IsPlatform);
            system.debug(a.RecordTypeId);
            IsPlatform = RTIds.contains(a.RecordTypeId);
            system.debug(IsPlatform);
            if (IsPlatform){ //012f00000008WDsAAM = Vessel-Maritime (in the sandbox anyway!) for example 
                a.BillingCountry = 'Platform';
            }
        }
    }

    public void OnAfterInsert(List<Account> newAccounts){
        // EXECUTE AFTER INSERT LOGIC
    }

    public void OnBeforeUpdate(List<Account> oldObjects, List<Account> updatedObjects, Map<ID, Account> ObjectMap){
        // BEFORE UPDATE LOGIC
    }

    public void OnAfterUpdate(List<Account> oldObjects, List<Account> updatedObjects, Map<ID, Account> ObjectMap){
        // AFTER UPDATE LOGIC
        /*need to force an update to myKVH_Parent_Account__c
          FOR this.account and all platform children
          Workflow normally takes care of this*/
        //Need a list of Accounts to update...
        List<Account> Children = new List<Account>();
        for (Account FoundChildren : [SELECT id, ParentId, Name, Send_to_myKVH_Physical__c,
        								myKVH_Parent_Account__c, 
        								myKVH_Parent_Automatic_Selection__c,
        								myKVH_Parent_Manual_Selection__c,
        								myKVH_Parent_Override__c,
        								myKVH_Element_Count__c
        						FROM Account
        						WHERE ParentId IN :updatedObjects]){
        	system.debug(FoundChildren.myKVH_Parent_Automatic_Selection__c +':'+FoundChildren.myKVH_Parent_Account__c);
        	Children.add(FoundChildren);
        }
        try {
        	update Children;
        }
        catch (system.Dmlexception e){
        	for (Integer i = 0; i < e.getNumDml(); i++) {
        		// Process exception here
        		System.debug(e.getDmlMessage(i)); 
    		}
        }
    }

    public void OnBeforeDelete(List<Account> ObjectsToDelete, Map<ID, Account> ObjectMap){
        // BEFORE DELETE LOGIC
        system.debug('entering on before delete handler...');
		// need to find the deleted Accounts, identify which ones go to myKVH,
        // and segregate the Platforms
        // start with a set of Platform record IDs
        // by design, the RecordType.DeveloperName *MUST* start with 'Platform'
		Set<Id> RTIds = new Set<Id>();
		for (RecordType RT : [SELECT id, DeveloperName FROM RecordType WHERE DeveloperName LIKE 'Platform%']){
			RTIds.Add(RT.Id);
		}
		System.debug(RTIds); //This set contains all the "Platform" Record Type Ids.
		Boolean IsPlatform = false;	//need a platform flag....
		List<myKVH_Deleted_Records__c> DEL_Accts = new List<myKVH_Deleted_Records__c>();
		//Need to make a list of myKVH_Deleted_Records__c...
		for (Account a : ObjectsToDelete){	// Loop through the deletedObjects and add them to the list
			IsPlatform = false;				//reset our platform flag
			system.debug(a);
			if (a.Send_to_myKVH_Physical__c){ //This record is in myKVH... need to send the message!
				IsPlatform = RTIds.contains(a.RecordTypeId);	//is the deleted object a platform?
				system.debug(a.RecordTypeId);
				system.debug(IsPlatform);
				if (IsPlatform){							//YES, it's a Plaform
					DEL_Accts.Add(new myKVH_Deleted_Records__c(Object_Type__c = 'Platform',
																Name = a.Name,
																Deleted_Record_ID__c = a.Id));
				} else {									//NO it's an Account
					DEL_Accts.Add(new myKVH_Deleted_Records__c(Object_Type__c = 'Account',
																Name = a.Name,
																Deleted_Record_ID__c = a.Id));
				}
				system.debug(DEL_Accts);					//and add it to a list.
			}
        }
        insert DEL_Accts;							//insert the list into the database.
    }

    public void OnAfterDelete(List<Account> deletedObjects, Map<ID, Account> ObjectMap){
		// AFTER DELETE LOGIC
    }

    public void OnUndelete(List<Account> restoredObjects){
        // AFTER UNDELETE LOGIC
    }

    public boolean IsTriggerContext{
        get{ return m_isExecuting;}
    }
}