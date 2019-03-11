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
private class CCDS_CustomerHelper_Test {
    //The typical test Class statics....
    private static final Id Direct_Customer_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Customer').getRecordTypeId();
    
    @testSetup static void setupTestData(){//Runs before any test methods...
        // Need Account, Asset, Case, Contact(s), ContactRoles, Address, Countries
        // Countries first...
        Test.startTest();
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
        
        pw_ccpro__CountryObject__c co = SetUpCountry_Test();    //returns Canada
        
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
        
        Test.StopTest();
    }
    
    @testSetup static void GenerateCustomSettings_Test()
    {   //Since we are setting up the customSettings using an @testSetup annotation, they will be available
        //for all of the methods in this Class
        Test.StartTest();
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
        
        Test.StopTest();
    }
    
    static testMethod void testSetupData(){
        //This testMethod is used to verify that the setupTestData method executed correctly
        //Test Countries.....
        Test.startTest();
        pw_ccpro__CountryObject__c co = SetUpCountry_Test();    //Use existing method
        system.assertEquals('Canada', co.Name);
        system.assertEquals('CA', co.pw_ccpro__IsoCode_2__c);
        system.assertEquals('CAN', co.pw_ccpro__IsoCode_3__c);
        Account a = SetUpAccountData_Test();                    //Use existing method
        system.assertEquals('Anew Customer Test',a.Name.Left(18));
        //This method could be extended to sample ALL of the @testSetup data.
        Test.stopTest();
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
                WHERE Name LIKE 'Anew Customer Test%' LIMIT 1]; //Relies on the Account Name setup in the @testSetup method
        system.debug(readAcct.Name);
        return readAcct;
    } 
    
    //Method (not a testMethod) to return a pw_ccpro__CountryObject__c, Specifically Canada
    static pw_ccpro__CountryObject__c SetUpCountry_Test(){
        pw_ccpro__CountryObject__c returnCo = new pw_ccpro__CountryObject__c ();
        returnCo = [SELECT Id, Name, pw_ccpro__IsoCode_2__c, pw_ccpro__IsoCode_3__c
                    FROM pw_ccpro__CountryObject__c
                    WHERE Name = 'Canada' LIMIT 1];
        return returnCo;
    }
    
    //Method (not a testMethod) to generate and return a random string, 40 char in length
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
    
    static testMethod void AddAccount_Test()
    {       
        Test.startTest();
        Account a = SetUpAccountData_Test();  

        a.Custom_Call_Acct_ID__c = '-99';
        a.CC_Prospect_Acct_ID__c = -9999;
        update a;
        System.assert(CCDS_CustomerHelper.AddAccount(a.Id, 'Customer') == true); 
                
        System.assert(CCDS_CustomerHelper.AddAccount(a.Id, 'Corporate') == true);  
        Test.stopTest();
    } 
   
    static testMethod void UpdateAccount_Test()
    {              
        Test.startTest();
        Account a = SetUpAccountData_Test();        
        
        System.assert(CCDS_CustomerHelper.UpdateAccount(a.Id, 'Customer') == true); 

        a.Bill_to__c = 'Corporate';
        a.Mail_to__c = 'Corporate';
        System.assert(CCDS_CustomerHelper.UpdateAccount(a.Id, 'Corporate') == true); 
        
        a.Custom_Call_Acct_ID__c = null;
        update a;
        System.assert(CCDS_CustomerHelper.UpdateAccount(a.Id, 'Customer') == false); 
        Test.stopTest();
    }
    
    static testMethod void AddContact_Test()
    {   
        Test.startTest();    
        Account a = SetUpAccountData_Test();
        
        System.assert(CCDS_CustomerHelper.AddContact(a.Id, 'Customer') == true); 
        
        System.assert(CCDS_CustomerHelper.AddContact(a.Id, 'Corporate') == true);

        Contact c3 = new Contact();
        c3.AccountId = a.Id;
        c3.Title = 'CustomerTitle';
        c3.Email='abc@abc.com';
        c3.Phone = '6085551212';
        c3.Fax = '9725551212';
        c3.MobilePhone = '5039991212';
        c3.FirstName = 'Third';
        c3.LastName = 'Contact';
        c3.Birthdate = Date.newInstance(2014, 12, 2);
        c3.Department = 'testing';
        insert c3;
        System.assert(c3 != null);
        
        AccountContactRole cr3 = new AccountContactRole();
        cr3.AccountId = a.Id;
        cr3.ContactId = c3.Id;
        cr3.Role = 'Airtime Services Authorized Rep';
        insert cr3;
        System.assert(cr3 != null); 
        
        System.assert(CCDS_CustomerHelper.AddContact(a.Id, 'Corporate') == false);
        
        a.Custom_Call_Acct_ID__c = null;
        update a;
        System.assert(CCDS_CustomerHelper.AddContact(a.Id, 'Customer') == false);
        Test.stopTest();
    }

    static testMethod void CreateMiscInfo_Test()
    {
        Test.startTest();
        Account a = SetUpAccountData_Test();
        
        System.assert(CCDS_CustomerHelper.CreateMiscInfo(a, true, 123) != null);
        Test.stopTest();
    }
    
    static testMethod void AddMiscInformation_Test()
    {
        Test.startTest();
        Account a = SetUpAccountData_Test();
        
        System.assert(CCDS_CustomerHelper.AddMiscInformation(true, 123,10, 27, 'test') != null);
        Test.stopTest();
    }
    
    static testMethod void ProcessEntityByAccount_Test()
    {
        Test.startTest();
        Account a = SetUpAccountData_Test();
        
        System.assert(CCDS_CustomerHelper.ProcessEntityByAccount(a) != null);   
        Test.stopTest();    
    }
    
    static testMethod void ProcessCustomerReturnResult_Test()
    {
        Test.startTest();
        Account a = SetUpAccountData_Test();
        a.CC_Prospect_Acct_ID__c = null;
        update a;
        
        CCDS_Customer.CustomerReturn cr = new CCDS_Customer.CustomerReturn();
        cr.id = '190283';
        cr.successful = true;
        
        System.assert(CCDS_CustomerHelper.ProcessCustomerReturnResult(cr, a) == true);
        
        a.Custom_Call_Acct_ID__c = null;
        a.CC_Prospect_Acct_ID__c = 98227;
        update a;        
        System.assert(CCDS_CustomerHelper.ProcessCustomerReturnResult(cr, a) == false);
        
        a.Custom_Call_Acct_ID__c = String.valueOf(Math.round(Math.random() * 123456));
        update a;
        System.assert(CCDS_CustomerHelper.ProcessCustomerReturnResult(cr, a) == true);   
        
        cr = new CCDS_Customer.CustomerReturn();
        cr.id = '4567';
        cr.successful = false;
        cr.messages = new String[] {'testing, testing Will Robinson'};
        
        a.CC_Prospect_Acct_ID__c = null;
        update a;
        
        System.assert(CCDS_CustomerHelper.ProcessCustomerReturnResult(cr, a) == false);
        
        a.CC_Prospect_Acct_ID__c = 72298;
        update a;
        
        System.assert(CCDS_CustomerHelper.ProcessCustomerReturnResult(cr, a) == false);
        Test.stopTest();
    }
    
    static testMethod void CreateCustomerReturnResultForExistingProspect_Test()
    {
        Test.startTest();
        Account a = SetUpAccountData_Test();
        
        System.assert(CCDS_CustomerHelper.CreateCustomerReturnResultForExistingProspect(a) != null);
        Test.stopTest();
    }
   
    static testMethod void IsCustomer_Test()
    {
        Test.startTest();
        Account a = SetUpAccountData_Test();
        a.Custom_Call_Acct_ID__c = null;      
        
        System.assert(CCDS_CustomerHelper.IsCustomer(a) == false);
        
        a.Custom_Call_Acct_ID__c = String.valueOf(Math.round(Math.random() * 123456));      
        System.assert(CCDS_CustomerHelper.IsCustomer(a) == true);
        Test.stopTest();
    }
    
    static testMethod void GetEntityID_Test()
    {
        Test.startTest();
        Account a = SetUpAccountData_Test();
        a.Custom_Call_Acct_ID__c = '19996';
        update a;
        
        System.assert(CCDS_CustomerHelper.GetEntityID(a) == 19996);
        Test.stopTest();
    }   
       
    static testMethod void MockEntityProxy_Test()
    {
        CCDS_Customer.CustomerAddress c1 = new CCDS_Customer.CustomerAddress();
        CCDS_Customer.CustomerTermination c2 = new CCDS_Customer.CustomerTermination();
        CCDS_Customer.MiscInfoReturn c3 = new CCDS_Customer.MiscInfoReturn();
        CCDS_Customer.CustomerSearchReturn c4 = new CCDS_Customer.CustomerSearchReturn();
        CCDS_Customer.CustomerEntity c5 = new CCDS_Customer.CustomerEntity();
        CCDS_Customer.PaymentsReturn c6 = new CCDS_Customer.PaymentsReturn();
        CCDS_Customer.CustomerReturn c7 = new CCDS_Customer.CustomerReturn();
        CCDS_Customer.Notepad c8 = new CCDS_Customer.Notepad();
        CCDS_Customer.AccountsReceivableReturn c9 = new CCDS_Customer.AccountsReceivableReturn();
        CCDS_Customer.CustomerInvoiceFileReturn c10 = new CCDS_Customer.CustomerInvoiceFileReturn();
        CCDS_Customer.PaymentHistoryItem c11 = new CCDS_Customer.PaymentHistoryItem();
        CCDS_Customer.AccountsReceivable c12 = new CCDS_Customer.AccountsReceivable();
        CCDS_Customer.MiscInformation c13 = new CCDS_Customer.MiscInformation();
        CCDS_Customer.CustomerSearchItem c14 = new CCDS_Customer.CustomerSearchItem();
        CCDS_Customer.MiscInformationDisplay c15 = new CCDS_Customer.MiscInformationDisplay();
        CCDS_Customer.addProspect_element c16 = new CCDS_Customer.addProspect_element();
        CCDS_Customer.terminateCustomer_element c17 = new CCDS_Customer.terminateCustomer_element();
        CCDS_Customer.getMiscInfoByProspectIdOrCustomerNumber_element c18 = new CCDS_Customer.getMiscInfoByProspectIdOrCustomerNumber_element();
        CCDS_Customer.getPaymentsResponse_element c19 = new CCDS_Customer.getPaymentsResponse_element();
        CCDS_Customer.addPaymentResponse_element c20 = new CCDS_Customer.addPaymentResponse_element();
        CCDS_Customer.addDocument_element c21 = new CCDS_Customer.addDocument_element();
        CCDS_Customer.updateProspectResponse_element c22 = new CCDS_Customer.updateProspectResponse_element();
        CCDS_Customer.addDocumentResponse_element c23 = new CCDS_Customer.addDocumentResponse_element();
        CCDS_Customer.updateCustomer_element c24 = new CCDS_Customer.updateCustomer_element();
        CCDS_Customer.customerSearch_element c25 = new CCDS_Customer.customerSearch_element();
        CCDS_Customer.getInvoiceFile_element c26 = new CCDS_Customer.getInvoiceFile_element();
        CCDS_Customer.getMiscInfoByCategoryNameSubCategoryName_element c27 = new CCDS_Customer.getMiscInfoByCategoryNameSubCategoryName_element();
        CCDS_Customer.addNoteResponse_element c28 = new CCDS_Customer.addNoteResponse_element();
        CCDS_Customer.updateCustomerResponse_element c29 = new CCDS_Customer.updateCustomerResponse_element();
        CCDS_Customer.addProspectResponse_element c30 = new CCDS_Customer.addProspectResponse_element();
        CCDS_Customer.getAvailableMiscInfoFieldsByProspectIdResponse_element c31 = new CCDS_Customer.getAvailableMiscInfoFieldsByProspectIdResponse_element();
        CCDS_Customer.getMiscInfoByCategoryIdSubCategoryId_element c32 = new CCDS_Customer.getMiscInfoByCategoryIdSubCategoryId_element();
        CCDS_Customer.getInvoiceFileResponse_element c33 = new CCDS_Customer.getInvoiceFileResponse_element();
        CCDS_Customer.addMiscInfoResponse_element c34 = new CCDS_Customer.addMiscInfoResponse_element();
        CCDS_Customer.getPayments_element c35 = new CCDS_Customer.getPayments_element();
        CCDS_Customer.addPayment_element c36 = new CCDS_Customer.addPayment_element();
        CCDS_Customer.getAvailableMiscInfoFieldsByProspectId_element c37 = new CCDS_Customer.getAvailableMiscInfoFieldsByProspectId_element();
        CCDS_Customer.terminateCustomerResponse_element c38 = new CCDS_Customer.terminateCustomerResponse_element();
        CCDS_Customer.addMiscInfo_element c39 = new CCDS_Customer.addMiscInfo_element();
        CCDS_Customer.getMiscInfoByCategoryIdSubCategoryIdResponse_element c40 = new CCDS_Customer.getMiscInfoByCategoryIdSubCategoryIdResponse_element();
        CCDS_Customer.getMiscInfoByCategoryNameSubCategoryNameResponse_element c41 = new CCDS_Customer.getMiscInfoByCategoryNameSubCategoryNameResponse_element();
        CCDS_Customer.updateProspect_element c42 = new CCDS_Customer.updateProspect_element();
        CCDS_Customer.getAccountsReceivable_element c43 = new CCDS_Customer.getAccountsReceivable_element();
        CCDS_Customer.getAccountsReceivableResponse_element c44 = new CCDS_Customer.getAccountsReceivableResponse_element();
        CCDS_Customer.addNote_element c45 = new CCDS_Customer.addNote_element();
        CCDS_Customer.getMiscInfoByProspectIdOrCustomerNumberResponse_element c46 = new CCDS_Customer.getMiscInfoByProspectIdOrCustomerNumberResponse_element();
        CCDS_Customer.customerSearchResponse_element c47 = new CCDS_Customer.customerSearchResponse_element();
        CCDS_Customer.CcdsMiscInformationValidation c48 = new CCDS_Customer.CcdsMiscInformationValidation();
        CCDS_Customer.EntityContact c49 = new CCDS_Customer.EntityContact();
        CCDS_Customer.ContactType c50 = new CCDS_Customer.ContactType();
        CCDS_Customer.AbstractType c51 = new CCDS_Customer.AbstractType();
        CCDS_Customer.Authentication c52 = new CCDS_Customer.Authentication();
        CCDS_Customer.Map_x c53 = new CCDS_Customer.Map_x();
        CCDS_Customer.BaseFileReturn c54 = new CCDS_Customer.BaseFileReturn();
        CCDS_Customer.BaseReturnObject c55 = new CCDS_Customer.BaseReturnObject();
        CCDS_Customer.Payment c56 = new CCDS_Customer.Payment();
        CCDS_Customer.CustomerHttpSoap11Endpoint c57 = new CCDS_Customer.CustomerHttpSoap11Endpoint();   
        CCDS_Customer.CustomerBillOptionEntity c58 = new CCDS_Customer.CustomerBillOptionEntity();
            
        System.assert(c1 != null);
        System.assert(c2 != null);
        System.assert(c3 != null);
        System.assert(c4 != null);
        System.assert(c5 != null);
        System.assert(c6 != null);
        System.assert(c7 != null);
        System.assert(c8 != null);
        System.assert(c9 != null);
        System.assert(c10 != null);
        System.assert(c11 != null);
        System.assert(c12 != null);
        System.assert(c13 != null);
        System.assert(c14 != null);
        System.assert(c15 != null);
        System.assert(c16 != null);
        System.assert(c17 != null);
        System.assert(c18 != null);
        System.assert(c19 != null);
        System.assert(c20 != null);
        System.assert(c21 != null);
        System.assert(c22 != null);
        System.assert(c23 != null);
        System.assert(c24 != null);
        System.assert(c25 != null);
        System.assert(c26 != null);
        System.assert(c27 != null);
        System.assert(c28 != null);
        System.assert(c29 != null);
        System.assert(c30 != null);
        System.assert(c31 != null);
        System.assert(c32 != null);
        System.assert(c33 != null);
        System.assert(c34 != null);
        System.assert(c35 != null);
        System.assert(c36 != null);
        System.assert(c37 != null);
        System.assert(c38 != null);
        System.assert(c39 != null);
        System.assert(c40 != null);
        System.assert(c41 != null);
        System.assert(c42 != null);
        System.assert(c43 != null);
        System.assert(c44 != null);
        System.assert(c45 != null);
        System.assert(c46 != null);
        System.assert(c47 != null);
        System.assert(c48 != null);
        System.assert(c49 != null);
        System.assert(c50 != null);
        System.assert(c51 != null);
        System.assert(c52 != null);
        System.assert(c53 != null);
        System.assert(c54 != null);
        System.assert(c55 != null);
        System.assert(c56 != null);
        System.assert(c57 != null);
        System.assert(c58 != null);
        
        
        CCDS_Customer.CustomerHttpSoap11Endpoint tempEP = new CCDS_Customer.CustomerHttpSoap11Endpoint(1);
        CCDS_Customer.Authentication auth = new CCDS_Customer.Authentication('1','2','3','4','5');
        
        Test.startTest();
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForCustomerCallouts.getAvailableMiscInfoFieldsByProspectIdMockImpl());
        CCDS_Customer.MiscInfoReturn miscInfoReturn = tempEP.getAvailableMiscInfoFieldsByProspectId(auth, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForCustomerCallouts.getMiscInfoByCategoryNameSubCategoryNameMockImpl());
        miscInfoReturn = tempEP.getMiscInfoByCategoryNameSubCategoryName(auth, 1, 1, 'Test', 'Test');
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForCustomerCallouts.getInvoiceFileMockImpl());
        CCDS_Customer.CustomerInvoiceFileReturn custInvoiceFileReturn = tempEP.getInvoiceFile(auth, 1, Datetime.now());
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForCustomerCallouts.getAccountsReceivableMockImpl());
        CCDS_Customer.AccountsReceivableReturn arReturn = tempEP.getAccountsReceivable(auth, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForCustomerCallouts.addMiscInfoMockImpl());
        CCDS_Customer.CustomerReturn custReturn = tempEP.addMiscInfo(auth, c13);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForCustomerCallouts.updateCustomerBillOptionsMockImpl());
        CCDS_Customer.CustomerBillOptionReturn custBillOptionReturn = tempEP.updateCustomerBillOptions(auth, c58);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForCustomerCallouts.addDocumentMockImpl());
        custReturn = tempEP.addDocument(auth, 'Test', 1, 1, 'Test');
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForCustomerCallouts.getMiscInfoByCategoryIdSubCategoryIdMockImpl());
        miscInfoReturn = tempEP.getMiscInfoByCategoryIdSubCategoryId(auth, 1, 1, 1, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForCustomerCallouts.terminateCustomerMockImpl());
        custReturn = tempEP.terminateCustomer(auth, c2);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForCustomerCallouts.addNoteMockImpl());
        custReturn = tempEP.addNote(auth, c8);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForCustomerCallouts.getMiscInfoByProspectIdOrCustomerNumberMockImpl());
        miscInfoReturn = tempEP.getMiscInfoByProspectIdOrCustomerNumber(auth, 1, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForCustomerCallouts.addPaymentMockImpl());
        custReturn = tempEP.addPayment(auth, c56);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForCustomerCallouts.addProspectMockImpl());
        custReturn = tempEP.addProspect(auth, c5);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForCustomerCallouts.updateProspectMockImpl());
        custReturn = tempEP.updateProspect(auth, c5);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForCustomerCallouts.getPaymentsMockImpl());
        CCDS_Customer.PaymentsReturn paymentsReturn = tempEP.getPayments(auth, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForCustomerCallouts.customerSearchMockImpl());
        CCDS_Customer.CustomerSearchReturn customerSearchReturn = tempEP.customerSearch(auth, 'Test', 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestsForCustomerCallouts.updateCustomerMockImpl());
        custReturn = tempEP.updateCustomer(auth, c5);
        
        Test.stopTest();      
        
    }        
}