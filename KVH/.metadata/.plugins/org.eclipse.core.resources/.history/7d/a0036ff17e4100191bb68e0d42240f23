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
@IsTest()
private class CCDS_InventoryHelper_Test {
	//The typical test Class statics...
	private static final Id Direct_Customer_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Customer').getRecordTypeId();
	
	@testSetup static void setupTestData(){//Runs before any test methods...
        // Need Account, Asset, Case, Contact(s), ContactRoles, Address, Countries
        // Countries first...
        list <pw_ccpro__CountryObject__c> coList = new list <pw_ccpro__CountryObject__c>();
        
        pw_ccpro__CountryObject__c co1 = new pw_ccpro__CountryObject__c();
        co1.Name = 'Canada';
        co1.pw_ccpro__IsoCode_2__c = 'CA';
        co1.pw_ccpro__IsoCode_3__c = 'CAN';
        coList.add(co1);
        co1 = new pw_ccpro__CountryObject__c();
        co1.Name = 'United States';
        co1.pw_ccpro__IsoCode_2__c = 'US';
        co1.pw_ccpro__IsoCode_3__c = 'USA';
        coList.add(co1);
        insert coList;
        
        //Setup an Account....
        Account a = new Account(); 
        a.RecordTypeId = Direct_Customer_RECORD_TYPE_ID;
        a.name='Anew Customer Test' + String.valueOf(System.now());	//for some reason, 'Anew Customer-Test' saves to DB as 'Anew Customer Test'... Illeagle char?
        a.Country_Code__c = 'US';
        a.BillingCountry = 'United States';
        a.Billing_Cycle_picklist__c = 'Active';
        a.BillingPostalCode = '12345';
        a.BillingStreet = '123 Customer Street';
        a.Bill_Type__c = 'Mail';
        a.Bill_to__c = 'Customer';
        a.Mail_to__c = 'Customer';
        a.Bill_To_Corporate__c = false;
        a.Mail_to_Corporate__c = false;
        a.Account_Type__c = 'Customer';
        a.CC_Prospect_Acct_ID__c = 129056;
        a.CC_Reseller_Account_ID__c = 1;
        a.Company_IMO__c = String.valueOf(Math.random() * 9998769).subString(0,7); // must be 7 digits
        a.Custom_Call_Acct_ID__c = String.valueOf(Math.round(Math.random() * 123456));
        a.Home_Hub__c = 'MIAMI';
        a.Revenue_Category__c = 'VSAT';
        a.Source__c = 'CustomerHelper_Test';
        a.KVH_Sales_Office__c = 'KU Satcom';
        a.Market__c = 'Leisure';
        a.Market_Sector__c = 'Marine';
        a.Account_Status__c = 'Active';
        a.Account_Effective_Date__c = date.Today();          
        insert a;
        System.assert(a != null);
        
        //setup an Asset
        Asset asset= new Asset();
        asset.Name = GenerateRandomString_Test();
        asset.AccountId = a.id;
        asset.Asset_ID__c = String.valueOf(Math.round(Math.random() * 123456789));
        insert asset;
        System.assert(asset != null);
        
        //setup a Case
        Case newCase = new Case();
        newCase.AssetId = asset.id;
        newCase.Platform_Asset_Account__c = a.id;
        insert newCase; 
        System.assert(newCase != null);
        
        //setup a Contact
        Contact c = new Contact();
        c.AccountId = a.Id;
        c.Title = 'CustomerTitle';
        c.Email='abc@abcCanada.com';
        c.Phone = '6085551212';
        c.Fax = '9725551212';
        c.MobilePhone = '5035551212';
        c.FirstName = 'First New';
        c.LastName = 'Contact';
        c.Birthdate = Date.newInstance(1914, 12, 2);
        c.Department = 'testing';
        insert c;
        System.assert(c != null);
        
        //setup a Contact Role
        AccountContactRole cr = new AccountContactRole();
        cr.AccountId = a.Id;
        cr.ContactId = c.Id;
        cr.Role = 'Airtime Services Main Contact';
        insert cr;
        System.assert(cr != null); 
        
        //setup another Contact
        Contact c2 = new Contact();
        c2.AccountId = a.Id;
        c2.Title = 'CustomerTitle';
        c2.Email='abc@abc.com';
        c2.Phone = '6085551212';
        c2.Fax = '9725551212';
        c2.MobilePhone = '5035551212';
        c2.FirstName = 'Second';
        c2.LastName = 'Contact';
        c2.Birthdate = Date.newInstance(2014, 12, 2);
        c2.Department = 'testing';
        insert c2;
        System.assert(c2 != null);
        
        //setup another Contact Role
        AccountContactRole cr2 = new AccountContactRole();
        cr2.AccountId = a.Id;
        cr2.ContactId = c2.Id;
        cr2.Role = 'Airtime Services Billing Contact';
        insert cr2;
        System.assert(cr2 != null); 
        
         //setup a billing account
        Billing_Account__c objBillingAccountCorporate = New Billing_Account__c();
        objBillingAccountCorporate.Account__c = a.id;
        objBillingAccountCorporate.RecordTypeId = Schema.SObjectType.Billing_Account__c.getRecordTypeInfosByName().get('Customer CC Account').getRecordTypeId();
        objBillingAccountCorporate.Billing_Account_ID__c = '00';
        insert objBillingAccountCorporate;
        System.assert(objBillingAccountCorporate != null); 
        
		//setup a couple of addresses
        Address__c addr = new Address__c();
        addr.Account__c = a.Id;
        addr.Billing_Account__c = objBillingAccountCorporate.id;
        addr.Address_Type__c = 'Airtime Services Billing';
        addr.Address_1__c = 'East Washington 24';
        addr.City__c = 'Calgary';
        addr.State__c = 'Alberta';
        addr.State_Province_ISO_Code__c = 'AB';
        addr.Country__c = 'Canada';
        addr.Postal_Zipcode__c = '00123';
        insert addr;
        System.assert(addr != null);
        
        pw_ccpro__CountryObject__c co = SetUpCountry_Test();	//returns Canada
        
        //setup a couple of addresses
        Address__c addr2 = new Address__c();
        addr2.Account__c = a.Id;
        addr2.Billing_Account__c = objBillingAccountCorporate.id;
        addr2.Address_Type__c = 'Airtime Services Subscriber';
        addr2.Address_1__c = '1001 S. Whitney Way';
        addr2.City__c = 'Madison';
        addr2.State__c = 'Wisconsin';
        addr2.State_Province_ISO_Code__c = 'WI';
        addr2.Country__c = 'United States';
        addr2.Postal_Zipcode__c = '53711';
        insert addr2;
        System.assert(addr2 != null);
    }
    
