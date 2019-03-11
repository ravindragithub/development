@isTest 
private class Service_LTE_activation_transform_test {
    //setup testClass variables here. For example:
    //RecordType Ids
    private static final Id ServCloud_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Cloud').getRecordTypeId();
    private static final Id DIRECTCUSTOMER_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Customer').getRecordTypeId();
    private static final Id SERVICE_PRODUCT2_RECORD_TYPE_ID = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Service').getRecordTypeId();
    private static final Id TEST_PLATFORM_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Demo/Test/Monitor').getRecordTypeId();
    private static final Id CONTRACT_RECORD_TYPE_ID = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Airtime Activation Service Contract').getRecordTypeId();
    
    
    @testSetup static void setupTestData(){
        //Need an LTE Activation sObject... inserted with a Record ID and everything!
        //This is a pretty big sObject, and currently, subject to change...
        Account testAcct = new Account(Name='Test Account', RecordTypeId=TEST_PLATFORM_RECORD_TYPE_ID);
        LTE_Activation__c lteForm = new LTE_Activation__c();
        Asset testAsset = new Asset();
        Contact testContact = new Contact();
        
        //dummy account that sub contact lives on that will get moved
        Account dummyAcc = new Account();
        dummyAcc.Name = 'AccountTest';
        dummyAcc.KVH_Sales_Office__c = 'KU Satcom';
        dummyAcc.Account_Status__c = 'Active';
        dummyAcc.Market__c = 'Leisure';
        dummyAcc.Market_Sector__c = 'Marine';
        insert dummyAcc;
        
        
        //Set up Contact data
        testContact.FirstName = 'test first';
        testContact.LastName = 'test last';
        testContact.AccountId = dummyAcc.Id;
        testContact.Email = 'subscriber@kvh.com';
        insert testContact;
        
        
        //case
       case newCase = new case();
        newCase.ContactId = testContact.Id;
        newCase.Subject = 'Fatal Error in Service_LTE_activation_transform Class';
        newCase.Origin = 'System Generated';
        newCase.Status = 'New';
        insert newCase;
        
        lteForm.Agreed_to_Receive_Texts__c = true;
        lteForm.Antenna_Serial_No__c = '12344571234567';
        lteForm.Billing_Address__c =       		  '50 Enterprise Center';
        lteForm.Billing_City__c =                 'Middletown';
        lteForm.Billing_Company_Name__c =         'KVH Industries';
        lteForm.Billing_Country__c =              'United States';
        lteForm.Billing_Email__c =                'email1@kvh.com';
        lteForm.Billing_Phone_No__c =             '401-847-3327';
        lteForm.Billing_Postal_Zip_Code__c =      '02842';
        lteForm.Billing_State_Province_Territory__c = 'Rhode Island';
        lteForm.Contact1_is_Authorized_Rep__c = true;
        lteForm.Contact1_is_Billing_Point__c = true;
        lteForm.Contact1_is_Invoice_Recipient__c = true;
        lteForm.Contact2_is_Authorized_Rep__c = true;
        lteForm.Contact2_is_Billing_Point__c = true;
        lteForm.Contact2_is_Invoice_Recipient__c = true;
        lteForm.Contact_1_Company_Name__c =       'KVH Industries 1';
        lteForm.Contact_1_Country__c =            'United States';
        lteForm.Contact_1_Email__c =              'email1@kvh.com';
        lteForm.Contact_1_Job_Title__c =          'test title 1';
        lteForm.Contact_1_Phone__c =              '401-847-3329';
        lteForm.Contact_1_Role__c =               'test role 1';
        lteForm.Contact_1_State_Province__c =     'Rhode Island';
        lteForm.Contact_2_Company_Name__c =             'KVH Industries 2';
        lteForm.Contact_2_Country__c =                  'United States';
        lteForm.Contact_2_Email__c =                    'email2@kvh.com';
        lteForm.Contact_2_Job_Title__c =                'test title 2';
        lteForm.Contact_2_Phone__c =                    '02842';
        lteForm.Contact_2_Role__c =                     'test role 2';
        lteForm.Contact_2_State_Province_Territory__c = 'Rhode Island';
        lteForm.Customer_Code__c = '9999';
        lteForm.Flag__c = 'United States';
        lteForm.IMO_Registration_No__c = '1234567';
        lteForm.Installer_Contact_Name__c = 'CJ Webber';
        lteForm.Installer_Country__c = 'United States';
        lteForm.Installer_Information__c = 'Self';
        lteForm.Installer_Manufacture__c = 'manufacture info';
        lteForm.Installer_State_Province_Territory__c = 'Florida';
        lteForm.Main_Contact_FirstName_Billing__c = 'Bill';
        lteForm.Main_Contact_FirstName_Subscriber__c = 'test first';
        lteForm.Main_Contact_First_Name_Cont1__c = 'Cont1';
        lteForm.Sim_Serial_No__c = '123456789';
        lteForm.Market__c = 'Leisure';
        lteForm.Sector__c = 'Marine Systems';
        lteForm.Main_Contact_First_Name_Cont2__c = 'Cont2';
        lteForm.Main_Contact_LastName_Billing__c = 'Billingsly';
        lteForm.Main_Contact_LastName_Subscriber__c = 'test last';
        lteForm.Main_Contact_Last_Name_Cont1__c = 'Tact1';
        lteForm.Main_Contact_Last_Name_Cont2__c = 'Tact2';
        lteForm.MMSI__c = '123456789';
        lteForm.Onboard_Company_Name__c = 'Onboard Company';
        lteForm.Onboard_Contact_Name__c = 'Onboard Name';
        lteForm.Onboard_Country__c = 'United Stated';
        lteForm.Onboard_Email__c = 'onboard@kvh.com';
        lteForm.Onboard_Job_Title__c = 'onboard job';
        lteForm.Onboard_Phone__c = '401-847-3330';
        lteForm.Onboard_Role__c = 'Onboard Role';
        lteForm.Onboard_State_Province_Territory__c = 'Rhode Island';
        lteForm.Pre_activation_Date__c = system.today();
        lteForm.Primary_CC_Exp_Date__c = '10/19';
        lteForm.Primary_Credit_Card_No__c = '12341234123412341234';
        lteForm.Primary_Name_on_Card__c = 'JP Morgan';
        lteForm.Privacy_Policy_is_Accepted2__c = true;
        lteForm.Privacy_Policy_is_Accepted3__c = true;
        lteForm.Privacy_Policy_is_Accepted__c = true;
        lteForm.Promotional_Code__c = 'test Promo';
        lteForm.Purchased_From__c = 'West Marine';
        lteForm.Requested_Service_Start_Date__c = system.today();
        lteForm.Secondary_CC_Exp_Date__c = '10/19';
        lteForm.Secondary_Credit_Card_No__c = '43214321432143214321';
        lteForm.Secondary_Name_on_Card__c = 'Bill Gates';
        lteForm.Sim_Serial_No__c = '12344571234567';    //this might be deprecated....
        lteForm.Subscriber_Address__c = '50 Enterprise Center';
        lteForm.Subscriber_City__c =    'Middletown';
        lteForm.Subscriber_Company_Name__c = 'Subscriber Inc.';
        lteForm.Subscriber_Country__c = 'United States';
        lteForm.Subscriber_Email__c = 'subscriber@kvh.com';
        lteForm.Subscriber_is_Billing_Point_of_Contact__c = true;
        lteForm.Subscriber_is_Invoice_recipient__c = true;
        lteForm.Subscriber_Phone__c = '401-847-3331';
        lteForm.Subscriber_Postal_Zip_Code__c = '02842';
        lteForm.Subscriber_State_Province_Territory__c = 'Rhode Island';
        lteForm.Vessel_Length__c = '40';
        lteForm.Vessel_Name__c = 'Titanic';
        lteForm.Vessel_Type__c = 'Sail Superyacht >80 ft (24m)';
        lteForm.Contact__c = testContact.Id;
        lteForm.Contact_email__c = 'egbneuigbe@gmail.com';
        lteForm.Rate_Plan__c = 'LTE20GB';
        Platform_Market_Sector__c marketSector = new Platform_Market_Sector__c();
        marketSector.Market__c = 'Leisure';
        marketSector.Sector__c = 'Marine Systems';
        marketSector.Name = 'Sail Superyacht >80 ft (24m)';
        marketSector.Account_Market__c = 'Leisure';
        marketSector.Account_Sector__c = 'Marine Systems';
        marketSector.Account_Record_Type__c = 'Leisure Vessel';
        
        insert marketSector;
        
        
        
        
        //Set up asset data
        testAsset.Name = '12344571234567';
        testAsset.SerialNumber = '12344571234567';
        
        list<Product2> prodList = new list<Product2>();
        Product2 testProd = new Product2(Name='LTE20GB', 
                                         ProductCode='LTE20GB-C', 
                                         RecordTypeId=Service_Product2_RECORD_TYPE_ID, Data_Rate_Plan__c = true);
        prodList.add(testProd);
        //Need several HARDWARE Products...
        Product2 lteModemProduct = new Product2(Name = '19-1027', ProductCode = '19-1027', Product_ID__c='19-1027_US');
        prodList.add(lteModemProduct);
        Product2 lteSIMProduct = new Product2(Name = '19-1035', ProductCode = '19-1035', Product_ID__c='19-1035_US');
        prodList.add(lteSIMProduct);
        Product2 lteDomeProduct = new Product2(Name = '02-2280', ProductCode = '02-2280', Product_ID__c='02-2280_US');
        prodList.add(lteDomePRoduct);
        Product2 lteSystemProduct = new Product2(Name = '01-0419', ProductCode = '01-0419', Product_ID__c='01-0419_US');
        prodList.add(lteSystemProduct);
        Product2 lteVTIDProduct = new Product2(Name = 'Virtual Terminal ID', ProductCode = 'Virtual Terminal ID', Product_ID__c='Virtual Terminal ID_US');
        prodList.add(lteVTIDProduct);
        insert prodList;
        //And we need Assets, in a Hierarhcy
        list<Asset> assetList = new list<Asset>();
        for(Product2 p : [SELECT Id, ProductCode, Name FROM Product2]){
            if(p.Name!= 'LTE20GB'){  //Exclude our one service!
                //User the Product2.Name as the Asset.Name
                Asset a = new Asset(Name = p.Name, Product2Id = p.Id, AccountId = testAcct.Id);
                assetList.add(a);
            }
        }  
        insert assetList;
        assetList.clear();
        //now to setup the Hierarchy... start with a map
        assetList = [SELECT Id, Name, ParentId, Parent_Asset__c, RootAssetId, Root_Asset__c,
                     Product2.ProductCode FROM Asset];
        map<String, Asset> assetMap = new map<String, Asset>();
        for(asset a : assetList){
            assetMap.put(a.Name, a);
        }
        //now arrange Parents and children
        assetList.clear();
        assetMap.get('02-2280').Parent_Asset__c = assetMap.get('01-0419').Id;
        assetMap.get('19-1027').Parent_Asset__c = assetMap.get('02-2280').Id;
        assetMap.get('19-1035').Parent_Asset__c = assetMap.get('02-2280').Id;
        assetList = assetMap.values();
        update assetList;
        
        
        //Dummy product
        Product2 dummyProduct = new Product2(Name = 'LTE20GB' , Data_Rate_Plan__c =true);
        dummyProduct.RecordTypeId = SERVICE_PRODUCT2_RECORD_TYPE_ID;
        insert dummyProduct;
        
        //Dummy contract
        Contract dummyContract = new Contract();
        dummyContract.AccountId = dummyAcc.Id;
        dummyContract.ContractTerm = 1;
        dummyContract.Contract_Type__c = 'Airtime';
        dummyContract.Status = 'Draft';
        dummyContract.StartDate = system.today();
        dummyContract.RecordTypeId = Contract_RECORD_TYPE_ID;
        insert dummyContract;
        
        
        //insert rest
        
        insert lteForm;
        insert testAsset;

        //setup for User updates...
        //need to add Custom Setting with a mock myKVH Role ID
        myKVH_new_User_Defaults__c insertCs = new myKVH_new_User_Defaults__c();
        insertCs.Name = 'DirectCustomerDefaults';
        insertCs.myKVH_Role_Id__c = 'a1l000000000000AAA';
        insertCs.SF_Profile_Id__c = '00e000000000000AAA'; //not used, but required for custom setting
        insert insertCs;
        //need to add User related to Contact.
        list<Contact> conList = new list<Contact>();
        conList = [SELECT Id, AccountId, Name FROM Contact];
        system.debug(conList);
        Profile PortalProf = new Profile();
        PortalProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Portal%' Limit 1];
        User admin = [SELECT Id, username FROM User 
                      WHERE Profile.name = 'System Administrator' 
                      AND isActive = true
                      LIMIT 1];
        system.debug(admin);
        system.runAs(admin){
          //site.createExternalUser()
          //Convert Contacts to Portal Users
          User tu = new User();
          tu.username = 'AccountAdmin.testUser@mock.user';
          tu.LastName = 'User1';
          tu.Email = 'AccountAdmin.testUser@mock.user';
          tu.Alias = 'AccAdm';
          tu.TimeZoneSidKey = 'America/New_York';
          tu.LocaleSidKey = 'en_US';
          tu.EmailEncodingKey = 'ISO-8859-1';
          tu.ProfileId = PortalProf.id;
          tu.LanguageLocaleKey = 'en_US';
          tu.ContactId = conList[0].Id; //must CREATE() user with Contact Id.....
          insert tu;
        }
    }
    
