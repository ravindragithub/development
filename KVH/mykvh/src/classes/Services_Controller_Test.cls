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
private class Services_Controller_Test {
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
        
        Activation_Contact__c objActivationContact = new Activation_Contact__c();
        objActivationContact.Activation_Order__c = testActOrder.id;
        objActivationContact.Email__c = 'test@4test.com';
        objActivationContact.contact_Role__c ='Onboard Contact, System Support Contact';
        
        insert objActivationContact;
        
        Activation_Service__c objActivationService = New Activation_Service__c();
        objActivationService.Activation_Order__c = testActOrder.id;
        objActivationService.Activation_Plan_Type__c ='Metered Rate Plans';
        insert objActivationService;
        
        Activation_Platform__c objActivationPlatform = New Activation_Platform__c();
        objActivationPlatform.Activation_Order__c = testActOrder.id;
        objActivationPlatform.Confirm_if_boat_yacht_is_chartered__c = 'Yes';
        objActivationPlatform.Market__c = 'Leisure';
        insert objActivationPlatform; 
        
        String strActivationHardwareRecordTypeId = Schema.SObjectType.Activation_Hardware__c.getRecordTypeInfosByName().get('Activation System').getRecordTypeId();

        Activation_Hardware__c objActivationHardware = New Activation_Hardware__c();
        objActivationHardware.System_Name__c = 'Test System V3';
        objActivationHardware.RecordTypeId = strActivationHardwareRecordTypeId;
        objActivationHardware.System_Name_Group__c = 'V3';
        objActivationHardware.Activation_Order__c = testActOrder.id;
        insert objActivationHardware;
       
        Product2 objProduct1 = New Product2();
        objProduct1.Name= 'Metered Rate Plans';
        insert objProduct1;
        
        Activation_Product_Bundle__c objActivationProductBundle = New Activation_Product_Bundle__c();
        objActivationProductBundle.Name = 'Metered Rate Plans';
        objActivationProductBundle.Actual_Name__c = 'Metered Rate Plans';
        objActivationProductBundle.Product_Bundle_Id__c =  objProduct1.Id;
        insert objActivationProductBundle;
    }
    
    static testMethod void testServices_ControllerConstructor() {
        Activation_Order__c ActOrder;
        ActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        PageReference thePage = page.Services;
        thePage.getParameters().put('order', ActOrder.Id);
        Test.setCurrentPage(thePage);
        Test.startTest();
        Services_Controller objServicesController = new Services_Controller();
        Activation_Status__c ActOrderStatus = objServicesController.ActivationStatus; 
        system.assertEquals(ActOrder.Id, ActOrderStatus.Activation_Order__c);
        system.assertEquals('Subscriptions', ActOrderStatus.Active_Page__c);
        system.assertEquals('available', ActOrderStatus.Services_Page__c);
        //test with existing active tab...
        ActOrderStatus.Services_Active_Tab__c = 'Plan_Types';
        ActOrderStatus.Services_Type_Last_Active_Tab_Index__c =1;
        upsert ActOrderStatus;
        system.assertEquals(1, ActOrderStatus.Services_Type_Last_Active_Tab_Index__c);	
        objServicesController = new Services_Controller(); //re-instanciate
        ActOrderStatus = objServicesController.ActivationStatus; 
        objServicesController.selectedTab = 'Additional_Plans_and_Services';
        PageReference pageRef1 =  objServicesController.gototab();
        system.assertEquals(ActOrder.Id, ActOrderStatus.Activation_Order__c);
        system.assertEquals('Subscriptions', ActOrderStatus.Active_Page__c);	
        system.assertEquals('available', ActOrderStatus.Services_Page__c);
        system.assertEquals('Additional_Plans_and_Services', ActOrderStatus.Services_Active_Tab__c);
        Test.stopTest();
    }
    
    static testMethod void testServices_Controller() {
        Activation_Order__c ActOrder;
        ActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        PageReference thePage = page.Services;
        thePage.getParameters().put('order', ActOrder.Id);
        Test.setCurrentPage(thePage);
        Test.startTest();
        
        Services_Controller objServicesController = new Services_Controller();
        objServicesController.strPlanName = 'Test Product Bundle';
        system.assertEquals('V3', objServicesController.objActivationService.VSAT_Antenna_Hardware__c);
        objServicesController.updateActivationService();
        system.assertEquals('Test Product Bundle', objServicesController.objActivationService.Activation_Plan_Type__c);
        
        PageReference pageRef1 =  objServicesController.gototab();
        PageReference pageRef = page.Review_Activation_Order_1;  
        objServicesController.selectedTab = '';
        
        pageRef1 =  objServicesController.gototab();
        pageRef.getParameters().put('order',pageRef1.getParameters().get('order'));
        system.assertEquals(pageRef.getUrl(),pageRef1.getUrl());
        
        objServicesController.selectedTab = 'Technical_Assistance_Package';
        pageRef1 =  objServicesController.gototab();
        List<SelectOption> bandwidthManagementControl = objServicesController.bandwidthManagementControl; // get all bandwidthManagementControl

        objServicesController.objActivationService.VSAT_Antenna_Hardware__c = null;
        objServicesController.objActivationService.Activation_Plan_Type__c = '';
        objServicesController.updateActivationService1();
        //objServicesController.gototab();
        //system.assertEquals(pageRef.getUrl(),pageRef1.getUrl());
        
        Activation_Hardware__c objActivationHardware = [SELECT Id,Name,System_Name_Group__c FROM Activation_Hardware__c WHERE Activation_Order__c =: ActOrder.Id LIMIT 1];
        objActivationHardware.System_Name_Group__c = 'V7';
        update objActivationHardware; // different system
        objServicesController = new Services_Controller();
        system.assertEquals('V7', objServicesController.objActivationService.VSAT_Antenna_Hardware__c);
        Test.stopTest();
    }
    
}