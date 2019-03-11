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
private class Act_Subscriber_component_controller_test {
    private static final Id Prospect_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
    private static final Id DirectPartner_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Partner').getRecordTypeId();
    private static final Id DirectCustomer_RECORD_TYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Direct Customer').getRecordTypeId();
    
    @testSetup static void setupTestData(){
        Account objAccountpartner = New Account(Name='Self Registered Mock', BillingCountry = 'Spain', RecordTypeId = DirectPartner_RECORD_TYPE_ID);
        insert objAccountpartner;
        
        Activation_Order__c testActOrder = new Activation_Order__c();
        testActOrder.isSelf_Activation__c = true;
        testActOrder.User_Agent_String__c = 'test User-Agent string';
        testActOrder.Activation_Type__c = 'Activation on behalf of Customer';
        insert testActOrder;
        
        Activation_Status__c testOrderStatus = new Activation_Status__c();
        testOrderStatus.Activation_Order__c = testActOrder.Id;
        insert testOrderStatus;
        
        DefaultAccounts__c selfRegAcctSetting = new DefaultAccounts__c();
        selfRegAcctSetting.Name = 'SelfRegisteredAccount';
        selfRegAcctSetting.Account_ID__c = objAccountpartner.Id;
        selfRegAcctSetting.Description__c = 'SelfRegisteredAccount';
        insert selfRegAcctSetting;
        //Need a Profile.... a COMMUNITY profile to add to a Custom Setting! Profiles are Metadata!
        list<Profile> CommunityProf = new list<Profile>();
        CommunityProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Community Base%'];
        system.debug(CommunityProf);
        myKVH_new_User_Defaults__c defaultSettings = new myKVH_new_User_Defaults__c();
        defaultSettings.Name = 'DirectCustomerDefaults';
        defaultSettings.SF_Profile_Id__c = CommunityProf[0].id;
        insert defaultSettings;
        myKVH_new_User_Defaults__c defaultSettings2 = new myKVH_new_User_Defaults__c();
        defaultSettings2.Name = 'ProdRegistration';
        defaultSettings2.SF_Profile_Id__c = CommunityProf[0].id;
        insert defaultSettings2;
       
    }
    
