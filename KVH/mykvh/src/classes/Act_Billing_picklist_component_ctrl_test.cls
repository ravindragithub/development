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
Private Class Act_Billing_picklist_component_ctrl_test{
    
    @testSetup static void setupTestData(){
        
        Activation_Order__c objActivationOrder = new Activation_Order__c();
        objActivationOrder.isSelf_Activation__c = true;
        objActivationOrder.User_Agent_String__c = 'test User-Agent string';
        insert objActivationOrder;
        
        Activation_Status__c objOrderStatus = new Activation_Status__c();
        objOrderStatus.Activation_Order__c = objActivationOrder.Id;
        insert objOrderStatus;
        
        Activation_Contact__c objActivationContact = new Activation_Contact__c();
        objActivationContact.Activation_Order__c = objActivationOrder.id;
        objActivationContact.Email__c = 'test@4test.com';
        objActivationContact.Contact_Role__c = 'Contact Role';
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
        objActivationSubscriber.Contact_Role__c = 'Subscriber';
        objActivationSubscriber.State_Province__c = 'Rhode Island';
        objActivationSubscriber.Phone_Number__c = '401-555-1212';
        objActivationSubscriber.Billing_Rep_Name__c = 'TestName';
        objActivationSubscriber.Activation_Order__c = objActivationOrder.id;
        insert objActivationSubscriber;
    }
    
    static testMethod void testActivationBillingPicklistContactMethod(){
        Activation_Order__c objActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        PageReference thePage = page.Account_Setup;     
        thePage.getParameters().put('order', objActOrder.Id);                   // set current page with parameter 'order'
        Test.setCurrentPage(thePage);
        
        Test.startTest();
        Act_Billing_picklist_component_ctrl objActBillingpicklistcompctrl = new Act_Billing_picklist_component_ctrl();
        system.assertEquals(objActOrder.Id, objActBillingpicklistcompctrl.ActOrderId);    // Order Id 
        objActBillingpicklistcompctrl.parentContainer = 'ActivationInvoiceSelection'; // pass selected TAB
        list<SelectOption> lstSubscribersAndContactsReturned =  objActBillingpicklistcompctrl.getSameAsBillingList();
        objActBillingpicklistcompctrl.selectedSubscriberOrContactId();
        system.assertEquals(2, lstSubscribersAndContactsReturned.size());       //check returned selectoption size Before Activation Order Id
        objActBillingpicklistcompctrl.ActOrderId = (string)objActOrder.Id;      // Asign Activation Order Id
        lstSubscribersAndContactsReturned = objActBillingpicklistcompctrl.getSameAsBillingList();
        system.assertEquals(2, lstSubscribersAndContactsReturned.size());       // check returned selectoption size After Activation Order Id
        
        Activation_Contact__c objActivationContact = new Activation_Contact__c();
        objActivationContact = [SELECT Id, Email__c, Contact_Role__c FROM Activation_Contact__c WHERE Activation_Order__c =: objActOrder.Id LIMIT 1]; 
        system.assertEquals('test@4test.com', objActivationContact.Email__c);   // Activation Contact Email validate
        objActBillingpicklistcompctrl.strSelectedSubscriberOrContactId = ''; // passing null
        objActBillingpicklistcompctrl.selectedSubscriberOrContactId(); // pass param to url and redirect page
        objActBillingpicklistcompctrl.strSelectedSubscriberOrContactId = (string)objActivationContact.Id; // passing activation contact Id
        objActBillingpicklistcompctrl.selectedSubscriberOrContactId();          // pass param to url based on contact Id and redirect page
        system.assertEquals('System.PageReference[/apex/account_setup?conActID='+(string)objActivationContact.Id+'&order='+(string)objActOrder.Id+']',string.valueOf(thePage)); // return page reference validate

        Test.stopTest();
    }
    
  /*  static testMethod void testActivationBillingPicklistSubscriberMethod(){
        Activation_Order__c objActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        PageReference thePage = page.Account_Setup;     
        thePage.getParameters().put('order', objActOrder.Id);
        Test.setCurrentPage(thePage);   // set current page with parameter 'order'
        
        Test.startTest();
        Act_Billing_picklist_component_ctrl objActBillingpicklistcompctrl = new Act_Billing_picklist_component_ctrl();
        objActBillingpicklistcompctrl.ActOrderId = (string)objActOrder.Id; 
        
        Activation_Subscriber__c objActivationSubscriber = new Activation_Subscriber__c();
        objActivationSubscriber = [SELECT Id, Phone_Number__c  FROM Activation_Subscriber__c WHERE Activation_Order__c =: objActOrder.Id LIMIT 1]; 
        system.assertEquals('401-555-1212', objActivationSubscriber.Phone_Number__c);   // Activation Subscriber Phone validate
        
        objActBillingpicklistcompctrl.strSelectedSubscriberOrContactId = ''; // passing null
        objActBillingpicklistcompctrl.selectedSubscriberOrContactId(); // pass param to url and redirect page
        objActBillingpicklistcompctrl.strSelectedSubscriberOrContactId = (string)objActivationSubscriber.Id; // passing activation subscriber Id
        objActBillingpicklistcompctrl.selectedSubscriberOrContactId();  // pass param to url based on subscriber Id and redirect page
        system.assertEquals('System.PageReference[/apex/account_setup?order='+(string)objActOrder.Id+'&subsActID='+(string)objActivationSubscriber.Id+']',string.valueOf(thePage)); // return page reference validate

        Test.stopTest();
    }*/
    
}