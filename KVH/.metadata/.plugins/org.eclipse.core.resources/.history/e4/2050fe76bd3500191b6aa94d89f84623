global without sharing class SiteUtilities {	//must override sharing rule for Contact/Account/Hierarchy visibility (Guest User)
	global SiteUtilities () {}					//no arguement constructor....
	
	//Need a method to count the number of Platforms (Accounts) for a given Contact.AccountId (in AccountUtilities)
	//Since this class is run before the User is Authenticated, we need to run the Account Hierarchy, counting Platforms
	//WITHOUT sharing rules in place!
    global list<string> getFleetList(string UserId){							//returns a list of myKVH Platforms Ids (as strings) that a User can see
    	system.debug('Entering getFleetList method with User Id: ' + UserId);
    	Boolean endOfStructure = false;											//supports hierarchy engine
    	list<String> returnList = new list<String>();							//return list of Strings
    	User userDetails = new User();											//need to query Username for userDetails....
    	userDetails = [SELECT Id, username, ContactId, Contact.AccountId FROM User WHERE Id =: UserId LIMIT 1];
    	system.debug(userDetails.ContactId);
    	Contact cont = new Contact();											//need to query contact details in turn....
    	cont = [SELECT Id, AccountId FROM Contact WHERE Id =: userDetails.ContactId LIMIT 1];
    	system.debug(cont);
    	if (cont.AccountId != null){											//FIRST! make sure that we HAVE an Account ID!!
    		/*recreate hierarchy engine*/
			List<Account> al            = new List<Account>{};					//Accounts at a given hierarchy level...
			List<ID> currentParent      = new List<ID>{};						//current parent account (gets reset for every iteration)
			Integer level               = 0;									//Level counter... we really only need to know starting level
			currentParent.add(cont.AccountId);									//Start with the User's Account and drill down
    		while (!endofStructure){											//Tough to deal with hierarchical data without SOQL in a loop :(
    			if (level == 0){												//First iteration....
    				al = [SELECT Id, ParentId, Send_to_myKVH_Physical__c, RecordType.DeveloperName FROM Account WHERE Id IN : CurrentParent];
    			} else {														//all subsequent iterations.
    				al = [SELECT Id, ParentId, Send_to_myKVH_Physical__c, RecordType.DeveloperName FROM Account WHERE ParentId IN : CurrentParent];
    			}
    			if (al.size() == 0){											//Nothing returned from Query?
    				endOfStructure = true;										//Then we have hit bottom!
    			} else {														//Otherwise setup for another level iteration....
    				currentParent.clear();
    				for ( Integer i = 0 ; i < al.size(); i++){
    					Account a = al[i];
    					if (a.Send_to_myKVH_Physical__c && a.RecordType.DeveloperName.left(9) == 'Platform_'){	//must meet criteria!!
    						returnList.add(a.Id);								//If it does, add it to the return list!
    					}
    					currentParent.add( a.id );								//Add account to current parents list....
    				}
    			}
    			level ++;														//increment level and go again! (watch that SOQL limit!)
    		}
    		/*end of hierarchy engine*/
    	}
		system.debug(returnList);
    	return returnList;
    }
}