   /* static testMethod void testSetupData(){
        Activation_Order__c ActOrder;
        list<Activation_Order__c> ActOrdList = new list<Activation_Order__c>(); //Let's get all Activation_Orders from the database....
        ActOrdList = [SELECT ID, Name, isSelf_Activation__c, User_Agent_String__c FROM Activation_Order__c];                
        system.assertEquals(1,ActOrdList.size());                               //but there should be ONLY one!
        ActOrder = ActOrdList[0];                                               //the one we just created in our testSetup!
        system.assertEquals(ActOrder.isSelf_Activation__c, true);
        system.assertEquals(ActOrder.User_Agent_String__c, 'test User-Agent string');
        ActivationsBaseController util = new ActivationsBaseController();
        list<Activation_Status__c> ActOrdStatusList = util.getActivationStatus(ActOrdList);
        system.assertEquals(1,ActOrdStatusList.size());                         //and there should be ONLY one!.
        Activation_Status__c ActOrderStatus = ActOrdStatusList[0];
    }
    
    static testMethod void testConstructor() {
        // TO DO: implement unit test
        test.startTest();
        Activation_Order__c testOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        system.debug('Test Order: ' + testOrder.Id);
        Activation_Status__c testStatus = New Activation_Status__c();
        testStatus = [SELECT Id FROM Activation_Status__c WHERE Activation_Order__c =: testOrder.Id LIMIT 1];
        Act_Subscriber_component_controller ctrl = new Act_Subscriber_component_controller();
        ctrl.ActOrderId = (string)testOrder.Id;     //convert to string (see base controller)
        ctrl.ActStatus = testStatus;                //see base controller
        PageReference thePage = page.Account_setup;
        thePage.getParameters().put('order', testOrder.Id);
        Test.setCurrentPage(thePage);
        ctrl.newSubscriber = ctrl.getNewSubscriber();
        list<selectOption> readOptions = new list<selectOption>();      // we will reuse this...
        ctrl.parentContainer = 'test container';
        readOptions.clear();                                            //reset
        readOptions = ctrl.getCountriesList();
        system.assertEquals('Choose One', readOptions[0].getValue());   //test constructor values.
        system.assertEquals('Choose One', readOptions[0].getLabel());   //test constructor values.
        readOptions.clear();                                            //reset
        readOptions = ctrl.getStatesList();
        system.assertEquals('Choose Country First', readOptions[0].getValue()); //test constructor values.
        system.assertEquals('Choose Country First', readOptions[0].getLabel()); //test constructor values.
        readOptions.clear();
        readOptions = ctrl.buildPhoneTypes();                           //see base controller
        system.assertEquals(3, readOptions.size());
        test.stopTest();
    }*/
    static testMethod void test_setnewSubscriber2(){
        list<Account> AccountList = [SELECT Id, Name, BillingCountry FROM Account LIMIT 1];
        Billing_Account__c objBillingAccountCorporate = New Billing_Account__c();
        objBillingAccountCorporate.Account__c = AccountList[0].id;
        objBillingAccountCorporate.RecordTypeId = Schema.SObjectType.Billing_Account__c.getRecordTypeInfosByName().get('Corporate CC Account').getRecordTypeId();
        objBillingAccountCorporate.Billing_Account_ID__c = '00';
        insert objBillingAccountCorporate;
        Activation_Order__c testOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        Activation_Status__c testStatus = [SELECT Id FROM Activation_Status__c WHERE Activation_Order__c =: testOrder.Id LIMIT 1];
        
        Contact objContact = New Contact(AccountId =AccountList[0].id,
                                         email = 'testCont123@example.com',
                                         LastName = 'Last Name',
                                         firstName = 'first Name',
                                         MailingCountry = 'Spain');
        Insert objContact;
        Activation_Platform__c objActivationPlatform = New Activation_Platform__c();
        objActivationPlatform.Name = 'TBD';
        objActivationPlatform.Activation_Order__c = testOrder.id;
        objActivationPlatform.Market__c = 'Leisure';
        objActivationPlatform.Market_Sector__c = 'Marine';
        objActivationPlatform.Vessel_IMO__c = '1234567';
        insert objActivationPlatform;
        List<Address__c> lstAddress = New List<Address__c>();
        Address__c objAddress = New Address__c(Account__c = AccountList[0].id,
                                               Address_1__c = 'Address 1',
                                               Address_2__c = 'Address 2',
                                               Address_Type__c = 'Airtime Services Subscriber',
                                               City__c = 'City',
                                               Postal_Zipcode__c = '123456',
                                               Country__c = 'Spain',
                                               State__c = 'State',
                                               State_Province_ISO_Code__c = '11',
                                               Preferred_Addressee__c = 'Address 1',
                                               Billing_Account__c = objBillingAccountCorporate.Id
                                              );
        lstAddress.add(objAddress);
        Address__c objAddress1 = New Address__c(Account__c = AccountList[0].id,
                                                Address_1__c = 'Address 1',
                                                Address_2__c = 'Address 2',
                                                Address_Type__c = 'Airtime Services Billing',
                                                City__c = 'City',
                                                Postal_Zipcode__c = '123456',
                                                Country__c = 'Spain',
                                                State__c = 'State',
                                                State_Province_ISO_Code__c = '11',
                                                Preferred_Addressee__c = 'Address 1',
                                                Billing_Account__c = objBillingAccountCorporate.Id
                                               );
        lstAddress.add(objAddress1);
        Insert lstAddress;
        
        PageReference pageRef = page.Account_Setup;
        pageRef.getParameters().put('CorporateAccountId', objBillingAccountCorporate.Id);
        pageRef.getParameters().put('SFAccountId', AccountList[0].id);
        pageRef.getParameters().put('mainContactId', objContact.Id);
        pageRef.getParameters().put('order', testOrder.Id);
        Test.setCurrentPage(pageRef); 
        Act_Subscriber_component_controller ctrl = new Act_Subscriber_component_controller();
        ctrl.ActOrderId = (string)testOrder.Id;     //convert to string (see base controller)
        ctrl.ActStatus = testStatus;                //see base controller
        ctrl.newSubscriber = ctrl.getNewSubscriber();
        ctrl.newSubscriber.Country__c = 'US';
        ctrl.newSubscriber.Activation_Order__c = null;
        ctrl.selectedTab = 'Invoicing_Preferences';     //test that FinalTab thing
        
        test.startTest();
        
        list<Lead> LeadList = new list<Lead>();
        for(integer i = 0; i < 2; i++){
            Lead c = new Lead(email = 'testLead' + i + '@example.com',
                              LastName = 'Last ' + i,
                              firstName = 'first' + i,
                              Country = 'India');
            LeadList.add(c);
        }
        system.assertEquals(2, LeadList.size());    //make sure that we have two contacts
        ctrl.analyzeFoundLeads(LeadList, true);  //TWO Leads
        LeadList.remove(1);
        system.assertEquals(1, LeadList.size());    //make sure that we have ONE contacts
        insert LeadList;
        ctrl.analyzeFoundLeads(LeadList, true);  //ONE Lead
        test.stopTest();
    }
    static testMethod void test_setnewSubscriber(){
        list<Account> AccountList = [SELECT Id, Name, BillingCountry FROM Account LIMIT 1];
        Billing_Account__c objBillingAccountCorporate = New Billing_Account__c();
        objBillingAccountCorporate.Account__c = AccountList[0].id;
        objBillingAccountCorporate.RecordTypeId = Schema.SObjectType.Billing_Account__c.getRecordTypeInfosByName().get('Corporate CC Account').getRecordTypeId();
        objBillingAccountCorporate.Billing_Account_ID__c = '00';
        insert objBillingAccountCorporate;
        Activation_Order__c testOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        Activation_Status__c testStatus = [SELECT Id FROM Activation_Status__c WHERE Activation_Order__c =: testOrder.Id LIMIT 1];
        
        Contact objContact = New Contact(AccountId =AccountList[0].id,
                                         email = 'testCont123@example.com',
                                         LastName = 'Last Name',
                                         firstName = 'first Name',
                                         MailingCountry = 'Spain');
        Insert objContact;
        Activation_Platform__c objActivationPlatform = New Activation_Platform__c();
        objActivationPlatform.Name = 'TBD';
        objActivationPlatform.Activation_Order__c = testOrder.id;
        objActivationPlatform.Market__c = 'Leisure';
        objActivationPlatform.Market_Sector__c = 'Marine';
        objActivationPlatform.Vessel_IMO__c = '1234567';
        insert objActivationPlatform;
        List<Address__c> lstAddress = New List<Address__c>();
        Address__c objAddress = New Address__c(Account__c = AccountList[0].id,
                                               Address_1__c = 'Address 1',
                                               Address_2__c = 'Address 2',
                                               Address_Type__c = 'Airtime Services Subscriber',
                                               City__c = 'City',
                                               Postal_Zipcode__c = '123456',
                                               Country__c = 'Spain',
                                               State__c = 'State',
                                               State_Province_ISO_Code__c = '11',
                                               Preferred_Addressee__c = 'Address 1',
                                               Billing_Account__c = objBillingAccountCorporate.Id
                                              );
        lstAddress.add(objAddress);
        Address__c objAddress1 = New Address__c(Account__c = AccountList[0].id,
                                                Address_1__c = 'Address 1',
                                                Address_2__c = 'Address 2',
                                                Address_Type__c = 'Airtime Services Billing',
                                                City__c = 'City',
                                                Postal_Zipcode__c = '123456',
                                                Country__c = 'Spain',
                                                State__c = 'State',
                                                State_Province_ISO_Code__c = '11',
                                                Preferred_Addressee__c = 'Address 1',
                                                Billing_Account__c = objBillingAccountCorporate.Id
                                               );
        lstAddress.add(objAddress1);
        Insert lstAddress;
        
        PageReference pageRef = page.Account_Setup;
        pageRef.getParameters().put('CorporateAccountId', objBillingAccountCorporate.Id);
        pageRef.getParameters().put('SFAccountId', AccountList[0].id);
        pageRef.getParameters().put('mainContactId', objContact.Id);
        pageRef.getParameters().put('order', testOrder.Id);
        Test.setCurrentPage(pageRef); 
        Act_Subscriber_component_controller ctrl = new Act_Subscriber_component_controller();
        ctrl.ActOrderId = (string)testOrder.Id;     //convert to string (see base controller)
        ctrl.ActStatus = testStatus;                //see base controller
        ctrl.newSubscriber = ctrl.getNewSubscriber();
        ctrl.newSubscriber.Country__c = 'US';
        ctrl.newSubscriber.Activation_Order__c = null;
        ctrl.selectedTab = 'Invoicing_Preferences';     //test that FinalTab thing
        ctrl.saveandExit();
        ctrl.setnewSubscriber();
        ctrl.newSubscriber = null;
        Activation_Subscriber__c readSubscriber = ctrl.getnewSubscriber();
        system.assertEquals(readSubscriber.Country__c, 'US');
        ctrl.callfromOtherPage(objActivationPlatform,true);
        
        test.startTest();
        list<User> userList = new list<User>();
        //Need a Profile.... a COMMUNITY profile to add to a Custom Setting! Profiles are Metadata!
        list<Profile> CommunityProf = new list<Profile>();
        CommunityProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Community Base%'];
        Account a = [SELECT Id FROM Account WHERE Name = 'Self Registered Mock' LIMIT 1];
        Contact returnedContact = ctrl.createCommunityContact(a.id);
        returnedContact.Inactive_Contact__c = true;
        update returnedContact;
        for(integer i = 0; i < 2; i++){
            User guestUser = new User(LastName = 'guest user ' + i, 
                                      Username = 'guest.user.'+i+'@example.com', 
                                      CommunityNickname = 'nickname',
                                      Email = 'guest.user.'+i+'@example.com',
                                      Alias = 'guestu' + i, 
                                      TimeZoneSidKey = 'GMT', 
                                      LocaleSidKey = 'en_GB', 
                                      ContactId= returnedContact.Id,
                                      EmailEncodingKey = 'ISO-8859-1', 
                                      ProfileId = CommunityProf[0].id, 
                                      LanguageLocaleKey = 'en_US');
            userList.add(guestUser);
        }
        ctrl.analyzeFoundUsers(userList, true); 
        userList.remove(1);
        ctrl.analyzeFoundUsers(userList, true);   //ONE user
        
        //insert userList;
        returnedContact.Inactive_Contact__c = false;
        update returnedContact;
        userList[0].contactId = returnedContact.Id;
        //ctrl.analyzeFoundUsers(userList, true);   //ONE user
        
        
        returnedContact.Inactive_Contact__c = true;
        update returnedContact;
        userList[0].isActive = false;
        ctrl.analyzeFoundUsers(userList, true);   //ONE user
        
        list<Contact> contactList = new list<Contact>();
        Account notSelffReg = new Account(Name='NOT Self Registered Mock', RecordTypeId = Prospect_RECORD_TYPE_ID);
        insert notSelffReg;
        list<Account> acctList = [SELECT Id, Name FROM Account WHERE Name LIKE 'NOT%'];
        for(integer i = 0; i < 2; i++){
            Contact c = new Contact(
                email = 'testCont' + i + '@example.com',
                LastName = 'Last Name' + i,
                firstName = 'first Name' + i,
                MailingCountry = 'Spain');
            contactList.add(c);
        }
        system.assertEquals(2, contactList.size());    //make sure that we have two contacts
        ctrl.analyzeFoundContacts(contactList, true);  //TWO Contacts
        contactList.remove(1);
        system.assertEquals(1, contactList.size());    //make sure that we have ONE contacts
        insert contactList;
        ctrl.analyzeFoundContacts(contactList, true);  //ONE Contact
        contactList.clear();
        for(integer i = 0; i < 1; i++){
            Contact c = new Contact(AccountId =acctList[0].id,
                                    email = 'testCont123' + i + '@example.com',
                                    LastName = 'Last Name' + i,
                                    firstName = 'first Name' + i,
                                    MailingCountry = 'Spain');
            contactList.add(c);
        }
        insert contactList;
        //ctrl.analyzeFoundContacts(contactList);  //ONE Contact
        test.stopTest();
    }
    static testMethod void testComponentCountryChangeHandler(){
        //Validating Test Data
        Activation_Order__c ActOrder = [SELECT Id, Name,isSelf_Activation__c FROM Activation_Order__c LIMIT 1];
        system.assertEquals(true,ActOrder.isSelf_Activation__c);
        Act_Subscriber_component_controller accc = New Act_Subscriber_component_controller();
        list<selectOption> readOptions = new list<selectOption>();      // we will reuse this...
        PageReference thePage = page.Account_setup;
        thePage.getParameters().put('order', ActOrder.Id);
        Test.setCurrentPage(thePage);
        test.startTest(); 
        accc.newSubscriber = accc.getNewSubscriber();
        accc.parentContainer = 'test container';
        accc.getCountriesList();
        accc.newSubscriber.Country__c = 'US'; 
        accc.newSubscriber.State_Province__c = 'choose one'; 
        accc.componentCountryChangeHandler();
        readOptions = accc.getStatesList();
        system.assert(readOptions.size() > 2 );  
        accc.componentStateChangeHandler();
        accc.selfRegistrationException('Error','Test');
        test.stopTest();
    }
   
}