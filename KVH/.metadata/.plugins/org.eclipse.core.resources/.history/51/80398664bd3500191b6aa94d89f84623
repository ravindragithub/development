@isTest
private class IITTestClassForPriceUplift {
    /*@isTest static void newMethod1() {
        // insert the custom settings
        IITTestClassForPhase1.insertCustomSettings();

        Id kvaccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('KV Platform').getRecordTypeId();

        // don't change the billing country field as VAT will be calculated based on this
        Account acc = new Account(Name = 'Test Account', BillingCountry = 'United Kingdom', recordtypeID = kvaccountRecordTypeId);
        insert acc;

        invoiceit_s__Product__c invoiceItProduct = new invoiceit_s__Product__c(invoiceit_s__Valid_From_Date__c = system.today(), Name = 'Test');
        insert invoiceItProduct;

        invoiceit_s__Product_Rate_Plan__c ratePlan = new invoiceit_s__Product_Rate_Plan__c(Name = 'Full......', invoiceit_s__Valid_From_Date__c = system.today());
        ratePlan.invoiceit_s__Product__c = invoiceItProduct.Id;
        insert ratePlan;

        invoiceit_s__Currency__c currency1 = new invoiceit_s__Currency__c(Name = 'EUR', invoiceit_s__Symbol__c = '£');
        insert currency1;

        invoiceit_s__Product_Rate_Plan_Charge__c productCharge = new invoiceit_s__Product_Rate_Plan_Charge__c(invoiceit_s__Product_Rate_Plan__c = ratePlan.Id, Name = 'Annual Subscription Fee: Full', invoiceit_s__CurrencyL__c = currency1.Id);
        insert productCharge;

        // this will cover the IITClassAfterOnOrderRatePlanCharges
        invoiceit_s__Job__c job = new invoiceit_s__Job__c(invoiceit_s__Account__c = acc.id, invoiceit_s__Sub_Total__c = 100, invoiceit_s__Discount_Value__c = 0, invoiceit_s__CurrencyL__c = currency1.Id);
        job.invoiceit_s__Account__c = acc.Id;
        job.Shipping_Account__c = acc.Id;
        job.IITIntended_Use__c = 'LOCAL UK WATERS';
        job.Withholding_Tax_Percentage__c = 10;
        job.BMS_Contract_Year__c = 1;
        job.BMS_Contract_Year__c = 3;
        insert job;

        invoiceit_s__Job_Product__c  jobProduct= new invoiceit_s__Job_Product__c(invoiceit_s__Product__c = invoiceItProduct.Id, Name = 'jobProduct',invoiceit_s__Job__c = job.Id);
        insert jobProduct;

        invoiceit_s__Job_Rate_Plan__c jobRP = new invoiceit_s__Job_Rate_Plan__c(invoiceit_s__Product_Rate_Plan__c = ratePlan.Id, Name = 'JobRP',invoiceit_s__Job_Product__c =jobProduct.Id);
        insert jobRP;

        list<invoiceit_s__Job_Rate_Plan_Charge__c> charges = new list<invoiceit_s__Job_Rate_Plan_Charge__c>();
        invoiceit_s__Job_Rate_Plan_Charge__c charge = new invoiceit_s__Job_Rate_Plan_Charge__c(invoiceit_s__Product_Rate_Plan_Charge__c = productCharge.Id);
        charge.Name = 'Charge1';
        charge.invoiceit_s__Order__c = job.Id;
        charge.invoiceit_s__Job_Rate_Plan__c =jobRP.Id;
        charge.invoiceit_s__Status__c = 'Ready to be Invoiced';
        charge.invoiceit_s__Quantity__c = 1;
        charge.invoiceit_s__Price_Type__c = 'Half Yearly';
        charge.invoiceit_s__Accounting_Code__c = '12345';
        charge.invoiceit_s__Charge_Date__c = system.today();
        charge.invoiceit_s__Unit_Price__c = 100;
        charge.invoiceit_s__Service_Activation_Date__c = System.today();
        charge.invoiceit_s__Service_End_Date__c = charge.invoiceit_s__Service_Activation_Date__c.addYears(4);
        charge.Next_Uplift_Date__c = System.today().addMonths(12);
        charge.invoiceit_s__Uplift__c = 2;
        charge.invoiceit_s__VAT_Percentage__c = 0;    
        charge.invoiceit_s__Tax_Percentage__c = 0;  
        charge.invoiceit_s__Tax__c = 0;  
        charge.invoiceit_s__VAT_Percentage__c = 0; 
        charges.add(charge);

        invoiceit_s__Job_Rate_Plan_Charge__c charge1 = new invoiceit_s__Job_Rate_Plan_Charge__c(invoiceit_s__Product_Rate_Plan_Charge__c = productCharge.Id);
        charge1.Name = 'Charge1';
        charge1.invoiceit_s__Order__c = job.Id;
        charge1.invoiceit_s__Job_Rate_Plan__c =jobRP.Id;
        charge1.invoiceit_s__Status__c = 'Ready to be Invoiced';
        charge1.invoiceit_s__Quantity__c = 1;
        charge1.invoiceit_s__Price_Type__c = 'Annual';
        charge1.invoiceit_s__Accounting_Code__c = '12345';
        charge1.invoiceit_s__Charge_Date__c = system.today();
        charge1.invoiceit_s__Unit_Price__c = 100;
        charge1.invoiceit_s__Service_Activation_Date__c = System.today();
        charge1.invoiceit_s__Service_End_Date__c = charge.invoiceit_s__Service_Activation_Date__c.addYears(4);
        charge1.Next_Uplift_Date__c = System.today().addMonths(12);
        charge1.invoiceit_s__Uplift__c = 2;
        charge1.invoiceit_s__VAT_Percentage__c = 0;    
        charge1.invoiceit_s__Tax_Percentage__c = 0;  
        charge1.invoiceit_s__Tax__c = 0;  
        charge1.invoiceit_s__VAT_Percentage__c = 0; 
        charges.add(charge1);
        insert charges;

        // code for 
        invoiceit_s__Invoice__c invoice = new invoiceit_s__Invoice__c();
        invoice.invoiceit_s__Account__c = acc.Id;
        insert invoice;

        list<invoiceit_s__Invoice_Lines__c> invLines = new list<invoiceit_s__Invoice_Lines__c>();
        invoiceit_s__Invoice_Lines__c invoiceLine = new invoiceit_s__Invoice_Lines__c();
        invoiceLine.invoiceit_s__Job__c = job.Id;
        invoiceLine.invoiceit_s__Invoice__c = invoice.Id;
        invoiceline.invoiceit_s__Service_Start_Date__c = system.today().addMonths(1);
        invoiceline.invoiceit_s__Service_End_Date__c = system.today().addMonths(18);
        invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__c = charges[0].Id;
        invoiceLine.invoiceit_s__Unit_Price__c = 100;
        invoiceline.invoiceit_s__Quantity__c = 1;
        invoiceline.invoiceit_s__Discount_Value__c = 0;
        invoiceline.Split_Invoice__c = false;
        invLines.add(invoiceline);

        invoiceLine = new invoiceit_s__Invoice_Lines__c();
        invoiceLine.invoiceit_s__Job__c = job.Id;
        invoiceLine.invoiceit_s__Invoice__c = invoice.Id;
        invoiceline.invoiceit_s__Service_Start_Date__c = system.today().addMonths(1);
        invoiceline.invoiceit_s__Service_End_Date__c = system.today().addMonths(18);
        invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__c = charges[1].Id;
        invoiceLine.invoiceit_s__Unit_Price__c = 100;
        invoiceline.invoiceit_s__Quantity__c = 1;
        invoiceline.invoiceit_s__Discount_Value__c = 0;
        invoiceline.Split_Invoice__c = false;

        invoiceLine = new invoiceit_s__Invoice_Lines__c();
        invoiceLine.invoiceit_s__Job__c = job.Id;
        invoiceLine.invoiceit_s__Invoice__c = invoice.Id;
        invoiceline.invoiceit_s__Service_Start_Date__c = system.today().addMonths(1);
        invoiceline.invoiceit_s__Service_End_Date__c = system.today().addMonths(18);
        invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__c = charges[2].Id;
        invoiceLine.invoiceit_s__Unit_Price__c = 100;
        invoiceline.invoiceit_s__Quantity__c = 1;
        invoiceline.invoiceit_s__Discount_Value__c = 0;
        invoiceline.Split_Invoice__c = false;
        invLines.add(invoiceline);
        insert invoiceline;
    }*/

