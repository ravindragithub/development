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
private class Act_Product_Summary_Component_Ctrl_Test {
    
    @testSetup static void setupTestData(){
        Account objAccount = New Account();
        objAccount.Name = 'Test Account';
        objAccount.Phone = '2327039234';
        objAccount.KVH_Sales_Office__c = 'TBD';
        objAccount.Prospect_Type__c = 'Customer';
        insert objAccount;
        
        Opportunity objOpportunity = New Opportunity();
        objOpportunity.AccountID = objAccount.id;
        objOpportunity.Name = 'Test Opp';
        objOpportunity.LeadSource = 'Website';
        objOpportunity.CloseDate = system.today()+5;
        objOpportunity.StageName = 'Quote'; 
        objOpportunity.Description = 'New Online Activation';
        objOpportunity.RecordTypeID = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('Mobile Broadband').RecordTypeId;
        insert objOpportunity;
        
        Case objCase = New Case();
        objCase.Subject = 'Test Case';
        insert objCase;
        
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
        
        Activation_Contact__c objActivationContact = new Activation_Contact__c();
        objActivationContact.Activation_Order__c = testActOrder.id;
        objActivationContact.Email__c = 'test@4test.com';
        objActivationContact.contact_Role__c ='Onboard Contact, System Support Contact,Main Contact,Billing Representative,Authorized Representative,Invoice Recipient';
        
        insert objActivationContact;
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
        
        Product2 objProduct = New Product2();
        objProduct.Name= 'Product1';
        insert objProduct;
        
        Product2 objProduct1 = New Product2();
        objProduct1.Name= 'Test Product Bundle';
        objProduct1.SBQQ__SubscriptionType__c  ='Leased';
        insert objProduct1;
        
        Product2 objProduct2 = New Product2();
        objProduct2.Name= 'Product Optional';
        objProduct2.SBQQ__SubscriptionType__c  ='Leased';
        objProduct2.VSAT_Antenna_Hardware__c = 'V3;V7';
        insert objProduct2;
        
        Product2 objProduct4 = New Product2();
        objProduct4.Name= 'CommBox Product1';
        insert objProduct4;
        
        Activation_Service__c objActivationService = New Activation_Service__c();
        objActivationService.Activation_Order__c = testActOrder.id;
        objActivationService.Activation_Rate_Plan__c = 'Metered Flex';
        objActivationService.Contract_Hardware_Type__c = 'Leased';
        objActivationService.Contract_Term__c = 12;
        objActivationService.Activation_Plan_Type__c ='Test Product Bundle';
        objActivationService.Product__c = objProduct.Id;
        objActivationService.Voice_1_Product__c = objProduct4.Id;
        objActivationService.Voice_2_Product__c = objProduct1.Id;
        objActivationService.Global_Static_IP_Product__c = objProduct4.Id;
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
        objActivationService.Entertainment_Programming_Product__c = objProduct2.Id;
        objActivationService.Entertainment_Programming_Selected__c = true;
        objActivationService.Viewing_Option_Product__c = objProduct2.Id;
        objActivationService.Independent_Entertainment_Channels__c = 'product1 <-->' +  objProduct2.Id +'product2 <-->' + objProduct1.Id;
        objActivationService.Special_Event_Channels__c = 'product1 <-->' +  objProduct2.Id +'product2 <-->' + objProduct1.Id;
        objActivationService.Training_Packages__c = 'product1 <-->' +  objProduct2.Id +'product2 <-->' + objProduct1.Id;
        objActivationService.Operations_Data_Services__c = 'product1 <-->' +  objProduct2.Id +'product2 <-->' + objProduct1.Id;
        objActivationService.Iridium_OpenPort_Product__c = objProduct2.Id;
        objActivationService.Extended_Warranty_Product__c = objProduct2.Id;
        objActivationService.OneCare_Technical_Assistance_Package__c = objProduct2.Id;
        objActivationService.Iridium_OpenPort_Selected__c = true;
        objActivationService.VSAT_Antenna_Hardware__c = 'V7';
        insert objActivationService;
        
        Id Pricebook2Id = Test.getStandardPricebookId();
        
        PricebookEntry objPricebookEntry = new PricebookEntry();
        objPricebookEntry.Pricebook2Id = Pricebook2Id;
        objPricebookEntry.Product2Id = objProduct.Id;
        objPricebookEntry.UnitPrice = 12000;
        objPricebookEntry.IsActive = true;
        insert objPricebookEntry;
        
        PricebookEntry objPricebookEntry2 = new PricebookEntry();
        objPricebookEntry2.Pricebook2Id = Pricebook2Id;
        objPricebookEntry2.Product2Id = objProduct4.Id;
        objPricebookEntry2.UnitPrice = 12000;
        objPricebookEntry2.IsActive = true;
        insert objPricebookEntry2;
        
        SBQQ__ProductFeature__c objFeature = New SBQQ__ProductFeature__c();
        objFeature.Name = 'Metered Flex';
        objFeature.SBQQ__ConfiguredSKU__c = objProduct1.Id;
        objFeature.SBQQ__Number__c = 1;
        insert objFeature;
        
        SBQQ__ProductFeature__c objFeature1 = New SBQQ__ProductFeature__c();
        objFeature1.Name = 'Data Rate';
        objFeature1.SBQQ__ConfiguredSKU__c = objProduct.Id;
        objFeature1.SBQQ__Number__c = 1;
        insert objFeature1;
        
        SBQQ__ProductFeature__c objFeature2 = New SBQQ__ProductFeature__c();
        objFeature2.Name = 'Virtual Line - Voice Line 1';
        objFeature2.SBQQ__ConfiguredSKU__c = objProduct.Id;
        objFeature2.SBQQ__Number__c = 1;
        insert objFeature2;
        
        SBQQ__ProductFeature__c objFeature3 = New SBQQ__ProductFeature__c();
        objFeature3.Name = 'Data Rate';
        objFeature3.SBQQ__ConfiguredSKU__c = objProduct4.Id;
        objFeature3.SBQQ__Number__c = 1;
        insert objFeature3;
        
        SBQQ__ProductFeature__c objFeature4 = New SBQQ__ProductFeature__c();
        objFeature4.Name = 'Virtual Line - Voice Line 1';
        objFeature4.SBQQ__ConfiguredSKU__c = objProduct4.Id;
        objFeature4.SBQQ__Number__c = 1;
        insert objFeature4;
        
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
        
        SBQQ__ProductOption__c objProductOption3 = New SBQQ__ProductOption__c();
        objProductOption3.SBQQ__ConfiguredSKU__c = objProduct1.Id;
        objProductOption3.SBQQ__OptionalSKU__c = objProduct4.Id;
        objProductOption3.SBQQ__Feature__c = objFeature.id;
        objProductOption3.SBQQ__Number__c = 1;
        lstSBQQProductOptions.add(objProductOption3);
        
        SBQQ__ProductOption__c objProductOption4 = New SBQQ__ProductOption__c();
        objProductOption4.SBQQ__ConfiguredSKU__c = objProduct4.Id;
        objProductOption4.SBQQ__OptionalSKU__c = objProduct2.Id;
        objProductOption4.SBQQ__Feature__c = objFeature3.id;
        objProductOption4.SBQQ__Number__c = 1;
        lstSBQQProductOptions.add(objProductOption4);
        
        SBQQ__ProductOption__c objProductOption5 = New SBQQ__ProductOption__c();
        objProductOption5.SBQQ__ConfiguredSKU__c = objProduct4.Id;
        objProductOption5.SBQQ__OptionalSKU__c = objProduct2.Id;
        objProductOption5.SBQQ__Number__c = 1;
        objProductOption5.SBQQ__Feature__c = objFeature4.id;
        lstSBQQProductOptions.add(objProductOption5);
        insert lstSBQQProductOptions;
        
        SBQQ__Quote__c objQuote = New SBQQ__Quote__c();
        objQuote.SBQQ__PaymentTerms__c = 'Net 30';
        objQuote.SBQQ__DeliveryMethod__c = 'Ship';
        objQuote.Activation_Order__c = testActOrder.Id;
        objQuote.SBQQ__Opportunity2__c = objOpportunity.Id;
        insert objQuote;
        
        testActOrder.Quote__c = objQuote.Id;
        update testActOrder;

        SBQQ__QuoteLine__c objQuoteLine = New SBQQ__QuoteLine__c();
        objQuoteLine.SBQQ__Quote__c = objQuote.Id;
        objQuoteLine.SBQQ__Product__c = objProductOption.SBQQ__OptionalSKU__c;
        objQuoteLine.SBQQ__ProductOption__c = objProductOption.Id;
        objQuoteLine.SBQQ__OptionLevel__c = 1;
        objQuoteLine.SBQQ__OptionType__c = 'Component';
        insert objQuoteLine;
        
        List<Activation_Rate_Plan_Table__c> lstActivationRatePlanTable = New List<Activation_Rate_Plan_Table__c>();
        Activation_Rate_Plan_Table__c objActivationRatePlanTable = New Activation_Rate_Plan_Table__c();
        objActivationRatePlanTable.Name = 'Test Record1';
        objActivationRatePlanTable.Map_Value_Type__c = 'Price';
        objActivationRatePlanTable.Feature_Name__c = 'Metered Flex';
        objActivationRatePlanTable.Order__c = '50';
        objActivationRatePlanTable.Plan_Type__c = 'Test Product Bundle';
        lstActivationRatePlanTable.add(objActivationRatePlanTable);
        
        Activation_Rate_Plan_Table__c objActivationRatePlanTable1 = New Activation_Rate_Plan_Table__c();
        objActivationRatePlanTable1.Name = 'Test Record2';
        objActivationRatePlanTable1.Map_Value_Type__c = 'Price';
        objActivationRatePlanTable1.Feature_Name__c = 'Date Rate';
        objActivationRatePlanTable1.Order__c = '50';
        objActivationRatePlanTable1.Plan_Type__c = 'Test Product Bundle';
        lstActivationRatePlanTable.add(objActivationRatePlanTable1);
        
        Activation_Rate_Plan_Table__c objActivationRatePlanTable2 = New Activation_Rate_Plan_Table__c();
        objActivationRatePlanTable2.Name = 'Test Record3';
        objActivationRatePlanTable2.Map_Value_Type__c = 'Price';
        objActivationRatePlanTable2.Order__c = '50';
        objActivationRatePlanTable2.Plan_Type__c = 'Test Product Bundle';
        lstActivationRatePlanTable.add(objActivationRatePlanTable2); 
        
        Activation_Rate_Plan_Table__c objActivationRatePlanTable3 = New Activation_Rate_Plan_Table__c();
        objActivationRatePlanTable3.Name = 'Test Record4';
        objActivationRatePlanTable3.Map_Value_Type__c = 'Other';
        objActivationRatePlanTable3.Order__c = '50';
        objActivationRatePlanTable3.Feature_Name__c = 'Test Data';
        objActivationRatePlanTable3.Plan_Type__c = 'Test Product Bundle';
        lstActivationRatePlanTable.add(objActivationRatePlanTable3);
        
        Activation_Rate_Plan_Table__c objActivationRatePlanTable4 = New Activation_Rate_Plan_Table__c();
        objActivationRatePlanTable4.Name = 'Test Record5';
        objActivationRatePlanTable4.Map_Value_Type__c = 'Other';
        objActivationRatePlanTable4.Feature_Name__c = 'Date Rate';
        objActivationRatePlanTable4.Order__c = '50';
        objActivationRatePlanTable4.Plan_Type__c = 'Test Product Bundle';
        lstActivationRatePlanTable.add(objActivationRatePlanTable4);
        
        insert lstActivationRatePlanTable;
        
    }
    
