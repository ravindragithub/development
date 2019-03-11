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
private class Activation_Corporate_Company_test {
    private static final Id DirectPartner_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Partner').getRecordTypeId();

    @testSetup static void setupTestData(){
        Account objAccountpartner = New Account(Name='Self Registered Mock', RecordTypeId = DirectPartner_RECORD_TYPE_ID);
        insert objAccountpartner;
        
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
        list<Activation_Order__c> ActOrdList = new list<Activation_Order__c>(); //Let's get all Activation_Orders from the database....
        ActOrdList = [SELECT ID, Name, isSelf_Activation__c, User_Agent_String__c FROM Activation_Order__c];                
        system.assertEquals(1,ActOrdList.size());                               //but there should be ONLY one!
        ActOrder = ActOrdList[0];                                               //the one we just created in our testSetup!
        system.assertEquals(ActOrder.isSelf_Activation__c, true);
        system.assertEquals(ActOrder.User_Agent_String__c, 'test User-Agent string');
        ActivationsBaseController util = new ActivationsBaseController();
        list<Activation_Status__c> ActOrdStatusList = util.getActivationStatus(ActOrdList);
        system.assertEquals(1,ActOrdStatusList.size());                         //and there should be ONLY one!.
        Activation_Status__c ActOrderStatus = ActOrdStatusList[0];
    }
    static testMethod void testConstructor() {
        // TO DO: implement unit test
        test.startTest();
        Activation_Order__c testOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        system.debug('Test Order: ' + testOrder.Id);
        Activation_Status__c testStatus = [SELECT Id FROM Activation_Status__c WHERE Activation_Order__c =: testOrder.Id LIMIT 1];
        Activation_Corporate_Company ctrl = new Activation_Corporate_Company();
        ctrl.ActOrderId = (string)testOrder.Id;     //convert to string (see base controller)
        ctrl.ActStatus = testStatus;                //see base controller
        ctrl.newSubscriber = ctrl.getNewSubscriber();
        list<selectOption> readOptions = new list<selectOption>();      // we will reuse this...
        ctrl.parentContainer = 'test container';
        readOptions.clear();                                            //reset
        readOptions = ctrl.getCountriesList();
        system.assertEquals('Choose One', readOptions[0].getValue());   //test constructor values.
        system.assertEquals('Choose One', readOptions[0].getLabel());   //test constructor values.
        readOptions.clear();                                            //reset
        readOptions = ctrl.getStatesList();
        system.assertEquals('Choose Country First', readOptions[0].getValue()); //test constructor values.
        system.assertEquals('Choose Country First', readOptions[0].getLabel()); //test constructor values.
        readOptions.clear();
        readOptions = ctrl.buildPhoneTypes();                           //see base controller
        system.assertEquals(3, readOptions.size());
        test.stopTest();
    }
    static testMethod void test_setnewSubscriber(){
        test.startTest();
        list<Account> AccountList = [SELECT Id, Name FROM Account LIMIT 1];
        contact objContact = new Contact();
        objContact.LastName = 'Test';
        insert objContact;
        Activation_Order__c testOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        Activation_Status__c testStatus = [SELECT Id FROM Activation_Status__c WHERE Activation_Order__c =: testOrder.Id LIMIT 1];
        Activation_Corporate_Company ctrl = new Activation_Corporate_Company();
        ctrl.ActOrderId = (string)testOrder.Id;     //convert to string (see base controller)
        ctrl.ActStatus = testStatus;                //see base controller
        ctrl.newSubscriber = ctrl.getNewSubscriber();
        ctrl.newSubscriber.Country__c = 'US';
        ctrl.newSubscriber.Activation_Order__c = null;
        ctrl.selectedTab = 'Invoicing_Preferences';     //test that FinalTab thing
        PageReference pageRef = page.Account_Setup;
        pageRef.getParameters().put('mainContactId', objContact.Id);
        pageRef.getParameters().put('CorporateAccountId', AccountList[0].Id);
        Test.setCurrentPage(pageRef);
        ctrl.saveandExit();
        ctrl.setnewSubscriber();
        ctrl.newSubscriber = null;
        Activation_Subscriber__c readSubscriber = ctrl.getnewSubscriber();
        system.assertEquals(readSubscriber.Country__c, 'US');
        test.stopTest();
    }
    static testMethod void testComponentCountryChangeHandler(){
        //Validating Test Data
        Activation_Order__c ActOrder = [SELECT Id, Name,isSelf_Activation__c FROM Activation_Order__c LIMIT 1];
        system.assertEquals(true,ActOrder.isSelf_Activation__c);
        Activation_Corporate_Company accc = New Activation_Corporate_Company();
        list<selectOption> readOptions = new list<selectOption>();      // we will reuse this...
        
        test.startTest();
        accc.newSubscriber = accc.getNewSubscriber();
        accc.newSubscriber.Country__c = 'US'; 
        accc.newSubscriber.State_Province__c = 'choose one';        
        accc.componentCountryChangeHandler();
        readOptions = accc.getStatesList();
        system.assert(readOptions.size() > 2 );  
        accc.componentStateChangeHandler();
        test.stopTest();
    }
}