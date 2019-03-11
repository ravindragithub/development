/* State machine details
 * State = 1: Collect Email and execute search
 * State = 2: Found 1 or more contacts and 0 Users
 * State = 3: Found 0 contacts and 0 Users. Collect New User details
 * State = 4: New User details validated successfully. Collect Fleet visibility selection
 * State = 5: New User successfully added
 */
 public class myKVH_add_new_User_ctrlEXT extends myKVH_User_Management_Base{ 
	private static final string ProductionOrgId = '00D30000000pQ0zEAE'; 				//Like *REALLY* Static!
	
	CountryStateMethods util = New CountryStateMethods();       //Helper Class
	public list<SelectOption> CountriesList = New list<SelectOption>();                     //List of Country Names for Subscriber Picklist
    public list<SelectOption> StatesList = New list<SelectOption>();                            //List of State Names for Subscriber Picklist
   
	//Class variables
	//state control...
	public integer state {get;set;}
	public Boolean saveDisabled {get;set;} 
	public Boolean searchCompleted {get;set;}
	public Boolean hasErrors = false;
	//exception handling
	public Boolean showPageMessages {get;set;}
	//Input Output data
	//public User currentUser {get;set;}													//Currently logged in User (moved to Base Class)
	//public list<AccountStructure.ObjectStructureMap> newUserAcctHierarchyRaw {get;set;}	//this might not get surfaced...(moved to Base Class)
	//public list<AccountStructure.ObjectStructureMap> newUserAcctHierarchy {get;set;}	//this might not get surfaced...(moved to Base Class)
	public list<User> foundUsers = new list<User>();									//Add a duplicate username for testing purposes....
	public list<Contact> foundContacts {get; set;}										//search results
	//public myKVH_Contact__c myKVHContact {get;set;}									//staging sObject for Contact/User creation (moved to Base Class)
	//public String fleetId {get;set;}													//converts to Contact.AccountId, controls Fleet visibility(moved to base controller)
	//public Contact SFContact {get;set;}
	public String contactId {get;set;}													//Used when search returns Contact(s) but not Users
	public Boolean next2Disabled {get;set;}												//Controls state 2 next button enabled/disabled
	public User newUser {get;set;}

	//Constructor
	public myKVH_add_new_User_ctrlEXT(){
		showPageMessages = true;
        CountriesList = util.setupCountryPicklist();
        StatesList = util.setupStatesPicklist();
		resetPage();
	}
	//getters setters 
	public Boolean gethasErrors(){
		hasErrors = ApexPages.hasMessages(ApexPages.severity.FATAL);
		return hasErrors;
	}
	
	public list<Contact> getfoundContacts(){
		return foundContacts;
	}
	private void setfoundContacts(string queryParam){
		//string SelectClause = 'SELECT Id, FirstName, LastName, Name, Email, Phone, MobilePhone, AccountId, Account.Name, Job_Function__c, Receive_Network_Service_Notifications__c, Network_Outage_Type__c FROM Contact ';
		string WhereClause = 'WHERE Email =: queryParam';
		if(UserInfo.getOrganizationId() == ProductionOrgId){				//If we are in the PRoduction Org...
			WhereClause += ' AND isTestUser__c = false';					//filter out the test users!
		}
		system.debug('Query string: ' + ContactSelect + WhereClause); 
		foundContacts = Database.query(ContactSelect + WhereClause);
	}
	
	public Contact getSFContact(){
		return SFContact;
	}
	private void setSFContact(string conId){
		map<Id,Contact> contactMap = new map<Id,Contact>(foundContacts);	//create lookup map
		SFContact = contactMap.get(conId);
		myKVHContact = populateActivationContact(SFContact);
	}
	public list<User> getfoundUsers(){
		return foundUsers;
	}
	private void setfoundUsers(string queryParam){
		foundUsers = [SELECT Id, username, lastName, firstName, Contact.AccountId FROM User WHERE username =: queryParam];	//search (query, really)....
	}
	//getters setters and change handlers for picklists....
	public list<SelectOption> getCountriesList(){
        return CountriesList;
    }
    public list<SelectOption> getStatesList(){
        return StatesList;
    }
    //picklist change handlers
    public void componentCountryChangeHandler(){
        StatesList = util.CountryChangeHandler(myKVHContact.Country__c, myKVHContact.State_Province__c); 
    }
    public void componentStateChangeHandler(){
        system.debug('Invoking State Change handler....');
    }

	// Page Methods
	public void resetPage(){
		state = 1;
		saveDisabled = true;
		next2Disabled = true;
		searchCompleted = false;
		
		myKVHContact = new myKVH_Contact__c();
		foundContacts = new list<Contact>();
		foundUsers = new list<User>();
		fleetId = '';
	}
	
	public void searchUsers(){						//This method populates the Found Users list
		if(myKVHContact.Email__c != null){															//make sure we have a search param...
			setfoundUsers(myKVHContact.Email__c);														//search (query, really)....
		}
		analyzeFoundUsers();																		//analyze results
	}
	public void analyzeFoundUsers(){				//This encapsulated method allows for complete testing
		//setup error and warning message relative to this state. 
		ApexPages.Message ExistingUser = new ApexPages.Message(ApexPages.severity.FATAL,
														 'A User with this username already exists. Please click Search Again.', 
														 'A User with this username already exists.');
		if(foundUsers.size() == 0){																	//username not found....
			searchContacts();																		//so search contacts!
		} else if (foundUsers.size() > 1){															//found duplicate username! (tough to test!)
			string caseNum = createCase('Found > 1 Users with username = ' + myKVHContact.Email__c);	//should NEVER happen!!!
			ApexPages.addMessage(ExistingUser);														//notify User
			searchCompleted = true;
		} else {																					//found 1 user with that name...
			newUser = foundUsers[0];																//assign to newUser variable
			map<Id, Account> acctMap = getHierarchicalAccountMap(myKVHHierarchy);				//search the current users hierarchy
			if(acctMap.containsKey(newUser.Contact.AccountId)){										//NOT out of bounds...
				ApexPages.addMessage(ExistingUser);													//but the user is already provisioned! (notify)
				searchCompleted = true;																//set search completed flag.
			} else {
				newUser.clear();																	//clear that newUSer varaible! 
				string caseNum = createCase('Portal User tried to create out-of-bounds User : ' + myKVHContact.Email__c);//open a case out of bounds user
				ApexPages.addMessage(ExistingUser);													//notify current User
				searchCompleted = true;																//set search completed flag.
			}
		}
	}
	
	public void searchContacts(){
		//setup error and warning message relative to this state. 
		ApexPages.Message DuplicateContacts = new ApexPages.Message(ApexPages.severity.WARNING,
														 'There is more than one Contact with this E-mail address.', 
														 'There is more than one Contact with this E-mail address.');
		ApexPages.Message OOBContact = new ApexPages.Message(ApexPages.severity.FATAL,
														 'The UserName that you searched for is not available. myKVH Support has been notified of your intentions and will be in contact to help you.', 
														 'This Contact already exists, but you do not have access to it.');
		map<Id, Account> acctMap = getHierarchicalAccountMap(myKVHHierarchy);						//our "not" out of bounds Accounts
		if(myKVHContact.Email__c != null){
			/*foundContacts = [SELECT Id, FirstName, LastName, Name, Email, Phone, MobilePhone, AccountId, Account.Name, 
										Job_Function__c, Receive_Network_Service_Notifications__c 
							FROM Contact 
							WHERE Email =: myKVHContact.Email__c];*/
			setfoundContacts(myKVHContact.Email__c);
			if(foundContacts.size() == 0){																//ZERO contacts...
				searchCompleted = true;
				next();																					//proceed to next state!
			} else if (foundContacts.size() > 1){														//More than 1 Contact....
				string caseNum = createCase('Found ' + foundContacts.size() + ' Contacts with Email = ' + myKVHContact.Email__c);//open a ServCloud Case
				list<Contact> ContactsToKeep = new list<Contact>();										//To remove elements while iterating a list, create a new list, then copy the elements you wish to keep
				for (integer i = 0; i < foundContacts.size(); i++){										//loop through the found Contacts by INDEX!! 
					system.debug('Start Loop iteration ' + i );
					if(acctMap.containsKey(foundContacts[i].AccountId)){								//if within hierarchy bounds...
						system.debug(foundContacts[i] + ' is OK to present to Current User!');
						ContactsToKeep.add(foundContacts[i]);											//add it to the "keep" list...
					}
				}
				foundContacts.clear();																	//Clear and then...
				foundContacts = ContactsToKeep;															//reset foundContacts list...
				if (foundContacts.size() > 1){															//if there is STILL more than one contact!
					ApexPages.addMessage(DuplicateContacts);
				} else if (foundContacts.size() == 0){
					ApexPages.addMessage(OOBContact);													//found only OOB contacts...
				} else {
					next();																				//just one Contact left... proceed to next state
				}
				
				searchCompleted = true;
			} else {										//Only 1 Contact
				if(!acctMap.containsKey(foundContacts[0].AccountId)){									//if NOT within hierarchy bounds
					string caseNum = createCase(' tried to re-create Out of Bounds user ' + foundContacts[0].Email);//open a ServCloud Case
					foundContacts.remove(0);
					ApexPages.addMessage(OOBContact);
				} else {
					next();
				}								
				searchCompleted = true;
			}
		}
	}
	
	public PageReference createUserFromContact(){
		PageReference returnPage = page.Manage_myKVH_Users;
		insert myKVHContact;															//This is simply serves as a record of User actions - not required for workflow
		User pUser = createPortalUser(myKVHContact.Contact__c);						//this creates User sObject from Contact, but this does not insert record...
		ID jobID = System.enqueueJob(new createUser(pUser, currentUser));						//Insert the User and reset password, asynchonously! TODO?? bulkify 
		state = 5;																		//Proceed to final state
		return null;
	}
	
	public PageReference createContactUser(){		//Maybe we return User ID or something....
		//PageReference returnPage = page.Manage_myKVH_Users;
		myKVHContact.Account__c = fleetId;			//associate staging object with Account ID (it's still text!!)
		insert myKVHContact;							//insert staging sObject
		list<myKVH_Contact__c> myKVHContactList = new list<myKVH_Contact__c>();
		myKVHContactList.add(myKVHContact);
		ActivationOrderUtilities Util = new ActivationOrderUtilities();
		Database.SaveResult[] sr = Util.ConvertContact(myKVHContactList);
		for(Integer i=0; i<sr.size(); i++){
			if (sr[i].isSuccess()){
				// Operation was successful, so get the ID of the record that was processed
				Id successId = sr[i].getId();												//We will use the successId a few times...
				System.debug('Successfully inserted Contact. Contact ID: ' + successId);	//once in a debug...
				myKVHContactList[i].Contact__c = successId;									//then to update the Activation sObject...
				User pUser = createPortalUser(successId);									//then to create User sObject, but this does not insert record...
				ID jobID = System.enqueueJob(new createUser(pUser, currentUser));						//Insert the User and reset password, asynchonously! TODO bulkify
			} else {
				// Operation failed, so get all errors                
				for(Database.Error err : sr[i].getErrors()) {
					System.debug('The following error has occurred.');                    
					System.debug(err.getStatusCode() + ': ' + err.getMessage());
					System.debug('Account fields that affected this error: ' + err.getFields());
					//create Case?
				}
			}
		}
		update myKVHContactList;
		next();
		return null;								//go home? maybe to manage Users Page?
		//create user
	}
	public User createPortalUser(Id portalContactId){					//Creates User from Contact, but does not insert record
		//Need Portal Profile, myKVH Role... get from Custom Setting
		Contact portalContact = [SELECT Id, Name, FirstName, LastName, email FROM Contact WHERE Id =: portalContactId LIMIT 1];
		myKVH_new_User_Defaults__c defaultSettings = myKVH_new_User_Defaults__c.getValues('DirectCustomerDefaults'); 
		system.debug(defaultSettings);
		User userToCreate = new User();
		userToCreate.ProfileId = defaultSettings.SF_Profile_Id__c;			//set default profile first...
		userToCreate.myKVH_Role__c = defaultSettings.myKVH_Role_Id__c;		//set default myKVH role first...
		userToCreate.ContactId = PortalContact.Id;
		userToCreate.username = portalContact.email;
		userToCreate.email = portalContact.email;
		userToCreate.LastName = portalContact.LastName;
		userToCreate.FirstName = portalContact.FirstName;
		userToCreate.EmailEncodingKey = 'UTF-8';
		userToCreate.alias = portalContact.FirstName.substring(0,1) + portalContact.LastName.substring(0,math.min(7,portalContact.LastName.length()));
		userToCreate.communityNickname = portalContact.LastName + '_'+ Math.random();
		//Copy Current Users details for a few attributes....
		userToCreate.LocaleSidKey = UserInfo.getLocale();
		userToCreate.LanguageLocaleKey = UserInfo.getLanguage();
		userToCreate.TimeZoneSidKey = UserInfo.getTimeZone().getId();
		userToCreate = assignRoleAndProfile(userToCreate, currentUser);
		return userToCreate;
	}
	@testVisible private User assignRoleAndProfile(User newUser, User currentUser){
		//determine the Account relationships between the two Users,
		//assign the Profile and Role accordingly
		//and return an updated User
		Id newUserAccountId;
		if (newUser.Contact.AccountId != null){		//Need to handle newly created Contact/User
			newUserAccountId = newUser.Contact.AccountId;
		} else {
			system.debug('New User Contact: ' + newUser.ContactId);
			list<Contact> contactList = [SELECT AccountId FROM Contact WHERE Id =: newUser.ContactId LIMIT 1];
			newUserAccountId = contactList[0].AccountId;
		}
		system.debug('New User Account: ' + newUserAccountId);
		system.debug('Current User Account: ' + currentUser.Contact.AccountId);
		map<User, Account> userAccountMap = new map<User, Account>();
		for (Account a : [SELECT Id, Name, RecordType.DeveloperName, 
								 Parent.RecordType.DeveloperName, 
								 Parent.Parent.RecordType.DeveloperName 
						  FROM Account 
						  WHERE Id =: newUserAccountId OR id =: currentUser.Contact.AccountId]){ //Should be either one or two, yes?
			system.debug('loooping over Account: ' + a.Name);
			if(a.Id == newUserAccountId){
				userAccountMap.put(newUser, a);
				system.debug('Mapping ' + newUser.username + ' to Account ' + a.name);
			}	//NO else!! regardless of list size, we get to map entries!
			if(a.Id == currentUser.Contact.AccountId){
				userAccountMap.put(currentUser, a);
				system.debug('Mapping ' + currentUser.username + ' to Account ' + a.name);
			}
		}
		//map setup complete... on to logic! Need an Account var and a Cust of Svc Provider settings var
		Account newUsersAcct = userAccountMap.get(newUser);
		myKVH_new_User_Defaults__c indirectSettings = myKVH_new_User_Defaults__c.getValues('CustomerOfServiceProviderDefaults');
		//Five decisions and Two outcomes, Gee Whiz!!
		if (newUsersAcct.Id == userAccountMap.get(currentUser).Id){					//New user has same Account as Current User!
			newUser.ProfileId = currentUser.ProfileId;
			newUser.myKVH_Role__c = currentUser.myKVH_Role__c;
		} else if (newUsersAcct.RecordType.DeveloperName.left(8) == 'Indirect'){	//Customer of Service Provider!
			newUser.ProfileId = indirectSettings.SF_Profile_Id__c;
			newUser.myKVH_Role__c = indirectSettings.myKVH_Role_Id__c;
		} else if (newUsersAcct.RecordType.DeveloperName.left(9) == 'Platform_'){	//Shipboard User
			if (newUsersAcct.parent.parent.RecordType.DeveloperName != null && newUsersAcct.parent.parent.RecordType.DeveloperName.left(8) == 'Indirect'){
				//Has a grandparent... an INDIRECT Customer Grandparent
				newUser.ProfileId = indirectSettings.SF_Profile_Id__c;
				newUser.myKVH_Role__c = indirectSettings.myKVH_Role_Id__c;
			} else if(newUsersAcct.parent.RecordType.DeveloperName != null && newUsersAcct.parent.RecordType.DeveloperName.left(8) == 'Indirect' ){
				newUser.ProfileId = indirectSettings.SF_Profile_Id__c;
				newUser.myKVH_Role__c = indirectSettings.myKVH_Role_Id__c;
			} else {
				newUser.ProfileId = currentUser.ProfileId;
				newUser.myKVH_Role__c = currentUser.myKVH_Role__c;
			}
		} else {	//default
			newUser.ProfileId = currentUser.ProfileId;
			newUser.myKVH_Role__c = currentUser.myKVH_Role__c;
		}
		return newUser;
	}
	
	public PageReference contactSelected(){										//invoked by Javascript
		if(contactId != null){													//User selected an existing Contact
			system.debug(contactId);
			setSFContact(contactId);
			myKVHContact = populateActivationContact(SFContact);			//populate Activation Contact INCLUDE Contact Id
			
			next2Disabled = false;												//allow next step
		} else {
			next2Disabled = true;
		}
		return null;
	}
	
	public map<Id, Account> getHierarchicalAccountMap(list<AccountStructure.ObjectStructureMap> userHierarchy){
		//returns entire Account hierarchy as an Account map
		map<Id, Account> returnMap = new map<Id, Account>();
		system.debug(userHierarchy);
		for(AccountStructure.ObjectStructureMap h : userHierarchy){
			returnMap.put(h.account.Id, h.account);
		}
		system.debug(returnMap);
		return returnMap;
	}
	private string createCase(string stateDetails){
		final Id ServCloudCase_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Cloud').getRecordTypeId();
		final Group SvcCloudQueue = [SELECT Id FROM Group WHERE DeveloperName = 'Service_Cloud_Queue' and Type = 'Queue'];
		Case newCase = new Case();
		newCase.RecordTypeId = ServCloudCase_RECORD_TYPE_ID;
		//newCase.ContactId = currentUser.ContactId;
		newCase.Subject = userInfo.getUserName() + ' ' + stateDetails;
		newCase.Origin = 'Web';
		newCase.Status = 'New';
		newCase.OwnerId = SvcCloudQueue.Id;
		insert newCase;
		system.debug(newCase); 
		//list<Case> caseList = [SELECT Id, Subject, CaseNumber FROM Case WHERE Id =:newCase.Id];			//Query results....
		//system.debug(caseList); 
		//return caseList[0].CaseNumber;
		return newCase.Id;
	}
	
	public void next(){																//state engine, forward direction
		state = state + 1;
		if(state == 2 &&  foundContacts.size() == 0){
			state = 3;
		}
		//Max state value...
		if(state == 6){
			state = 5;
		}
	}
	public void prev(){																//state engine, reverse direction
		state = state - 1;
		if(state == 3){
			saveDisabled = true;
		}
		if(state == 2 && foundContacts.size() == 0){
			state = 1;
		} else if(state ==2 && foundContacts.size() >= 1){
			next2Disabled = true;
		}
		if(state ==1){
			next2Disabled = true;
		}
		if(state == 0){
			state = 1;
		}
		
	}
	public class createUser implements Queueable{		//Queueable Class to avoid Mixed DML
		private User u = new User();					//Needs a User to create (should NOT have a record ID!)
		private User u2 = new User();					//and a reference user for next queued job!
		
		public createUser(User createdUser, User referenceUser){			//constructor, handles input parameter
			this.u = createdUser;						// "u" is visible to Class now.
			this.u2 = referenceUser;
		}
		public void execute(QueueableContext context){	//Mandatory Execute method
			insert u;									//insert the User won't work if there is a record ID! and upsert not allowed :(
			system.debug(u);							
			//ID jobID = System.enqueueJob(new updateRoleAndProfile(u, u2));						//Insert the User and reset password, asynchonously! TODO bulkify
			//system.resetPassword(u.Id, true);			//This line causes an UNKNOWN_EXCEPTION: SoOoO....
			resetmyKVHPassword(u.Id);					//send the email in an @future method!
		}
	}
	@future static void resetmyKVHPassword(Id uId){		//Asynch method to reset password
		system.resetPassword(uId, true);				//since we apparently can't do it from within the queueable execute method!
	}
	
	//Private Method test helpers
	public string testCreateCase(string stateDetails){								//public method for test purposes
		string returnString = 'You can only invoke this method from a Unit Test';	//default return value
		if(test.isRunningTest()){													//If we are unit testing... 
			returnString = createCase(stateDetails);								//invoke the Private method...
		}																			//which overwrites the default return value!
		return returnString;														//return the string!
	}
	public string testsetSFContact(string contacId){								//public method for test purposes
		string returnString = 'You can only invoke this method from a Unit Test';	//default return value
		if(test.isRunningTest()){													//If we are unit testing... 
			setSFContact(contacId);											//invoke the Private method...
			returnString = 'Tested setSFContact';								//a string to return...
		}																			//which overwrites the default return value!
		return returnString;														//return the string!
	}
}