    @testSetup static void GenerateCustomSettings_Test(){
    	
        List<Global_Variable__c> customSettings = new List<Global_Variable__c>();  
        //create a list of the Custom Settings so we can insert all at once
        //this approach helps to avoid governor limits.
                                            
        Global_Variable__c setting = new Global_Variable__c();
        //create a single Custom Setting that we will re-use over and over....
          
        /* Setup Custom Settings fields here.... */
        //first one.... set the name
        setting.name = 'Webtop_Application'; 
        //set the value...
        setting.Value__c = 'Salesforce';
        //add to the list. (lather, rinse, repeat....)
        customSettings.add(setting); 
        
        //reset
        //clear out the single instance variable
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_ClientInitials';                   
        setting.Value__c = 'K93'; 
        customSettings.add(setting);
        
        //reset
        //clear out the single instance variable
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_CustomerUpdate_Failure';
        setting.Value__c = 'The customer could not be updated in Webtop';
        customSettings.add(setting); 
        
        //reset
        //clear out the single instance variable
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_CustomerUpdate_Success';
        setting.Value__c = 'The customer was updated successfully in Webtop';
        customSettings.add(setting); 
        
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_Environment';
        setting.Value__c = '2';
        customSettings.add(setting); 

        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_MiscInfo_Category_AcctFields';
        setting.Value__c = '18';
        customSettings.add(setting); 
        
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_MiscInfo_SubCat_AccountID';
        setting.Value__c = '48';
        customSettings.add(setting); 
        
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_MiscInfo_SubCat_SalesRep1';
        setting.Value__c = '49';
        customSettings.add(setting);
        
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_MiscInfo_SubCat_SalesRep2';
        setting.Value__c = '50';
        customSettings.add(setting);
        
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_MiscInfo_SubCat_EffDate';
        setting.Value__c = '51';
        customSettings.add(setting);
        
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_MiscInfo_SubCat_TermReason';
        setting.Value__c = '9';
        customSettings.add(setting);
        
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_MiscInfo_SubCat_VesselName';
        setting.Value__c = '10';
        customSettings.add(setting);
        
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_OrderSource';
        setting.Value__c = 'WEB';
        customSettings.add(setting);

        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_ProspectCreate_Failure';
        setting.Value__c = 'The prospect could not be created in Webtop';
        customSettings.add(setting);
        
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_ProspectCreate_Success';
        setting.Value__c = 'The prospect was created successfully in Webtop';
        customSettings.add(setting);
        
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_Username';
        setting.Value__c = 'kvh.apiUser';
        customSettings.add(setting);
        
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_Version';
        setting.Value__c = '9.3.1';
        customSettings.add(setting);
        
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_WsdlType_Corporate';
        setting.Value__c = 'Corporate';
        customSettings.add(setting);
        
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_WsdlType_Customer';
        setting.Value__c = 'Customer';
        customSettings.add(setting);
        
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_WsdlType_Entity';
        setting.Value__c = 'Entity';
        customSettings.add(setting);
        
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_WsdlType_Inventory';
        setting.Value__c = 'Inventory';
        customSettings.add(setting);
        
        // execute a single DML statement to insert all of the custom settings at once... */
        system.debug('ready to insert '+customSettings.size()+' Global Variable Custom Settings...');
        
        //this inserts the entire list
        insert customSettings;                            
        System.assert(customSettings != null);
        
        CCDS_Bill_Type__c bt = new CCDS_Bill_Type__c();
        bt.Name = 'CCDS_Bill_Type__c';
        bt.Label__c = 'Mail';
        bt.Value__c = 'M';
        insert bt;
        System.assert(bt != null);
        
        CCDS_Billing_Cycle__c bc = new CCDS_Billing_Cycle__c();
        bc.Name = 'CCDS_Billing_Cycle__c';
        bc.Label__c = 'Active';
        bc.Value__c = 'A';
        insert bc;
        System.assert(bc != null);
        
        CCDS_Sales_Office__c so = new CCDS_Sales_Office__c();  
        so.Name = 'CCDS_Sales_Office__c';
        so.Label__c = 'VSAT';
        so.Value__c = 28;
        insert so;
        System.assert(so != null);
                            
        CCDS_Sales_Region__c sr = new CCDS_Sales_Region__c();
        sr.Name = 'CCDS_Sales_Region__c';
        sr.Label__c = 'KU Satcom';
        sr.Value__c = 1;
        insert sr;
        System.assert(sr != null);
        
        CCDS_Sales_Rep__c rep = new CCDS_Sales_Rep__c();
        rep.Name = 'CCDS_Sales_Rep__c';
        rep.Label__c = 'MIAMI';
        rep.Value__c = 3;
        insert rep;
        System.assert(rep != null);
        
        //Need to create a Security__c sObject so that tests will pass....
        Security__c testSecure = new Security__c();
        testSecure.Name = 'CCDS';
        testSecure.Key__c = 'test_password';
        insert testSecure;
    }
      
    /*static testMethod void testSetupData(){
    	//This testMethod is used to verify that the setupTestData method executed correctly
    	//Test Countries.....
    	pw_ccpro__CountryObject__c co = SetUpCountry_Test();	//Use existing method
    	system.assertEquals('Canada', co.Name);
    	system.assertEquals('CA', co.pw_ccpro__IsoCode_2__c);
    	system.assertEquals('CAN', co.pw_ccpro__IsoCode_3__c);
    	Account a = SetUpAccountData_Test();					//Use existing method
    	system.assertEquals('Anew Customer Test',a.Name.Left(18));
    	//This method could be extended to sample ALL of the @testSetup data.
    }
    */
    //Method (not a testMethod) to return an Account, Specifically our test Account
    static Account SetUpAccountData_Test(){
    	Account readAcct = [SELECT a.Id, a.Name, a.Source__c, a.Revenue_Category__c, a.RecordTypeId, 
    			a.Market__c, a.Mail_to__c, a.Mail_to_Corporate__c, 
    			a.KVH_Sales_Office__c, a.Home_Hub__c, a.Custom_Call_Acct_ID__c, a.Country_Code__c, 
    			a.Company_IMO__c, a.CC_Reseller_Account_ID__c, a.CC_Prospect_Acct_ID__c, 
    			a.Billing_Cycle_picklist__c, a.BillingStreet, a.BillingPostalCode, a.BillingCountry, 
    			a.Bill_to__c, a.Bill_Type__c, a.Bill_To_Corporate__c, a.Account_Type__c, 
    			a.Account_Status__c, a.Account_Effective_Date__c, a.OwnerId, a.Commission_Dealer__c, 
    			a.Parent_Acct_CC_ID__c, a.Acct_ID_18_Char__c 
    			FROM Account a 
    			WHERE Name LIKE 'Anew Customer Test%' LIMIT 1];	//Relies on the Account Name setup in the @testSetup method
    	system.debug(readAcct.Name);
    	return readAcct;
    } 
    
    static pw_ccpro__CountryObject__c SetUpCountry_Test(){
    	
        pw_ccpro__CountryObject__c returnCo = new pw_ccpro__CountryObject__c ();
    	returnCo = [SELECT Id, Name, pw_ccpro__IsoCode_2__c, pw_ccpro__IsoCode_3__c
    	            FROM pw_ccpro__CountryObject__c
    	            WHERE Name = 'Canada' LIMIT 1];
    	return returnCo;
    }
    
    static String GenerateRandomString_Test(){
        
        Integer len = 40;
        
        Integer[] charset = new Integer[0];
        for(Integer i = 15; i < 25; i++) charset.add(i);
        for(Integer i = 33; i < 43; i++) charset.add(i);
        for(Integer i = 50; i < 60; i++) charset.add(i);
        for(Integer i = 77; i < 87; i++) charset.add(i);
        
        Integer[] chars = new Integer[len];
        Integer key, size = charset.size();
    
        for(Integer idx = 0; idx < len; idx++) {
            chars[idx] = charset[Math.mod(Math.abs(Crypto.getRandomInteger()), size)];
        }
    
        return String.fromCharArray(chars);
    }  
    
    //This is where we really start testing code!
    //The Custom Settings used by this Class are setup once in the @testSetup annotated method.
    static testMethod void CreateOrderByProspect_Test()
    {
        Account a = SetUpAccountData_Test();
         
        Integer i = CCDS_InventoryHelper.CreateOrderBy(false, a);
        
        System.assert(i > 0);
    }
    
    static testMethod void CreateOrderByCustomer_Test()
    {
        Account a = SetUpAccountData_Test();
        a.Custom_Call_Acct_ID__c = String.valueOf(Math.round(Math.random() * 123456));
        
        Integer i = CCDS_InventoryHelper.CreateOrderBy(true, a);
        
        System.assert(i > 0);
    }
    
    static testmethod void CreateOrderFid_Test()
    {   	
        System.assert(CCDS_InventoryHelper.CreateOrderFid(-1001, 'Lucky Lady') != false);
    }
    
    static testMethod void SubmitTheOrder_Test()
    {       
        System.Assert(CCDS_InventoryHelper.SubmitTheOrder(null) == false);
        System.assert(CCDS_InventoryHelper.SubmitTheOrder(-1001) == true);
    }
    
