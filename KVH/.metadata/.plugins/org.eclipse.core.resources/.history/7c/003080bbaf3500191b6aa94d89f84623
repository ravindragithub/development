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
private class Act_Service_Info_Component_Ctrl_Test {
    
    @testSetup static void setupTestData(){
      
        Activation_Order__c testActOrder = new Activation_Order__c();
        testActOrder.isSelf_Activation__c = true;
        testActOrder.User_Agent_String__c = 'test User-Agent string';
        insert testActOrder;
        
      
        Activation_Contact__c objActivationContact = new Activation_Contact__c();
        objActivationContact.Activation_Order__c = testActOrder.id;
        objActivationContact.Email__c = 'test@4test.com';
        objActivationContact.contact_Role__c ='Onboard Contact, System Support Contact';
        insert objActivationContact;
   
        Activation_Service__c objActivationService = New Activation_Service__c();
        objActivationService.Activation_Order__c = testActOrder.id;
        objActivationService.Activation_Rate_Plan__c = 'Metered Flex';
        objActivationService.Contract_Hardware_Type__c = 'Leased';
        objActivationService.Contract_Term__c = 12;
        objActivationService.Activation_Plan_Type__c ='ZS CommBox Bundles';
        objActivationService.Global_Static_IP_Selected__c = true;
        objActivationService.CommBox_Selected__c = true;
        objActivationService.Is_Selected__c = true;
        insert objActivationService;
        
    }
    
    static testMethod void test_Act_Service_Info_Component_Ctrl() {
        Activation_Order__c ActOrder;
        ActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        PageReference thePage = page.Services;
        thePage.getParameters().put('order', ActOrder.Id);
        Test.setCurrentPage(thePage);
        Test.startTest();
        Act_Service_Info_Component_Controller objActServiceInfoComponentController = new Act_Service_Info_Component_Controller();
        objActServiceInfoComponentController.getobjActivationService();
        Activation_Service__c objActivationService = [SELECT Id, Name,Inbound_Applications__c,Global_Static_IP_Selected__c,CommBox_Product__c, Activation_Plan_Type__c, Activation_Rate_Plan__c, Product__c FROM Activation_Service__c LIMIT 1];
        objActServiceInfoComponentController.setobjActivationService(objActivationService);
        List <String> selectedInboundApplications = objActServiceInfoComponentController.selectedInboundApplications; // getter
        objActServiceInfoComponentController.selectedInboundApplications = selectedInboundApplications; // setter
        List <SelectOption> allContactLists = objActServiceInfoComponentController.allContactLists; // get all contacts
        List <SelectOption> Regions = objActServiceInfoComponentController.Regions; // get all regions
        objActServiceInfoComponentController.clearActivationService();
        system.assertEquals(false, objActServiceInfoComponentController.objActivationService.Global_Static_IP_Selected__c);
        objActServiceInfoComponentController.updateActivationServiceInformation();
        system.assertEquals(true, objActServiceInfoComponentController.objActivationService.Global_Static_IP_Selected__c);        
        
        Test.stopTest();
    }
}