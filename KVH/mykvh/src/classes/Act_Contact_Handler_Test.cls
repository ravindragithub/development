@isTest
private class Act_Contact_Handler_Test{
    
    private static Account objAccount;
    
    @testSetup private static void setupdata(){       
        // Account creation
        Id acc_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        Id act_Order_RecordtypeId = Schema.SObjectType.Activation_Order__c.getRecordTypeInfosByName().get('Customer Activation').getRecordTypeId();
        Id Bill_Acc_RecordtypeId = Schema.SObjectType.Billing_Account__c.getRecordTypeInfosByName().get('BaaN Account').getRecordTypeId();
        objAccount = New Account(Name ='testname', KVH_Sales_Office__c = 'KB Satcom', Account_Type__c='Customer', Market__c='Leisure');
        objAccount.RecordTypeId = acc_RecordTypeId;          
        Insert objAccount; 
        system.assert(objAccount !=Null);
        
        //Billing Account Creation
        Billing_Account__c objBillAcc = New Billing_Account__c(Name='testbill',Billing_Account_ID__c='138');
        objbillAcc.Account__c = objAccount.Id;
        objBillAcc.RecordTypeId = Bill_Acc_RecordtypeId;
        Insert objBillAcc;
        system.assert(objBillAcc!=Null);
        
        //Activation Order Creation    
        Activation_Order__c objActOrder = New Activation_Order__c();
        objActOrder.Billing_Account__c = objbillAcc.Id;        
        objActOrder.RecordTypeId = act_Order_RecordtypeId ; 
        Insert objActOrder ; 
        system.assert(objActOrder != Null);        
    }
    
    private static testmethod void activationconTest1(){    
        test.startTest();
        objAccount = [SELECT Name FROM Account];
        Activation_Order__c objActivationOrder = [SELECT Id,Name FROM Activation_Order__c];
        system.assert(objAccount != Null);
        
        Contact objContact = New Contact(FirstName='test',LastName='name',Phone='1234567890',Email='test@gmail.com'); 
        objContact.AccountId = objAccount.Id;
        Insert objContact;
        
        system.assert(objContact!=Null); 
        
        Activation_Contact__c objActivationContact = New Activation_Contact__c(First_Name__c='test',Last_Name__c='name',Primary_Phone__c='1234567890',Email__c='test@gmail.com');
        objActivationContact.Activation_Order__c = objActivationOrder.Id;
        Insert objActivationContact ;
        system.assert(objActivationContact != Null);  
        //Testing the output data from trigger update -- Act_Contact Trigger
        system.assertEquals(objContact.Id, [SELECT Contact__c FROM Activation_Contact__c WHERE Id =: objActivationContact.Id].Contact__c); 
        system.assertEquals(false, [SELECT Review_Contact_Detail__c FROM Activation_Contact__c WHERE Id =: objActivationContact.Id].Review_Contact_Detail__c); 
        
        
        Activation_Contact__c objActivationContact1 = New Activation_Contact__c(First_Name__c='test1',Last_Name__c='name1',Primary_Phone__c='1234567890',Email__c='test1@gmail.com');
        objActivationContact1.Activation_Order__c = objActivationOrder.Id;
        Insert objActivationContact1 ;
        system.assert(objActivationContact1 != Null);  
        //Testing the output data from trigger update -- Act_Contact Trigger
        system.assertNotEquals(objContact.Id, [SELECT Contact__c FROM Activation_Contact__c WHERE Id =: objActivationContact1.Id].Contact__c); 
        system.assertEquals(false, [SELECT Review_Contact_Detail__c FROM Activation_Contact__c WHERE Id =: objActivationContact1.Id].Review_Contact_Detail__c); 
        test.stopTest();
    }
}