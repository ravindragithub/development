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
private class Product_Registration_Review_Ctrl_Test {
    
    @testSetup static void setupTestData(){
        String strActivationHardwareRecordTypeId = Schema.SObjectType.Activation_Hardware__c.getRecordTypeInfosByName().get('Product Registration').getRecordTypeId();
        String strActivationOrderRecordTypeId = Schema.SObjectType.Activation_Order__c.getRecordTypeInfosByName().get('Product Registration').getRecordTypeId();
        
        Account objAccountpartner = New Account(Name='Self Registered Mock', BillingCountry = 'Spain');
        insert objAccountpartner;
        Contact objContact = new Contact(AccountId =objAccountpartner.id,
                                         email = 'gu1st.user.9@example.com',
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
        testActOrder.Main_Contact__c = objContact.Id;
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
        
        Attachment objAttachment = New Attachment();
        objAttachment.ParentId = objActivationHardware.Id;
        objAttachment.Body = Blob.valueOf('body');
        objAttachment.Name = 'Test Attachment';
        insert objAttachment;
        
        Activation_Platform__c objActivationPlatform = New Activation_Platform__c();
        objActivationPlatform.Activation_Order__c = testActOrder.id;
        objActivationPlatform.Market__c='Leisure';
        objActivationPlatform.Market_Sector__c='Marine';
        insert objActivationPlatform;

    }
    
    static testMethod void testProduct_Registration_Review_Ctrl_Test() {
        Activation_Order__c ActOrder;
        ActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        PageReference thePage = page.Activation_Product_Registration;
        thePage.getParameters().put('order', ActOrder.Id);
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
        Product_Registration_Review_Ctrl objProductRegistrationReviewCtrl = New Product_Registration_Review_Ctrl();
        system.assertEquals(1, objProductRegistrationReviewCtrl.lstwrapAllRegisteredProductsDetail.size());
        //objProductRegistrationReviewCtrl.goToPage();
        }
        Test.stopTest();
    }

}