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
private class CCDS_EntityHelper_Test {
	//The typical test Class statics....
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
        a.name='Anew Customer Test' + String.valueOf(System.now());	
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
                       
        //setup another Contact Role
        AccountContactRole cr3 = new AccountContactRole();
        cr3.AccountId = a.Id;
        cr3.ContactId = c.Id;
        cr3.Role = 'Airtime Services Authorized Rep';
        insert cr3;
        System.assert(cr3 != null); 
        
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
        
        //setup another Contact Role
        AccountContactRole cr4 = new AccountContactRole();
        cr4.AccountId = a.Id;
        cr4.ContactId = c2.Id;
        cr4.Role = 'Airtime Services Authorized Rep';
        insert cr4;
        System.assert(cr4 != null); 
        
          
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
   
    static testMethod void GetCustomerEntityFromAccount_Test()
    {       
        Account a = SetUpAccountData_Test();
        
        System.assert(CCDS_EntityHelper.GetCustomerEntityFromAccount(a) != null); 
        
        a.Mail_to__c = 'Corporate';
        a.Bill_to__c = 'Corporate';
        a.Bill_To_Corporate__c = true;
        a.Mail_to_Corporate__c = true;
        System.assert(CCDS_EntityHelper.GetCustomerEntityFromAccount(a) != null);
    } 
    
    static testMethod void GetContacts_Test()
    {       
        Account a = SetUpAccountData_Test();
        
        System.assert(CCDS_EntityHelper.GetContacts(a) != null);                       
    } 
    
    static testMethod void GetAddresses_Test()
    {       
        Account a = SetUpAccountData_Test();
        a.Custom_Call_Acct_ID__c = String.valueOf(Math.round(Math.random() * 123456));
        
        System.assert(CCDS_EntityHelper.GetAddresses(a) != null);       
    } 
  
    static testMethod void GetEntityContact_Test()
    {       
        Account a = SetUpAccountData_Test();
        a.Custom_Call_Acct_ID__c = String.valueOf(Math.round(Math.random() * 123456));
        
        System.assert(CCDS_EntityHelper.GetEntityContact(a, 'Airtime Services Main Contact') != null);                       
    }
    
    static testMethod void GetAddress_Test()
    {       
        Account a = SetUpAccountData_Test();
        
        System.assert(CCDS_EntityHelper.GetAddress(a, 1) != null);    
        
        System.assert(CCDS_EntityHelper.GetAddress(a, 2) != null);      
    }
    
    static testMethod void SetExistingAddressIDByCustomerNumber_Test()
    {    
        Account a = SetUpAccountData_Test();
        
        CCDS_Customer.CustomerAddress address = new CCDS_Customer.CustomerAddress();
        
        address.addressTypeId = 1;
        
        CCDS_EntityHelper.SetExistingAddressIDByCustomerNumber(123, address);
        
        System.assert(address.addressId == 9999);        
    }
        
    static testMethod void AddCustomerContact_Test()
    {       
        Account a = SetUpAccountData_Test();
        
        //setup a Contact
        Contact c = new Contact();
        c.AccountId = a.Id;
        c.Title = 'CustomerBillingTitle';
        c.Email='abc@abcCanada.com';
        c.Phone = '6085551212';
        c.Fax = '9725551212';
        c.MobilePhone = '5035551212';
        c.FirstName = 'anotherNew';
        c.LastName = 'Contact';
        c.Birthdate = Date.newInstance(1914, 12, 2);
        c.Department = 'testing';
        insert c;
        System.assert(c != null);
        
        //setup a Contact Role
        AccountContactRole cr = new AccountContactRole();
        cr.AccountId = a.Id;
        cr.ContactId = c.Id;
        cr.Role = 'Airtime Services Billing Contact';
        insert cr;
        System.assert(cr != null); 
        
        System.assert(CCDS_EntityHelper.AddCustomerContact(a) != null);                       
    }
    
