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
private class InstallationTypeController_test {
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
        testOrderStatus.Installation_Type_Last_Active_Tab_Index__c = null;// default value is always 1
        update testOrderStatus; // to cover 66 line
        
        Activation_Contact__c objActivationContact = new Activation_Contact__c();
        objActivationContact.Activation_Order__c = testActOrder.id;
        objActivationContact.Email__c = 'test@4test.com';
        objActivationContact.contact_Role__c ='Onboard Contact, System Support Contact';
        
        insert objActivationContact;
        
        Activation_Subscriber__c objActivationSubscriber = New Activation_Subscriber__c();
        objActivationSubscriber.Subscriber_Contact_First_Name__c = 'First';
        objActivationSubscriber.Subscribing_Company__c = 'Company';
        objActivationSubscriber.Address__c = '123 Street St.';
        objActivationSubscriber.Country__c = 'US';
        objActivationSubscriber.Postal_Zip_Code__c = '02842';
        objActivationSubscriber.Subscriber_Mobile_Phone__c = '401-555-1212';
        objActivationSubscriber.Subscriber_Contact_Name__c = 'Last';
        objActivationSubscriber.Subscriber_Email__c = 'first@last.com';
        objActivationSubscriber.City__c = 'Middletown';
        objActivationSubscriber.contact_Role__c ='Subscriber, Onboard Contact, System Support Contact';
        objActivationSubscriber.State_Province__c = 'Rhode Island';
        objActivationSubscriber.Phone_Number__c = '401-555-1212';
        objActivationSubscriber.Billing_Rep_Name__c = 'TestName';
        objActivationSubscriber.Activation_Order__c = testActOrder.id;
        insert objActivationSubscriber;
        
        Activation_Platform__c objActivationPlatform = New Activation_Platform__c();
        objActivationPlatform.Name = 'TBD';
        objActivationPlatform.Activation_Order__c = testActOrder.id;
        objActivationPlatform.Market__c = 'Leisure';
        objActivationPlatform.Market_Sector__c = 'Marine';
        objActivationPlatform.Vessel_IMO__c = '1234567';
        insert objActivationPlatform;
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
        PageReference thePage = page.Installation_Type;
        thePage.getParameters().put('order', ActOrder.Id);
        Test.setCurrentPage(thePage);
        InstallationTypeController ctrl = new InstallationTypeController();
        Activation_Status__c ActOrderStatus = ctrl.ActivationStatus; 
        
        system.assertEquals(ActOrder.Id, ActOrderStatus.Activation_Order__c);
        system.assertEquals('Installation Type', ActOrderStatus.Active_Page__c);		//Installation Type is default... test default!, ActOrder.Id);
        system.assertEquals('available', ActOrderStatus.Installation_Type_Page__c);
        //test with existing active tab...
        ActOrderStatus.Account_Setup_Active_Tab__c = 'Payment_Information';
        ActOrderStatus.Installation_Type_Active_Tab__c = 'Onboard_Contact';
        upsert ActOrderStatus;
        ctrl = new InstallationTypeController(); //re-instanciate
        
        system.assertEquals(ActOrder.Id, ActOrderStatus.Activation_Order__c);
        system.assertEquals('Installation Type', ActOrderStatus.Active_Page__c);		//Installation Type is default... test default!, ActOrder.Id);
        system.assertEquals('available', ActOrderStatus.Installation_Type_Page__c);
        system.assertEquals('Payment_Information', ActOrderStatus.Account_Setup_Active_Tab__c);
    }
    
    static testMethod void testAllMethod(){
        Activation_Order__c ActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        Activation_Contact__c objActivationContact =  [SELECT Id, Email__c, Contact_Role__c FROM Activation_Contact__c WHERE Activation_Order__c =: ActOrder.Id LIMIT 1]; 
        Activation_Subscriber__c objActivationSubscriber = [SELECT Id, Phone_Number__c  FROM Activation_Subscriber__c WHERE Activation_Order__c =: ActOrder.Id LIMIT 1]; 
        Activation_Platform__c objActivationPlatform = [SELECT Id,Activation_Order__c,Market__c,Market_Sector__c,Vessel_IMO__c FROM Activation_Platform__c WHERE Activation_Order__c =: ActOrder.Id LIMIT 1];
        PageReference thePage = page.Installation_Type;
        thePage.getParameters().put('order', ActOrder.Id);
        Test.setCurrentPage(thePage);
        InstallationTypeController ctrl = new InstallationTypeController();
        Activation_Status__c ActOrderStatus = ctrl.ActivationStatus;
        ctrl.ActivationStatus.Installation_Type_Active_Tab__c = 'Onboard_Contact';
        update ctrl.ActivationStatus;
        list<selectOption> readOptions = new list<selectOption>();      // we will reuse this...
        readOptions.clear();                                            //reset
        readOptions = ctrl.getCountriesList();
        system.assertEquals('Choose One', readOptions[0].getValue());   //test constructor values.
        system.assertEquals('Choose One', readOptions[0].getLabel());   //test constructor values.
        ctrl.selectedMarketType = 'Leisure Vessel'; //pass selected market.
        ctrl.loadActivationPlatform();
        ctrl.getTypes(); // returns Confirm_if_boat_yacht_is_chartered__c field picklist values
        ctrl.selectedTab = 'Payment_Information'; // to satisfy 208 line number
        ctrl.goToNextTab();
        system.assertEquals('System.PageReference[/apex/installation_type?order='+(string)ActOrder.Id+']',string.valueOf(thePage)); // return page reference validate
        ctrl.selectedTab = 'Antenna_System_Support_Contact';
        ctrl.selectedMarketType = ''; //pass selected market.
        ctrl.havingIMO = 'Yes'; //pass picklist value for IMO.
        ctrl.goToNextTab();
        ctrl.BrazilianWatersVessel();
        ctrl.goToCurrentContactTab();
        ctrl.selectedTab = 'Onboard_Contact';
        ctrl.goToNextTab();
        ctrl.goToCurrentContactTab();
        ctrl.saveandExit();
        system.assertEquals('System.PageReference[/apex/installation_type?conActID='+objActivationContact.id+'&order='+(string)ActOrder.Id+']',string.valueOf(thePage)); // return page reference validate
        objActivationContact.Contact_Role__c = 'System Support Contact';
        update objActivationContact; // update Activation contact Role
        ctrl.goToCurrentContactTab();
        delete objActivationPlatform;
        ctrl.loadActivationPlatform(); // new activation platform initialize
    }
}