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
private class Contract_Details_Controller_Test {
    @testSetup static void setupTestData(){
        
        Activation_Order__c testActOrder = new Activation_Order__c();
        testActOrder.isSelf_Activation__c = true;
        testActOrder.User_Agent_String__c = 'test User-Agent string';
        insert testActOrder;
        
        Activation_Status__c testOrderStatus = new Activation_Status__c();
        testOrderStatus.Activation_Order__c = testActOrder.Id;
        insert testOrderStatus;
        testOrderStatus.Services_Type_Last_Active_Tab_Index__c = null;
        update testOrderStatus; 

        Activation_Service__c objActivationService = New Activation_Service__c();
        objActivationService.Activation_Order__c = testActOrder.id;
        objActivationService.Activation_Plan_Type__c ='Test Product Bundle';
        insert objActivationService;
    }
    
    static testMethod void testContract_Details_Controller(){
         Activation_Order__c ActOrder;
        ActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        PageReference thePage = page.Contract_Details;
        thePage.getParameters().put('order', ActOrder.Id);
        Test.setCurrentPage(thePage);
        Test.startTest();
        Contract_Details_Controller objContractDetailsController = new Contract_Details_Controller();
        Activation_Status__c ActOrderStatus = objContractDetailsController.ActivationStatus; 
        system.assertEquals(ActOrder.Id, ActOrderStatus.Activation_Order__c);
        system.assertEquals('Contract Details', ActOrderStatus.Active_Page__c);
        system.assertEquals('available', ActOrderStatus.Contract_Details_Page__c);
        PageReference pageRef1 =  objContractDetailsController.gototab();
        PageReference pageRef = page.Review_Activation_Order;   
        objContractDetailsController.selectedTab = 'Service_Summary';
        objContractDetailsController.strServiceStartDate = '2016-Dec-06';
        objContractDetailsController.strServicePreActivationDate = '2016-Dec-06';
        objContractDetailsController.updateActivationOrderContract();
        pageRef1 = objContractDetailsController.goToTab();
        pageRef.getParameters().put('order',pageRef1.getParameters().get('order'));
        system.assertEquals(pageRef.getUrl(),pageRef1.getUrl());
        
        pageRef = page.ActivationOneCare;   
        objContractDetailsController.selectedTab = 'Extended_Warranty';
        pageRef1 = objContractDetailsController.goToTab();
        pageRef.getParameters().put('order',pageRef1.getParameters().get('order'));
        system.assertEquals(pageRef.getUrl(),pageRef1.getUrl());
        ActOrderStatus.Contract_Details_Active_Tab__c = 'Contract_Details';
        update ActOrderStatus;
        objContractDetailsController = new Contract_Details_Controller();
        system.assertEquals('Contract_Details', objContractDetailsController.ActivationStatus.Contract_Details_Active_Tab__c);
    }
}