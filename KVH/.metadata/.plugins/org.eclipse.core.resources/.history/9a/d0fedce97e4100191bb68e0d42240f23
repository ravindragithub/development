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
private class Act_Terms_Component_Controller_Test {
    
    @testSetup static void setupTestData(){
        
        SBQQ__QuoteTerm__c objSBQQQuoteTerm = New SBQQ__QuoteTerm__c();
        objSBQQQuoteTerm.SBQQ__Active__c = true;
        objSBQQQuoteTerm.SBQQ__ConditionsMet__c = 'Any';
        objSBQQQuoteTerm.SBQQ__PrintOrder__c = 1;
        insert objSBQQQuoteTerm;
        system.assert(objSBQQQuoteTerm != null);
        
        List<Activation_Terms__c> lstActivationTerms = New  List<Activation_Terms__c>();
        
        Activation_Terms__c objActivationTerms = New Activation_Terms__c();
        objActivationTerms.Term_Display_Order__c = 1;
        objActivationTerms.Reference_Name__c = 'Authorized_Representatives_Permissions';
        objActivationTerms.Page_Reference__c = 'Account_setup';
        objActivationTerms.Tab_Reference__c = 'Test Tab Name1';
        objActivationTerms.Quote_Term__c = objSBQQQuoteTerm.Id;
        lstActivationTerms.add(objActivationTerms);
        
        Activation_Terms__c objActivationTerms1 = New Activation_Terms__c();
        objActivationTerms1.Term_Display_Order__c = 2;
        objActivationTerms1.Reference_Name__c = 'Authorized_Representatives_Permissions';
        objActivationTerms1.Quote_Term__c = objSBQQQuoteTerm.Id;
        objActivationTerms1.Page_Reference__c = 'Account_setup';
        objActivationTerms1.Tab_Reference__c = 'Test Tab Name2'; 
        lstActivationTerms.add(objActivationTerms1);
        
        insert lstActivationTerms;
        system.assert(lstActivationTerms.size() == 2);
    }
    
    static testMethod void test_Act_Terms_Component_Controller(){
        Act_Terms_Component_Controller objActTermsComponentController = New Act_Terms_Component_Controller();
        objActTermsComponentController.setstrPageReferenceName('Account_setup');
        objActTermsComponentController.getstrPageReferenceName();
        system.assert(objActTermsComponentController.mapActivationTerms.size() == 1);
    }
}