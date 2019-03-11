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
private class Product_Registration_ListViewCtrl_Test {
    static String strActivationHardwareRecordTypeId = Schema.SObjectType.Activation_Hardware__c.getRecordTypeInfosByName().get('Product Registration').getRecordTypeId();
    static String strActivationOrderRecordTypeId = Schema.SObjectType.Activation_Order__c.getRecordTypeInfosByName().get('Product Registration').getRecordTypeId();
    
    @testSetup static void setupTestData(){
        
        Account objAccountpartner = New Account(Name='Self Registered Mock', BillingCountry = 'Spain');
        insert objAccountpartner;
        Contact objContact = new Contact(AccountId =objAccountpartner.id,
                                         email = 'gu1st.user.9@example.com',
                                         LastName = 'Last Name',
                                         firstName = 'first Name',
                                         MailingCountry = 'Spain');
        insert objContact; 
        
        Account objAccount = New Account();
        objAccount.ParentId = objAccountpartner.Id;
        objAccount.Name = 'Test Account';
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Leisure Vessel').getRecordTypeId();
        objAccount.Phone = '2327039234';
        objAccount.Market__c = 'Leisure';
        objAccount.Market_Sector__c = 'Marine';
        objAccount.Industry_Designation__c =  'Power Megayacht >80 ft (24m)';
        objAccount.Platform_Detail__c = 'Other';
        insert objAccount;
        
        system.debug('objAccount' + objAccount.RecordTypeId);
        
        Product2 SystemRoot = new Product2();
        SystemRoot.Name = 'V11IP';
        insert SystemRoot;
        
        Asset Assetroot = new Asset();
        Assetroot.Name = '123456789';
        Assetroot.Product2Id = SystemRoot.Id;
        Assetroot.AccountId = objAccount.Id;
        insert Assetroot;
        
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
        testActOrder.Main_Contact__c = objContact.Id;
        testActOrder.Order_Status__c ='In Progress';
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
        
    }
    
    static testMethod void testProduct_Registration_ListViewCtrl_Test() {
        Test.startTest();
        list<Profile> CommunityProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Community Base%'];
        contact objContact = [SELECT Id,AccountId, Salutation, FirstName, LastName, Email, Phone, MailingStreet, MailingCity, MailingCountry, MailingState, MailingPostalCode FROM contact LIMIT 1];
        User guestUser = new User(ProfileID = CommunityProf[0].id, 
                                  EmailEncodingKey = 'ISO-8859-1',
                                  LanguageLocaleKey = 'en_US',
                                  TimeZoneSidKey = 'America/New_York',
                                  LocaleSidKey = 'en_US',
                                  FirstName = 'first',
                                  LastName = 'last',
                                  Username = 'test@example.com', 
                                  CommunityNickname = 'testUser123',
                                  Alias = 't1',
                                  Email = 'no@email.com',
                                  IsActive = true,
                                  ContactId = objContact.Id);
        insert guestUser;
        
        Test.stopTest();
        System.runAs(guestUser){
            Activation_Order__c testActOrder = new Activation_Order__c();
            testActOrder.isSelf_Activation__c = true;
            testActOrder.User_Agent_String__c = 'test User-Agent string';
            testActOrder.Main_Contact__c = objContact.Id;
            testActOrder.Order_Status__c ='In Progress';
            testActOrder.RecordTypeId = strActivationOrderRecordTypeId;
            insert testActOrder;
            Activation_Subscriber__c objActivationSubscriber = New Activation_Subscriber__c();
            objActivationSubscriber.Activation_Order__c = testActOrder.id;
            insert objActivationSubscriber;
            
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
            Product_Registration_ListViewCtrl objProductRegistrationListViewCtrl = New Product_Registration_ListViewCtrl();
            List<SelectOption> lstSelectOptions = objProductRegistrationListViewCtrl.getRegistrationTypes();
            //system.assertEquals(3, lstSelectOptions.size());
            system.assertEquals(0, objProductRegistrationListViewCtrl.lstwrapAllRegisteredProductsDetail.size());
            system.assertEquals(1, objProductRegistrationListViewCtrl.lstAssets.size());
            objProductRegistrationListViewCtrl.strSelectedType = 'Registrations_In_Progress';
            objProductRegistrationListViewCtrl.onchangeType();
            system.assertEquals(1, objProductRegistrationListViewCtrl.lstwrapAllRegisteredProductsDetail.size());
            system.assertEquals(0, objProductRegistrationListViewCtrl.lstAssets.size());
            
            objProductRegistrationListViewCtrl.strSelectedType = 'Submitted_Registrations';
            testActOrder.Order_Status__c ='Submitted';
            update testActOrder;
            objProductRegistrationListViewCtrl.onchangeType();
            system.assertEquals(1, objProductRegistrationListViewCtrl.lstwrapAllRegisteredProductsDetail.size());
        }
    }
}