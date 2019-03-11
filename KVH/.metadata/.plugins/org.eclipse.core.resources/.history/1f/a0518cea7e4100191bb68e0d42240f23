@isTest
Private Class ActivationOneCare_Ctrl_test{

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
        testOrderStatus.OneCare_Last_Active_Tab_Index__c = null;
        update testOrderStatus; 
        
        Activation_Contact__c objActivationContact = new Activation_Contact__c();
        objActivationContact.Activation_Order__c = testActOrder.id;
        objActivationContact.Email__c = 'test@4test.com';
        objActivationContact.contact_Role__c ='Onboard Contact, System Support Contact';
        
        insert objActivationContact;
        
        String strActivationHardwareRecordTypeId = Schema.SObjectType.Activation_Hardware__c.getRecordTypeInfosByName().get('Activation System').getRecordTypeId();

        Activation_Hardware__c objActivationHardware = New Activation_Hardware__c();
        objActivationHardware.Activation_Order__c = testActOrder.id;
        objActivationHardware.System_Name__c = 'Test V3';
        objActivationHardware.RecordTypeId = strActivationHardwareRecordTypeId;
        objActivationHardware.System_Name_Group__c = 'V3';
        insert objActivationHardware;
       
        
        Product2 objProduct = New Product2();
        objProduct.Name= 'TracPhone V3 Extended Warranty';
        insert objProduct;
        
        Product2 objProduct1 = New Product2();
        objProduct1.Name= 'TracPhone V3 Extended Warranty 1 year';
        insert objProduct1;
        
        Product2 objProduct2 = New Product2();
        objProduct2.Name= 'TracPhone V3 Extended Warranty 2 year Technical Assistance Package';
        objProduct2.VSAT_Antenna_Hardware__c = 'V3;V7';
        insert objProduct2;
        
        PricebookEntry objPricebookEntry = new PricebookEntry();
        objPricebookEntry.Pricebook2Id = Test.getStandardPricebookId();
        objPricebookEntry.Product2Id = objProduct2.Id;
        objPricebookEntry.UnitPrice = 12000;
        objPricebookEntry.IsActive = true;
        insert objPricebookEntry; 
        
        SBQQ__ProductFeature__c objFeature = New SBQQ__ProductFeature__c();
        objFeature.Name = 'Year 1';
        objFeature.SBQQ__ConfiguredSKU__c = objProduct.Id;
        objFeature.SBQQ__Number__c = 1;
        insert objFeature;
        
        SBQQ__ProductFeature__c objFeature1 = New SBQQ__ProductFeature__c();
        objFeature1.Name = 'Year 2';
        objFeature1.SBQQ__ConfiguredSKU__c = objProduct.Id;
        objFeature1.SBQQ__Number__c = 1;
        insert objFeature1;
        
        SBQQ__ProductFeature__c objFeature2 = New SBQQ__ProductFeature__c();
        objFeature2.Name = 'Year 3';
        objFeature2.SBQQ__ConfiguredSKU__c = objProduct.Id;
        objFeature2.SBQQ__Number__c = 1;
        insert objFeature2;
        
         
        Activation_Service__c objActivationService = New Activation_Service__c();
        objActivationService.Activation_Order__c = testActOrder.id;
        objActivationService.Activation_Plan_Type__c ='Test Product Bundle';
        objActivationService.Extended_Warranty_Product__c = objProduct2.id;
        objActivationService.VSAT_Antenna_Hardware__c = 'V7';
        objActivationService.Product__c = objProduct1.Id;
        insert objActivationService;
        
        
        List<SBQQ__ProductOption__c> lstSBQQProductOptions = New List<SBQQ__ProductOption__c>();
        SBQQ__ProductOption__c objProductOption = New SBQQ__ProductOption__c();
        objProductOption.SBQQ__ConfiguredSKU__c = objProduct.Id;
        objProductOption.SBQQ__OptionalSKU__c = objProduct1.Id;
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
        lstSBQQProductOptions.add(objProductOption2);
        insert lstSBQQProductOptions;
       	
        ActivationOneCare__c ActOneCare = new ActivationOneCare__c();
        ActOneCare.Name = '1';
        ActOneCare.Global__c = true;
        ActOneCare.Premium__c = true;
        ActOneCare.Standard__c = true;
        ActOneCare.OneCareTechnicalAssitance__c = 'Technical Assistance';
        ActOneCare.Technical__c = 'Test';
        insert ActOneCare;
        
        ActivationOneCare__c ActOneCare1 = new ActivationOneCare__c();
        ActOneCare1.Name = '2';
        ActOneCare1.Global__c = true;
        ActOneCare1.Premium__c = true;
        ActOneCare1.Standard__c = false;
        ActOneCare1.OneCareTechnicalAssitance__c = 'Technical Assistance';
        ActOneCare1.Technical__c = 'Test';
        insert ActOneCare1;
        
         Activation_Product_Bundle__c objActivationProductBundle = New Activation_Product_Bundle__c();
        objActivationProductBundle.Name = 'OneCare';
        objActivationProductBundle.Actual_Name__c = 'OneCare';
        objActivationProductBundle.Product_Bundle_Id__c =  objProduct.Id;
        insert objActivationProductBundle;
        
    }
    
    static testMethod void testActivationOneCare_Ctrl_test() {
        Activation_Order__c ActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        Product2 Prod = [select id , name from Product2 where name = 'TracPhone V3 Extended Warranty 2 year Technical Assistance Package'];
        PageReference thePage = page.ActivationOneCare;
        thePage.getParameters().put('order', ActOrder.Id); 
        Test.setCurrentPage(thePage);
        Test.startTest();
        ActivationOneCare_Ctrl ActOneCare = new ActivationOneCare_Ctrl();
        ActOneCare.ProdId = (string)Prod.id;
        ActOneCare.selectedTab = 'Additional_Plans_and_Services';
        ActOneCare.gototab();
        ActOneCare.selectedTab = 'Contract_Details';
        ActOneCare.gototab();
        ActOneCare.selectedTab = 'test';
        ActOneCare.gototab();
        ActOneCare.saveService();
        ActOneCare.clear();
        Test.stopTest();
    }
}