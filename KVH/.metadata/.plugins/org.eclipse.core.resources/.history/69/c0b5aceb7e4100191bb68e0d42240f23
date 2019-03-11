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
private class Activation_ThankYou_Controller_Test {
    
    @testSetup static void setupTestData(){
        Account objAccount = New Account();
        objAccount.Name = 'Test Account';
        objAccount.Phone = '2327039234';
        objAccount.KVH_Sales_Office__c = 'TBD';
        objAccount.Prospect_Type__c = 'Customer';
        insert objAccount;
        
        Case objCase = New Case();
        objCase.Subject = 'Test Case';
        insert objCase;
        
        Opportunity objOpportunity = New Opportunity();
        objOpportunity.AccountID = objAccount.id;
        objOpportunity.Name = 'Test Opp';
        objOpportunity.LeadSource = 'Website';
        objOpportunity.CloseDate = system.today()+5;
        objOpportunity.StageName = 'Quote'; 
        objOpportunity.Description = 'New Online Activation';
        objOpportunity.RecordTypeID = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('Mobile Broadband').RecordTypeId;
        insert objOpportunity;
        
        Activation_Order__c testActOrder = new Activation_Order__c();
        testActOrder.isSelf_Activation__c = true;
        testActOrder.Case__c = objCase.Id;
        testActOrder.User_Agent_String__c = 'test User-Agent string';
        testActOrder.Activation_Opportunity__c = objOpportunity.Id;
        insert testActOrder;
        
        Activation_Status__c testOrderStatus = new Activation_Status__c();
        testOrderStatus.Activation_Order__c = testActOrder.Id;
        insert testOrderStatus;
        testOrderStatus.Services_Type_Last_Active_Tab_Index__c = null;
        update testOrderStatus; 
        
        Activation_Subscriber__c objActivationSubscriber = New Activation_Subscriber__c();
        objActivationSubscriber.Activation_Order__c = testActOrder.id;
        insert objActivationSubscriber;
        
        Activation_Dealer__c objActivationDealer = New Activation_Dealer__c();
        objActivationDealer.Activation_Order__c = testActOrder.id;
        insert objActivationDealer;
        
        Customer_Profile__c objCustomerProfile = New Customer_Profile__c();
        objCustomerProfile.Activation_Order__c = testActOrder.id;
        objCustomerProfile.Customer_Profile_Id__c = '2343234';
        insert objCustomerProfile;
        
        Payment_Profile__c objPaymentProfile = New Payment_Profile__c();
        objPaymentProfile.Customer_Profile__c = objCustomerProfile.Id;
        objPaymentProfile.Payment_Profile_Id__c = '234234';
        insert objPaymentProfile;
        
        Activation_Contact__c objActivationContact = new Activation_Contact__c();
        objActivationContact.Activation_Order__c = testActOrder.id;
        objActivationContact.Email__c = 'test@4test.com';
        objActivationContact.contact_Role__c ='Onboard Contact, System Support Contact,Main Contact,Billing Representative,Authorized Representative,Invoice Recipient';
        
        insert objActivationContact;
        
        Activation_Contact__c objActivationContact1 = new Activation_Contact__c();
        objActivationContact1.Activation_Order__c = testActOrder.id;
        objActivationContact1.Email__c = 'test@4test.com';
        objActivationContact1.contact_Role__c ='Onboard Contact, System Support Contact,Main Contact,Invoice Recipient,Authorized Representative';
        
        insert objActivationContact1;
        
        String strActivationHardwareRecordTypeId = Schema.SObjectType.Activation_Hardware__c.getRecordTypeInfosByName().get('Activation System').getRecordTypeId();

        Activation_Hardware__c objActivationHardware = New Activation_Hardware__c();
        objActivationHardware.Activation_Order__c = testActOrder.id;
        objActivationHardware.RecordTypeId = strActivationHardwareRecordTypeId;
        objActivationHardware.System_Name__c = 'Test V3';
        objActivationHardware.System_Name_Group__c = 'V3';
        insert objActivationHardware;
        
        Activation_Platform__c objActivationPlatform = New Activation_Platform__c();
        objActivationPlatform.Activation_Order__c = testActOrder.id;
        insert objActivationPlatform;
    }
    
    static testMethod void test_Activation_ThankYou_Controller() {
        Activation_Order__c ActOrder;
        ActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        PageReference thePage = page.Services;
        thePage.getParameters().put('order', ActOrder.Id);
        Test.setCurrentPage(thePage);
        Test.startTest();
        Activation_ThankYou_Controller objActivationThankYouController = new Activation_ThankYou_Controller();
        Activation_Status__c ActOrderStatus = objActivationThankYouController.ActivationStatus; 
        Test.stopTest();
    }
}