    @isTest static void test_IITBatchUpliftPrice() {
        IITClassAfterOnOrderRatePlanCharges.ExecuteTrigger = false;
        system.debug('Indide');

        //
        invoiceit_s__Revenue_Recognition_Rule__c rule = new invoiceit_s__Revenue_Recognition_Rule__c(Name = 'Full Recognition - On Invoice Date');
        insert rule;

        // insert the custom settings
        IITTestClassForPhase1.insertCustomSettings();

        Id kvaccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('KV Platform').getRecordTypeId();

        // don't change the billing country field as VAT will be calculated based on this
        Account acc = new Account(Name = 'Test Account', BillingCountry = 'United Kingdom', recordtypeID = kvaccountRecordTypeId);
        insert acc;

        invoiceit_s__Product__c invoiceItProduct = new invoiceit_s__Product__c(invoiceit_s__Valid_From_Date__c = system.today(), Name = 'Test');
        insert invoiceItProduct;

        invoiceit_s__Product_Rate_Plan__c ratePlan = new invoiceit_s__Product_Rate_Plan__c(Name = 'Full......', invoiceit_s__Valid_From_Date__c = system.today());
        ratePlan.invoiceit_s__Product__c = invoiceItProduct.Id;
        insert ratePlan;

        invoiceit_s__Currency__c currency1 = new invoiceit_s__Currency__c(Name = 'EUR', invoiceit_s__Symbol__c = '£');
        insert currency1;

        invoiceit_s__Product_Rate_Plan_Charge__c productCharge = new invoiceit_s__Product_Rate_Plan_Charge__c(invoiceit_s__Product_Rate_Plan__c = ratePlan.Id, Name = 'Annual Subscription Fee: Full', invoiceit_s__CurrencyL__c = currency1.Id);
        insert productCharge;

        // this will cover the IITClassAfterOnOrderRatePlanCharges
        invoiceit_s__Job__c job = new invoiceit_s__Job__c(invoiceit_s__Account__c = acc.id, invoiceit_s__Sub_Total__c = 100, invoiceit_s__Discount_Value__c = 0, invoiceit_s__CurrencyL__c = currency1.Id);
        job.invoiceit_s__Account__c = acc.Id;
        job.Shipping_Account__c = acc.Id;
        job.IITIntended_Use__c = 'LOCAL UK WATERS';
        job.Withholding_Tax_Percentage__c = 10;
        job.BMS_Contract_Year__c = 2;
        //job.Mid_Term_Order__c = true;
        insert job;

        invoiceit_s__Job_Product__c  jobProduct= new invoiceit_s__Job_Product__c(invoiceit_s__Product__c = invoiceItProduct.Id, Name = 'jobProduct',invoiceit_s__Job__c = job.Id);
        insert jobProduct;

        invoiceit_s__Job_Rate_Plan__c jobRP = new invoiceit_s__Job_Rate_Plan__c(invoiceit_s__Product_Rate_Plan__c = ratePlan.Id, Name = 'JobRP',invoiceit_s__Job_Product__c =jobProduct.Id);
        insert jobRP;

        list<invoiceit_s__Job_Rate_Plan_Charge__c> charges = new list<invoiceit_s__Job_Rate_Plan_Charge__c>();
        invoiceit_s__Job_Rate_Plan_Charge__c charge = new invoiceit_s__Job_Rate_Plan_Charge__c(invoiceit_s__Product_Rate_Plan_Charge__c = productCharge.Id);
        charge.Name = 'Charge1';
        charge.invoiceit_s__Order__c = job.Id;
        charge.invoiceit_s__Job_Rate_Plan__c =jobRP.Id;
        charge.invoiceit_s__Status__c = 'Ready to be Invoiced';
        charge.invoiceit_s__Quantity__c = 1;
        charge.invoiceit_s__Price_Type__c = 'Half Yearly';
        charge.invoiceit_s__Accounting_Code__c = '12345';
        charge.invoiceit_s__Charge_Date__c = system.today();
        charge.invoiceit_s__Unit_Price__c = 100;
        charge.invoiceit_s__Service_Activation_Date__c = System.today();
        charge.invoiceit_s__Service_End_Date__c = charge.invoiceit_s__Service_Activation_Date__c.addYears(4);
        charge.invoiceit_s__Uplift__c = 2;
        charge.invoiceit_s__VAT_Percentage__c = 0;    
        charge.invoiceit_s__Tax_Percentage__c = 0;  
        charge.invoiceit_s__Tax__c = 0;  
        charge.invoiceit_s__VAT_Percentage__c = 0; 
        charges.add(charge);

        charge = new invoiceit_s__Job_Rate_Plan_Charge__c(invoiceit_s__Product_Rate_Plan_Charge__c = productCharge.Id);
        charge.Name = 'Charge2';
        charge.invoiceit_s__Order__c = job.Id;
        charge.invoiceit_s__Job_Rate_Plan__c =jobRP.Id;
        charge.invoiceit_s__Status__c = 'Ready to be Invoiced';
        charge.invoiceit_s__Quantity__c = 1;
        charge.invoiceit_s__Price_Type__c = 'Half Yearly';
        charge.invoiceit_s__Accounting_Code__c = '12345';
        charge.invoiceit_s__Charge_Date__c = system.today();
        charge.invoiceit_s__Unit_Price__c = 100;
        charge.invoiceit_s__Service_Activation_Date__c = System.today();
        charge.invoiceit_s__Service_End_Date__c = charge.invoiceit_s__Service_Activation_Date__c.addYears(4);
        charge.invoiceit_s__Uplift__c = null;
        charge.Legacy_Orders__c = true;
        charge.AnnualRentYear2__c = 105;
        charge.Next_Uplift_Date__c = system.today();
        charge.invoiceit_s__VAT_Percentage__c = 0;    
        charge.invoiceit_s__Tax_Percentage__c = 0;  
        charge.invoiceit_s__Tax__c = 0;  
        charge.invoiceit_s__VAT_Percentage__c = 0; 
        charges.add(charge);

        charge = new invoiceit_s__Job_Rate_Plan_Charge__c(invoiceit_s__Product_Rate_Plan_Charge__c = productCharge.Id);
        charge.Name = 'Charge3';
        charge.invoiceit_s__Order__c = job.Id;
        charge.invoiceit_s__Job_Rate_Plan__c =jobRP.Id;
        charge.invoiceit_s__Status__c = 'Ready to be Invoiced';
        charge.invoiceit_s__Quantity__c = 1;
        charge.invoiceit_s__Price_Type__c = 'Half Yearly';
        charge.invoiceit_s__Accounting_Code__c = '12345';
        charge.invoiceit_s__Charge_Date__c = system.today();
        charge.invoiceit_s__Unit_Price__c = 100;
        charge.invoiceit_s__Service_Activation_Date__c = System.today();
        charge.invoiceit_s__Service_End_Date__c = charge.invoiceit_s__Service_Activation_Date__c.addYears(4);
        charge.invoiceit_s__Uplift__c = 0;
        charge.Legacy_Orders__c = true;
        charge.AnnualRentYear3__c = 105;
        charge.AnnualRentYear3__c = 110;
        charge.Next_Uplift_Date__c = system.today();
        charge.invoiceit_s__VAT_Percentage__c = 0;    
        charge.invoiceit_s__Tax_Percentage__c = 0;  
        charge.invoiceit_s__Tax__c = 0;  
        charge.invoiceit_s__VAT_Percentage__c = 0;  
        
        charges.add(charge);

        insert charges;
        system.assert(charge.Next_Uplift_Date__c != null);

        test.startTest();             

            Date dateToday = system.today();
            string query = 'SELECT AnnualRentYear2__c, AnnualRentYear3__c, AnnualRentYear4__c, Unit_Price_2nd_Year__c, Unit_Price_3rd_Year__c, Unit_Price_4th_Year__c, invoiceit_s__Quantity__c, invoiceit_s__Uplift__c, invoiceit_s__Uplift_Frequency__c, invoiceit_s__Price_Type__c,invoiceit_s__Order__c, Legacy_Orders__c, Next_Uplift_Date__c, invoiceit_s__Unit_Price__c, invoiceit_s__Order__r.BMS_Contract_Year__c FROM invoiceit_s__Job_Rate_Plan_Charge__c WHERE invoiceit_s__Product_Rate_Plan_Charge__c = \'' + productCharge.Id + '\' ';
            
            // This is to cover class IITBatchUpliftPrice
            IITBatchUpliftPrice a = new IITBatchUpliftPrice(query, false);
            database.executeBatch(a);
    
            charges = [SELECT Name, invoiceit_s__Unit_Price__c, invoiceit_s__Uplift_Frequency__c, Next_Uplift_Date__c FROM invoiceit_s__Job_Rate_Plan_Charge__c WHERE invoiceit_s__Product_Rate_Plan_Charge__c =: productCharge.Id];
    
            for(invoiceit_s__Job_Rate_Plan_Charge__c chargeLoop : charges) {
                system.debug('invoiceit_s__Unit_Price__c should be updated by the uplift price by ' + chargeLoop.invoiceit_s__Unit_Price__c);
                if(chargeLoop.Name == 'Charge1') {
                    //system.assert(chargeLoop.invoiceit_s__Unit_Price__c == 102);    
                } else if(chargeLoop.Name == 'Charge2') {
                    //system.assert(chargeLoop.invoiceit_s__Unit_Price__c == 105);    
                } else if(chargeLoop.Name == 'Charge3') {
                    //system.assert(chargeLoop.invoiceit_s__Unit_Price__c == 110);    
                }
            }
    
            charge = [SELECT Id, invoiceit_s__Uplift_Frequency__c, Next_Uplift_Date__c FROM invoiceit_s__Job_Rate_Plan_Charge__c WHERE Id =: charges[0].Id];
    
            system.debug('Next_Uplift_Date__c should be populated by the system');
            //system.assert(charge.Next_Uplift_Date__c != null);
    
            // code for Suspension_Period__c period.
            Suspension_Period__c sp = new Suspension_Period__c();
            sp.Suspension_Start_Date__c = system.today();
            sp.Suspension_End_Date__c = sp.Suspension_Start_Date__c.addMonths(1);
            sp.Order_Rate_Plan_Charge_Suspension__c = charges[0].Id;
            insert sp;
    
            charge = charges[0];
            charge.Next_Uplift_Date__c = system.today().addMonths(6);
            update charge;
        test.stopTest();

        // code for 
        invoiceit_s__Invoice__c invoice = new invoiceit_s__Invoice__c();
        invoice.invoiceit_s__Account__c = acc.Id;
        insert invoice;

        invoiceit_s__Invoice_Lines__c invoiceLine = new invoiceit_s__Invoice_Lines__c();
        invoiceLine.invoiceit_s__Job__c = job.Id;
        invoiceLine.invoiceit_s__Invoice__c = invoice.Id;
        invoiceline.invoiceit_s__Service_Start_Date__c = system.today()-1;
        invoiceline.invoiceit_s__Service_End_Date__c = system.today().addMonths(12);
        invoiceLine.invoiceit_s__Job_Rate_Plan_Charge__c = charges[1].Id;
        invoiceLine.invoiceit_s__Unit_Price__c = 100;
        invoiceline.invoiceit_s__Quantity__c = 1;
        invoiceline.invoiceit_s__Discount_Value__c = 1;
        invoiceline.Split_Invoice__c = false;
        insert invoiceline;

    }
}