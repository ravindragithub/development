@isTest
private class IITTestClassForTitles {

     @isTest static void test_method_one() {
        // insert the custom settings
        IITTestClassForPhase1.insertCustomSettings();

        Id kvaccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('KV Platform').getRecordTypeId();

        // don't change the billing country field as VAT will be calculated based on this
        Account acc = new Account(Name = 'Test Account', BillingCountry = 'United Kingdom', recordtypeID = kvaccountRecordTypeId);
        insert acc;

        invoiceit_s__Product__c invoiceItProduct = new invoiceit_s__Product__c(invoiceit_s__Valid_From_Date__c = system.today(), Name = 'VOD');
        insert invoiceItProduct;

        invoiceit_s__Product_Rate_Plan__c ratePlan = new invoiceit_s__Product_Rate_Plan__c(Name = 'Full VOD', invoiceit_s__Valid_From_Date__c = system.today());
        ratePlan.invoiceit_s__Product__c = invoiceItProduct.Id;
        insert ratePlan;

        invoiceit_s__Currency__c currency1 = new invoiceit_s__Currency__c(Name = 'EUR', invoiceit_s__Symbol__c = '£');
        insert currency1;

        invoiceit_s__Product_Rate_Plan_Charge__c productCharge = new invoiceit_s__Product_Rate_Plan_Charge__c(invoiceit_s__Product_Rate_Plan__c = ratePlan.Id, Name = 'Annual Subscription Fee: Full VOD', invoiceit_s__CurrencyL__c = currency1.Id);
        insert productCharge;

        // this will cover the IITClassAfterOnOrderRatePlanCharges
        invoiceit_s__Job__c job = new invoiceit_s__Job__c(invoiceit_s__Account__c = acc.id, invoiceit_s__Sub_Total__c = 100, invoiceit_s__Discount_Value__c = 0, invoiceit_s__CurrencyL__c = currency1.Id);
        job.invoiceit_s__Account__c = acc.Id;
        job.Shipping_Account__c = acc.Id;
        job.IITIntended_Use__c = 'LOCAL UK WATERS';
        job.Wet_or_Dry_Cargo__c = 'Dry Cargo';
        job.Legal_Entity__c = 'VMA';
        insert job;

        invoiceit_s__Job_Product__c  jobProduct= new invoiceit_s__Job_Product__c(invoiceit_s__Product__c = invoiceItProduct.Id, Name = 'jobProduct',invoiceit_s__Job__c = job.Id);
        insert jobProduct;

        invoiceit_s__Job_Rate_Plan__c jobRP = new invoiceit_s__Job_Rate_Plan__c(invoiceit_s__Product_Rate_Plan__c = ratePlan.Id, Name = 'JobRP',invoiceit_s__Job_Product__c =jobProduct.Id);
        insert jobRP;

        list<invoiceit_s__Revenue_Period__c> revenuePeriods = new list<invoiceit_s__Revenue_Period__c>();
        invoiceit_s__Revenue_Period__c revenueForecast;
        Date myDateTime; 

        for(integer i=1; i<=12; i++) {
            myDateTime = Date.newInstance(system.today().year(), i, 1);    
            revenueForecast = new  invoiceit_s__Revenue_Period__c(invoiceit_s__Revenue_Period_Start_Date__c =myDateTime, invoiceit_s__Revenue_Period_End_Date__c = myDateTime.addMonths(1), Name = ''+i );
            revenuePeriods.add(revenueForecast);
        }

        insert revenuePeriods;

        list< invoiceit_s__Revenue_Recognition_Rule__c> revenueForecasts = new list< invoiceit_s__Revenue_Recognition_Rule__c>();
        revenueForecasts.add( new  invoiceit_s__Revenue_Recognition_Rule__c(Name = 'Daily Recognition Rule - Based on Revenue Recognition Date', invoiceit_s__Recognition_Type__c = 'Daily Recognition Over Time', invoiceit_s__Recognition_Date__c = 'Revenue Recognition Date'));
        revenueForecasts.add( new  invoiceit_s__Revenue_Recognition_Rule__c(Name = 'Monthly Recognition Rule - Based on Revenue Recognition Date', invoiceit_s__Recognition_Type__c = 'Monthly Recognition Over Time', invoiceit_s__Recognition_Date__c = 'Revenue Recognition Date'));
        revenueForecasts.add( new  invoiceit_s__Revenue_Recognition_Rule__c(Name = 'Monthly Recognition Rule - Based on Service Activation Date', invoiceit_s__Recognition_Type__c = 'Monthly Recognition Over Time', invoiceit_s__Recognition_Date__c = 'Service Activation Date'));
        revenueForecasts.add( new  invoiceit_s__Revenue_Recognition_Rule__c(Name = 'Full Recognition - On Invoice Date', invoiceit_s__Recognition_Type__c = 'Full Recognition on Specific Date', invoiceit_s__Recognition_Date__c = 'Invoice Date'));
        revenueForecasts.add( new  invoiceit_s__Revenue_Recognition_Rule__c(Name = 'Full Recognition - On Revenue Recognition Date', invoiceit_s__Recognition_Type__c = 'Full Recognition on Specific Date', invoiceit_s__Recognition_Date__c = 'Revenue Recognition Date'));
        revenueForecasts.add( new  invoiceit_s__Revenue_Recognition_Rule__c(Name = 'Daily Recognition Rule - Based on Service Activation Date', invoiceit_s__Recognition_Type__c = 'Daily Recognition Over Time', invoiceit_s__Recognition_Date__c = 'Service Activation Date'));
        revenueForecasts.add( new  invoiceit_s__Revenue_Recognition_Rule__c(Name = 'Full Recognition - On Service Activation Date', invoiceit_s__Recognition_Type__c = 'Full Recognition on Specific Date', invoiceit_s__Recognition_Date__c = 'Service Activation Date'));
        revenueForecasts.add( new  invoiceit_s__Revenue_Recognition_Rule__c(Name = 'Full Recognition - On Service End Date', invoiceit_s__Recognition_Type__c = 'Full Recognition on Specific Date', invoiceit_s__Recognition_Date__c = 'Service End Date'));
        revenueForecasts.add( new  invoiceit_s__Revenue_Recognition_Rule__c(Name = 'Daily Recognition Rule - Based on Revenue Recognition Date', invoiceit_s__Recognition_Type__c = 'Daily Recognition Over Time', invoiceit_s__Recognition_Date__c = 'Service End Date'));
        revenueForecasts.add( new  invoiceit_s__Revenue_Recognition_Rule__c(Name = 'Daily Recognition Over Time', invoiceit_s__Recognition_Type__c = 'Daily Recognition Over Time', invoiceit_s__Recognition_Date__c = 'Service Activation Date'));
        
        insert revenueForecasts;

        list<invoiceit_s__Job_Rate_Plan_Charge__c> charges = new list<invoiceit_s__Job_Rate_Plan_Charge__c>(); 

        invoiceit_s__Job_Rate_Plan_Charge__c charge = new invoiceit_s__Job_Rate_Plan_Charge__c(invoiceit_s__Product_Rate_Plan_Charge__c = productCharge.Id);
        charge.Name = 'jobRPC';
        charge.invoiceit_s__Job_Rate_Plan__c =jobRP.Id;
        charge.invoiceit_s__Status__c = 'Ready to be Invoiced';
        charge.invoiceit_s__Quantity__c = 12;
        charge.invoiceit_s__Price_Type__c = 'One Time';
        charge.invoiceit_s__Accounting_Code__c = '12345';
        charge.invoiceit_s__Charge_Date__c = system.today();
        charge.invoiceit_s__Unit_Price__c = 12;

        charge.invoiceit_s__Revenue_Recognition_Rule__c = revenueForecasts[2].Id;
        charge.invoiceit_s__Service_Activation_Date__c = system.today();
        charge.invoiceit_s__Revenue_Recognition_Date__c  = system.today();
        charge.invoiceit_s__Service_End_Date__c = system.today() + 100;
        charges.add(charge);

        charge = new invoiceit_s__Job_Rate_Plan_Charge__c(invoiceit_s__Product_Rate_Plan_Charge__c = productCharge.Id);
        charge.Name = 'jobRPC';
        charge.invoiceit_s__Job_Rate_Plan__c =jobRP.Id;
        charge.invoiceit_s__Status__c = 'Ready to be Invoiced';
        charge.invoiceit_s__Quantity__c = 12;
        charge.invoiceit_s__Revenue_Recognition_Rule__c = revenueForecasts[0].Id;
        charge.invoiceit_s__Price_Type__c = 'Annual';
        charge.invoiceit_s__Accounting_Code__c = '12345';
        charge.invoiceit_s__Charge_Date__c = system.today();
        charge.invoiceit_s__Unit_Price__c = 12;
        charge.invoiceit_s__Service_Activation_Date__c = system.today();
        charge.invoiceit_s__Revenue_Recognition_Date__c  = system.today();
        charge.invoiceit_s__Service_End_Date__c = system.today() + 100;
        charges.add(charge);

        charge = new invoiceit_s__Job_Rate_Plan_Charge__c(invoiceit_s__Product_Rate_Plan_Charge__c = productCharge.Id);
        charge.Name = 'jobRPC';
        charge.invoiceit_s__Job_Rate_Plan__c =jobRP.Id;
        charge.invoiceit_s__Status__c = 'Ready to be Invoiced';
        charge.invoiceit_s__Quantity__c = 12;
        charge.invoiceit_s__Revenue_Recognition_Rule__c = revenueForecasts[6].Id;
        charge.invoiceit_s__Price_Type__c = 'Half Yearly';
        charge.invoiceit_s__Accounting_Code__c = '12345';
        charge.invoiceit_s__Charge_Date__c = system.today();
        charge.invoiceit_s__Unit_Price__c = 12;
        charge.invoiceit_s__Service_Activation_Date__c = system.today();
        charge.invoiceit_s__Revenue_Recognition_Date__c  = system.today();
        charge.invoiceit_s__Service_End_Date__c = system.today() + 100;
        charges.add(charge);

        charge = new invoiceit_s__Job_Rate_Plan_Charge__c(invoiceit_s__Product_Rate_Plan_Charge__c = productCharge.Id);
        charge.Name = 'jobRPC';
        charge.invoiceit_s__Job_Rate_Plan__c =jobRP.Id;
        charge.invoiceit_s__Status__c = 'Quarterly';
        charge.invoiceit_s__Quantity__c = 12;
        charge.invoiceit_s__Revenue_Recognition_Rule__c = revenueForecasts[3].Id;
        charge.invoiceit_s__Price_Type__c = 'One Time';
        charge.invoiceit_s__Accounting_Code__c = '12345';
        charge.invoiceit_s__Charge_Date__c = system.today();
        charge.invoiceit_s__Unit_Price__c = 12;
        charge.invoiceit_s__Service_Activation_Date__c = system.today();
        charge.invoiceit_s__Revenue_Recognition_Date__c  = system.today();
        charge.invoiceit_s__Service_End_Date__c = system.today() + 100;
        charges.add(charge);

        insert charges;
        
        // This is cover the ControllerAssignTitlesToCharge class
        Order_Charge_Titles__c ordercharge = new Order_Charge_Titles__c(Order_Rate_Plan_Charge__c = charges[0].Id);
        insert ordercharge;

        Titles__c Titles = new Titles__c(Name = 'titles', Length__c = '12', Platform_Type__c = 'Dry Cargo', Included_in_VOD__c = 'Full VOD', List_Price__c = 450);
        insert Titles;

        Format_Types__c formatTypes = new Format_Types__c(Format__c = 'VIDEO', Title__c = Titles.Id, Status__c = 'Current', Delivery_Method_s__c = 'VOD G2;VOD G1');
        insert formatTypes;

        ApexPages.StandardController controllerTitles = new ApexPages.StandardController(charges[0]);
        ControllerAssignTitlesToCharge controllerAssignTitlesToChargeObj = new ControllerAssignTitlesToCharge(controllerTitles);


        controllerAssignTitlesToChargeObj.next();
        controllerAssignTitlesToChargeObj.previous();
        controllerAssignTitlesToChargeObj.last();
        controllerAssignTitlesToChargeObj.first();
        controllerAssignTitlesToChargeObj.addTitles();

        controllerAssignTitlesToChargeObj.sSearchString = 'titl';
        controllerAssignTitlesToChargeObj.sSearchStringFormat = 'VIDEO';
        controllerAssignTitlesToChargeObj.searchTitles();
        controllerAssignTitlesToChargeObj.searchFormats();
        test.startTest(); 
        controllerAssignTitlesToChargeObj.saveTitles();
        apexpages.currentpage().getparameters().put('removeTitles','1');
        controllerAssignTitlesToChargeObj.removeTitles();
        
            // This is cover the createRevenueForecastForOrder class
            IITRevenueRecognitionUtilClass_New.createRevenueForecastForOrder(job.Id);
            IITRevenueRecognitionUtilClass_New.createRevenueForecastForOrderCharge(charge.Id);
        test.stopTest();

    }