    static testMethod void testSetupData(){
        // Test that your test data is setup correctly
        // It's probably just that one sObject...
        list<LTE_Activation__c> lteForms = new list<LTE_Activation__c>();
        lteForms = [SELECT Id, Name FROM LTE_Activation__c];
        system.assertEquals(1, lteForms.size());
    }
    //Static block output tests
    static testMethod void test_staticLog(){
        serviceResults logStringResponse = Service_LTE_activation_transform.getLog();
        system.assert(logStringResponse.message.contains('SERVICE_INITIALIZATION'));
        system.assert(logStringResponse.message.contains('Initializing LTE Activation Transform Service'), logStringResponse);
    }  
    //Method tests
    static testMethod void test_returnFatalError(){
        LTE_Activation__c cleanForm = [ SELECT Id, Billing_Address__c, Subscriber_Address__c,Agreed_to_Receive_Texts__c,Antenna_Serial_No__c, Billing_City__c,  
                                       Subscriber_City__c,Billing_Company_Name__c, Contact_1_Company_Name__c,Contact_2_Company_Name__c,
                                       Onboard_Company_Name__c, Subscriber_Company_Name__c, Contact1_is_Authorized_Rep__c, Contact1_is_Billing_Point__c,
                                       Contact1_is_Invoice_Recipient__c, Contact2_is_Authorized_Rep__c, Contact2_is_Billing_Point__c,Contact2_is_Invoice_Recipient__c, 
                                       Onboard_Contact_Name__c, Billing_Country__c, Contact_1_Country__c, Contact_2_Country__c,  Subscriber_Country__c ,
                                       Customer_Code__c, Billing_Email__c, 
                                       Contact_1_Email__c, Contact_2_Email__c, Subscriber_Email__c, Flag__c,  
                                       IMO_Registration_No__c, Installer_Contact_Name__c,  Installer_Country__c, Installer_Information__c, Installer_Manufacture__c  ,  
                                       Installer_State_Province_Territory__c, Contact_1_Job_Title__c, Contact_2_Job_Title__c, Main_Contact_First_Name_Cont1__c, 
                                       Main_Contact_First_Name_Cont2__c,  Main_Contact_FirstName_Subscriber__c,  Main_Contact_FirstName_Billing__c,  
                                       Main_Contact_LastName_Billing__c, Main_Contact_LastName_Subscriber__c,  Main_Contact_Last_Name_Cont1__c,  Main_Contact_Last_Name_Cont2__c, 
                                       MMSI__c,  Primary_Name_on_Card__c,Market__c, Sector__c, Secondary_Name_on_Card__c,  Onboard_Country__c,  Onboard_Email__c,  Onboard_Job_Title__c, 
                                       Onboard_Phone__c , Onboard_Role__c, Onboard_State_Province_Territory__c, Contact_1_Phone__c, Contact_2_Phone__c, Subscriber_Phone__c,
                                       Billing_Phone_No__c, Billing_Postal_Zip_Code__c, Subscriber_Postal_Zip_Code__c, Pre_activation_Date__c, Primary_CC_Exp_Date__c, 
                                       Primary_Credit_Card_No__c,Privacy_Policy_is_Accepted__c, Privacy_Policy_is_Accepted2__c, Privacy_Policy_is_Accepted3__c, 
                                       Promotional_Code__c,Purchased_From__c,Sim_Serial_No__c,
                                       Requested_Service_Start_Date__c, Contact_1_Role__c, Contact_2_Role__c, Secondary_CC_Exp_Date__c, 
                                       Secondary_Credit_Card_No__c, Billing_State_Province_Territory__c, Contact_1_State_Province__c, 
                                       Contact_2_State_Province_Territory__c, 
                                       Subscriber_State_Province_Territory__c, Subscriber_is_Billing_Point_of_Contact__c, 
                                       Subscriber_is_Invoice_recipient__c, Vessel_Length__c, Vessel_Name__c, Vessel_Type__c, Name, CurrencyIsoCode, Account__c,  Platform_Account__c
                                        , Billing_Account__c  ,   Contact__c,    Contract__c , Corporate_Billing_Account__c   ,Rate_Plan__c                        
                                       FROM LTE_Activation__c LIMIT 1
                                      ];
        test.startTest();
        serviceResults returnedLog = Service_LTE_activation_transform.returnFatalError(cleanForm);
        test.stopTest();
        
        system.debug('log message: ' + returnedLog.message);
        system.assert(returnedLog.message.contains('LTE Activation Transform Service failed ' + 
                                                   'to complete successfully. See log for details.'), returnedLog.message);
        Case c = [SELECT ID, Subject, Status, Origin, RecordTypeId, Description, CaseNumber FROM Case LIMIT 1];
        system.assertEquals(ServCloud_RECORD_TYPE_ID, c.RecordTypeId);
        system.assertEquals('Fatal Error in Service_LTE_activation_transform Class', c.Subject);
        system.assertEquals('System Generated', c.Origin);
        system.assertEquals('New', c.Status);
    }
    static testMethod void test_preProcessValidation(){
        LTE_Activation__c rawForm = [SELECT Id FROM LTE_Activation__c WHERE Vessel_Name__c = 'Titanic'];
        
        test.startTest();
        Service_LTE_activation_transform.preProcessValidation(rawForm);
        test.stopTest();
        
        list<Case> theCase = [SELECT Id, Subject FROM case WHERE Subject like '%exception%' LIMIT 1 ];
        serviceResults log = Service_LTE_activation_transform.getLog();
        //Asserts
        system.assertEquals(0, theCase.size());
        system.assert(log.success);
        system.assert(log.message.contains('METHOD_EXIT'), log);
        system.assert(log.message.contains('|Pre-Process Validation of LTE_Activation__c Complete '), log);
    }
    static testMethod void test_preProcessValidation_FAIL(){
        LTE_Activation__c newForm = new LTE_Activation__c();
        
        test.startTest();
        Service_LTE_activation_transform.preProcessValidation(newForm);
        test.stopTest();
        
        List<Case> theCase = [SELECT Id, Subject, Origin, Case_Symptom__c FROM Case LIMIT 1 ];
        serviceResults log = Service_LTE_activation_transform.getLog();
        //Asserts
        system.assertEquals(false, log.success, log);
        system.assert(log.message.contains('FATAL_ERROR'), log);
        system.assert(log.message.contains('Pre-process validation failed. Input LTE_Activation__c does not include record Ids'), log);
    }
    static testMethod void test_getCleanForm_OK(){
        LTE_Activation__c rawForm = [SELECT Id FROM LTE_Activation__c WHERE Vessel_Name__c = 'Titanic'];
        
        test.startTest();
        LTE_Activation__c outputList = Service_LTE_activation_transform.getCleanForm(rawForm);
        test.stopTest();
        
        list<Case> theCase = [SELECT Id, Subject FROM case WHERE Subject like '%exception%' LIMIT 1 ];
        system.assertNotEquals(null, outputList.Name);
        
        serviceResults log = Service_LTE_activation_transform.getLog();
        //Asserts
        system.assertEquals(0, theCase.size());
        system.assert(log.success );
        system.assert(log.message.contains('METHOD_EXIT'), log);
        system.assert(log.message.contains('|Successfully obtained clean list of form from Salesforce'), log);
    }
    static testMethod void test_getCleanForm_FAIL(){
        LTE_Activation__c rawForm = [SELECT Id FROM LTE_Activation__c WHERE Vessel_Name__c = 'Titanic'];
        LTE_Activation__c testRecord = new LTE_Activation__c(id=rawForm.Id);
        delete rawForm;
        
        test.startTest();
        LTE_Activation__c outputList = Service_LTE_activation_transform.getCleanForm(rawForm);
        test.stopTest();
        
        system.assertEquals(null, outputList.Name);
        serviceResults log = Service_LTE_activation_transform.getLog();
        
        //Asserts
        system.assertEquals('System Generated', log.srCase.Origin);
        system.assertEquals(false, log.success);
        system.assert(log.message.contains('FATAL_ERROR'), log);
        system.assert(log.message.contains('Could not obtain clean list of form from Salesforce'), log);
    }
    static testMethod void test_createSubscriberAcct(){
        //Need to add all required fields to this query
        LTE_Activation__c cleanForm = [ SELECT Id, Billing_Address__c, Subscriber_Address__c,Agreed_to_Receive_Texts__c,Antenna_Serial_No__c, Billing_City__c,  
                                       Subscriber_City__c,Billing_Company_Name__c, Contact_1_Company_Name__c,Contact_2_Company_Name__c,
                                       Onboard_Company_Name__c, Subscriber_Company_Name__c, Contact1_is_Authorized_Rep__c, Contact1_is_Billing_Point__c,
                                       Contact1_is_Invoice_Recipient__c, Contact2_is_Authorized_Rep__c, Contact2_is_Billing_Point__c,Contact2_is_Invoice_Recipient__c, 
                                       Onboard_Contact_Name__c, Billing_Country__c, Contact_1_Country__c, Contact_2_Country__c,  Subscriber_Country__c ,
                                       Customer_Code__c, Billing_Email__c, 
                                       Contact_1_Email__c, Contact_2_Email__c, Subscriber_Email__c, Flag__c,  
                                       IMO_Registration_No__c, Installer_Contact_Name__c,  Installer_Country__c, Installer_Information__c, Installer_Manufacture__c  ,  
                                       Installer_State_Province_Territory__c, Contact_1_Job_Title__c, Contact_2_Job_Title__c, Main_Contact_First_Name_Cont1__c, 
                                       Main_Contact_First_Name_Cont2__c,  Main_Contact_FirstName_Subscriber__c,  Main_Contact_FirstName_Billing__c,  
                                       Main_Contact_LastName_Billing__c, Main_Contact_LastName_Subscriber__c,  Main_Contact_Last_Name_Cont1__c,  Main_Contact_Last_Name_Cont2__c, 
                                       MMSI__c,  Primary_Name_on_Card__c,Market__c, Sector__c, Secondary_Name_on_Card__c,  Onboard_Country__c,  Onboard_Email__c,  Onboard_Job_Title__c, 
                                       Onboard_Phone__c , Onboard_Role__c, Onboard_State_Province_Territory__c, Contact_1_Phone__c, Contact_2_Phone__c, Subscriber_Phone__c,
                                       Billing_Phone_No__c, Billing_Postal_Zip_Code__c, Subscriber_Postal_Zip_Code__c, Pre_activation_Date__c, Primary_CC_Exp_Date__c, 
                                       Primary_Credit_Card_No__c,Privacy_Policy_is_Accepted__c, Privacy_Policy_is_Accepted2__c, Privacy_Policy_is_Accepted3__c, 
                                       Promotional_Code__c,Purchased_From__c,Sim_Serial_No__c,
                                       Requested_Service_Start_Date__c, Contact_1_Role__c, Contact_2_Role__c, Secondary_CC_Exp_Date__c, 
                                       Secondary_Credit_Card_No__c, Billing_State_Province_Territory__c, Contact_1_State_Province__c, 
                                       Contact_2_State_Province_Territory__c, 
                                       Subscriber_State_Province_Territory__c, Subscriber_is_Billing_Point_of_Contact__c, 
                                       Subscriber_is_Invoice_recipient__c, Vessel_Length__c, Vessel_Name__c, Vessel_Type__c, Name, CurrencyIsoCode  , Account__c,  Platform_Account__c
                                        , Billing_Account__c  ,   Contact__c,    Contract__c , Corporate_Billing_Account__c     ,Rate_Plan__c                                             
                                       FROM LTE_Activation__c LIMIT 1
                                      ];
        
        system.debug('market');
        system.debug(cleanForm.Market__c);
        system.debug('sector');
        system.debug(cleanForm.Sector__c);
        
        Platform_Market_Sector__c marketSector = [SELECT Account_Market__c, Account_Record_Type__c, Account_Sector__c, Market__c, Name, Sector__c FROM Platform_Market_Sector__c WHERE Market__c =: 
                          cleanForm.Market__c AND Sector__c =: cleanForm.Sector__c AND Name =: cleanForm.Vessel_Type__c LIMIT 1 ];
        system.debug('marketsector');
        //system.debug(marketSector);
        
        
        
       
        test.startTest();
        Account outputList = Service_LTE_activation_transform.createSubscriberAcct(cleanForm);
        test.stopTest();
        
        list<Case> theCase = [SELECT Id, Subject  FROM case WHERE Subject like '%exception%' LIMIT 1 ];
        serviceResults log = Service_LTE_activation_transform.getLog();
        
        //Asserts
        system.assertEquals(0, theCase.size());
        system.assert(log.success);
        system.assert(log.message.contains('METHOD_EXIT'), log);
        system.assert(log.message.contains('|Subscriber Account with Id: ' ), log);
        
    }
    
