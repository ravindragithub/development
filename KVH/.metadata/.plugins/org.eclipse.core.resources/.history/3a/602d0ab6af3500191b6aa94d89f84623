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
Private Class Act_Contact_component_controller_Test{
    
    @testSetup static void setupTestData(){
        
        Activation_Order__c testActOrder = new Activation_Order__c();
        testActOrder.isSelf_Activation__c = true;
        testActOrder.User_Agent_String__c = 'test User-Agent string';
        insert testActOrder;
        
        Activation_Status__c testOrderStatus = new Activation_Status__c();
        testOrderStatus.Activation_Order__c = testActOrder.Id;
        testOrderStatus.Account_Setup_Active_Tab__c = 'Not_Invoicing_Preferences';
        insert testOrderStatus;
        
        Activation_Contact__c actcon = new Activation_Contact__c();
        actcon.Activation_Order__c = testActOrder.id;
        actcon.Email__c = 'test@4Test.com';
        insert actcon;
        
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
        objActivationSubscriber.contact_Role__c ='Subscriber, Onboard Contact';
        objActivationSubscriber.State_Province__c = 'Rhode Island';
        objActivationSubscriber.Phone_Number__c = '401-555-1212';
        objActivationSubscriber.Billing_Rep_Name__c = 'TestName';
        objActivationSubscriber.Activation_Order__c = testActOrder.id;
        insert objActivationSubscriber;
    }
    
    //if Existing activation Contact Updates
    static testMethod void testConstructor(){
        Act_Contact_component_controller util = new Act_Contact_component_controller();
        list<selectOption> readOptions = new list<selectOption>();
        readOptions = util.getCountriesList();
        system.assertEquals('Choose One', readOptions[0].getLabel());
        readOptions.clear();
        readOptions = util.getStatesList();
        //system.assertEquals('Choose Country First', readOptions[0].getLabel());
        readOptions.clear();
        util.componentStateChangeHandler();         //Method doesn't really do anything.....
        util.parentContainer = 'Dummy Container';
    }
    
    static testMethod void testSave(){
        Test.startTest();
        Activation_Order__c ActOrder;
        ActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        Activation_Contact__c objActivationContact =  [SELECT Id,Activation_Order__c, Email__c, Contact_Role__c FROM Activation_Contact__c WHERE Activation_Order__c =: ActOrder.Id LIMIT 1]; 
        
        PageReference thePage = page.Account_Setup;     
        thePage.getParameters().put('order', ActOrder.Id);
        //thePage.getParameters().put('conActID', objActivationContact.Id);
        Test.setCurrentPage(thePage);
        
        Activation_Status__c objActivationStatus = [SELECT Id,name,Account_Setup_Active_Tab__c FROM Activation_Status__c WHERE Activation_Order__c =: ActOrder.Id LIMIT 1];
        Act_Contact_component_controller util = new Act_Contact_component_controller();
        util.ActOrderId = (string)ActOrder.Id;
        util.actCon.Email__c = 'test@actcon.com';
        util.actStatus = objActivationStatus;
        util.SaveFromAccountSetup();
        util.strContactRole ='Onboard Contact';
        util.SaveFromInstallationType();
        util.SaveFromInstallationTypeSaveAndExit();
        Activation_Contact__c foundSavedContact = new Activation_Contact__c();
        for(Activation_Contact__c ac: [SELECT Id, Email__c, Contact_Role__c FROM Activation_Contact__c WHERE Activation_Order__c =: ActOrder.Id] ){
            if(ac.Email__c == 'test@actcon.com'){
                foundSavedContact = ac;
            }
        }
        system.assert(foundSavedContact != null);                                                       //we actually found one...
        system.assertEquals('test@actcon.com', foundSavedContact.Email__c);                             //with the right Email...
        
        thePage.getParameters().put('Role', 'Group');
        util.actCon = New Activation_Contact__c(Contact_Role__c ='Group Invoice Recipient');
        util.SaveFromAccountSetup();
       // util.actCon = New Activation_Contact__c();  // To satisfy  Activation Order null condition on SaveFromAccountSetup method
       // util.SaveFromAccountSetup();
        util.SaveFromCorporateSetup();
        util.gotospecifictab();

        util.strContactRole ='Onboard Contact';
        util.actCon = New Activation_Contact__c();  // To satisfy  Activation Order null condition on SaveFromInstallationType method
        util.SaveFromInstallationType();
        util.SaveFromAccountSetupSaveAndExit();
        
        Test.stopTest();
    }
    
    static testMethod void testSaveNewGroup(){
        Test.startTest();
        Activation_Order__c ActOrder;
        ActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        Activation_Subscriber__c objActivationSubscriber = [SELECT Id, Phone_Number__c,Contact_Role__c,Activation_Order__c  FROM Activation_Subscriber__c WHERE Activation_Order__c =: ActOrder.Id LIMIT 1]; 
        Activation_Contact__c objActivationContact =  [SELECT Id, Email__c, Contact_Role__c,Activation_Order__c FROM Activation_Contact__c WHERE Activation_Order__c =: ActOrder.Id LIMIT 1]; 
        PageReference thePage = page.Account_Setup;     
        thePage.getParameters().put('order', ActOrder.Id);
        thePage.getParameters().put('subsActID', objActivationSubscriber.Id);
        Test.setCurrentPage(thePage);
        Activation_Status__c objActivationStatus = [SELECT Id,name,Account_Setup_Active_Tab__c FROM Activation_Status__c WHERE Activation_Order__c =: ActOrder.Id LIMIT 1];
        
        Act_Contact_component_controller util = new Act_Contact_component_controller();
        util.ActOrderId = (string)ActOrder.Id;
        util.actCon.Email__c = 'test@actcon.com';
        util.actStatus = objActivationStatus;
        thePage.getParameters().put('Role', 'Group');
        util.SaveFromAccountSetup();
        util.strContactRole ='Onboard Contact';
        util.SaveFromInstallationType();
        system.assertEquals('Group Invoice Recipient, Onboard Contact', util.actCon.Contact_Role__c);      //and with the right Contact Role...
        
        thePage.getParameters().clear();
        //test for blank Activation Contact
        thePage.getParameters().put('order', ActOrder.Id);                   // set current page with parameter 'order'
        thePage.getParameters().put('conActID', objActivationContact.id); 
        Act_Contact_component_controller util1 = new Act_Contact_component_controller();
        util1.actStatus = objActivationStatus;
        update objActivationSubscriber; // update the record for trigger
        util1.selectedTab = 'System_Type';
        util1.SaveFromInstallationType(); // return next page
        Test.stopTest();
    }
}