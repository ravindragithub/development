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
private class TestBatchFlagmyKVHParentToSend {

    static testMethod void testParentFlagging() {
        // TO DO: implement unit test
        //Create 2 Accounts to act as myKVH Parents, send flag off on both
		Account WriteAcct = new Account();
		WriteAcct.Name = 'Positive Flag';
		WriteAcct.Account_Type__c = 'Corporate';
		WriteAcct.Custom_Call_Acct_ID__c = '998';
		WriteAcct.Account_Effective_Date__c = Date.today();
		WriteAcct.Revenue_Category__c = 'VSAT';
		WriteAcct.BillingCountry = 'Italy';
		WriteAcct.Send_to_myKVH_Physical__c = false;	//should change to true
		WriteAcct.Account_Status__c = 'Active';
		Database.Saveresult Parent1 = Database.insert(WriteAcct);
		
		Account WriteAcct2 = new Account();
		WriteAcct2.Name = 'Negative Flag';
		WriteAcct2.Account_Type__c = 'Corporate';
		WriteAcct2.Custom_Call_Acct_ID__c = '999';
		WriteAcct2.Account_Effective_Date__c = Date.today();
		WriteAcct2.Revenue_Category__c = 'VSAT';
		WriteAcct2.BillingCountry = 'Italy';
		WriteAcct2.Send_to_myKVH_Physical__c = true;	//should change to false...
		WriteAcct2.Account_Status__c = 'Active';
		Database.Saveresult Parent2 = Database.insert(WriteAcct2);

        //Create Accounts to "claim" on Account as a myKVH Parent
        Account WriteAcct3 = new Account();
		WriteAcct3.Name = 'Test Account';
		WriteAcct3.Account_Type__c = 'Customer';
		WriteAcct3.Custom_Call_Acct_ID__c = '999998';
		WriteAcct3.Account_Effective_Date__c = Date.today();
		WriteAcct3.Revenue_Category__c = 'VSAT';
		WriteAcct3.BillingCountry = 'Italy';
		WriteAcct3.Send_to_myKVH_Physical__c = false;
		WriteAcct3.Account_Status__c = 'Active';
		WriteAcct3.myKVH_Parent_Manual_Selection__c = Parent1.GetId();
		WriteAcct3.myKVH_Parent_Override__c = true;
		system.debug('Here it is ------------------------------>>>' + Parent1.getID());
		insert WriteAcct3;
		WriteAcct3.Name = 're-Test Account';
		update WriteAcct3;
		system.debug('Here it is ------------------------------>>>' + WriteAcct3.myKVH_Parent_Account__c);
		
		Account WriteAcct4 = new Account();
		WriteAcct4.Name = 'Test Account';
		WriteAcct4.Account_Type__c = 'Customer';
		WriteAcct4.Custom_Call_Acct_ID__c = '999997';
		WriteAcct4.Account_Effective_Date__c = Date.today();
		WriteAcct4.Revenue_Category__c = 'VSAT';
		WriteAcct4.BillingCountry = 'Italy';
		WriteAcct4.Send_to_myKVH_Physical__c = true;
		WriteAcct4.Account_Status__c = 'Active';
		//WriteAcct4.myKVH_Parent_Account__c = Parent1.getId();
		insert WriteAcct4;
		//Run batch
		Test.startTest();
		BatchFlagmyKVHParentToSend batch = new BatchFlagmyKVHParentToSend();
		Id JobId = database.executeBatch(batch);
		Test.stopTest();
		//make assertions here....
		//Assert that the "Claimed" parent has it's flag set
		Account ReadAcct = [SELECT Id, Name, Send_to_myKVH_Physical__c FROM Account 
							WHERE Name = 'Positive Flag' LIMIT 1];
		//System.assert(ReadAcct.Send_to_myKVH_Physical__c == true);
		//Assert that the unclaimed parent does not have it's flag set
		Account ReadAcct2 = [SELECT Id, Name, Send_to_myKVH_Physical__c FROM Account 
							WHERE Name = 'Negative Flag' LIMIT 1];
		System.assert(ReadAcct2.Send_to_myKVH_Physical__c == false);
	}
}