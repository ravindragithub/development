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
private class DB_CustomTestDataGeneratorTests {

// Test Account data generation.
    static testMethod void testAccountDataGeneration()
    {
        DB_CustomTestDataGenerator gen = new DB_CustomTestDataGenerator();
        Test.startTest();
        System.assert( gen.isSupportedType( Account.getSObjectType() ) );
        Account testAccount = (Account)gen.createTestData( Account.getSObjectType() );
        System.assertNotEquals( null, testAccount );
        System.assertNotEquals( null, testAccount.Name );
        // Optionally test other fields for expected values.
        Test.stopTest();
    }


    // Test Contact data generation.
    static testMethod void testContactDataGeneration()
    {
        DB_CustomTestDataGenerator gen = new DB_CustomTestDataGenerator();
        Test.startTest();
        System.assert( gen.isSupportedType( Contact.getSObjectType() ) );
        Contact testContact = (Contact)gen.createTestData( Contact.getSObjectType() );
        System.assertNotEquals( null, testContact );
        System.assertNotEquals( null, testContact.LastName );
        // Optionally test other fields for expected values.
        Test.stopTest();
    }


    // Test Lead data generation.
    static testMethod void testLeadDataGeneration()
    {
        DB_CustomTestDataGenerator gen = new DB_CustomTestDataGenerator();
        Test.startTest();
        System.assert( gen.isSupportedType( Lead.getSObjectType() ) );
        Lead testLead = (Lead)gen.createTestData( Lead.getSObjectType() );
        System.assertNotEquals( null, testLead );
        System.assertNotEquals( null, testLead.LastName );
        // Optionally test other fields for expected values.
        Test.stopTest();
    }
    
    // Test Asset data generation
    static testMEthod Void testAssetDataGeneration(){
    	DB_CustomTestDataGenerator gen = new DB_CustomTestDataGenerator();
        Test.startTest();
        System.assert( gen.isSupportedType( Asset.getSObjectType() ) );
        Asset testAsset = (Asset)gen.createTestData( Asset.getSObjectType() );
        System.assertNotEquals( null, testAsset );
        System.assertNotEquals( null, testAsset.Name );
        // Optionally test other fields for expected values.
        Test.stopTest();
    }
}