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
private class CCDS_CorporateHelper_Test {
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
        
        //Setup an Account...
        Account a = new Account();  
        a.RecordTypeId = Direct_Customer_RECORD_TYPE_ID;
        a.name='Anew Corp Test' + String.valueOf(System.now());
        a.Country_Code__c = 'US';
        a.BillingCountry = 'United States';
        a.Billing_Cycle_picklist__c = 'Active';
        a.BillingPostalCode = '12345';
        a.BillingStreet = '123 Corporate Street';
        a.Bill_to__c = 'Corporate';
        a.Mail_to__c = 'Corporate';
        a.Account_Type__c = 'Corporate';
        a.CC_Reseller_Account_ID__c = 1;
        a.Company_IMO__c = String.valueOf(Math.random() * 9998769).subString(0,7); // must be 7 digits
        a.Custom_Call_Acct_ID__c = String.valueOf(Math.round(Math.random() * 123456)); //6 digits
        a.Source__c = 'CorporateHelper_Test';
        a.KVH_Sales_Office__c = 'KU Satcom';
        a.Market__c = 'Leisure';  
        a.Market_Sector__c = 'Marine';
        a.Account_Status__c = 'Active';
        a.Account_Effective_Date__c = date.Today();
        a.Revenue_Category__c = 'VSAT';        
        insert a;
        System.assert(a != null);
        
        //Setup an Asset...
        Asset asset= new Asset();
        asset.Name = GenerateRandomString_Test();
        asset.AccountId = a.id;
        asset.Asset_ID__c = String.valueOf(Math.round(Math.random() * 123456789));
        insert asset;
        System.assert(asset != null);
        
        //Setup a Case...
        Case newCase = new Case();
        newCase.AssetId = asset.id;
        newCase.Platform_Asset_Account__c = a.id;
        insert newCase; 
        System.assert(newCase != null);
        
        //Setup a Contact...
        Contact c = new Contact();
        c.AccountId = a.Id;
        c.Title = 'CorpTitle';
        c.Email='abc@abcCanada.com';
        c.Phone = '6085551212';
        c.Fax = '9725551212';
        c.FirstName = 'FirstNew';
        c.LastName = 'Contact';
        c.Birthdate = Date.newInstance(2014, 12, 2);
        c.Department = 'testing';
        insert c;
        System.assert(c != null);
        
        //Setup a Contact Role...
        AccountContactRole cr = new AccountContactRole();
        cr.AccountId = a.Id;
        cr.ContactId = c.Id;
        cr.Role = 'Airtime Services Main Contact';
        insert cr;
        System.assert(cr != null); 
        
        //Setup another Contact...
        Contact c2 = new Contact();
        c2.AccountId = a.Id;
        c2.Title = 'CorpTitle';
        c2.Email='abc@abcCanada.com';
        c2.Phone = '6085551212';
        c2.Fax = '9725551212';
        c2.FirstName = 'SecondNew';
        c2.LastName = 'Contact';
        c2.Birthdate = Date.newInstance(2014, 12, 2);
        c2.Department = 'testing';
        insert c2;
        System.assert(c2 != null);
        
        //Setup another Contact Role...
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
        
		//Setup a couple of Addresses...
        Address__c addr = new Address__c();
        addr.Account__c = a.Id;
        addr.Billing_Account__c = objBillingAccountCorporate.id;
        addr.Address_Type__c = 'Airtime Services Billing';
        addr.Address_1__c = 'East Washington 31';
        addr.City__c = 'Calgary';
        addr.State__c = 'Alberta';
        addr.State_Province_ISO_Code__c = 'AB';
        addr.Country__c = 'Canada';
        addr.Postal_Zipcode__c = '00123';
        insert addr;
        System.assert(addr != null);
        
        pw_ccpro__CountryObject__c co = SetUpCountry_Test(); //returns Canada
               
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