    static testMethod void test_Act_Product_Summary_Component_CtrlV1C1V1C2() {
        Activation_Order__c ActOrder;
        ActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        PageReference thePage = page.Services;
        thePage.getParameters().put('order', ActOrder.Id);
        Test.setCurrentPage(thePage);
        Test.startTest();
        Act_Product_Summary_Component_Ctrl objActProductSummaryComponentCtrl = new Act_Product_Summary_Component_Ctrl();
        Activation_Status__c ActOrderStatus = objActProductSummaryComponentCtrl.ActivationStatus; 
        SBQQ__ProductFeature__c objFeature = New SBQQ__ProductFeature__c();
        objFeature = [SELECT Id, Name FROM SBQQ__ProductFeature__c WHERE Name = 'Metered Flex' LIMIT 1];
        system.assertEquals('Test Product Bundle', objActProductSummaryComponentCtrl.objActivationServiceComp.Activation_Plan_Type__c);
        List<Product2> lstProduct = New List<Product2>();
        lstProduct = [SELECT Id FROM Product2 WHERE Name =: 'Product1' LIMIT 1];
        objActProductSummaryComponentCtrl.selectedProductBundle();
        objActProductSummaryComponentCtrl.objActivationServiceComp.Voice1_Country1__c =  null;
        objActProductSummaryComponentCtrl.selectedProductBundle();
        Test.stopTest();
    }
    
