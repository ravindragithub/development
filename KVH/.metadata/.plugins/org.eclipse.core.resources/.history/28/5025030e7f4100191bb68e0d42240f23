@isTest
private class REST_accounts_V2_test {
  //need a platform account (positive assertion)
  //and a not-a-platform account (negative assertion) 
  static {
    //Collect Record types from Org data
    RecordType PlatRecType = new RecordType();
    PlatRecType = [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName = 'Platform_Vessel_Maritime' LIMIT 1];
    RecordType CustRecType = new RecordType();
    CustRecType = [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName = 'Direct_Customer' LIMIT 1];
    system.debug('Record Type ID and Name:' + PlatRecType.Id + ' - ' + PlatRecType.DeveloperName);
    //Create a Platform Account and a 3 Direct Customer Accounts
    Account PlatformAcct = new Account(Name = 'TestAcct_Platform', RecordTypeId = PlatRecType.Id, BillingCountry = 'Platform');
    insert PlatformAcct;
    Account DirCustAcct = new Account(Name = 'TestAcct_Customer', RecordTypeId = CustRecType.Id, BillingCountry = 'Spain');
    insert DirCustAcct;
    Account DirCustAcct2 = new Account(Name = 'TestAcct_Customer2', myKVH_Parent_Account__c = DirCustAcct.Id, myKVH_Parent_Override__c = false, myKVH_Parent_Manual_Selection__c = DirCustAcct.Id, RecordTypeId = CustRecType.Id, BillingCountry = 'Spain');
    insert DirCustAcct2;
    Account DirCustAcct3 = new Account(Name = 'TestAcct_Customer3', myKVH_Parent_Account__c = DirCustAcct.Id, myKVH_Parent_Override__c = true, myKVH_Parent_Manual_Selection__c = DirCustAcct2.Id, RecordTypeId = CustRecType.Id, BillingCountry = 'Spain');
    insert DirCustAcct3;
    Contact testcontact = new Contact(LastName = 'Smith', MailingCountry = 'Spain', AccountId = DirCustAcct.Id);
    insert testcontact;
  }

    static testMethod void testDoGet() {
        // TO DO: implement unit test
    string instance = 'https://kvh.my.';
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
     
    req.requestURI = instance + 'salesforce.com/services/apexrest/V2/accounts/';  
    req.httpMethod = 'GET';
    RestContext.request = req;
    RestContext.response = res;
    //test to ensure an API call with no record ID returns an empty list
    List<Account> Accounts = new List<Account>();
    Accounts = REST_accounts_V2.doGet();
    System.assert(Accounts.isEmpty());
    
    //reset
    Accounts.clear();
    //test to ensure that API does not return Platforms.
    Account testAccount = new Account();
    testAccount = [SELECT Id, Name FROM Account WHERE Name = 'TestAcct_Platform' LIMIT 1]; //NOT a Customer!
    req.requestURI = instance + 'salesforce.com/services/apexrest/V1/platforms/' + testAccount.Id;  
    req.httpMethod = 'GET';
    RestContext.request = req;
    RestContext.response = res;
    Accounts = REST_accounts_V2.doGet(); //We shouldn't get anything back here....
    Integer size = Accounts.size();
    system.assertEquals(size, 0);
    system.assertEquals(res.statusCode, 404);
    
    //reset
    Accounts.clear();
    //test to ensure that API will return Customers.
    //Account testAccount = new Account();
    testAccount = [SELECT Id, Name FROM Account WHERE Name = 'TestAcct_Customer' LIMIT 1]; //A Customer!
    req.requestURI = instance + 'salesforce.com/services/apexrest/V2/accounts/' + testAccount.Id;  
    req.httpMethod = 'GET';
    RestContext.request = req;
    RestContext.response = res;
    Accounts = REST_accounts_V2.doGet(); //We should get 1 record back here....
    size = Accounts.size();
    system.assertEquals(size, 1);
        
    Accounts.clear();
    //test to check exception response for incorrect Id  
    testAccount = [SELECT Id, Name FROM Account WHERE Name = 'TestAcct_Customer' LIMIT 1];
    Contact testContact = new Contact();
    testContact = [SELECT Id, Name FROM Contact WHERE Name = 'Smith' LIMIT 1];
    req.requestURI = instance + 'salesforce.com/services/apexrest/V2/accounts/' + testcontact.Id; 
    req.httpMethod = 'GET';
    RestContext.request = req;
    RestContext.response = res;
    Accounts = REST_accounts_V2.doGet(); //There should be no accounts AND status code 400
    size = Accounts.size();
    system.assertEquals(size, 0);    
    system.assertEquals(res.statusCode, 400);
    }
    
    static testMethod void testmyKVHparent(){
    string instance = 'https://kvh.my.'; 
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    List<Account> Accounts = new List<Account>();
    Accounts.clear();
    //test to check exception response for incorrect Id  
    
    Account testAccount = [SELECT Id, Name FROM Account WHERE Name = 'TestAcct_Customer2' AND myKVH_Parent_Override__c = false LIMIT 1];
    req.requestURI = instance + 'salesforce.com/services/apexrest/V2/accounts/' + testAccount.Id; 
    req.httpMethod = 'GET';
    RestContext.request = req;
    RestContext.response = res;
    Accounts = REST_accounts_V2.doGet(); //There should be 1 account with original myKVH Parent
    Account myKVHtest = Accounts.get(0);
    system.assertEquals(myKVHtest.myKVH_Parent_Account__c, myKVHtest.myKVH_Parent_Automatic_Selection__c);
    
    Accounts.clear();
    //test to check exception response for incorrect Id  
    testAccount = [SELECT Id, Name FROM Account WHERE Name = 'TestAcct_Customer3' AND myKVH_Parent_Override__c = true LIMIT 1];
    req.requestURI = instance + 'salesforce.com/services/apexrest/V2/accounts/' + testAccount.Id; 
    req.httpMethod = 'GET';
    RestContext.request = req;
    RestContext.response = res;
    Accounts = REST_accounts_V2.doGet(); //There should be 1 account with new myKVH Parent
    myKVHtest = Accounts.get(0);
    system.assertNotEquals(myKVHtest.myKVH_Parent_Account__c, myKVHtest.myKVH_Parent_Automatic_Selection__c);

    }
}