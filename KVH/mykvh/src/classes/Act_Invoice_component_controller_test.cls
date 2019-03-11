@istest 
Private class Act_Invoice_component_controller_test {

     @testSetup static void setupTestData(){
        
        Activation_Order__c objActivationOrder = new Activation_Order__c();
        objActivationOrder.isSelf_Activation__c = true;
        objActivationOrder.User_Agent_String__c = 'test User-Agent string';
        insert objActivationOrder;
        
        Activation_Status__c objOrderStatus = new Activation_Status__c();
        objOrderStatus.Activation_Order__c = objActivationOrder.Id;
        insert objOrderStatus;
        
        Activation_Contact__c objActivationContact = new Activation_Contact__c();
        objActivationContact.Activation_Order__c = objActivationOrder.id;
        objActivationContact.Email__c = 'test@4test.com';
        insert objActivationContact;
        
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
        objActivationSubscriber.State_Province__c = 'Rhode Island';
        objActivationSubscriber.Phone_Number__c = '401-555-1212';
        objActivationSubscriber.Same_as_Company_Address__c=true;
        objActivationSubscriber.Mail_to__c = 'Both';
        objActivationSubscriber.Billing_Rep_Name__c = 'TestName';
        objActivationSubscriber.Activation_Order__c = objActivationOrder.id;
        insert objActivationSubscriber;
    }
     static testMethod void testActivationInvoiceSubscriberMethod(){
        Activation_Order__c objActOrder = [SELECT Id, Name FROM Activation_Order__c LIMIT 1];
        PageReference thePage = page.activation_corporate;     
        thePage.getParameters().put('order', objActOrder.Id);                   // set current page with parameter 'order'
        Test.setCurrentPage(thePage);
        Test.startTest(); 
        Act_Invoice_component_controller objActInvoiceSectioncontroller = new Act_Invoice_component_controller();
        objActInvoiceSectioncontroller.ActivationOrderId=objActOrder.Id;
        system.assertEquals(objActOrder.Id, objActInvoiceSectioncontroller.ActivationOrderId);     // Passed Order Id
        objActInvoiceSectioncontroller.getCountriesList();
        objActInvoiceSectioncontroller.getStatesList();
        objActInvoiceSectioncontroller.callDisableFunction();
        objActInvoiceSectioncontroller.mapAddressMapping();
        objActInvoiceSectioncontroller.componentStateChangeHandler();
        objActInvoiceSectioncontroller.actStatus = [SELECT Id,Activation_Order__c FROM Activation_Status__c WHERE Activation_Order__c =:objActOrder.Id LIMIT 1];
        objActInvoiceSectioncontroller.selectedTab = 'Invoicing_Preferences'; //Pass Selected Tab
        objActInvoiceSectioncontroller.save();
        objActInvoiceSectioncontroller.saveandExit();
        objActInvoiceSectioncontroller.objActivationSubscriber = New Activation_Subscriber__c(Contact_Role__c ='Subscriber', Activation_Order__c = objActOrder.Id,Same_as_Company_Address__c=false); // to cover null id condition
        objActInvoiceSectioncontroller.parentContainer = 'Dummy Container';
        objActInvoiceSectioncontroller.callDisableFunction();
        objActInvoiceSectioncontroller.updateSubscriber();
        system.assertEquals('System.PageReference[/apex/activation_corporate?order='+(string)objActOrder.Id+']',string.valueOf(thePage)); // return page reference validate
        Test.stopTest();
     }
}