    @isTest static void test_method_two() {
        // insert the custom settings
        IITTestClassForPhase1.insertCustomSettings();

        Id kvaccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('KV Platform').getRecordTypeId();

        // don't change the billing country field as VAT will be calculated based on this
        Account acc = new Account(Name = 'Test Account', BillingCountry = 'United Kingdom', recordtypeID = kvaccountRecordTypeId);
        insert acc;

        invoiceit_s__Product__c invoiceItProduct = new invoiceit_s__Product__c(invoiceit_s__Valid_From_Date__c = system.today(), Name = 'VOD');
        insert invoiceItProduct;

        invoiceit_s__Product_Rate_Plan__c ratePlan = new invoiceit_s__Product_Rate_Plan__c(Name = 'Full VOD', invoiceit_s__Valid_From_Date__c = system.today());
        ratePlan.invoiceit_s__Product__c = invoiceItProduct.Id;
        insert ratePlan;

        invoiceit_s__Currency__c currency1 = new invoiceit_s__Currency__c(Name = 'EUR', invoiceit_s__Symbol__c = '£');
        insert currency1;

        invoiceit_s__Product_Rate_Plan_Charge__c productCharge = new invoiceit_s__Product_Rate_Plan_Charge__c(invoiceit_s__Product_Rate_Plan__c = ratePlan.Id, Name = 'Annual Subscription Fee: Full VOD', invoiceit_s__CurrencyL__c = currency1.Id);
        insert productCharge;

        // this will cover the IITClassAfterOnOrderRatePlanCharges
        invoiceit_s__Job__c job = new invoiceit_s__Job__c(invoiceit_s__Account__c = acc.id, invoiceit_s__Sub_Total__c = 100, invoiceit_s__Discount_Value__c = 0, invoiceit_s__CurrencyL__c = currency1.Id);
        job.invoiceit_s__Account__c = acc.Id;
        job.Shipping_Account__c = acc.Id;
        job.IITIntended_Use__c = 'LOCAL UK WATERS';
        job.Wet_or_Dry_Cargo__c = 'Dry Cargo';
        job.Legal_Entity__c = 'VMA';
        insert job;

        invoiceit_s__Job_Product__c  jobProduct= new invoiceit_s__Job_Product__c(invoiceit_s__Product__c = invoiceItProduct.Id, Name = 'jobProduct',invoiceit_s__Job__c = job.Id);
        insert jobProduct;

        invoiceit_s__Job_Rate_Plan__c jobRP = new invoiceit_s__Job_Rate_Plan__c(invoiceit_s__Product_Rate_Plan__c = ratePlan.Id, Name = 'JobRP',invoiceit_s__Job_Product__c =jobProduct.Id);
        insert jobRP;

        list<invoiceit_s__Revenue_Period__c> revenuePeriods = new list<invoiceit_s__Revenue_Period__c>();
        invoiceit_s__Revenue_Period__c revenueForecast;
        Date myDateTime; 

        for(integer i=1; i<=12; i++) {
            myDateTime = Date.newInstance(system.today().year(), i, 1);    
            revenueForecast = new  invoiceit_s__Revenue_Period__c(invoiceit_s__Revenue_Period_Start_Date__c =myDateTime, invoiceit_s__Revenue_Period_End_Date__c = myDateTime.addMonths(1), Name = ''+i );
            revenuePeriods.add(revenueForecast);
        }

        insert revenuePeriods;

        list< invoiceit_s__Revenue_Recognition_Rule__c> revenueForecasts = new list< invoiceit_s__Revenue_Recognition_Rule__c>();
        //list< invoiceit_s__Revenue_Recognition_Rule__c> revenueForecasts = new list< invoiceit_s__Revenue_Recognition_Rule__c>();
        revenueForecasts.add( new  invoiceit_s__Revenue_Recognition_Rule__c(Name = 'Daily Recognition Rule - Based on Revenue Recognition Date', invoiceit_s__Recognition_Type__c = 'Daily Recognition Over Time', invoiceit_s__Recognition_Date__c = 'Revenue Recognition Date'));
        revenueForecasts.add( new  invoiceit_s__Revenue_Recognition_Rule__c(Name = 'Monthly Recognition Rule - Based on Revenue Recognition Date', invoiceit_s__Recognition_Type__c = 'Monthly Recognition Over Time', invoiceit_s__Recognition_Date__c = 'Revenue Recognition Date'));
        revenueForecasts.add( new  invoiceit_s__Revenue_Recognition_Rule__c(Name = 'Monthly Recognition Rule - Based on Service Activation Date', invoiceit_s__Recognition_Type__c = 'Monthly Recognition Over Time', invoiceit_s__Recognition_Date__c = 'Service Activation Date'));
        revenueForecasts.add( new  invoiceit_s__Revenue_Recognition_Rule__c(Name = 'Full Recognition - On Invoice Date', invoiceit_s__Recognition_Type__c = 'Full Recognition on Specific Date', invoiceit_s__Recognition_Date__c = 'Invoice Date'));
        revenueForecasts.add( new  invoiceit_s__Revenue_Recognition_Rule__c(Name = 'Full Recognition - On Revenue Recognition Date', invoiceit_s__Recognition_Type__c = 'Full Recognition on Specific Date', invoiceit_s__Recognition_Date__c = 'Revenue Recognition Date'));
        revenueForecasts.add( new  invoiceit_s__Revenue_Recognition_Rule__c(Name = 'Daily Recognition Rule - Based on Service Activation Date', invoiceit_s__Recognition_Type__c = 'Daily Recognition Over Time', invoiceit_s__Recognition_Date__c = 'Service Activation Date'));
        revenueForecasts.add( new  invoiceit_s__Revenue_Recognition_Rule__c(Name = 'Full Recognition - On Service Activation Date', invoiceit_s__Recognition_Type__c = 'Full Recognition on Specific Date', invoiceit_s__Recognition_Date__c = 'Service Activation Date'));
        revenueForecasts.add( new  invoiceit_s__Revenue_Recognition_Rule__c(Name = 'Full Recognition - On Service End Date', invoiceit_s__Recognition_Type__c = 'Full Recognition on Specific Date', invoiceit_s__Recognition_Date__c = 'Service End Date'));
        revenueForecasts.add( new  invoiceit_s__Revenue_Recognition_Rule__c(Name = 'Daily Recognition Rule - Based on Revenue Recognition Date', invoiceit_s__Recognition_Type__c = 'Daily Recognition Over Time', invoiceit_s__Recognition_Date__c = 'Service End Date'));
        revenueForecasts.add( new  invoiceit_s__Revenue_Recognition_Rule__c(Name = 'Daily Recognition Over Time', invoiceit_s__Recognition_Type__c = 'Daily Recognition Over Time', invoiceit_s__Recognition_Date__c = 'Service Activation Date'));
        
        insert revenueForecasts;

        list<invoiceit_s__Job_Rate_Plan_Charge__c> charges = new list<invoiceit_s__Job_Rate_Plan_Charge__c>(); 

        invoiceit_s__Job_Rate_Plan_Charge__c charge = new invoiceit_s__Job_Rate_Plan_Charge__c(invoiceit_s__Product_Rate_Plan_Charge__c = productCharge.Id);
        charge.Name = 'jobRPC';
        charge.invoiceit_s__Job_Rate_Plan__c =jobRP.Id;
        charge.invoiceit_s__Status__c = 'Ready to be Invoiced';
        charge.invoiceit_s__Quantity__c = 12;
        charge.invoiceit_s__Price_Type__c = 'One Time';
        charge.invoiceit_s__Accounting_Code__c = '12345';
        charge.invoiceit_s__Charge_Date__c = system.today();
        charge.invoiceit_s__Unit_Price__c = 12;

        charge.invoiceit_s__Revenue_Recognition_Rule__c = revenueForecasts[2].Id;
        charge.invoiceit_s__Service_Activation_Date__c = system.today();
        charge.invoiceit_s__Revenue_Recognition_Date__c  = system.today();
        charge.invoiceit_s__Service_End_Date__c = system.today() + 100;
        charges.add(charge);

        charge = new invoiceit_s__Job_Rate_Plan_Charge__c(invoiceit_s__Product_Rate_Plan_Charge__c = productCharge.Id);
        charge.Name = 'jobRPC';
        charge.invoiceit_s__Job_Rate_Plan__c =jobRP.Id;
        charge.invoiceit_s__Status__c = 'Ready to be Invoiced';
        charge.invoiceit_s__Quantity__c = 12;
        charge.invoiceit_s__Revenue_Recognition_Rule__c = revenueForecasts[0].Id;
        charge.invoiceit_s__Price_Type__c = 'Annual';
        charge.invoiceit_s__Accounting_Code__c = '12345';
        charge.invoiceit_s__Charge_Date__c = system.today();
        charge.invoiceit_s__Unit_Price__c = 12;
        charge.invoiceit_s__Service_Activation_Date__c = system.today();
        charge.invoiceit_s__Revenue_Recognition_Date__c  = system.today();
        charge.invoiceit_s__Service_End_Date__c = system.today() + 100;
        charges.add(charge);

        charge = new invoiceit_s__Job_Rate_Plan_Charge__c(invoiceit_s__Product_Rate_Plan_Charge__c = productCharge.Id);
        charge.Name = 'jobRPC';
        charge.invoiceit_s__Job_Rate_Plan__c =jobRP.Id;
        charge.invoiceit_s__Status__c = 'Ready to be Invoiced';
        charge.invoiceit_s__Quantity__c = 12;
        charge.invoiceit_s__Revenue_Recognition_Rule__c = revenueForecasts[6].Id;
        charge.invoiceit_s__Price_Type__c = 'Half Yearly';
        charge.invoiceit_s__Accounting_Code__c = '12345';
        charge.invoiceit_s__Charge_Date__c = system.today();
        charge.invoiceit_s__Unit_Price__c = 12;
        charge.invoiceit_s__Service_Activation_Date__c = system.today();
        charge.invoiceit_s__Revenue_Recognition_Date__c  = system.today();
        charge.invoiceit_s__Service_End_Date__c = system.today() + 100;
        charges.add(charge);

        charge = new invoiceit_s__Job_Rate_Plan_Charge__c(invoiceit_s__Product_Rate_Plan_Charge__c = productCharge.Id);
        charge.Name = 'jobRPC';
        charge.invoiceit_s__Job_Rate_Plan__c =jobRP.Id;
        charge.invoiceit_s__Status__c = 'Quarterly';
        charge.invoiceit_s__Quantity__c = 12;
        charge.invoiceit_s__Revenue_Recognition_Rule__c = revenueForecasts[3].Id;
        charge.invoiceit_s__Price_Type__c = 'Quarterly';
        charge.invoiceit_s__Accounting_Code__c = '12345';
        charge.invoiceit_s__Charge_Date__c = system.today();
        charge.invoiceit_s__Unit_Price__c = 12;
        charge.invoiceit_s__Service_Activation_Date__c = system.today();
        charge.invoiceit_s__Revenue_Recognition_Date__c  = system.today();
        charge.invoiceit_s__Service_End_Date__c = system.today() + 100;
        charges.add(charge);

        insert charges;

        invoiceit_s__Invoice__c invoice=new invoiceit_s__Invoice__c (invoiceit_s__Account__c=acc.id, invoiceit_s__Invoice_Date__c=system.today(),invoiceit_s__Order__c=job.id,invoiceit_s__Invoice_Status__c ='Posted');
        insert invoice;

        list<invoiceit_s__Invoice_Lines__c> listofInvoiceLines = new list<invoiceit_s__Invoice_Lines__c>();
        invoiceit_s__Invoice_Lines__c invoiceline1= new invoiceit_s__Invoice_Lines__c(invoiceit_s__Quantity__c = 1, invoiceit_s__Unit_Price__c = 10, RevenueRecognitionRuleNew__c = revenueForecasts[2].Id, invoiceit_s__Sequence_No__c =1, Revenue_Recognition_Date__c = system.today(),RevenueRecognitionEndDatenew__c=system.today()+1,invoiceit_s__Line_Amount__c = 100, invoiceit_s__Calculated_Quantity__c =1, invoiceit_s__Service_End_Date__c = system.today()+30, invoiceit_s__Service_Start_Date__c = system.today(),invoiceit_s__Status__c = 'Cancelled', invoiceit_s__Invoice__c=invoice.id,invoiceit_s__Job__c=job.id,invoiceit_s__Job_Rate_Plan_Charge__c=charges[0].id,invoiceit_s__Line_Name__c='Line 1');
        invoiceit_s__Invoice_Lines__c invoiceline2= new invoiceit_s__Invoice_Lines__c(invoiceit_s__Quantity__c = 1, invoiceit_s__Unit_Price__c = 10, RevenueRecognitionRuleNew__c = revenueForecasts[7].Id, invoiceit_s__Sequence_No__c=1, Revenue_Recognition_Date__c = system.today(),RevenueRecognitionEndDatenew__c=system.today()+1,invoiceit_s__Line_Amount__c = 100,invoiceit_s__Calculated_Quantity__c =1,invoiceit_s__Service_End_Date__c = system.today()+30,invoiceit_s__Service_Start_Date__c = system.today(),invoiceit_s__Invoice__c=invoice.id,invoiceit_s__Job__c=job.id,invoiceit_s__Job_Rate_Plan_Charge__c=charges[1].id,invoiceit_s__Line_Name__c='Line 1');
        invoiceit_s__Invoice_Lines__c invoiceline3= new invoiceit_s__Invoice_Lines__c(invoiceit_s__Quantity__c = 1, invoiceit_s__Unit_Price__c = 10, RevenueRecognitionRuleNew__c = revenueForecasts[3].Id, Revenue_Recognition_Date__c = system.today(),invoiceit_s__Line_Amount__c = 100,RevenueRecognitionEndDatenew__c=system.today()+1,invoiceit_s__Calculated_Quantity__c =1,invoiceit_s__Service_End_Date__c = system.today().addMonths(1),invoiceit_s__Service_Start_Date__c = system.today(),invoiceit_s__Status__c = 'Cancelled', invoiceit_s__Invoice__c=invoice.id,invoiceit_s__Job__c=job.id,invoiceit_s__Job_Rate_Plan_Charge__c=charges[2].id,invoiceit_s__Line_Name__c='Line 1');
        invoiceit_s__Invoice_Lines__c invoiceline4= new invoiceit_s__Invoice_Lines__c(invoiceit_s__Quantity__c = 1, invoiceit_s__Unit_Price__c = 10, RevenueRecognitionRuleNew__c = revenueForecasts[1].Id, Revenue_Recognition_Date__c = system.today(),invoiceit_s__Line_Amount__c = 1000,RevenueRecognitionEndDatenew__c=system.today()+1,invoiceit_s__Calculated_Quantity__c =1,invoiceit_s__Service_End_Date__c = system.today().addMonths(1),invoiceit_s__Service_Start_Date__c = system.today(),invoiceit_s__Invoice__c=invoice.id,invoiceit_s__Job__c=job.id,invoiceit_s__Job_Rate_Plan_Charge__c=charges[3].id,invoiceit_s__Line_Name__c='Line 1');
        invoiceit_s__Invoice_Lines__c invoiceline5= new invoiceit_s__Invoice_Lines__c(invoiceit_s__Quantity__c = 1, invoiceit_s__Unit_Price__c = 10, RevenueRecognitionRuleNew__c = revenueForecasts[4].Id, Revenue_Recognition_Date__c = system.today(),invoiceit_s__Line_Amount__c = 2000,RevenueRecognitionEndDatenew__c=system.today()+1,invoiceit_s__Calculated_Quantity__c =1,invoiceit_s__Service_End_Date__c = system.today().addMonths(1),invoiceit_s__Service_Start_Date__c = system.today(),invoiceit_s__Invoice__c=invoice.id,invoiceit_s__Job__c=job.id,invoiceit_s__Job_Rate_Plan_Charge__c=charges[3].id,invoiceit_s__Line_Name__c='Line 1');
        invoiceit_s__Invoice_Lines__c invoiceline6= new invoiceit_s__Invoice_Lines__c(invoiceit_s__Quantity__c = 1, invoiceit_s__Unit_Price__c = 10, RevenueRecognitionRuleNew__c = revenueForecasts[5].Id, Revenue_Recognition_Date__c = system.today(),invoiceit_s__Line_Amount__c = 10000,RevenueRecognitionEndDatenew__c=system.today()+1,invoiceit_s__Calculated_Quantity__c =1,invoiceit_s__Service_End_Date__c = system.today().addMonths(1),invoiceit_s__Service_Start_Date__c = system.today(),invoiceit_s__Invoice__c=invoice.id,invoiceit_s__Job__c=job.id,invoiceit_s__Job_Rate_Plan_Charge__c=charges[3].id,invoiceit_s__Line_Name__c='Line 1');
        invoiceit_s__Invoice_Lines__c invoiceline7= new invoiceit_s__Invoice_Lines__c(invoiceit_s__Quantity__c = 1, invoiceit_s__Unit_Price__c = 10, RevenueRecognitionRuleNew__c = revenueForecasts[6].Id, Revenue_Recognition_Date__c = system.today(),invoiceit_s__Line_Amount__c = 1,RevenueRecognitionEndDatenew__c=system.today()+1,invoiceit_s__Calculated_Quantity__c =1,invoiceit_s__Service_End_Date__c = system.today().addMonths(1),invoiceit_s__Service_Start_Date__c = system.today(),invoiceit_s__Invoice__c=invoice.id,invoiceit_s__Job__c=job.id,invoiceit_s__Job_Rate_Plan_Charge__c=charges[3].id,invoiceit_s__Line_Name__c='Line 1');
        invoiceit_s__Invoice_Lines__c invoiceline8= new invoiceit_s__Invoice_Lines__c(invoiceit_s__Quantity__c = 1, invoiceit_s__Unit_Price__c = 10, RevenueRecognitionRuleNew__c = revenueForecasts[7].Id, Revenue_Recognition_Date__c = system.today(),invoiceit_s__Line_Amount__c = 50000,RevenueRecognitionEndDatenew__c=system.today()+1,invoiceit_s__Calculated_Quantity__c =1,invoiceit_s__Service_End_Date__c = system.today().addMonths(1),invoiceit_s__Service_Start_Date__c = system.today(),invoiceit_s__Invoice__c=invoice.id,invoiceit_s__Job__c=job.id,invoiceit_s__Job_Rate_Plan_Charge__c=charges[3].id,invoiceit_s__Line_Name__c='Line 1');
        invoiceit_s__Invoice_Lines__c invoiceline9= new invoiceit_s__Invoice_Lines__c(invoiceit_s__Quantity__c = 1, invoiceit_s__Unit_Price__c = 10, RevenueRecognitionRuleNew__c = revenueForecasts[8].Id, Revenue_Recognition_Date__c = system.today(),invoiceit_s__Line_Amount__c = 25,RevenueRecognitionEndDatenew__c=system.today()+1,invoiceit_s__Calculated_Quantity__c =1,invoiceit_s__Service_End_Date__c = system.today().addMonths(1),invoiceit_s__Service_Start_Date__c = system.today(),invoiceit_s__Invoice__c=invoice.id,invoiceit_s__Job__c=job.id,invoiceit_s__Job_Rate_Plan_Charge__c=charges[3].id,invoiceit_s__Line_Name__c='Line 1');
        invoiceit_s__Invoice_Lines__c invoiceline10= new invoiceit_s__Invoice_Lines__c(invoiceit_s__Quantity__c = 1, invoiceit_s__Unit_Price__c = 10, RevenueRecognitionRuleNew__c = revenueForecasts[9].Id, Revenue_Recognition_Date__c = system.today(),invoiceit_s__Line_Amount__c = 50000,RevenueRecognitionEndDatenew__c=system.today()+1,invoiceit_s__Calculated_Quantity__c =1,invoiceit_s__Service_End_Date__c = system.today().addMonths(1),invoiceit_s__Service_Start_Date__c = system.today(),invoiceit_s__Invoice__c=invoice.id,invoiceit_s__Job__c=job.id,invoiceit_s__Job_Rate_Plan_Charge__c=charges[3].id,invoiceit_s__Line_Name__c='Line 1');
        invoiceit_s__Invoice_Lines__c invoiceline11= new invoiceit_s__Invoice_Lines__c(invoiceit_s__Quantity__c = 1, invoiceit_s__Unit_Price__c = 10, RevenueRecognitionRuleNew__c = revenueForecasts[9].Id, Revenue_Recognition_Date__c = system.today(),invoiceit_s__Line_Amount__c = -25,RevenueRecognitionEndDatenew__c=system.today()+1,invoiceit_s__Calculated_Quantity__c =1,invoiceit_s__Service_End_Date__c = system.today().addMonths(1),invoiceit_s__Service_Start_Date__c = system.today(),invoiceit_s__Invoice__c=invoice.id,invoiceit_s__Job__c=job.id,invoiceit_s__Job_Rate_Plan_Charge__c=charges[3].id,invoiceit_s__Line_Name__c='Line 1');
        invoiceit_s__Invoice_Lines__c invoiceline12= new invoiceit_s__Invoice_Lines__c(invoiceit_s__Quantity__c = 1, invoiceit_s__Unit_Price__c = 10, RevenueRecognitionRuleNew__c = revenueForecasts[9].Id, Revenue_Recognition_Date__c = system.today(),invoiceit_s__Line_Amount__c = -25,RevenueRecognitionEndDatenew__c=system.today()+1,invoiceit_s__Calculated_Quantity__c =1,invoiceit_s__Service_End_Date__c = system.today().addMonths(1),invoiceit_s__Service_Start_Date__c = system.today(),invoiceit_s__Invoice__c=invoice.id,invoiceit_s__Job__c=job.id,invoiceit_s__Job_Rate_Plan_Charge__c=charges[0].id,invoiceit_s__Line_Name__c='Line 1');
        invoiceit_s__Invoice_Lines__c invoiceline13= new invoiceit_s__Invoice_Lines__c(invoiceit_s__Quantity__c = 1, invoiceit_s__Unit_Price__c = 10, RevenueRecognitionRuleNew__c = revenueForecasts[9].Id, Revenue_Recognition_Date__c = system.today(),invoiceit_s__Line_Amount__c = 20,RevenueRecognitionEndDatenew__c=system.today()+1,invoiceit_s__Calculated_Quantity__c =1,invoiceit_s__Service_Start_Date__c = system.today().addMonths(1),invoiceit_s__Invoice__c=invoice.id,invoiceit_s__Job__c=job.id,invoiceit_s__Job_Rate_Plan_Charge__c=charges[2].id,invoiceit_s__Line_Name__c='Line 1');
        invoiceit_s__Invoice_Lines__c invoiceline14= new invoiceit_s__Invoice_Lines__c(invoiceit_s__Quantity__c = 1, invoiceit_s__Unit_Price__c = 10, RevenueRecognitionRuleNew__c = revenueForecasts[7].Id, invoiceit_s__Sequence_No__c=1, Revenue_Recognition_Date__c = system.today(),RevenueRecognitionEndDatenew__c=system.today()+1,invoiceit_s__Line_Amount__c = -100,invoiceit_s__Calculated_Quantity__c =1,invoiceit_s__Service_End_Date__c = system.today()+30,invoiceit_s__Service_Start_Date__c = system.today(),invoiceit_s__Invoice__c=invoice.id,invoiceit_s__Job__c=job.id,invoiceit_s__Job_Rate_Plan_Charge__c=charges[1].id,invoiceit_s__Line_Name__c='Line 1');
        
        listofInvoiceLines.add(invoiceline1);
        listofInvoiceLines.add(invoiceline2);
        listofInvoiceLines.add(invoiceline3);
        listofInvoiceLines.add(invoiceline4);
        listofInvoiceLines.add(invoiceline5);
        listofInvoiceLines.add(invoiceline6);
        listofInvoiceLines.add(invoiceline7);
        listofInvoiceLines.add(invoiceline8);
        listofInvoiceLines.add(invoiceline9);
        listofInvoiceLines.add(invoiceline10);
        listofInvoiceLines.add(invoiceline11);
        listofInvoiceLines.add(invoiceline12);
        listofInvoiceLines.add(invoiceline13);
        listofInvoiceLines.add(invoiceline14);
        insert listofInvoiceLines;
        
        invoiceit_s__Revenue_Transaction__c revenueTransaction = new invoiceit_s__Revenue_Transaction__c();
        revenueTransaction.invoiceit_s__Account__c = acc.Id;
        revenueTransaction.invoiceit_s__Invoice__c = invoice.Id;
        revenueTransaction.invoiceit_s__Invoice_Line__c = invoiceline4.Id;
        revenueTransaction.invoiceit_s__Revenue_Period__c = revenuePeriods[1].Id;
        revenueTransaction.invoiceit_s__Revenue_Amount__c = 200;
        revenueTransaction.invoiceit_s__Recognised_Revenue__c = 200;
        revenueTransaction.invoiceit_s__Deferred_Balance__c = 0;
        
        insert revenueTransaction ;

        test.startTest();
            // This is to cover IITRevenueRecognitionUtilClass_New
            
            IITRevenueRecognitionUtilClass_New.processRevenueTransactions(invoice.Id, null);
            IITRevenueRecognitionUtilClass_New.processRevenueTransactions(null, invoiceline2.Id);
    
            BatchProcessForRevenueTransactions batch = new BatchProcessForRevenueTransactions('SELECT ID FROM invoiceit_s__Invoice_Lines__c');
            database.executeBatch(batch);
    
           invoiceline4.RevenueRecognitionRuleNew__c = revenueForecasts[1].Id;
            update invoiceline4;
    
            invoiceit_s__Revenue_Recognition_Rule__c RevenueRecognitionRule = new  invoiceit_s__Revenue_Recognition_Rule__c(Name = 'Full Recognition - On Service End Date', invoiceit_s__Recognition_Type__c = 'Weighted Monthly Recognition Over Time', invoiceit_s__Recognition_Date__c = 'Service End Date');
            insert RevenueRecognitionRule;
    
            IITRevenueTransactions.processRevenueTransactions(invoice.Id, null);
            IITRevenueTransactions.processRevenueTransactions(null, null);
            IITRevenueTransactions.processRevenueTransactions(null, invoiceline1.Id);
            IITRevenueTransactions.processRevenueTransactions(null, invoiceline2.Id);
            IITRevenueTransactions.processRevenueTransactions(null, invoiceline3.Id);
            IITRevenueTransactions.processRevenueTransactions(null, invoiceline4.Id);
            IITRevenueTransactions.processRevenueTransactions(null, invoiceline5.Id);
            IITRevenueTransactions.processRevenueTransactions(null, invoiceline6.Id);
            IITRevenueTransactions.processRevenueTransactions(null, invoiceline7.Id);
            IITRevenueTransactions.processRevenueTransactions(null, invoiceline8.Id);
            IITRevenueTransactions.processRevenueTransactions(null, invoiceline9.Id);
    
            invoiceline4.RevenueRecognitionRuleNew__c = RevenueRecognitionRule.Id;
            update invoiceline4;
    
            IITRevenueTransactions.processRevenueTransactions(null, invoiceline4.Id);
    
            invoiceline4.invoiceit_s__Service_End_Date__c = null;
            update invoiceline4;
    
            IITRevenueTransactions.processRevenueTransactions(null, invoiceline4.Id);
            
            IITRevenueTransactions.processRevenueTransactions(invoice.Id, invoiceline4.Id);
            IITRevenueTransactions.processRevenueTransactions(invoice.Id, invoiceline2.Id);
            
            invoiceline2.RevenueRecognitionRuleNew__c = RevenueRecognitionRule.Id;
            update invoiceline2;
            IITRevenueTransactions.processRevenueTransactions(invoice.Id, invoiceline2.Id);
            
            IITRevenueTransactions.offSetNegativeValues(revenueTransaction);
        test.stopTest();

    }
  
