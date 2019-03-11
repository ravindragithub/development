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
private class test_UAccountShareButton {
    private static final Id Platform_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Demo/Test/Monitor').getRecordTypeId();
    private static final Id DirectCust_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Customer').getRecordTypeId();
    private static final User adminUser = [SELECT Id, username FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
    static final integer MAX_LOOP_COUNTER = 24;
    
    @testSetup static void setupTestData(){
        //We are going to need....
        //An Account hierarchy including Platform, DC (not sent to myKVH), DC Send to myKVH
        list<Account> testAccounts = new list<Account>();
        Account Level1 = new Account(Name = 'Level 1', RecordTypeId = DirectCust_RECORD_TYPE_ID, Send_to_myKVH_Physical__c = true);
        testAccounts.add(Level1);
        Account Level2a = new Account(Name = 'Level 2a', RecordTypeId = DirectCust_RECORD_TYPE_ID, Send_to_myKVH_Physical__c = false);
        testAccounts.add(Level2a);
        Account Level3a = new Account(Name = 'Level 3a', RecordTypeId = DirectCust_RECORD_TYPE_ID, Send_to_myKVH_Physical__c = false);
        testAccounts.add(Level3a);
        Account Level4a = new Account(Name = 'Level 4a', RecordTypeId = DirectCust_RECORD_TYPE_ID, Send_to_myKVH_Physical__c = false);
        testAccounts.add(Level4a);
        Account Level5a = new Account(Name = 'Level 5a', RecordTypeId = DirectCust_RECORD_TYPE_ID, Send_to_myKVH_Physical__c = false);
        testAccounts.add(Level5a);
        Account Level2b = new Account(Name = 'Level 2b', RecordTypeId = DirectCust_RECORD_TYPE_ID, Send_to_myKVH_Physical__c = true);
        testAccounts.add(Level2b);
        Account Platform1a = new Account(Name = 'Platform 1a', RecordTypeId = Platform_RECORD_TYPE_ID, Send_to_myKVH_Physical__c = true, myKVH_Element_Count__c = 1);
        testAccounts.add(Platform1a);
        Account Platform1b = new Account(Name = 'Platform 1b', RecordTypeId = Platform_RECORD_TYPE_ID, Send_to_myKVH_Physical__c = true, myKVH_Element_Count__c = 1);
        testAccounts.add(Platform1b);
        insert testAccounts;
        testAccounts.clear();
        
        Level2a.ParentId = Level1.Id;
        Level3a.ParentId = Level2a.Id;
        Level4a.ParentId = Level3a.Id;
        Level5a.ParentId = Level4a.Id;
        
        Platform1a.ParentId = Level2a.Id;
        Platform1b.ParentId = Level2b.Id;
        testAccounts.add(Level2a);
        testAccounts.add(Level3a);
        testAccounts.add(Level4a);
        testAccounts.add(Level5a);
        testAccounts.add(Level2b);
        testAccounts.add(Platform1a);
        testAccounts.add(Platform1b);
        update testAccounts;                //Account Hierarchy all set....
    }
    
    static testMethod void test_level_a_no_sharing(){
        Account a = [SELECT Id, Name, Apply_Custom_Sharing__c FROM Account WHERE Name = 'Level 1' LIMIT 1];
        test.startTest();           //start the test, and reset the SOQL limit
        system.debug('SOQL queries issued AFTER startTest(): ' + Limits.getQueries());
        string returnedString = UAccountShareButton.run(a.Id);
        test.stopTest();            //This is where the batch job actually runs!
        system.assertEquals('Apply Custom Sharing is set to false', returnedString);        
    }
    static testMethod void test_level_a(){
        Account a = [SELECT Id, Name, Apply_Custom_Sharing__c FROM Account WHERE Name = 'Level 1' LIMIT 1];
        a.Apply_Custom_Sharing__c = true;
        update a;
        test.startTest();           //start the test, and reset the SOQL limit
        system.debug('SOQL queries issued AFTER startTest(): ' + Limits.getQueries());
        string returnedString = UAccountShareButton.run(a.Id);
        test.stopTest();            //This is where the batch job actually runs!
        system.assertEquals('Done', returnedString.left(4));
    }
    static testMethod void test_level_b(){
        Account b = [SELECT Id, Name, Apply_Custom_Sharing__c FROM Account WHERE Name = 'Level 1' LIMIT 1];
        b.Apply_Custom_Sharing__c = true;
        update b;
        test.startTest();           //start the test, and reset the SOQL limit
        system.debug('SOQL queries issued AFTER startTest(): ' + Limits.getQueries());
        string returnedString = UAccountShareButton.run(b.Id);
        test.stopTest();            //This is where the batch job actually runs!
        system.assertEquals('Done', returnedString.left(4));
    }
    static testMethod void test_level_c(){
        Account c = [SELECT Id, Name, Apply_Custom_Sharing__c FROM Account WHERE Name = 'Level 1' LIMIT 1];
        c.Apply_Custom_Sharing__c = true;
        update c;
        test.startTest();           //start the test, and reset the SOQL limit
        system.debug('SOQL queries issued AFTER startTest(): ' + Limits.getQueries());
        string returnedString = UAccountShareButton.run(c.Id);
        test.stopTest();            //This is where the batch job actually runs!
        system.assertEquals('Done', returnedString.left(4));
    }
    static testMethod void test_level_d(){
        Account d = [SELECT Id, Name, Apply_Custom_Sharing__c FROM Account WHERE Name = 'Level 1' LIMIT 1];
        d.Apply_Custom_Sharing__c = true;
        update d;
        test.startTest();           //start the test, and reset the SOQL limit
        system.debug('SOQL queries issued AFTER startTest(): ' + Limits.getQueries());
        string returnedString = UAccountShareButton.run(d.Id);
        test.stopTest();            //This is where the batch job actually runs!
        system.assertEquals('Done', returnedString.left(4));
    }
    static testMethod void test_level_e(){
        Account e = [SELECT Id, Name, Apply_Custom_Sharing__c FROM Account WHERE Name = 'Level 1' LIMIT 1];
        e.Apply_Custom_Sharing__c = true;
        update e;
        test.startTest();           //start the test, and reset the SOQL limit
        system.debug('SOQL queries issued AFTER startTest(): ' + Limits.getQueries());
        string returnedString = UAccountShareButton.run(e.Id);
        test.stopTest();            //This is where the batch job actually runs!
        system.assertEquals('Done', returnedString.left(4));
    }
}