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
private class ActivationsBaseController_test {
	public static final integer MAX_LOOP_COUNTER = 20;
	@testSetup static void setupTestData(){
		//Need an Activation Order, clearly. Heck let's use a Bunch!
		list<Activation_Order__c> ActOrdList = new list<Activation_Order__c>();
		list<Activation_Status__c> ActOrdStatusList = new list<Activation_Status__c>();
		for(integer i = 0; i< MAX_LOOP_COUNTER; i++){
			Activation_Order__c testActOrder = new Activation_Order__c();
			testActOrder.isSelf_Activation__c = true;
			testActOrder.User_Agent_String__c = 'test User-Agent string' + i;
			ActOrdList.add(testActOrder);
			
		}
		insert ActOrdList;
		for(Activation_Order__c a: [SELECT Id FROM Activation_Order__c]){
			//Need a Status record for each order (only one allowed)
			Activation_Status__c testOrdStatus = new Activation_Status__c();
			testOrdStatus.Activation_Order__c = a.Id;
			//testOrdStatus.Active_Page__c = 'Subscriber'; //Subscriber is default... test default!
			//testOrdStatus.Contacts_page__c = 'inhibited';  //inhibitied is default... test default!
			//testOrdStatus.Platform_page__c = 'inhibited';  //inhibitied is default... test default!
			//testOrdStatus.Products_page__c = 'inhibited';  //inhibitied is default... test default!
			//testOrdStatus.Services_page__c = 'inhibited';  //inhibitied is default... test default!
			//testOrdStatus.Subscriber_page__c = 'inhibited';  //inhibitied is default... test default!
			ActOrdStatusList.add(testOrdStatus);
		}
		insert ActOrdStatusList;
	}
	static testMethod void testSetupData(){
		list<Activation_Order__c> ActOrdList = new list<Activation_Order__c>();				//Let's get all Activation_Orders from the database....
		list<Activation_Status__c> ActOrdStatusList = new list<Activation_Status__c>();		//And all the corresponding Activation Statuses...
		ActOrdList = [SELECT ID, Name, isSelf_Activation__c, User_Agent_String__c FROM Activation_Order__c];
		system.assertEquals(MAX_LOOP_COUNTER,ActOrdList.size());
		ActOrdStatusList = [SELECT Id, Name, Activation_Order__c, 
								Active_Page__c,   Services_page__c, Subscriber_page__c,
								    Subscriber_Active_Tab__c 
							FROM Activation_Status__c];
		system.assertEquals(MAX_LOOP_COUNTER,ActOrdStatusList.size());
		for(integer i = 0; i< MAX_LOOP_COUNTER; i++){
			system.assertEquals(ActOrdList[i].isSelf_Activation__c, true);
			system.assertEquals(ActOrdList[i].User_Agent_String__c, 'test User-Agent string' + i);
		}
		for(integer i = 0; i< MAX_LOOP_COUNTER; i++){
			//system.debug(ActOrdStatusList[i].Active_Page__c);
			system.assertEquals('Account Setup', ActOrdStatusList[i].Active_Page__c);
			//system.assertEquals(ActOrdStatusList[i].Contacts_page__c, 'inhibited');
			//system.assertEquals(ActOrdStatusList[i].Platform_page__c, 'inhibited');
			//system.assertEquals(ActOrdStatusList[i].Products_page__c, 'inhibited');
			system.assertEquals('inhibited', ActOrdStatusList[i].Services_page__c);
			system.assertEquals('inhibited', ActOrdStatusList[i].Subscriber_page__c);
			//system.assertEquals(ActOrdStatusList[i].Contact_Tab_State__c, 1);
			//system.assertEquals(ActOrdStatusList[i].Platform_Tab_State__c, 1);
			//system.assertEquals(ActOrdStatusList[i].Products_Tab_State__c, 1);
			//system.assertEquals(ActOrdStatusList[i].Services_Tab_State__c, 1);
			//system.assertEquals(ActOrdStatusList[i].Subscriber_Active_Tab__c, 'string');
		}
	}
    static testMethod void testGetActivationStatusList() {
        // TO DO: implement unit test
        ActivationsBaseController util = new ActivationsBaseController();
		list<Activation_Order__c> ActOrdList = new list<Activation_Order__c>();				//Let's get all Activation_Orders from the database....
		list<Activation_Status__c> ActOrdStatusList = new list<Activation_Status__c>();		//And all the corresponding Activation Statuses...
		ActOrdList = [SELECT ID, Name, isSelf_Activation__c, User_Agent_String__c FROM Activation_Order__c];
		ActOrdStatusList = util.getActivationStatus(ActOrdList);
		for(Activation_Status__c s : ActOrdStatusList){
			system.assertEquals('Account Setup', s.Active_Page__c);
			//system.assertEquals(s.Contacts_page__c, 'inhibited');
			//system.assertEquals(s.Platform_page__c, 'inhibited');
			//system.assertEquals(s.Products_page__c, 'inhibited');
			system.assertEquals('inhibited', s.Services_page__c);
			//system.assertEquals(s.Contact_Tab_State__c, 1);
			//system.assertEquals(s.Platform_Tab_State__c, 1);
			//system.assertEquals(s.Products_Tab_State__c, 1);
			//system.assertEquals(s.Services_Tab_State__c, 1);
			//system.assertEquals(s.Subscriber_Active_Tab__c, 'string');
		}
    }
    static testMethod void testGetActivationStatus() {
        // TO DO: implement unit test
        ActivationsBaseController util = new ActivationsBaseController();
		list<Activation_Order__c> ActOrdList = new list<Activation_Order__c>();				//Let's get all Activation_Orders from the database....
		//Activation_Status__c ONEActOrdStatus = new Activation_Status__c();					//And all the corresponding Activation Statuses...
		ActOrdList = [SELECT ID, Name, isSelf_Activation__c, User_Agent_String__c FROM Activation_Order__c];
		util.ActivationStatus = util.readActivationStatus((String)ActOrdList[0].Id);
		
		system.assertEquals('Account Setup', util.ActivationStatus.Active_Page__c);
		//system.assertEquals(util.ActivationStatus.Contacts_page__c, 'inhibited');
		//system.assertEquals(util.ActivationStatus.Platform_page__c, 'inhibited');
		//system.assertEquals(util.ActivationStatus.Products_page__c, 'inhibited');
		system.assertEquals('inhibited', util.ActivationStatus.Services_page__c);
		//system.assertEquals(util.ActivationStatus.Contact_Tab_State__c, 1);
		//system.assertEquals(util.ActivationStatus.Platform_Tab_State__c, 1);
		//system.assertEquals(util.ActivationStatus.Products_Tab_State__c, 1);
		//system.assertEquals(util.ActivationStatus.Services_Tab_State__c, 1);
		//system.assertEquals(ONEActOrdStatus.Subscriber_Active_Tab__c, 'string');
    }
    static testMethod void testRemoteAction(){
    	ActivationsBaseController util = new ActivationsBaseController();
		list<Activation_Order__c> ActOrdList = new list<Activation_Order__c>();				//Let's get all Activation_Orders from the database....
		Activation_Status__c ONEActOrdStatus = new Activation_Status__c();					//And all the corresponding Activation Statuses...
		ActOrdList = [SELECT ID, Name, isSelf_Activation__c, User_Agent_String__c FROM Activation_Order__c];
		ONEActOrdStatus = util.readActivationStatus((String)ActOrdList[0].Id);
    	string tabName = 'Test Tab Name';
        //ActivationsBaseController.updateStatus(ActOrdList[0].id,tabname);
    	//ActivationsBaseController.updateSubscriber(ActOrdList[0].Id, tabName,(String)ActOrdList[0].Id); //Method refactored....
    	
    	//ONEActOrdStatus = [SELECT ID, Name, Subscriber_Active_Tab__c FROM Activation_Status__c WHERE Id =: ONEActOrdStatus.Id];
    	//system.assertEquals('Test Tab Name', ONEActOrdStatus.Subscriber_Active_Tab__c);
    }
	/* Next/Prev are deprecated - Tab State is text based */
	static testMethod void testNextPrev(){
		ActivationsBaseController util = new ActivationsBaseController();
		integer MAX_TAB_STATE = 3;
		system.assertEquals(2, util.next(1, MAX_TAB_STATE));
		system.assertEquals(3, util.next(2, MAX_TAB_STATE));
		system.assertEquals(3, util.next(3, MAX_TAB_STATE));
		system.assertEquals(2, util.prev(3));
		system.assertEquals(1, util.prev(2));
		system.assertEquals(1, util.prev(1));
    }
}