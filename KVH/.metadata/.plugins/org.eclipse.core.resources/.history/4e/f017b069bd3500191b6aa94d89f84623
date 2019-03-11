/* ************************************************************
 * Created By  : Gopi Kishore
 * Created Date: __/__/20__ 
 * Description : OrderInvoiceITTriggerTest class used to test OrderInvoiceITTrigger.
                 1) If invoice order update it will validate related Product job Name contains "VOD".If Yes trigger creates new Case Record. 
 *               2) If invoice order update it will validate related case contains "New VOD Order" case symtom.If Yes trigger it wont create new Case Record. 
                 3) If invoice order create,update,delete it will create rollup count on Account - Active_Orders__c field.if order - invoiceit_s__Status__c!=:'Completed/Cancelled' 
 * Modified By   :
 * Modified Date : 
 * Description   :
 * 
 * ************************************************************/


@isTest
Private Class OrderInvoiceITTriggerTest{
    
    
    //Following Method will Cover Trigger(OrderInvoiceITTrigger) to create new case if VOD invoicejobproduct exists.
    
    Static testmethod void OrderInvoiceITTrigger(){
      
        CustomSettingOrderItTestClassReuseCode.insertCustomSettings();
      
        Id kvaccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('KV Platform').getRecordTypeId();
        
        Test.StartTest();
        Account acc = new Account(Name = 'Test Account', BillingCountry = 'United Kingdom', recordtypeID = kvaccountRecordTypeId);
        insert acc;
        
        DefaultQueues__c dq = New DefaultQueues__c();
        dq.Name = 'VOD Production Team';
        dq.Description__c = 'test Description';
        dq.Queue_Id__c = UserInfo.getUserId();
        insert dq;

        invoiceit_s__Product__c invoiceItProduct = new invoiceit_s__Product__c(invoiceit_s__Valid_From_Date__c = system.today(), Name = 'VOD');
        insert invoiceItProduct;
        
        invoiceit_s__Product_Rate_Plan__c ratePlan = new invoiceit_s__Product_Rate_Plan__c(Name = 'Full VOD', invoiceit_s__Valid_From_Date__c = system.today());
        ratePlan.invoiceit_s__Product__c = invoiceItProduct.Id;
        insert ratePlan;
        
        invoiceit_s__Currency__c currency1 = new invoiceit_s__Currency__c(Name = 'EUR', invoiceit_s__Symbol__c = '£');
        insert currency1;
        
        invoiceit_s__Product_Rate_Plan_Charge__c productCharge = new invoiceit_s__Product_Rate_Plan_Charge__c(invoiceit_s__Product_Rate_Plan__c = ratePlan.Id, Name = 'Annual Subscription Fee: Full VOD', invoiceit_s__CurrencyL__c = currency1.Id);
        insert productCharge;
         
         
         invoiceit_s__Job__c jobMaster = new invoiceit_s__Job__c(invoiceit_s__Account__c = acc.id, invoiceit_s__Sub_Total__c = 100, invoiceit_s__Discount_Value__c = 0, invoiceit_s__CurrencyL__c = currency1.Id,name='Order');
         jobMaster.invoiceit_s__Account__c = acc.Id;
         jobMaster.Shipping_Account__c = acc.Id;
         jobMaster.invoiceit_s__Status__c = 'Ready for Fulfillment';
         jobMaster.RecordTypeID = Schema.SObjectType.invoiceit_s__Job__c.getRecordTypeInfosByName().get('Master Order').getRecordTypeId();
         insert jobMaster;
         
         invoiceit_s__Job__c jobChild = new invoiceit_s__Job__c(invoiceit_s__Account__c = acc.id, invoiceit_s__Sub_Total__c = 100, invoiceit_s__Discount_Value__c = 0, invoiceit_s__CurrencyL__c = currency1.Id,name='Order');
         jobChild.invoiceit_s__Account__c = acc.Id;
         jobChild.Shipping_Account__c = acc.Id;
         jobChild.invoiceit_s__Status__c = 'Ready for Fulfillment';
         jobChild.invoiceit_s__Master_Order__c = jobMaster.ID;
         jobChild.RecordTypeID = Schema.SObjectType.invoiceit_s__Job__c.getRecordTypeInfosByName().get('Child Order').getRecordTypeId();
         insert jobChild;
         
         invoiceit_s__Job_Product__c  jobProduct= new invoiceit_s__Job_Product__c(invoiceit_s__Product__c = invoiceItProduct.Id, Name = 'VOD',invoiceit_s__Job__c = jobChild.Id);
         insert jobProduct;
          
         delete jobChild;
         Test.StopTest();
    }
    
    //Following Method will Cover Trigger(OrderInvoiceITTrigger) validate VOD Case exists for jobProduct.
    Static testmethod void OrderInvoiceITTriggerNotCreatingCase(){
      
        CustomSettingOrderItTestClassReuseCode.insertCustomSettings();
      
        Id kvaccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('KV Platform').getRecordTypeId();
        Test.StartTest();
        Account acc = new Account(Name = 'Test Account', BillingCountry = 'United Kingdom', recordtypeID = kvaccountRecordTypeId);
        insert acc;
        
        DefaultQueues__c dq = New DefaultQueues__c();
        dq.Name = 'VOD Production Team';
        dq.Description__c = 'test Description';
        dq.Queue_Id__c = UserInfo.getUserId();
        insert dq;
        
        invoiceit_s__Product__c invoiceItProduct = new invoiceit_s__Product__c(invoiceit_s__Valid_From_Date__c = system.today(), Name = 'VOD');
        insert invoiceItProduct;
        
        invoiceit_s__Product_Rate_Plan__c ratePlan = new invoiceit_s__Product_Rate_Plan__c(Name = 'Full VOD', invoiceit_s__Valid_From_Date__c = system.today());
        ratePlan.invoiceit_s__Product__c = invoiceItProduct.Id;
        insert ratePlan;
        
        invoiceit_s__Currency__c currency1 = new invoiceit_s__Currency__c(Name = 'EUR', invoiceit_s__Symbol__c = '£');
        insert currency1;
        
        invoiceit_s__Product_Rate_Plan_Charge__c productCharge = new invoiceit_s__Product_Rate_Plan_Charge__c(invoiceit_s__Product_Rate_Plan__c = ratePlan.Id, Name = 'Annual Subscription Fee: Full VOD', invoiceit_s__CurrencyL__c = currency1.Id);
        insert productCharge;
         
         
         
         invoiceit_s__Job__c jobMaster = new invoiceit_s__Job__c(invoiceit_s__Account__c = acc.id, invoiceit_s__Sub_Total__c = 100, invoiceit_s__Discount_Value__c = 0, invoiceit_s__CurrencyL__c = currency1.Id,name='Order');
         jobMaster.invoiceit_s__Account__c = acc.Id;
         jobMaster.Shipping_Account__c = acc.Id;
         jobMaster.invoiceit_s__Status__c = 'Ready for Fulfillment';
         jobMaster.RecordTypeID = Schema.SObjectType.invoiceit_s__Job__c.getRecordTypeInfosByName().get('Master Order').getRecordTypeId();
         insert jobMaster;
         
         invoiceit_s__Job__c jobChild = new invoiceit_s__Job__c(invoiceit_s__Account__c = acc.id, invoiceit_s__Sub_Total__c = 100, invoiceit_s__Discount_Value__c = 0, invoiceit_s__CurrencyL__c = currency1.Id,name='Order');
         jobChild.invoiceit_s__Account__c = acc.Id;
         jobChild.Shipping_Account__c = acc.Id;
         jobChild.invoiceit_s__Status__c = 'Ready for Fulfillment';
         jobChild.invoiceit_s__Master_Order__c = jobMaster.ID;
         jobChild.RecordTypeID = Schema.SObjectType.invoiceit_s__Job__c.getRecordTypeInfosByName().get('Child Order').getRecordTypeId();
         insert jobChild;
         
         invoiceit_s__Job_Product__c  jobProduct= new invoiceit_s__Job_Product__c(invoiceit_s__Product__c = invoiceItProduct.Id, Name = 'VOD',invoiceit_s__Job__c = jobChild.Id);
         insert jobProduct;
         
         Case newVODCase = New Case();
         newVODCase.InvoiceIT_Order__c = jobChild.id;
         newVODCase.Case_Symptom__c = 'New VOD Order';
         newVODCase.Status = 'New';
         newVODCase.RecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('KV Production Support').getRecordTypeId();
         newVODCase.AccountID = jobChild.invoiceit_s__Account__c;
         insert newVODCase;
         
         update jobChild;
         
    }
}