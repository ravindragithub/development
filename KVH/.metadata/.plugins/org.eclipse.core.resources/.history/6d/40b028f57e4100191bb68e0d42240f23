public with sharing class ContactsController extends ActivationsBaseController{
	//Page attributes
	//public string ActivationOrderId;																	//should be a Q param with page request
	//public ActivationUtilities util = new ActivationUtilities();										//Utility Class with common methods
	public Activation_Status__c ActivationStatus {get;set;}												//Utility Class returns a list of Status Records
	public Activation_Contact__c newContact;
	public integer tabState {get;set;}																	//This is the tab that the User is on
	private integer MAX_TAB_STATE = 4;																	//How many tabs on the page??
	
	//Getters and Setters
	
	//Get does a query
	public Activation_Contact__c getnewContact(){		//reads contact details from the database
		system.debug('Invoking getnewContact'); 
		list<Activation_Contact__c> act_cons = [SELECT Id, Activation_Order__c 
													FROM Activation_Contact__c
													WHERE Activation_Order__c =: ActivationOrderId];
		if(act_cons.size() == 0){
			newContact = new Activation_Contact__c(Activation_Order__c = ActivationOrderId);//create a new subscriber
		} else {
			newContact = act_cons[0];
		}
		return newContact;
	}
	//Set creates or updates a record
	public void setnewContact(){						//commits contact(s) details to database TODO: make private w/helper test method
		system.debug('Invoking setnewContact');
		if(newContact.Id == null){						//need to insert record....
			insert newContact;
		} else {										//just need to update the record
			update newContact;
		}
	}
	//constructor
	public ContactsController(){
		system.debug('Invoking Contstructor....');
		ActivationOrderId = ApexPages.currentPage().getParameters().get('order');
		ActivationStatus = readActivationStatus(ActivationOrderId);
		ActivationStatus.Active_Page__c = 'Contacts';			//set Status
		//TODO refactor to correspond with new Activation Status sObject
		//ActivationStatus.Contacts_page__c = 'available';		//set Status
		//system.debug('Constructor Tab State: ' + ActivationStatus.Contact_Tab_State__c);
		//tabState = (integer)ActivationStatus.Contact_Tab_State__c;
	}
	//Navigation Methods
	public pageReference goNext(){		//Pass in an anchor reference??
		//Need to read state, update data, save state, and re-direct to next tab....
		ActivationStatus = readActivationStatus(ActivationOrderId);										//read current state
		//tabState = next((integer)ActivationStatus.Subscriber_Tab_State__c, MAX_TAB_STATE);				//
		//setnewSubscriber();																				//update record ....
		PageReference returnPage = goTab();																//return the page for re-load
		return returnPage; 
	}

	public pageReference goPrev(){
		//Need to read state, update data, save state, and re-direct to next tab....
		ActivationStatus = readActivationStatus(ActivationOrderId);										//read current state
		//tabState = prev((integer)ActivationStatus.Subscriber_Tab_State__c);								//
		//setnewSubscriber();																				//update record ....
		PageReference returnPage = goTab();																//return the page for re-load
		return returnPage; 																				//return the page for re-load
	}
	public pageReference goTab(){ 
		system.debug('Invoking goTab()...');
		//ActivationStatus.Contact_Tab_State__c = tabState;
		system.debug('Activation Status: ' + ActivationStatus);
		update ActivationStatus;																			//update the activation status
																											//update data too....
		PageReference returnPage = new PageReference('/apex/Contacts');									//setup return page
		returnPage.getParameters().put('order', ActivationOrderId);											//add the order ID
		returnPage.setAnchor('tab-' + string.valueOf(tabState));											//add the tab anchor local var
		returnPage.setRedirect(true);																		//get ready to go!
		system.debug('Page Tab: ' + tabState + ' Return Page: ' + returnPage.getURL());
		return returnPage;																					//return the page for re-load
	}
}