    static testmethod void ProcessInventoryReturnResult_Test()
    {
        Account a = SetUpAccountData_Test();
        a.Custom_Call_Acct_ID__c = String.valueOf(Math.round(Math.random() * 123456));
        
        CCDS_Inventory.InventoryReturn result = new CCDS_Inventory.InventoryReturn();
        result.successful = true;
        result.Ids = new string[] {'1'};   
            
        System.assert(CCDS_InventoryHelper.ProcessInventoryReturnResult(result, a) == 1);  
        
        result.successful = false;
        result.messages = new String[] {'testing Will Robinson'};
            
        System.assert(CCDS_InventoryHelper.ProcessInventoryReturnResult(result, a) == -1);         
    }

    static testMethod void MockEntityProxy_Test()
    {
        CCDS_Inventory.ItemAvailabilityDetail i1 = new CCDS_Inventory.ItemAvailabilityDetail(); 
        CCDS_Inventory.Item i2 = new CCDS_Inventory.Item();
        CCDS_Inventory.ItemDetailDisplay i3 = new CCDS_Inventory.ItemDetailDisplay();
        CCDS_Inventory.ItemDetail i4 = new CCDS_Inventory.ItemDetail();
        CCDS_Inventory.FidEnabledImpl i5 = new CCDS_Inventory.FidEnabledImpl();
        CCDS_Inventory.CustomerItemReturn i6 = new CCDS_Inventory.CustomerItemReturn();
        CCDS_Inventory.NumbersInventorySummaryReturn i7 = new CCDS_Inventory.NumbersInventorySummaryReturn();
        CCDS_Inventory.UpdateBtnLine i8 = new CCDS_Inventory.UpdateBtnLine();
        CCDS_Inventory.OrderDetail i9 = new CCDS_Inventory.OrderDetail();
        CCDS_Inventory.LinesReturn i10 = new CCDS_Inventory.LinesReturn();
        CCDS_Inventory.AniReturn i11 = new CCDS_Inventory.AniReturn();
        CCDS_Inventory.CustomerItemDelete i12 = new CCDS_Inventory.CustomerItemDelete();
        CCDS_Inventory.LineStatusReturn i13 = new CCDS_Inventory.LineStatusReturn();
        CCDS_Inventory.BtnReturn i14 = new CCDS_Inventory.BtnReturn();
        CCDS_Inventory.LineLDProvisioningOptions i15 = new CCDS_Inventory.LineLDProvisioningOptions();
        CCDS_Inventory.LineFidDetail i16 = new CCDS_Inventory.LineFidDetail();
        CCDS_Inventory.LineTypeAndFids i17 = new CCDS_Inventory.LineTypeAndFids();
        CCDS_Inventory.ItemReturn i18 = new CCDS_Inventory.ItemReturn();
        CCDS_Inventory.Add800Line i19 = new CCDS_Inventory.Add800Line();
        CCDS_Inventory.BtnTerminator i20 = new CCDS_Inventory.BtnTerminator();
        CCDS_Inventory.OrderServicesReturn i21 = new CCDS_Inventory.OrderServicesReturn();
        CCDS_Inventory.AniWithBtn i22 = new CCDS_Inventory.AniWithBtn();
        CCDS_Inventory.AddressContainer i23 = new CCDS_Inventory.AddressContainer();
        CCDS_Inventory.MultipleProvisioningUpdates i24 = new CCDS_Inventory.MultipleProvisioningUpdates();
        CCDS_Inventory.AddVoipLine i25 = new CCDS_Inventory.AddVoipLine();       
        CCDS_Inventory.OrderFidDetailReturn i26 = new CCDS_Inventory.OrderFidDetailReturn();
        CCDS_Inventory.LineProvisioningOptions i27 = new CCDS_Inventory.LineProvisioningOptions();
        CCDS_Inventory.BaseFidDetail i28 = new CCDS_Inventory.BaseFidDetail();
        CCDS_Inventory.AniWithBtnReturn i29 = new CCDS_Inventory.AniWithBtnReturn();
        CCDS_Inventory.Ani i30 = new CCDS_Inventory.Ani();
        CCDS_Inventory.BtnMove i31 = new CCDS_Inventory.BtnMove();
        CCDS_Inventory.CustomerItemFidDetail i32 = new CCDS_Inventory.CustomerItemFidDetail();
        CCDS_Inventory.AddLineWithBtn i33 = new CCDS_Inventory.AddLineWithBtn();
        CCDS_Inventory.Market i34 = new CCDS_Inventory.Market();
        CCDS_Inventory.LineFidDetailReturn i35 = new CCDS_Inventory.LineFidDetailReturn();
        CCDS_Inventory.ItemSearchReturn i36 = new CCDS_Inventory.ItemSearchReturn();
        CCDS_Inventory.InventoryReturn i37 = new CCDS_Inventory.InventoryReturn();
        CCDS_Inventory.AddBtnLine i38 = new CCDS_Inventory.AddBtnLine();
        CCDS_Inventory.MarketReturn i39 = new CCDS_Inventory.MarketReturn();
        CCDS_Inventory.LineStatus i40 = new CCDS_Inventory.LineStatus();
        CCDS_Inventory.Btn i41 = new CCDS_Inventory.Btn();
        CCDS_Inventory.AddLineWithBtnReturn i42 = new CCDS_Inventory.AddLineWithBtnReturn();
        CCDS_Inventory.Order i43 = new CCDS_Inventory.Order();
        CCDS_Inventory.NumbersInventorySummary i44 = new CCDS_Inventory.NumbersInventorySummary();
        CCDS_Inventory.MultipleAniUpdates i45 = new CCDS_Inventory.MultipleAniUpdates();
        CCDS_Inventory.AddItemDetail i46 = new CCDS_Inventory.AddItemDetail();
        CCDS_Inventory.AddLine i47 = new CCDS_Inventory.AddLine();
        CCDS_Inventory.CustomerItem i48 = new CCDS_Inventory.CustomerItem();
        CCDS_Inventory.LineProvisioningOptionsReturn i49 = new CCDS_Inventory.LineProvisioningOptionsReturn();
        CCDS_Inventory.NpaNxxReturn i50 = new CCDS_Inventory.NpaNxxReturn();
        CCDS_Inventory.OptionalSubItem i51 = new CCDS_Inventory.OptionalSubItem();
        CCDS_Inventory.ActiveOrderNumberReturn i52 = new CCDS_Inventory.ActiveOrderNumberReturn();
        CCDS_Inventory.NumbersStatusReturn i53 = new CCDS_Inventory.NumbersStatusReturn();
        CCDS_Inventory.FidDropDown i54 = new CCDS_Inventory.FidDropDown();
        CCDS_Inventory.LineAddressReturn i55 = new CCDS_Inventory.LineAddressReturn();
        CCDS_Inventory.OrderFidDetail i56 = new CCDS_Inventory.OrderFidDetail();
        CCDS_Inventory.MultipleAddressUpdates i57 = new CCDS_Inventory.MultipleAddressUpdates();
        CCDS_Inventory.LineTerminator i58 = new CCDS_Inventory.LineTerminator();
        CCDS_Inventory.OrderReturn i59 = new CCDS_Inventory.OrderReturn();
        CCDS_Inventory.AniTerminator i60 = new CCDS_Inventory.AniTerminator();
        CCDS_Inventory.Address i61 = new CCDS_Inventory.Address();
        CCDS_Inventory.MultipleAniAdds i62 = new CCDS_Inventory.MultipleAniAdds();
        CCDS_Inventory.AddOptionalSubItem i63 = new CCDS_Inventory.AddOptionalSubItem();
        CCDS_Inventory.MaintainServices i64 = new CCDS_Inventory.MaintainServices();      
        CCDS_Inventory.Line i65 = new CCDS_Inventory.Line();
        CCDS_Inventory.Map_x i66 = new CCDS_Inventory.Map_x();
        CCDS_Inventory.BaseException i67 = new CCDS_Inventory.BaseException();
        CCDS_Inventory.BaseDataObject i68 = new CCDS_Inventory.BaseDataObject();
        CCDS_Inventory.BaseRequiredDataObject i69 = new CCDS_Inventory.BaseRequiredDataObject();
        CCDS_Inventory.ServiceException i70 = new CCDS_Inventory.ServiceException();
        CCDS_Inventory.addAniResponse_element i71 = new CCDS_Inventory.addAniResponse_element();
        CCDS_Inventory.getAvailableServicesForProspectOrderResponse_element i72 = new CCDS_Inventory.getAvailableServicesForProspectOrderResponse_element();
        CCDS_Inventory.maintainServicesOnProspectOrderResponse_element i73 = new CCDS_Inventory.maintainServicesOnProspectOrderResponse_element();
        CCDS_Inventory.updateLineProvisioningOptions_element i74 = new CCDS_Inventory.updateLineProvisioningOptions_element();
        CCDS_Inventory.startOrderWithExternalId_element i75 = new CCDS_Inventory.startOrderWithExternalId_element();
        CCDS_Inventory.getCustomerItems_element i76 = new CCDS_Inventory.getCustomerItems_element();
        CCDS_Inventory.startOrderWithProspectId_element i77 = new CCDS_Inventory.startOrderWithProspectId_element();
        CCDS_Inventory.getAvailableNumbersSummary_element i78 = new CCDS_Inventory.getAvailableNumbersSummary_element();
        CCDS_Inventory.addBtnResponse_element i79 = new CCDS_Inventory.addBtnResponse_element();
        CCDS_Inventory.getLineProvisioningOptionsForLineResponse_element i80 = new CCDS_Inventory.getLineProvisioningOptionsForLineResponse_element();
        CCDS_Inventory.deleteCustomerItemResponse_element i81 = new CCDS_Inventory.deleteCustomerItemResponse_element();
        CCDS_Inventory.itemSearchResponse_element i82 = new CCDS_Inventory.itemSearchResponse_element();
        CCDS_Inventory.addDocumentResponse_element i83 = new CCDS_Inventory.addDocumentResponse_element();
        CCDS_Inventory.addBtn_element i84 = new CCDS_Inventory.addBtn_element();
        CCDS_Inventory.startOrderWithCustomerNumber_element i85 = new CCDS_Inventory.startOrderWithCustomerNumber_element();
        CCDS_Inventory.getNumbersStatusByLineNumberResponse_element i86 = new CCDS_Inventory.getNumbersStatusByLineNumberResponse_element();
        CCDS_Inventory.updateMultipleAnis_element i87 = new CCDS_Inventory.updateMultipleAnis_element();
        CCDS_Inventory.getEntityAnisByOrderIdAndStatusResponse_element i88 = new CCDS_Inventory.getEntityAnisByOrderIdAndStatusResponse_element();
        CCDS_Inventory.getActiveOrdersForExternalIdResponse_element i89 = new CCDS_Inventory.getActiveOrdersForExternalIdResponse_element();
        CCDS_Inventory.getEntityAniByLineNumber_element i90 = new CCDS_Inventory.getEntityAniByLineNumber_element();
        CCDS_Inventory.updateLineResponse_element i91 = new CCDS_Inventory.updateLineResponse_element();
        CCDS_Inventory.moveBtn_element i92 = new CCDS_Inventory.moveBtn_element();
        CCDS_Inventory.getEntityAniResponse_element i93 = new CCDS_Inventory.getEntityAniResponse_element();
        CCDS_Inventory.getLinesByLineNumberResponse_element i94 = new CCDS_Inventory.getLinesByLineNumberResponse_element();
        CCDS_Inventory.getEntityAnisByOrderId_element i95 = new CCDS_Inventory.getEntityAnisByOrderId_element();
        CCDS_Inventory.addOptionalSubItemResponse_element i96 = new CCDS_Inventory.addOptionalSubItemResponse_element();
        CCDS_Inventory.addItemResponse_element i97 = new CCDS_Inventory.addItemResponse_element();
        CCDS_Inventory.getFidsForAddLineByProspectIdResponse_element i98 = new CCDS_Inventory.getFidsForAddLineByProspectIdResponse_element();
        CCDS_Inventory.terminateLine_element i99 = new CCDS_Inventory.terminateLine_element();
        CCDS_Inventory.addReservedNumbersToOrder_element i100 = new CCDS_Inventory.addReservedNumbersToOrder_element();
        CCDS_Inventory.getFidsByLineIdAndFidId_element i101 = new CCDS_Inventory.getFidsByLineIdAndFidId_element();
        CCDS_Inventory.getActiveOrdersForProspectIdResponse_element i102 = new CCDS_Inventory.getActiveOrdersForProspectIdResponse_element();
        CCDS_Inventory.getAvailableNumbersSummaryResponse_element i103 = new CCDS_Inventory.getAvailableNumbersSummaryResponse_element();
        CCDS_Inventory.maintainServicesOnProspectOrder_element i104 = new CCDS_Inventory.maintainServicesOnProspectOrder_element();
        CCDS_Inventory.getNumbersStatusByLineNumber_element i105 = new CCDS_Inventory.getNumbersStatusByLineNumber_element();
        CCDS_Inventory.startOrderWithCustomerNumberResponse_element i106 = new CCDS_Inventory.startOrderWithCustomerNumberResponse_element();
        CCDS_Inventory.getFidsForAddLineByProspectId_element i107 = new CCDS_Inventory.getFidsForAddLineByProspectId_element();
        CCDS_Inventory.getEntityBtn_element i108 = new CCDS_Inventory.getEntityBtn_element();
        CCDS_Inventory.addAniWithBtnResponse_element i109 = new CCDS_Inventory.addAniWithBtnResponse_element();
        CCDS_Inventory.getEntityBtns_element i110 = new CCDS_Inventory.getEntityBtns_element();
        CCDS_Inventory.getFidsByLineIdResponse_element i111 = new CCDS_Inventory.getFidsByLineIdResponse_element();
        CCDS_Inventory.addVoipResponse_element i112 = new CCDS_Inventory.addVoipResponse_element();
        CCDS_Inventory.updateMultipleLineAddresses_element i113 = new CCDS_Inventory.updateMultipleLineAddresses_element();
        CCDS_Inventory.reserveNumbers_element i114 = new CCDS_Inventory.reserveNumbers_element();
        CCDS_Inventory.getEntityAnis_element i115 = new CCDS_Inventory.getEntityAnis_element();
        CCDS_Inventory.getFidsByLineId_element i116 = new CCDS_Inventory.getFidsByLineId_element();
        CCDS_Inventory.getEntityAnisByCustomerNumberAndStatus_element i117 = new CCDS_Inventory.getEntityAnisByCustomerNumberAndStatus_element();
        CCDS_Inventory.terminateLineResponse_element i118 = new CCDS_Inventory.terminateLineResponse_element();
        CCDS_Inventory.getCustomerItemsResponse_element i119 = new CCDS_Inventory.getCustomerItemsResponse_element();
        CCDS_Inventory.updateLineAddress_element i120 = new CCDS_Inventory.updateLineAddress_element();
        CCDS_Inventory.updateMultipleLineProvisioningOptionsResponse_element i121 = new CCDS_Inventory.updateMultipleLineProvisioningOptionsResponse_element();
        CCDS_Inventory.addOrUpdateFidResponse_element i122 = new CCDS_Inventory.addOrUpdateFidResponse_element();
        CCDS_Inventory.getEntityAni_element i123 = new CCDS_Inventory.getEntityAni_element();
        CCDS_Inventory.getEntityBtnsByCustomerNumberResponse_element i124 = new CCDS_Inventory.getEntityBtnsByCustomerNumberResponse_element();
        CCDS_Inventory.getMarketsByNpaNxxResponse_element i125 = new CCDS_Inventory.getMarketsByNpaNxxResponse_element();
        CCDS_Inventory.startOrderWithProspectIdResponse_element i126 = new CCDS_Inventory.startOrderWithProspectIdResponse_element();
        CCDS_Inventory.getEntityAnisForStatusResponse_element i127 = new CCDS_Inventory.getEntityAnisForStatusResponse_element();
        CCDS_Inventory.getFidsByLineIdAndFidIdResponse_element i128 = new CCDS_Inventory.getFidsByLineIdAndFidIdResponse_element();
        CCDS_Inventory.getOrderResponse_element i129 = new CCDS_Inventory.getOrderResponse_element();
        CCDS_Inventory.getLinesByTypeAndFidValuesResponse_element i130 = new CCDS_Inventory.getLinesByTypeAndFidValuesResponse_element();
        CCDS_Inventory.terminateBtn_element i131 = new CCDS_Inventory.terminateBtn_element();
        CCDS_Inventory.terminateCustomerItemResponse_element i132 = new CCDS_Inventory.terminateCustomerItemResponse_element();
        CCDS_Inventory.addReservedNumbersToOrderResponse_element i133 = new CCDS_Inventory.addReservedNumbersToOrderResponse_element();
        CCDS_Inventory.updateAniResponse_element i134 = new CCDS_Inventory.updateAniResponse_element();
        CCDS_Inventory.getFidsForAddLineResponse_element i135 = new CCDS_Inventory.getFidsForAddLineResponse_element();
        CCDS_Inventory.add800Response_element i136 = new CCDS_Inventory.add800Response_element();
        CCDS_Inventory.getMarketsByNpaNxx_element i137 = new CCDS_Inventory.getMarketsByNpaNxx_element();
        CCDS_Inventory.updateBtnLineResponse_element i138 = new CCDS_Inventory.updateBtnLineResponse_element();
        CCDS_Inventory.getNpaNxxForStatusResponse_element i139 = new CCDS_Inventory.getNpaNxxForStatusResponse_element();
        CCDS_Inventory.getCustomerItemsForLineResponse_element i140 = new CCDS_Inventory.getCustomerItemsForLineResponse_element();
        CCDS_Inventory.getActiveOrdersForProspectId_element i141 = new CCDS_Inventory.getActiveOrdersForProspectId_element();
        CCDS_Inventory.getEntityAnisByCustomerNumberResponse_element i142 = new CCDS_Inventory.getEntityAnisByCustomerNumberResponse_element();
        CCDS_Inventory.updateLineAddressResponse_element i143 = new CCDS_Inventory.updateLineAddressResponse_element();
        CCDS_Inventory.addDocument_element i144 = new CCDS_Inventory.addDocument_element();
        CCDS_Inventory.getCustomerItemsForLine_element i145 = new CCDS_Inventory.getCustomerItemsForLine_element();
        CCDS_Inventory.reserveAndAddNumberToOrder_element i146 = new CCDS_Inventory.reserveAndAddNumberToOrder_element();
        CCDS_Inventory.updateAni_element i147 = new CCDS_Inventory.updateAni_element();
        CCDS_Inventory.getEntityAnisResponse_element i148 = new CCDS_Inventory.getEntityAnisResponse_element();
        CCDS_Inventory.reserveNumbersResponse_element i149 = new CCDS_Inventory.reserveNumbersResponse_element();
        CCDS_Inventory.getMarkets_element i150 = new CCDS_Inventory.getMarkets_element();
        CCDS_Inventory.addAni_element i151 = new CCDS_Inventory.addAni_element();
        CCDS_Inventory.addCustomerItemResponse_element i152 = new CCDS_Inventory.addCustomerItemResponse_element();
        CCDS_Inventory.getActiveOrdersForExternalId_element i153 = new CCDS_Inventory.getActiveOrdersForExternalId_element();
        CCDS_Inventory.addVoipWithBtn_element i154 = new CCDS_Inventory.addVoipWithBtn_element();
        CCDS_Inventory.getLineStatusOptions_element i155 = new CCDS_Inventory.getLineStatusOptions_element();
        CCDS_Inventory.updateMultipleLineAddressesResponse_element i156 = new CCDS_Inventory.updateMultipleLineAddressesResponse_element();
        CCDS_Inventory.addCustomerItem_element i157 = new CCDS_Inventory.addCustomerItem_element();
        CCDS_Inventory.terminateCustomerItem_element i158 = new CCDS_Inventory.terminateCustomerItem_element();
        CCDS_Inventory.getActiveOrdersForCustomerNumberResponse_element i159 = new CCDS_Inventory.getActiveOrdersForCustomerNumberResponse_element();
        CCDS_Inventory.reserveAndAddNumberToOrderResponse_element i160 = new CCDS_Inventory.reserveAndAddNumberToOrderResponse_element();
        CCDS_Inventory.changeNumbersStatusForOrderResponse_element i161 = new CCDS_Inventory.changeNumbersStatusForOrderResponse_element();
        CCDS_Inventory.getAvailableServicesForProspectOrder_element i162 = new CCDS_Inventory.getAvailableServicesForProspectOrder_element();
        CCDS_Inventory.add800_element i163 = new CCDS_Inventory.add800_element();
        CCDS_Inventory.getAddressForLineResponse_element i164 = new CCDS_Inventory.getAddressForLineResponse_element();
        CCDS_Inventory.getLinesByLineNumber_element i165 = new CCDS_Inventory.getLinesByLineNumber_element();
        CCDS_Inventory.deleteOrder_element i166 = new CCDS_Inventory.deleteOrder_element();
        CCDS_Inventory.addOptionalSubItem_element i167 = new CCDS_Inventory.addOptionalSubItem_element();
        CCDS_Inventory.addItem_element i168 = new CCDS_Inventory.addItem_element();
        CCDS_Inventory.changeNumbersStatusForOrder_element i169 = new CCDS_Inventory.changeNumbersStatusForOrder_element();
        CCDS_Inventory.addMultipleAnisResponse_element i170 = new CCDS_Inventory.addMultipleAnisResponse_element();
        CCDS_Inventory.submitOrderResponse_element i171 = new CCDS_Inventory.submitOrderResponse_element();
        CCDS_Inventory.terminateBtnResponse_element i172 = new CCDS_Inventory.terminateBtnResponse_element();
        CCDS_Inventory.startOrderWithExternalIdResponse_element i173 = new CCDS_Inventory.startOrderWithExternalIdResponse_element();
        CCDS_Inventory.terminateAni_element i174 = new CCDS_Inventory.terminateAni_element();
        CCDS_Inventory.getNpaNxxForCustomerNumberAndStatus_element i175 = new CCDS_Inventory.getNpaNxxForCustomerNumberAndStatus_element();
        CCDS_Inventory.deleteLine_element i176 = new CCDS_Inventory.deleteLine_element();
        CCDS_Inventory.getLineStatusOptionsResponse_element i177 = new CCDS_Inventory.getLineStatusOptionsResponse_element();
        CCDS_Inventory.Exception_x i178 = new CCDS_Inventory.Exception_x();
        CCDS_Inventory.getFidsForOrderResponse_element i179 = new CCDS_Inventory.getFidsForOrderResponse_element();
        CCDS_Inventory.getFidsForAddLine_element i180 = new CCDS_Inventory.getFidsForAddLine_element();
        CCDS_Inventory.addAniWithBtn_element i181 = new CCDS_Inventory.addAniWithBtn_element();
        CCDS_Inventory.getEntityBtnResponse_element i182 = new CCDS_Inventory.getEntityBtnResponse_element();
        CCDS_Inventory.getEntityAniByLineNumberResponse_element i183 = new CCDS_Inventory.getEntityAniByLineNumberResponse_element();
        CCDS_Inventory.itemSearch_element i184 = new CCDS_Inventory.itemSearch_element();
        CCDS_Inventory.getEntityAnisForStatus_element i185 = new CCDS_Inventory.getEntityAnisForStatus_element();
        CCDS_Inventory.getEntityBtnsResponse_element i186 = new CCDS_Inventory.getEntityBtnsResponse_element();
        CCDS_Inventory.getEntityBtnsByCustomerNumber_element i187 = new CCDS_Inventory.getEntityBtnsByCustomerNumber_element();
        CCDS_Inventory.getEntityAnisByOrderIdResponse_element i188 = new CCDS_Inventory.getEntityAnisByOrderIdResponse_element();
        CCDS_Inventory.updateMultipleLineProvisioningOptions_element i189 = new CCDS_Inventory.updateMultipleLineProvisioningOptions_element();
        CCDS_Inventory.addMultipleAnis_element i190 = new CCDS_Inventory.addMultipleAnis_element();
        CCDS_Inventory.terminateAniResponse_element i191 = new CCDS_Inventory.terminateAniResponse_element();
        CCDS_Inventory.deleteCustomerItem_element i192 = new CCDS_Inventory.deleteCustomerItem_element();
        CCDS_Inventory.deleteOrderResponse_element i193 = new CCDS_Inventory.deleteOrderResponse_element();
        CCDS_Inventory.addOrUpdateFid_element i194 = new CCDS_Inventory.addOrUpdateFid_element();
        CCDS_Inventory.submitOrder_element i195 = new CCDS_Inventory.submitOrder_element();
        CCDS_Inventory.updateLineProvisioningOptionsResponse_element i196 = new CCDS_Inventory.updateLineProvisioningOptionsResponse_element();
        CCDS_Inventory.updateLine_element i197 = new CCDS_Inventory.updateLine_element();
        CCDS_Inventory.moveBtnResponse_element i198 = new CCDS_Inventory.moveBtnResponse_element();
        CCDS_Inventory.getLineProvisioningOptionsForLine_element i199 = new CCDS_Inventory.getLineProvisioningOptionsForLine_element();
        CCDS_Inventory.addVoipWithBtnResponse_element i200 = new CCDS_Inventory.addVoipWithBtnResponse_element();
        CCDS_Inventory.addVoip_element i201 = new CCDS_Inventory.addVoip_element();
        CCDS_Inventory.getMarketsResponse_element i202 = new CCDS_Inventory.getMarketsResponse_element();
        CCDS_Inventory.updateBtnLine_element i203 = new CCDS_Inventory.updateBtnLine_element();
        CCDS_Inventory.getOrder_element i204 = new CCDS_Inventory.getOrder_element();
        CCDS_Inventory.getLinesByTypeAndFidValues_element i205 = new CCDS_Inventory.getLinesByTypeAndFidValues_element();
        CCDS_Inventory.getEntityAnisByCustomerNumber_element i206 = new CCDS_Inventory.getEntityAnisByCustomerNumber_element();
        CCDS_Inventory.getNpaNxxForStatus_element i207 = new CCDS_Inventory.getNpaNxxForStatus_element();
        CCDS_Inventory.getNpaNxxForCustomerNumberAndStatusResponse_element i208 = new CCDS_Inventory.getNpaNxxForCustomerNumberAndStatusResponse_element();
        CCDS_Inventory.updateMultipleAnisResponse_element i209 = new CCDS_Inventory.updateMultipleAnisResponse_element();
        CCDS_Inventory.getEntityAnisByOrderIdAndStatus_element i210 = new CCDS_Inventory.getEntityAnisByOrderIdAndStatus_element();
        CCDS_Inventory.getFidsForOrder_element i211 = new CCDS_Inventory.getFidsForOrder_element();
        CCDS_Inventory.getAddressForLine_element i212 = new CCDS_Inventory.getAddressForLine_element();
        CCDS_Inventory.getEntityAnisByCustomerNumberAndStatusResponse_element i213 = new CCDS_Inventory.getEntityAnisByCustomerNumberAndStatusResponse_element();
        CCDS_Inventory.ServiceException_element i214 = new CCDS_Inventory.ServiceException_element();
        CCDS_Inventory.Number_x i215 = new CCDS_Inventory.Number_x();
        CCDS_Inventory.InventorySummaryItem i216 = new CCDS_Inventory.InventorySummaryItem();
        CCDS_Inventory.ServiceItem i217 = new CCDS_Inventory.ServiceItem();
        CCDS_Inventory.Authentication i218 = new CCDS_Inventory.Authentication();
        CCDS_Inventory.BaseReturnObject i219 = new CCDS_Inventory.BaseReturnObject();
        CCDS_Inventory.InventoryHttpSoap11Endpoint i220 = new CCDS_Inventory.InventoryHttpSoap11Endpoint();
        
        CCDS_Inventory.getActiveOrdersForCustomerNumber_element i221 = new CCDS_Inventory.getActiveOrdersForCustomerNumber_element();    
    	CCDS_Inventory.deleteLineResponse_element i222 = new CCDS_Inventory.deleteLineResponse_element();
        CCDS_Inventory.UpdateBtnLine i223 = new CCDS_Inventory.UpdateBtnLine();
        CCDS_Inventory.MultipleProvisioningUpdates i224 = new CCDS_Inventory.MultipleProvisioningUpdates();
        CCDS_Inventory.AddBtnLine i225 = new CCDS_Inventory.AddBtnLine();
        CCDS_Inventory.MaintainServices i226 = new CCDS_Inventory.MaintainServices();
        CCDS_Inventory.MultipleAddressUpdates i227 = new CCDS_Inventory.MultipleAddressUpdates();
    
    	
    
        System.assert(i1 != null);
        System.assert(i2 != null);
        System.assert(i3 != null);
        System.assert(i4 != null);
        System.assert(i5 != null);
        System.assert(i6 != null);
        System.assert(i7 != null);
        System.assert(i8 != null);
        System.assert(i9 != null);
        System.assert(i10 != null);
        System.assert(i11 != null);
        System.assert(i12 != null);
        System.assert(i13 != null);
        System.assert(i14 != null);
        System.assert(i15 != null);
        System.assert(i16 != null);
        System.assert(i17 != null);
        System.assert(i18 != null);
        System.assert(i19 != null);
        System.assert(i20 != null);
        System.assert(i21 != null);
        System.assert(i22 != null);
        System.assert(i23 != null);
        System.assert(i24 != null);
        System.assert(i25 != null);
        System.assert(i26 != null);
        System.assert(i27 != null);
        System.assert(i28 != null);
        System.assert(i29 != null);
        System.assert(i30 != null);
        System.assert(i31 != null);
        System.assert(i32 != null);
        System.assert(i33 != null);
        System.assert(i34 != null);
        System.assert(i35 != null);
        System.assert(i36 != null);
        System.assert(i37 != null);
        System.assert(i38 != null);
        System.assert(i39 != null);
        System.assert(i40 != null);
        System.assert(i41 != null);
        System.assert(i42 != null);
        System.assert(i43 != null);
        System.assert(i44 != null);
        System.assert(i45 != null);
        System.assert(i46 != null);
        System.assert(i47 != null);
        System.assert(i48 != null);
        System.assert(i49 != null);
        System.assert(i50 != null);
        System.assert(i51 != null);
        System.assert(i52 != null);
        System.assert(i53 != null);
        System.assert(i54 != null);
        System.assert(i55 != null);
        System.assert(i56 != null);
        System.assert(i57 != null);
        System.assert(i58 != null);
        System.assert(i59 != null);
        System.assert(i60 != null);
        System.assert(i61 != null);
        System.assert(i62 != null);
        System.assert(i63 != null);
        System.assert(i64 != null);
        System.assert(i65 != null);
        System.assert(i66 != null);
        System.assert(i67 != null);
        System.assert(i68 != null);
        System.assert(i69 != null);
        System.assert(i70 != null);
        System.assert(i71 != null);
        System.assert(i72 != null);
        System.assert(i73 != null);
        System.assert(i74 != null);
        System.assert(i75 != null);
        System.assert(i76 != null);
        System.assert(i77 != null);
        System.assert(i78 != null);
        System.assert(i79 != null);
        System.assert(i80 != null);
        System.assert(i81 != null);
        System.assert(i82 != null);
        System.assert(i83 != null);
        System.assert(i84 != null);
        System.assert(i85 != null);
        System.assert(i86 != null);
        System.assert(i87 != null);
        System.assert(i88 != null);
        System.assert(i89 != null);
        System.assert(i90 != null);
        System.assert(i91 != null);
        System.assert(i92 != null);
        System.assert(i93 != null);
        System.assert(i94 != null);
        System.assert(i95 != null);
        System.assert(i96 != null);
        System.assert(i97 != null);
        System.assert(i98 != null);
        System.assert(i99 != null);
        System.assert(i100 != null);
        System.assert(i101 != null);
        System.assert(i102 != null);
        System.assert(i103 != null);
        System.assert(i104 != null);
        System.assert(i105 != null);
        System.assert(i106 != null);
        System.assert(i107 != null);
        System.assert(i108 != null);
        System.assert(i109 != null);
        System.assert(i110 != null);
        System.assert(i111 != null);
        System.assert(i112 != null);
        System.assert(i113 != null);
        System.assert(i114 != null);
        System.assert(i115 != null);
        System.assert(i116 != null);
        System.assert(i117 != null);
        System.assert(i118 != null);
        System.assert(i119 != null);
        System.assert(i120 != null);
        System.assert(i121 != null);
        System.assert(i122 != null);
        System.assert(i123 != null);
        System.assert(i124 != null);
        System.assert(i125 != null);
        System.assert(i126 != null);
        System.assert(i127 != null);
        System.assert(i128 != null);
        System.assert(i129 != null);
        System.assert(i130 != null);
        System.assert(i131 != null);
        System.assert(i132 != null);
        System.assert(i133 != null);
        System.assert(i134 != null);
        System.assert(i135 != null);
        System.assert(i136 != null);
        System.assert(i137 != null);
        System.assert(i138 != null);
        System.assert(i139 != null);
        System.assert(i140 != null);
        System.assert(i141 != null);
        System.assert(i142 != null);
        System.assert(i143 != null);
        System.assert(i144 != null);
        System.assert(i145 != null);
        System.assert(i146 != null);
        System.assert(i147 != null);
        System.assert(i148 != null);
        System.assert(i149 != null);
        System.assert(i150 != null);
        System.assert(i151 != null);
        System.assert(i152 != null);
        System.assert(i153 != null);
        System.assert(i154 != null);
        System.assert(i155 != null);
        System.assert(i156 != null);
        System.assert(i157 != null);
        System.assert(i158 != null);
        System.assert(i159 != null);
        System.assert(i160 != null);
        System.assert(i161 != null);
        System.assert(i162 != null);
        System.assert(i163 != null);
        System.assert(i164 != null);
        System.assert(i165 != null);
        System.assert(i166 != null);
        System.assert(i167 != null);
        System.assert(i168 != null);
        System.assert(i169 != null);
        System.assert(i170 != null);
        System.assert(i171 != null);
        System.assert(i172 != null);
        System.assert(i173 != null);
        System.assert(i174 != null);
        System.assert(i175 != null);
        System.assert(i176 != null);
        System.assert(i177 != null);
        System.assert(i178 != null);
        System.assert(i179 != null);
        System.assert(i180 != null);
        System.assert(i181 != null);
        System.assert(i182 != null);
        System.assert(i183 != null);
        System.assert(i184 != null);
        System.assert(i185 != null);
        System.assert(i186 != null);
        System.assert(i187 != null);
        System.assert(i188 != null);
        System.assert(i189 != null);
        System.assert(i190 != null);
        System.assert(i191 != null);
        System.assert(i192 != null);
        System.assert(i193 != null);
        System.assert(i194 != null);
        System.assert(i195 != null);
        System.assert(i196 != null);
        System.assert(i197 != null);
        System.assert(i198 != null);
        System.assert(i199 != null);
        System.assert(i200 != null);
        System.assert(i201 != null);
        System.assert(i202 != null);
        System.assert(i203 != null);
        System.assert(i204 != null);
        System.assert(i205 != null);
        System.assert(i206 != null);
        System.assert(i207 != null);
        System.assert(i208 != null);
        System.assert(i209 != null);
        System.assert(i210 != null);
        System.assert(i211 != null);
        System.assert(i212 != null);
        System.assert(i213 != null);
        System.assert(i214 != null);
        System.assert(i215 != null);
        System.assert(i216 != null);
        System.assert(i217 != null);
        System.assert(i218 != null);
        System.assert(i219 != null);
        System.assert(i220 != null);
        System.assert(i221 != null);
        System.assert(i222 != null);
        System.assert(i223 != null);
        System.assert(i224 != null);
        System.assert(i225 != null);
        System.assert(i226 != null);
        System.assert(i227 != null);
        
        
        CCDS_Inventory.InventoryHttpSoap11Endpoint tempEP = new CCDS_Inventory.InventoryHttpSoap11Endpoint(1);
        CCDS_Inventory.Authentication auth = new CCDS_Inventory.Authentication('1','2','3','4','5');
        
        Test.startTest();
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.addReservedNumbersToOrderMockImpl());
        CCDS_Inventory.InventoryReturn inventoryReturn = tempEP.addReservedNumbersToOrder(auth, 1, 'Test', 1, 'Test', 'Test');
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.updateLineMockImpl());
        inventoryReturn = tempEP.updateLine(auth, i65);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.submitOrderMockImpl());
        inventoryReturn = tempEP.submitOrder(auth, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.getEntityAnisByOrderIdMockImpl());
        CCDS_Inventory.AniReturn aniReturn = tempEP.getEntityAnisByOrderId(auth, 1, 'Test', 'Test', false, false, false, false, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.getEntityAnisForStatusMockImpl());
        aniReturn = tempEP.getEntityAnisForStatus(auth, 'Test', 'Test', 1, false, false, false, false, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.addAniWithBtnMockImpl());
        CCDS_Inventory.AddLineWithBtnReturn addLineWithBtnReturn = tempEP.addAniWithBtn(auth, i33);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.terminateCustomerItemMockImpl());
        inventoryReturn = tempEP.terminateCustomerItem(auth, 1, Date.today());
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.getFidsForAddLineMockImpl());
        CCDS_Inventory.LineFidDetailReturn lineFidDetailReturn = tempEP.getFidsForAddLine(auth, 1, 'Test');
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.getEntityBtnsByCustomerNumberMockImpl());
        CCDS_Inventory.BtnReturn btnReturn = tempEP.getEntityBtnsByCustomerNumber(auth, 1, false);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.addMultipleAnisMockImpl());
        inventoryReturn = tempEP.addMultipleAnis(auth, i62);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.getCustomerItemsForLineMockImpl());
        CCDS_Inventory.CustomerItemReturn customerItemReturn = tempEP.getCustomerItemsForLine(auth, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.terminateLineMockImpl());
        inventoryReturn = tempEP.terminateLine(auth, i58);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.updateBtnLineMockImpl());
        inventoryReturn = tempEP.updateBtnLine(auth, i223);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.getLineStatusOptionsMockImpl());
        CCDS_Inventory.LineStatusReturn lineStatusReturn = tempEP.getLineStatusOptions(auth);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.getAvailableNumbersSummaryMockImpl());
        CCDS_Inventory.NumbersInventorySummaryReturn numbersInventorySummaryReturn = tempEP.getAvailableNumbersSummary(auth, 1, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.addVoipMockImpl());
        inventoryReturn = tempEP.addVoip(auth, i25);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.getEntityAniMockImpl());
        CCDS_Inventory.AniWithBtnReturn aniWithBtnReturn = tempEP.getEntityAni(auth, 1, false);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.getFidsForOrderMockImpl());
        CCDS_Inventory.OrderFidDetailReturn orderFidDetailReturn = tempEP.getFidsForOrder(auth, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.getEntityAnisByOrderIdAndStatusMockImpl());
        aniReturn = tempEP.getEntityAnisByOrderIdAndStatus(auth, 1, 'Test', 'Test', 1, false, false, false, false, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.getNpaNxxForCustomerNumberAndStatusMockImpl());
        CCDS_Inventory.NpaNxxReturn npaNxxReturn = tempEP.getNpaNxxForCustomerNumberAndStatus(auth, 1, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.updateMultipleLineProvisioningOptionsMockImpl());
        inventoryReturn = tempEP.updateMultipleLineProvisioningOptions(auth, i224);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.updateMultipleAnisMockImpl());
        inventoryReturn = tempEP.updateMultipleAnis(auth, i45);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.addDocumentMockImpl());
        inventoryReturn = tempEP.addDocument(auth, 'Test', 1, 'Test');
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.addBtnMockImpl());
        inventoryReturn = tempEP.addBtn(auth, i225);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.getFidsByLineIdMockImpl());
        lineFidDetailReturn = tempEP.getFidsByLineId(auth, 1, false);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.reserveAndAddNumberToOrderMockImpl());
        inventoryReturn = tempEP.reserveAndAddNumberToOrder(auth, 1, 1, 1, 1, 1, 1, 'Test', 1, 'Test', 'Test');
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.deleteOrderMockImpl());
        inventoryReturn = tempEP.deleteOrder(auth, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.getActiveOrdersForProspectIdMockImpl());
        CCDS_Inventory.ActiveOrderNumberReturn activeOrderNumberReturn = tempEP.getActiveOrdersForProspectId(auth, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.getLineProvisioningOptionsForLineMockImpl());
        CCDS_Inventory.LineProvisioningOptionsReturn lineProvisioningOptionsReturn = tempEP.getLineProvisioningOptionsForLine(auth, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.terminateAniMockImpl());
        inventoryReturn = tempEP.terminateAni(auth, i60);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.addItemMockImpl());
        inventoryReturn = tempEP.addItem(auth, i46);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.getAddressForLineMockImpl());
        CCDS_Inventory.LineAddressReturn lineAddressReturn = tempEP.getAddressForLine(auth, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.getActiveOrdersForExternalIdMockImpl());
        activeOrderNumberReturn = tempEP.getActiveOrdersForExternalId(auth, 'Test');
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.getEntityAnisByCustomerNumberMockImpl());
        aniReturn = tempEP.getEntityAnisByCustomerNumber(auth, 1, 'Test', 'Test', false, false, false, false, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.getEntityAnisMockImpl());
        aniReturn = tempEP.getEntityAnis(auth, 'Test', 'Test', 'Test', false, false, false, false, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.startOrderWithExternalIdMockImpl());
        inventoryReturn = tempEP.startOrderWithExternalId(auth, 'Test');
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.getEntityBtnsMockImpl());
        btnReturn = tempEP.getEntityBtns(auth, 'Test', false);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.itemSearchMockImpl());
        CCDS_Inventory.ItemSearchReturn itemSearchReturn = tempEP.itemSearch(auth, 'Test');
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.getFidsForAddLineByProspectIdMockImpl());
        lineFidDetailReturn = tempEP.getFidsForAddLineByProspectId(auth, 1, 'Test');
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.getAvailableServicesForProspectOrderMockImpl());
        CCDS_Inventory.OrderServicesReturn orderServicesReturn = tempEP.getAvailableServicesForProspectOrder(auth, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.getNumbersStatusByLineNumberMockImpl());
        CCDS_Inventory.NumbersStatusReturn numbersStatusReturn = tempEP.getNumbersStatusByLineNumber(auth, 'Test');
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.deleteLineMockImpl());
        inventoryReturn = tempEP.deleteLine(auth, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.getMarketsMockImpl());
        CCDS_Inventory.MarketReturn marketReturn = tempEP.getMarkets(auth);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.changeNumbersStatusForOrderMockImpl());
        inventoryReturn = tempEP.changeNumbersStatusForOrder(auth, 1, 1, 'Test', 1, 1, 1, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.deleteCustomerItemMockImpl());
        inventoryReturn = tempEP.deleteCustomerItem(auth, i12);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.addOrUpdateFidMockImpl());
        inventoryReturn = tempEP.addOrUpdateFid(auth, 1, 1, 'Test');
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.getCustomerItemsMockImpl());
        customerItemReturn = tempEP.getCustomerItems(auth, 1, 1, false);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.getOrderMockImpl());
        CCDS_Inventory.OrderReturn orderReturn = tempEP.getOrder(auth, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.updateLineProvisioningOptionsMockImpl());
        inventoryReturn = tempEP.updateLineProvisioningOptions(auth, i27);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.addCustomerItemMockImpl());
        inventoryReturn = tempEP.addCustomerItem(auth, i46);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.getActiveOrdersForCustomerNumberMockImpl());
        activeOrderNumberReturn = tempEP.getActiveOrdersForCustomerNumber(auth, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.getFidsByLineIdAndFidIdMockImpl());
        lineFidDetailReturn = tempEP.getFidsByLineIdAndFidId(auth, 1, 1, false);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.addOptionalSubItemMockImpl());
        inventoryReturn = tempEP.addOptionalSubItem(auth, i63);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.getEntityBtnMockImpl());
        btnReturn = tempEP.getEntityBtn(auth, 1, false);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.startOrderWithProspectIdMockImpl());
        inventoryReturn = tempEP.startOrderWithProspectId(auth, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.add800MockImpl());
        inventoryReturn = tempEP.add800(auth, i19);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.getNpaNxxForStatusMockImpl());
        npaNxxReturn = tempEP.getNpaNxxForStatus(auth, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.reserveNumbersMockImpl());
        inventoryReturn = tempEP.reserveNumbers(auth, 1, 'Test', 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.maintainServicesOnProspectOrderMockImpl());
        inventoryReturn = tempEP.maintainServicesOnProspectOrder(auth, i226);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.updateAniMockImpl());
        inventoryReturn = tempEP.updateAni(auth, i30);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.addAniMockImpl());
        inventoryReturn = tempEP.addAni(auth, i47);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.startOrderWithCustomerNumberMockImpl());
        inventoryReturn = tempEP.startOrderWithCustomerNumber(auth, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.getLinesByTypeAndFidValuesMockImpl());
        CCDS_Inventory.LinesReturn linesReturn = tempEP.getLinesByTypeAndFidValues(auth, i17);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.getEntityAnisByCustomerNumberAndStatusMockImpl());
        aniReturn = tempEP.getEntityAnisByCustomerNumberAndStatus(auth, 1, 'Test', 'Test', 1, false, false, false, false, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.getMarketsByNpaNxxMockImpl());
        marketReturn = tempEP.getMarketsByNpaNxx(auth, 'Test', 'Test');
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.updateMultipleLineAddressesMockImpl());
        inventoryReturn = tempEP.updateMultipleLineAddresses(auth, i227);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.getEntityAniByLineNumberMockImpl());
        aniWithBtnReturn = tempEP.getEntityAniByLineNumber(auth, 'Test', false);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.terminateBtnMockImpl());
        inventoryReturn = tempEP.terminateBtn(auth, i20);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.addVoipWithBtnMockImpl());
        addLineWithBtnReturn = tempEP.addVoipWithBtn(auth, i33);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.getLinesByLineNumberMockImpl());
        linesReturn = tempEP.getLinesByLineNumber(auth, 'Test', false, false, false, false);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.moveBtnMockImpl());
        inventoryReturn = tempEP.moveBtn(auth, i31);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForInventoryCallouts.updateLineAddressMockImpl());
        inventoryReturn = tempEP.updateLineAddress(auth, i61);
        
        Test.stopTest();
    }
}