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
private class EK_Trigger_Test {


    static testMethod void TestAddressValidationTrigger_Test() {
        
        Account acct = new Account(Name='ek address verification acct');
        acct.BillingCountry='US';
        acct.BillingState='NY';
        insert acct;
        
         //setup a billing account
        Billing_Account__c objBillingAccountCorporate = New Billing_Account__c();
        objBillingAccountCorporate.Account__c = acct.id;
        objBillingAccountCorporate.RecordTypeId = Schema.SObjectType.Billing_Account__c.getRecordTypeInfosByName().get('Customer CC Account').getRecordTypeId();
        objBillingAccountCorporate.Billing_Account_ID__c = '00';
        insert objBillingAccountCorporate;
        System.assert(objBillingAccountCorporate != null); 
        
        address__c a1 = new address__c();
        a1.Billing_Account__c = objBillingAccountCorporate.Id;
        a1.country__c='Canada';
        a1.state__c='NB';
        a1.Account__c=acct.id;
        insert a1;
    }       
}