    static testMethod void test_createSubscriberAcctTEST2(){
        //Need to add all required fields to this query
        //Is going to test when the company name is null and has to append the first name and last name
        
        LTE_Activation__c cleanForm = [ SELECT Id, Billing_Address__c, Subscriber_Address__c,Agreed_to_Receive_Texts__c,Antenna_Serial_No__c, Billing_City__c,  
                                       Subscriber_City__c,Billing_Company_Name__c, Contact_1_Company_Name__c,Contact_2_Company_Name__c,
                                       Onboard_Company_Name__c, Subscriber_Company_Name__c, Contact1_is_Authorized_Rep__c, Contact1_is_Billing_Point__c,
                                       Contact1_is_Invoice_Recipient__c, Contact2_is_Authorized_Rep__c, Contact2_is_Billing_Point__c,Contact2_is_Invoice_Recipient__c, 
                                       Onboard_Contact_Name__c, Billing_Country__c, Contact_1_Country__c, Contact_2_Country__c,  Subscriber_Country__c ,
                                       Customer_Code__c, Billing_Email__c, 
                                       Contact_1_Email__c, Contact_2_Email__c, Subscriber_Email__c, Flag__c,  
                                       IMO_Registration_No__c, Installer_Contact_Name__c,  Installer_Country__c, Installer_Information__c, Installer_Manufacture__c  ,  
                                       Installer_State_Province_Territory__c, Contact_1_Job_Title__c, Contact_2_Job_Title__c, Main_Contact_First_Name_Cont1__c, 
                                       Main_Contact_First_Name_Cont2__c,Market__c, Sector__c,  Main_Contact_FirstName_Subscriber__c,  Main_Contact_FirstName_Billing__c,  
                                       Main_Contact_LastName_Billing__c, Main_Contact_LastName_Subscriber__c,  Main_Contact_Last_Name_Cont1__c,  Main_Contact_Last_Name_Cont2__c, 
                                       MMSI__c,  Primary_Name_on_Card__c, Secondary_Name_on_Card__c,  Onboard_Country__c,  Onboard_Email__c,  Onboard_Job_Title__c, 
                                       Onboard_Phone__c , Onboard_Role__c, Onboard_State_Province_Territory__c, Contact_1_Phone__c, Contact_2_Phone__c, Subscriber_Phone__c,
                                       Billing_Phone_No__c, Billing_Postal_Zip_Code__c, Subscriber_Postal_Zip_Code__c, Pre_activation_Date__c, Primary_CC_Exp_Date__c, 
                                       Primary_Credit_Card_No__c,Privacy_Policy_is_Accepted__c, Privacy_Policy_is_Accepted2__c, Privacy_Policy_is_Accepted3__c, 
                                       Promotional_Code__c,Purchased_From__c,Sim_Serial_No__c,
                                       Requested_Service_Start_Date__c, Contact_1_Role__c, Contact_2_Role__c, Secondary_CC_Exp_Date__c, 
                                       Secondary_Credit_Card_No__c, Billing_State_Province_Territory__c, Contact_1_State_Province__c, 
                                       Contact_2_State_Province_Territory__c, 
                                       Subscriber_State_Province_Territory__c, Subscriber_is_Billing_Point_of_Contact__c, 
                                       Subscriber_is_Invoice_recipient__c, Vessel_Length__c, Vessel_Name__c, Vessel_Type__c, Name, CurrencyIsoCode   , Account__c,  Platform_Account__c
                                        , Billing_Account__c  ,   Contact__c,    Contract__c , Corporate_Billing_Account__c    ,Rate_Plan__c                                             
                                       FROM LTE_Activation__c LIMIT 1
                                      ];
        
        
        
        cleanForm.Subscriber_Company_Name__c =null;
        test.startTest();
        Account outputList = Service_LTE_activation_transform.createSubscriberAcct(cleanForm);
        test.stopTest();
        
        list<Case> theCase = [SELECT Id, Subject  FROM case WHERE Subject like '%exception%' LIMIT 1 ];
        serviceResults log = Service_LTE_activation_transform.getLog();
        
        //Asserts
        
        system.assertEquals(0, theCase.size());
        system.assert(log.success);
        system.assert(outputList.Name == cleanForm.Main_Contact_FirstName_Subscriber__c + ' ' + cleanForm.Main_Contact_LastName_Subscriber__c + ' ' + cleanForm.Name);
        system.assert(log.message.contains('METHOD_EXIT'), log);
        system.assert(log.message.contains('|Subscriber Account with Id: ' ), log);
        
    }
    static testMethod void test_createSubscriberAcct_FAIL(){
        //Need to add all required fields to this query
        LTE_Activation__c cleanForm = new LTE_Activation__c();
        cleanForm.Subscriber_Company_Name__c = '';
        cleanForm.Main_Contact_FirstName_Subscriber__c ='';
        cleanForm.Main_Contact_LastName_Subscriber__c= '';
        test.startTest();
        Account outputList = Service_LTE_activation_transform.createSubscriberAcct(cleanForm);
        test.stopTest();
        
        serviceResults log = Service_LTE_activation_transform.getLog();
        //Asserts
        system.assertEquals('System Generated', log.srCase.Origin);
        system.assertEquals(false, log.success);
        system.assert(log.message.contains('FATAL_ERROR'), log);
        system.assert(log.message.contains('LTE createSubscriber method failed'), log);
        
    }
    static testMethod void test_createPlatformAcct(){
        //Need to add all required fields to this query
        LTE_Activation__c cleanForm = [ SELECT Id, Billing_Address__c, Subscriber_Address__c,Agreed_to_Receive_Texts__c,Antenna_Serial_No__c, Billing_City__c,  
                                       Subscriber_City__c,Billing_Company_Name__c, Contact_1_Company_Name__c,Contact_2_Company_Name__c,
                                       Onboard_Company_Name__c, Subscriber_Company_Name__c, Contact1_is_Authorized_Rep__c, Contact1_is_Billing_Point__c,
                                       Contact1_is_Invoice_Recipient__c, Contact2_is_Authorized_Rep__c, Contact2_is_Billing_Point__c,Contact2_is_Invoice_Recipient__c, 
                                       Onboard_Contact_Name__c, Billing_Country__c, Contact_1_Country__c, Contact_2_Country__c,  Subscriber_Country__c ,
                                       Customer_Code__c, Billing_Email__c, 
                                       Contact_1_Email__c, Contact_2_Email__c, Subscriber_Email__c, Flag__c,  
                                       IMO_Registration_No__c, Installer_Contact_Name__c,  Installer_Country__c, Installer_Information__c, Installer_Manufacture__c  ,  
                                       Installer_State_Province_Territory__c, Contact_1_Job_Title__c, Contact_2_Job_Title__c, Main_Contact_First_Name_Cont1__c, 
                                       Main_Contact_First_Name_Cont2__c,  Main_Contact_FirstName_Subscriber__c,  Main_Contact_FirstName_Billing__c,  
                                       Main_Contact_LastName_Billing__c, Main_Contact_LastName_Subscriber__c,  Main_Contact_Last_Name_Cont1__c,  Main_Contact_Last_Name_Cont2__c, 
                                       MMSI__c,  Primary_Name_on_Card__c,Market__c, Sector__c, Secondary_Name_on_Card__c,  Onboard_Country__c,  Onboard_Email__c,  Onboard_Job_Title__c, 
                                       Onboard_Phone__c , Onboard_Role__c, Onboard_State_Province_Territory__c, Contact_1_Phone__c, Contact_2_Phone__c, Subscriber_Phone__c,
                                       Billing_Phone_No__c, Billing_Postal_Zip_Code__c, Subscriber_Postal_Zip_Code__c, Pre_activation_Date__c, Primary_CC_Exp_Date__c, 
                                       Primary_Credit_Card_No__c,Privacy_Policy_is_Accepted__c, Privacy_Policy_is_Accepted2__c, Privacy_Policy_is_Accepted3__c, 
                                       Promotional_Code__c,Purchased_From__c,Sim_Serial_No__c,
                                       Requested_Service_Start_Date__c, Contact_1_Role__c, Contact_2_Role__c, Secondary_CC_Exp_Date__c, 
                                       Secondary_Credit_Card_No__c, Billing_State_Province_Territory__c, Contact_1_State_Province__c, 
                                       Contact_2_State_Province_Territory__c, 
                                       Subscriber_State_Province_Territory__c, Subscriber_is_Billing_Point_of_Contact__c, 
                                       Subscriber_is_Invoice_recipient__c, Vessel_Length__c, Vessel_Name__c, Vessel_Type__c, Name, CurrencyIsoCode , Account__c,  Platform_Account__c
                                        , Billing_Account__c  ,   Contact__c,    Contract__c , Corporate_Billing_Account__c    ,Rate_Plan__c                                               
                                       FROM LTE_Activation__c LIMIT 1
                                      ];   
        
        
        test.startTest();
        Account subscriberAcct = Service_LTE_activation_transform.createSubscriberAcct(cleanForm);
        Account outputList = Service_LTE_activation_transform.createPlatformAcct(cleanForm, subscriberAcct );
        test.stopTest();
        
        list<Case> theCase = [SELECT Id, Subject  FROM case WHERE Subject like '%exception%' LIMIT 1 ];
        serviceResults log = Service_LTE_activation_transform.getLog();
        //Asserts
        system.assertEquals(0, theCase.size());
        system.assert(log.success);
        system.assert(log.message.contains('METHOD_EXIT'), log);
        system.assert(log.message.contains('|Subscriber Account with Id: ' ), log);
        
    }
    
