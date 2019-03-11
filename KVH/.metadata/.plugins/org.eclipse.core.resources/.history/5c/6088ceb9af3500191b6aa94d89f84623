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
Private Class Act_Payment_component_Ctrl_Test{
    
    @testSetup static void setupTestData(){
        
        Activation_Order__c testActOrder = new Activation_Order__c();
        testActOrder.isSelf_Activation__c = true;
        testActOrder.User_Agent_String__c = 'test User-Agent string';
        insert testActOrder;
        
        Activation_Status__c testOrderStatus = new Activation_Status__c();
        testOrderStatus.Activation_Order__c = testActOrder.Id;
        testOrderStatus.Account_Setup_Active_Tab__c = 'Not_Invoicing_Preferences';
        insert testOrderStatus;
        
        Activation_Contact__c actcon = new Activation_Contact__c();
        actcon.Activation_Order__c = testActOrder.id;
        actcon.Email__c = 'test@4Test.com';
        insert actcon;
        
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
        
        Customer_Profile__c objCustomerProfile = New Customer_Profile__c();
        objCustomerProfile.Name = 'Test Customer Profile';
        objCustomerProfile.Customer_Profile_Id__c = '12123123';
        objCustomerProfile.Activation_Order__c = testActOrder.Id;
        insert objCustomerProfile;
        
        List<Payment_Profile__c> lstPaymentProfile = New List<Payment_Profile__c>();
        Payment_Profile__c objPaymentProfile = New Payment_Profile__c();
        objPaymentProfile.Customer_Profile__c = objCustomerProfile.Id;
        objPaymentProfile.Payment_Profile_Id__c ='232342322';
        objPaymentProfile.Primary_Credit_Card__c = True;
        objPaymentProfile.Credit_Card_Number__c = '123456789222';
        lstPaymentProfile.add(objPaymentProfile);
        
        Payment_Profile__c objPaymentProfile1 = New Payment_Profile__c();
        objPaymentProfile1.Customer_Profile__c = objCustomerProfile.Id;
        objPaymentProfile1.Payment_Profile_Id__c ='232342222';
        objPaymentProfile1.Credit_Card_Number__c = '123456789222';
        lstPaymentProfile.add(objPaymentProfile1);
        insert lstPaymentProfile;
    }
    
    //if Existing activation Contact get that mapped to payment profile
    static testMethod void testConstructor(){
        Test.startTest();
        Act_Payment_Component_Controller util = new Act_Payment_Component_Controller();
        list<selectOption> readOptions = new list<selectOption>();
        readOptions = util.getCountriesList();
        system.assertEquals('Choose One', readOptions[0].getLabel());
        readOptions.clear();
        readOptions = util.getStatesList();
        system.assertEquals('Choose Country First', readOptions[0].getLabel());
        readOptions.clear();
        util.componentStateChangeHandler();         //Method doesn't really do anything.....
        util.parentContainer = 'Dummy Container';
        Test.stopTest();
    }
    
    static testMethod void testConstructorFlowupdateSubscriber(){
        Test.startTest();
        Activation_Order__c ActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        Activation_Contact__c objActivationContact =  [SELECT Id,Activation_Order__c, Email__c, Contact_Role__c FROM Activation_Contact__c WHERE Activation_Order__c =: ActOrder.Id LIMIT 1]; 
        
        PageReference thePage = page.Account_Setup;     
        thePage.getParameters().put('order', ActOrder.Id);
        thePage.getParameters().put('conActID', objActivationContact.Id);
        Test.setCurrentPage(thePage);
        Act_Payment_Component_Controller objActPaymentComponentController = new Act_Payment_Component_Controller();
        Activation_Status__c objActivationStatus = [SELECT Id,name,Account_Setup_Active_Tab__c FROM Activation_Status__c WHERE Activation_Order__c =: ActOrder.Id LIMIT 1];
        objActPaymentComponentController.actStatus = objActivationStatus;
        //months size including select
        system.assertEquals(13,objActPaymentComponentController.lstMonths.size());
        //year size including select
        system.assertEquals(8,objActPaymentComponentController.lstYears.size());
        objActPaymentComponentController.getstrCreditCardCVV();
        objActPaymentComponentController.getstrMonth();
        objActPaymentComponentController.getstrYear();
        objActPaymentComponentController.getstrCreditCardNumber();
        objActPaymentComponentController.setstrCreditCardCVV('444');
        objActPaymentComponentController.setstrMonth('12');
        objActPaymentComponentController.setstrYear('2022');
        objActPaymentComponentController.setstrCreditCardNumber('333534534534');
        PageReference pageRef = page.Account_Setup;  
        thePage.getParameters().put('order', ActOrder.Id);
        thePage.getParameters().put('existingcreditterms', 'true');
        Test.setCurrentPage(thePage);
        PageReference pageRef1 =  objActPaymentComponentController.updateSubscriber();
        system.assertNotEquals(pageRef.getUrl(),pageRef1.getUrl());
        Test.stopTest();
    }
    
    static testMethod void testConstructortestCalloutsPrimaryFail(){
        Test.startTest();
        Activation_Order__c ActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        Activation_Contact__c objActivationContact =  [SELECT Id,Activation_Order__c, Email__c, Contact_Role__c FROM Activation_Contact__c WHERE Activation_Order__c =: ActOrder.Id LIMIT 1]; 
        
        PageReference thePage = page.Account_Setup;     
        thePage.getParameters().put('order', ActOrder.Id);
        thePage.getParameters().put('conActID', objActivationContact.Id);
        Test.setCurrentPage(thePage);
        Act_Payment_Component_Controller objActPaymentComponentController = new Act_Payment_Component_Controller();
        Activation_Status__c objActivationStatus = [SELECT Id,name,Account_Setup_Active_Tab__c FROM Activation_Status__c WHERE Activation_Order__c =: ActOrder.Id LIMIT 1];
        objActPaymentComponentController.actStatus = objActivationStatus;
        objActPaymentComponentController.strCreditCardNumber = '1234567891234';
        objActPaymentComponentController.strMonth = '12';
        objActPaymentComponentController.strYear = String.valueOf(Date.Today().Year()+2);
        objActPaymentComponentController.strCreditCardCVV = '123';
        objActPaymentComponentController.boolIsShowPrimary = false;
        objActPaymentComponentController.testcallouts();
        system.assertEquals(true, objActPaymentComponentController.boolPopup);
        Test.stopTest();
    }
    
    static testMethod void testConstructortestCalloutsSecondaryFail(){
        Test.startTest();
        Activation_Order__c ActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        Activation_Contact__c objActivationContact =  [SELECT Id,Activation_Order__c, Email__c, Contact_Role__c FROM Activation_Contact__c WHERE Activation_Order__c =: ActOrder.Id LIMIT 1]; 
        
        PageReference thePage = page.Account_Setup;     
        thePage.getParameters().put('order', ActOrder.Id);
        thePage.getParameters().put('conActID', objActivationContact.Id);
        Test.setCurrentPage(thePage);
        Act_Payment_Component_Controller objActPaymentComponentController = new Act_Payment_Component_Controller();
        Activation_Status__c objActivationStatus = [SELECT Id,name,Account_Setup_Active_Tab__c FROM Activation_Status__c WHERE Activation_Order__c =: ActOrder.Id LIMIT 1];
        objActPaymentComponentController.actStatus = objActivationStatus;
        objActPaymentComponentController.strCreditCardNumber = '1234567891234';
        objActPaymentComponentController.strMonth = '12';
        objActPaymentComponentController.strYear = String.valueOf(Date.Today().Year()+2);
        objActPaymentComponentController.strCreditCardCVV = '123';
        objActPaymentComponentController.testcallouts();
        system.assertEquals(true, objActPaymentComponentController.boolPopup);
        Test.stopTest();
    }
    
    static testMethod void testConstructortestCalloutsSuccess(){
        Test.startTest();
        Activation_Order__c ActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        Activation_Contact__c objActivationContact =  [SELECT Id,Activation_Order__c, Email__c, Contact_Role__c FROM Activation_Contact__c WHERE Activation_Order__c =: ActOrder.Id LIMIT 1]; 
        
        PageReference thePage = page.Account_Setup;     
        thePage.getParameters().put('order', ActOrder.Id);
        thePage.getParameters().put('conActID', objActivationContact.Id);
        Test.setCurrentPage(thePage);
        Act_Payment_Component_Controller objActPaymentComponentController = new Act_Payment_Component_Controller();
        Activation_Status__c objActivationStatus = [SELECT Id,name,Account_Setup_Active_Tab__c FROM Activation_Status__c WHERE Activation_Order__c =: ActOrder.Id LIMIT 1];
        objActPaymentComponentController.actStatus = objActivationStatus;
        objActPaymentComponentController.strCreditCardNumber = '1234567891234';
        objActPaymentComponentController.strMonth = '12';
        objActPaymentComponentController.strYear = String.valueOf(Date.Today().Year()+2);
        objActPaymentComponentController.strCreditCardCVV = '123';
        objActPaymentComponentController.testcallouts();
        Map<String, List<String>> mapXmlNodeValue = New Map<String, List<String>>();
        mapXmlNodeValue.put('customerProfileId', New List<String>{'12345678'});
        mapXmlNodeValue.put('customerPaymentProfileId', New List<String>{'12345678'});
        objActPaymentComponentController.mapXmlNodeValue = mapXmlNodeValue;
        objActPaymentComponentController.saveprofiles();
        List<Customer_Profile__c> lstCustomerProfile = [SELECT ID FROM Customer_Profile__c];
        system.assertEquals(1, lstCustomerProfile.size());
        Test.stopTest();
    }
    
    static testMethod void testorderStatusUpdateAndMethod(){
        Test.startTest();
        Activation_Order__c ActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        Activation_Contact__c objActivationContact =  [SELECT Id,Activation_Order__c, Email__c, Contact_Role__c FROM Activation_Contact__c WHERE Activation_Order__c =: ActOrder.Id LIMIT 1]; 
        
        PageReference thePage = page.Account_Setup;     
        thePage.getParameters().put('order', ActOrder.Id);
        thePage.getParameters().put('conActID', objActivationContact.Id);
        Test.setCurrentPage(thePage);
        Act_Payment_Component_Controller objActPaymentComponentController = new Act_Payment_Component_Controller();
        Activation_Status__c objActivationStatus = [SELECT Id,name,Account_Setup_Active_Tab__c FROM Activation_Status__c WHERE Activation_Order__c =: ActOrder.Id LIMIT 1];
        objActPaymentComponentController.strCreditCardNumber = '1234567891234';
        //objActPaymentComponentController.strCreditCardExDate = '12/2020';
        objActPaymentComponentController.strCreditCardCVV = '123';
        Map<String, List<String>> mapXmlNodeValue = New Map<String, List<String>>();
        mapXmlNodeValue.put('customerProfileId', New List<String>{'12345678'});
        mapXmlNodeValue.put('customerPaymentProfileId', New List<String>{'12345678'});
        mapXmlNodeValue.put('validationDirectResponse', New List<String>{'e,r,t,XXXX1234,Visa,3'});
        
        objActPaymentComponentController.mapXmlNodeValue = mapXmlNodeValue;
        List<Customer_Profile__c> lstCustomerProfile = [SELECT ID FROM Customer_Profile__c];
		if( lstCustomerProfile.size()>0 ) delete lstCustomerProfile;
        objActPaymentComponentController.strMonth = '12';
        objActPaymentComponentController.strYear = String.valueOf(Date.Today().Year()+2);
        objActPaymentComponentController.saveprofiles();
        objActPaymentComponentController.actStatus = objActivationStatus;
        PageReference pageRef = page.Account_Setup;  
        //objActPaymentComponentController.orderStatusUpdate();
        PageReference pageRef1 =  objActPaymentComponentController.gototab();
        pageRef.getParameters().put('order',pageRef1.getParameters().get('order'));
        system.assertEquals(pageRef.getUrl(),pageRef1.getUrl());
        objActPaymentComponentController.accountsListView();
        objActPaymentComponentController.strAttachmentName = 'test.pdf';
        objActPaymentComponentController.strAttachmentBody = 'abcd';
        objActPaymentComponentController.strAttachmentType = 'application/pdf';
        objActPaymentComponentController.uploadCreditAttachment();
        Test.stopTest();
    }
}