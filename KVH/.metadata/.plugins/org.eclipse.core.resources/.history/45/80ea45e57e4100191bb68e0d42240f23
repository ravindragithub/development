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
Private Class Act_Billing_component_controller_test {
   
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
       objActivationSubscriber.State_Province__c = 'Rhode Island';
       objActivationSubscriber.Phone_Number__c = '401-555-1212';
       objActivationSubscriber.Billing_Rep_Name__c = 'TestName';
       objActivationSubscriber.Activation_Order__c = objActivationOrder.id;
       insert objActivationSubscriber;
   }
   
   static testMethod void testActivationBillingSubscriberMethod(){
       Activation_Order__c objActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
       PageReference thePage = page.Account_Setup;     
       thePage.getParameters().put('order', objActOrder.Id);                   // set current page with parameter 'order'
       Test.setCurrentPage(thePage);
       Test.startTest(); 
       Act_Billing_component_controller objActBillingSectioncontroller = new Act_Billing_component_controller();
       system.assertEquals(objActOrder.Id, objActBillingSectioncontroller.ActOrderId);     // Passed Order Id
       //objActBillingSectioncontroller.getCountriesList();   // get all country list
       //objActBillingSectioncontroller.getStatesList();      // get State list
       //objActBillingSectioncontroller.componentStateChangeHandler();
       objActBillingSectioncontroller.componentStateChangeHandlerBilling();
       
       objActBillingSectioncontroller.copySubscriberAddress = true;
       objActBillingSectioncontroller.callDisableFunction();
       objActBillingSectioncontroller.mapAddressMapping();
       //objActBillingSectioncontroller.readcontact();
       objActBillingSectioncontroller.copySubscriberAddress = false;
       objActBillingSectioncontroller.callDisableFunction();
       
       objActBillingSectioncontroller.actStatus = [SELECT Id,Activation_Order__c FROM Activation_Status__c WHERE Activation_Order__c =:objActOrder.Id LIMIT 1];
       objActBillingSectioncontroller.selectedTab = 'Invoicing_Preferences'; //Pass Selected Tab
       objActBillingSectioncontroller.copySubscriberAddress = true;
       objActBillingSectioncontroller.objSubscriber = New Activation_Subscriber__c(Contact_Role__c ='Subscriber', Activation_Order__c = objActOrder.Id); // to cover null id condition
       objActBillingSectioncontroller.strContactRole = 'Onboard Contact';
       objActBillingSectioncontroller.parentContainer = 'Dummy Container';
       objActBillingSectioncontroller.Save();
       system.assertEquals('System.PageReference[/apex/account_setup?order='+(string)objActOrder.Id+']',string.valueOf(thePage)); // return page reference validate
       objActBillingSectioncontroller.saveandExit();
       Test.stopTest();
   } 
   
   static testMethod void testActivationBillingContactMethod(){
       Activation_Order__c objActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
       Activation_Contact__c objActivationContact =  [SELECT Id, Email__c, Contact_Role__c FROM Activation_Contact__c WHERE Activation_Order__c =: objActOrder.Id LIMIT 1]; 
       Activation_Subscriber__c objActivationSubscriber = [SELECT Id, Phone_Number__c,contact_Role__c  FROM Activation_Subscriber__c WHERE Activation_Order__c =: objActOrder.Id LIMIT 1]; 
       PageReference thePage = page.Account_Setup;     
       thePage.getParameters().put('order', objActOrder.Id);                   // set current page with parameter 'order'
       thePage.getParameters().put('conActID', objActivationContact.Id);
       Test.setCurrentPage(thePage);
       Test.startTest();
       Act_Billing_component_controller objActBillingSectioncontroller = new Act_Billing_component_controller();
       //objActBillingSectioncontroller.strActivationContact = objActivationContact.Id;
       objActBillingSectioncontroller.copySubscriberAddress = true;
       objActBillingSectioncontroller.callDisableFunction();
       objActBillingSectioncontroller.copySubscriberAddress = false;
       objActBillingSectioncontroller.callDisableFunction();
       system.assertEquals(objActOrder.Id, objActBillingSectioncontroller.ActOrderId);     // Passed Order Id 
       //system.assertEquals(objActivationContact.Id, objActBillingSectioncontroller.objSubscriber.Id);   // validate returned record
       Test.stopTest();
   }
   
   static testMethod void testActivationBillingEmptyListHandling(){
       Activation_Order__c objActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
       Activation_Subscriber__c objActivationSubscriber = [SELECT Id, Phone_Number__c  FROM Activation_Subscriber__c WHERE Activation_Order__c =: objActOrder.Id LIMIT 1]; 
       PageReference thePage = page.Account_Setup;
       //test for null Activation Contact
       thePage.getParameters().put('order', objActOrder.Id);                   // set current page with parameter 'order'
       thePage.getParameters().put('conActID', null);                          // set current page with parameter 'conActID' to null
       Test.setCurrentPage(thePage);
       Test.startTest();
       Act_Billing_component_controller objActBillingSectioncontroller = new Act_Billing_component_controller();
       system.assertEquals(objActOrder.Id, objActBillingSectioncontroller.ActOrderId);     // Passed Order Id 
       
       thePage.getParameters().clear();
       //test for blank Activation Subscriber
       thePage.getParameters().put('order', objActOrder.Id);                   // set current page with parameter 'order'
       thePage.getParameters().put('subsActID', objActivationSubscriber.id);                           // set current page with parameter 'subsActID' to blank
       Act_Billing_component_controller objActBillingSectioncontroller1 = new Act_Billing_component_controller();
       
       //test for proper Activation Subscriber role
       thePage.getParameters().clear();
       thePage.getParameters().put('order', objActOrder.Id);                   // set current page with parameter 'order'
       objActivationSubscriber.Contact_Role__c = 'Subscriber, Billing Representative';
       update objActivationSubscriber;
       Act_Billing_component_controller objActBillingSectioncontroller2 = new Act_Billing_component_controller();
       
   } 

}