    static testMethod void test_createPlatformAcctTEST2(){
        //Need to add all required fields to this query
        //This will test when the vessel type is a power boat which triggers another required dependent picklist value
        LTE_Activation__c cleanForm = [ SELECT Id, Billing_Address__c, Subscriber_Address__c,Agreed_to_Receive_Texts__c,Antenna_Serial_No__c, Billing_City__c,  
                                       Subscriber_City__c,Billing_Company_Name__c, Contact_1_Company_Name__c,Contact_2_Company_Name__c,
                                       Onboard_Company_Name__c, Subscriber_Company_Name__c, Contact1_is_Authorized_Rep__c, Contact1_is_Billing_Point__c,
                                       Contact1_is_Invoice_Recipient__c, Contact2_is_Authorized_Rep__c, Contact2_is_Billing_Point__c,Contact2_is_Invoice_Recipient__c, 
                                       Onboard_Contact_Name__c, Billing_Country__c, Contact_1_Country__c, Contact_2_Country__c,  Subscriber_Country__c ,
                                       Customer_Code__c, Billing_Email__c, 
                                       Contact_1_Email__c, Contact_2_Email__c, Subscriber_Email__c, Flag__c,  
                                       IMO_Registration_No__c, Installer_Contact_Name__c,  Installer_Country__c, Installer_Information__c, Installer_Manufacture__c  ,  
                                       Installer_State_Province_Territory__c, Contact_1_Job_Title__c, Contact_2_Job_Title__c, Main_Contact_First_Name_Cont1__c, 
                                       Main_Contact_First_Name_Cont2__c,Market__c, Sector__c,  Main_Contact_FirstName_Subscriber__c,  Main_Contact_FirstName_Billing__c,  
                                       Main_Contact_LastName_Billing__c, Main_Contact_LastName_Subscriber__c,  Main_Contact_Last_Name_Cont1__c,  Main_Contact_Last_Name_Cont2__c, 
                                       MMSI__c,  Primary_Name_on_Card__c, Secondary_Name_on_Card__c,  Onboard_Country__c,  Onboard_Email__c,  Onboard_Job_Title__c, 
                                       Onboard_Phone__c , Onboard_Role__c, Onboard_State_Province_Territory__c, Contact_1_Phone__c, Contact_2_Phone__c, Subscriber_Phone__c,
                                       Billing_Phone_No__c, Billing_Postal_Zip_Code__c, Subscriber_Postal_Zip_Code__c, Pre_activation_Date__c, Primary_CC_Exp_Date__c, 
                                       Primary_Credit_Card_No__c,Privacy_Policy_is_Accepted__c, Privacy_Policy_is_Accepted2__c, Privacy_Policy_is_Accepted3__c, 
                                       Promotional_Code__c,Purchased_From__c,Sim_Serial_No__c,
                                       Requested_Service_Start_Date__c, Contact_1_Role__c, Contact_2_Role__c, Secondary_CC_Exp_Date__c, 
                                       Secondary_Credit_Card_No__c, Billing_State_Province_Territory__c, Contact_1_State_Province__c, 
                                       Contact_2_State_Province_Territory__c, 
                                       Subscriber_State_Province_Territory__c, Subscriber_is_Billing_Point_of_Contact__c, 
                                       Subscriber_is_Invoice_recipient__c, Vessel_Length__c, Vessel_Name__c, Vessel_Type__c, Name, CurrencyIsoCode       , Account__c,  Platform_Account__c
                                        , Billing_Account__c  ,   Contact__c,    Contract__c , Corporate_Billing_Account__c    ,Rate_Plan__c                                         
                                       FROM LTE_Activation__c LIMIT 1
                                      ];   
        
        cleanForm.Vessel_Type__c = 'Sail Superyacht >80 ft (24m)' ;   
       
        Account subscriberAcct = new Account( );
        subscriberAcct.KVH_Sales_Office__c = 'KU Satcom';
        subscriberAcct.Account_Status__c = 'Active';
        subscriberAcct.Market__c = 'Leisure';
        subscriberAcct.Market_Sector__c = 'Marine';
        subscriberAcct.Name = 'testt';
        insert subscriberAcct;
        test.startTest();
        Account outputList = Service_LTE_activation_transform.createPlatformAcct(cleanForm, subscriberAcct );
        test.stopTest();
        
        list<Case> theCase = [SELECT Id, Subject  FROM case WHERE Subject like '%exception%' LIMIT 1 ];
        serviceResults log = Service_LTE_activation_transform.getLog();
        //Asserts
        //system.assert(outputList.Industry_Designation__c == cleanForm.Vessel_Type__c );
        //system.assert(outputList.Platform_Detail__c == 'Cruiser');
        system.assertEquals(0, theCase.size());
        system.assert(log.success);
        system.assert(log.message.contains('METHOD_EXIT'), log);
        system.assert(log.message.contains('|Platform Account with Id:' ), log);
        
    }
    static testMethod void test_createPlatformAcct_FAIL(){
        
        LTE_Activation__c cleanForm = new LTE_Activation__c();
        Account theAcc = new Account();
        
        test.startTest();
        Account outputList = Service_LTE_activation_transform.createPlatformAcct(cleanForm, theAcc );
        test.stopTest();
        
        serviceResults log = Service_LTE_activation_transform.getLog();
        //Asserts
        system.assertEquals('System Generated', log.srCase.Origin);
        system.assertEquals(false, log.success);
        system.assert(log.message.contains('FATAL_ERROR'), log);
        system.assert(log.message.contains('LTE createPlatformAcct method failed'), log);
        
    }
    static testMethod void test_moveAssets(){
        LTE_Activation__c cleanForm = [ SELECT Id, Billing_Address__c, Subscriber_Address__c,Agreed_to_Receive_Texts__c,Antenna_Serial_No__c, Billing_City__c,  
                                       Subscriber_City__c,Billing_Company_Name__c, Contact_1_Company_Name__c,Contact_2_Company_Name__c,
                                       Onboard_Company_Name__c, Subscriber_Company_Name__c, Contact1_is_Authorized_Rep__c, Contact1_is_Billing_Point__c,
                                       Contact1_is_Invoice_Recipient__c, Contact2_is_Authorized_Rep__c, Contact2_is_Billing_Point__c,Contact2_is_Invoice_Recipient__c, 
                                       Onboard_Contact_Name__c, Billing_Country__c, Contact_1_Country__c, Contact_2_Country__c,  Subscriber_Country__c ,
                                       Customer_Code__c, Billing_Email__c, 
                                       Contact_1_Email__c, Contact_2_Email__c, Subscriber_Email__c, Flag__c,  
                                       IMO_Registration_No__c, Installer_Contact_Name__c,  Installer_Country__c, Installer_Information__c, Installer_Manufacture__c  ,  
                                       Installer_State_Province_Territory__c,Market__c, Sector__c, Contact_1_Job_Title__c, Contact_2_Job_Title__c, Main_Contact_First_Name_Cont1__c, 
                                       Main_Contact_First_Name_Cont2__c,  Main_Contact_FirstName_Subscriber__c,  Main_Contact_FirstName_Billing__c,  
                                       Main_Contact_LastName_Billing__c, Main_Contact_LastName_Subscriber__c,  Main_Contact_Last_Name_Cont1__c,  Main_Contact_Last_Name_Cont2__c, 
                                       MMSI__c,  Primary_Name_on_Card__c, Secondary_Name_on_Card__c,  Onboard_Country__c,  Onboard_Email__c,  Onboard_Job_Title__c, 
                                       Onboard_Phone__c , Onboard_Role__c, Onboard_State_Province_Territory__c, Contact_1_Phone__c, Contact_2_Phone__c, Subscriber_Phone__c,
                                       Billing_Phone_No__c, Billing_Postal_Zip_Code__c, Subscriber_Postal_Zip_Code__c, Pre_activation_Date__c, Primary_CC_Exp_Date__c, 
                                       Primary_Credit_Card_No__c,Privacy_Policy_is_Accepted__c, Privacy_Policy_is_Accepted2__c, Privacy_Policy_is_Accepted3__c, 
                                       Promotional_Code__c,Purchased_From__c,Sim_Serial_No__c,
                                       Requested_Service_Start_Date__c, Contact_1_Role__c, Contact_2_Role__c, Secondary_CC_Exp_Date__c, 
                                       Secondary_Credit_Card_No__c, Billing_State_Province_Territory__c, Contact_1_State_Province__c, 
                                       Contact_2_State_Province_Territory__c, 
                                       Subscriber_State_Province_Territory__c, Subscriber_is_Billing_Point_of_Contact__c, 
                                       Subscriber_is_Invoice_recipient__c, Vessel_Length__c, Vessel_Name__c, Vessel_Type__c, Name, CurrencyIsoCode, Account__c,  Platform_Account__c
                                        , Billing_Account__c  ,   Contact__c,    Contract__c , Corporate_Billing_Account__c  ,Rate_Plan__c                                                  
                                       FROM LTE_Activation__c LIMIT 1
                                      ];
        Asset domeAsset = new Asset();
        domeAsset = [SELECT Id, SerialNumber, Name, AccountId FROM Asset  Where Name =: cleanForm.Antenna_Serial_No__c];
        
        
        test.startTest();
        Account subscriberAcct = Service_LTE_activation_transform.createSubscriberAcct(cleanForm);
        Account outputList = Service_LTE_activation_transform.createPlatformAcct(cleanForm, subscriberAcct );
        Asset domeAssetOutPut = Service_LTE_activation_transform.moveAssets(cleanForm, subscriberAcct );
        test.stopTest();
        
        list<Case> theCase = [SELECT Id, Subject  FROM case WHERE Subject like '%exception%' LIMIT 1 ];
        serviceResults log = Service_LTE_activation_transform.getLog();
        //Asserts
        system.assertEquals(0, theCase.size());
        system.assert(log.success);
        system.assert(log.message.contains('METHOD_EXIT'), log);
        system.assert(log.message.contains('|Asset with Id: ' ), log);
        
    }
    
    
    
    
    static testMethod void test_moveAssets_FAIL(){
        Asset domeAsset = new Asset();
        LTE_Activation__c cleanForm = new LTE_Activation__c();
        Account subscriberAcct = new Account();
        
        test.startTest();
        Asset domeAssetOutPut = Service_LTE_activation_transform.moveAssets(cleanForm, subscriberAcct );
        test.stopTest();
        
        serviceResults log = Service_LTE_activation_transform.getLog();
        //Asserts
        system.assertEquals('System Generated', log.srCase.Origin);
        system.assertEquals(false, log.success);
        system.assert(log.message.contains('FATAL_ERROR'), log);
        system.assert(log.message.contains('LTE moveAssets method failed'), log);
        
    }
    static testMethod void test_moveSubscriberContact(){
        LTE_Activation__c cleanForm = [ SELECT Id, Billing_Address__c, Subscriber_Address__c,Agreed_to_Receive_Texts__c,Antenna_Serial_No__c, Billing_City__c,  
                                       Subscriber_City__c,Billing_Company_Name__c, Contact_1_Company_Name__c,Contact_2_Company_Name__c,
                                       Onboard_Company_Name__c, Subscriber_Company_Name__c, Contact1_is_Authorized_Rep__c, Contact1_is_Billing_Point__c,
                                       Contact1_is_Invoice_Recipient__c, Contact2_is_Authorized_Rep__c, Contact2_is_Billing_Point__c,Contact2_is_Invoice_Recipient__c, 
                                       Onboard_Contact_Name__c, Billing_Country__c, Contact_1_Country__c, Contact_2_Country__c,  Subscriber_Country__c ,
                                       Customer_Code__c, Billing_Email__c, 
                                       Contact_1_Email__c, Contact_2_Email__c,Market__c, Sector__c, Subscriber_Email__c, Flag__c,  
                                       IMO_Registration_No__c, Installer_Contact_Name__c,  Installer_Country__c, Installer_Information__c, Installer_Manufacture__c  ,  
                                       Installer_State_Province_Territory__c, Contact_1_Job_Title__c, Contact_2_Job_Title__c, Main_Contact_First_Name_Cont1__c, 
                                       Main_Contact_First_Name_Cont2__c,  Main_Contact_FirstName_Subscriber__c,  Main_Contact_FirstName_Billing__c,  
                                       Main_Contact_LastName_Billing__c, Main_Contact_LastName_Subscriber__c,  Main_Contact_Last_Name_Cont1__c,  Main_Contact_Last_Name_Cont2__c, 
                                       MMSI__c,  Primary_Name_on_Card__c, Secondary_Name_on_Card__c,  Onboard_Country__c,  Onboard_Email__c,  Onboard_Job_Title__c, 
                                       Onboard_Phone__c , Onboard_Role__c, Onboard_State_Province_Territory__c, Contact_1_Phone__c, Contact_2_Phone__c, Subscriber_Phone__c,
                                       Billing_Phone_No__c, Billing_Postal_Zip_Code__c, Subscriber_Postal_Zip_Code__c, Pre_activation_Date__c, Primary_CC_Exp_Date__c, 
                                       Primary_Credit_Card_No__c,Privacy_Policy_is_Accepted__c, Privacy_Policy_is_Accepted2__c, Privacy_Policy_is_Accepted3__c, 
                                       Promotional_Code__c,Purchased_From__c,Sim_Serial_No__c,
                                       Requested_Service_Start_Date__c, Contact_1_Role__c, Contact_2_Role__c, Secondary_CC_Exp_Date__c, 
                                       Secondary_Credit_Card_No__c, Billing_State_Province_Territory__c, Contact_1_State_Province__c, 
                                       Contact_2_State_Province_Territory__c, 
                                       Subscriber_State_Province_Territory__c, Subscriber_is_Billing_Point_of_Contact__c, 
                                       Subscriber_is_Invoice_recipient__c, Vessel_Length__c, Vessel_Name__c, Vessel_Type__c, Name, CurrencyIsoCode, Account__c,  Platform_Account__c
                                        , Billing_Account__c  ,   Contact__c,    Contract__c , Corporate_Billing_Account__c   ,Rate_Plan__c                                                 
                                       FROM LTE_Activation__c LIMIT 1
                                      ];
        Contact subscriberContact = new Contact();
 		subscriberContact = [SELECT Id, FirstName, LastName, LastModifiedDate,
                                 Email FROM Contact  Where Email =: cleanForm.Subscriber_Email__c AND FirstName =: cleanForm.Main_Contact_FirstName_Subscriber__c AND LastName =: cleanForm.Main_Contact_LastName_Subscriber__c ORDER BY LastModifiedDate LIMIT 1 ];

        
        
        
        test.startTest();
        Account subscriberAcct = Service_LTE_activation_transform.createSubscriberAcct(cleanForm);
        Account outputList = Service_LTE_activation_transform.createPlatformAcct(cleanForm, subscriberAcct );
        Asset domeAssetOutPut = Service_LTE_activation_transform.moveAssets(cleanForm, subscriberAcct );
        Contact subscriberContactOutPut = Service_LTE_activation_transform.moveSubscriberContact( CleanForm,  subscriberAcct);
        test.stopTest();
        
        list<Case> theCase = [SELECT Id, Subject  FROM case WHERE Subject like '%exception%' LIMIT 1 ];
        serviceResults log = Service_LTE_activation_transform.getLog();
        //Asserts
        system.assertEquals(0, theCase.size());
        system.assert(log.success);
        system.assert(log.message.contains('METHOD_EXIT'), log);
        system.assert(log.message.contains('|Asset with Id: ' ), log);
        
    }
    static testMethod void test_moveSubscriberContact_FAIL(){
        Lte_Activation__c cleanForm = new Lte_Activation__c();
        Account subscriberAcct = new Account();
        
        
        test.startTest();
        Contact subscriberContactOutPut = Service_LTE_activation_transform.moveSubscriberContact( CleanForm,  subscriberAcct);
        test.stopTest();
        
        serviceResults log = Service_LTE_activation_transform.getLog();
        //Asserts
        system.assertEquals('System Generated', log.srCase.Origin);
        system.assertEquals(false, log.success);
        system.assert(log.message.contains('FATAL_ERROR'), log);
        system.assert(log.message.contains('LTE moveSubscriberContact method failed'), log);
        
    }
    static testMethod void test_createBillingAcct(){
        LTE_Activation__c cleanForm = [ SELECT Id, Billing_Address__c, Subscriber_Address__c,Agreed_to_Receive_Texts__c,Antenna_Serial_No__c, Billing_City__c,  
                                       Subscriber_City__c,Billing_Company_Name__c, Contact_1_Company_Name__c,Contact_2_Company_Name__c,
                                       Onboard_Company_Name__c, Subscriber_Company_Name__c, Contact1_is_Authorized_Rep__c, Contact1_is_Billing_Point__c,
                                       Contact1_is_Invoice_Recipient__c, Contact2_is_Authorized_Rep__c, Contact2_is_Billing_Point__c,Contact2_is_Invoice_Recipient__c, 
                                       Onboard_Contact_Name__c, Billing_Country__c,Market__c, Sector__c, Contact_1_Country__c, Contact_2_Country__c,  Subscriber_Country__c ,
                                       Customer_Code__c, Billing_Email__c, 
                                       Contact_1_Email__c, Contact_2_Email__c, Subscriber_Email__c, Flag__c,  
                                       IMO_Registration_No__c, Installer_Contact_Name__c,  Installer_Country__c, Installer_Information__c, Installer_Manufacture__c  ,  
                                       Installer_State_Province_Territory__c, Contact_1_Job_Title__c, Contact_2_Job_Title__c, Main_Contact_First_Name_Cont1__c, 
                                       Main_Contact_First_Name_Cont2__c,  Main_Contact_FirstName_Subscriber__c,  Main_Contact_FirstName_Billing__c,  
                                       Main_Contact_LastName_Billing__c, Main_Contact_LastName_Subscriber__c,  Main_Contact_Last_Name_Cont1__c,  Main_Contact_Last_Name_Cont2__c, 
                                       MMSI__c,  Primary_Name_on_Card__c, Secondary_Name_on_Card__c,  Onboard_Country__c,  Onboard_Email__c,  Onboard_Job_Title__c, 
                                       Onboard_Phone__c , Onboard_Role__c, Onboard_State_Province_Territory__c, Contact_1_Phone__c, Contact_2_Phone__c, Subscriber_Phone__c,
                                       Billing_Phone_No__c, Billing_Postal_Zip_Code__c, Subscriber_Postal_Zip_Code__c, Pre_activation_Date__c, Primary_CC_Exp_Date__c, 
                                       Primary_Credit_Card_No__c,Privacy_Policy_is_Accepted__c, Privacy_Policy_is_Accepted2__c, Privacy_Policy_is_Accepted3__c, 
                                       Promotional_Code__c,Purchased_From__c,Sim_Serial_No__c,
                                       Requested_Service_Start_Date__c, Contact_1_Role__c, Contact_2_Role__c, Secondary_CC_Exp_Date__c, 
                                       Secondary_Credit_Card_No__c, Billing_State_Province_Territory__c, Contact_1_State_Province__c, 
                                       Contact_2_State_Province_Territory__c, 
                                       Subscriber_State_Province_Territory__c, Subscriber_is_Billing_Point_of_Contact__c, 
                                       Subscriber_is_Invoice_recipient__c, Vessel_Length__c, Vessel_Name__c, Vessel_Type__c, Name, CurrencyIsoCode, Account__c,  Platform_Account__c
                                        , Billing_Account__c  ,   Contact__c,    Contract__c , Corporate_Billing_Account__c     , Rate_Plan__c                                               
                                       FROM LTE_Activation__c LIMIT 1
                                      ];
        Contact subscriberContact = new Contact();
        subscriberContact = [SELECT Id, Name, 
                             Email FROM Contact  Where Email =: cleanForm.Subscriber_Email__c];
        Asset domeAsset = new Asset();
        domeAsset = [SELECT Id, SerialNumber, AccountId FROM Asset  Where Name =: cleanForm.Antenna_Serial_No__c];
        
        test.startTest();
        Account subscriberAcct = Service_LTE_activation_transform.createSubscriberAcct(cleanForm);
        Account outputList = Service_LTE_activation_transform.createPlatformAcct(cleanForm, subscriberAcct );
        Asset domeAssetOutPut = Service_LTE_activation_transform.moveAssets(cleanForm, subscriberAcct );
        Contact subscriberContactOutPut = Service_LTE_activation_transform.moveSubscriberContact( CleanForm,  subscriberAcct);
        Billing_Account__c billingAccOutPut = Service_LTE_activation_transform.createBillingAccount( CleanForm,  subscriberAcct);
        test.stopTest();
        
        list<Case> theCase = [SELECT Id, Subject  FROM case WHERE Subject like '%exception%' LIMIT 1 ];
        serviceResults log = Service_LTE_activation_transform.getLog();
        //Asserts
        system.assertEquals(0, theCase.size());
        system.assert(log.success);
        system.assert(log.message.contains('METHOD_EXIT'), log);
        system.assert(log.message.contains('|Billing Account with Id: ' ), log);
        
    }
    static testMethod void test_createBillingAcct_FAIL(){
        Asset domeAsset = new Asset();
        Contact subscriberContact = new Contact();
        Lte_Activation__c cleanForm = new Lte_Activation__c();
        Account subscriberAcct = new Account();
        Account platformAcct = new Account();
        
        test.startTest();
        Billing_Account__c billingAccOutPut = Service_LTE_activation_transform.createBillingAccount( CleanForm,  subscriberAcct);
        test.stopTest();
        
        serviceResults log = Service_LTE_activation_transform.getLog();
        //Asserts
        system.assertEquals('System Generated', log.srCase.Origin);
        system.assertEquals(false, log.success);
        system.assert(log.message.contains('FATAL_ERROR'), log);
        system.assert(log.message.contains('LTE createBillingAccount method failed'), log);
        
    }
    static testMethod void test_createContract(){
        LTE_Activation__c cleanForm = [ SELECT Id, Billing_Address__c, Subscriber_Address__c,Agreed_to_Receive_Texts__c,Antenna_Serial_No__c, Billing_City__c,  
                                       Subscriber_City__c,Billing_Company_Name__c, Contact_1_Company_Name__c,Contact_2_Company_Name__c,
                                       Onboard_Company_Name__c, Subscriber_Company_Name__c, Contact1_is_Authorized_Rep__c, Contact1_is_Billing_Point__c,
                                       Contact1_is_Invoice_Recipient__c, Contact2_is_Authorized_Rep__c, Contact2_is_Billing_Point__c,Contact2_is_Invoice_Recipient__c, 
                                       Onboard_Contact_Name__c, Billing_Country__c, Contact_1_Country__c, Contact_2_Country__c,  Subscriber_Country__c ,
                                       Customer_Code__c, Billing_Email__c, 
                                       Contact_1_Email__c, Contact_2_Email__c,Market__c, Sector__c, Subscriber_Email__c, Flag__c,  
                                       IMO_Registration_No__c, Installer_Contact_Name__c,  Installer_Country__c, Installer_Information__c, Installer_Manufacture__c  ,  
                                       Installer_State_Province_Territory__c, Contact_1_Job_Title__c, Contact_2_Job_Title__c, Main_Contact_First_Name_Cont1__c, 
                                       Main_Contact_First_Name_Cont2__c,  Main_Contact_FirstName_Subscriber__c,  Main_Contact_FirstName_Billing__c,  
                                       Main_Contact_LastName_Billing__c, Main_Contact_LastName_Subscriber__c,  Main_Contact_Last_Name_Cont1__c,  Main_Contact_Last_Name_Cont2__c, 
                                       MMSI__c,  Primary_Name_on_Card__c, Secondary_Name_on_Card__c,  Onboard_Country__c,  Onboard_Email__c,  Onboard_Job_Title__c, 
                                       Onboard_Phone__c , Onboard_Role__c, Onboard_State_Province_Territory__c, Contact_1_Phone__c, Contact_2_Phone__c, Subscriber_Phone__c,
                                       Billing_Phone_No__c, Billing_Postal_Zip_Code__c, Subscriber_Postal_Zip_Code__c, Pre_activation_Date__c, Primary_CC_Exp_Date__c, 
                                       Primary_Credit_Card_No__c,Privacy_Policy_is_Accepted__c, Privacy_Policy_is_Accepted2__c, Privacy_Policy_is_Accepted3__c, 
                                       Promotional_Code__c,Purchased_From__c,Sim_Serial_No__c,
                                       Requested_Service_Start_Date__c, Contact_1_Role__c, Contact_2_Role__c, Secondary_CC_Exp_Date__c, 
                                       Secondary_Credit_Card_No__c, Billing_State_Province_Territory__c, Contact_1_State_Province__c, 
                                       Contact_2_State_Province_Territory__c, 
                                       Subscriber_State_Province_Territory__c, Subscriber_is_Billing_Point_of_Contact__c, 
                                       Subscriber_is_Invoice_recipient__c, Vessel_Length__c, Vessel_Name__c, Vessel_Type__c, Name, CurrencyIsoCode, Account__c,  Platform_Account__c
                                        , Billing_Account__c  ,   Contact__c,    Contract__c , Corporate_Billing_Account__c        , Rate_Plan__c                                            
                                       FROM LTE_Activation__c LIMIT 1
                                      ];
        Contact subscriberContact = new Contact();
        subscriberContact = [SELECT Id, Name, 
                             Email FROM Contact  Where Email =: cleanForm.Subscriber_Email__c];
        Asset domeAsset = new Asset();
        domeAsset = [SELECT Id, SerialNumber, AccountId FROM Asset  Where Name =: cleanForm.Antenna_Serial_No__c];
        
        test.startTest();
        Account subscriberAcct = Service_LTE_activation_transform.createSubscriberAcct(cleanForm);
        Account outputList = Service_LTE_activation_transform.createPlatformAcct(cleanForm, subscriberAcct );
        Asset domeAssetOutPut = Service_LTE_activation_transform.moveAssets(cleanForm, subscriberAcct );
        Contact subscriberContactOutPut = Service_LTE_activation_transform.moveSubscriberContact( CleanForm,  subscriberAcct);
        Billing_Account__c billingAccOutPut = Service_LTE_activation_transform.createBillingAccount( CleanForm,  subscriberAcct);
        Contract ContractOutPut = Service_LTE_activation_transform.createContract( cleanForm, subscriberAcct, outputList, billingAccOutPut);
        
        test.stopTest();
        
        list<Case> theCase = [SELECT Id, Subject  FROM case WHERE Subject like '%exception%' LIMIT 1 ];
        serviceResults log = Service_LTE_activation_transform.getLog();
        //Asserts
        system.assertEquals(0, theCase.size());
        system.assert(log.success);
        system.assert(log.message.contains('METHOD_EXIT'), log);
        system.assert(log.message.contains('|Contract with Id: ' ), log);
        
    }
    static testMethod void test_createContractFAIL(){
        Asset domeAsset = new Asset();
        Contact subscriberContact = new Contact();
        LTE_Activation__c cleanForm = new LTE_Activation__c();
        Account subscriberAcct = new Account();
        Account platformAcct = new Account();
        Billing_Account__c billingAcct = new Billing_Account__c();
        
        domeAsset.SerialNumber = '';
        subscriberContact.Email = '';
        domeAsset = [SELECT Id, SerialNumber, AccountId, Name FROM Asset  Where Name = '12344571234567'];
        
        test.startTest();
        Contract ContractOutPut = Service_LTE_activation_transform.createContract(cleanForm,subscriberAcct, platformAcct, billingAcct);
        test.stopTest();
        
        serviceResults log = Service_LTE_activation_transform.getLog();
        //Asserts
        system.assertEquals('System Generated', log.srCase.Origin);
        system.assertEquals(false, log.success);
        system.assert(log.message.contains('FATAL_ERROR'), log);
        system.assert(log.message.contains('LTE createContract method failed'), log);
        
    }
    static testMethod void test_createSubscription(){
        LTE_Activation__c cleanForm = [ SELECT Id, Billing_Address__c, Subscriber_Address__c,Agreed_to_Receive_Texts__c,Antenna_Serial_No__c, Billing_City__c,  
                                       Subscriber_City__c,Billing_Company_Name__c, Contact_1_Company_Name__c,Contact_2_Company_Name__c,
                                       Onboard_Company_Name__c, Subscriber_Company_Name__c, Contact1_is_Authorized_Rep__c, Contact1_is_Billing_Point__c,
                                       Contact1_is_Invoice_Recipient__c, Contact2_is_Authorized_Rep__c, Contact2_is_Billing_Point__c,Contact2_is_Invoice_Recipient__c, 
                                       Onboard_Contact_Name__c, Billing_Country__c,Market__c, Sector__c, Contact_1_Country__c, Contact_2_Country__c,  Subscriber_Country__c ,
                                       Customer_Code__c, Billing_Email__c, 
                                       Contact_1_Email__c, Contact_2_Email__c, Subscriber_Email__c, Flag__c,  
                                       IMO_Registration_No__c, Installer_Contact_Name__c,  Installer_Country__c, Installer_Information__c, Installer_Manufacture__c  ,  
                                       Installer_State_Province_Territory__c, Contact_1_Job_Title__c, Contact_2_Job_Title__c, Main_Contact_First_Name_Cont1__c, 
                                       Main_Contact_First_Name_Cont2__c,  Main_Contact_FirstName_Subscriber__c,  Main_Contact_FirstName_Billing__c,  
                                       Main_Contact_LastName_Billing__c, Main_Contact_LastName_Subscriber__c,  Main_Contact_Last_Name_Cont1__c,  Main_Contact_Last_Name_Cont2__c, 
                                       MMSI__c,  Primary_Name_on_Card__c, Secondary_Name_on_Card__c,  Onboard_Country__c,  Onboard_Email__c,  Onboard_Job_Title__c, 
                                       Onboard_Phone__c , Onboard_Role__c, Onboard_State_Province_Territory__c, Contact_1_Phone__c, Contact_2_Phone__c, Subscriber_Phone__c,
                                       Billing_Phone_No__c, Billing_Postal_Zip_Code__c, Subscriber_Postal_Zip_Code__c, Pre_activation_Date__c, Primary_CC_Exp_Date__c, 
                                       Primary_Credit_Card_No__c,Privacy_Policy_is_Accepted__c, Privacy_Policy_is_Accepted2__c, Privacy_Policy_is_Accepted3__c, 
                                       Promotional_Code__c,Purchased_From__c,Sim_Serial_No__c,
                                       Requested_Service_Start_Date__c, Contact_1_Role__c, Contact_2_Role__c, Secondary_CC_Exp_Date__c, 
                                       Secondary_Credit_Card_No__c, Billing_State_Province_Territory__c, Contact_1_State_Province__c, 
                                       Contact_2_State_Province_Territory__c, 
                                       Subscriber_State_Province_Territory__c, Subscriber_is_Billing_Point_of_Contact__c, 
                                       Subscriber_is_Invoice_recipient__c, Vessel_Length__c, Vessel_Name__c, Vessel_Type__c, Name, CurrencyIsoCode, Account__c,  Platform_Account__c
                                        , Billing_Account__c  ,   Contact__c,    Contract__c , Corporate_Billing_Account__c         , Rate_Plan__c                                           
                                       FROM LTE_Activation__c LIMIT 1
                                      ];
        Contact subscriberContact = new Contact();
        subscriberContact = [SELECT Id, Name, 
                             Email FROM Contact  Where Email =: cleanForm.Subscriber_Email__c];
        Asset domeAsset = new Asset();
        domeAsset = [SELECT Id, SerialNumber, AccountId FROM Asset  Where Name =: cleanForm.Antenna_Serial_No__c];
        
        test.startTest();
        Account subscriberAcct = Service_LTE_activation_transform.createSubscriberAcct(cleanForm);
        Account outputList = Service_LTE_activation_transform.createPlatformAcct(cleanForm, subscriberAcct );
        Asset domeAssetOutPut = Service_LTE_activation_transform.moveAssets(cleanForm, subscriberAcct );
        Contact subscriberContactOutPut = Service_LTE_activation_transform.moveSubscriberContact( CleanForm,  subscriberAcct);
        Billing_Account__c billingAccOutPut = Service_LTE_activation_transform.createBillingAccount( CleanForm,  subscriberAcct);
        Contract contractOutPut = Service_LTE_activation_transform.createContract(CleanForm,subscriberAcct, outputList, billingAccOutPut);
        SBQQ__Subscription__c theSubscription = Service_LTE_activation_transform.createSubscription(domeAssetOutPut, contractOutPut, cleanForm);
        test.stopTest();
        
        list<Case> theCase = [SELECT Id, Subject  FROM case WHERE Subject like '%exception%' LIMIT 1 ];
        serviceResults log = Service_LTE_activation_transform.getLog();
        //Asserts
        system.assertEquals(0, theCase.size());
        system.assert(log.success);
        system.assert(log.message.contains('METHOD_EXIT'), log);
        system.assert(log.message.contains('|Subscription with Id: ' ), log);
        
    }
    
