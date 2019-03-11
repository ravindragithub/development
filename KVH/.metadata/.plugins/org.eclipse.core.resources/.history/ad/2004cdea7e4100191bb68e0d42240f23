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
Private Class ActivationSystemInfo_Test{
    
    @testSetup static void setupTestData(){
        Activation_Order__c testActOrder = new Activation_Order__c();
        testActOrder.isSelf_Activation__c = true;
        testActOrder.User_Agent_String__c = 'test User-Agent string';
        insert testActOrder;
        
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
        objActivationSubscriber.contact_Role__c ='Subscriber, Onboard Contact';
        objActivationSubscriber.State_Province__c = 'Rhode Island';
        objActivationSubscriber.Phone_Number__c = '401-555-1212';
        objActivationSubscriber.Billing_Rep_Name__c = 'TestName';
        objActivationSubscriber.Activation_Order__c = testActOrder.id;
        insert objActivationSubscriber;
         
        Activation_Platform__c ap = New Activation_Platform__c();
        ap.Name = 'Test Platform';
        ap.Activation_Order__c = testActOrder.id;
        insert ap;
        
        Activation_Status__c testOrderStatus = new Activation_Status__c();
        testOrderStatus.Activation_Order__c = testActOrder.Id;
        testOrderStatus.Account_Setup_Active_Tab__c = 'Not_Invoicing_Preferences';
        insert testOrderStatus;
        
        Account acct = New Account();
        acct.Name = 'TestAccName';
        insert acct;
        
        Product2 SystemRoot = new Product2();
        SystemRoot.Name = 'V11IP';
        insert SystemRoot;
        
        Asset Assetroot = new Asset();
        Assetroot.Name = '123456789';
        Assetroot.Product2Id = SystemRoot.Id;
        Assetroot.AccountId = acct.Id;
        insert Assetroot;
        
        
        Asset firstLevel = new Asset();
        firstLevel.Name = '123457689';
        firstLevel.Product2Id = SystemRoot.Id;
        firstLevel.AccountId = acct.Id;
        firstLevel.Parent_Asset__c = Assetroot.id;
        insert firstLevel;
        
        Asset secondLevel = new Asset();
        secondLevel.Name = '123456798';
        secondLevel.Product2Id = SystemRoot.Id;
        secondLevel.AccountId = acct.Id;
        secondLevel.Parent_Asset__c = firstLevel.id;
        insert secondLevel;
        
        
        Asset thridLevel = new Asset();
        thridLevel.Name = '123456978';
        thridLevel.Product2Id = SystemRoot.Id;
        thridLevel.AccountId = acct.Id;
        thridLevel.Parent_Asset__c = secondLevel.id;
        insert thridLevel;
        
        Asset fourthLevel = new Asset();
        fourthLevel.Name = '123459678';
        fourthLevel.Product2Id = SystemRoot.Id;
        fourthLevel.AccountId = acct.Id;
        fourthLevel.Parent_Asset__c = thridLevel.id;
        insert fourthLevel;  
        
        Activation_Hardware__c ActHardware=new Activation_Hardware__c();
        ActHardware.Antenna_Serial_Number__c='123456978';
        ActHardware.Activation_Order__c =testActOrder.id ;
        insert ActHardware;
        
        
        Activation_System_Hardware__c objActivationSystemHardware = New Activation_System_Hardware__c();
        objActivationSystemHardware.Name = 'Test Hardware V3111';
        objActivationSystemHardware.Image_Name__c = 'Test Image';
        objActivationSystemHardware.Image_URL__c = '/Image/Path/Test.jpg';
        objActivationSystemHardware.Order__c = 99;
        objActivationSystemHardware.Last_Name__c = 'Hardware V3111';
        objActivationSystemHardware.First_Name__c = 'Test';
        objActivationSystemHardware.Product_Group__c = 'V3111';
        insert objActivationSystemHardware;
        
    }
    static testMethod void ActivationSystemInfo(){
        test.startTest();
        Activation_Order__c ActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        
        PageReference thePage = page.ActivationSystemInfo;     
        thePage.getParameters().put('order', ActOrder.Id);
        Test.setCurrentPage(thePage);
        
        ActivationSystemInfo asi = New ActivationSystemInfo();
        asi.objActivationHardware.Do_Not_Know_Serial_Number__c = true;
        asi.selectedTab = 'Dealer_Distributor_Info';
        asi.goToTab();
        asi.getexistsAsset();
        //V11IP
        Product2 P = [SELECT id FROM Product2 limit 1];
        P.Name = 'V11IP';
        update p;
        
        asi.objActivationHardware.Antenna_Serial_Number__c = '123459678';
        asi.objActivationHardware.Below_Decks_Serial_Number__c = '123459678';
        asi.SearchAsset();
        
        //V3IP
        P.Name = 'V3IP';
        update p;
        
        asi.objActivationHardware.Antenna_Serial_Number__c = '123456978';
        asi.SearchAsset();
        
        
        //V7
        P.Name = 'V7';
        update p;
        
        asi.objActivationHardware.Antenna_Serial_Number__c = '123456798';
        asi.SearchAsset();
        
        //V7IP
        P.Name = 'V7IP';
        update p;
        
        asi.objActivationHardware.Antenna_Serial_Number__c = '123457689';
        asi.SearchAsset();
        asi.objActivationHardware.Antenna_Serial_Number__c = '123456789';
        asi.SearchAsset();
        asi.selectedTab = 'Not_Antenna_System_Support_Contact';
        asi.objActivationHardware.System_Name__c = 'Test Hardware V3111';
        asi.updateActivationhardware();
        asi.AssetNotFound();
        boolean AssetNotFound = asi.getNameException();
        asi.goToNextTab();
        asi.selectedTab = '';
        asi.goToTab();
        asi.saveandExit();
        test.stopTest();
    }
}