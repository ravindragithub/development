global class BatchEbilllink_V2 implements Database.Batchable<sObject> {
  global Database.Querylocator start(Database.BatchableContext context) {
    System.debug('Start');
    /*set the scope of the batch job to Billing Accounts that are Custom Call Customer Accounts only
      Maybe we want to limit the scope to active Accounts only*/
    return Database.getQueryLocator(
      [SELECT Name, Billing_Account_ID__c FROM Billing_Account__c WHERE RecordTypeName__c = 'Customer CC Account']);
  }
  
  global void execute(Database.BatchableContext context, List<sObject> scope) {
    System.debug('Executing');
    /*Create a "security" object to store the algorithm and pre-shared password/hash key
      and query for data*/
    Security__c ebill = new Security__c(); 
    List<Billing_Account__c> BillingAcct = new List<Billing_Account__c>();
    ebill = [SELECT Id, Algorithm__c, Key__c FROM Security__c WHERE Name='E-bill' Limit 1];
    /*Loop through the collection of Accounts (scope), generate the hash, and update the record
      Maybe the update should occur outside the loop....*/
    /*CAUTION: Max tested batch size = 25*/
    for(sObject rec : scope) {
      String Link ='https://www.myebill.com/index.asp?logon=autohash&id=';
      Billing_Account__c ba = (Billing_Account__c)rec;
      system.debug('Billing_Account__c: ' + ba.name + ' CCid: ' + ba.Billing_Account_ID__c);
      Link = Link + 'kvh' + ba.Billing_Account_ID__c + '&password=';
      Blob Hash = Crypto.generateDigest(ebill.Algorithm__c, Blob.valueOf(('000000'+ba.Billing_Account_ID__c).right(6) + ebill.Key__c));
      String HashString = (EncodingUtil.convertToHex(Hash));
      ba.E_bill_URL__c = Link + HashString;
      BillingAcct.add(ba);
    }
      update BillingAcct;
  }
  
  global void finish(Database.BatchableContext context) {
    System.Debug('Finish!');
  }
}