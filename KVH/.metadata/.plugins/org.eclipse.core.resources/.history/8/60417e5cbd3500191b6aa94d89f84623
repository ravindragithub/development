global class EquipmentBatch2 implements Database.Batchable<Sobject>{
	//This batch job selects all Platforms that "Has_V3", "Has_V7", "Has_V11", "Has_ACU__c", "Has_ICM__c", "Has_IPACU__c", or "Has_MediaServer__c" flags set,
	//and updates the Platform's hierarchy (to the top) with the same field values without making any changes to the Platform Acct
	
	// Need a global "bubble up" method, 
	// Input params are Platform Account and Parent, Grand-Parent, etc...
	// returns Account (Parent, Grand-parent etc...)
	global Account BubbleUp(Account Child, Account Ancestor){
		if (Child.Has_V3__c ==  true){		// antennas first...
			Ancestor.Has_V3__c = true;
		}
		if (Child.Has_V7__c ==  true){
			Ancestor.Has_V7__c = true;
		}
		if (Child.Has_V11__c ==  true){
			Ancestor.Has_V11__c = true;
		}
		if (Child.Has_ACU__c ==  true){		// then below decks eq
			Ancestor.Has_ACU__c = true;
		}
		if (Child.Has_IPACU__c ==  true){
			Ancestor.Has_IPACU__c = true;
		}
		if (Child.Has_ICM__c ==  true){
			Ancestor.Has_ICM__c = true;
		}
		if (Child.Has_MediaServer__c ==  true){
			Ancestor.Has_MediaServer__c = true;
		}
		system.debug('Field Values Bubbled up to Account : ' + Ancestor);
		return Ancestor;
	}
	
	// START
	global Database.Querylocator start(Database.BatchableContext context) {
		system.debug('*** starting EquipmentBatch2 ***');
		return Database.getQueryLocator([SELECT Id, Name, Has_V3__c, Has_V7__c, Has_V11__c, Has_ACU__c, Has_ICM__c, Has_IPACU__c, Has_MediaServer__c,
												Parent.Id,				//Level 1
												Parent.Parent.Id,			//Level 2
												Parent.Parent.Parent.Id,			//Level 3
												Parent.Parent.Parent.Parent.Id,		//Level 4
												Parent.Parent.Parent.Parent.Parent.Id	//Level 5
										FROM Account
						WHERE (Has_V3__c = true OR Has_V7__c = true OR Has_V11__c = true OR Has_ACU__c = true OR Has_ICM__c = true OR Has_IPACU__c = true OR Has_MediaServer__c = true) 
						AND RecordType.DeveloperName LIKE 'Platform%']);
		//This query appears to run OK in workbench, and also seems to cover even the deepest of hierarchies
	}
	// EXECUTE
	global void execute(Database.BatchableContext context, List<Sobject> scope){
		system.debug('*** execute ***');
		List<Account> acctList = new List<Account>();				//Need a list of Accounts to update....
		Map<Id, Account> acctMap = new Map<Id, Account>();			//use a Map for de-duping...
		
		for (Sobject rec : scope){									//popuate the de-duping map...with empty shell accounts...
			Account thePlatform = (Account)rec;								//Type conversion required from sObject to Account....
			// LEVEL 1
			if(thePlatform.Parent.Id != null){								//Does the Platform have a Parent? (It *really* should!!)
				Account acct = new Account(id = thePlatform.Parent.Id);		//create the shell account, level 1
				acctMap.put(thePlatform.Parent.Id, acct);					//add to Map... duplicate Ids get overwritten.
				system.debug('Level 1 Acct: '+ acct);
			}
			//LEVEL 2
			if(thePlatform.Parent.Parent.Id != null){								//Does the Billing Acct have a Parent? 
				Account acct = new Account(id = thePlatform.Parent.Parent.Id);		//create the shell account, level 2
				acctMap.put(thePlatform.Parent.Parent.Id, acct);					//add to Map... duplicate Ids get overwritten.
				system.debug('Level 2 Acct: '+ acct);
			}
			//LEVEL 3
			if(thePlatform.Parent.Parent.Parent.Id != null){							//Does this Acct have a Parent? 
				Account acct = new Account(id = thePlatform.Parent.Parent.Parent.Id);	//create the shell account, level 3
				acctMap.put(thePlatform.Parent.Parent.Parent.Id, acct);					//add to Map... duplicate Ids get overwritten.
				system.debug('Level 3 Acct: '+ acct);
			}
			//LEVEL 4
			if(thePlatform.Parent.Parent.Parent.Parent.Id != null){								//Does this Acct have a Parent? 
				Account acct = new Account(id = thePlatform.Parent.Parent.Parent.Parent.Id);	//create the shell account, level 4
				acctMap.put(thePlatform.Parent.Parent.Parent.Parent.Id, acct);					//add to Map... duplicate Ids get overwritten.
				system.debug('Level 4 Acct: '+ acct);
			}
			//LEVEL 5
			if(thePlatform.Parent.Parent.Parent.Parent.Parent.Id != null){								//Does this Acct have a Parent? 
				Account acct = new Account(id = thePlatform.Parent.Parent.Parent.Parent.Parent.Id);		//create the shell account, level 5
				acctMap.put(thePlatform.Parent.Parent.Parent.Parent.Parent.Id, acct);					//add to Map... duplicate Ids get overwritten.
				system.debug('Level 5 Acct: '+ acct);
			}
		} //end For
		//de-dupe map complete! Now to bubble up...
		for (Sobject rec : Scope){
			Account thePlatform = (Account)rec;
			// LEVEL 1
			if (thePlatform.Parent.Id != null){	
				Account lvl_1 = acctMap.get(thePlatform.Parent.Id);
				lvl_1 = BubbleUp(thePlatform, lvl_1);
				acctMap.put(thePlatform.Parent.Id, lvl_1);
				system.debug('Modified Level 1 Account : ' + acctMap.get(thePlatform.Parent.Id));
			}
			// LEVEL 2
			if (thePlatform.Parent.Parent.Id != null){	
				Account lvl_2 = acctMap.get(thePlatform.Parent.Parent.Id);
				lvl_2 = BubbleUp(thePlatform, lvl_2);
				acctMap.put(thePlatform.Parent.Parent.Id, lvl_2);
				system.debug('Modified Level 2 Account : ' + acctMap.get(thePlatform.Parent.Parent.Id));
			}
			// LEVEL 3
			if (thePlatform.Parent.Parent.Parent.Id != null){	
				Account lvl_3 = acctMap.get(thePlatform.Parent.Parent.Parent.Id);
				lvl_3 = BubbleUp(thePlatform, lvl_3);
				acctMap.put(thePlatform.Parent.Parent.Parent.Id, lvl_3);
				system.debug('Modified Level 3 Account : ' + acctMap.get(thePlatform.Parent.Parent.Parent.Id));
			}
			// LEVEL 4
			if (thePlatform.Parent.Parent.Parent.Parent.Id != null){	
				Account lvl_4 = acctMap.get(thePlatform.Parent.Parent.Parent.Parent.Id);
				lvl_4 = BubbleUp(thePlatform, lvl_4);
				acctMap.put(thePlatform.Parent.Parent.Parent.Parent.Id, lvl_4);
				system.debug('Modified Level 4 Account : ' + acctMap.get(thePlatform.Parent.Parent.Parent.Parent.Id));
			}
			// LEVEL 5
			if (thePlatform.Parent.Parent.Parent.Parent.Parent.Id != null){	
				Account lvl_5 = acctMap.get(thePlatform.Parent.Parent.Parent.Parent.Parent.Id);
				lvl_5 = BubbleUp(thePlatform, lvl_5);
				acctMap.put(thePlatform.Parent.Parent.Parent.Parent.Parent.Id, lvl_5);
				system.debug('Modified Level 5 Account : ' + acctMap.get(thePlatform.Parent.Parent.Parent.Parent.Parent.Id));
			}
		}
		acctList = acctMap.values();
		system.debug(acctList);
		system.debug(acctList.size());
		update acctList;
	}
	// FINISH
	global void finish(Database.BatchableContext context){
		system.debug('*** finish ***');
	}
}