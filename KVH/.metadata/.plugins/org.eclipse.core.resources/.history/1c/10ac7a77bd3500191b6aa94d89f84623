public with sharing class SubscriberController extends ActivationsBaseController{
	//Page attributes
	public Activation_Subscriber__c newSubscriber;														//The purpose of this page is to create one of these!
																									//need two sets... subscriber and billing
	public list<SelectOption> SubscriberCountriesList = new list<SelectOption>();						//List of Country Names for Subscriber Picklist
	public list<SelectOption> SubscriberStatesList = new list<SelectOption>();							//List of State Names for Subscriber Picklist
	public list<SelectOption> BillingCountriesList = new list<SelectOption>();							//List of Country Names for Billing Picklist
	public list<SelectOption> BillingStatesList = new list<SelectOption>();								//List of State Names for Billing Picklist
	
	//don;t need these.....
	//public string SubscriberCountry {get;set;}			//ISO Code
	//public string SubscriberState {get;set;}			//Trimmed name....
	//public string BillingCountry {get; set;}			//ISO Code
	//public string BillingState {get;set;}				//Trimmed name....

	//Uses Custom Metadata Types.... KVH_Countries__mtd
	@TestVisible private map<String, KVH_Countries__mdt> CountryMap = new map<String, KVH_Countries__mdt>();					//Use to lookup Countries by ISO Code 2
	
	//Constructor
	public SubscriberController(){
		system.debug('Invoking Constructor....');
		ActivationOrderId = ApexPages.currentPage().getParameters().get('order');	//extract Order Id
		ActivationStatus = readActivationStatus(ActivationOrderId);					//get status record
		ActivationStatus.Active_Page__c = 'Subscriber';								//set Active Page 
		ActivationStatus.Subscriber_page__c = 'available';							//set Page Available Status
		If (ActivationStatus.Subscriber_Active_Tab__c == null){						//set Active tab
			system.debug('set default tab....');
			selectedTab = 'tab-1';
			ActivationStatus.Subscriber_Active_Tab__c = selectedTab;
		} else {
			system.debug('use saved tab....');
			selectedTab = ActivationStatus.Subscriber_Active_Tab__c;
		}
		system.debug('Constructor Tab State: ' + ActivationStatus.Subscriber_Active_Tab__c);
		newSubscriber = getnewSubscriber();											//read Subscriber data (if there is any!)
		buildCountryMap();
		SubscriberCountriesList = setSubscriberCountriesList(newSubscriber);
		SubscriberStatesList = setSubscriberStatesList(newSubscriber);
		BillingCountriesList = setBillingCountriesList(newSubscriber);
		BillingStatesList = setBillingStatesList(newSubscriber);
	}
	/*Country and State Picklist setup*/
	@testVisible private list<SelectOption> setSubscriberCountriesList(Activation_Subscriber__c subscriber){
		//SelectOption option = new SelectOption(value, label);
		list<SelectOption> returnList = new list<SelectOption>();
		system.debug('Invoking setSubscriberCountriesList with Subscriber: ' + subscriber);
		if(subscriber.Id == null){
			returnList = setupCountryPicklist();
		} else if (subscriber.Country__c.left(6) == 'choose') {
			returnList = setupCountryPicklist();
		} else {
			returnList = setupCountryPicklist(subscriber.Country__c);
		}
		return returnList;
	}
	@testVisible private list<selectOption> setSubscriberStatesList(Activation_Subscriber__c subscriber){
		list<SelectOption> returnList = new list<SelectOption>();
		system.debug('Invoking setSubscriberStatesList with Subscriber: ' + subscriber);
		if (subscriber.Country__c == null){																						//test null first...
			returnList = setupStatesPicklist();
		}else if (CountryMap.containsKey(subscriber.Country__c) && subscriber.State_Province__c.left(6) != 'choose'){			//test most complex condition second...
			returnList = setupStatesPicklist(subscriber.Country__c, subscriber.State_Province__c);								//we have a valid country, and a valid state selected..
		} else if (CountryMap.containsKey(subscriber.Country__c) && subscriber.State_Province__c.left(6) == 'choose'){
			returnList = setupStatesPicklist(subscriber.Country__c);															//we have a valid country, but no state selected..
		} else if (subscriber.Country__c.left(6) == 'choose'){																	//"Choose country first"....
			returnList = setupStatesPicklist();
		} else {																												//default
			returnList = setupStatesPicklist();
		}
		return returnList;
	}
	@testVisible private list<SelectOption> setBillingCountriesList(Activation_Subscriber__c subscriber){
		//SelectOption option = new SelectOption(value, label);
		list<SelectOption> returnList = new list<SelectOption>();
		system.debug('Invoking setBillingCountriesList with Subscriber: ' + subscriber);
		if(subscriber.Id == null){
			returnList = setupCountryPicklist();
		} else if (subscriber.Country__c.left(6) == 'choose') {
			returnList = setupCountryPicklist();
		} else {
			returnList = setupCountryPicklist(subscriber.Billing_Country__c);
		}
		return returnList;
	}
	@testVisible private list<selectOption> setBillingStatesList(Activation_Subscriber__c subscriber){
		list<SelectOption> returnList = new list<SelectOption>();
		system.debug('Invoking setBillingStatesList with Subscriber: ' + subscriber);
		if (subscriber.Billing_Country__c == null){																						//test null first...
			returnList = setupStatesPicklist();
		}else if (CountryMap.containsKey(subscriber.Billing_Country__c) && subscriber.Billing_State_Province__c.left(6) != 'choose'){			//test most complex condition second...
			returnList = setupStatesPicklist(subscriber.Billing_Country__c, subscriber.Billing_State_Province__c);								//we have a valid country, and a valid state selected..
		} else if (CountryMap.containsKey(subscriber.Billing_Country__c) && subscriber.Billing_State_Province__c.left(6) == 'choose'){
			returnList = setupStatesPicklist(subscriber.Billing_Country__c);															//we have a valid country, but no state selected..
		} else if (subscriber.Billing_Country__c.left(6) == 'choose'){																	//"Choose country first"....
			returnList = setupStatesPicklist();
		} else {																												//default
			returnList = setupStatesPicklist();
		}
		return returnList;
	}
	
	
	
	//Page methods
	public void onLoad(){
		system.debug('onLoad Tab State: ' + ActivationStatus.Subscriber_Active_Tab__c);
		update ActivationStatus;
	}
	
	
	//Getters and Setters
	public String selectedTab {
        get {
            if (selectedTab == null) {
                if (ActivationStatus.Subscriber_Active_Tab__c != null) {
                    selectedTab = ActivationStatus.Subscriber_Active_Tab__c;
                } else {
                    selectedTab = 'tab-1';
                }
            }
            return selectedTab;
        }
        // Setter has to be public as some (but not all) actions do result in an update
        set;
    }
	public Activation_Subscriber__c getnewSubscriber(){		//reads subscriber details from the database
		system.debug('Invoking getnewSubscriber');			//handle a postback
		if(newSubscriber == null){
			system.debug('null test for new subscriber positive.....');
			list<Activation_Subscriber__c> act_subs = [SELECT Id, Name, Activation_Order__c ,
													Subscriber_Contact_First_Name__c,  Subscriber_Contact_Name__c, Subscriber_Email__c,
													Subscribing_Company__c, Country__c, State_Province__c, City__c, Postal_Zip_Code__c, 
													Address__c, Subscriber_Mobile_Phone__c, Phone_Number__c, 
													Billing_Rep_First_Name__c, Billing_Rep_Name__c, Billing_Email__c, 
													Billing_Company__c, Billing_Country__c, Billing_State_Province__c, Billing_City__c, Billing_Zip_Code__c,
													Billing_Rep_Address__c, Billing_Mobile_Phone__c, Billing_Phone_Number__c 
													FROM Activation_Subscriber__c
													WHERE Activation_Order__c =: ActivationOrderId];
			//system.debug(act_subs.size());
			if(act_subs.size() == 0){
				system.debug(act_subs.size() + ' Subscribers found, creating a new one!');
				newSubscriber = new Activation_Subscriber__c(Activation_Order__c = ActivationOrderId);//create a new subscriber
			} else {
				system.debug(act_subs.size() + ' Subscribers found, using existing record');
				newSubscriber = act_subs[0];
			}
		}
		system.debug('newSubscriber: ' + newSubscriber);
		return newSubscriber;
	}
	public void setnewSubscriber(){						//commits subscriber details to database TODO: make private w/helper test method
		system.debug('Invoking setnewSubscriber');
		upsert newSubscriber;
	}
	
	//Subscriber stuff
	public list<SelectOption> getSubscriberCountriesList(){
		return SubscriberCountriesList;
	}

	public void setSubscriberCountriesList(string CountryISOCode){	//do we need this
		//SelectOption option = new SelectOption(value, label);
		SubscriberCountriesList = setupCountryPicklist(CountryISOCode);
	}
	
	public list<SelectOption> getSubscriberStatesList(){
		return SubscriberStatesList;
	}
	public void setSubscriberStatesList(){ /*big decisions here*/
		/*Deprecated refactor to SubscriberCountryChangeHandler()*/
		if(newSubscriber.Country__c.left(6) == 'choose'){
			SubscriberStatesList = setupStatesPicklist(); //setup with no params
		} else if(newSubscriber.State_Province__c.left(6) == 'choose'){
			newSubscriber.Country__c = newSubscriber.Country__c;
			SubscriberStatesList = setupStatesPicklist(newSubscriber.Country__c);
			SubscriberStatesList = setupStatesPicklist(newSubscriber.Country__c, newSubscriber.State_Province__c);
		}
	}
	
	public void SubscriberCountryChangeHandler(){
		system.debug('Invoking Subscriber Country Change Handler...');
		if(newSubscriber.Country__c != null){	//Subscriber Country is normally populated.
			//Four conditions...
			if(newSubscriber.Country__c.left(6) != 'choose' && newSubscriber.State_Province__c.left(6) != 'choose'){
				system.debug('Need to Validate State Picklist with: ' + newSubscriber.Country__c + ' and: ' + newSubscriber.State_Province__c);	//Previously selected State?? Check for valid state!
				for(KVH_States__mdt c : [SELECT TrimmedName__c FROM KVH_States__mdt WHERE CountryIsoCode_2__c =: newSubscriber.Country__c]){
					if(c.TrimmedName__c == newSubscriber.State_Province__c){
						system.debug('We are cool, Country and State in alignment!');
						SubscriberStatesList = setupStatesPicklist(newSubscriber.Country__c, newSubscriber.State_Province__c);
						return;	//we are cool, Country and State align
					}
				}
			} else if(newSubscriber.Country__c.left(6) == 'choose' && newSubscriber.State_Province__c.left(10) != 'choose cou'){
				system.debug('Need to Default Country and State Picklist...');								//Country got set back to "Choose" after a state was chosen
				SubscriberCountriesList = setupCountryPicklist();
				SubscriberStatesList = setupStatesPicklist(); //setup with no params
			} else if (newSubscriber.Country__c.left(6) != 'choose' && newSubscriber.State_Province__c.left(6) == 'choose'){
				system.debug('Need to Setup State Picklist with: ' + newSubscriber.Country__c);		//Country Chosen, setup States Picklist
				SubscriberStatesList = setupStatesPicklist(newSubscriber.Country__c);
			} else if(newSubscriber.Country__c.left(6) == 'choose' && newSubscriber.State_Province__c.left(10) == 'choose cou'){
				system.debug('Picklists at defaults....');													//We are good here...
			} else { // .... and a WTF!?
				SubscriberCountriesList = setupCountryPicklist();
				SubscriberStatesList = setupStatesPicklist();
			}
		} else { //Billing Country == null.... another WTF!?.... but rather then throwing a null exception error, check first!
			SubscriberCountriesList = setupCountryPicklist();
			SubscriberStatesList = setupStatesPicklist();
		}
		
		
		
		
		/*system.debug('Invoking Subscriber Country Change Handler...');
		if(newSubscriber.Country__c == null){											//Could happen frequently!
			system.debug('Need to Setup State Picklist with default');
			SubscriberStatesList = setupStatesPicklist(); 										//setup with no params
		
		} else if(newSubscriber.Country__c.left(6) != 'choose'){
			system.debug('Need to Setup State Picklist with: ' + newSubscriber.Country__c);
			SubscriberStatesList = setupStatesPicklist(newSubscriber.Country__c); 				//setup with no filter
		
		} else if(newSubscriber.Country__c.left(6) == 'choose' && newSubscriber.State_Province__c.left(10) == 'choose cou'){
			system.debug('Picklists at defaults....');											//We are good here...
		
		} else if (newSubscriber.Country__c.left(6) != 'choose' && newSubscriber.State_Province__c.left(6) == 'choose'){
			system.debug('Need to Setup State Picklist with: ' + newSubscriber.Country__c);		//Country Chosen, setup States Picklist
			//newSubscriber.Country__c = newSubscriber.Country__c;
			SubscriberStatesList = setupStatesPicklist(newSubscriber.Country__c);
		
		} else if(newSubscriber.Country__c.left(6) == 'choose' && newSubscriber.State_Province__c.left(10) != 'choose cou'){
			system.debug('Need to Default Country and State Picklist...');						//Country got set back to "Choose" after a state was chosen
			//newSubscriber.Country__c = newSubscriber.Country__c;
			SubscriberCountriesList = setupCountryPicklist();
			SubscriberStatesList = setupStatesPicklist(); //setup with no params
		
		} else if(newSubscriber.Country__c.left(6) != 'choose' && newSubscriber.State_Province__c.left(6) != 'choose'){
			system.debug('Need to Validate State Picklist with: ' + newSubscriber.Country__c);	//Previously selected State?? Check for valid state!
			for(KVH_States__mdt c : [SELECT TrimmedName__c 
										FROM KVH_States__mdt 
										//WHERE CountryIsoCode_2__c = 'US' OR CountryIsoCode_2__c = 'CA'			//just for testing...
										WHERE CountryIsoCode_2__c =: newSubscriber.Country__c]){
				if(c.TrimmedName__c == newSubscriber.State_Province__c){
					return;	//we are cool, Country and State align
				}
			}
			//newSubscriber.Country__c = newSubscriber.Country__c;
			SubscriberStatesList = setupStatesPicklist(newSubscriber.Country__c);
		}*/
	}
	
	public void BillingCountryChangeHandler(){
		system.debug('Invoking Billing Country Change Handler...');
		if(newSubscriber.Billing_Country__c != null){	//Billing Country is normally populated.
			//Four conditions...
			if(newSubscriber.Billing_Country__c.left(6) != 'choose' && newSubscriber.Billing_State_Province__c.left(6) != 'choose'){
				system.debug('Need to Validate State Picklist with: ' + newSubscriber.Billing_Country__c + ' and: ' + newSubscriber.Billing_State_Province__c);	//Previously selected State?? Check for valid state!
				for(KVH_States__mdt c : [SELECT TrimmedName__c FROM KVH_States__mdt WHERE CountryIsoCode_2__c =: newSubscriber.Billing_Country__c]){
					if(c.TrimmedName__c == newSubscriber.Billing_State_Province__c){
						system.debug('We are cool, Country and State in alignment!');
						BillingStatesList = setupStatesPicklist(newSubscriber.Billing_Country__c, newSubscriber.Billing_State_Province__c);
						return;	//we are cool, Country and State align
					}
				}
			} else if(newSubscriber.Billing_Country__c.left(6) == 'choose' && newSubscriber.Billing_State_Province__c.left(10) != 'choose cou'){
				system.debug('Need to Default Country and State Picklist...');								//Country got set back to "Choose" after a state was chosen
				BillingCountriesList = setupCountryPicklist();
				BillingStatesList = setupStatesPicklist(); //setup with no params
			} else if (newSubscriber.Billing_Country__c.left(6) != 'choose' && newSubscriber.Billing_State_Province__c.left(6) == 'choose'){
				system.debug('Need to Setup State Picklist with: ' + newSubscriber.Billing_Country__c);		//Country Chosen, setup States Picklist
				BillingStatesList = setupStatesPicklist(newSubscriber.Billing_Country__c);
			} else if(newSubscriber.Billing_Country__c.left(6) == 'choose' && newSubscriber.Billing_State_Province__c.left(10) == 'choose cou'){
				system.debug('Picklists at defaults....');													//We are good here...
			} else { // .... and a WTF!?
				BillingCountriesList = setupCountryPicklist();
				BillingStatesList = setupStatesPicklist();
			}
		} else { //Billing Country == null.... another WTF!?.... but rather then throwing a null exception error, check first!
			BillingCountriesList = setupCountryPicklist();
			BillingStatesList = setupStatesPicklist();
		}
	}
	
	public void SubOrBillingStateChangeHandler(){					//One Handler for BOTH States lists..... it's a simple save/update
		system.debug('Invoking SubOrBillingStateChangeHandler...');
		upsert newSubscriber;
	}

	//Billing Stuff
	public list<SelectOption> getBillingCountriesList(){
		return BillingCountriesList;
	}
	private void setBillingCountriesList(){
		//SelectOption option = new SelectOption(value, label);
		BillingCountriesList = setupCountryPicklist();
	}
	public void setBillingCountriesList(string CountryISOCode){
		//SelectOption option = new SelectOption(value, label);
		BillingCountriesList = setupCountryPicklist(CountryISOCode);
	}
	public list<SelectOption> getBillingStatesList(){
		return BillingStatesList;
	}
	public void setBillingStatesList(){
		BillingStatesList = setupStatesPicklist(newSubscriber.Billing_Country__c);
	}
	
	private void buildCountryMap(){
		//create a map of just <ISO_Code_2, Country>
		for(KVH_Countries__mdt c : [SELECT Id, TrimmedName__c, IsoCode_2__c FROM KVH_Countries__mdt 
											//WHERE IsoCode_2__c = 'US' OR IsoCode_2__c = 'CA'			//just for testing...
											ORDER BY TrimmedName__c ASC]){
			CountryMap.put(c.IsoCode_2__c, c);															//Populate the Country Map
			//KVHCountryStateMap.put(c, new list<KVH_States__mdt>());										//initialize the State Map!
		}
	}
	/*Navigation Methods*/
	
	public pageReference goTab(){		
		pageReference returnPage = new PageReference('/apex/subscriber');
		returnPage.getParameters().put('order', ActivationOrderId);
		returnPage.setRedirect(true);
		return returnPage;
	}

	public pageReference ContinueToContactPage(){
		pageReference ContactPage = Page.Contacts;							//create reference to Activation Order
		ContactPage.getParameters().put('order', ActivationOrderId);		//add the order ID to page reference
		return ContactPage;													//return page reference and off we go!
	}

	/*helper methods*/
	//CountriesList with +1 overloaded setters!
	private list<selectOption> setupCountryPicklist(){
		//SelectOption option = new SelectOption(value, label);
		list<SelectOption> returnList = new list<SelectOption>();
		returnList.add(new SelectOption('choose one', 'choose one'));
		//read the countries and ISO codes...
		for(KVH_Countries__mdt c : [SELECT Id, TrimmedName__c, IsoCode_2__c FROM KVH_Countries__mdt 
											//WHERE IsoCode_2__c = 'US' OR IsoCode_2__c = 'CA'			//just for testing...
											ORDER BY TrimmedName__c ASC]){
			returnList.add(new SelectOption(c.IsoCode_2__c, c.TrimmedName__c));
		}
		return returnList;
	}
	private list<selectOption> setupCountryPicklist(String CountryISOCode){
		//SelectOption option = new SelectOption(value, label);
		list<SelectOption> returnList = new list<SelectOption>();
		returnList.add(new SelectOption('choose one', 'choose one'));
		//read the countries and ISO codes...
		for(KVH_Countries__mdt c : [SELECT Id, TrimmedName__c, IsoCode_2__c FROM KVH_Countries__mdt 
											//WHERE IsoCode_2__c = 'US' OR IsoCode_2__c = 'CA'			//just for testing...
											ORDER BY TrimmedName__c ASC]){
			returnList.add(new SelectOption(c.IsoCode_2__c, c.TrimmedName__c));
			if(c.IsoCode_2__c == CountryISOCode){
				returnList.add(0, new SelectOption(c.IsoCode_2__c, c.TrimmedName__c));						//put this one at the top too!
			}
		}
		return returnList;
	}
	
	//StatesList with +2 overloaded setters!
	@TestVisible private list<SelectOption> setupStatesPicklist(){
		system.debug('Invoking setupStatesPicklist with no parameters');
		list<SelectOption> returnList = new list<SelectOption>();
		returnList.clear();												//clear it out first...
		returnList.add(new SelectOption('choose country first', 'choose country first'));
		return returnList;
	}
	@TestVisible private list<SelectOption> setupStatesPicklist(string CountryISOCode){
		system.debug('Invoking setupStatesPicklist with: ' + CountryISOCode);
		list<SelectOption> returnList = new list<SelectOption>();
		returnList.clear();												//clear it out first...
		returnList.add(new SelectOption('choose one', 'choose one'));
		//KVH_Countries__mdt c = CountryMap.get(newSubscriber.Country__c);
		for(KVH_States__mdt s : [SELECT MasterLabel, TrimmedName__c, CountryIsoCode_2__c, Id 
								 FROM KVH_States__mdt
								 WHERE CountryIsoCode_2__c =: countryISOCode]){
			returnList.add(new SelectOption(s.TrimmedName__c, s.TrimmedName__c));
		}
		system.debug('Number of States returned: ' + returnList.size());
		if(returnList.size() == 1){ 								//There's NO states for the selected country
			returnList.clear();										//clear it out first...
			returnList.add(new SelectOption('n/a', 'n/a', true));	//do not allow a selection
		} else if(returnList.size() == 2){							//only ONE state! who knew!
			returnList.remove(0);									//remove that 'choose one' option...
		}
		return returnList;
	}
	@TestVisible private list<SelectOption> setupStatesPicklist(string countryISOCode, string namedState){
		//SelectOption option = new SelectOption(value, label);
		system.debug('Invoking setStatesList with: ' + countryISOCode + ' and: ' + namedState);
		list<SelectOption> returnList = new list<SelectOption>();
		returnList.clear();												//clear it out first...
		returnList.add(new SelectOption(namedState, namedState));		//set the top of the list...
		for(KVH_States__mdt s : [SELECT MasterLabel, TrimmedName__c, CountryIsoCode_2__c, Id 
								 FROM KVH_States__mdt
								 WHERE CountryIsoCode_2__c =: countryISOCode]){
			returnList.add(new SelectOption(s.TrimmedName__c, s.TrimmedName__c));
		}
		return returnList;
	}
	
	public void copySubscriber(){ 
		system.debug('Inkoving copySubscriber....'); 
		newSubscriber.Billing_Rep_First_Name__c = newSubscriber.Subscriber_Contact_First_Name__c;
		newSubscriber.Billing_Company__c = newSubscriber.Subscribing_Company__c;
		newSubscriber.Billing_Rep_Address__c = newSubscriber.Address__c;
		newSubscriber.Billing_Zip_Code__c = newSubscriber.Postal_Zip_Code__c;
		newSubscriber.Billing_Mobile_Phone__c = newSubscriber.Subscriber_Mobile_Phone__c;
		newSubscriber.Billing_Rep_Name__c = newSubscriber.Subscriber_Contact_Name__c;
		newSubscriber.Billing_Email__c = newSubscriber.Subscriber_Email__c;
		newSubscriber.Billing_City__c = newSubscriber.City__c;
		newSubscriber.Billing_Phone_Number__c = newSubscriber.Phone_Number__c;
		newSubscriber.Billing_Zip_Code__c = newSubscriber.Postal_Zip_Code__c;
		newSubscriber.Billing_Mobile_Phone__c = newSubscriber.Subscriber_Mobile_Phone__c;
		//enter critical section....
		newSubscriber.Billing_Country__c = newSubscriber.Country__c;
		newSubscriber.Billing_State_Province__c = newSubscriber.State_Province__c;
		system.debug('Billing Country: ' + newSubscriber.Billing_Country__c + ' Billing State: ' + newSubscriber.Billing_State_Province__c);
		//update picklists...check for nulls!
		BillingCountryChangeHandler();
		/*if(newSubscriber.Billing_Country__c == null){
			BillingCountriesList = setupCountryPicklist();
			BillingStatesList = setupStatesPicklist();
		} else {
			BillingCountriesList = setupCountryPicklist(newSubscriber.Billing_Country__c);
			if (newSubscriber.Billing_State_Province__c == null){
				BillingStatesList = setupStatesPicklist();
			} else {
				BillingStatesList = setupStatesPicklist(newSubscriber.Billing_Country__c, newSubscriber.Billing_State_Province__c);
			}
		}*/
	}
}