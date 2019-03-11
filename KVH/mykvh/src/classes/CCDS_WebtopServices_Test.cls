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
private class CCDS_WebtopServices_Test {
	//The typical test Class statics...
	private static final Id Direct_Customer_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Customer').getRecordTypeId();
	
	//Runs before any test methods...
	@testSetup static void setupTestData(){
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
        
    //Method (not a testMethod) to return a pw_ccpro__CountryObject__c, Specifically Canada
    static pw_ccpro__CountryObject__c SetUpCountry_Test(){
    	
    	pw_ccpro__CountryObject__c returnCo = new pw_ccpro__CountryObject__c ();
    	returnCo = [SELECT Id, Name, pw_ccpro__IsoCode_2__c, pw_ccpro__IsoCode_3__c
    	            FROM pw_ccpro__CountryObject__c
    	            WHERE Name = 'Canada' LIMIT 1];
    	return returnCo;
    }
    
    //Method (not a testMethod) to generate and return a random string, 40 char in length
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
    static testMethod void AddCorporateAccount_Test(){
        
        Account a = SetUpAccountData_Test();

        a.Bill_to__c = 'Corporate';
        a.Mail_to__c = 'Corporate';
        a.Account_Type__c = 'Corporate';
        update a;
        System.assert(CCDS_WebtopServices.AddAccount(a.Id, 'Corporate') == true);
    }
    
    static testMethod void AddCustomerAccount_Test(){     
        
        Account a = SetUpAccountData_Test();
        
        System.assert(CCDS_WebtopServices.AddAccount(a.Id, 'Customer') == true);
    }
   
    static testMethod void UpdateCorporateAccount_Test(){
        
        Account a = SetUpAccountData_Test();

        a.Bill_to__c = 'Corporate';
        a.Mail_to__c = 'Corporate';
        a.Account_Type__c = 'Corporate';
        update a;        
        System.assert(CCDS_WebtopServices.UpdateAccount(a.Id, 'Corporate') == true);
    }

    static testMethod void UpdateCustomerAccount_Test(){
        
        Account a = SetUpAccountData_Test();
        
        System.assert(CCDS_WebtopServices.UpdateAccount(a.Id, 'Customer') == true);
    }

    static testMethod void AddCorporateContact_Test(){
        
        Account a = SetUpAccountData_Test();

        a.Bill_to__c = 'Corporate';
        a.Mail_to__c = 'Corporate';
        a.Account_Type__c = 'Corporate';
        update a; 
        System.assert(CCDS_WebtopServices.AddContact(a.Id, 'Corporate') == true);
    }
    
    static testMethod void AddCustomerContact_Test(){
        
        Account a = SetUpAccountData_Test();      
        
        System.assert(CCDS_WebtopServices.AddContact(a.Id, 'Customer') == true);
    }    
    
}