     @isTest static void test_method_two_2() {
        // insert the custom settings
        IITTestClassForPhase1.insertCustomSettings();

        Id kvaccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('KV Platform').getRecordTypeId();

        // don't change the billing country field as VAT will be calculated based on this
        Account acc = new Account(Name = 'Test Account', BillingCountry = 'United Kingdom', recordtypeID = kvaccountRecordTypeId);
        insert acc;

        invoiceit_s__Product__c invoiceItProduct = new invoiceit_s__Product__c(invoiceit_s__Valid_From_Date__c = system.today(), Name = 'VOD');
        insert invoiceItProduct;

        invoiceit_s__Product_Rate_Plan__c ratePlan = new invoiceit_s__Product_Rate_Plan__c(Name = 'Full VOD', invoiceit_s__Valid_From_Date__c = system.today());
        ratePlan.invoiceit_s__Product__c = invoiceItProduct.Id;
        insert ratePlan;

        invoiceit_s__Currency__c currency1 = new invoiceit_s__Currency__c(Name = 'EUR', invoiceit_s__Symbol__c = '£');
        insert currency1;

        invoiceit_s__Product_Rate_Plan_Charge__c productCharge = new invoiceit_s__Product_Rate_Plan_Charge__c(invoiceit_s__Product_Rate_Plan__c = ratePlan.Id, Name = 'Annual Subscription Fee: Full VOD', invoiceit_s__CurrencyL__c = currency1.Id);
        insert productCharge;

        // this will cover the IITClassAfterOnOrderRatePlanCharges
        invoiceit_s__Job__c job = new invoiceit_s__Job__c(invoiceit_s__Account__c = acc.id, invoiceit_s__Sub_Total__c = 100, invoiceit_s__Discount_Value__c = 0, invoiceit_s__CurrencyL__c = currency1.Id);
        job.invoiceit_s__Account__c = acc.Id;
        job.Shipping_Account__c = acc.Id;
        job.IITIntended_Use__c = 'LOCAL UK WATERS';
        job.Wet_or_Dry_Cargo__c = 'Dry Cargo';
        job.Legal_Entity__c = 'VMA';
        insert job;

        invoiceit_s__Job_Product__c  jobProduct= new invoiceit_s__Job_Product__c(invoiceit_s__Product__c = invoiceItProduct.Id, Name = 'jobProduct',invoiceit_s__Job__c = job.Id);
        insert jobProduct;

        invoiceit_s__Job_Rate_Plan__c jobRP = new invoiceit_s__Job_Rate_Plan__c(invoiceit_s__Product_Rate_Plan__c = ratePlan.Id, Name = 'JobRP',invoiceit_s__Job_Product__c =jobProduct.Id);
        insert jobRP;
        
        
        // new revenue period
        
        list<invoiceit_s__Revenue_Period__c> listRevenuePeriod = new list<invoiceit_s__Revenue_Period__c>();
        date d1 = date.newInstance(2014, 12, 1) ;
        date d2 = date.newInstance(2014, 12, 31) ;
        
        date d3 = date.newInstance(2015, 1, 1) ;
        date d4 = date.newInstance(2015, 1, 31) ;
        
        date d5 = date.newInstance(2015, 2, 1) ;
        date d6= date.newInstance(2015, 2, 31) ;
        invoiceit_s__Revenue_Period__c  revenuePeriod1 = new invoiceit_s__Revenue_Period__c( Name= 'Dec-2014', invoiceit_s__Revenue_Period_Start_Date__c = d1,
                                                 invoiceit_s__Revenue_Period_End_Date__c = d2
                                                 );
         invoiceit_s__Revenue_Period__c  revenuePeriod2 = new invoiceit_s__Revenue_Period__c( Name= 'Jan-2015', invoiceit_s__Revenue_Period_Start_Date__c = d3,
         invoiceit_s__Revenue_Period_End_Date__c = d4
         );
         invoiceit_s__Revenue_Period__c  revenuePeriod3 = new invoiceit_s__Revenue_Period__c( Name= 'Feb-2015', invoiceit_s__Revenue_Period_Start_Date__c = d5,
         invoiceit_s__Revenue_Period_End_Date__c = d6
         );
         
         listRevenuePeriod.add(revenuePeriod1);
         listRevenuePeriod.add(revenuePeriod2);
         listRevenuePeriod.add(revenuePeriod3);
         
         insert listRevenuePeriod;
         

        list<invoiceit_s__Revenue_Period__c> revenuePeriods = new list<invoiceit_s__Revenue_Period__c>();
        invoiceit_s__Revenue_Period__c revenueForecast;
        Date myDateTime; 

        for(integer i=1; i<=12; i++) {
            myDateTime = Date.newInstance(system.today().year(), i, 1);    
            revenueForecast = new  invoiceit_s__Revenue_Period__c(invoiceit_s__Revenue_Period_Start_Date__c =myDateTime, invoiceit_s__Revenue_Period_End_Date__c = myDateTime.addMonths(1), Name = ''+i );
            revenuePeriods.add(revenueForecast);
        }

        insert revenuePeriods;

        list< invoiceit_s__Revenue_Recognition_Rule__c> revenueForecasts = new list< invoiceit_s__Revenue_Recognition_Rule__c>();
        revenueForecasts.add( new  invoiceit_s__Revenue_Recognition_Rule__c(Name = 'Daily Recognition Rule - Based on Revenue Recognition Date', invoiceit_s__Recognition_Type__c = 'Daily Recognition Over Time', invoiceit_s__Recognition_Date__c = 'Revenue Recognition Date'));
        revenueForecasts.add( new  invoiceit_s__Revenue_Recognition_Rule__c(Name = 'Monthly Recognition Rule - Based on Revenue Recognition Date', invoiceit_s__Recognition_Type__c = 'Monthly Recognition Over Time', invoiceit_s__Recognition_Date__c = 'Revenue Recognition Date'));
        revenueForecasts.add( new  invoiceit_s__Revenue_Recognition_Rule__c(Name = 'Monthly Recognition Rule - Based on Service Activation Date', invoiceit_s__Recognition_Type__c = 'Monthly Recognition Over Time', invoiceit_s__Recognition_Date__c = 'Service Activation Date'));
        revenueForecasts.add( new  invoiceit_s__Revenue_Recognition_Rule__c(Name = 'Full Recognition - On Invoice Date', invoiceit_s__Recognition_Type__c = 'Full Recognition on Specific Date', invoiceit_s__Recognition_Date__c = 'Invoice Date'));
        revenueForecasts.add( new  invoiceit_s__Revenue_Recognition_Rule__c(Name = 'Full Recognition - On Revenue Recognition Date', invoiceit_s__Recognition_Type__c = 'Full Recognition on Specific Date', invoiceit_s__Recognition_Date__c = 'Revenue Recognition Date'));
        revenueForecasts.add( new  invoiceit_s__Revenue_Recognition_Rule__c(Name = 'Daily Recognition Rule - Based on Service Activation Date', invoiceit_s__Recognition_Type__c = 'Daily Recognition Over Time', invoiceit_s__Recognition_Date__c = 'Service Activation Date'));
        revenueForecasts.add( new  invoiceit_s__Revenue_Recognition_Rule__c(Name = 'Full Recognition - On Service Activation Date', invoiceit_s__Recognition_Type__c = 'Full Recognition on Specific Date', invoiceit_s__Recognition_Date__c = 'Service Activation Date'));
        revenueForecasts.add( new  invoiceit_s__Revenue_Recognition_Rule__c(Name = 'Full Recognition - On Service End Date', invoiceit_s__Recognition_Type__c = 'Full Recognition on Specific Date', invoiceit_s__Recognition_Date__c = 'Service End Date'));

        insert revenueForecasts;

        list<invoiceit_s__Job_Rate_Plan_Charge__c> charges = new list<invoiceit_s__Job_Rate_Plan_Charge__c>(); 

        invoiceit_s__Job_Rate_Plan_Charge__c charge = new invoiceit_s__Job_Rate_Plan_Charge__c(invoiceit_s__Product_Rate_Plan_Charge__c = productCharge.Id);
        charge.Name = 'jobRPC';
        charge.invoiceit_s__Job_Rate_Plan__c =jobRP.Id;
        charge.invoiceit_s__Status__c = 'Ready to be Invoiced';
        charge.invoiceit_s__Quantity__c = 12;
        charge.invoiceit_s__Price_Type__c = 'One Time';
        charge.invoiceit_s__Accounting_Code__c = '12345';
        charge.invoiceit_s__Charge_Date__c = system.today();
        charge.invoiceit_s__Unit_Price__c = 12;

        charge.invoiceit_s__Revenue_Recognition_Rule__c = revenueForecasts[2].Id;
        charge.invoiceit_s__Service_Activation_Date__c = system.today();
        charge.invoiceit_s__Revenue_Recognition_Date__c  = system.today();
        charge.invoiceit_s__Service_End_Date__c = system.today() + 100;
        charges.add(charge);

        charge = new invoiceit_s__Job_Rate_Plan_Charge__c(invoiceit_s__Product_Rate_Plan_Charge__c = productCharge.Id);
        charge.Name = 'jobRPC';
        charge.invoiceit_s__Job_Rate_Plan__c =jobRP.Id;
        charge.invoiceit_s__Status__c = 'Ready to be Invoiced';
        charge.invoiceit_s__Quantity__c = 12;
        charge.invoiceit_s__Revenue_Recognition_Rule__c = revenueForecasts[0].Id;
        charge.invoiceit_s__Price_Type__c = 'Annual';
        charge.invoiceit_s__Accounting_Code__c = '12345';
        charge.invoiceit_s__Charge_Date__c = system.today();
        charge.invoiceit_s__Unit_Price__c = 12;
        charge.invoiceit_s__Service_Activation_Date__c = system.today();
        charge.invoiceit_s__Revenue_Recognition_Date__c  = system.today();
        charge.invoiceit_s__Service_End_Date__c = system.today() + 100;
        charges.add(charge);

        charge = new invoiceit_s__Job_Rate_Plan_Charge__c(invoiceit_s__Product_Rate_Plan_Charge__c = productCharge.Id);
        charge.Name = 'jobRPC';
        charge.invoiceit_s__Job_Rate_Plan__c =jobRP.Id;
        charge.invoiceit_s__Status__c = 'Ready to be Invoiced';
        charge.invoiceit_s__Quantity__c = 12;
        charge.invoiceit_s__Revenue_Recognition_Rule__c = revenueForecasts[6].Id;
        charge.invoiceit_s__Price_Type__c = 'Half Yearly';
        charge.invoiceit_s__Accounting_Code__c = '12345';
        charge.invoiceit_s__Charge_Date__c = system.today();
        charge.invoiceit_s__Unit_Price__c = 12;
        charge.invoiceit_s__Service_Activation_Date__c = system.today();
        charge.invoiceit_s__Revenue_Recognition_Date__c  = system.today();
        charge.invoiceit_s__Service_End_Date__c = system.today() + 100;
        charges.add(charge);

        charge = new invoiceit_s__Job_Rate_Plan_Charge__c(invoiceit_s__Product_Rate_Plan_Charge__c = productCharge.Id);
        charge.Name = 'jobRPC';
        charge.invoiceit_s__Job_Rate_Plan__c =jobRP.Id;
        charge.invoiceit_s__Status__c = 'Quarterly';
        charge.invoiceit_s__Quantity__c = 12;
        charge.invoiceit_s__Revenue_Recognition_Rule__c = revenueForecasts[3].Id;
        charge.invoiceit_s__Price_Type__c = 'Quarterly';
        charge.invoiceit_s__Accounting_Code__c = '12345';
        charge.invoiceit_s__Charge_Date__c = system.today();
        charge.invoiceit_s__Unit_Price__c = 12;
        charge.invoiceit_s__Service_Activation_Date__c = system.today();
        charge.invoiceit_s__Revenue_Recognition_Date__c  = system.today();
        charge.invoiceit_s__Service_End_Date__c = system.today() + 100;
        charges.add(charge);

        insert charges;

        invoiceit_s__Invoice__c invoice=new invoiceit_s__Invoice__c (invoiceit_s__Account__c=acc.id, invoiceit_s__Invoice_Date__c=system.today(),invoiceit_s__Order__c=job.id,invoiceit_s__Invoice_Status__c ='Posted');
        insert invoice;

        list<invoiceit_s__Invoice_Lines__c> listofInvoiceLines = new list<invoiceit_s__Invoice_Lines__c>();
        invoiceit_s__Invoice_Lines__c invoiceline1= new invoiceit_s__Invoice_Lines__c(RevenueRecognitionRuleNew__c = revenueForecasts[0].Id, invoiceit_s__Sequence_No__c =1, Revenue_Recognition_Date__c = system.today(),RevenueRecognitionEndDatenew__c=system.today()+1, invoiceit_s__Line_Amount__c = 100, invoiceit_s__Calculated_Quantity__c =1, invoiceit_s__Service_End_Date__c = system.today()+30, invoiceit_s__Service_Start_Date__c = system.today(),invoiceit_s__Status__c = 'Cancelled', invoiceit_s__Invoice__c=invoice.id,invoiceit_s__Job__c=job.id,invoiceit_s__Job_Rate_Plan_Charge__c=charges[0].id,invoiceit_s__Line_Name__c='Line 1');
        invoiceit_s__Invoice_Lines__c invoiceline2= new invoiceit_s__Invoice_Lines__c(RevenueRecognitionRuleNew__c = revenueForecasts[1].Id, invoiceit_s__Sequence_No__c=1, Revenue_Recognition_Date__c = system.today(),RevenueRecognitionEndDatenew__c=system.today()+1,invoiceit_s__Line_Amount__c = 100,invoiceit_s__Calculated_Quantity__c =1,invoiceit_s__Service_End_Date__c = system.today()+30,invoiceit_s__Service_Start_Date__c = system.today(),invoiceit_s__Invoice__c=invoice.id,invoiceit_s__Job__c=job.id,invoiceit_s__Job_Rate_Plan_Charge__c=charges[1].id,invoiceit_s__Line_Name__c='Line 1');
        invoiceit_s__Invoice_Lines__c invoiceline3= new invoiceit_s__Invoice_Lines__c(RevenueRecognitionRuleNew__c = revenueForecasts[2].Id, Revenue_Recognition_Date__c = system.today(),invoiceit_s__Line_Amount__c = 100,RevenueRecognitionEndDatenew__c=system.today()+1,invoiceit_s__Calculated_Quantity__c =1,invoiceit_s__Service_End_Date__c = system.today()+30,invoiceit_s__Service_Start_Date__c = system.today(),invoiceit_s__Status__c = 'Cancelled', invoiceit_s__Invoice__c=invoice.id,invoiceit_s__Job__c=job.id,invoiceit_s__Job_Rate_Plan_Charge__c=charges[2].id,invoiceit_s__Line_Name__c='Line 1');
        invoiceit_s__Invoice_Lines__c invoiceline4= new invoiceit_s__Invoice_Lines__c(RevenueRecognitionRuleNew__c = revenueForecasts[3].Id, Revenue_Recognition_Date__c = system.today(),invoiceit_s__Line_Amount__c = 100,RevenueRecognitionEndDatenew__c=system.today()+1,invoiceit_s__Calculated_Quantity__c =1,invoiceit_s__Service_End_Date__c = system.today()+30,invoiceit_s__Service_Start_Date__c = system.today(),invoiceit_s__Invoice__c=invoice.id,invoiceit_s__Job__c=job.id,invoiceit_s__Job_Rate_Plan_Charge__c=charges[3].id,invoiceit_s__Line_Name__c='Line 1');
        invoiceit_s__Invoice_Lines__c invoiceline5= new invoiceit_s__Invoice_Lines__c(RevenueRecognitionRuleNew__c = revenueForecasts[4].Id, Revenue_Recognition_Date__c = system.today(),invoiceit_s__Line_Amount__c = 100,RevenueRecognitionEndDatenew__c=system.today()+1,invoiceit_s__Calculated_Quantity__c =1,invoiceit_s__Service_End_Date__c = system.today()+30,invoiceit_s__Service_Start_Date__c = system.today(),invoiceit_s__Invoice__c=invoice.id,invoiceit_s__Job__c=job.id,invoiceit_s__Job_Rate_Plan_Charge__c=charges[3].id,invoiceit_s__Line_Name__c='Line 1');
        invoiceit_s__Invoice_Lines__c invoiceline6= new invoiceit_s__Invoice_Lines__c(RevenueRecognitionRuleNew__c = revenueForecasts[5].Id, Revenue_Recognition_Date__c = system.today(),invoiceit_s__Line_Amount__c = 100,RevenueRecognitionEndDatenew__c=system.today()+1,invoiceit_s__Calculated_Quantity__c =1,invoiceit_s__Service_End_Date__c = system.today()+30,invoiceit_s__Service_Start_Date__c = system.today(),invoiceit_s__Invoice__c=invoice.id,invoiceit_s__Job__c=job.id,invoiceit_s__Job_Rate_Plan_Charge__c=charges[3].id,invoiceit_s__Line_Name__c='Line 1');
        invoiceit_s__Invoice_Lines__c invoiceline7= new invoiceit_s__Invoice_Lines__c(RevenueRecognitionRuleNew__c = revenueForecasts[6].Id, Revenue_Recognition_Date__c = system.today(),invoiceit_s__Line_Amount__c = 100,RevenueRecognitionEndDatenew__c=system.today()+1,invoiceit_s__Calculated_Quantity__c =1,invoiceit_s__Service_End_Date__c = system.today()+30,invoiceit_s__Service_Start_Date__c = system.today(),invoiceit_s__Invoice__c=invoice.id,invoiceit_s__Job__c=job.id,invoiceit_s__Job_Rate_Plan_Charge__c=charges[3].id,invoiceit_s__Line_Name__c='Line 1');
        invoiceit_s__Invoice_Lines__c invoiceline8= new invoiceit_s__Invoice_Lines__c(RevenueRecognitionRuleNew__c = revenueForecasts[7].Id, Revenue_Recognition_Date__c = system.today(),invoiceit_s__Line_Amount__c = 100,RevenueRecognitionEndDatenew__c=system.today()+1,invoiceit_s__Calculated_Quantity__c =1,invoiceit_s__Service_End_Date__c = system.today()+30,invoiceit_s__Service_Start_Date__c = system.today(),invoiceit_s__Invoice__c=invoice.id,invoiceit_s__Job__c=job.id,invoiceit_s__Job_Rate_Plan_Charge__c=charges[3].id,invoiceit_s__Line_Name__c='Line 1');
        listofInvoiceLines.add(invoiceline1);
        listofInvoiceLines.add(invoiceline2);
        listofInvoiceLines.add(invoiceline3);
        listofInvoiceLines.add(invoiceline4);
        listofInvoiceLines.add(invoiceline5);
        listofInvoiceLines.add(invoiceline6);
        listofInvoiceLines.add(invoiceline7);
        listofInvoiceLines.add(invoiceline8);
        insert listofInvoiceLines;

        test.startTest();
            // This is to cover IITRevenueRecognitionUtilClass_New
            IITRevenueRecognitionUtilClass_New.processRevenueTransactions(invoice.Id, null);
            IITRevenueRecognitionUtilClass_New.processRevenueTransactions(null, invoiceline2.Id);
            
            IITRevenueTransactions.processRevenueTransactions(invoice.Id, null);
            IITRevenueTransactions.processRevenueTransactions(null, invoiceline1.Id);
            IITRevenueTransactions.processRevenueTransactions(null, invoiceline2.Id);
            IITRevenueTransactions.processRevenueTransactions(null, invoiceline3.Id);
            IITRevenueTransactions.processRevenueTransactions(null, invoiceline4.Id);
            IITRevenueTransactions.processRevenueTransactions(null, invoiceline5.Id);
            IITRevenueTransactions.processRevenueTransactions(null, invoiceline6.Id);
            IITRevenueTransactions.processRevenueTransactions(null, invoiceline7.Id);
            IITRevenueTransactions.processRevenueTransactions(null, invoiceline8.Id);
            //IITRevenueTransactions.processRevenueTransactions(null, invoiceline2.Id);
           
            BatchProcessForRevenueTransactions batch = new BatchProcessForRevenueTransactions('SELECT ID FROM invoiceit_s__Invoice_Lines__c');
            database.executeBatch(batch);
    
            invoiceline4.RevenueRecognitionRuleNew__c = revenueForecasts[1].Id;
            update invoiceline4;
    
            invoiceit_s__Revenue_Recognition_Rule__c RevenueRecognitionRule = new  invoiceit_s__Revenue_Recognition_Rule__c(Name = 'Full Recognition - On Service End Date', invoiceit_s__Recognition_Type__c = 'Weighted Monthly Recognition Over Time', invoiceit_s__Recognition_Date__c = 'Service End Date');
            insert RevenueRecognitionRule;
    
            IITRevenueTransactions.processRevenueTransactions(null, invoiceline4.Id);
    
            invoiceline4.RevenueRecognitionRuleNew__c = RevenueRecognitionRule.Id;
            update invoiceline4;
    
            IITRevenueTransactions.processRevenueTransactions(null, invoiceline4.Id);
            IITRevenueTransactions.processRevenueTransactions(invoice.Id, invoiceline2.Id);
    
            invoiceline4.invoiceit_s__Service_End_Date__c = null;
            update invoiceline4;
    
            IITRevenueTransactions.processRevenueTransactions(null, invoiceline4.Id);
            
            IITRevenueTransactions.processRevenueTransactions(invoice.Id, invoiceline4.Id);

        test.stopTest();

    }
    
