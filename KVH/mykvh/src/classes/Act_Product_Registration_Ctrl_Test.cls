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
private class Act_Product_Registration_Ctrl_Test {
    
    @testSetup static void setupTestData(){
        String strActivationHardwareRecordTypeId = Schema.SObjectType.Activation_Hardware__c.getRecordTypeInfosByName().get('Product Registration').getRecordTypeId();
        String strActivationOrderRecordTypeId = Schema.SObjectType.Activation_Order__c.getRecordTypeInfosByName().get('Product Registration').getRecordTypeId();
        
        Account objAccountpartner = New Account(Name='Self Registered Mock', BillingCountry = 'Spain');
        insert objAccountpartner;
        Contact objContact = new Contact(AccountId =objAccountpartner.id,
                                         email = 'guq1st.user.9@example.com',
                                         LastName = 'Last Name',
                                         firstName = 'first Name',
                                         MailingCountry = 'Spain');
        insert objContact; 
        Account objAccount = New Account();
        objAccount.Name = 'Test Account';
        objAccount.Phone = '2327039234';
        objAccount.KVH_Sales_Office__c = 'TBD';
        objAccount.Prospect_Type__c = 'Customer';
        insert objAccount;
        
        Opportunity objOpportunity = New Opportunity();
        objOpportunity.AccountID = objAccount.id;
        objOpportunity.Name = 'Test Opp';
        objOpportunity.LeadSource = 'Website';
        objOpportunity.CloseDate = system.today()+5;
        objOpportunity.StageName = 'Quote'; 
        objOpportunity.Description = 'New Online Activation';
        objOpportunity.RecordTypeID = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('Mobile Broadband').RecordTypeId;
        insert objOpportunity;
        
        Activation_Order__c testActOrder = new Activation_Order__c();
        testActOrder.isSelf_Activation__c = true;
        testActOrder.User_Agent_String__c = 'test User-Agent string';
        testActOrder.Activation_Opportunity__c = objOpportunity.Id;
        testActOrder.RecordTypeId = strActivationOrderRecordTypeId;
        insert testActOrder;
        
        Activation_Status__c testOrderStatus = new Activation_Status__c();
        testOrderStatus.Activation_Order__c = testActOrder.Id;
        insert testOrderStatus;
        testOrderStatus.Account_Setup_Active_Tab__c = 'Product';
        update testOrderStatus; 
        
        Activation_Subscriber__c objActivationSubscriber = New Activation_Subscriber__c();
        objActivationSubscriber.Activation_Order__c = testActOrder.id;
        insert objActivationSubscriber;
        
        Activation_Dealer__c objActivationDealer = New Activation_Dealer__c();
        objActivationDealer.Activation_Order__c = testActOrder.id;
        insert objActivationDealer;
        
        Activation_Contact__c objActivationContact = new Activation_Contact__c();
        objActivationContact.Activation_Order__c = testActOrder.id;
        objActivationContact.Email__c = 'test@4test.com';
        objActivationContact.contact_Role__c ='Onboard Contact, System Support Contact,Main Contact,Billing Representative,Authorized Representative,Invoice Recipient';
        
        insert objActivationContact;
        
        Activation_Contact__c objActivationContact1 = new Activation_Contact__c();
        objActivationContact1.Activation_Order__c = testActOrder.id;
        objActivationContact1.Email__c = 'test@4test.com';
        objActivationContact1.contact_Role__c ='Onboard Contact, System Support Contact,Main Contact,Invoice Recipient,Authorized Representative';
        
        insert objActivationContact1;
        
        
        Activation_Hardware__c objActivationHardware = New Activation_Hardware__c();
        objActivationHardware.Activation_Order__c = testActOrder.id;
        objActivationHardware.RecordTypeId = strActivationHardwareRecordTypeId;
        objActivationHardware.System_Name__c = 'Test V3';
        objActivationHardware.System_Name_Group__c = 'V3';
        objActivationHardware.Purchase_Date__c = system.today();
        objActivationHardware.Product_Line__c = 'Satellite_Television';
        insert objActivationHardware;
        
        Activation_Platform__c objActivationPlatform = New Activation_Platform__c();
        objActivationPlatform.Activation_Order__c = testActOrder.id;
        objActivationPlatform.Market__c='Leisure';
        objActivationPlatform.Market_Sector__c='Marine';
        insert objActivationPlatform;
        
        Product_Registration_Management__c objProductRegistrationManagement = New Product_Registration_Management__c();
        objProductRegistrationManagement.Market__c='Leisure';
        objProductRegistrationManagement.Market_Sector__c='Marine';
        objProductRegistrationManagement.Product_Line__c = 'Satellite_Television';
        objProductRegistrationManagement.Current_Products__c = 'TracVision HD11; TracVision HD7';
        objProductRegistrationManagement.Retired_Products__c = 'TracVision M1; TracVision M1DX';
        insert objProductRegistrationManagement;
    }
    
