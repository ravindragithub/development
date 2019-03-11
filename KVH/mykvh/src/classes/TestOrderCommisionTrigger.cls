@isTest
Private Class TestOrderCommisionTrigger{
    Static testMethod void OrderCommisionTrigger(){
         // insert the custom settings
        IITTestClassForPhase1.insertCustomSettings();
    
        //Partner Creation
        Account acc = New Account();
        acc.RecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('KV Partner').getRecordTypeId();
        acc.Name = 'TestAcc';
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
        
        
        
        //Child Order Creation
        invoiceit_s__Job__c childOrder = new invoiceit_s__Job__c(invoiceit_s__Account__c = acc.id, invoiceit_s__Sub_Total__c = 100, invoiceit_s__Discount_Value__c = 0, invoiceit_s__CurrencyL__c = currency1.Id);
        childOrder.invoiceit_s__Account__c = acc.Id;
        childOrder.IITIntended_Use__c = 'LOCAL UK WATERS';
        childOrder.Withholding_Tax_Percentage__c = 10;
        childOrder.BMS_Contract_Year__c = 1;
        childOrder.Mid_Term_Order__c = true;
        childOrder.invoiceit_s__Master_Order__c = masterOrder.id;
        insert childOrder;

        
        //Product Creation
        invoiceit_s__Product__c invoiceProduct = New invoiceit_s__Product__c();
        insert invoiceProduct;
        
        //Partner Commission Record Creation
        Partner_Commission_Rates__c pcr = New Partner_Commission_Rates__c();
        pcr.Partner_Agent_Account__c = acc.Id;
        pcr.Product__c = invoiceProduct.id;
        pcr.Standard_Comm__c = 1.0;
        pcr.Year1_Commission__c = 1.0;
        insert pcr;
        
        
        //OrderCommision Creation
        list<Order_Commissions__c> orderCommissions = New list<Order_Commissions__c>();
        Order_Commissions__c oc = New Order_Commissions__c();
        oc.Order_Product__c = invoiceProduct.id;
        oc.Sales_Agent__c = acc.id;
        oc.Order_for_Commission__c = childOrder.id;
        orderCommissions.add(oc);
        
        Order_Commissions__c oc1 = New Order_Commissions__c();
        oc1.Order_Product__c = invoiceProduct.id;
        oc1.Sales_Agent__c = acc.id;
        oc1.Order_for_Commission__c = masterOrder.id;
        orderCommissions.add(oc1);
        
        Order_Commissions__c oc2 = New Order_Commissions__c();
        oc2.Order_Product__c = invoiceProduct.id;
        oc2.Sales_Agent__c = acc.id;
        oc2.Order_for_Commission__c = masterOrder.id;
        orderCommissions.add(oc2);
        
        insert orderCommissions;
        
        update oc;
    }
    
}