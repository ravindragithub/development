/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestBatchCreateEbillHyperlink {

    static testMethod void testEbillBatch() {
		Account WriteAcct = new Account();
		WriteAcct.Name = 'Test Account';
		WriteAcct.Account_Type__c = 'Customer';
		WriteAcct.Custom_Call_Acct_ID__c = '999999';
		WriteAcct.Account_Effective_Date__c = Date.today();
		WriteAcct.Revenue_Category__c = 'VSAT';
		WriteAcct.BillingCountry = 'Italy';
		insert WriteAcct;
		
		Account WriteAcct2 = new Account();
		WriteAcct2.Name = 'Test Account';
		WriteAcct2.Account_Type__c = 'Corporate';
		WriteAcct2.Custom_Call_Acct_ID__c = '999';
		WriteAcct2.Account_Effective_Date__c = Date.today();
		WriteAcct2.Revenue_Category__c = 'VSAT';
		WriteAcct2.BillingCountry = 'Italy';
		insert WriteAcct2;
		
		Security__c ebill = new Security__c();
		ebill.Name = 'E-bill';
		ebill.Algorithm__c = 'SHA1';
		ebill.Key__c = 'BuTTeRCuP';
		insert ebill;
		
        Test.startTest();
        BatchCreateEbillHyperlink batch = new BatchCreateEbillHyperlink();
		Id JobId = database.executeBatch(batch, 25);
		Test.stopTest();
		//make assertions here....
		//Positive Case
		
		Account ReadAcct = [SELECT Id, Name, Custom_Call_Acct_ID__c, E_bill_URL__c FROM Account WHERE Account_Type__c = 'Customer' Limit 1];
		System.assert(String.isNotBlank(ReadAcct.E_bill_URL__c));
		
		//Negative Case
		Account ReadAcct2 = [SELECT Id, Name, Custom_Call_Acct_ID__c, E_bill_URL__c FROM Account WHERE Account_Type__c = 'Corporate' Limit 1];
		System.assert(String.isBlank(ReadAcct2.E_bill_URL__c));
		}
}