    static testMethod void test_createSubscriptionFAIL(){
        Asset domeAsset = new Asset();
        Contact subscriberContact = new Contact();
        Contract dummyContract = new Contract();
        Account subscriberAcct = new Account();
        Account platformAcct = new Account();
        Billing_Account__c billingAcct = new Billing_Account__c();
        dummyContract = [SELECT Id FROM Contract WHERE Contract_Type__c = 'Airtime' ];
        lte_activation__c cleanForm = new lte_activation__c();
        domeAsset.SerialNumber = '';
        dummyContract.Contract_Type__c  ='';
        delete dummyContract;
        



        test.startTest();
        SBQQ__Subscription__c theSubscription = Service_LTE_activation_transform.createSubscription(domeAsset, dummyContract, cleanForm);
        test.stopTest();
        
        serviceResults log = Service_LTE_activation_transform.getLog();
        //Asserts
        system.assertEquals('System Generated', log.srCase.Origin);
        system.assertEquals(false, log.success);
        system.assert(log.message.contains('FATAL_ERROR'), log);
        system.assert(log.message.contains('LTE createSubscription method failed'), log);
        
    }
    
    // //isnt used anymore
    // static testMethod void test_createCase(){
    //     LTE_Activation__c cleanForm = [ SELECT Id, Billing_Address__c, Subscriber_Address__c,Agreed_to_Receive_Texts__c,Antenna_Serial_No__c, Billing_City__c,  
    //                                    Subscriber_City__c,Billing_Company_Name__c, Contact_1_Company_Name__c,Contact_2_Company_Name__c,
    //                                    Onboard_Company_Name__c, Subscriber_Company_Name__c, Contact1_is_Authorized_Rep__c, Contact1_is_Billing_Point__c,
    //                                    Contact1_is_Invoice_Recipient__c, Contact2_is_Authorized_Rep__c, Contact2_is_Billing_Point__c,Contact2_is_Invoice_Recipient__c, 
    //                                    Onboard_Contact_Name__c, Billing_Country__c,Market__c, Sector__c, Contact_1_Country__c, Contact_2_Country__c,  Subscriber_Country__c ,
    //                                    Customer_Code__c, Billing_Email__c, 
    //                                    Contact_1_Email__c, Contact_2_Email__c, Subscriber_Email__c, Flag__c,  
    //                                    IMO_Registration_No__c, Installer_Contact_Name__c,  Installer_Country__c, Installer_Information__c, Installer_Manufacture__c  ,  
    //                                    Installer_State_Province_Territory__c, Contact_1_Job_Title__c, Contact_2_Job_Title__c, Main_Contact_First_Name_Cont1__c, 
    //                                    Main_Contact_First_Name_Cont2__c,  Main_Contact_FirstName_Subscriber__c,  Main_Contact_FirstName_Billing__c,  
    //                                    Main_Contact_LastName_Billing__c, Main_Contact_LastName_Subscriber__c,  Main_Contact_Last_Name_Cont1__c,  Main_Contact_Last_Name_Cont2__c, 
    //                                    MMSI__c,  Primary_Name_on_Card__c, Secondary_Name_on_Card__c,  Onboard_Country__c,  Onboard_Email__c,  Onboard_Job_Title__c, 
    //                                    Onboard_Phone__c , Onboard_Role__c, Onboard_State_Province_Territory__c, Contact_1_Phone__c, Contact_2_Phone__c, Subscriber_Phone__c,
    //                                    Billing_Phone_No__c, Billing_Postal_Zip_Code__c, Subscriber_Postal_Zip_Code__c, Pre_activation_Date__c, Primary_CC_Exp_Date__c, 
    //                                    Primary_Credit_Card_No__c,Privacy_Policy_is_Accepted__c, Privacy_Policy_is_Accepted2__c, Privacy_Policy_is_Accepted3__c, 
    //                                    Promotional_Code__c,Purchased_From__c,Sim_Serial_No__c,
    //                                    Requested_Service_Start_Date__c, Contact_1_Role__c, Contact_2_Role__c, Secondary_CC_Exp_Date__c, 
    //                                    Secondary_Credit_Card_No__c, Billing_State_Province_Territory__c, Contact_1_State_Province__c, 
    //                                    Contact_2_State_Province_Territory__c, 
    //                                    Subscriber_State_Province_Territory__c, Subscriber_is_Billing_Point_of_Contact__c, 
    //                                    Subscriber_is_Invoice_recipient__c, Vessel_Length__c, Vessel_Name__c, Vessel_Type__c, Name, CurrencyIsoCode, Account__c,  Platform_Account__c
    //                                     , Billing_Account__c  ,   Contact__c,    Contract__c , Corporate_Billing_Account__c                                                    
    //                                    FROM LTE_Activation__c LIMIT 1
    //                                   ];
    //     Contact subscriberContact = new Contact();
    //     subscriberContact = [SELECT Id, Name, 
    //                          Email FROM Contact  Where Email =: cleanForm.Subscriber_Email__c];
    //     Asset domeAsset = new Asset();
    //     domeAsset = [SELECT Id, SerialNumber, AccountId FROM Asset  Where Name =: cleanForm.Antenna_Serial_No__c];
        
