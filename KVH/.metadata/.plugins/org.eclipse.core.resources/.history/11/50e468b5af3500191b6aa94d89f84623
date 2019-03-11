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
private class Act_CommBox_Component_Controller_Test {
    
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
        
        Activation_Order__c testActOrder = new Activation_Order__c();
        testActOrder.isSelf_Activation__c = true;
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
        objActivationContact.contact_Role__c ='Onboard Contact, System Support Contact';
        
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
        objActivationSubscriber.contact_Role__c ='Subscriber, Onboard Contact, System Support Contact';
        objActivationSubscriber.State_Province__c = 'Rhode Island';
        objActivationSubscriber.Phone_Number__c = '401-555-1212';
        objActivationSubscriber.Billing_Rep_Name__c = 'TestName';
        objActivationSubscriber.Activation_Order__c = testActOrder.id;
        insert objActivationSubscriber;
        
        String strActivationHardwareRecordTypeId = Schema.SObjectType.Activation_Hardware__c.getRecordTypeInfosByName().get('Activation System').getRecordTypeId();
        
        Activation_Hardware__c objActivationHardware = New Activation_Hardware__c();
        objActivationHardware.Activation_Order__c = testActOrder.id;
        objActivationHardware.System_Name__c = 'Test V3';
        objActivationHardware.RecordTypeId = strActivationHardwareRecordTypeId;
        objActivationHardware.System_Name_Group__c = 'V3';
        insert objActivationHardware;
        
       
        
        Product2 objProduct = New Product2();
        objProduct.Name= 'Enterprise Product1';
        insert objProduct;
        
        Product2 objProduct1 = New Product2();
        objProduct1.Name= 'Enterprise CommBox Bundles';
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
        objActivationService.Activation_Plan_Type__c ='CommBox Bundles';
        objActivationService.Product__c = objProduct.Id;
        objActivationService.Voice_1_Product__c = objProduct4.Id;
        objActivationService.Voice_2_Product__c = objProduct1.Id;
        objActivationService.Global_Static_IP_Product__c = objProduct4.Id;
        objActivationService.Global_Static_IP_Selected__c = true;
        objActivationService.CommBox_Selected__c = true;
        objActivationService.Is_Selected__c = true;
        objActivationService.CommBox_Product__c = objProduct1.Id;
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
        objFeature.Name = 'Hub Metered Flex';
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
        objFeature3.Name = 'Hub Data Rate';
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
        objQuote.SBQQ__Opportunity2__c = objOpportunity.Id;
        insert objQuote;
        
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
        objActivationRatePlanTable.Plan_Type__c = 'CommBox Bundles';
        lstActivationRatePlanTable.add(objActivationRatePlanTable);
        
        Activation_Rate_Plan_Table__c objActivationRatePlanTable1 = New Activation_Rate_Plan_Table__c();
        objActivationRatePlanTable1.Name = 'Test Record2';
        objActivationRatePlanTable1.Map_Value_Type__c = 'Price';
        objActivationRatePlanTable1.Feature_Name__c = 'Date Rate';
        objActivationRatePlanTable1.Order__c = '50';
        objActivationRatePlanTable1.Plan_Type__c = 'CommBox Bundles';
        lstActivationRatePlanTable.add(objActivationRatePlanTable1);
        
        Activation_Rate_Plan_Table__c objActivationRatePlanTable2 = New Activation_Rate_Plan_Table__c();
        objActivationRatePlanTable2.Name = 'Test Record3';
        objActivationRatePlanTable2.Map_Value_Type__c = 'Price';
        objActivationRatePlanTable2.Order__c = '50';
        objActivationRatePlanTable2.Plan_Type__c = 'CommBox Bundles';
        lstActivationRatePlanTable.add(objActivationRatePlanTable2); 
         
        Activation_Rate_Plan_Table__c objActivationRatePlanTable3 = New Activation_Rate_Plan_Table__c();
        objActivationRatePlanTable3.Name = 'Test Record4';
        objActivationRatePlanTable3.Map_Value_Type__c = 'Other';
        objActivationRatePlanTable3.Order__c = '50';
        objActivationRatePlanTable3.Feature_Name__c = 'Test Data';
        objActivationRatePlanTable3.Plan_Type__c = 'CommBox Bundles';
        lstActivationRatePlanTable.add(objActivationRatePlanTable3);
        
        Activation_Rate_Plan_Table__c objActivationRatePlanTable4 = New Activation_Rate_Plan_Table__c();
        objActivationRatePlanTable4.Name = 'Test Record5';
        objActivationRatePlanTable4.Map_Value_Type__c = 'Other';
        objActivationRatePlanTable4.Feature_Name__c = 'Date Rate';
        objActivationRatePlanTable4.Order__c = '50';
        objActivationRatePlanTable4.Plan_Type__c = 'CommBox Bundles';
        lstActivationRatePlanTable.add(objActivationRatePlanTable4);
        
        insert lstActivationRatePlanTable;
        
        Activation_Product_Bundle__c objActivationProductBundle = New Activation_Product_Bundle__c();
        objActivationProductBundle.Name = 'CommBox Bundles';
        objActivationProductBundle.Actual_Name__c = 'CommBox Bundles';
        objActivationProductBundle.Product_Bundle_Id__c =  objProduct1.Id;
        insert objActivationProductBundle;
    }
    
    static testMethod void test_Act_CommBox_Component_Ctrl() {
        Activation_Order__c ActOrder;
        ActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        PageReference thePage = page.Services;
        thePage.getParameters().put('order', ActOrder.Id);
        Test.setCurrentPage(thePage);
        Test.startTest();
        Act_CommBox_Component_Controller objActCommBoxComponentController = new Act_CommBox_Component_Controller();
        Activation_Service__c objActivationService = [SELECT Id, Name,CommBox_Hub_Hosting_Id__c,CommBox_Product__r.Name,CommBox_Product__c, Activation_Plan_Type__c, Activation_Rate_Plan__c, Product__c FROM Activation_Service__c LIMIT 1];
        objActCommBoxComponentController.setobjActivationService(objActivationService);
        objActCommBoxComponentController.objActivationService  = objActivationService;
        objActCommBoxComponentController.setobjActivationService(objActivationService);
        system.assertEquals('CommBox Bundles', objActCommBoxComponentController.objActivationService.Activation_Plan_Type__c);
        
        objActCommBoxComponentController.getobjActivationService();
        objActCommBoxComponentController.updateActivationService();
        system.assertEquals(true, objActCommBoxComponentController.objActivationService.CommBox_Selected__c);

        objActCommBoxComponentController.clearActivationService();
        system.assertEquals(false, objActCommBoxComponentController.objActivationService.CommBox_Selected__c);
         
        objActCommBoxComponentController.strSelectedRatePlanTemp = 'Enterprise Test';
        objActCommBoxComponentController.updateActivationServiceValueCommBox();
        system.assertEquals(null, objActCommBoxComponentController.objActivationService.CommBox_Hub_Hosting_Id__c);
		objActCommBoxComponentController.updateActivationServiceValueHub();
        Test.stopTest();
    }
}