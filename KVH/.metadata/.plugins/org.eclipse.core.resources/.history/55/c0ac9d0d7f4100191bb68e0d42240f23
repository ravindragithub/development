@isTest
private class REST_API_utilities_test {
    /* typical testClass statics...*/
    static integer MAX_LOOP_COUNTER = 4;
    private static final Id Billing_Account_RECORD_TYPE_ID = Schema.SObjectType.Billing_Account__c.getRecordTypeInfosByName().get('Customer CC Account').getRecordTypeId();
    private static final Id Account_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Customer').getRecordTypeId();
    private static final Profile PortalProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Portal%' Limit 1];
    private static final User adminUser = [SELECT Id, username FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
    
    @testSetup static void setupTestData(){
        //need An Account hierarchy, and an Asset...
        list<Billing_Account__c> testBAcctList = new list<Billing_Account__c>();
        Account acct = new Account();
        acct.Name = 'testingAccount';
        acct.BillingCountry = 'Spain';
        insert acct;
        map<String, Billing_Account__c> bacctMap = new map<String, Billing_Account__c>();
        for (integer i = 0; i < MAX_LOOP_COUNTER; i++){    //We need 2
            Billing_Account__c ba = new Billing_Account__c();
            integer myint = 100 + i;
            ba.Billing_Account_ID__c = myInt.format();
            ba.Name = 'Test REST API ' + i;
            ba.Account__c = acct.Id;
            testBAcctList.add(ba); 
            bacctMap.put(ba.Name, ba);
            system.debug(testBAcctList);
        }
        for(integer i = 0; i < MAX_LOOP_COUNTER; i++){
            Billing_Account__c r = new Billing_Account__c();
            r.name = i + 'Test REST API Platforms';
            r.Account__c = acct.Id;
            r.RecordTypeId = Billing_Account_RECORD_TYPE_ID;
            integer myint2 = 200 + i;
            r.Billing_Account_ID__c = myInt2.format();
            bacctMap.put(r.Name, r);
            testBAcctList.add(r);
        }
        insert testBAcctList;
        testBAcctList.clear();
        for (integer i = 0; i < MAX_LOOP_COUNTER; i++){
            Billing_Account__c top = bacctMap.get('Test REST API ' + i);
            Billing_Account__c bottom = bacctMap.get(i + 'Test REST API Platforms');
            testBAcctlist.add(bottom);
        }
        update testBAcctList;
        
        //Need some Assets...
        list<Asset> testAssetList = new list<Asset>();
        for(integer i = 0; i < MAX_LOOP_COUNTER; i++){
            Asset element = new Asset();
            element.Name = 'Test Asset ' + i;
            element.AccountId = acct.Id;
            testAssetList.add(element);
        }
        insert testAssetList;
        
        Contact c = new Contact();
        c.LastName = 'REST API test Contact';
        c.email = 'test_REST_API_utilities@kvh.com';
        c.AccountId = testBAcctList[0].Account__c;
        c.MailingCountry = 'Spain';
        insert c;
        
    }
    
    static testMethod void testSetupData(){
        list<Billing_Account__c> readList = new list<Billing_Account__c>();
        readList = [SELECT Id, Name, Account__c FROM Billing_Account__c];
        system.assertEquals(MAX_LOOP_COUNTER * 2, readList.size());
        for(Billing_Account__c a : readList){
            if(a.name.right(9) == 'Test REST'){ 
                system.assertNotEquals(a.Account__c, null);
            }
        }
        list<Asset> assetReadList = new list<Asset>();
        assetReadList = [SELECT Id, Name, AccountId FROM Asset];
        system.assertEquals(MAX_LOOP_COUNTER, assetReadList.size());
    }
    
    static testMethod void test_getBillingAcctObject_OK(){
        //test null return
        REST_API_utilities util = new REST_API_utilities();
        list<Asset> assetReadList = new list<Asset>();
        assetReadList = [SELECT Id FROM Asset LIMIT 1];
        Billing_Account__c a =  util.getBillingAccountObject(assetReadList[0]);
        system.assertEquals(a, null);
        //test positive return
        a = [SELECT id, Name FROM Billing_Account__c WHERE Name = 'Test REST API 0' LIMIT 1];
        a.Billing_Account_ID__c = '6666';
        a.Account_Effective_Date__c = Date.today();
        a.Revenue_Category__c = 'VSAT';
        update a;
        Account acc = new Account();
        acc.Name = 'testaccount1234';
        acc.BillingCountry = 'Spain';
        acc.RecordTypeId = Account_RECORD_TYPE_ID;
        insert acc;
        Contract testcontract = new Contract();
        Id Contract_RECORD_TYPE_ID = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Airtime Activation Service Contract').getRecordTypeId();
        testcontract.RecordTypeId = Contract_RECORD_TYPE_ID;
        testcontract.AccountId = acc.Id;
        testcontract.ContractTerm = 5;
        testcontract.StartDate = system.today();
        testcontract.Billing_Account__c = a.Id;
        insert testcontract;
        Product2 prod = new Product2();
        prod.Name = 'testproduct';
        insert prod;
        Contact con = [SELECT Id, LastName, email FROM Contact LIMIT 1];
        Asset x = new Asset();
        x.Name = 'Orphan Asset';
        x.ContactId = con.Id;
        x.AccountId = acc.Id;
        insert x;
        SBQQ__Subscription__c sub = new SBQQ__Subscription__c();
        sub.Asset__c = x.Id;
        sub.SBQQ__Account__c = acc.Id;
        sub.SBQQ__Contract__c = testcontract.Id;
        sub.SBQQ__Product__c = prod.Id;
        sub.SBQQ__Quantity__c = 1;
        insert sub;
        //test when no subscriptions
        Billing_Account__c b =  util.getBillingAccountObject(assetReadList[0]);
        system.assertEquals(null, b);
        //test with subscriptions
        Billing_Account__c c =  util.getBillingAccountObject(x);
        system.assertNotEquals(c, null);
        //test same response
        Billing_Account__c d =  util.getBillingAccountObject(x);
        system.assertEquals(a.id, d.id);
    }
    static testMethod void test_getBillingAcctObject_FAIL(){
        //test null return
        REST_API_utilities util = new REST_API_utilities();
        list<Asset> assetReadList = new list<Asset>();
        assetReadList = [SELECT Id FROM Asset LIMIT 1];
        Billing_Account__c a =  util.getBillingAccountObject(assetReadList[0]);
        system.assertEquals(a, null);
        //test positive return
        a = [SELECT id, Name FROM Billing_Account__c WHERE Name = 'Test REST API 0' LIMIT 1];
        a.Billing_Account_ID__c = '6666';
        a.Account_Effective_Date__c = Date.today();
        a.Revenue_Category__c = 'VSAT';
        update a;
        Account acc = new Account();
        acc.Name = 'testaccount1234';
        acc.BillingCountry = 'Spain';
        acc.RecordTypeId = Account_RECORD_TYPE_ID;
        insert acc;
        Contract testcontract = new Contract();
        Id Contract_RECORD_TYPE_ID = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Airtime Activation Service Contract').getRecordTypeId();
        testcontract.RecordTypeId = Contract_RECORD_TYPE_ID;
        testcontract.AccountId = acc.Id;
        testcontract.ContractTerm = 5;
        testcontract.StartDate = system.today();
        testcontract.Billing_Account__c = a.Id;
        insert testcontract;
        Product2 prod = new Product2();
        prod.Name = 'testproduct';
        insert prod;
        Contact con = [SELECT Id, LastName, email FROM Contact LIMIT 1];
        Asset x = new Asset();
        x.Name = 'Orphan Asset';
        x.ContactId = con.Id;
        x.AccountId = acc.Id;
        insert x;
        SBQQ__Subscription__c sub = new SBQQ__Subscription__c();
        sub.Asset__c = x.Id;
        sub.SBQQ__Account__c = acc.Id;
        sub.SBQQ__Contract__c = testcontract.Id;
        sub.SBQQ__Product__c = prod.Id;
        sub.SBQQ__Quantity__c = 1;
        sub.SBQQ__TerminatedDate__c = Date.today();
        insert sub;
        //test when no subscriptions
        Billing_Account__c b =  util.getBillingAccountObject(assetReadList[0]);
        system.assertEquals(null, b);
        //test with Terminated subscriptions
        Billing_Account__c c =  util.getBillingAccountObject(x);
        system.assertEquals(c, null);
    }
    static testMethod void testReturnCode() {
        // TO DO: implement unit test
        //test no paramater constructor...
        REST_API_utilities.resultCode rc = new REST_API_utilities.resultCode(); 
        rc.success = true;
        rc.exceptionMessage = 'Everything is cool';
        system.assert(rc.success);
        system.assertEquals('Everything is cool', rc.exceptionMessage);
        //test two parameter constructor...
        REST_API_utilities.resultCode rc2 = new REST_API_utilities.resultCode(false, 'Constructor test'); 
        system.assertEquals(false, rc2.success);
        system.assertEquals('Constructor test', rc2.exceptionMessage);
    }
}