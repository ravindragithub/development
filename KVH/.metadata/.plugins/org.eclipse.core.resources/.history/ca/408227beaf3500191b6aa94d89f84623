public with sharing class ActivationOrderUtilities {
	//Need a method to ConvertToContact(myKVH_Contact__c) //bulkify....
	public list<Database.SaveResult> ConvertContact(list<myKVH_Contact__c> toConvert){
		//Do a little setup
		list<Database.SaveResult> Conversions = new list<Database.SaveResult>();				//instanciate return list
		set<Id> AcctIds = new set<Id>();														//instanciate a set to collect all the Account Ids (currently strings!)...
		for (myKVH_Contact__c ac : toConvert){												//start looping through the input list...
			AcctIds.add(ac.Account__c);															//adding Account Ids to the set as we go! (do this first!)
		}																						//Use the set to get the Account and Owner....
		list<Account> acctList = [SELECT Id, OwnerID FROM Account WHERE ID IN :AcctIds];		//get all the Account Owners and any other details../
		system.debug(acctList);
		map<Id, Account> acctMap = new map<Id, Account>(acctList);								//convert to map for easy lookup!
		//Start making Contacts!
		list<Contact> ContactsToInsert = new list<Contact>();									//instanciate the list we are going to insert
		for (myKVH_Contact__c ac : toConvert){												//start looping through the input list AGAIN!
			Contact c = new Contact();															//instanciate a new Contact
			c.OwnerId = acctMap.get(ac.Account__c).OwnerId;									//get value from Map
																								//Contact Owner is set via Workflow...
			system.debug('Contact Owner before insert: ' + c.OwnerId );
			c.AccountId = acctMap.get(ac.Account__c).Id;										//get value from Map
			c.FirstName = ac.First_Name__c;														//copy value from myKVH_Contact__c
			c.LastName = ac.Last_Name__c;														//copy value from myKVH_Contact__c
			c.Email = ac.Email__c;																//copy value from myKVH_Contact__c
			c.MobilePhone = ac.Mobile__c;														//copy value from myKVH_Contact__c
			c.Phone = ac.Phone__c;																//copy value from myKVH_Contact__c
			c.MailingCountry = ac.Country__c;                                               //Main Country must contain a value!
			c.MailingState = ac.State_Province__c;                                          //SOMETIMEs we need a state/province too!
			c.Receive_Network_Service_Notifications__c = ac.Receive_Network_Service_Notifications__c;	//copy value from myKVH_Contact__c
			c.Job_Function__c = ac.Job_Function__c;												//copy value from myKVH_Contact__c
			ContactsToInsert.add(c);
		}
		try{																					//wrap it up in a try-catch
			Conversions = Database.insert(ContactsToInsert, false);								//NOT an all-or-nothing transaction....
		} catch(Exception e){
			system.debug(e.getMessage());
			
		}
		//for debug purposes....
		list<Id> IdList = new list<Id>();
		for (Database.SaveResult sr : Conversions){
			if (sr.isSuccess()){
				IdList.add(sr.getId());
			}
		}
		list<Contact> cList = [SELECT Id, OwnerId FROM Contact WHERE Id in :IdList];
		system.debug(cList);
		return Conversions;
	}
}