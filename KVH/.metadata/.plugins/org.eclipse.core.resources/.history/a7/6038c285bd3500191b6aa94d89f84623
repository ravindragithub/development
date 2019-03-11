@isTest
private class subscriptionTrigger_Test{
    
    public static Account objAccount;
    public static Billing_Account__c objBillAcc;
    public static Product2  prod;
    static void setupdata(){       
        // Account creation
        Id acc_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        Id act_Order_RecordtypeId = Schema.SObjectType.Activation_Order__c.getRecordTypeInfosByName().get('Customer Activation').getRecordTypeId();
        Id Bill_Acc_RecordtypeId = Schema.SObjectType.Billing_Account__c.getRecordTypeInfosByName().get('BaaN Account').getRecordTypeId();
        
        //Account Creation
        objAccount = New Account(Name ='testname', KVH_Sales_Office__c = 'KB Satcom', Account_Type__c='Customer', Market__c='Leisure');
        objAccount.RecordTypeId = acc_RecordTypeId;          
        insert objAccount; 
        system.assert(objAccount !=Null);
        
        //Contact creation
        Contact cont = new Contact();
        cont.LastName = 'Test Contact';
        cont.AccountId = objAccount.Id;
        insert cont;
        //Billing Account Creation
        objBillAcc = New Billing_Account__c(Name='testbill',Billing_Account_ID__c='138');
        objbillAcc.Account__c = objAccount.Id;
        objBillAcc.RecordTypeId = Bill_Acc_RecordtypeId;
        objBillAcc.Main_Contact__c = cont.Id;
        insert objBillAcc;
        system.assert(objBillAcc!=Null);
        
        //Product Creation
        prod = new Product2();
        prod.Name = 'Virtual Terminal ID';
        prod.ProductCode = '02-2103';
        insert prod;
        
        
        //Asset Creation
        Asset asst= new Asset();
        asst.Name ='Asset Test';
        asst.Date_Shipped__c = system.today();
        asst.Product2Id = prod.Id;
        insert asst;
        
        //Contract creation
        Contract contrt = new Contract(
                AccountId = objAccount.Id
                ,ContractTerm = 12
                ,StartDate = system.today()
                ,OwnerExpirationNotice = '30'
                ,Billing_Account__c = objBillAcc.Id
            );
        insert contrt ;
        
        //SBQQ__Subscription__c creation
        List<SBQQ__Subscription__c> lstSubs = new List<SBQQ__Subscription__c>();
        for(integer i = 0; i<20; i++){
        SBQQ__Subscription__c subs = new SBQQ__Subscription__c();
        subs.SBQQ__Quantity__c = 100;
        subs.SBQQ__Contract__c = contrt.Id;
        subs.Asset__c = asst.Id;
        lstSubs.add(subs);
        }
        insert lstSubs;
        
        lstSubs[0].SBQQ__Quantity__c = 101;
        update lstSubs;
        
        
    }
    static testmethod void subscriptionTriggerMethod()
    {    
        Test.startTest();
        setupdata();
        Test.stopTest();
    }
}