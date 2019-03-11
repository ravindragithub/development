@isTest(seeallData=true)
public with sharing class TestBatchUpdateOrders {
    public static testMethod void testBatchClass() {

        
        Id kvaccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('KV Platform').getRecordTypeId();

        // don't change the billing country field as VAT will be calculated based on this
        Account accountObj = new Account(Name = 'Test Account', BillingCountry = 'United Kingdom', recordtypeID = kvaccountRecordTypeId);
        insert accountObj;
        
        invoiceit_s__Currency__c currencyObj = new invoiceit_s__Currency__c(invoiceit_s__Currency_Symbol__c='USD');
        insert currencyObj;
        
        Id orderRecordTypeId = Schema.SObjectType.invoiceit_s__Job__c.getRecordTypeInfosByName().get('Child Order').getRecordTypeId();
        
        Id masterorderRecordTypeId = Schema.SObjectType.invoiceit_s__Job__c.getRecordTypeInfosByName().get('Master Order').getRecordTypeId();
        
        invoiceit_s__Job__c orderMasterObj = new invoiceit_s__Job__c(RecordTypeId = masterorderRecordTypeId, Name = 'MasterOrder',Invoice_Details__c = 'Consolidated',Alignment_Date_1__c = System.Today(),invoiceit_s__Account__c = accountObj.Id,invoiceit_s__CurrencyL__c=currencyObj.Id);
        insert orderMasterObj;
         
        invoiceit_s__Job__c orderObj = new invoiceit_s__Job__c(invoiceit_s__Master_Order__c =orderMasterObj.Id, RecordTypeId = orderRecordTypeId, Name = 'ChildOrder1',Invoice_Details__c = 'Consolidated',Alignment_Date_1__c = System.Today(),invoiceit_s__Account__c = accountObj.Id,invoiceit_s__CurrencyL__c=currencyObj.Id);
        insert orderObj;

        system.Test.startTest();
        BatchUpdateOrders b = new BatchUpdateOrders();
        Id batchInstanceId = Database.executeBatch(b, 1);
        system.debug(batchInstanceId);
        system.Test.stopTest();
      

    }
    public static testMethod void testSchedulerClass() {

     RunSchedulerUpdateOrders sh1 = new RunSchedulerUpdateOrders();
            String sch = '0 0 23 * * ?';
            system.schedule('RunSchedulerUpdateOrders', sch, sh1);
            BatchUpdateOrders batch=new BatchUpdateOrders();
            ID batchprocessid = Database.executeBatch(batch, 1);
       
   }  
    
}