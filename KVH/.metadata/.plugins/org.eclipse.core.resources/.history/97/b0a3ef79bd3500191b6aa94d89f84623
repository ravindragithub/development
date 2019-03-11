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
private class Test_Batch_Update_myKVH_Element_Count {

    static testMethod void TestElementCounting() {
        // TO DO: implement unit test
        //Create 2 Accounts to act as myKVH Parents, send flag off on both
		Account WriteAcct = new Account();
		WriteAcct.Name = 'Positive Flag';
		WriteAcct.Account_Type__c = 'Customer';
		WriteAcct.Custom_Call_Acct_ID__c = '999999';
		WriteAcct.Account_Effective_Date__c = Date.today();
		WriteAcct.Revenue_Category__c = 'VSAT';
		WriteAcct.BillingCountry = 'Italy';
		WriteAcct.Send_to_myKVH_Physical__c = false;
		WriteAcct.Account_Status__c = 'Active';
		WriteAcct.myKVH_Element_Count__c = null;	//this should change to 1 after the run
		Database.Saveresult Parent1 = Database.insert(WriteAcct);
		
		Account WriteAcct2 = new Account();
		WriteAcct2.Name = 'Negative Flag';
		WriteAcct2.Account_Type__c = 'Customer';
		WriteAcct2.Custom_Call_Acct_ID__c = '999998';
		WriteAcct2.Account_Effective_Date__c = Date.today();
		WriteAcct2.Revenue_Category__c = 'VSAT';
		WriteAcct2.BillingCountry = 'Italy';
		WriteAcct2.Send_to_myKVH_Physical__c = false;
		WriteAcct2.Account_Status__c = 'Active';
		WriteAcct.myKVH_Element_Count__c = 1;	//this should change to null after the run
		Database.Saveresult Parent2 = Database.insert(WriteAcct2);
		
		Account WriteAcct3 = new Account();
		WriteAcct3.Name = 'Neutral Flag';
		WriteAcct3.Account_Type__c = 'Customer';
		WriteAcct3.Custom_Call_Acct_ID__c = '999997';
		WriteAcct3.Account_Effective_Date__c = Date.today();
		WriteAcct3.Revenue_Category__c = 'VSAT';
		WriteAcct3.BillingCountry = 'Italy';
		WriteAcct3.Send_to_myKVH_Physical__c = false;
		WriteAcct3.Account_Status__c = 'Active';
		WriteAcct.myKVH_Element_Count__c = 1;	//this should NOT change after the run
		Database.Saveresult Parent3 = Database.insert(WriteAcct3);
		
		//Need a KVH Product Family to aggregate on...
		KVH_Product_Family__c TestFamily = new KVH_Product_Family__c();
		TestFamily.Name = 'IP Adress';
		TestFamily.FCP_Element_Type__c = 'Terminal';
		Database.Saveresult Family1 = Database.insert(TestFamily);
		
		//Need a Product to base the Assets on...
		Product2 BaseProd = new Product2();
		BaseProd.Name = 'IP Address';
		BaseProd.KVH_Product_Family__c = Family1.getId();
		insert BaseProd;
		
		//Need a couple of Assets based on the Product
		Asset Element1 = new Asset();
		Element1.AccountId = Parent1.getId();
		Element1.Product2Id = BaseProd.Id;
		Element1.Name = '10.61.1.1';
		Element1.Date_Removed__c = null;
		insert Element1;

		Asset Element2 = new Asset();
		Element2.AccountId = Parent3.getId();
		Element2.Product2Id = BaseProd.Id;
		Element2.Name = '10.61.1.2';
		Element2.Date_Removed__c = null;
		insert Element2;
		//Run batch
		Test.startTest();
		Batch_Update_myKVH_Element_Count batch = new Batch_Update_myKVH_Element_Count();
		Id JobId = database.executeBatch(batch, 25);
		Test.stopTest();
		//make assertions here....
		//Assert that the Positive Flag has had it's count set to 1
		Account ReadAcct = [SELECT Id, Name, myKVH_Element_Count__c FROM Account 
							WHERE Name = 'Positive Flag' LIMIT 1];
		System.assert(ReadAcct.myKVH_Element_Count__c == 1);
		//Assert that the Negative Flag has had it's count set to null
		Account ReadAcct2 = [SELECT Id, Name, myKVH_Element_Count__c FROM Account 
							WHERE Name = 'Negative Flag' LIMIT 1];
		System.assert(ReadAcct2.myKVH_Element_Count__c == null);
		//Assert that the Neutral Flag has not had it's count changed
		Account ReadAcct3 = [SELECT Id, Name, myKVH_Element_Count__c FROM Account 
							WHERE Name = 'Neutral Flag' LIMIT 1];
		System.assert(ReadAcct3.myKVH_Element_Count__c == 1);
    }
}