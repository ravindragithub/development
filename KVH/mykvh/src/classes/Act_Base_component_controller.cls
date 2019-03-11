public virtual with sharing class Act_Base_component_controller {
	public list<SelectOption> phoneType {get; set;}
	public string ActOrderId {get;set;}					//Activation Order
	public Activation_Status__c actStatus {get;set;}	//Activation Status, used for tab navigation
	
	//Constructor
	public Act_Base_component_controller(){
		phoneType = buildPhoneTypes();
	}
	
	@testVisible private list<SelectOption> buildPhoneTypes(){
		list<SelectOption> returnList = new list<SelectOption>();
		returnList.add(new SelectOption('Home', 'Home'));
		returnList.add(new SelectOption('Business', 'Business'));
		returnList.add(new SelectOption('Mobile', 'Mobile'));
		return returnList;
	}

	/*Navigation Methods*/
	/*public pageReference goTab(){
		//pageReference returnPage = new PageReference('/apex/Account_Setup');	//Need to figure out the current page...
		pageReference returnPage = ApexPages.currentPage();
		returnPage.getParameters().put('order', ActOrderId);
		returnPage.setRedirect(true);
		return returnPage;
	}*/
}