       static testMethod void test_Act_Product_Summary_Component_CtrlV1C3V1C4() {
        Activation_Order__c ActOrder;
        ActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        PageReference thePage = page.Services;
        thePage.getParameters().put('order', ActOrder.Id);
        Test.setCurrentPage(thePage);
        Test.startTest();
        Act_Product_Summary_Component_Ctrl objActProductSummaryComponentCtrl = new Act_Product_Summary_Component_Ctrl();
        Activation_Status__c ActOrderStatus = objActProductSummaryComponentCtrl.ActivationStatus; 
        
        objActProductSummaryComponentCtrl.objActivationServiceComp.Voice1_Country1__c =  null;
        objActProductSummaryComponentCtrl.objActivationServiceComp.Voice1_Country2__c =  null;
        objActProductSummaryComponentCtrl.selectedProductBundle();
        objActProductSummaryComponentCtrl.objActivationServiceComp.Voice1_Country3__c =  null;
        objActProductSummaryComponentCtrl.selectedProductBundle();

        Test.stopTest();
    }
    
    
    
    static testMethod void test_Act_Product_Summary_Component_CtrlV1C5V2C1() {
        Activation_Order__c ActOrder;
        ActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        PageReference thePage = page.Services;
        thePage.getParameters().put('order', ActOrder.Id);
        Test.setCurrentPage(thePage);
        Test.startTest();
        Act_Product_Summary_Component_Ctrl objActProductSummaryComponentCtrl = new Act_Product_Summary_Component_Ctrl();
        Activation_Status__c ActOrderStatus = objActProductSummaryComponentCtrl.ActivationStatus; 
        objActProductSummaryComponentCtrl.objActivationServiceComp.Voice1_Country1__c =  null;
        objActProductSummaryComponentCtrl.objActivationServiceComp.Voice1_Country2__c =  null;
        objActProductSummaryComponentCtrl.objActivationServiceComp.Voice1_Country3__c =  null;
        objActProductSummaryComponentCtrl.objActivationServiceComp.Voice1_Country4__c =  null;
        objActProductSummaryComponentCtrl.selectedProductBundle();
        objActProductSummaryComponentCtrl.objActivationServiceComp.Voice1_Country5__c =  null;
        objActProductSummaryComponentCtrl.selectedProductBundle();
        Test.stopTest();
    }
    
