@isTest
private class AgilePlan_ltgsvc_indicator_test {
	@testSetup static void setupTestData(){
		//setup common test data here
		//need an Account, a Contact, a Case, an Asset base on the isAgile Plan part number!
    Account testAccount = new Account(name='test');
    insert testAccount;
    Contact testContact = new Contact(lastname='testCont', AccountId=testAccount.Id);
    insert testContact;
    list<Product2> insertList = new list<Product2>();
    Product2 p1 = new Product2(ProductCode = '01-0283-15SP', Name='01-0283-15SP');
    insertList.add(p1);
    Product2 p2 = new Product2(ProductCode = '01-0283-15', Name='01-0283-15');
    insertList.add(p2);
    insert insertList;

    list<Asset> insertList2 = new list<Asset>();
    Asset a1 = new Asset(AccountId = testAccount.Id, Product2Id = p1.id, Name='testAsset');
    insertList2.add(a1);
    Asset a2 = new Asset(AccountId = testAccount.Id, Product2Id = p2.id, Name='testAsset2');
    insertList2.add(a2);
    insert insertList2;

    Case c = new Case(AccountId = testAccount.Id, ContactId=testContact.Id, AssetId=a1.Id);
    insert c;
	}
	
	static testMethod void testSetupData(){
		//use this method to validate that you have test data setup correctly
		//this will protect you from changes to workflow, process, and validation that break your test code!
    list<Case> activeCases = [SELECT Id, Asset.Is_AgilePlan__c FROM Case];
    system.assertEquals(1, activeCases.size());
    system.assertEquals(true, activeCases[0].Asset.Is_AgilePlan__c);
    list<Asset> readList = [SELECT Id, Is_AgilePlan__c, Product2.ProductCode FROM Asset];
    system.debug(readList);
	}
	
	static testMethod void myUnitTest() {
		// TO DO: implement unit test AFTER you have your test data all setup and verified as OK
    //verify positive case
    list<Case> activeCases = [SELECT Id, Asset.Is_AgilePlan__c FROM Case];
    system.debug('Positive Case: ' + activeCases);
    Boolean isRental = AgilePlan_ltgsvc_indicator.checkIsAgilePlan(activeCases[0].Id);
    system.assert(isRental);
    //update case.Asset
    Asset notRental = [SELECT Id, Name, Is_AgilePlan__c FROM Asset WHERE Name = 'testAsset2' LIMIT 1];
    system.assertEquals(false, notRental.Is_AgilePlan__c);
    activeCases[0].AssetId = notRental.Id;
    update activeCases;
    activeCases = [SELECT Id, Asset.Is_AgilePlan__c FROM Case];
    system.debug('Negative Case: ' + activeCases);
    isRental = AgilePlan_ltgsvc_indicator.checkIsAgilePlan(activeCases[0].Id);
    system.assertEquals(false, isRental);
    //verify negative case
	}
	
}