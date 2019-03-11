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
Private Class ActivationAccountsController_test{
    private static final Id DirectPartner_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Partner').getRecordTypeId();
    private static final Id DirectCustomer_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Customer').getRecordTypeId();
    
    @testSetup static void setupTestData(){
        
        Account objAccountpartner = New Account(Name='Self Registered Mock', RecordTypeId = DirectPartner_RECORD_TYPE_ID);
        insert objAccountpartner;
        
        Account objAccountCustomer = New Account(Name='NOT Self Registered Mock1', RecordTypeId = DirectCustomer_RECORD_TYPE_ID, ParentId = objAccountpartner.Id);
        insert objAccountCustomer;
        
        Contact objContact = new Contact(AccountId =objAccountpartner.id,
                                         email = 'guest.user.9@example.com',
                                         LastName = 'Last Name',
                                         firstName = 'first Name',
                                         MailingCountry = 'Spain');
        insert objContact; 
        
        
        
        Billing_Account__c objBillingAccountCorporate = New Billing_Account__c();
        objBillingAccountCorporate.Account__c = objAccountCustomer.id;
        objBillingAccountCorporate.RecordTypeId = Schema.SObjectType.Billing_Account__c.getRecordTypeInfosByName().get('Corporate CC Account').getRecordTypeId();
        objBillingAccountCorporate.Billing_Account_ID__c = '1010';
        objBillingAccountCorporate.Main_Contact__c = objContact.id;
        insert objBillingAccountCorporate;
        
        Billing_Account__c objBillingAccountCustomer = New Billing_Account__c();
        objBillingAccountCustomer.Account__c = objAccountCustomer.id;
        objBillingAccountCustomer.Corporate_CC_Account_Name__c = objBillingAccountCorporate.id;
        objBillingAccountCustomer.RecordTypeId = Schema.SObjectType.Billing_Account__c.getRecordTypeInfosByName().get('Customer CC Account').getRecordTypeId();
        objBillingAccountCustomer.Billing_Account_ID__c = '10100';
		objBillingAccountCorporate.Main_Contact__c = objContact.id;
        insert objBillingAccountCustomer;
        
        Billing_Contact_Role__c objBillingContactRole = New Billing_Contact_Role__c();
        objBillingContactRole.Contact__c = objContact.Id;
        objBillingContactRole.Billing_Account__c = objBillingAccountCustomer.id;
        objBillingContactRole.Role_s__c = 'Authorized Representative';
        insert objBillingContactRole;
        Case newCase = new Case();
        newCase.Subject = 'test';
        newCase.Origin = 'Web';
        newCase.Status = 'New';
        newCase.ContactId = objContact.id;
        newCase.AccountId = objAccountCustomer.id;
        insert newCase; 
    }
    
    static testMethod void ActivationAccountsController_test(){
        Test.startTest();
        list<Contact> contactList = [SELECT Id, Name,AccountId FROM Contact LIMIT 1];
        list<Profile> CommunityProf = new list<Profile>();
        list<Account> acctList = [SELECT Id, Name, parentId FROM Account];
        CommunityProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Community Base%'];
        User guestUser = new User(LastName = 'guest user 9', 
                                  Username = 'guest.user.9@example.com', 
                                  CommunityNickname = 'nickname',
                                  Email = 'guest.user.9@example.com', 
                                  Alias = 'guestu9', 
                                  TimeZoneSidKey = 'GMT', 
                                  LocaleSidKey = 'en_GB', 
                                  EmailEncodingKey = 'ISO-8859-1',
                                  ProfileId = CommunityProf[0].id, 
                                  ContactId = contactList[0].Id,
                                  LanguageLocaleKey = 'en_US');
        insert guestUser;
        System.runAs(guestUser){
            Account objAccountCustomer = New Account(Name='NOT Self Registered Mock1', RecordTypeId = DirectCustomer_RECORD_TYPE_ID, ParentId = acctList[0].Id);
            insert objAccountCustomer;
            
            List<Billing_Account__c> lstBillingAccount = New List<Billing_Account__c>();
            Billing_Account__c objBillingAccountCorporate = New Billing_Account__c();
            objBillingAccountCorporate.Account__c = objAccountCustomer.id;
            objBillingAccountCorporate.RecordTypeId = Schema.SObjectType.Billing_Account__c.getRecordTypeInfosByName().get('Corporate CC Account').getRecordTypeId();
            objBillingAccountCorporate.Billing_Account_ID__c = '0110';
            objBillingAccountCorporate.Main_Contact__c = contactList[0].Id;
            lstBillingAccount.add(objBillingAccountCorporate);
            
            Billing_Account__c objBillingAccountCorporate1 = New Billing_Account__c();
            objBillingAccountCorporate1.Account__c = objAccountCustomer.id;
            objBillingAccountCorporate1.RecordTypeId = Schema.SObjectType.Billing_Account__c.getRecordTypeInfosByName().get('Corporate CC Account').getRecordTypeId();
            objBillingAccountCorporate1.Billing_Account_ID__c = '0111';
            objBillingAccountCorporate1.Main_Contact__c = contactList[0].Id;
            lstBillingAccount.add(objBillingAccountCorporate1);
            insert lstBillingAccount;
            
            List<Billing_Account__c> lstBillingAccount1 = New List<Billing_Account__c>();
            Billing_Account__c objBillingAccountCustomer = New Billing_Account__c();
            objBillingAccountCustomer.Account__c = objAccountCustomer.id;
            objBillingAccountCustomer.Corporate_CC_Account_Name__c = lstBillingAccount[0].id;
            objBillingAccountCustomer.RecordTypeId = Schema.SObjectType.Billing_Account__c.getRecordTypeInfosByName().get('Customer CC Account').getRecordTypeId();
            objBillingAccountCustomer.Billing_Account_ID__c = '0000';
            objBillingAccountCustomer.Main_Contact__c = contactList[0].Id;
            lstBillingAccount1.add(objBillingAccountCustomer);
            
            Billing_Account__c objBillingAccountCustomer1 = New Billing_Account__c();
            objBillingAccountCustomer1.Account__c = objAccountCustomer.id;
            objBillingAccountCustomer1.Corporate_CC_Account_Name__c = lstBillingAccount[0].id;
            objBillingAccountCustomer1.RecordTypeId = Schema.SObjectType.Billing_Account__c.getRecordTypeInfosByName().get('Customer CC Account').getRecordTypeId();
            objBillingAccountCustomer1.Billing_Account_ID__c = '0001';
            objBillingAccountCustomer1.Main_Contact__c = contactList[0].Id;
            lstBillingAccount1.add(objBillingAccountCustomer1);
            
            Billing_Account__c objBillingAccountCustomer2 = New Billing_Account__c();
            objBillingAccountCustomer2.Account__c = objAccountCustomer.id;
            objBillingAccountCustomer2.RecordTypeId = Schema.SObjectType.Billing_Account__c.getRecordTypeInfosByName().get('Customer CC Account').getRecordTypeId();
            objBillingAccountCustomer2.Billing_Account_ID__c = '0002';
            objBillingAccountCustomer2.Main_Contact__c = contactList[0].Id;
            lstBillingAccount1.add(objBillingAccountCustomer2);
            
            insert lstBillingAccount1;
            
            ActivationAccountsController objActivationAccountsController = new ActivationAccountsController();
            system.assertEquals(null, objActivationAccountsController.boolIsShowMsg);
            objActivationAccountsController.validatePopupOnload();
            objActivationAccountsController.validateRedirectionOnload();
            PageReference pageRef = page.Account_Setup;
            pageRef.getParameters().put('AccountId',acctList[0].Id);
            PageReference pageRef1 =  objActivationAccountsController.createNewActOrder();
            pageRef.getParameters().put('order',pageRef1.getParameters().get('order'));
            pageRef.getParameters().put('maincontactId',contactList[0].id);
            
            system.assertEquals(pageRef.getUrl(),pageRef1.getUrl());
            pageRef.getParameters().clear();
            pageRef.getParameters().put('accountType','corporate');
            Test.setCurrentPage(pageRef);
            PageReference pageRef2 =  objActivationAccountsController.createNewActOrder();
            
            delete lstBillingAccount;
            lstBillingAccount.clear(); // no corporate accounts!
            objActivationAccountsController = new ActivationAccountsController();
            //system.assertEquals(0, objActivationAccountsController.mapCorporateMapCustomerAccounts.size());
            //system.assertEquals(3, objActivationAccountsController.mapBillingCustomerAccounts.size());
        }
        
        ActivationAccountsController objActivationAccountsController1 = new ActivationAccountsController(); 
        system.assertEquals(null, objActivationAccountsController1.boolIsShowMsg);
        
        Test.stopTest();
    }
    static testMethod void ActivationAccountsMethod(){
        Test.startTest();
        list<Account> acctList = [SELECT Id, Name, parentId FROM Account];
        map<id,Account> mapAccount = new map<Id,Account>();
        for(Account A:acctList) mapAccount.put(A.id, A);
        ActivationAccountsController objActivationAccountsController = new ActivationAccountsController(); 
        case objCase = [SELECT Id FROM case limit 1];
        Billing_Account__c objBillingAccountCustomer2 = New Billing_Account__c();
        objBillingAccountCustomer2.Account__c = acctList[0].id;
        objBillingAccountCustomer2.RecordTypeId = Schema.SObjectType.Billing_Account__c.getRecordTypeInfosByName().get('Customer CC Account').getRecordTypeId();
        objBillingAccountCustomer2.Billing_Account_ID__c = '10002';
        insert objBillingAccountCustomer2;
        PageReference pageRef =  page.Account_Setup;
        pageRef.getParameters().put('caseID',objCase.id);
        Test.setCurrentPage(pageRef);
        objActivationAccountsController.validatePopupOnload();
        objActivationAccountsController.loadAccounts(mapAccount.keySet()); 
        objActivationAccountsController.createNewActOrderConditionType();
        objActivationAccountsController.validateRedirectionOnload(); 
        test.stopTest();
    }
}