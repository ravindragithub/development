@isTest
private class REST_subscriptions_test {
  //setup testClass variables here. For example:
  //RecordType Ids
  private static final Id CustBA = Schema.SObjectType.Billing_Account__c.getRecordTypeInfosByName().get('Customer CC Account').getRecordTypeId();
  private static final Id airtimeContract = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Airtime Activation Service Contract').getRecordTypeId();
  private static final Id AcctRT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Customer').getRecordTypeId();
  private static final Id PlatRT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Leisure Vessel').getRecordTypeId();
  private static final Id IdentRT = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Identifier').getRecordTypeId();
  private static final Id ServRT = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Service').getRecordTypeId();
  //A common Loop Counter for bulikification purposes
  /*private static final integer MAX_LOOP_COUNTER = 200;*/

  @testSetup static void setupTestData(){
    //Need a couple of Product2 records...
    Product2 ipAddId = new Product2(Name = 'IP Address', ProductCode = 'IP Address', RecordTypeId = IdentRT);
    insert ipAddId;
    Product2 plan = new Product2(Name = 'OP2K', ProductCode = 'OP2K', RecordTypeId = ServRT, Data_Rate_Plan__c = true);
    insert plan;
    //Create a Billing Account and a Direct Customer Accounts
    list<Account> insertList = new list<Account>();
    Account DirCustAcct = new Account(Name = 'TestAcct_Customer', RecordTypeId = AcctRT, BillingCountry = 'Spain');
    insertList.add(DirCustAcct);
    Account plat = new Account(Name = 'testplat', BillingCountry = 'Platform', RecordTypeId = PlatRT);
    insertList.add(plat);
    Account DirCustAcct1 = new Account(Name = 'TestAcct_Customer1', RecordTypeId = AcctRT, BillingCountry = 'Spain');
    insertList.add(DirCustAcct1);
    insert insertList;
    //Need an Asset
    Asset ipadd = new Asset(Name = '10.61.qq.xx', AccountId = plat.Id, Product2Id = ipAddId.Id);
    insert ipadd;
    //Need a Billing Acct....
    Billing_Account__c billacct = new Billing_Account__c(Name = 'testbillingacct_cust', RecordTypeId = CustBA, Billing_Account_ID__c = 'xxxx', Account__c = DirCustAcct.Id);
    insert billacct;
    //Need a contract
    Contract cont = new Contract(RecordTypeId = airtimeContract, Installation__c = plat.Id, Billing_Account__c = billacct.Id, ContractTerm = 12, StartDate = system.today(), AccountId = DirCustAcct.Id);
    insert cont;
    //need a subscription
    SBQQ__Subscription__c sub = new SBQQ__Subscription__c( Asset__c = ipadd.Id, SBQQ__Product__c = plan.Id, SBQQ__Quantity__c = 1, SBQQ__Contract__c = cont.Id);
    insert sub;
  }
  static testMethod void testSetupData(){
    list<Product2> prodList = [SELECT Id, Name, ProductCode FROM Product2];
    system.assertEquals(2, prodList.size());
    list<Account> acctList = [SELECT Id, Name FROM Account];
    system.assertEquals(3, acctList.size());
    list<Asset> assList = [SELECT Id, Name FROM Asset];
    system.assertEquals(1, assList.size());
    list<Billing_Account__c> billAcctList = [SELECT Id, Name FROM Billing_Account__c];
    system.assertEquals(1, billAcctList.size());
    list<Contract> conList = [SELECT Id, Name FROM Contract];
    system.assertEquals(1, conList.size());
    list<SBQQ__Subscription__c> subList = [SELECT Id, Name FROM SBQQ__Subscription__c];
    system.assertEquals(1, subList.size());
  }
  static testMethod void testDoGet() {
    //implement unit test
    string instance = ''; 
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
     
    req.requestURI = instance + 'salesforce.com/services/apexrest/V1/subscriptions/';  
    req.httpMethod = 'GET';
    RestContext.request = req;
    RestContext.response = res;
    //test to ensure an API call with no record ID returns an empty list
    List<SBQQ__Subscription__c> subs = new List<SBQQ__Subscription__c>();
    subs = REST_subscriptions.doGet();
    System.assert(subs.isEmpty());
    System.assertEquals(400, res.statusCode);

    //reset
    subs.clear();
    req = new RestRequest();
    res = new RestResponse();
    //test to ensure that API does not return whe Id does not exist
    req.requestURI = instance + 'salesforce.com/services/apexrest/V1/subscriptions/a6k0m0000000000AAA';  
    req.httpMethod = 'GET';
    RestContext.request = req;
    RestContext.response = res;
    subs = REST_subscriptions.doGet(); //We should get no subscriptions back here....
    system.assert(subs.isEmpty());
    system.assertEquals(404, res.statusCode);

    //reset
    subs.clear();
    req = new RestRequest();
    res = new RestResponse();
    //test to ensure that API does not return for incorrect ID
    Account testAccount = new Account();
    testAccount = [SELECT Id, Name FROM Account WHERE Name = 'TestAcct_Customer' LIMIT 1]; 
    req.requestURI = instance + 'salesforce.com/services/apexrest/V1/subscriptions/' + testAccount.Id;  
    req.httpMethod = 'GET';
    RestContext.request = req;
    RestContext.response = res;
    subs = REST_subscriptions.doGet(); //We should get no subscriptions back here....
    system.assert(subs.isEmpty());
    system.assertEquals(400, res.statusCode);

    //reset
    subs.clear();
    req = new RestRequest();
    res = new RestResponse();
    //test to ensure that API returns for Asset/element
    Asset testAsset = new Asset();
    testAsset = [SELECT Id, Name FROM Asset WHERE Name = '10.61.qq.xx' LIMIT 1]; 
    system.debug(testAsset.Name);
    req.requestURI = instance + 'salesforce.com/services/apexrest/V1/subscriptions/search';
    req.addParameter('asset', testAsset.Name);
    req.httpMethod = 'GET';
    RestContext.request = req;
    RestContext.response = res;
    subs = REST_subscriptions.doGet(); //We should get 1 subscription
    system.assertEquals(1, subs.size());
    system.assertEquals(200, res.statusCode);

    //reset
    subs.clear();
    req = new RestRequest();
    res = new RestResponse();
    //test to ensure that API will return Subscriptions for Id.
    List<SBQQ__Subscription__c> testsubs = new List<SBQQ__Subscription__c>();
    testsubs = [SELECT Id FROM SBQQ__Subscription__c WHERE SBQQ__Quantity__c = 1];  
    req.requestURI = instance + 'salesforce.com/services/apexrest/V1/subscriptions/' + testsubs[0].Id;  
    req.httpMethod = 'GET';
    RestContext.request = req;
    RestContext.response = res;
    subs = REST_Subscriptions.doGet(); //We should get 1 record back here....
    system.assertEquals(1, subs.size());
    system.assertEquals(200, res.statusCode);

    //reset
    subs.clear();
    req = new RestRequest();
    res = new RestResponse();
    //test to ensure that API will return Subscriptions.
    req.requestURI = instance + 'salesforce.com/services/apexrest/V1/subscriptions/search';  
    req.httpMethod = 'GET';
    RestContext.request = req;
    RestContext.response = res;
    req.addParameter('customernumber', 'xxx1');
    subs = REST_Subscriptions.doGet(); //We should get no records back here....
    system.assertEquals(0, subs.size(), res);
    system.assertEquals(404, res.statusCode);

    //reset
    subs.clear();
    req = new RestRequest();
    res = new RestResponse();
    //test to check search function 
    req.requestURI = instance + 'salesforce.com/services/apexrest/V1/installconfig/search';  
    req.httpMethod = 'GET';
    req.addParameter('customernumber', 'xxxx');
    RestContext.request = req;
    RestContext.response = res;
    //test to ensure an API call with a proper search param ID returns a list
    subs = REST_Subscriptions.doGet();
    system.assertEquals(1, subs.size());
    system.assertEquals(200, res.statusCode, res);

    //reset
    subs.clear();
    req = new RestRequest();
    res = new RestResponse();
    //test to check search function 
    req.requestURI = instance + 'salesforce.com/services/apexrest/V1/installconfig/search';  
    req.httpMethod = 'GET';
    req.addParameter('customernumber', 'xxx1');
    RestContext.request = req;
    RestContext.response = res;
    //test to ensure an API call with an incorrect search param ID returns an empty list
    subs = REST_Subscriptions.doGet();
    system.assertEquals(0, subs.size());
    system.assertEquals(404, res.statusCode);

    //reset
    subs.clear();
    req = new RestRequest();
    res = new RestResponse();
    //test to ensure an API call with two search param ID returns correctly!
    req.requestURI = instance + 'salesforce.com/services/apexrest/V1/installconfig/search';  
    req.httpMethod = 'GET';
    req.addParameter('customernumber', 'xxxx');
    req.addParameter('asset', testAsset.Name);
    RestContext.request = req;
    RestContext.response = res;
    subs = REST_Subscriptions.doGet();
    system.assertEquals(1, subs.size());
    system.assertEquals(200, res.statusCode);
  }
}