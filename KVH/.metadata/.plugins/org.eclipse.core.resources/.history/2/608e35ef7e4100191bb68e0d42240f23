global class BatchCreateEbillHyperlink implements Database.Batchable<sObject> {
	global Database.Querylocator start(Database.BatchableContext context) {
		System.debug('Start');
		/*set the scope of the batch job to Custom Call Customer Accounts only
		  Maybe we want to limit the scope to active Accounts only*/
		return Database.getQueryLocator(
			[SELECT Name, Custom_Call_Acct_ID__c FROM Account WHERE Account_Type__c = 'Customer']);
	}
	
	global void execute(Database.BatchableContext context, List<sObject> scope) {
		System.debug('Executing');
		/*Create a "security" object to store the algorithm and pre-shared password/hash key
		  and query for data*/
		Security__c ebill = new Security__c(); 
		ebill = [SELECT Id, Algorithm__c, Key__c FROM Security__c WHERE Name='E-bill' Limit 1];
		/*Loop through the collection of Accounts (scope), generate the hash, and update the record
		  Maybe the update should occur outside the loop....*/
		/*CAUTION: Max tested batch size = 25*/
		for(sObject rec : scope) {
			String Link ='https://www.myebill.com/index.asp?logon=autohash&id=';
			Account a = (Account)rec;
			system.debug('Account: ' + a.name + ' CCid: ' + a.Custom_Call_Acct_ID__c);
			Link = Link + 'kvh' + a.Custom_Call_Acct_ID__c + '&password=';
			Blob Hash = Crypto.generateDigest(ebill.Algorithm__c, Blob.valueOf(('000000'+a.Custom_Call_Acct_ID__c).right(6) + ebill.Key__c));
			String HashString = (EncodingUtil.convertToHex(Hash));
			a.E_bill_URL__c = Link + HashString;
			update a;
		}
	}
	
	global void finish(Database.BatchableContext context) {
		System.Debug('Finish!');
	}
}