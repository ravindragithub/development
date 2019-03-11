public class ContactUtilities {
	
	public void deactivateUsers(list<Contact> contactList){
		map<Id, Contact> contactMap = new map<Id, Contact>(contactList);			//convert to map to deduplicate
		for(Contact c : contactMap.values()){
			if(c.Inactive_Contact__c != true){										//Process Contacts in Map
				system.debug('Removing Contact from Map : ' + c);
				contactMap.remove(c.Id);											//remove Contacts that are still active!
			}
		}
		List<User> usersToDisable = new list<User>();								//setup a list of Users to Update (Portal Users!)
		usersToDisable = [SELECT Id FROM User 										//Query for a list of User Ids...
							WHERE contactId IN :contactMap.KeySet() 				//Based on the triggered Contacts...
							AND uas__Sync_to_Contact__c = false];					//Deal with uas Managed Pkg carefully!
		map<Id, User> userMap = new map<Id, User>(usersToDisable);					//Convert to map so we can get a set of Ids
		if (userMap.size() != 0){													//if there are any users to be updated...
			deactivateUsersFuture(userMap.KeySet());							//call the future method (cross your fingers!)
		}
	}
	
	@future
	static void deactivateUsersFuture(set<Id> contactIdSet){
		system.debug(contactIdSet);
		List<User> usersToDisable = new list<User>();								//setup a list of User to Update (Portal Users!)
		for (User u : [SELECT Id, IsPortalEnabled, IsActive, ContactId FROM User 	//Use SOQL a FOR loop...
						WHERE Id IN :contactIdSet AND isActive = true]){			//and exclude inActive Users
			User portalUser = new User();											//create a new User sObject...
			portalUser.Id = u.Id;													//clone the current iteration..
			portalUser.IsPortalEnabled = false;										//turn off portal user flag...
			portalUser.IsActive = false;											//set to inActive...
			portalUser.myKVH_Manual_Push__c = true;									//trigger that Outbound Message workflow
			usersToDisable.add(portalUser);											//Add to disable List!
		}
		update usersToDisable;														//Update the list!
	}
	
}