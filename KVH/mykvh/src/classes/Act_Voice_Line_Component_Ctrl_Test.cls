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
private class Act_Voice_Line_Component_Ctrl_Test {
    
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
        objActivationService.Activation_Plan_Type__c ='ZS CommBox Bundles';
        objActivationService.Global_Static_IP_Selected__c = true;
        objActivationService.CommBox_Selected__c = true;
        objActivationService.Voice_Line_2_Type__c = 'User-specified Phone Number';
        objActivationService.Voice_Line_2_Type__c = 'User-specified Phone Number';
        objActivationService.Is_Selected__c = true;
        insert objActivationService;
        
        Product2 objProduct1 = New Product2();
        objProduct1.Name= 'Bundles';
        objProduct1.SBQQ__SubscriptionType__c  ='Leased';
        insert objProduct1;
        
        List<Activation_Product_Bundle__c> lstActivationProductBundle = New List<Activation_Product_Bundle__c>();
        Activation_Product_Bundle__c objActivationProductBundle = New Activation_Product_Bundle__c();
        objActivationProductBundle.Name = 'User-specified Phone Number 2';
        objActivationProductBundle.Actual_Name__c = 'User-specified Phone Number 2';
        objActivationProductBundle.Product_Bundle_Id__c =  objProduct1.Id;
        lstActivationProductBundle.add(objActivationProductBundle);
        
        Activation_Product_Bundle__c objActivationProductBundle1 = New Activation_Product_Bundle__c();
        objActivationProductBundle1.Name = 'User-specified Phone Number 1';
        objActivationProductBundle1.Actual_Name__c = 'User-specified Phone Number 1';
        objActivationProductBundle1.Product_Bundle_Id__c =  objProduct1.Id;
        lstActivationProductBundle.add(objActivationProductBundle1);
        insert lstActivationProductBundle;
        
    }
    
    static testMethod void test_Act_Voice_Line_Component_Ctrl() {
        Activation_Order__c ActOrder;
        ActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        PageReference thePage = page.Services;
        thePage.getParameters().put('order', ActOrder.Id);
        Test.setCurrentPage(thePage);
        Test.startTest();
        Act_Voice_Line_Component_Ctrl objActVoiceLineComponentCtrl = new Act_Voice_Line_Component_Ctrl();
        objActVoiceLineComponentCtrl.getobjActivationService();
        Activation_Service__c objActivationService = [SELECT Id, Name,Voice_Line_2_Type__c,Voice_Line_1_Type__c,Inbound_Applications__c,Global_Static_IP_Selected__c,CommBox_Product__c, Activation_Plan_Type__c, Activation_Rate_Plan__c, Product__c FROM Activation_Service__c LIMIT 1];
        objActVoiceLineComponentCtrl.setobjActivationService(objActivationService);
        objActVoiceLineComponentCtrl.updateActivationServiceVoice1();
        objActVoiceLineComponentCtrl.ActivationServiceVoice2Show();
        system.assertEquals(true, objActVoiceLineComponentCtrl.boolSecondVoiceLine);
        objActVoiceLineComponentCtrl.ActivationServiceVoice2Hide();
        system.assertEquals(false, objActVoiceLineComponentCtrl.boolSecondVoiceLine);
        system.assertEquals('', objActVoiceLineComponentCtrl.objActivationService.Voice_Line_2_Type__c);
        objActVoiceLineComponentCtrl.saveActivationServiceVoice();
        Test.stopTest();
    }
}