    //     test.startTest();
    //     Account subscriberAcct = Service_LTE_activation_transform.createSubscriberAcct(cleanForm);
    //     Account outputList = Service_LTE_activation_transform.createPlatformAcct(cleanForm, subscriberAcct );
    //     Asset domeAssetOutPut = Service_LTE_activation_transform.moveAssets(cleanForm, subscriberAcct );
    //     Contact subscriberContactOutPut = Service_LTE_activation_transform.moveSubscriberContact( CleanForm,  subscriberAcct);
    //     Billing_Account__c billingAccOutPut = Service_LTE_activation_transform.createBillingAccount( CleanForm,  subscriberAcct);
    //     Contract contractOutPut = Service_LTE_activation_transform.createContract(cleanForm,subscriberAcct, outputList, billingAccOutPut);
    //     SBQQ__Subscription__c theSubscription = Service_LTE_activation_transform.createSubscription(domeAssetOutPut, contractOutPut, cleanForm );
    //     Case c = Service_LTE_activation_transform.updateCase(subscriberAcct, outputList,  billingAccOutPut, domeAssetOutPut,subscriberContact, contractOutPut);
        
    //     test.stopTest();
        
    //     list<Case> theCase = [SELECT Id, Subject  FROM case WHERE Subject like '%exception%' LIMIT 1 ];
    //     serviceResults log = Service_LTE_activation_transform.getLog();
    //     //Asserts
    //     system.assertEquals(0, theCase.size());
    //     system.assert(log.success);
    //     system.assert(log.message.contains('METHOD_EXIT'), log);
    //     system.assert(log.message.contains('|Case with Id: ' ), log);
        
