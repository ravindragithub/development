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
private class Act_CREWlink_Component_Ctrl_Test {
    @testSetup static void setupTestData(){
        Activation_Order__c testActOrder = new Activation_Order__c();
        testActOrder.isSelf_Activation__c = true;
        testActOrder.User_Agent_String__c = 'test User-Agent string';
        insert testActOrder;
        
        Product2 objProduct = New Product2();
        objProduct.Name= 'Product1';
        insert objProduct;
        
        Product2 objProduct1 = New Product2();
        objProduct1.Name= 'Optional Plans & Services';
        objProduct1.SBQQ__SubscriptionType__c  ='Leased';
        insert objProduct1;
        
        Product2 objProduct2 = New Product2();
        objProduct2.Name= 'Product Optional';
        objProduct2.SBQQ__SubscriptionType__c  ='Leased';
        objProduct2.VSAT_Antenna_Hardware__c = 'V3;V7';
        insert objProduct2;
    
        Activation_Service__c objActivationService = New Activation_Service__c();
        objActivationService.Activation_Order__c = testActOrder.id;
        objActivationService.Activation_Rate_Plan__c = 'Metered Flex';
        objActivationService.Activation_Plan_Type__c ='Optional Plans & Services';
        objActivationService.Product__c = objProduct.Id;
        objActivationService.Voice_1_Product__c = objProduct2.Id;
        objActivationService.Voice_2_Product__c = objProduct1.Id;
        objActivationService.Global_Static_IP_Product__c = objProduct2.Id;
        objActivationService.Global_Static_IP_Selected__c = true;
        objActivationService.CommBox_Selected__c = true;
        objActivationService.Is_Selected__c = true;
        objActivationService.CommBox_Product__c = objProduct2.Id;
        objActivationService.Voice1_Country1__c = 'Test Country';
        objActivationService.Voice1_Country2__c = 'Test Country';
        objActivationService.Voice1_Country3__c = 'Test Country';
        objActivationService.Voice1_Country4__c = 'Test Country';
        objActivationService.Voice1_Country5__c = 'Test Country';
        objActivationService.Voice2_Country1__c = 'Test Country';
        objActivationService.Voice2_Country2__c = 'Test Country';
        objActivationService.Voice2_Country3__c = 'Test Country';
        objActivationService.Voice2_Country4__c = 'Test Country';
        objActivationService.Voice2_Country5__c = 'Test Country';
        insert objActivationService;
        
         Activation_Hardware__c objActivationHardware = New Activation_Hardware__c();
        objActivationHardware.Activation_Order__c = testActOrder.id;
        objActivationHardware.System_Name__c = 'Test V3';
        objActivationHardware.RecordTypeId = Schema.SObjectType.Activation_Hardware__c.getRecordTypeInfosByName().get('CREWLink MTA').getRecordTypeId();
        objActivationHardware.System_Name_Group__c = 'V3';
        insert objActivationHardware;
        
        Activation_Platform__c objActivationPlatform = New Activation_Platform__c();
        objActivationPlatform.Activation_Order__c = testActOrder.id;
        objActivationPlatform.Confirm_if_boat_yacht_is_chartered__c = 'Yes';
        objActivationPlatform.Market__c = 'Leisure';
        insert objActivationPlatform;
        
        SBQQ__ProductFeature__c objFeature = New SBQQ__ProductFeature__c();
        objFeature.Name = 'CREWlink Cards';
        objFeature.SBQQ__ConfiguredSKU__c = objProduct1.Id;
        objFeature.SBQQ__Number__c = 1;
        insert objFeature;
        
        SBQQ__ProductFeature__c objFeature1 = New SBQQ__ProductFeature__c();
        objFeature1.Name = 'CREWlink Cards';
        objFeature1.SBQQ__ConfiguredSKU__c = objProduct.Id;
        objFeature1.SBQQ__Number__c = 1;
        insert objFeature1;
        
        SBQQ__ProductFeature__c objFeature2 = New SBQQ__ProductFeature__c();
        objFeature2.Name = 'CREWlink Cards';
        objFeature2.SBQQ__ConfiguredSKU__c = objProduct.Id;
        objFeature2.SBQQ__Number__c = 1;
        insert objFeature2;
        
        List<SBQQ__ProductOption__c> lstSBQQProductOptions = New List<SBQQ__ProductOption__c>();
        SBQQ__ProductOption__c objProductOption = New SBQQ__ProductOption__c();
        objProductOption.SBQQ__ConfiguredSKU__c = objProduct1.Id;
        objProductOption.SBQQ__OptionalSKU__c = objProduct.Id;
        objProductOption.SBQQ__Feature__c = objFeature.id;
        objProductOption.SBQQ__Number__c = 1;
        lstSBQQProductOptions.add(objProductOption);
        
        SBQQ__ProductOption__c objProductOption1 = New SBQQ__ProductOption__c();
        objProductOption1.SBQQ__ConfiguredSKU__c = objProduct.Id;
        objProductOption1.SBQQ__OptionalSKU__c = objProduct2.Id;
        objProductOption1.SBQQ__Feature__c = objFeature1.id;
        objProductOption1.SBQQ__Number__c = 1;
        lstSBQQProductOptions.add(objProductOption1);
        
        SBQQ__ProductOption__c objProductOption2 = New SBQQ__ProductOption__c();
        objProductOption2.SBQQ__ConfiguredSKU__c = objProduct.Id;
        objProductOption2.SBQQ__OptionalSKU__c = objProduct2.Id;
        objProductOption2.SBQQ__Number__c = 1;
        objProductOption2.SBQQ__Feature__c = objFeature2.id;
        
        insert lstSBQQProductOptions;
        
        Activation_Product_Bundle__c objActivationProductBundle = New Activation_Product_Bundle__c();
        objActivationProductBundle.Name = 'CREWlink Services';
        objActivationProductBundle.Actual_Name__c = 'CREWlink Services';
        objActivationProductBundle.Product_Bundle_Id__c =  objProduct1.Id;
        insert objActivationProductBundle;
    }
    
    static testMethod void testAct_CREWlink_Component_Ctrl() {
        Activation_Order__c ActOrder;
        ActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        PageReference thePage = page.Services;
        thePage.getParameters().put('order', ActOrder.Id);
        Test.setCurrentPage(thePage);
        Test.startTest();
        Act_CREWlink_Component_Ctrl objActCREWlinkComponentCtrl = New Act_CREWlink_Component_Ctrl();
        objActCREWlinkComponentCtrl.updateActivationServiceCREWlink();
        system.assertEquals(false, objActCREWlinkComponentCtrl.objActivationService.Purchase_CREWLink_Calling_Cards__c);
        objActCREWlinkComponentCtrl.objActivationService.Purchase_CREWLink_Calling_Cards__c = true;
        system.assertEquals(true, objActCREWlinkComponentCtrl.objActivationService.Purchase_CREWLink_Calling_Cards__c);
        objActCREWlinkComponentCtrl.clearActivationService();
        system.assertEquals(false, objActCREWlinkComponentCtrl.objActivationService.Purchase_CREWLink_Calling_Cards__c);
        Test.stopTest();
    }
}