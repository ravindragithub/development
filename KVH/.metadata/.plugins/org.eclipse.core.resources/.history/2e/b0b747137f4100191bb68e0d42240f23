@isTest
private class SalesOrders_AgilePlans_RootAsset_Test{
    
    public static Account objAccount;
    public static Billing_Account__c objBillAcc;
    public static Product2  prod;
    public static List<Asset> lstAsset;
    static void setupdata(){       
        // Account creation
        Id acc_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        Id act_Order_RecordtypeId = Schema.SObjectType.Activation_Order__c.getRecordTypeInfosByName().get('Customer Activation').getRecordTypeId();
        Id Bill_Acc_RecordtypeId = Schema.SObjectType.Billing_Account__c.getRecordTypeInfosByName().get('BaaN Account').getRecordTypeId();
        objAccount = New Account(Name ='testname', KVH_Sales_Office__c = 'KB Satcom', Account_Type__c='Customer', Market__c='Leisure');
        objAccount.RecordTypeId = acc_RecordTypeId;          
        insert objAccount; 
        system.assert(objAccount !=Null);
        
        //Billing Account Creation
        objBillAcc = New Billing_Account__c(Name='testbill',Billing_Account_ID__c='138');
        objbillAcc.Account__c = objAccount.Id;
        objBillAcc.RecordTypeId = Bill_Acc_RecordtypeId;
        insert objBillAcc;
        system.assert(objBillAcc!=Null);
        
        //Product Creation
        prod = new Product2();
        prod.Name = 'AGILEPLANS-TPV7IP';
        prod.ProductCode = '02-2103';
        insert prod;
        
        //Creation of Custom Setting
        ProductParentAsset__c csProd = new ProductParentAsset__c();
        csProd.Name = 'Test';
        csProd.Product_Name__c = 'AGILEPLANS-TPV7IP';
        insert csProd;
        //Sales Order Creation
        List<Sales_Order__c> lstSalesOrder= new List<Sales_Order__c>();
        for(Integer i=0 ;i <10;i++)
        {
            Sales_Order__c salsOrd = new Sales_Order__c();
            salsOrd.Name ='Test Sales Order '+i;
            salsOrd.Account__c = objAccount.id;
            salsOrd.Billing_Account__c = objBillAcc.id;
            lstSalesOrder.add(salsOrd);
        }
        insert lstSalesOrder;
        
        //Sales Order Line Creation
        List<Order_Line__c> lstSalesOrderLine= new List<Order_Line__c>();
        for(Integer i=0 ;i <10;i++)
        {
            Order_Line__c salsOrdLine = new Order_Line__c();
            salsOrdLine.Name ='Test Sales Order Line '+i;
            salsOrdLine.Sales_Order__c = lstSalesOrder[i].id;
            salsOrdLine.Item__c = prod.id;
            lstSalesOrderLine.add(salsOrdLine);
        }
        insert lstSalesOrderLine;
        
        //Asset Creation
        lstAsset= new List<Asset>();
        for(Integer i=0 ;i <10;i++)
        {
            Asset asst= new Asset();
            asst.Name ='Asset '+i;
            asst.Sales_Order__c = lstSalesOrder[i].id;
            asst.Date_Shipped__c = system.today();
            lstAsset.add(asst);
        }
        for(Integer i=0 ;i <5;i++)
        {
            Asset asst= new Asset();
            asst.Name ='Asset '+i+'_-AP';
            asst.Sales_Order__c = lstSalesOrder[i].id;
            asst.Date_Shipped__c = system.today();
            lstAsset.add(asst);
        }
        insert lstAsset;
        
    }
    static testmethod void createParentAssetBatchMethod()
    {    
        
        Test.startTest();
        //Call the test data creation method
        setupdata();
        //Call the Batch class instance
        //SalesOrders_AgilePlans_RootAsset_Batch obj = new SalesOrders_AgilePlans_RootAsset_Batch(); 
        //Id BatchId = database.executeBatch(obj);
        SalesOrders_AgilePlans_RootAsset_Schld obj = new SalesOrders_AgilePlans_RootAsset_Schld();   
         String chron = '0 0 23 * * ?';        
         String jobid = System.schedule('testScheduledApex', chron, obj);
             
        Test.stopTest();
    }
}