    static testMethod void UpdateCustomerContact_Test()
    {       
        Account a = SetUpAccountData_Test();
        
        //setup a Contact
        Contact c = new Contact();
        c.AccountId = a.Id;
        c.Title = 'CustomerBillingTitle';
        c.Email='abc@abcCanada.com';
        c.Phone = '6085551212';
        c.Fax = '9725551212';
        c.MobilePhone = '5035551212';
        c.FirstName = 'anotherNew';
        c.LastName = 'Contact';
        c.Birthdate = Date.newInstance(1914, 12, 2);
        c.Department = 'testing';
        insert c;
        System.assert(c != null);
        
        //setup a Contact Role
        AccountContactRole cr = new AccountContactRole();
        cr.AccountId = a.Id;
        cr.ContactId = c.Id;
        cr.Role = 'Airtime Services Billing Contact';
        insert cr;
        System.assert(cr != null); 
        
        System.assert(CCDS_EntityHelper.UpdateCustomerContact(a) != null);                       
    }
   
    static testMethod void GetCCDSContacts_Test()
    {    
        System.assert(CCDS_EntityHelper.GetCCDSContacts('ab10xyZ') != null);      
    }
  
    static testMethod void DeleteEntityContacts_Test()
    {    
        System.assert(CCDS_EntityHelper.DeleteEntityContacts(CCDS_EntityHelper.GetCCDSContacts('ab10xyZ')) != null);      
    }
    
    static testMethod void GetAddressByType_Test()
    {
        Account a = SetUpAccountData_Test();
        
        System.assert(CCDS_EntityHelper.GetAddressByType(a.Id, 'Airtime Services Billing') != null);
    }
    
