@isTest
private class REST_activations_test {
    //setup testClass variables here. For example:
    //RecordType Ids
    private static final Id ServCloud_RECORD_TYPE_ID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Cloud').getRecordTypeId();
    private static final Id DIRECTCUSTOMER_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Customer').getRecordTypeId();
    private static final Id SERVICE_PRODUCT2_RECORD_TYPE_ID = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Service').getRecordTypeId();
    private static final Id TEST_PLATFORM_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Demo/Test/Monitor').getRecordTypeId();
    private static final Id CONTRACT_RECORD_TYPE_ID = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Airtime Activation Service Contract').getRecordTypeId();
    

	static testMethod void doGet_test() {
		//implement unit test
    string instance = ''; 
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    REST_activations.activation_response returnObj = new REST_activations.activation_response();

    req.requestURI = instance + 'salesforce.com/services/apexrest/V1/activations/';  
    req.httpMethod = 'GET';
    RestContext.request = req;
    RestContext.response = res;
    returnObj = REST_activations.doGet(); //We should get 1 billing account back here....
    system.assertEquals(0, returnObj.recordMap.size()); //do we even HAVE a record map?
    system.assertEquals(null, returnObj.resultCode.exceptionMessage); //do we even HAVE a message?
    system.assertEquals(null, returnObj.resultCode.success); //do we even HAVE a flag?
	}
	static testMethod void doPost_test() {
		//implement unit test
    string instance = ''; 
    LTE_Activation__c rawForm = [SELECT Id FROM LTE_Activation__c LIMIT 1];
    String JSONbody = '{"recordId":"' + rawForm.Id + '"}';
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    REST_activations.activation_response returnObj = new REST_activations.activation_response();

    req.requestURI = instance + 'salesforce.com/services/apexrest/V1/activations/';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueOf(JSONbody);
    RestContext.request = req;
    RestContext.response = res;
    returnObj = REST_activations.doPost(rawForm.Id); //We should get 1 billing account back here....
    system.assertNotEquals(null, returnObj.recordMap, returnObj); //do we even HAVE a record map?
    system.assertNotEquals(null, returnObj.resultCode.exceptionMessage, returnObj); //do we even HAVE a message?
    system.assertNotEquals(null, returnObj.resultCode.success, returnObj); //do we even HAVE a flag?
	}
  //Need to setup test data for Transform service....
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
        lteForm.Main_Contact_FirstName_Subscriber__c = 'Sub';
        lteForm.Main_Contact_First_Name_Cont1__c = 'Cont1';
        lteForm.Sim_Serial_No__c = '123456789';
        lteForm.Main_Contact_First_Name_Cont2__c = 'Cont2';
        lteForm.Main_Contact_LastName_Billing__c = 'Billingsly';
        lteForm.Main_Contact_LastName_Subscriber__c = 'Subsingly';
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
        lteForm.Vessel_Type__c = 'true';
        lteForm.Contact__c = testContact.Id;
        lteForm.Contact_email__c = 'egbneuigbe@gmail.com';
        insert lteForm;
        
        //reset governor limits
        test.startTest();
        
        //Set up asset data
        testAsset.Name = '12344571234567';
        testAsset.SerialNumber = '12344571234567';
        
        list<Product2> prodList = new list<Product2>();
        Product2 testProd = new Product2(Name='LTE20GB', 
                                         ProductCode='LTE20GB-C', 
                                         RecordTypeId=Service_Product2_RECORD_TYPE_ID);
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
        
        test.stopTest();
        /*
        //Dummy product
        Product2 dummyProduct = new Product2(Name = 'LTE20GB');
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
        */
        
        //insert rest
        
        
        //insert testAsset;
    }
    
    static testMethod void testSetupData(){
        // Test that your test data is setup correctly
        // It's probably just that one sObject...
        list<LTE_Activation__c> lteForms = new list<LTE_Activation__c>();
        lteForms = [SELECT Id, Name, Vessel_Name__c FROM LTE_Activation__c];
        system.assertEquals(1, lteForms.size());
        system.assertEquals('Titanic', lteForms[0].Vessel_Name__c);
    }
}