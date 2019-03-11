@isTest
public class SelfRegisteredUserWelcomePage_Ctrl_test {
    @testSetup static void setupTestData(){
        Account objAccountpartner = New Account(Name='Self Registered Mock', BillingCountry = 'Spain');
        insert objAccountpartner;
        Contact objContact = new Contact(AccountId =objAccountpartner.id,
                                         email = 'guest.user.9@example.com',
                                         LastName = 'Last Name',
                                         firstName = 'first Name',
                                         MailingCountry = 'Spain');
        insert objContact; 
        Activation_Order__c testActOrder = new Activation_Order__c();
        testActOrder.isSelf_Activation__c = false;
        testActOrder.User_Agent_String__c = 'test User-Agent string';
        testActOrder.Activation_Type__c = 'Activation on behalf of Customer';
        testActOrder.Order_Status__c = 'Pending Customer Confirmation';
        insert testActOrder;
        Activation_Status__c testOrderStatus = new Activation_Status__c();
        testOrderStatus.Activation_Order__c = testActOrder.Id;
        insert testOrderStatus;
        Activation_Subscriber__c Asub=new Activation_Subscriber__c();
        Asub.Activation_Order__c=testActOrder.id;
        Asub.Contact__c = objContact.Id;
        insert Asub;
        Activation_Order__c testActOrder1 = new Activation_Order__c();
        testActOrder1.isSelf_Activation__c = false;
        testActOrder1.User_Agent_String__c = 'test User-Agent string';
        testActOrder1.Activation_Type__c = 'Activation on behalf of Customer';
        testActOrder1.Order_Status__c = 'Pending Customer Confirmation';
        insert testActOrder1;
        Activation_Status__c testOrderStatus1 = new Activation_Status__c();
        testOrderStatus1.Activation_Order__c = testActOrder1.Id;
        insert testOrderStatus1;
        Activation_Subscriber__c Asub1=new Activation_Subscriber__c();
        Asub1.Activation_Order__c=testActOrder1.id;
        Asub1.Contact__c = objContact.Id;
        insert Asub1;
        list<Profile> CommunityProf = [SELECT Id, Name FROM Profile WHERE Name LIKE '%Community Base%'];
        system.debug(CommunityProf);
        myKVH_new_User_Defaults__c defaultSettings = new myKVH_new_User_Defaults__c();
        defaultSettings.Name = 'SelfRegisteredDefaults';
        defaultSettings.SF_Profile_Id__c = CommunityProf[0].id;
        insert defaultSettings;
        
    }
    static testmethod void SelfRegisteredUserWelcomePage_Ctrl(){
        SelfRegisteredUserWelcomePage_Ctrl SelfRegister = new SelfRegisteredUserWelcomePage_Ctrl();
        SelfRegister.boolAgreeTerms = false;
        SelfRegister.getCountriesList();
        SelfRegister.getStatesList();
        SelfRegister.componentCountryChangeHandlerBilling();
        SelfRegister.updateUserContact();
        SelfRegister.userRedirectPage();
        SelfRegister.RedirectActOrder();
        
    }
    static testmethod void selfReg(){
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
            SelfRegisteredUserWelcomePage_Ctrl SelfRegister1 = new SelfRegisteredUserWelcomePage_Ctrl();
            SelfRegister1.boolAgreeTerms = false;
            SelfRegister1.userRedirectPage();
            SelfRegister1.updateUserContact();
            SelfRegister1.ActOrderId = [SELECT Id From Activation_Order__c limit 1][0].Id;
            //SelfRegisteredUserWelcomePage_Ctrl.updateUser(guestUser.Id);
            SelfRegister1.RedirectActOrder();
            SelfRegister1.AgreeActivationOrderTerms();
            SelfRegister1.updateActivationOrderTerms();
        }
    }
}