    static testMethod void AddCorporateAccount_Test()
    {       
        Account a = SetUpAccountData_Test();    

        CCDS_Corporate.CorporateMessageReturn cmr = CCDS_CorporateHelper.AddCorporateAccount(a);               
        system.assert(cmr.successful == true);   
    }
    
    static testMethod void UpdateCorporateAccount_Test()
    {        
        Account a = SetUpAccountData_Test();
       
        CCDS_Corporate.CorporateMessageReturn cmr = CCDS_CorporateHelper.UpdateCorporateAccount(a);
        system.assert(cmr.successful == true);    
    }
    
    static testMethod void UpdateCorporateName_test()
    {
        Account a = SetUpAccountData_Test();
        
        CCDS_Corporate.CorporateMessageReturn cmr2 = CCDS_CorporateHelper.UpdateCorporateName(a);
        system.assert(cmr2.successful == true); 
    }
        
    static testMethod void UpdateSubAccountDefaultOptions_test()
    {   
        Account a = SetUpAccountData_Test();
        
        a.Mail_to__c = 'Corporate';
        a.Bill_to__c = 'Corporate';
        CCDS_Corporate.CorporateMessageReturn cmr = CCDS_CorporateHelper.UpdateSubAccountDefaultOptions(a);
        system.assert(cmr.successful == true); 
        
        a.Mail_to__c = 'Customer';
        a.Bill_to__c = 'Customer';
        CCDS_Corporate.CorporateMessageReturn cmr2 = CCDS_CorporateHelper.UpdateSubAccountDefaultOptions(a);
        system.assert(cmr2.successful == true);
        
        a.Mail_to__c = 'Both';
        CCDS_Corporate.CorporateMessageReturn cmr3 = CCDS_CorporateHelper.UpdateSubAccountDefaultOptions(a);
        system.assert(cmr3.successful == true);
    }
    
    static testMethod void UpdateCorporateBillingAddress_test()
    {  
        Account a = SetUpAccountData_Test();
        
        CCDS_Corporate.CorporateMessageReturn cmr = CCDS_CorporateHelper.UpdateCorporateAddress(a, 'Airtime Services Billing');
        system.assert(cmr.successful == true); 
    }
    
    static testMethod void UpdateCorporateSubscriberAddress_test()
    {   
        Account a = SetUpAccountData_Test();
        
        CCDS_Corporate.CorporateMessageReturn cmr = CCDS_CorporateHelper.UpdateCorporateAddress(a, 'Airtime Services Subscriber');
        system.assert(cmr.successful == true);         
    }
    
    static testMethod void SetCorporateValues_Test()
    {
        Account a = SetUpAccountData_Test();
        
         //setup a billing account
        Billing_Account__c objBillingAccountCorporate = New Billing_Account__c();
        objBillingAccountCorporate.Account__c = a.id;
        objBillingAccountCorporate.RecordTypeId = Schema.SObjectType.Billing_Account__c.getRecordTypeInfosByName().get('Customer CC Account').getRecordTypeId();
        objBillingAccountCorporate.Billing_Account_ID__c = '1001';
        insert objBillingAccountCorporate;
        System.assert(objBillingAccountCorporate != null); 
        
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
       
        a.Mail_to__c = 'Corporate';
        a.Bill_to__c = 'Corporate';
        CCDS_Corporate.Corporate corp = CCDS_CorporateHelper.SetCorporateValues(a);
        system.assert(corp != null);  
        
        a.Mail_to__c = 'Customer';
        a.Bill_to__c = 'Customer';
        CCDS_Corporate.Corporate corp2 = CCDS_CorporateHelper.SetCorporateValues(a);
        system.assert(corp2 != null);
        
        a.Mail_to__c = 'Both';
        CCDS_Corporate.Corporate corp3 = CCDS_CorporateHelper.SetCorporateValues(a);
        system.assert(corp3 != null);
    }
   
