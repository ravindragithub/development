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
Private Class Act_Subscriber_Handler_Test{
    
    @testSetup static void setupTestData(){
        Account Acc = new Account();
        Acc.name='Test';
        insert Acc;
        
        list<Contact> lstContact = new list<Contact>();
        Contact Con=new Contact();
        Con.LastName='TestConatct';
        Con.Inactive_Contact__c=false;
        Con.AccountId=Acc.Id;
        lstContact.add(Con); 
        
        Contact Con2=new Contact();
        Con2.LastName='TestConatct2';
        Con2.Inactive_Contact__c=false;
        Con2.AccountId=Acc.Id;
        lstContact.add(Con2);  
        
        Contact Con3=new Contact();
        Con3.LastName='TestConatct3';
        Con3.Inactive_Contact__c=false;
        Con3.AccountId=Acc.Id;
        lstContact.add(Con3);
        
        Contact Con4=new Contact();
        Con4.LastName='TestConatct3';
        Con4.Inactive_Contact__c=false;
        Con4.AccountId=Acc.Id;
        lstContact.add(Con4); 
        
        insert lstContact; 
        
        Billing_Account__c ObjBillingAccount = new Billing_Account__c();
        ObjBillingAccount.Name = 'TestBillingAccount';
        ObjBillingAccount.Account__c = Acc.Id;
        ObjBillingAccount.Billing_Contact__c = Con4.id;
        ObjBillingAccount.Bill_to__c = 'Corporate';
        ObjBillingAccount.Corp_Duplicate__c = 'No';
        insert ObjBillingAccount;
        
        Billing_Contact_Role__c ObjBillingContactRole = new Billing_Contact_Role__c();
        ObjBillingContactRole.contact__c = Con3.Id;
        ObjBillingContactRole.Billing_Account__c = ObjBillingAccount.id;
        ObjBillingContactRole.Role_s__c = 'Airtime Invoice Recipient';
        insert ObjBillingContactRole;
        
        list<AccountContactRole> lstAccountContactRole = new list<AccountContactRole>();
        AccountContactRole AccConRole1= new AccountContactRole();
        AccConRole1.AccountId=Acc.Id;
        AccConRole1.ContactId=Con.Id;
        AccConRole1.Role ='Airtime Main Contact';
        lstAccountContactRole.add(AccConRole1);
        
        AccountContactRole AccConRole2= new AccountContactRole();
        AccConRole2.AccountId=Acc.Id;
        AccConRole2.ContactId=Con2.Id;
        AccConRole2.Role ='Authorized Representative';
        lstAccountContactRole.add(AccConRole2);
        
        AccountContactRole AccConRole3= new AccountContactRole();
        AccConRole3.AccountId=Acc.Id;
        AccConRole3.ContactId=Con2.Id;
        AccConRole3.Role ='Airtime Main Contact';
        lstAccountContactRole.add(AccConRole3);
        insert lstAccountContactRole;
        
        list<Activation_Order__c> lstActivationOrder = new list<Activation_Order__c>();
        Activation_Order__c testActOrder = new Activation_Order__c();
        testActOrder.isSelf_Activation__c = true;
        testActOrder.User_Agent_String__c = 'test User-Agent string';
        lstActivationOrder.add(testActOrder);
        
         Activation_Order__c testActOrder2 = new Activation_Order__c();
        testActOrder2.isSelf_Activation__c = true;
        testActOrder2.User_Agent_String__c = 'test User-Agent string';
        lstActivationOrder.add(testActOrder2);
        insert lstActivationOrder;
        
        Activation_Status__c testOrderStatus = new Activation_Status__c();
        testOrderStatus.Activation_Order__c = testActOrder.Id;
        testOrderStatus.Account_Setup_Active_Tab__c = 'Not_Invoicing_Preferences';
        insert testOrderStatus;
        
        Activation_Contact__c actcon = new Activation_Contact__c();
        actcon.Activation_Order__c = testActOrder.id;
        actcon.Email__c = 'test@4Test.com';
        actcon.Contact_Role__c = 'Main Contact';
        insert actcon;
		
        list<Activation_Subscriber__c> lstSubscriber = new list<Activation_Subscriber__c>();
        Activation_Subscriber__c objActivationSubscriber = New Activation_Subscriber__c();
        objActivationSubscriber.Subscriber_Contact_First_Name__c = 'First';
        objActivationSubscriber.Subscribing_Company__c = 'Company';
        objActivationSubscriber.Address__c = '123 Street St.';
        objActivationSubscriber.Country__c = 'US';
        objActivationSubscriber.Postal_Zip_Code__c = '02842';
        objActivationSubscriber.Subscriber_Mobile_Phone__c = '401-555-1212';
        objActivationSubscriber.Subscriber_Contact_Name__c = 'Last';
        objActivationSubscriber.Subscriber_Email__c = 'first@last.com';
        objActivationSubscriber.City__c = 'Middletown';
        objActivationSubscriber.contact_Role__c ='Main Contact, Onboard Contact';
        objActivationSubscriber.State_Province__c = 'Rhode Island';
        objActivationSubscriber.Phone_Number__c = '401-555-1212';
        objActivationSubscriber.Billing_Rep_Name__c = 'TestName';
        objActivationSubscriber.Activation_Order__c = testActOrder.id;
        objActivationSubscriber.Contact__c = Con.Id;
        objActivationSubscriber.Account__c=Acc.Id;
        objActivationSubscriber.Corporate_Billing_Account__c = ObjBillingAccount.id;
        lstSubscriber.add(objActivationSubscriber);
        
        Activation_Subscriber__c objActivationSubscriber2 = New Activation_Subscriber__c();
        objActivationSubscriber2.Subscriber_Contact_First_Name__c = 'First';
        objActivationSubscriber2.Subscribing_Company__c = 'Company';
        objActivationSubscriber2.Address__c = '123 Street St.';
        objActivationSubscriber2.Country__c = 'US';
        objActivationSubscriber2.Postal_Zip_Code__c = '02842';
        objActivationSubscriber2.Subscriber_Mobile_Phone__c = '401-555-1212';
        objActivationSubscriber2.Subscriber_Contact_Name__c = 'Last';
        objActivationSubscriber2.Subscriber_Email__c = 'first@last.com';
        objActivationSubscriber2.City__c = 'Middletown';
        objActivationSubscriber2.contact_Role__c ='Main Contact, Onboard Contact';
        objActivationSubscriber2.State_Province__c = 'Rhode Island';
        objActivationSubscriber2.Phone_Number__c = '401-555-1212';
        objActivationSubscriber2.Billing_Rep_Name__c = 'TestName';
        objActivationSubscriber2.Activation_Order__c = testActOrder2.id;
        objActivationSubscriber2.Contact__c = Con.Id;
        objActivationSubscriber2.Account__c=Acc.Id;
        lstSubscriber.add(objActivationSubscriber2);
        insert lstSubscriber;
        
    }
    static testMethod void testonAfter(){
        Test.startTest();
        Activation_Subscriber__c objActivationSubscriber = [SELECT Id, Phone_Number__c,Contact_Role__c,Activation_Order__c  FROM Activation_Subscriber__c LIMIT 1];
        List<Activation_Contact__c> lstActivationContacts =  [SELECT Id, Email__c, Contact_Role__c,Activation_Order__c FROM Activation_Contact__c]; 
        //system.assertEquals(1, lstActivationContacts.size()); // one record because contact role on contact and subscriber contains "Subscriber".
        if(lstActivationContacts.size()>0)
            delete lstActivationContacts;
        lstActivationContacts =  [SELECT Id, Email__c, Contact_Role__c,Activation_Order__c FROM Activation_Contact__c]; 
        update objActivationSubscriber;
        lstActivationContacts =  [SELECT Id, Email__c, Contact_Role__c,Activation_Order__c FROM Activation_Contact__c]; 
        Test.stopTest();
    }
}