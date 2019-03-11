@isTest
Private Class InvoiceCommissionCreationBatchTest{
    static testMethod void InvoiceCommissionCreationBatch(){
        CustomSettingOrderItTestClassReuseCode.insertCustomSettings();

        Id kvaccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('KV Partner').getRecordTypeId();

        // don't change the billing country field as VAT will be calculated based on this
        Account acc = new Account(Name = 'Test Account', BillingCountry = 'United Kingdom', recordtypeID = kvaccountRecordTypeId);
        insert acc;

        invoiceit_s__Currency__c currency1 = new invoiceit_s__Currency__c(Name = 'EUR', invoiceit_s__Symbol__c = '£');
        insert currency1;

        //Master order Creation
        invoiceit_s__Job__c masterOrder = new invoiceit_s__Job__c(invoiceit_s__Account__c = acc.id, invoiceit_s__Sub_Total__c = 100, invoiceit_s__Discount_Value__c = 0, invoiceit_s__CurrencyL__c = currency1.Id);
        masterOrder.invoiceit_s__Account__c = acc.Id;
        masterOrder.IITIntended_Use__c = 'LOCAL UK WATERS';
        masterOrder.Withholding_Tax_Percentage__c = 10;
        masterOrder.BMS_Contract_Year__c = 1;
        insert masterOrder;
        
        invoiceit_s__Invoice__c invoice = new invoiceit_s__Invoice__c(invoiceit_s__Account__c = acc.id,
                invoiceit_s__CurrencyL__c = currency1.Id, invoiceit_s__Target_Date__c = Date.today(), invoiceit_s__Delivery_Type__c = 'Both', invoiceit_s__Invoice_Status__c = 'Posted'
                    ,invoiceit_s__Invoice_Date__c = System.today()
        );
        insert invoice;
     
       
        //Child Order Creation
        invoiceit_s__Job__c childOrder = new invoiceit_s__Job__c(invoiceit_s__Account__c = acc.id, invoiceit_s__Sub_Total__c = 100, invoiceit_s__Discount_Value__c = 0, invoiceit_s__CurrencyL__c = currency1.Id);
        childOrder.invoiceit_s__Account__c = acc.Id;
        childOrder.IITIntended_Use__c = 'LOCAL UK WATERS';
        childOrder.Withholding_Tax_Percentage__c = 10;
        childOrder.BMS_Contract_Year__c = 1;
        childOrder.Mid_Term_Order__c = true;
        childOrder.invoiceit_s__Master_Order__c = masterOrder.id;
        childOrder.RecordTypeID = Schema.SObjectType.invoiceit_s__Job__c.getRecordTypeInfosByName().get('Child Order').getRecordTypeId();
        insert childOrder;
        
         //Product Creation
        invoiceit_s__Product__c invoiceProduct = New invoiceit_s__Product__c();
        invoiceProduct.Commissionable_Product__c = true;
        insert invoiceProduct;
        
         //OrderCommision Creation
        list<Order_Commissions__c> orderCommissions = New list<Order_Commissions__c>();
        Order_Commissions__c oc = New Order_Commissions__c();
        oc.Order_Product__c = invoiceProduct.id;
        oc.Sales_Agent__c = acc.id;
        oc.Order_for_Commission__c = masterOrder.id;
        orderCommissions.add(oc);
        
        Order_Commissions__c oc1 = New Order_Commissions__c();
        oc1.Order_Product__c = invoiceProduct.id;
        oc1.Sales_Agent__c = acc.id;
        oc1.Order_for_Commission__c = childOrder.id;
        orderCommissions.add(oc1);
        
        Order_Commissions__c oc2 = New Order_Commissions__c();
        oc2.Order_Product__c = invoiceProduct.id;
        oc2.Sales_Agent__c = acc.id;
        oc2.Order_for_Commission__c = childOrder.id;
        orderCommissions.add(oc2);
        
        insert orderCommissions;
        
        list<invoiceit_s__Invoice_Lines__c> listInvoiceLines = new list<invoiceit_s__Invoice_Lines__c>();
        listInvoiceLines.add(new invoiceit_s__Invoice_Lines__c(invoiceit_s__Invoice__c = invoice.id, invoiceit_s__Line_Name__c = 'Broadband Installation For L',invoiceit_s__Quantity__c = 1,invoiceit_s__Unit_Price__c = 40.00,invoiceit_s__VAT__c = 8.00,invoiceit_s__Line_Amount__c = 40.00,invoiceit_s__Job__c = childOrder.Id,invoiceit_s__Product__c=invoiceProduct.id));
        insert listInvoiceLines;
        
        
        InvoiceLineCommissions__c ILC = New InvoiceLineCommissions__c();
        String Yearvalue  = String.valueOF(Date.Today().Year());
        String Monthvalue = String.valueOF(Date.Today().Month());
        String Datevalue  = String.valueOF(Date.Today().Day());
        
        ILC.Name              = 'Year,month,date';
        ILC.InvoiceLine_ED__c = Yearvalue+','+Monthvalue+','+Datevalue;
        ILC.InvoiceLine_SD__c = Yearvalue+','+Monthvalue+','+Datevalue;
        insert ILC;
    
        test.startTest();
            InvoiceCommissionCreationBatch iccb = New InvoiceCommissionCreationBatch();
            DataBase.ExecuteBatch(iccb);
        test.stopTest();
    }
}