    static testMethod void test_Act_Product_Summary_Component_CtrlV2C2V2C3() {
        Activation_Order__c ActOrder;
        ActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        PageReference thePage = page.Services;
        thePage.getParameters().put('order', ActOrder.Id);
        Test.setCurrentPage(thePage);
        Test.startTest();
        Act_Product_Summary_Component_Ctrl objActProductSummaryComponentCtrl = new Act_Product_Summary_Component_Ctrl();
        Activation_Status__c ActOrderStatus = objActProductSummaryComponentCtrl.ActivationStatus; 
        objActProductSummaryComponentCtrl.objActivationServiceComp.Voice1_Country1__c =  null;
        objActProductSummaryComponentCtrl.objActivationServiceComp.Voice1_Country2__c =  null;
        objActProductSummaryComponentCtrl.objActivationServiceComp.Voice1_Country3__c =  null;
        objActProductSummaryComponentCtrl.objActivationServiceComp.Voice1_Country4__c =  null;
        objActProductSummaryComponentCtrl.objActivationServiceComp.Voice1_Country5__c =  null;
        objActProductSummaryComponentCtrl.objActivationServiceComp.Voice2_Country1__c =  null;
        objActProductSummaryComponentCtrl.selectedProductBundle();
        objActProductSummaryComponentCtrl.objActivationServiceComp.Voice2_Country2__c =  null;
        objActProductSummaryComponentCtrl.selectedProductBundle();
        Test.stopTest();
    }
    