    @isTest static void test_method_three() {

        // insert the custom settings
        IITTestClassForPhase1.insertCustomSettings();

        Id kvaccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('KV Platform').getRecordTypeId();

        // don't change the billing country field as VAT will be calculated based on this
        Account acc = new Account(Name = 'Test Account', BillingCountry = 'United Kingdom', recordtypeID = kvaccountRecordTypeId);
        insert acc;

        invoiceit_s__Product__c invoiceItProduct = new invoiceit_s__Product__c(invoiceit_s__Valid_From_Date__c = system.today(), Name = 'VOD');
        insert invoiceItProduct;

        invoiceit_s__Product_Rate_Plan__c ratePlan = new invoiceit_s__Product_Rate_Plan__c(Name = 'Full VOD', invoiceit_s__Valid_From_Date__c = system.today());
        ratePlan.invoiceit_s__Product__c = invoiceItProduct.Id;
        insert ratePlan;

        invoiceit_s__Currency__c currency1 = new invoiceit_s__Currency__c(Name = 'EUR', invoiceit_s__Symbol__c = '£');
        insert currency1;

        invoiceit_s__Product_Rate_Plan_Charge__c productCharge = new invoiceit_s__Product_Rate_Plan_Charge__c(invoiceit_s__Product_Rate_Plan__c = ratePlan.Id, Name = 'Annual Subscription Fee: Full VOD', invoiceit_s__CurrencyL__c = currency1.Id);
        insert productCharge;

        // this will cover the IITClassAfterOnOrderRatePlanCharges
        invoiceit_s__Quote__c quote = new invoiceit_s__Quote__c(invoiceit_s__Account__c = acc.id, invoiceit_s__Sub_Total__c = 100, invoiceit_s__Discount_Value__c = 0, invoiceit_s__CurrencyL__c = currency1.Id);
        quote.invoiceit_s__Account__c = acc.Id;
        quote.Shipping_Account__c = acc.Id;
        quote.IITIntended_Use__c = 'LOCAL UK WATERS';
        quote.Wet_or_Dry_Cargo__c = 'Dry Cargo';
        insert quote;

        invoiceit_s__Quote_Product__c  quoteProduct = new invoiceit_s__Quote_Product__c(Name = 'jobProduct',invoiceit_s__Quote__c = quote.Id);
        insert quoteProduct;

        invoiceit_s__Quote_Rate_Plan__c quoteRP = new invoiceit_s__Quote_Rate_Plan__c(Name = 'JobRP',invoiceit_s__Quote_Product__c = quoteProduct.Id);
        insert quoteRP;

        invoiceit_s__Quote_Rate_Plan_Charge__c quotecharge = new invoiceit_s__Quote_Rate_Plan_Charge__c();
        quotecharge.Name = 'jobRPC';
        quotecharge.invoiceit_s__Quote_Rate_Plan__c =quoteRP.Id;
        quotecharge.invoiceit_s__Quantity__c = 12;
        quotecharge.invoiceit_s__Price_Type__c = 'One Time';
        quotecharge.invoiceit_s__Accounting_Code__c = '12345';
        quotecharge.invoiceit_s__Unit_Price__c = 12;
        insert quotecharge;

        // This is used to cover ControllerAssignTitlesToQuoteCharge class
        
        Quote_Charge_Titles__c ordercharge = new Quote_Charge_Titles__c(Quote_Rate_Plan_Charge__c = quotecharge.Id);
        insert ordercharge;

        Titles__c Titles = new Titles__c(Name = 'titles', Length__c = '12', Platform_Type__c = 'Dry Cargo', Included_in_VOD__c = 'Full VOD', List_Price__c = 450);
        insert Titles;

        Format_Types__c formatTypes = new Format_Types__c(Format__c = 'VIDEO', Title__c = Titles.Id, Status__c = 'Current', Delivery_Method_s__c = 'VOD G2;VOD G1');
        insert formatTypes;

        ApexPages.StandardController controllerTitles = new ApexPages.StandardController(quotecharge);
        ControllerAssignTitlesToQuoteCharge controllerAssignTitlesToChargeObj = new ControllerAssignTitlesToQuoteCharge(controllerTitles);

        controllerAssignTitlesToChargeObj.next();
        controllerAssignTitlesToChargeObj.previous();
        controllerAssignTitlesToChargeObj.last();
        controllerAssignTitlesToChargeObj.first();
        controllerAssignTitlesToChargeObj.addTitles();

        controllerAssignTitlesToChargeObj.sSearchString = 'titl';
        controllerAssignTitlesToChargeObj.sSearchStringFormat = 'VIDEO';
        controllerAssignTitlesToChargeObj.searchTitles();
        controllerAssignTitlesToChargeObj.searchFormats();
        controllerAssignTitlesToChargeObj.saveTitles();
        apexpages.currentpage().getparameters().put('removeTitles','1');
        controllerAssignTitlesToChargeObj.removeTitles(); 
    }
}