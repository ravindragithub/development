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
private class Batch_IPMC_File_Services_Vessel_Ema_test {
    private static final integer MAX_LOOP_COUNTER = 4;
    private static final Id Platform_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Demo/Test/Monitor').getRecordTypeId();
    private static final Id Customer_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Customer').getRecordTypeId();
    private static final Id Service_RECORD_TYPE_ID = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Service').getRecordTypeId();
    @testSetup static void setupTestData(){
        //setup common test data here
        //Need Platforms, Assets, Contracted Services...
        Product2 testService = new Product2();
        testService.Name = 'FS1 Batch Test Service';
        testService.Family = 'File Services';
        testService.RecordTypeId = Service_RECORD_TYPE_ID;
        insert testService;
        
        Account testCustomer = new Account();
        testCustomer.Name = 'Test TOP Customer';
        testCustomer.RecordTypeID = Customer_RECORD_TYPE_ID;
        insert testCustomer;
        
        Contract kontrakt = new Contract();
        kontrakt.AccountId = testCustomer.Id;
        kontrakt.StartDate = date.today();
        kontrakt.ContractTerm = 12;
        insert kontrakt;
        
        list<Account> testAcctList = new list<Account>();
        for(integer i = 0; i < MAX_LOOP_COUNTER; i++){
            Account r = new Account();
            r.name = i + 'Batch Platforms';
            r.Vessel_Email__c = i + 'batch@kvh.com';
            r.RecordTypeId = Platform_RECORD_TYPE_ID;
            testAcctList.add(r);
        }
        insert testAcctList;
        //associate Assets and Contracts with Accounts...
        list<Asset> testAssets = new list<Asset>();
        for(Account a : [SELECT Id, Name FROM Account WHERE RecordTypeId =: Platform_RECORD_TYPE_ID]){
            Asset ia = new Asset();
            ia.AccountId = a.Id;
            ia.Name = a.Name + ' Asset';
            testAssets.add(ia);
        }
        insert testAssets;
        
        list<Contracted_Services__c> testSvcs = new list<Contracted_Services__c>();
        for(Asset a : [SELECT Id FROM Asset]){
            Contracted_Services__c cs = new Contracted_Services__c();
            cs.Service_Item__c = testService.Id;
            cs.Name = testService.Name;
            cs.Asset__c = a.Id;
            cs.Contract__c = kontrakt.Id;
            testSvcs.add(cs);
        }
        insert testSvcs;
    }
    static testMethod void testSetupData(){
        //use this method to validate that you have test data setup correctly
        list<Product2> readProds = [SELECT Id, Name FROM Product2 WHERE Name = 'FS1 Batch Test Service'];
        system.assertEquals(1, readProds.size());
        
        list<Account> readAccts = [SELECT Id, RecordType.DeveloperName FROM Account WHERE RecordTypeId =: Platform_RECORD_TYPE_ID];
        system.assertEquals(MAX_LOOP_COUNTER, readAccts.size());
        
        list<Asset> readAssets = [SELECT Id, Name, Account.Vessel_Email__c FROM Asset];
        system.assertEquals(MAX_LOOP_COUNTER, readAssets.size());
        for(Asset a : readAssets){
            system.assertNotEquals(null, a.Account.Vessel_Email__c);
        }
        
        list<Contracted_Services__c> readCS = [SELECT Id, Vessel_Email__c, Asset__r.Account.Vessel_email__c FROM Contracted_Services__c];
        system.assertEquals(MAX_LOOP_COUNTER, readCS.size());
        for(Contracted_Services__c c : readCS){
            system.debug('CS : ' + c.Vessel_Email__c + ' Vessel : ' + c.Asset__r.Account.Vessel_email__c);
            system.assertEquals(c.Vessel_Email__c, c.Asset__r.Account.Vessel_email__c);
        }
        
    }
    static testMethod void test_noChangesBatch() {
        // TO DO: implement unit test
        test.startTest();
        Batch_IPMC_File_Services_Vessel_Email b = new Batch_IPMC_File_Services_Vessel_Email();
        Database.ExecuteBatch(b);
        test.stopTest();
        //Verify output
        list<Contracted_Services__c> readCS = [SELECT Id, Vessel_Email__c, Asset__r.Account.Vessel_email__c FROM Contracted_Services__c];
        system.assertEquals(MAX_LOOP_COUNTER, readCS.size());
        for(Contracted_Services__c c : readCS){
            system.debug('CS : ' + c.Vessel_Email__c + ' Vessel : ' + c.Asset__r.Account.Vessel_email__c);
            system.assertEquals(c.Vessel_Email__c, c.Asset__r.Account.Vessel_email__c);
        }
    }
    
    static testMethod void test_changesBatch(){
        list<Account> updateAccounts = new list<Account>();
        for(Account a : [SELECT Id, Vessel_Email__c FROM Account WHERE RecordTypeId =: Platform_RECORD_TYPE_ID]){
            a.Vessel_Email__c = 'changed_' + a.Vessel_Email__c;
            updateAccounts.add(a);
        }
        update updateAccounts;
        //Verify input
        list<Contracted_Services__c> readCS = [SELECT Id, Vessel_Email__c, Asset__r.Account.Vessel_email__c FROM Contracted_Services__c];
        for(Contracted_Services__c c : readCS){
            //system.debug('CS : ' + c.Vessel_Email__c + ' Vessel : ' + c.Asset__r.Account.Vessel_email__c);
            system.assertNotEquals(c.Vessel_Email__c, c.Asset__r.Account.Vessel_email__c);
        }
        test.startTest();
        Batch_IPMC_File_Services_Vessel_Email b = new Batch_IPMC_File_Services_Vessel_Email();
        Database.ExecuteBatch(b);
        test.stopTest();
        //Verify output
        readCS.clear();
        readCS = [SELECT Id, Vessel_Email__c, Asset__r.Account.Vessel_email__c FROM Contracted_Services__c];
        for(Contracted_Services__c c : readCS){
            //system.debug('CS : ' + c.Vessel_Email__c + ' Vessel : ' + c.Asset__r.Account.Vessel_email__c);
            system.assertEquals(c.Vessel_Email__c, c.Asset__r.Account.Vessel_email__c);
        }
    }
}