    static testMethod void AddCorporateContact_Test()
    {       
        Account a = SetUpAccountData_Test();
        
        CCDS_Corporate.CorporateMessageReturn cmr = CCDS_CorporateHelper.AddCorporateContact(a);
        System.assert(cmr.successful == true);    
    }
    
    static testMethod void testSetupData(){
    	//This testMethod is used to verify that the setupTestData method executed correctly
    	//Test Countries.....
    	pw_ccpro__CountryObject__c co = SetUpCountry_Test();	//Use existing method
    	system.assertEquals('Canada', co.Name);
    	system.assertEquals('CA', co.pw_ccpro__IsoCode_2__c);
    	system.assertEquals('CAN', co.pw_ccpro__IsoCode_3__c);
    	Account a = SetUpAccountData_Test();					//Use existing method
    	system.assertEquals('Anew Corp Test',a.Name.Left(14));
    	//This method could be extended to sample ALL of the @testSetup data.
    }
    
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
    			WHERE Name LIKE 'Anew Corp Test%' LIMIT 1];	//Relies on the Account Name setup in the @testSetup method
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
    	//Since we are setting up the customSettings using an @testSetup annotation, they will be available
    	//for all of the methods in this Class
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
        CCDS_Corporate.MiscInformation C1 = new CCDS_Corporate.MiscInformation(); 
        CCDS_Corporate.MiscInformationDisplay C2 = new CCDS_Corporate.MiscInformationDisplay(); 
        CCDS_Corporate.CcdsMiscInformationValidation  C3 = new CCDS_Corporate.CcdsMiscInformationValidation (); 
        CCDS_Corporate.SubAccountReturn C4 = new CCDS_Corporate.SubAccountReturn(); 
        CCDS_Corporate.CorporateAddressReturn C5 = new CCDS_Corporate.CorporateAddressReturn(); 
        CCDS_Corporate.Contact C6 = new CCDS_Corporate.Contact(); 
        CCDS_Corporate.Address C7 = new CCDS_Corporate.Address(); 
        CCDS_Corporate.CorporateReturn C8 = new CCDS_Corporate.CorporateReturn(); 
        CCDS_Corporate.ContactReturn C9 = new CCDS_Corporate.ContactReturn(); 
        CCDS_Corporate.SubAccount C10 = new CCDS_Corporate.SubAccount(); 
        CCDS_Corporate.CorporateMessageReturn C11 = new CCDS_Corporate.CorporateMessageReturn(); 
        CCDS_Corporate.CorporateInvoiceFileReturn C12 = new CCDS_Corporate.CorporateInvoiceFileReturn(); 
        CCDS_Corporate.getRepresentativeAccount_element C13 = new CCDS_Corporate.getRepresentativeAccount_element(); 
        CCDS_Corporate.add_element C14 = new CCDS_Corporate.add_element(); 
        CCDS_Corporate.getCorporationByExternalId_element C15 = new CCDS_Corporate.getCorporationByExternalId_element(); 
        CCDS_Corporate.updateBillingOptionsResponse_element C16 = new CCDS_Corporate.updateBillingOptionsResponse_element(); 
        CCDS_Corporate.getInvoiceFile_element C17 = new CCDS_Corporate.getInvoiceFile_element(); 
        CCDS_Corporate.getSubAccounts_element C18 = new CCDS_Corporate.getSubAccounts_element(); 
        CCDS_Corporate.getAddressResponse_element C19 = new CCDS_Corporate.getAddressResponse_element(); 
        CCDS_Corporate.getCorporationsResponse_element C20 = new CCDS_Corporate.getCorporationsResponse_element(); 
        CCDS_Corporate.updateCorporateNameResponse_element C21 = new CCDS_Corporate.updateCorporateNameResponse_element(); 
        CCDS_Corporate.updateSubAccountDefaultOptions_element C22 = new CCDS_Corporate.updateSubAccountDefaultOptions_element(); 
        CCDS_Corporate.getSubAccountsResponse_element C23 = new CCDS_Corporate.getSubAccountsResponse_element(); 
        CCDS_Corporate.getSubAccountsWithMiscInfoByExternalIdResponse_element C24 = new CCDS_Corporate.getSubAccountsWithMiscInfoByExternalIdResponse_element(); 
        CCDS_Corporate.getContactsResponse_element C25 = new CCDS_Corporate.getContactsResponse_element(); 
        CCDS_Corporate.updateSubAccountDefaultOptionsResponse_element C26 = new CCDS_Corporate.updateSubAccountDefaultOptionsResponse_element(); 
        CCDS_Corporate.updateContact_element C27 = new CCDS_Corporate.updateContact_element(); 
        CCDS_Corporate.getInvoiceFileResponse_element C28 = new CCDS_Corporate.getInvoiceFileResponse_element(); 
        CCDS_Corporate.updateCorporateExternalId_element C29 = new CCDS_Corporate.updateCorporateExternalId_element(); 
        CCDS_Corporate.getCorporationResponse_element C30 = new CCDS_Corporate.getCorporationResponse_element(); 
        CCDS_Corporate.getContacts_element C31 = new CCDS_Corporate.getContacts_element(); 
        CCDS_Corporate.getCorporation_element C32 = new CCDS_Corporate.getCorporation_element(); 
        CCDS_Corporate.updateCorporateId_element C33 = new CCDS_Corporate.updateCorporateId_element(); 
        CCDS_Corporate.getCorporationByExternalIdResponse_element C34 = new CCDS_Corporate.getCorporationByExternalIdResponse_element(); 
        CCDS_Corporate.addResponse_element C35 = new CCDS_Corporate.addResponse_element(); 
        CCDS_Corporate.getSubAccountsWithMiscInfoResponse_element C36 = new CCDS_Corporate.getSubAccountsWithMiscInfoResponse_element(); 
        CCDS_Corporate.updateBillingOptions_element C37 = new CCDS_Corporate.updateBillingOptions_element(); 
        CCDS_Corporate.getRepresentativeAccountResponse_element C38 = new CCDS_Corporate.getRepresentativeAccountResponse_element(); 
        CCDS_Corporate.updateAddressResponse_element C39 = new CCDS_Corporate.updateAddressResponse_element(); 
        CCDS_Corporate.getSubAccountsWithMiscInfo_element C40 = new CCDS_Corporate.getSubAccountsWithMiscInfo_element(); 
        CCDS_Corporate.getAddress_element C41 = new CCDS_Corporate.getAddress_element(); 
        CCDS_Corporate.updateAddress_element C42 = new CCDS_Corporate.updateAddress_element(); 
        CCDS_Corporate.updateCorporateIdResponse_element C43 = new CCDS_Corporate.updateCorporateIdResponse_element(); 
        CCDS_Corporate.getSubAccountsWithMiscInfoByExternalId_element C44 = new CCDS_Corporate.getSubAccountsWithMiscInfoByExternalId_element(); 
        CCDS_Corporate.updateContactResponse_element C45 = new CCDS_Corporate.updateContactResponse_element(); 
        CCDS_Corporate.updateCorporateExternalIdResponse_element C46 = new CCDS_Corporate.updateCorporateExternalIdResponse_element(); 
        CCDS_Corporate.getCorporations_element C47 = new CCDS_Corporate.getCorporations_element(); 
        CCDS_Corporate.updateCorporateName_element C48 = new CCDS_Corporate.updateCorporateName_element(); 
        CCDS_Corporate.Authentication C49 = new CCDS_Corporate.Authentication(); 
        CCDS_Corporate.BaseFileReturn C50 = new CCDS_Corporate.BaseFileReturn(); 
        CCDS_Corporate.BaseReturnObject C51 = new CCDS_Corporate.BaseReturnObject(); 
        CCDS_Corporate.Map_x C52 = new CCDS_Corporate.Map_x(); 
        CCDS_Corporate.Corporate C53 = new CCDS_Corporate.Corporate(); 
        CCDS_Corporate.BillingOptions C54 = new CCDS_Corporate.BillingOptions(); 
        CCDS_Corporate.SubAccountDefaults C55 = new CCDS_Corporate.SubAccountDefaults(); 
        CCDS_Corporate.CorporateHttpSoap11Endpoint C56 = new CCDS_Corporate.CorporateHttpSoap11Endpoint();
        
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
        
        
        CCDS_Corporate.CorporateHttpSoap11Endpoint tempEP = new CCDS_Corporate.CorporateHttpSoap11Endpoint(1);
        CCDS_Corporate.Authentication auth = new CCDS_Corporate.Authentication('1','2','3','4','5');
        
        Test.startTest();
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestForCorporateCallouts.getCorporationByExternalIdMockImpl());
        CCDS_Corporate.CorporateReturn corpReturn = tempEP.getCorporationByExternalId(auth, 'Test');
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestForCorporateCallouts.getAddressMockImpl());
        CCDS_Corporate.CorporateAddressReturn corpAddressReturn = tempEP.getAddress(auth, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestForCorporateCallouts.updateCorporateIdMockImpl());
        CCDS_Corporate.CorporateMessageReturn corpMessageReturn = tempEP.updateCorporateId(auth, 1, 'Test');
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestForCorporateCallouts.getRepresentativeAccountMockImpl());
        CCDS_Corporate.SubAccountReturn subAccountReturn = tempEP.getRepresentativeAccount(auth, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestForCorporateCallouts.updateSubAccountDefaultOptionsMockImpl());
        corpMessageReturn = tempEP.updateSubAccountDefaultOptions(auth, C55);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestForCorporateCallouts.updateContactMockImpl());
        corpMessageReturn = tempEP.updateContact(auth, C6);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestForCorporateCallouts.updateAddressMockImpl());
        corpMessageReturn = tempEP.updateAddress(auth, C7);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestForCorporateCallouts.getSubAccountsMockImpl());
        subAccountReturn = tempEP.getSubAccounts(auth, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestForCorporateCallouts.getInvoiceFileMockImpl());
        CCDS_Corporate.CorporateInvoiceFileReturn corpInvoiceFileReturn = tempEP.getInvoiceFile(auth, 1, Datetime.now());
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestForCorporateCallouts.getSubAccountsWithMiscInfoByExternalIdMockImpl());
        subAccountReturn = tempEP.getSubAccountsWithMiscInfoByExternalId(auth, 'Test', 1, 1, 'Test', 'Test');
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestForCorporateCallouts.updateCorporateNameMockImpl());
        corpMessageReturn = tempEP.updateCorporateName(auth, 1, 'Test');
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestForCorporateCallouts.updateCorporateExternalIdMockImpl());
        corpMessageReturn = tempEP.updateCorporateExternalId(auth, 1, 'Test');
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestForCorporateCallouts.updateBillingOptionsMockImpl());
        corpMessageReturn = tempEP.updateBillingOptions(auth, C54);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestForCorporateCallouts.addMockImpl());
        corpMessageReturn = tempEP.add(auth, C53);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestForCorporateCallouts.getCorporationsMockImpl());
        corpReturn = tempEP.getCorporations(auth);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestForCorporateCallouts.getCorporationMockImpl());
        corpReturn = tempEP.getCorporation(auth, 1);
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestForCorporateCallouts.getSubAccountsWithMiscInfoMockImpl());
        subAccountReturn = tempEP.getSubAccountsWithMiscInfo(auth, 1, 1, 1, 'Test', 'Test');
        
        Test.setMock(WebServiceMock.class, new CCDS_MockTestForCorporateCallouts.getContactsMockImpl());
        CCDS_Corporate.ContactReturn contactReturn = tempEP.getContacts(auth, 1);
        
        Test.stopTest();
    } 

}