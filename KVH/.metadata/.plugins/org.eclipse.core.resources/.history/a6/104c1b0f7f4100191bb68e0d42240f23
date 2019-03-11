@isTest
private class REST_iccid_maps_test {
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
    //Need a few  of Product2 records...
    list<Product2> insertProds = new list<Product2>();
    Product2 sys = new Product2(Name = '01-0419', ProductCode = '01-0419');
    insertProds.add(sys);
    Product2 vtid = new Product2(Name = 'Virtual Terminal ID', ProductCode = 'Virtual Terminal ID', RecordTypeId = IdentRT);
    insertProds.add(vtid);
    Product2 dome = new Product2(Name = '02-2279', ProductCode = '02-2279');
    insertProds.add(dome);
    Product2 sim = new Product2(Name = '19-1035', ProductCode = '19-1035', RecordTypeId = IdentRT);
    insertProds.add(sim);
    Product2 modem = new Product2(Name = '19-1027', ProductCode = '19-1027');
    insertProds.add(modem);

    Product2 plan = new Product2(Name = 'OP2K', ProductCode = 'OP2K', RecordTypeId = ServRT, Data_Rate_Plan__c = true);
    insertProds.add(plan);
    insert insertProds;

    //Create a Billing Account and a Direct Customer Accounts
    list<Account> insertList = new list<Account>();
    Account DirCustAcct = new Account(Name = 'TestAcct_Customer', RecordTypeId = AcctRT, BillingCountry = 'Spain');
    insertList.add(DirCustAcct);
    Account plat = new Account(Name = 'testplat', BillingCountry = 'Platform', RecordTypeId = PlatRT);
    insertList.add(plat);
    Account DirCustAcct1 = new Account(Name = 'TestAcct_Customer1', RecordTypeId = AcctRT, BillingCountry = 'Spain');
    insertList.add(DirCustAcct1);
    insert insertList;

    //Need Assets, IN Hierarchies
    list<Asset> assetList = new list<Asset>();
    
    Asset system1 = new Asset(Name = '180402001', AccountId = plat.Id, Product2Id = sys.Id);
    assetList.add(system1);
    Asset dome1 = new Asset(Name = '180402002', AccountId = plat.Id, Product2Id = dome.Id);
    assetList.add(dome1);
    Asset vtid1 = new Asset(Name = '99991234-LTE', AccountId = plat.Id, Product2Id = vtid.Id);
    assetList.add(vtid1);
    Asset modem1 = new Asset(Name = '1234-BAD9-E505', AccountId = plat.Id, Product2Id = modem.Id);
    assetList.add(modem1);
    Asset sim1 = new Asset(Name = '12345467890123456789', AccountId = plat.Id, Product2Id = sim.Id);
    assetList.add(sim1);
    
    Asset system2 = new Asset(Name = '180402003', AccountId = plat.Id, Product2Id = sys.Id);
    assetList.add(system2);
    Asset dome2 = new Asset(Name = '180402004', AccountId = plat.Id, Product2Id = dome.Id);
    assetList.add(dome2);
    Asset vtid2 = new Asset(Name = '99991235-LTE', AccountId = plat.Id, Product2Id = vtid.Id);
    assetList.add(vtid2);
    Asset modem2 = new Asset(Name = '1234-BAD9-E506', AccountId = plat.Id, Product2Id = modem.Id);
    assetList.add(modem2);
    Asset sim2 = new Asset(Name = '9876543210987654321', AccountId = plat.Id, Product2Id = sim.Id);
    assetList.add(sim2);

    insert assetList;
    test.startTest();
    //now setup hierarchies
    dome1.Parent_Asset__c = system1.Id;
    vtid1.Parent_Asset__c = system1.Id;
    modem1.Parent_Asset__c = dome1.Id;
    sim1.Parent_Asset__c = dome1.Id;