    // }
    // // Isnt used anymore
    // static testMethod void test_createCaseFAIL(){
    //     Asset domeAsset = new Asset();
    //     Contact subscriberContact = new Contact();
    //     Contract dummyContract = new Contract();
    //     Account subscriberAcct = new Account();
    //     Account platformAcct = new Account();
    //     Billing_Account__c billingAcct = new Billing_Account__c();
    //     LTE_Activation__c rawForm = new LTE_Activation__c();
    //     dummyContract = [SELECT Id FROM Contract WHERE Contract_Type__c = 'Airtime' ];
        
        
    //     case c = new case();
    //     c =  [SELECT Id,AccountId,LTE_Transform_Status__c,AssetId,Billing_Account__c,Platform_Asset_Account__c,Subject, ContactId,Description, Contract__c FROM case  LIMIT 1];
        
        
        
        
    //     test.startTest();

    //     c = Service_LTE_activation_transform.updateCase(subscriberAcct, platformAcct,  billingAcct, domeAsset,subscriberContact, dummyContract);
    //     test.stopTest();
        
    //     serviceResults log = Service_LTE_activation_transform.getLog();
    //     //Asserts
    //     //system.assertEquals('System Generated', log.srCase.Origin);
    //     //system.assertEquals(false, log.success);
    //     //system.assert(log.message.contains('FATAL_ERROR'), log);
    //     //system.assert(log.message.contains('LTE updateCase method failed'), log);
        
