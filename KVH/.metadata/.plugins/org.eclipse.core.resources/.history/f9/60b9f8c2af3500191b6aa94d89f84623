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
public class Address_Trigger_Handler_Test {
    private static final Id DirectPartner_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Partner').getRecordTypeId();
    private static final Id DirectCustomer_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Customer').getRecordTypeId();
    
    @testSetup static void setupTestData(){
        Account objAccountpartner = New Account(Name='Self Registered Mock', RecordTypeId = DirectPartner_RECORD_TYPE_ID);
        insert objAccountpartner;
        Account objAccountCustomer = New Account(Name='NOT Self Registered Mock1', RecordTypeId = DirectCustomer_RECORD_TYPE_ID, ParentId = objAccountpartner.Id);
        insert objAccountCustomer;
        
        Billing_Account__c objBillingAccountCustomer = New Billing_Account__c();
        objBillingAccountCustomer.Account__c = objAccountCustomer.id;
        objBillingAccountCustomer.RecordTypeId = Schema.SObjectType.Billing_Account__c.getRecordTypeInfosByName().get('Customer CC Account').getRecordTypeId();
        objBillingAccountCustomer.Billing_Account_ID__c = '0000';
        insert objBillingAccountCustomer;
    }
    
    private static testMethod void test_Address_Trigger_Handler(){
        Test.startTest();
        List<Billing_Account__c> lstBillingAccounts = New List<Billing_Account__c>();
        lstBillingAccounts =[SELECT Id,Account__c FROM Billing_Account__c LIMIT 1];
        Address__c objAddress = New Address__c();
        objAddress.Address_1__c = 'Address1';
        objAddress.Address_2__c = 'Address2';
        objAddress.Address_Type__c = 'Airtime Services Subscriber';
        objAddress.City__c = 'City';
        objAddress.ISO_3166_2_Code__c = 'US';
        objAddress.State__c = 'Rhode Island';
        objAddress.Billing_Account__c = lstBillingAccounts[0].Id;
        objAddress.Account__c = lstBillingAccounts[0].Account__c;
        insert objAddress;
        Address__c objAddress1 = New Address__c();
        objAddress1 = [SELECT Id, State_Province_ISO_Code__c, Country_ISO_Code_3166_3__c, State_ISO_Code__c FROM Address__c LIMIT 1];
        system.assertEquals('RI', objAddress1.State_Province_ISO_Code__c); 
        Test.stopTest();
    }
}