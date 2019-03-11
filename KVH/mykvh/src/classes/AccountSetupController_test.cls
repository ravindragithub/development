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
private class AccountSetupController_test {
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
        Activation_Subscriber__c Asub=new Activation_Subscriber__c();
        Asub.Activation_Order__c=testActOrder.id;
        insert Asub;
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
        PageReference thePage = page.Account_Setup;
        thePage.getParameters().put('order', ActOrder.Id);
		Test.setCurrentPage(thePage);
		AccountSetupController ctrl = new AccountSetupController();
		Activation_Status__c ActOrderStatus = ctrl.ActivationStatus; 
		
		system.assertEquals(ActOrder.Id, ActOrderStatus.Activation_Order__c);
		system.assertEquals('Account Setup', ActOrderStatus.Active_Page__c);		//Account Setup is default... test default!, ActOrder.Id);
		system.assertEquals('available', ActOrderStatus.Account_Setup_Page__c);
		//test with existing active tab...
		ActOrderStatus.Account_Setup_Active_Tab__c = 'test_string';
		upsert ActOrderStatus;
		ctrl = new AccountSetupController(); //re-instanciate
		
		system.assertEquals(ActOrder.Id, ActOrderStatus.Activation_Order__c);
		system.assertEquals('Account Setup', ActOrderStatus.Active_Page__c);		//Account Setup is default... test default!, ActOrder.Id);
		system.assertEquals('available', ActOrderStatus.Account_Setup_Page__c);
		system.assertEquals('test_string', ActOrderStatus.Account_Setup_Active_Tab__c);
    }
	static testMethod void test_goToTab(){
		Activation_Order__c ActOrder;
        ActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        PageReference thePage = page.Account_Setup;
        thePage.getParameters().put('order', ActOrder.Id);
		Test.setCurrentPage(thePage);
		AccountSetupController ctrl = new AccountSetupController();
        ctrl.saveandExit();
		Activation_Status__c ActOrderStatus = ctrl.ActivationStatus; 
		system.assertEquals('Account Setup', ActOrderStatus.Active_Page__c);		//Account Setup is default... test default!, ActOrder.Id);
		
        test.startTest();
        ctrl.selectedTab = 'Invoicing_Preferences';
        PageReference destinationPage = ctrl.goToTab();
        system.assertEquals(ActOrder.Id, destinationPage.getParameters().get('order'));	//make sure that we indeed get the Order ID param
        ActOrderStatus = ctrl.readActivationStatus(ActOrder.Id);
        system.assertEquals('Invoicing_Preferences', ActOrderStatus.Account_Setup_Active_Tab__c);
        
        ctrl.selectedTab = 'Installation_Type';
        destinationPage = ctrl.goToTab();
        system.assertEquals(ActOrder.Id, destinationPage.getParameters().get('order'));	//make sure that we indeed get the Order ID param
        ActOrderStatus = ctrl.readActivationStatus(ActOrder.Id);
        system.assertEquals('Installation_Type', ActOrderStatus.Installation_Type_Active_Tab__c);
      
        ctrl.selectedTab = 'test_tab';
        destinationPage = ctrl.goToTab();
        system.assertEquals(ActOrder.Id, destinationPage.getParameters().get('order'));	//make sure that we indeed get the Order ID param
        ActOrderStatus = ctrl.readActivationStatus(ActOrder.Id);
        system.assertEquals('test_tab', ActOrderStatus.Account_Setup_Active_Tab__c);
        
        ActOrderStatus.Account_Setup_Active_Tab__c = 'Invoicing_Preferences';
        update ActOrderStatus;
        ctrl = new AccountSetupController(); //re-instantiate
        test.stopTest();
	}
    
}