    static testMethod void testSetupData(){
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
    
    //Method (not a testMethod) to return a Account, Specifically our test Account
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
    
    static pw_ccpro__CountryObject__c SetUpCountry_Test()
    {
        pw_ccpro__CountryObject__c returnCo = new pw_ccpro__CountryObject__c ();
    	returnCo = [SELECT Id, Name, pw_ccpro__IsoCode_2__c, pw_ccpro__IsoCode_3__c
    	            FROM pw_ccpro__CountryObject__c
    	            WHERE Name = 'Canada' LIMIT 1];
    	return returnCo;
    }
    
    @testSetup static void GenerateCustomSettings_Test()
    {
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
        setting.Value__c = '31'; // 31 for ccds 9 for servcloud
        customSettings.add(setting);
        
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_MiscInfo_SubCat_VesselName';
        setting.Value__c = '27'; // 27 for ccds 10 for servcloud
        customSettings.add(setting);
        
        setting = new Global_Variable__c();                      
        setting.name = 'Webtop_OrderSource';
        setting.Value__c = 'WEB';
        customSettings.add(setting);

		setting = new Global_Variable__c();                      
        setting.name = 'Webtop_Order_FidId';
        setting.Value__c = '175'; 
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
        
        List<CCDS_Billing_Cycle__c> billingCycles = new List<CCDS_Billing_Cycle__c>();
        
        CCDS_Billing_Cycle__c bc = new CCDS_Billing_Cycle__c();
        bc.Name = 'Active';
        bc.Label__c = 'Active';
        bc.Value__c = 'A';
        billingCycles.add(bc);
        
        bc = new CCDS_Billing_Cycle__c();
        bc.Name = 'Excluded';
        bc.Label__c = 'Excluded';
        bc.Value__c = 'E';
        billingCycles.add(bc);
        
        bc = new CCDS_Billing_Cycle__c();
        bc.Name = 'New Customers';
        bc.Label__c = 'New Customers';
        bc.Value__c = 'N';
        billingCycles.add(bc);
        
        bc = new CCDS_Billing_Cycle__c();
        bc.Name = 'Pending';
        bc.Label__c = 'Pending';
        bc.Value__c = 'P';
        billingCycles.add(bc);
        
        bc = new CCDS_Billing_Cycle__c();
        bc.Name = 'Suspended Customers';
        bc.Label__c = 'Suspended Customers';
        bc.Value__c = 'S';
        billingCycles.add(bc);
        
        bc = new CCDS_Billing_Cycle__c();
        bc.Name = 'Terminated Customers';
        bc.Label__c = 'Terminated Customers';
        bc.Value__c = 'T';
        billingCycles.add(bc);
        
        bc = new CCDS_Billing_Cycle__c();
        bc.Name = 'Write Off';
        bc.Label__c = 'Write Off';
        bc.Value__c = 'W';
        billingCycles.add(bc);
        
        insert billingCycles;
        System.assert(billingCycles != null);
        
        List<CCDS_Bill_Type__c> billingTypes = new List<CCDS_Bill_Type__c>();
        
        CCDS_Bill_Type__c bt = new CCDS_Bill_Type__c();
        bt.Name = 'Both email with pdf & mail';
        bt.Label__c = 'Both email with pdf & mail';
        bt.Value__c = 'Z';
        billingTypes.add(bt);
        
        bt = new CCDS_Bill_Type__c();
        bt.Name = 'Email (without pdf)';
        bt.Label__c = 'Email (without pdf)';
        bt.Value__c = 'W';
        billingTypes.add(bt);
        
        bt = new CCDS_Bill_Type__c();
        bt.Name = 'Email with pdf';
        bt.Label__c = 'Email with pdf';
        bt.Value__c = 'P';
        billingTypes.add(bt);
        
        bt = new CCDS_Bill_Type__c();
        bt.Name = 'Mail';
        bt.Label__c = 'Mail';
        bt.Value__c = 'M';
        billingTypes.add(bt);
        
        bt = new CCDS_Bill_Type__c();
        bt.Name = 'See Corporate';
        bt.Label__c = 'See Corporate';
        bt.Value__c = 'C';
        billingTypes.add(bt);
        
        bt = new CCDS_Bill_Type__c();
        bt.Name = 'Special Handling';
        bt.Label__c = 'Special Handling';
        bt.Value__c = 'S';
        billingTypes.add(bt);
                        
        insert billingTypes;
        System.assert(billingTypes != null);
        
        List<CCDS_Sales_Office__c> salesOffices = new List<CCDS_Sales_Office__c>();
        
        CCDS_Sales_Office__c so = new CCDS_Sales_Office__c();  
        so.Name = 'COMMBOX';
        so.Label__c = 'COMMBOX';
        so.Value__c = 29;
        salesOffices.add(so);
        
        so = new CCDS_Sales_Office__c();  
        so.Name = 'FBB';
        so.Label__c = 'FBB';
        so.Value__c = 27;
        salesOffices.add(so);
        
        so = new CCDS_Sales_Office__c();  
        so.Name = 'FLEET';
        so.Label__c = 'FLEET';
        so.Value__c = 26;
        salesOffices.add(so);
        
        so = new CCDS_Sales_Office__c();  
        so.Name = 'MINIM';
        so.Label__c = 'MINIM';
        so.Value__c = 25;
        salesOffices.add(so);
        
        so = new CCDS_Sales_Office__c();  
        so.Name = 'VSAT';
        so.Label__c = 'VSAT';
        so.Value__c = 28;
        salesOffices.add(so);
        
        insert salesOffices;
        System.assert(salesOffices != null);
         
        List<CCDS_Sales_Region__c> salesRegions = new List<CCDS_Sales_Region__c>();
                            
        CCDS_Sales_Region__c sr = new CCDS_Sales_Region__c();
        sr.Name = 'KB Satcom';
        sr.Label__c = 'KB Satcom';
        sr.Value__c = 7;
        salesRegions.add(sr);
        
        sr = new CCDS_Sales_Region__c();
        sr.Name = 'KE Satcom';
        sr.Label__c = 'KE Satcom';
        sr.Value__c = 2;
        salesRegions.add(sr);
        
        sr = new CCDS_Sales_Region__c();
        sr.Name = 'KJ Satcom';
        sr.Label__c = 'KJ Satcom';
        sr.Value__c = 9;
        salesRegions.add(sr);
        
        sr = new CCDS_Sales_Region__c();
        sr.Name = 'KS Satcom';
        sr.Label__c = 'KS Satcom';
        sr.Value__c = 3;
        salesRegions.add(sr);
        
        sr = new CCDS_Sales_Region__c();
        sr.Name = 'KU Mil/Gov/Commercial';
        sr.Label__c = 'KU Mil/Gov/Commercial';
        sr.Value__c = 8;
        salesRegions.add(sr);
        
        sr = new CCDS_Sales_Region__c();
        sr.Name = 'KU Satcom';
        sr.Label__c = 'KU Satcom';
        sr.Value__c = 1;
        salesRegions.add(sr);
        
        insert salesRegions;
        System.assert(salesRegions != null);
        
        List<CCDS_Sales_Rep__c> salesReps = new List<CCDS_Sales_Rep__c>();
         
        CCDS_Sales_Rep__c rep = new CCDS_Sales_Rep__c();
        rep.Name = 'BRAZIL';
        rep.Label__c = 'BRAZIL';
        rep.Value__c = 9;
        salesReps.add(rep);
         
        rep = new CCDS_Sales_Rep__c();
        rep.Name = 'COMMBOX';
        rep.Label__c = 'COMMBOX';
        rep.Value__c = 10;
        salesReps.add(rep);
         
        rep = new CCDS_Sales_Rep__c();
        rep.Name = 'CONUS';
        rep.Label__c = 'CONUS';
        rep.Value__c = 2;
        salesReps.add(rep);
         
        rep = new CCDS_Sales_Rep__c();
        rep.Name = 'EMEA';
        rep.Label__c = 'EMEA';
        rep.Value__c = 5;
        salesReps.add(rep);
         
        rep = new CCDS_Sales_Rep__c();
        rep.Name = 'INMAR';
        rep.Label__c = 'INMAR';
        rep.Value__c = 1;
        salesReps.add(rep);
         
        rep = new CCDS_Sales_Rep__c();
        rep.Name = 'JSAT';
        rep.Label__c = 'JSAT';
        rep.Value__c = 7;
        salesReps.add(rep);
         
        rep = new CCDS_Sales_Rep__c();
        rep.Name = 'MIAMI';
        rep.Label__c = 'MIAMI';
        rep.Value__c = 3;
        salesReps.add(rep);
         
        rep = new CCDS_Sales_Rep__c();
        rep.Name = 'NAOR';
        rep.Label__c = 'NAOR';
        rep.Value__c = 8;
        salesReps.add(rep);
         
        rep = new CCDS_Sales_Rep__c();
        rep.Name = 'NP';
        rep.Label__c = 'NP';
        rep.Value__c = 4;
        salesReps.add(rep);
         
        rep = new CCDS_Sales_Rep__c();
        rep.Name = 'PERTH';
        rep.Label__c = 'PERTH';
        rep.Value__c = 6;
        salesReps.add(rep);
        
        insert salesReps;
        System.assert(salesReps != null);
      
        //Need to create a Security__c sObject so that tests will pass....
        Security__c testSecure = new Security__c();
        testSecure.Name = 'CCDS';
        testSecure.Key__c = 'test_password';
        insert testSecure;
    }
    
    static String GenerateRandomString_Test()
    {
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
    
    static testMethod void MockEntityProxy_Test()
    {
        CCDS_Entity.getAddressesResponse_element e1 = new CCDS_Entity.getAddressesResponse_element();
        CCDS_Entity.getEntityContactTypesResponse_element e2 = new CCDS_Entity.getEntityContactTypesResponse_element();
        CCDS_Entity.getContactsByCustomerNumber_element e3 = new CCDS_Entity.getContactsByCustomerNumber_element();
        CCDS_Entity.searchLimitedByZipCode_element e4 = new CCDS_Entity.searchLimitedByZipCode_element();
        CCDS_Entity.searchLimitedByZipCodeResponse_element e5 = new CCDS_Entity.searchLimitedByZipCodeResponse_element();
        CCDS_Entity.deleteEntityContacts_element e6 = new CCDS_Entity.deleteEntityContacts_element();
        CCDS_Entity.getContactsByExternalId_element e7 = new CCDS_Entity.getContactsByExternalId_element();
        CCDS_Entity.getContactsByCustomerNumberResponse_element e8 = new CCDS_Entity.getContactsByCustomerNumberResponse_element();
        CCDS_Entity.getAddressesByCustomerNumber_element e9 = new CCDS_Entity.getAddressesByCustomerNumber_element(); 
        CCDS_Entity.getAddressesByCustomerNumberResponse_element e10 = new CCDS_Entity.getAddressesByCustomerNumberResponse_element();
        CCDS_Entity.getAddresses_element e11 = new CCDS_Entity.getAddresses_element();
        CCDS_Entity.getByProspectId_element e12 = new CCDS_Entity.getByProspectId_element();
        CCDS_Entity.deleteEntityContactsResponse_element e13 = new CCDS_Entity.deleteEntityContactsResponse_element();
        CCDS_Entity.getContactsByExternalIdResponse_element e14 = new CCDS_Entity.getContactsByExternalIdResponse_element();
        CCDS_Entity.getByExternalIdResponse_element e15 = new CCDS_Entity.getByExternalIdResponse_element();
        CCDS_Entity.updateEntityContactsResponse_element e16 = new CCDS_Entity.updateEntityContactsResponse_element();
        CCDS_Entity.getEntityContactTypes_element e17 = new CCDS_Entity.getEntityContactTypes_element();
        CCDS_Entity.search_element e18 = new CCDS_Entity.search_element();
        CCDS_Entity.getByProspectIdResponse_element e19 = new CCDS_Entity.getByProspectIdResponse_element();
        CCDS_Entity.searchResponse_element e20 = new CCDS_Entity.searchResponse_element();
        CCDS_Entity.addEntityContactsResponse_element e21 = new CCDS_Entity.addEntityContactsResponse_element();
        CCDS_Entity.updateEntityContacts_element e22 = new CCDS_Entity.updateEntityContacts_element();
        CCDS_Entity.getByCustomerNumberResponse_element e23 = new CCDS_Entity.getByCustomerNumberResponse_element();
        CCDS_Entity.getByExternalId_element e24 = new CCDS_Entity.getByExternalId_element();
        CCDS_Entity.getByCustomerNumber_element e25 = new CCDS_Entity.getByCustomerNumber_element();
        CCDS_Entity.addEntityContacts_element e26 = new CCDS_Entity.addEntityContacts_element();
        CCDS_Entity.AddressType e27 = new CCDS_Entity.AddressType();
        CCDS_Entity.ContactType e28 = new CCDS_Entity.ContactType();
        CCDS_Entity.EntityContactReturn e29 = new CCDS_Entity.EntityContactReturn();
        CCDS_Entity.AddressContainer e30 = new CCDS_Entity.AddressContainer();
        CCDS_Entity.EntityContact e31 = new CCDS_Entity.EntityContact();
        CCDS_Entity.EntityReturn e32 = new CCDS_Entity.EntityReturn();
        CCDS_Entity.Address e33 = new CCDS_Entity.Address();
        CCDS_Entity.EntityContactTypeReturn e34 = new CCDS_Entity.EntityContactTypeReturn();
        CCDS_Entity.EntityContacts e35 = new CCDS_Entity.EntityContacts();
        CCDS_Entity.EntityAddressReturn e36 = new CCDS_Entity.EntityAddressReturn();
        CCDS_Entity.Entity e37 = new CCDS_Entity.Entity();
        CCDS_Entity.AbstractType e38 = new CCDS_Entity.AbstractType();
        CCDS_Entity.Authentication e39 = new CCDS_Entity.Authentication();
        CCDS_Entity.BaseReturnObject e40 = new CCDS_Entity.BaseReturnObject();
        CCDS_Entity.EntityHttpSoap11Endpoint e41 = new CCDS_Entity.EntityHttpSoap11Endpoint();      
   
        System.assert(e1 != null);
        System.assert(e2 != null);
        System.assert(e3 != null);
        System.assert(e4 != null);
        System.assert(e5 != null);
        System.assert(e6 != null);
        System.assert(e7 != null);
        System.assert(e8 != null);
        System.assert(e9 != null);
        System.assert(e10 != null);
        System.assert(e11 != null);
        System.assert(e12 != null);
        System.assert(e13 != null);
        System.assert(e14 != null);
        System.assert(e15 != null);
        System.assert(e16 != null);
        System.assert(e17 != null);
        System.assert(e18 != null);
        System.assert(e19 != null);
        System.assert(e20 != null);
        System.assert(e21 != null);
        System.assert(e22 != null);
        System.assert(e23 != null);
        System.assert(e24 != null);
        System.assert(e25 != null);
        System.assert(e26 != null);
        System.assert(e27 != null);
        System.assert(e28 != null);
        System.assert(e29 != null);
        System.assert(e30 != null);
        System.assert(e31 != null);
        System.assert(e32 != null);
        System.assert(e33 != null);
        System.assert(e34 != null);
        System.assert(e35 != null);
        System.assert(e36 != null);
        System.assert(e37 != null);
        System.assert(e38 != null);
        System.assert(e39 != null);
        System.assert(e40 != null);
        System.assert(e41 != null);
        
        CCDS_Entity.EntityHttpSoap11Endpoint tempEntityEP = new CCDS_Entity.EntityHttpSoap11Endpoint(1);
        CCDS_Entity.Authentication auth = new CCDS_Entity.Authentication('1','2','3','4','5');
        
        Test.startTest();
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForEntityCallouts.getByExternalIdMockImpl());
        CCDS_Entity.EntityReturn entityReturn = tempEntityEP.getByExternalId(auth, 'Test');
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForEntityCallouts.getByProspectIdMockImpl());
        entityReturn = tempEntityEP.getByProspectId(auth, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForEntityCallouts.getContactsByExternalIdMockImpl());
        CCDS_Entity.EntityContactReturn entityContactReturn = tempEntityEP.getContactsByExternalId(auth, 'Test');
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForEntityCallouts.getContactsByCustomerNumberMockImpl());
        entityContactReturn = tempEntityEP.getContactsByCustomerNumber(auth, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForEntityCallouts.getAddressesMockImpl());
        CCDS_Entity.EntityAddressReturn entityAddressReturn = tempEntityEP.getAddresses(auth, 'Test');
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForEntityCallouts.getAddressesByCustomerNumberMockImpl());
        entityAddressReturn = tempEntityEP.getAddressesByCustomerNumber(auth, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForEntityCallouts.search_xMockImpl());
        entityReturn = tempEntityEP.search_x(auth, 'Test');
        
        CCDS_Entity.EntityContacts contacts = new CCDS_Entity.EntityContacts();
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForEntityCallouts.deleteEntityContactsMockImpl());
        entityContactReturn = tempEntityEP.deleteEntityContacts(auth, contacts);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForEntityCallouts.getEntityContactTypesMockImpl());
        CCDS_Entity.EntityContactTypeReturn entityContcatTypeReturn = tempEntityEP.getEntityContactTypes(auth);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForEntityCallouts.getByCustomerNumberMockImpl());
        entityReturn = tempEntityEP.getByCustomerNumber(auth, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForEntityCallouts.updateEntityContactsMockImpl());
        entityContactReturn = tempEntityEP.updateEntityContacts(auth, contacts);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForEntityCallouts.addEntityContactsMockImpl());
        entityContactReturn = tempEntityEP.addEntityContacts(auth, contacts);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForEntityCallouts.searchLimitedByZipCodeMockImpl());
        entityReturn = tempEntityEP.searchLimitedByZipCode(auth, 'Test', 'ZIP');
        
        Test.stopTest();
    }
  
}