    static testMethod void test_Act_Product_Summary_Component_CtrlV2C4V2C5() {
        Activation_Order__c ActOrder;
        ActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        PageReference thePage = page.Services;
        thePage.getParameters().put('order', ActOrder.Id);
        Test.setCurrentPage(thePage);
        Test.startTest();
        Act_Product_Summary_Component_Ctrl objActProductSummaryComponentCtrl = new Act_Product_Summary_Component_Ctrl();
        Activation_Status__c ActOrderStatus = objActProductSummaryComponentCtrl.ActivationStatus; 
        objActProductSummaryComponentCtrl.objActivationServiceComp.Voice1_Country1__c =  null;
        objActProductSummaryComponentCtrl.objActivationServiceComp.Voice1_Country2__c =  null;
        objActProductSummaryComponentCtrl.objActivationServiceComp.Voice1_Country3__c =  null;
        objActProductSummaryComponentCtrl.objActivationServiceComp.Voice1_Country4__c =  null;
        objActProductSummaryComponentCtrl.objActivationServiceComp.Voice1_Country5__c =  null;
        objActProductSummaryComponentCtrl.objActivationServiceComp.Voice2_Country1__c =  null;
        objActProductSummaryComponentCtrl.objActivationServiceComp.Voice2_Country2__c =  null;
        objActProductSummaryComponentCtrl.objActivationServiceComp.Voice2_Country3__c =  null;
        objActProductSummaryComponentCtrl.selectedProductBundle();
        objActProductSummaryComponentCtrl.objActivationServiceComp.Voice2_Country4__c =  null;
        objActProductSummaryComponentCtrl.selectedProductBundle();
        Test.stopTest();
    }
    
    static testMethod void test_Act_Product_Summary_Component_CtrlRemaining() {
        Activation_Order__c ActOrder;
        ActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        PageReference thePage = page.Services;
        thePage.getParameters().put('order', ActOrder.Id);
        Test.setCurrentPage(thePage);
        Test.startTest();
        Act_Product_Summary_Component_Ctrl objActProductSummaryComponentCtrl = new Act_Product_Summary_Component_Ctrl();
        Activation_Status__c ActOrderStatus = objActProductSummaryComponentCtrl.ActivationStatus;
        objActProductSummaryComponentCtrl.boolSuccesscheck = true;
        objActProductSummaryComponentCtrl.incrementCounter();
        PageReference pageRef1 = objActProductSummaryComponentCtrl.goToTab();
        system.assertEquals(thePage.getUrl(),pageRef1.getUrl());
        
        thePage = page.Activation_ThankYou;
        thePage.getParameters().put('order', ActOrder.Id);
        pageRef1 = objActProductSummaryComponentCtrl.orderValidation();
        system.assertEquals(thePage.getUrl(),pageRef1.getUrl());
        objActProductSummaryComponentCtrl.orderValidationDealer();
        Test.stopTest();
    }
 
}