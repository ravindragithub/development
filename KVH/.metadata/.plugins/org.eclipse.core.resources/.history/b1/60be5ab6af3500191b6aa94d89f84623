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
Private class Act_Contact_list_component_ctrl_test{
    
    @testSetup static void setupTestData(){
        //create test data
        Activation_Order__c objActivationOrder = new Activation_Order__c();
        objActivationOrder.isSelf_Activation__c = true;
        objActivationOrder.User_Agent_String__c = 'test User-Agent string';
        insert objActivationOrder;
        
        Activation_Status__c objOrderStatus = new Activation_Status__c();
        objOrderStatus.Activation_Order__c = objActivationOrder.Id;
        insert objOrderStatus;
        
        Activation_Contact__c objActivationContact = new Activation_Contact__c();
        objActivationContact.Activation_Order__c = objActivationOrder.id;
        objActivationContact.Contact_Role__c = 'Authorized Representative';
        objActivationContact.Email__c = 'test@4test.com';
        insert objActivationContact;
        
    }
    
    static testMethod void testActivationContactListMethod(){
        
        Activation_Order__c objActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        PageReference thePage = page.Account_Setup;     
        Test.setCurrentPage(thePage);																							// set current page with parameter 'order'
        
        Test.startTest();
        Act_Contact_list_component_controller objActContactlistcompcontroller = New Act_Contact_list_component_controller();
        system.assertEquals(null, objActContactlistcompcontroller.ActOrderId);  												// Order Id null
        list<Activation_Contact__c> lstActivationContactsReturned = objActContactlistcompcontroller.getActivationContactList();	// Before Activation Order Id
        
        system.assertEquals(null, lstActivationContactsReturned); 									// check return value is equal to null
        thePage.getParameters().put('order', objActOrder.Id);
        objActContactlistcompcontroller.ActOrderId = (string)objActOrder.Id;    												// Asign Activation Order Id 
        lstActivationContactsReturned = objActContactlistcompcontroller.getActivationContactList();             				// After Activation Order Id 
        
        list<Activation_Contact__c> lstActivationContacts = New list<Activation_Contact__c>();
        lstActivationContacts = [SELECT Id, Email__c, Contact_Role__c FROM Activation_Contact__c WHERE Activation_Order__c =: objActOrder.Id];
        system.assertEquals(lstActivationContacts.size(), lstActivationContactsReturned.size()); 								// check return value list size is equal
        
        system.assertEquals('test@4test.com', lstActivationContacts[0].Email__c);   											// Activation Contact Email validate
        objActContactlistcompcontroller.strActivationContact = (string)lstActivationContacts[0].Id; 							// passing activation contact Id
        objActContactlistcompcontroller.EditContact();                          												// edit activation contact record based on passed Id
        system.assertEquals((string)lstActivationContacts[0].Id,thePage.getParameters().get('conActID'));
        system.assertEquals('System.PageReference[/apex/account_setup?conActID='+(string)lstActivationContacts[0].Id+'&order='+(string)objActOrder.Id+']',string.valueOf(thePage)); // return page reference validate
        objActContactlistcompcontroller.RemoveRole(); // remove selected contact;
        system.assertEquals('System.PageReference[/apex/account_setup?order='+(string)objActOrder.Id+']',string.valueOf(thePage)); // return page reference validate
        Test.stopTest();
    }
}