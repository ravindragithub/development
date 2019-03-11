/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class SubscriberController_test {
	//Going to need to pass in the Activation Order parameter, so we will probably need to add a record to our test data
	//Also going to need an Activation Order Status
	@testSetup static void setupTestData(){
		Activation_Order__c testActOrder = new Activation_Order__c();
		testActOrder.isSelf_Activation__c = true;
		testActOrder.User_Agent_String__c = 'test User-Agent string';
		insert testActOrder;
		Activation_Status__c testOrderStatus = new Activation_Status__c();
		testOrderStatus.Activation_Order__c = testActOrder.Id;
		insert testOrderStatus;
	}
	static testMethod void testSetupData(){
		Activation_Order__c ActOrder;
		list<Activation_Order__c> ActOrdList = new list<Activation_Order__c>();	//Let's get all Activation_Orders from the database....
		ActOrdList = [SELECT ID, Name, isSelf_Activation__c, User_Agent_String__c FROM Activation_Order__c];				
		system.assertEquals(1,ActOrdList.size());								//but there should be ONLY one!
		ActOrder = ActOrdList[0];												//the one we just created in our testSetup!
		system.assertEquals(ActOrder.isSelf_Activation__c, true);
		system.assertEquals(ActOrder.User_Agent_String__c, 'test User-Agent string');
		ActivationsBaseController util = new ActivationsBaseController();
		list<Activation_Status__c> ActOrdStatusList = util.getActivationStatus(ActOrdList);
		system.assertEquals(1,ActOrdStatusList.size());							//and there should be ONLY one!.
		Activation_Status__c ActOrderStatus = ActOrdStatusList[0];
	}
    static testMethod void testConstructor() {
        // TO DO: implement unit test
        Activation_Order__c ActOrder;
        ActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        PageReference thePage = page.Subscriber;
        thePage.getParameters().put('order', ActOrder.Id);
		Test.setCurrentPage(thePage);
		SubscriberController ctrl = new SubscriberController();
		Activation_Status__c ActOrderStatus = ctrl.ActivationStatus; 
		system.assertEquals(ActOrderStatus.Activation_Order__c, ActOrder.Id);
		system.assertEquals(ActOrderStatus.Active_Page__c, 'Subscriber');		//Subscriber is default... test default!, ActOrder.Id);
		system.assertEquals(ActOrderStatus.Subscriber_page__c, 'available');
    }
    
    /*static testMethod void testPicklists(){
    	Activation_Order__c ActOrder;
        ActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        PageReference thePage = page.Subscriber;
        thePage.getParameters().put('order', ActOrder.Id);
		Test.setCurrentPage(thePage);
    	SubscriberController ctrl = new SubscriberController();
    	list<selectOption> readOptions = new list<selectOption>();		// we will reuse this...
		readOptions = ctrl.getSubscriberCountriesList();
		system.assertEquals(readOptions[0].getValue(),'choose one');	//test constructor values.
		system.assertEquals(readOptions[0].getLabel(),'choose one');	//test constructor values.
		readOptions.clear();											//reset
		readOptions = ctrl.getBillingCountriesList();
		system.assertEquals(readOptions[0].getValue(),'choose one');	//test constructor values.
		system.assertEquals(readOptions[0].getLabel(),'choose one');	//test constructor values.
		readOptions.clear();											//reset
		readOptions = ctrl.getSubscriberStatesList();
		system.assertEquals(1,readOptions.size());
		system.assertEquals(readOptions[0].getValue(),'choose country first');	//test constructor values.
		system.assertEquals(readOptions[0].getLabel(),'choose country first');	//test constructor values.
		readOptions.clear();													//reset
		readOptions = ctrl.getBillingStatesList();
		system.assertEquals(1,readOptions.size());
		system.assertEquals(readOptions[0].getValue(),'choose country first');		//test constructor values.
		system.assertEquals(readOptions[0].getLabel(),'choose country first');		//test constructor values.
		readOptions.clear();														//reset
		ctrl.setSubscriberCountriesList('US');										//SET a well known value
		readOptions = ctrl.getSubscriberCountriesList();							//read it back
		system.assertNotEquals(1,readOptions.size());								//Should be a big list...
		system.assertEquals(readOptions[0].getValue(),'US');						//but with well known value at top
		system.assertEquals(readOptions[0].getLabel(),ctrl.CountryMap.get('US').TrimmedName__c);	//use lookup Map
		readOptions.clear();														//reset
		ctrl.setBillingCountriesList('US');											//SET a well known value
		readOptions = ctrl.getBillingCountriesList();								//read it back
		system.assertNotEquals(1,readOptions.size());								//Should be a big list...
		system.assertEquals(readOptions[0].getValue(),'US');						//but with well known value at top
		system.assertEquals(readOptions[0].getLabel(),ctrl.CountryMap.get('US').TrimmedName__c);	//use lookup Map
		
		readOptions.clear();														//reset
		Activation_Subscriber__c readSub = ctrl.getnewSubscriber();
		ctrl.newSubscriber.Country__c = 'US';										//SET a well known value
		ctrl.setSubscriberStatesList();											
		readOptions = ctrl.getSubscriberStatesList();								//read it back
		system.assert(readOptions.size() > 2);										//Should be a big list...
		system.assertNotEquals(readOptions[0].getValue(),'n/a');					//verify behaviour of big ( >2 ) list
		
		readOptions.clear();														//reset
		//Activation_Subscriber__c readSub = ctrl.getnewSubscriber();
		ctrl.newSubscriber.Billing_Country__c = 'US';								//SET a well known value
		ctrl.setBillingStatesList();											
		readOptions = ctrl.getBillingStatesList();									//read it back
		system.assert(readOptions.size() > 2);										//Should be a big list...
		system.assertNotEquals(readOptions[0].getValue(),'n/a');					//verify behaviour of big ( >2 ) list
		
		readOptions.clear();														//reset
		//Activation_Subscriber__c readSub = ctrl.getnewSubscriber();
		ctrl.newSubscriber.Billing_Country__c = 'XX';								//SET a well known value (HA! Platforms!!)
		ctrl.setBillingStatesList();											
		readOptions = ctrl.getBillingStatesList();									//read it back
		system.assert(readOptions.size() == 1);										//Should be a big list...
		system.assertEquals(readOptions[0].getValue(),'n/a');						//verify behaviour of no states in list
		system.assert(readOptions[0].getDisabled());								//verify behaviour of no states in list
		
		readOptions.clear();														//reset
		readOptions = ctrl.setupStatesPicklist('US', 'Rhode Island');				//read it back
		system.assert(readOptions.size() >2 );										//Should be a big list...
		system.assertEquals(readOptions[0].getValue(),'Rhode Island');				//verify of first value/label in list
		system.assertEquals(readOptions[0].getLabel(),'Rhode Island');				//verify of first value/label in list
		
		readOptions.clear();														//reset
		readOptions = ctrl.setupStatesPicklist('NF');								//Norfolk Island! Who knew! Only ONE state!
		system.assert(readOptions.size() == 1 );									//Should be a list of one...
		system.assertEquals(readOptions[0].getValue(),'NSW');						//verify of first value/label in list
		system.assertEquals(readOptions[0].getLabel(),'NSW');						//verify of first value/label in list
		system.assertEquals(readOptions[0].getDisabled(), false);					//verify behaviour of ONE state in list
    }*/
    
    static testMethod void testcopySubscriber(){
    	Activation_Order__c ActOrder;
        ActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        PageReference thePage = page.Subscriber;
        thePage.getParameters().put('order', ActOrder.Id);
		Test.setCurrentPage(thePage);
		SubscriberController ctrl = new SubscriberController();
		Activation_Subscriber__c readSub = ctrl.getnewSubscriber();
		ctrl.setnewSubscriber();
		
    	ctrl.newSubscriber.Subscriber_Contact_First_Name__c = 'First';
		ctrl.newSubscriber.Subscribing_Company__c = 'Company';
		ctrl.newSubscriber.Address__c = '123 Street St.';
		ctrl.newSubscriber.Country__c = 'US';
		ctrl.newSubscriber.Postal_Zip_Code__c = '02842';
		ctrl.newSubscriber.Subscriber_Mobile_Phone__c = '401-555-1212';
		ctrl.newSubscriber.Subscriber_Contact_Name__c = 'Last';
		ctrl.newSubscriber.Subscriber_Email__c = 'first@last.com';
		ctrl.newSubscriber.City__c = 'Middletown';
		ctrl.newSubscriber.State_Province__c = 'Rhode Island';
		ctrl.newSubscriber.Phone_Number__c = '401-555-1212';
		
		ctrl.copySubscriber();
		
		system.assertEquals(ctrl.newSubscriber.Billing_Rep_First_Name__c,ctrl.newSubscriber.Subscriber_Contact_First_Name__c);
		system.assertEquals(ctrl.newSubscriber.Billing_Company__c,ctrl.newSubscriber.Subscribing_Company__c);
		system.assertEquals(ctrl.newSubscriber.Billing_Rep_Address__c,ctrl.newSubscriber.Address__c);
		system.assertEquals(ctrl.newSubscriber.Billing_Country__c,ctrl.newSubscriber.Country__c);
		system.assertEquals(ctrl.newSubscriber.Billing_Zip_Code__c,ctrl.newSubscriber.Postal_Zip_Code__c);
		system.assertEquals(ctrl.newSubscriber.Billing_Mobile_Phone__c,ctrl.newSubscriber.Subscriber_Mobile_Phone__c);
		system.assertEquals(ctrl.newSubscriber.Billing_Rep_Name__c,ctrl.newSubscriber.Subscriber_Contact_Name__c);
		system.assertEquals(ctrl.newSubscriber.Billing_Email__c,ctrl.newSubscriber.Subscriber_Email__c);
		system.assertEquals(ctrl.newSubscriber.Billing_City__c,ctrl.newSubscriber.City__c);
		system.assertEquals(ctrl.newSubscriber.Billing_State_Province__c,ctrl.newSubscriber.State_Province__c);
		system.assertEquals(ctrl.newSubscriber.Billing_Phone_Number__c,ctrl.newSubscriber.Phone_Number__c);
		
    }
	static testMethod void testNavigation(){
		//Arrange
		Activation_Order__c ActOrder;
        ActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        PageReference thePage = page.Subscriber;
        thePage.getParameters().put('order', ActOrder.Id);
		Test.setCurrentPage(thePage);
		SubscriberController ctrl = new SubscriberController();
		ctrl.newSubscriber = ctrl.getnewSubscriber();
		ctrl.onLoad();
		//Act
	
		thePage = ctrl.ContinueToContactPage();
		//Assert
		system.assertEquals('/apex/contacts', thePage.getURL().left(14));		//make sure that we go to the right page...
		system.assertEquals(ActOrder.Id, thePage.getParameters().get('order'));	//make sure Order Id carries in...
	}
}