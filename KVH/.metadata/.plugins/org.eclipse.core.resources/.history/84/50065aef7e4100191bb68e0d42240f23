@isTest
private class BatchEbilllink_V2_test {

    static testMethod void testEbillBatch_V2() {
        Id corpRecordTypeId = Schema.SObjectType.Billing_Account__c.getRecordTypeInfosbyName().get('Corporate CC Account').getRecordTypeId();
        Id custRecordTypeId = Schema.SObjectType.Billing_Account__c.getRecordTypeInfosbyName().get('Customer CC Account').getRecordTypeId();
        
        
		Account WriteAcct = new Account();
		WriteAcct.Name = 'Test Account';
		WriteAcct.BillingCountry = 'Italy';
		insert WriteAcct;
        system.debug(WriteAcct.Id);
        
        Billing_Account__c corpBillAcct = new Billing_Account__c();
        corpBillAcct.Name = 'ABC321';
        corpBillAcct.RecordTypeId = corpRecordTypeId;
        corpBillAcct.Account__c = WriteAcct.Id;
        corpBillAcct.Billing_Account_ID__c = '000A';
        corpBillAcct.Account_Effective_Date__c = Date.today();
		corpBillAcct.Revenue_Category__c = 'VSAT';
        insert corpBillAcct;
        system.debug(corpBillAcct.Id);
        
		
		Billing_Account__c custBillAcct = new Billing_Account__c();
        custBillAcct.Name = 'ABC123';
		custBillAcct.RecordTypeId = custRecordTypeId;
        custBillAcct.Account__c = WriteAcct.Id;
        custBillAcct.Billing_Account_ID__c = '0000000A';
        custBillAcct.Account_Effective_Date__c = Date.today();
		custBillAcct.Revenue_Category__c = 'VSAT';
		insert custBillAcct;
        system.debug(custBillAcct.Id);
		
		Security__c ebill = new Security__c();
		ebill.Name = 'E-bill';
		ebill.Algorithm__c = 'SHA1';
		ebill.Key__c = 'BuTTeRCuP';
		insert ebill;
		
        Test.startTest();
        BatchEbilllink_V2 batch = new BatchEbilllink_V2();
		Id JobId = database.executeBatch(batch, 25);
		Test.stopTest();
		//make assertions here....
		
		//Positive Case
		Billing_Account__c ReadAcct = [SELECT Id, E_bill_URL__c FROM Billing_Account__c WHERE RecordTypeName__c = 'Customer CC Account' Limit 1];
		System.assert(String.isNotBlank(ReadAcct.E_bill_URL__c));
		
		//Negative Case
		Billing_Account__c ReadAcct2 = [SELECT Id, E_bill_URL__c FROM Billing_Account__c WHERE RecordTypeName__c = 'Corporate CC Account' Limit 1];
		System.assert(String.isBlank(ReadAcct2.E_bill_URL__c));
		}
}