    static testMethod void testAct_Product_Registration_Ctrl_Test() {
        Activation_Order__c ActOrder;
        ActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        Activation_Contact__c objActContact;
        objActContact = [SELECT Id, Name FROM Activation_Contact__c LIMIT 1];
        PageReference thePage = page.Activation_Product_Registration;
        thePage.getParameters().put('order', ActOrder.Id);
        thePage.getParameters().put('conActID', objActContact.Id);
        Test.setCurrentPage(thePage);
        Test.startTest();
        Act_Product_Registration_Controller objActProductRegistrationCtrl = New Act_Product_Registration_Controller();
        objActProductRegistrationCtrl.selectedTab = 'Product';
        objActProductRegistrationCtrl.objProductRegistrationManagement.Market__c='Leisure';
        objActProductRegistrationCtrl.objProductRegistrationManagement.Market_Sector__c='Marine';
        objActProductRegistrationCtrl.objProductRegistrationManagement.Product_Line__c = 'Satellite_Television';
        objActProductRegistrationCtrl.strFirstSerialNumberName = '';
        objActProductRegistrationCtrl.strSecondSerialNumberName = '';
        objActProductRegistrationCtrl.readActivationOrder();
        objActProductRegistrationCtrl.getCountriesList();
        objActProductRegistrationCtrl.getStatesList();
        objActProductRegistrationCtrl.getStatesListDeal();
        objActProductRegistrationCtrl.getStatesListInstalling();
        objActProductRegistrationCtrl.selectedMarketType = 'Leisure Vessel';
        PageReference pageRef1 = objActProductRegistrationCtrl.updateActivationPlatformMarketTab();
        system.assertEquals(thePage.getUrl(), pageRef1.getUrl());
        pageRef1 = objActProductRegistrationCtrl.upsertActivationContact();
        system.assertEquals(thePage.getUrl(),pageRef1.getUrl());
        objActProductRegistrationCtrl.strServiceStartDate = '2016-Dec-06';
        objActProductRegistrationCtrl.strbody = objActProductRegistrationCtrl.strfilename = 'test Attachment';
        pageRef1 = objActProductRegistrationCtrl.upsertActivationHardwareTab();
        system.assertEquals(thePage.getUrl(),pageRef1.getUrl());
        objActProductRegistrationCtrl.objActivationDealer.Dealer_Distributor_Company__c =  [SELECT Id FROM Account LIMIT 1].Id;
        objActProductRegistrationCtrl.objActivationDealer.Installing_Dealer_Company__c = [SELECT Id FROM Account LIMIT 1].Id;
        pageRef1 = objActProductRegistrationCtrl.upsertDealer();
        system.assertEquals(thePage.getUrl(),pageRef1.getUrl());
        objActProductRegistrationCtrl.strSelectedCurrentProduct = 'test current';
        objActProductRegistrationCtrl.onchangeCurrent();
        objActProductRegistrationCtrl.strSelectedRetiredProduct = 'test retired';
        objActProductRegistrationCtrl.onchangeRetired();
        objActProductRegistrationCtrl.validateAsset();
        system.assertEquals(1, objActProductRegistrationCtrl.intCounter);
        Act_Product_Registration_Controller.getAccountData('Test');
        //objActProductRegistrationCtrl.saveandExit();
        Test.stopTest();
    }
    
    static testMethod void test1Act_Product_Registration_Ctrl_Test() {
        PageReference thePage = page.Activation_Product_Registration;
        Test.setCurrentPage(thePage);
        Test.startTest();
        list<Profile> CommunityProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Community Base%'];
        contact objContact = [SELECT Id, Salutation, FirstName, LastName, Email, Phone, MailingStreet, MailingCity, MailingCountry, MailingState, MailingPostalCode FROM contact LIMIT 1];
        User guestUser = new User(LastName = 'guest user ', 
                                  Username = 'guest.user.@example.com', 
                                  CommunityNickname = 'nickname',
                                  Email = 'guest.user@example.com',
                                  Alias = 'guestu', 
                                  TimeZoneSidKey = 'GMT', 
                                  LocaleSidKey = 'en_GB', 
                                  ContactId= objContact.Id,
                                  EmailEncodingKey = 'ISO-8859-1', 
                                  ProfileId = CommunityProf[0].id, 
                                  LanguageLocaleKey = 'en_US');
        System.runAs(guestUser){
        Act_Product_Registration_Controller objActProductRegistrationCtrl = New Act_Product_Registration_Controller();
        objActProductRegistrationCtrl.readActivationOrder();
        PageReference pageRef1 = objActProductRegistrationCtrl.upsertActivationContact();
        system.assertEquals(thePage.getUrl(), pageRef1.getUrl());
        
        }
        Test.stopTest();
    }
    
}