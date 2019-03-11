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
Private Class Activation_Invoice_Payment_test{
    
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
        objActivationSubscriber.Contact_Role__c = 'Subscriber';
        objActivationSubscriber.State_Province__c = 'Rhode Island';
        objActivationSubscriber.Phone_Number__c = '401-555-1212';
        objActivationSubscriber.Billing_Rep_Name__c = 'TestName';
        objActivationSubscriber.Activation_Order__c = objActivationOrder.id;
        insert objActivationSubscriber;
    }
    
    static testMethod void testActivation_Invoice_Payment(){
        Activation_Order__c objActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        PageReference thePage = page.Account_Setup;   
        thePage.getParameters().put('order', objActOrder.Id);  
        Test.setCurrentPage(thePage);                                              // set current page with parameter 'order'
        
        Test.startTest();
            Activation_Invoice_Payment aip = New Activation_Invoice_Payment();
            
            
           
            List<Activation_Subscriber__c> aSubTrue = [SELECT id,Pay_from_sub_account_invoices__c,Bill_to__c,Pay_from_corporate_account_summary__c,Subscriber_Custom_Call_AccountID__c,Parent_Account_Custom_Call_Account_ID__c
                                                               FROM Activation_Subscriber__c WHERE Activation_Order__c=:objActOrder.Id];
            
            aip.setasub(aSubTrue);
            aip.getaSub();
            //When we selecting Customer Bill Type
            aip.SelectedPaymentType = 'first';
            aip.selectedInvoicePayment();
            
            
            aSubTrue = [SELECT id,Pay_from_sub_account_invoices__c,Bill_to__c,Pay_from_corporate_account_summary__c,Subscriber_Custom_Call_AccountID__c,Parent_Account_Custom_Call_Account_ID__c
                                                               FROM Activation_Subscriber__c WHERE Activation_Order__c=:objActOrder.Id];
            
            aip.setasub(aSubTrue);
            aip.getaSub();
            aip.selectedInvoicePayment();
            
            
            system.assertEquals(aSubTrue[0].Pay_from_sub_account_invoices__c,true);
            
            aip.SelectedPaymentType = 'second';
            aip.selectedInvoicePayment();
            
            aSubTrue = [SELECT id,Pay_from_sub_account_invoices__c,Bill_to__c,Pay_from_corporate_account_summary__c,Subscriber_Custom_Call_AccountID__c,Parent_Account_Custom_Call_Account_ID__c
                                                                 FROM Activation_Subscriber__c WHERE Activation_Order__c=:objActOrder.Id];
            aip.setasub(aSubTrue);
            aip.getaSub();
            aip.selectedInvoicePayment();
            
            system.assertEquals(aSubTrue[0].Pay_from_sub_account_invoices__c,false);
            
            
            aip.SelectedPaymentType = 'third';
            aip.selectedInvoicePayment();
            
            aSubTrue = [SELECT id,Pay_from_sub_account_invoices__c,Bill_to__c,Pay_from_corporate_account_summary__c,Subscriber_Custom_Call_AccountID__c,Parent_Account_Custom_Call_Account_ID__c
                                                                 FROM Activation_Subscriber__c WHERE Activation_Order__c=:objActOrder.Id];
            aip.setasub(aSubTrue);
            aip.getaSub();
            aip.selectedInvoicePayment();
            
        Test.StopTest();
    }
}