    // }
    static testMethod void test_invokeProvisioning(){
     
        SBQQ__Subscription__c theSub = new SBQQ__Subscription__c(Id = 'a6k1B000000CrOi');
        //Id provisioningJob  =  system.enqueueJob(new Enqueue_Service_LTE_provisioining(theSub));
        test.startTest();
        Id provisioningJob = Service_LTE_activation_transform.invokeProvisioining(theSub);
        //See Salesforce known issue... this will return a Null in a test context.
        //https://success.salesforce.com/issues_view?id=a1p300000008XJvAAM&title=system-enqueuejob-returns-null-in-apex-tests
        test.stopTest();
        
        serviceResults log = Service_LTE_activation_transform.getLog();
        //Asserts
        AsyncApexJob job = [select Id, Status, NumberOfErrors from AsyncApexJob]; 
        System.assertEquals('Completed', job.Status); 
        System.assertEquals(0, job.NumberOfErrors); 
        //system.assertEquals('System Generated', log.srCase.Origin);
 
    }
    
    
    static testMethod void test_MainMethod(){
        LTE_Activation__c cleanForm = [ SELECT Id, Billing_Address__c, Subscriber_Address__c,Agreed_to_Receive_Texts__c,Antenna_Serial_No__c, Billing_City__c,  
                                       Subscriber_City__c,Billing_Company_Name__c, Contact_1_Company_Name__c,Contact_2_Company_Name__c,
                                       Onboard_Company_Name__c, Subscriber_Company_Name__c, Contact1_is_Authorized_Rep__c, Contact1_is_Billing_Point__c,
                                       Contact1_is_Invoice_Recipient__c, Contact2_is_Authorized_Rep__c, Contact2_is_Billing_Point__c,Contact2_is_Invoice_Recipient__c, 
                                       Onboard_Contact_Name__c, Billing_Country__c, Contact_1_Country__c, Contact_2_Country__c,  Subscriber_Country__c ,
                                       Customer_Code__c, Billing_Email__c, 
                                       Contact_1_Email__c, Contact_2_Email__c, Subscriber_Email__c, Flag__c,  
                                       IMO_Registration_No__c, Installer_Contact_Name__c,  Installer_Country__c, Installer_Information__c, Installer_Manufacture__c  ,  
                                       Installer_State_Province_Territory__c,Market__c, Sector__c, Contact_1_Job_Title__c, Contact_2_Job_Title__c, Main_Contact_First_Name_Cont1__c, 
                                       Main_Contact_First_Name_Cont2__c,  Main_Contact_FirstName_Subscriber__c,  Main_Contact_FirstName_Billing__c,  
                                       Main_Contact_LastName_Billing__c, Main_Contact_LastName_Subscriber__c,  Main_Contact_Last_Name_Cont1__c,  Main_Contact_Last_Name_Cont2__c, 
                                       MMSI__c,  Primary_Name_on_Card__c, Secondary_Name_on_Card__c,  Onboard_Country__c,  Onboard_Email__c,  Onboard_Job_Title__c, 
                                       Onboard_Phone__c , Onboard_Role__c, Onboard_State_Province_Territory__c, Contact_1_Phone__c, Contact_2_Phone__c, Subscriber_Phone__c,
                                       Billing_Phone_No__c, Billing_Postal_Zip_Code__c, Subscriber_Postal_Zip_Code__c, Pre_activation_Date__c, Primary_CC_Exp_Date__c, 
                                       Primary_Credit_Card_No__c,Privacy_Policy_is_Accepted__c, Privacy_Policy_is_Accepted2__c, Privacy_Policy_is_Accepted3__c, 
                                       Promotional_Code__c,Purchased_From__c,Sim_Serial_No__c,
                                       Requested_Service_Start_Date__c, Contact_1_Role__c, Contact_2_Role__c, Secondary_CC_Exp_Date__c, 
                                       Secondary_Credit_Card_No__c, Billing_State_Province_Territory__c, Contact_1_State_Province__c, 
                                       Contact_2_State_Province_Territory__c, 
                                       Subscriber_State_Province_Territory__c, Subscriber_is_Billing_Point_of_Contact__c, 
                                       Subscriber_is_Invoice_recipient__c, Vessel_Length__c, Vessel_Name__c, Vessel_Type__c, Name, CurrencyIsoCode, Account__c,  Platform_Account__c
                                        , Billing_Account__c  ,   Contact__c,    Contract__c , Corporate_Billing_Account__c                                                    
                                       FROM LTE_Activation__c LIMIT 1
                                      ];
        
        test.startTest();
        serviceResults results = Service_LTE_activation_transform.transformLTEActivationForm(cleanForm);    
        test.stopTest();
        
        list<Case> theCase = [SELECT Id, Subject  FROM case WHERE Subject like '%exception%' LIMIT 1 ];
        serviceResults log = Service_LTE_activation_transform.getLog();
        //Asserts
        system.assertEquals(0, theCase.size());
        system.assert(log.success);
        system.assert(log.message.contains('METHOD_EXIT'), log);
        system.assert(log.message.contains('|LTE provisioning process finished for: ' ), log);
        
    }
    
    static testMethod void test_addMyKVHRoleToUser_OK(){
      //need to add Custom Setting with a mock myKVH Role ID
      myKVH_new_User_Defaults__c insertCs = new myKVH_new_User_Defaults__c();
      insertCs.Name = 'DirectCustomerDefaults';
      insertCs.myKVH_Role_Id__c = 'a1l000000000000AAA';
      insertCs.SF_Profile_Id__c = '00e000000000000AAA'; //not used, but required for custom setting
      insert insertCs;
      //need to add User related to Contact.
      list<Contact> conList = new list<Contact>();
      conList = [SELECT Id, AccountId, Name FROM Contact];
      system.debug(conList);
      /*
      Profile PortalProf = new Profile();
      PortalProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Portal%' Limit 1];
      User admin = [SELECT Id, username FROM User 
                    WHERE Profile.name = 'System Administrator' 
                    AND isActive = true
                    LIMIT 1];
      system.debug(admin);
      system.runAs(admin){
        //site.createExternalUser()
        //Convert Contacts to Portal Users
        User tu = new User();
        tu.username = 'AccountAdmin.testUser@mock.user';
        tu.LastName = 'User1';
        tu.Email = 'AccountAdmin.testUser@mock.user';
        tu.Alias = 'AccAdm';
        tu.TimeZoneSidKey = 'America/New_York';
        tu.LocaleSidKey = 'en_US';
        tu.EmailEncodingKey = 'ISO-8859-1';
        tu.ProfileId = PortalProf.id;
        tu.LanguageLocaleKey = 'en_US';
        tu.ContactId = conList[0].Id; //must CREATE() user with Contact Id.....
        insert tu;
      }
      */
      test.startTest();
      User u = Service_LTE_activation_transform.addMyKVHRoleToUser(conList[0]);
      serviceResults log = Service_LTE_activation_transform.getLog();
      test.stopTest();
      User u2 = [SELECT Id, myKVH_Role__c, contactId FROM User WHERE Id =: u.Id LIMIT 1];
      system.assertEquals('a1l000000000000AAA', u2.myKVH_Role__c, log);
      system.assertEquals(conList[0].Id, u2.contactId);
    }
    static testMethod void test_addMyKVHRoleToUser_FAIL(){
      //need to add Custom Setting with a mock myKVH Role ID
      myKVH_new_User_Defaults__c insertCs = new myKVH_new_User_Defaults__c();
      insertCs.Name = 'DirectCustomerDefaults';
      insertCs.myKVH_Role_Id__c = 'a1l000000000000AAA';
      insertCs.SF_Profile_Id__c = '00e000000000000AAA'; //not used, but required for custom setting
      insert insertCs;
      //need to add Contact without a related User
      Contact c = new Contact(LastName = 'bad9', email = 'bad9@bad.com');
      insert c;
      test.startTest();
      User u = Service_LTE_activation_transform.addMyKVHRoleToUser(c);
      serviceResults log = Service_LTE_activation_transform.getLog();
      test.stopTest();
      system.assert(log.message.contains('Unable to isolate the Contact\'s User!'), log);
      system.assert(log.message.contains('Found 0 Users!'),log);
    }
}