    dome2.Parent_Asset__c = system2.Id;
    vtid2.Parent_Asset__c = system2.Id;
    modem2.Parent_Asset__c = dome2.Id;
    sim2.Parent_Asset__c = dome2.Id;
    update assetList;



    //Need a Billing Acct....
    Billing_Account__c billacct = new Billing_Account__c(Name = 'testbillingacct_cust', RecordTypeId = CustBA, Billing_Account_ID__c = 'xxxx', Account__c = DirCustAcct.Id);
    insert billacct;
    //Need a contract
    Contract cont = new Contract(RecordTypeId = airtimeContract, Installation__c = plat.Id, Billing_Account__c = billacct.Id, ContractTerm = 12, StartDate = system.today(), AccountId = DirCustAcct.Id);
    insert cont;
    //need a couple of subscriptions
    list<SBQQ__Subscription__c> insertSubs = new list<SBQQ__Subscription__c>();
    SBQQ__Subscription__c sub1 
      = new SBQQ__Subscription__c(Asset__c = vtid1.Id, SBQQ__Product__c = plan.Id, 
                                  SBQQ__Quantity__c = 1, SBQQ__Contract__c = cont.Id, 
                                  Traffic_Identifier__c = '99991234-11');
    insertSubs.add(sub1);
    SBQQ__Subscription__c sub2 
      = new SBQQ__Subscription__c(Asset__c = vtid2.Id, SBQQ__Product__c = plan.Id, 
                                  SBQQ__Quantity__c = 1, SBQQ__Contract__c = cont.Id, 
                                  Traffic_Identifier__c = '99991235-11');
    insertSubs.add(sub2);
    insert insertSubs;
    test.stopTest();
  }
  static testMethod void testSetupData(){
    test.startTest();
    list<Product2> prodList = [SELECT Id, Name, ProductCode FROM Product2];
    system.assertEquals(6, prodList.size());
    list<Account> acctList = [SELECT Id, Name FROM Account];
    system.assertEquals(3, acctList.size());
    list<Asset> assList = [SELECT Id, Name FROM Asset];
    system.assertEquals(10, assList.size());
    list<Billing_Account__c> billAcctList = [SELECT Id, Name FROM Billing_Account__c];
    system.assertEquals(1, billAcctList.size());
    list<Contract> conList = [SELECT Id, Name FROM Contract];
    system.assertEquals(1, conList.size());
    list<SBQQ__Subscription__c> subList = [SELECT Id, Name FROM SBQQ__Subscription__c];
    system.assertEquals(2, subList.size());
    test.stopTest();
  }
  static testMethod void test_doGet(){
    string instance = 'https://cs69.'; //ServCloud Sandbox
    //string instance = 'https://na19.'; //Production
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    //This test Class doesn't even really use a request URI... it calls the REST class directly
    req.requestURI = instance + 'salesforce.com/services/apexrest/V1/iccid_maps/';  
    req.httpMethod = 'GET';
    RestContext.request = req;
    RestContext.response = res;
    REST_iccid_maps.IccidMappings results = new REST_iccid_maps.IccidMappings();
    test.startTest();
    results = REST_iccid_maps.doGet();
    system.assertEquals(2,results.iccid_mappings.size());

    Asset deProvision = [SELECT Id, Name, Parent_Asset__c
                         FROM Asset
                         WHERE Name = '99991234-LTE'
                         LIMIT 1];
    deProvision.Parent_Asset__c = null;
    update deProvision;
    //reset
    results = new REST_iccid_maps.IccidMappings();
    results = REST_iccid_maps.doGet();
    system.assertEquals(1, results.iccid_mappings.size());
    system.debug(results.iccid_mappings);
    REST_iccid_maps.IccidMap resultsMap = results.iccid_mappings[0];
    system.assertEquals('9876543210987654321', resultsMap.iccid);
    system.assertEquals('99991235-11', resultsMap.traffic_id);
    test.stopTest();
  }
}