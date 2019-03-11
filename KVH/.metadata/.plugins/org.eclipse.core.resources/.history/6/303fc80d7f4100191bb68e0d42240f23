@isTest
private class REST_BillingAcct_test {
  //setup testClass variables here. For example:
  //RecordType Ids
  /*private static final Id Customer_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();*/
  private static final Id CustBA = Schema.SObjectType.Billing_Account__c.getRecordTypeInfosByName().get('Customer CC Account').getRecordTypeId();
  private static final Id AcctRT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Customer').getRecordTypeId();
  //A common Loop Counter for bulikification purposes
  /*private static final integer MAX_LOOP_COUNTER = 200;*/
  	
  @testSetup static void setupTestData(){
    //setup common test data here
    //Create a Billing Account and a Direct Customer Accounts
    Account DirCustAcct = new Account(Name = 'TestAcct_Customer', RecordTypeId = AcctRT, BillingCountry = 'Spain');
    insert DirCustAcct;
    Account DirCustAcct1 = new Account(Name = 'TestAcct_Customer1', RecordTypeId = AcctRT, BillingCountry = 'Spain');
    insert DirCustAcct1;
    Billing_Account__c billacct = new Billing_Account__c(Name = 'testbillingacct_cust', RecordTypeId = CustBA, Billing_Account_ID__c = 'xxxx', Account__c = DirCustAcct.Id);
    insert billacct;
    Billing_Account__c billacct2 = new Billing_Account__c(Name = 'testbillingacct_cust', RecordTypeId = CustBA, Billing_Account_ID__c = 'xxx1', Account__c = DirCustAcct.Id);
    insert billacct2;
	}

  static testMethod void testDoGet() {
    //implement unit test
    string instance = ''; 
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    List<Billing_Account__c> BillAccts = new List<Billing_Account__c>();

    //test to ensure that API returns a list of Billing Accounts for an Account sObject Type
    Account testAccount = new Account();
    testAccount = [SELECT Id, Name FROM Account WHERE Name = 'TestAcct_Customer' LIMIT 1]; 
    req.requestURI = instance + 'salesforce.com/services/apexrest/V1/billingacct/' + testAccount.Id;  
    req.httpMethod = 'GET';
    RestContext.request = req;
    RestContext.response = res;
    BillAccts = REST_BillingAcct.doGet(); //We should get 1 billing account back here....
    system.assertEquals(2, BillAccts.size());
    //system.assertEquals(200, res.statusCode);
    //reset
    BillAccts.clear();

    //test to ensure that API returns successfully with Valid Billing Account Id
    Billing_Account__c testBillAcct = new Billing_Account__c();
    testBillAcct = [SELECT Id, Name FROM Billing_Account__c WHERE Billing_Account_ID__c = 'xxx1' LIMIT 1]; 
    req.requestURI = instance + 'salesforce.com/services/apexrest/V1/billingacct/' + testBillAcct.Id;  
    req.httpMethod = 'GET';
    RestContext.request = req;
    RestContext.response = res;
    BillAccts = REST_BillingAcct.doGet();
    system.assertEquals(1, BillAccts.size(), testBillAcct);
    //system.assertEquals(res.statusCode, 200);
    //reset
    BillAccts.clear();

    //test to ensure an API call with no record ID returns an empty list
    req.requestURI = instance + 'salesforce.com/services/apexrest/V1/billingacct/';  
    req.httpMethod = 'GET';
    RestContext.request = req;
    RestContext.response = res;
    BillAccts = REST_BillingAcct.doGet();
    System.assert(BillAccts.isEmpty());
    System.assertEquals(400, res.statusCode);
    //reset
    BillAccts.clear();

    //test to ensure that API will return zero results with an invalid Id.
    Id testId = testBillAcct.Id;
    delete testBillAcct;
    req.requestURI = instance + 'salesforce.com/services/apexrest/V1/billingacct/' + testId;
    req.httpMethod = 'GET';
    RestContext.request = req;
    RestContext.response = res;
    BillAccts = REST_BillingAcct.doGet(); //We should get 1 record back here....
    system.assertEquals(0, BillAccts.size());
    //reset
    BillAccts.clear();

    //test to check search function 
    req.requestURI = instance + 'salesforce.com/services/apexrest/V1/installconfig/search';  
    req.httpMethod = 'GET';
    req.addParameter('customernumber', 'xxxx');
    RestContext.request = req;
    RestContext.response = res;
    //test to ensure an API call with a proper search param ID returns a list
    BillAccts = REST_BillingAcct.doGet();
    system.assertEquals(1, BillAccts.size());
    //Check contents
    system.assertEquals('xxxx', BillAccts[0].Billing_Account_ID__c);
    //reset
    BillAccts.clear();

    //test to check search function 
    req.requestURI = instance + 'salesforce.com/services/apexrest/V1/installconfig/search';  
    req.httpMethod = 'GET';
    RestContext.request = req;
    req.addParameter('customernumber', 'xxx1');
    RestContext.response = res;
    //test to ensure an API call with an incorrect search param ID returns an empty list
    BillAccts = REST_BillingAcct.doGet();
    system.assertEquals(0, BillAccts.size());
    }
}