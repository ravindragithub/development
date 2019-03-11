@isTest
public class IITTestClassForPhase1 {

    @isTest static void test_method_one() {
        // insert the custom settings
        insertCustomSettings();

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
        job.Withholding_Tax_Percentage__c = 10;
        insert job;

        invoiceit_s__Job_Product__c  jobProduct= new invoiceit_s__Job_Product__c(invoiceit_s__Product__c = invoiceItProduct.Id, Name = 'jobProduct',invoiceit_s__Job__c = job.Id);
        insert jobProduct;

        invoiceit_s__Job_Rate_Plan__c jobRP = new invoiceit_s__Job_Rate_Plan__c(invoiceit_s__Product_Rate_Plan__c = ratePlan.Id, Name = 'JobRP',invoiceit_s__Job_Product__c =jobProduct.Id);
        insert jobRP;

        invoiceit_s__Job_Rate_Plan_Charge__c charge = new invoiceit_s__Job_Rate_Plan_Charge__c(invoiceit_s__Product_Rate_Plan_Charge__c = productCharge.Id);
        charge.Name = 'jobRPC';
        charge.invoiceit_s__Order__c = job.Id;
        charge.invoiceit_s__Job_Rate_Plan__c =jobRP.Id;
        charge.invoiceit_s__Status__c = 'Ready to be Invoiced';
        charge.invoiceit_s__Quantity__c = 12;
        charge.invoiceit_s__Price_Type__c = 'One Time';
        charge.invoiceit_s__Accounting_Code__c = '12345';
        charge.invoiceit_s__Charge_Date__c = system.today();
        charge.invoiceit_s__Unit_Price__c = 12;
        insert charge;

        list<invoiceit_s__Job_Rate_Plan_Charge_Tier__c> tierslist = new  list<invoiceit_s__Job_Rate_Plan_Charge_Tier__c>();
        invoiceit_s__Job_Rate_Plan_Charge_Tier__c tier01 = new invoiceit_s__Job_Rate_Plan_Charge_Tier__c(invoiceit_s__Start_Unit__c = 1,invoiceit_s__End_Unit__c=5,invoiceit_s__Unit_Price__c = 400,invoiceit_s__Job_Rate_Plan_Charge__c = charge.id);
        invoiceit_s__Job_Rate_Plan_Charge_Tier__c tier02 = new invoiceit_s__Job_Rate_Plan_Charge_Tier__c(invoiceit_s__Start_Unit__c = 6,invoiceit_s__End_Unit__c=10,invoiceit_s__Unit_Price__c = 400,invoiceit_s__Job_Rate_Plan_Charge__c = charge.id);
        invoiceit_s__Job_Rate_Plan_Charge_Tier__c tier11 = new invoiceit_s__Job_Rate_Plan_Charge_Tier__c(invoiceit_s__Start_Unit__c = 1,invoiceit_s__End_Unit__c=5,invoiceit_s__Unit_Price__c = 400,invoiceit_s__Job_Rate_Plan_Charge__c = charge.id);
        invoiceit_s__Job_Rate_Plan_Charge_Tier__c tier12 = new invoiceit_s__Job_Rate_Plan_Charge_Tier__c(invoiceit_s__Start_Unit__c = 6,invoiceit_s__End_Unit__c=10,invoiceit_s__Unit_Price__c = 400,invoiceit_s__Job_Rate_Plan_Charge__c = charge.id);
        tierslist.add(tier01);
        tierslist.add(tier02);
        tierslist.add(tier11);
        tierslist.add(tier12);
        insert tierslist;

        // This is to cover Clone Order functinality via batch process
        test.startTest(); 

        Order_Charge_Titles__c ordercharge = new Order_Charge_Titles__c(Order_Rate_Plan_Charge__c = charge.Id);
        insert ordercharge;

        job.IITIntended_Use__c = 'LOCAL EU WATERS';
        job.Withholding_Tax_Percentage__c = 0;
        upsert job;

        ApexPages.StandardController controller = new ApexPages.StandardController(job);   
        ControllerCloneOrder ControllerCloneOrderobj = new ControllerCloneOrder(controller);
        ControllerCloneOrderobj.isMasterOrder = True;
        ControllerCloneOrderobj.createCloneOrder();
        ControllerCloneOrderobj.masterOrder();
        ControllerCloneOrderobj.isChildOrder = True;
        ControllerCloneOrderobj.createCloneOrder();
        test.stopTest();

        // This is to cover ControllerAssignTitlesToCharge functionality  
        Titles__c Titles = new Titles__c(Length__c = '12', Platform_Type__c = 'Dry Cargo', Included_in_VOD__c = 'Full VOD', List_Price__c = 450);
        insert Titles;

        Format_Types__c formatTypes = new Format_Types__c(Title__c = Titles.Id, Status__c = 'Current', Delivery_Method_s__c = 'VOD G2;VOD G1');
        insert formatTypes;

        // This is to cover ControllerAssignTitlesToCharge functionality   
        ApexPages.StandardController controllerTitles = new ApexPages.StandardController(charge);
        ControllerAssignTitlesToCharge controllerAssignTitlesToChargeObj = new ControllerAssignTitlesToCharge(controllerTitles);

    }

    @isTest static void test_method_Invoice() {
        insertCustomSettings();

        Id kvaccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('KV Platform').getRecordTypeId();

        // don't change the billing country field as VAT will be calculated based on this
        Account acc = new Account(Name = 'Test Account', BillingCountry = 'United Kingdom', recordtypeID = kvaccountRecordTypeId);
        insert acc;

        invoiceit_s__Currency__c currency1 = new invoiceit_s__Currency__c(Name = 'EUR', invoiceit_s__Symbol__c = '£');
        insert currency1;

        // this will cover the IITClassAfterOnOrderRatePlanCharges
        invoiceit_s__Job__c job = new invoiceit_s__Job__c(invoiceit_s__Account__c = acc.id, invoiceit_s__Sub_Total__c = 100, invoiceit_s__Discount_Value__c = 0, invoiceit_s__CurrencyL__c = currency1.Id);
        job.invoiceit_s__Account__c = acc.Id;
        job.Shipping_Account__c = acc.Id;
        job.IITIntended_Use__c = 'LOCAL UK WATERS';
        job.Withholding_Tax_Percentage__c = 10;
        insert job;

        invoiceit_s__Invoice__c invoice = new invoiceit_s__Invoice__c(invoiceit_s__Account__c = acc.id,
                invoiceit_s__CurrencyL__c = currency1.Id, invoiceit_s__Target_Date__c = Date.today(), invoiceit_s__Delivery_Type__c = 'Both', invoiceit_s__Invoice_Status__c = 'Posted'
                    ,invoiceit_s__Invoice_Date__c = System.today()
        );
        insert invoice;

        list<invoiceit_s__Invoice_Lines__c> listInvoiceLines = new list<invoiceit_s__Invoice_Lines__c>();
        listInvoiceLines.add(new invoiceit_s__Invoice_Lines__c(invoiceit_s__Invoice__c = invoice.id, invoiceit_s__Line_Name__c = 'Broadband Installation For L',invoiceit_s__Quantity__c = 1,invoiceit_s__Unit_Price__c = 40.00,invoiceit_s__VAT__c = 8.00,invoiceit_s__Line_Amount__c = 40.00,invoiceit_s__Job__c = job.Id));
        listInvoiceLines.add(new invoiceit_s__Invoice_Lines__c(invoiceit_s__Invoice__c = invoice.id, invoiceit_s__Line_Name__c = 'Broadband Installation For X',invoiceit_s__Quantity__c = 1,invoiceit_s__Unit_Price__c = 40.00,invoiceit_s__VAT__c = 8.00,invoiceit_s__Line_Amount__c = 40.00,invoiceit_s__Job__c = job.Id));
        listInvoiceLines.add(new invoiceit_s__Invoice_Lines__c(invoiceit_s__Invoice__c = invoice.id, invoiceit_s__Line_Name__c = 'Broadband Installation For M',invoiceit_s__Quantity__c = 1,invoiceit_s__Unit_Price__c = 40.00,invoiceit_s__VAT__c = 8.00,invoiceit_s__Line_Amount__c = 40.00,invoiceit_s__Job__c = job.Id));
        listInvoiceLines.add(new invoiceit_s__Invoice_Lines__c(invoiceit_s__Invoice__c = invoice.id, invoiceit_s__Line_Name__c = 'Broadband Installation For L',invoiceit_s__Quantity__c = 1,invoiceit_s__Unit_Price__c = 40.00,invoiceit_s__VAT__c = 8.00,invoiceit_s__Line_Amount__c = 40.00,invoiceit_s__Job__c = job.Id));
        listInvoiceLines.add(new invoiceit_s__Invoice_Lines__c(invoiceit_s__Invoice__c = invoice.id, invoiceit_s__Line_Name__c = 'Broadband Installation For X',invoiceit_s__Quantity__c = 1,invoiceit_s__Unit_Price__c = 40.00,invoiceit_s__VAT__c = 8.00,invoiceit_s__Line_Amount__c = 40.00,invoiceit_s__Job__c = job.Id));
        insert listInvoiceLines;

        update listInvoiceLines;

        invoiceit_s__Payment__c payment = new invoiceit_s__Payment__c(invoiceit_s__Status__c = 'Completed', invoiceit_s__Account__c =acc.id,invoiceit_s__Amount__c = 10000, invoiceit_s__Currency__c = currency1.Id, invoiceit_s__Payment_Type__c = 'Cash');
        insert payment;

        // This is to cover IITControllerAllocatePayments functionality  

        ApexPages.StandardController stdController = new ApexPages.StandardController(payment);
        IITControllerAllocatePayments controllerAllocatePayment = new IITControllerAllocatePayments(stdController);
        system.currentPageReference().getParameters().put('selectedCounter', '1');
        controllerAllocatePayment.getSelectedInvoice();
        controllerAllocatePayment.savePaymentAllocations();
        controllerAllocatePayment.backToPayment();

        for(IITControllerAllocatePayments.paymentAllocation allocationClass : controllerAllocatePayment.listOfallocationClass) {
            allocationClass.isChecked = true;
        } 

        controllerAllocatePayment.map_Counter_allocationClass.get(1).paymentAllocation.invoiceit_s__Amount__c = 100;
        controllerAllocatePayment.savePaymentAllocations();

        ApexPages.StandardController stdControllerObj = new ApexPages.StandardController(payment);
        IITControllerAllocatePayments controllerAllocatePaymentsObj = new IITControllerAllocatePayments(stdControllerObj);
        system.currentPageReference().getParameters().put('paymentAllocationId', controllerAllocatePaymentsObj.listOfPaymentAllocationsInDb[0].Id);
        controllerAllocatePaymentsObj.cancelPaymentAllocation();

        Id childrecordId = Schema.SObjectType.invoiceit_s__Job__c.getRecordTypeInfosByName().get('Child Order').getRecordTypeId();
        invoiceit_s__Job__c jobChild = new invoiceit_s__Job__c(invoiceit_s__Master_Order__c = job.Id, recordtypeID = childrecordId, invoiceit_s__Account__c = acc.id, invoiceit_s__Sub_Total__c = 100, invoiceit_s__Discount_Value__c = 0, invoiceit_s__CurrencyL__c = currency1.Id);
        job.invoiceit_s__Account__c = acc.Id;
        job.Shipping_Account__c = acc.Id;
        job.IITIntended_Use__c = 'LOCAL UK WATERS';
        insert jobChild;

        // This is to cover IITCreateOrder functionality  

        invoiceit_s__Job__c jobChildObj = new invoiceit_s__Job__c();
        system.currentPageReference().getParameters().put('RecordType', childrecordId);
        ApexPages.StandardController controllerOrder = new ApexPages.StandardController(jobChildObj);
        IITCreateOrder IITCreateOrderObj = new IITCreateOrder(controllerOrder);
        IITCreateOrderObj.quicksave();

        test.startTest();
        system.currentPageReference().getParameters().put('RecordType', childrecordId);
        ApexPages.StandardController controllerOrder1 = new ApexPages.StandardController(jobChild);
        IITCreateOrder IITCreateOrderObj1 = new IITCreateOrder(controllerOrder1);
        IITCreateOrderObj1.quicksave();
        // This is to cover BatchProcessCreationOfOrder 

        BatchProcessCreationOfOrder batchProcessCreationOfOrderObj= new BatchProcessCreationOfOrder(1, jobChild);
        database.executeBatch(batchProcessCreationOfOrderObj);
        test.stopTest();
    }

    @isTest static void test_method_four() {

        // insert the custom settings
        insertCustomSettings();

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

        // this will cover the IITClassAfterOnQuoteRatePlanCharges
        invoiceit_s__Quote__c quote = new invoiceit_s__Quote__c(invoiceit_s__Account__c = acc.id, invoiceit_s__Sub_Total__c = 100, invoiceit_s__Discount_Value__c = 0, invoiceit_s__CurrencyL__c = currency1.Id);
        quote.invoiceit_s__Account__c = acc.Id;
        quote.Shipping_Account__c = acc.Id;
        quote.IITIntended_Use__c = 'LOCAL UK WATERS';
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

        quote.IITIntended_Use__c = 'LOCAL AK WATERS';
        upsert quote;
    }

    @isTest static void test_method_two() {

        insertCustomSettings();

        Id kvaccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('KV Platform').getRecordTypeId();

        // don't change the billing country field as VAT will be calculated based on this
        Account acc = new Account(Name = 'Test Account', BillingCountry = 'United Kingdom', recordtypeID = kvaccountRecordTypeId);
        insert acc;

        invoiceit_s__Currency__c currency1 = new invoiceit_s__Currency__c(Name = 'USD', invoiceit_s__Symbol__c = '£');
        insert currency1;

        Opportunity oppty = new Opportunity(invoiceit_crmx__CurrencyL__c = currency1.Id);
        oppty.AccountId = acc.Id;
        //oppty.Shipping_Account__c = acc.Id;
        oppty.IITIntended_Use__c = 'LOCAL UK WATERS';
        oppty.stageName = 'Close Won';
        oppty.CloseDate = system.today();
        oppty.Name = 'testOpp';
        insert oppty;

        invoiceit_crmx__Opportunity_Product__c  opptyProduct = new invoiceit_crmx__Opportunity_Product__c(Name = 'jobProduct',invoiceit_crmx__Opportunity__c = oppty.Id);
        insert opptyProduct;

        invoiceit_crmx__Opportunity_Rate_Plan__c opptyRP = new invoiceit_crmx__Opportunity_Rate_Plan__c(Name = 'JobRP',invoiceit_crmx__Opportunity_Product__c =opptyProduct.Id);
        insert opptyRP;

        invoiceit_crmx__Opportunity_Rate_Plan_Charge__c opptyCharge = new invoiceit_crmx__Opportunity_Rate_Plan_Charge__c();
        opptyCharge.Name = 'jobRPC';
        opptyCharge.invoiceit_crmx__Opportunity_Rate_Plan__c = opptyRP.Id;
        opptyCharge.invoiceit_crmx__Status__c = 'Ready to be Invoiced';
        opptyCharge.invoiceit_crmx__Quantity__c = 12;
        opptyCharge.invoiceit_crmx__Price_Type__c = 'One Time';
        opptyCharge.invoiceit_crmx__Accounting_Code__c = '12345';
        opptyCharge.invoiceit_crmx__Unit_Price__c = 12;
        insert opptyCharge;


        // non VAT
        Account acc2 = new Account(Name = 'Test Account', BillingCountry = 'USA', recordtypeID = kvaccountRecordTypeId);
        insert acc2;

        Opportunity oppty2 = new Opportunity(invoiceit_crmx__CurrencyL__c = currency1.Id);
        oppty2.AccountId = acc2.Id;
        oppty2.Shipping_Account__c = acc2.Id;
        oppty2.IITIntended_Use__c = 'LOCAL UK WATERS';
        oppty2.Name = 'testOpp';
        oppty2.stageName = 'Close Won';
        oppty2.CloseDate = system.today();
        insert oppty2;

        invoiceit_crmx__Opportunity_Product__c  opptyProduct2 = new invoiceit_crmx__Opportunity_Product__c(Name = 'jobProduct',invoiceit_crmx__Opportunity__c = oppty2.Id);
        insert opptyProduct2;

        invoiceit_crmx__Opportunity_Rate_Plan__c opptyRP2 = new invoiceit_crmx__Opportunity_Rate_Plan__c(Name = 'JobRP',invoiceit_crmx__Opportunity_Product__c =opptyProduct2.Id);
        insert opptyRP2;

        invoiceit_crmx__Opportunity_Rate_Plan_Charge__c opptyCharge2 = new invoiceit_crmx__Opportunity_Rate_Plan_Charge__c();
        opptyCharge2.Name = 'jobRPC';
        opptyCharge2.invoiceit_crmx__Opportunity_Rate_Plan__c = opptyRP2.Id;
        opptyCharge2.invoiceit_crmx__Status__c = 'Ready to be Invoiced';
        opptyCharge2.invoiceit_crmx__Quantity__c = 12;
        opptyCharge2.invoiceit_crmx__Price_Type__c = 'One Time';
        opptyCharge2.invoiceit_crmx__Accounting_Code__c = '12345';
        opptyCharge2.invoiceit_crmx__Unit_Price__c = 12;
        insert opptyCharge2;

        //========================Test class for createOrderobj========================================
        ApexPages.StandardController controller = new ApexPages.StandardController(oppty);
        createOrder createOrderobj = new createOrder(controller);
        createOrderobj.createOrder();


        ApexPages.StandardController controllerObj = new ApexPages.StandardController(oppty2);
        createOrder createOrderobj1 = new createOrder(controllerObj);
        createOrderobj1.createOrder();

        //==========================Test class controllerSyncQuote =====================================

        test.startTest();

        invoiceit_s__Quote__c quote = new invoiceit_s__Quote__c(invoiceit_crmx__Opportunity__c = oppty.Id, invoiceit_s__Account__c = acc.id, invoiceit_s__Sub_Total__c = 100, invoiceit_s__Discount_Value__c = 0, invoiceit_s__CurrencyL__c = currency1.Id);
        quote.invoiceit_s__Account__c = acc.Id;
        //quote.Shipping_Account__c = acc.Id; 
        quote.IITIntended_Use__c = 'LOCAL UK WATERS';
        insert quote;

        ApexPages.StandardController controllerQuote = new ApexPages.StandardController(quote);
        controllerSyncQuote controllerSyncQuoteObj = new controllerSyncQuote(controllerQuote);
        controllerSyncQuoteObj.SyncQuote();

        quote.invoiceit_crmx__Opportunity__c = oppty.Id;
        ApexPages.StandardController controllerQuote1 = new ApexPages.StandardController(quote);
        controllerSyncQuote controllerSyncQuoteObj1 = new controllerSyncQuote(controllerQuote);
       
        
        quote.invoiceit_s__Sync_Quote__c = true;
        //update quote;
        controllerSyncQuoteObj.SyncQuote();   
        
        test.stopTest();
    }

    @isTest static void IITControllerCreateAdhocInvoice() {

        insertCustomSettings();

        Id kvaccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('KV Platform').getRecordTypeId();

        // don't change the billing country field as VAT will be calculated based on this
        Account acc = new Account(Name = 'Test Account', BillingCountry = 'United Kingdom', recordtypeID = kvaccountRecordTypeId);
        insert acc;

        invoiceit_s__Currency__c currency1 = new invoiceit_s__Currency__c(Name = 'USD', invoiceit_s__Symbol__c = '£');
        insert currency1;  
        //==========================Test class IITControllerCreateAdhocInvoice =====================================

        invoiceit_s__Job__c job = new invoiceit_s__Job__c(invoiceit_s__Account__c = acc.id, invoiceit_s__Sub_Total__c = 100, invoiceit_s__Discount_Value__c = 0, invoiceit_s__CurrencyL__c = currency1.Id);
        job.invoiceit_s__Account__c = acc.Id;
        job.Shipping_Account__c = acc.Id;
        job.IITIntended_Use__c = 'LOCAL UK WATERS';
        job.Withholding_Tax_Percentage__c = 10;
        insert job;

        ApexPages.Standardcontroller stdController = new Apexpages.Standardcontroller(job);
        // this will cover IITControllerCreateAdhocInvoice, this will say service start is missing
        IITControllerCreateAdhocInvoice createJobController = new IITControllerCreateAdhocInvoice(stdController);
        // this will say alignment dates are missing
        createJobController.firstInvoice = true;
        createJobController.onChangefirstInvoice();

        // this will say alignment dates is missing
        job.invoiceit_s__Service_Activation_Date__c = system.today();
        update job;
        stdController = new Apexpages.Standardcontroller(job);
        createJobController = new IITControllerCreateAdhocInvoice(stdController);
        createJobController.job.invoiceit_s__Service_Activation_Date__c = null;
        createJobController.firstInvoice = true;
        createJobController.createAdhocInvoice();

        job.Alignment_Date_1__c = system.today();
        job.Alignment_Date_2__c = system.today();
        upsert job;

        // this will create the invoice
        stdController = new Apexpages.Standardcontroller(job);
        createJobController = new IITControllerCreateAdhocInvoice(stdController);
        createJobController.job.invoiceit_s__Service_Activation_Date__c = system.today();
        createJobController.firstInvoice = true;
        createJobController.onChangefirstInvoice();
        createJobController.createAdhocInvoice();
        //===============================================================================================

    }

    public static void insertCustomSettings() {

        list<Legal_Entity__c> listofSequenceNumber = new list<Legal_Entity__c>();

        Legal_Entity__c sequenceNumberVMA = new Legal_Entity__c(Name = 'VMA', Invoice_Next_Number__c = 1);
        Legal_Entity__c sequenceNumberVMI = new Legal_Entity__c(Name = 'VMI', Invoice_Next_Number__c = 1);
        listofSequenceNumber.add(sequenceNumberVMA);
        listofSequenceNumber.add(sequenceNumberVMI);
        insert listofSequenceNumber; 

        list<Invoiceit_s__Configuration__c> objects = new list<Invoiceit_s__Configuration__c>();

        Invoiceit_s__Configuration__c c1 =  new Invoiceit_s__Configuration__c(Name = 'QUOTE_PAGE_3', invoiceit_s__String_Value__c = 'createquotestep3'); 
        Invoiceit_s__Configuration__c c2 =  new Invoiceit_s__Configuration__c(Name = 'QUOTE_PAGE_2', invoiceit_s__String_Value__c = 'createquotestep2'); 
        Invoiceit_s__Configuration__c c3 =  new Invoiceit_s__Configuration__c(Name = 'PRODUCT_OBJECTNAME', invoiceit_s__String_Value__c = 'invoiceit_s__Product__c', invoiceit_s__Description__c = 'The name of the object that has to be searched for ');
        Invoiceit_s__Configuration__c c4 =  new Invoiceit_s__Configuration__c(Name = 'NO_OF_DECIMALS_FOR_CURRENCY_VALUES', invoiceit_s__NUMBER_VALUE__C = 3, invoiceit_s__Field_Type__c = 'Number', invoiceit_s__Description__c = 'Define the number of decimals (precision) for all your currency values. Currency values will be rounded to the specified number of decimals',invoiceit_s__Category__c ='General',invoiceit_s__Sequence__c = 15);
        Invoiceit_s__Configuration__c c5 =  new Invoiceit_s__Configuration__c(Name = 'CALCULATION_PRECISION', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Mention if you want to ROUND_UP or ROUND_DOWN the quote and order totals. If total is 46.70 ROUND_UP will make it 47 and ROUND_DOWN will make it 46. Leaving this blank will leave the total unchanged.',invoiceit_s__Picklist_Indicator__c ='listCalculatePrecision',invoiceit_s__Category__c ='Quote',invoiceit_s__Sequence__c = 3);
        Invoiceit_s__Configuration__c c6 =  new Invoiceit_s__Configuration__c(Name = 'PRODUCT_SEARCH_LIMIT', invoiceit_s__NUMBER_VALUE__C = 20, invoiceit_s__Field_Type__c = 'Number', invoiceit_s__Description__c = 'Define the maximum number of Invoice IT Product records that are returned in the instant product search results',invoiceit_s__Category__c ='General',invoiceit_s__Quick_Screen_Id__c ='3',invoiceit_s__Sequence__c = 1);
        Invoiceit_s__Configuration__c c7 =  new Invoiceit_s__Configuration__c(Name = 'PRODUCT_ORDERFIELD', invoiceit_s__String_Value__c = 'Name', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define the order in which the Invoice IT Product fields are displayed in the instant product search results',invoiceit_s__Picklist_Indicator__c ='listProductFields1',invoiceit_s__Category__c ='General',invoiceit_s__Quick_Screen_Id__c ='3',invoiceit_s__Sequence__c = 2);
        Invoiceit_s__Configuration__c c8 =  new Invoiceit_s__Configuration__c(Name = 'TYPE_OF_PACKAGE', invoiceit_s__String_Value__c = 'STANDALONE');
        Invoiceit_s__Configuration__c c9 =  new Invoiceit_s__Configuration__c(Name = 'PRODUCT_DISPLAYFIELDS', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define the Invoice IT Product fields that are displayed in the instant product search results',invoiceit_s__Picklist_Indicator__c ='listProductFields2',invoiceit_s__Category__c ='General',invoiceit_s__Quick_Screen_Id__c ='3',invoiceit_s__Sequence__c = 3);
        Invoiceit_s__Configuration__c c10 = new Invoiceit_s__Configuration__c(Name = 'INVOICE_GROUP_CRITERIA', invoiceit_s__String_Value__c = 'ONE_INVOICE_PER_ORDER', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define whether you want the invoice scheduler to generate one invoice per order or to generate a consolidated invoice per account',invoiceit_s__Picklist_Indicator__c ='listInvoiceGeneration',invoiceit_s__Category__c ='Invoice',invoiceit_s__Quick_Screen_Id__c ='4',invoiceit_s__Sequence__c = 8);
        Invoiceit_s__Configuration__c c11 = new Invoiceit_s__Configuration__c(Name = 'ORDER_PAGE_3', invoiceit_s__String_Value__c = 'createjobstep3');
        Invoiceit_s__Configuration__c c12 = new Invoiceit_s__Configuration__c(Name = 'ORDER_STATUS_FOR_INVOICING', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define the Order status that determines if the Order has to be picked up for invoicing',invoiceit_s__Picklist_Indicator__c ='listOrderStatusfields',invoiceit_s__Category__c ='Order',invoiceit_s__Quick_Screen_Id__c ='4',invoiceit_s__Sequence__c = 3);
        Invoiceit_s__Configuration__c c13 = new Invoiceit_s__Configuration__c(Name = 'DEFAULT_CURRENCY', invoiceit_s__String_Value__c = 'GBP', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Mention the ISO code of your default currency here. Say GBP',invoiceit_s__Category__c ='General',invoiceit_s__Quick_Screen_Id__c ='3',invoiceit_s__Sequence__c = 4);
        Invoiceit_s__Configuration__c c14 = new Invoiceit_s__Configuration__c(Name = 'QUOTE_VALIDITY_PERIOD', invoiceit_s__NUMBER_VALUE__C = 15, invoiceit_s__Field_Type__c = 'Number', invoiceit_s__Description__c = 'The default number of days that a Quote is valid for after the date it is created',invoiceit_s__Category__c ='Quote',invoiceit_s__Quick_Screen_Id__c ='4',invoiceit_s__Sequence__c = 2);
        Invoiceit_s__Configuration__c c15 = new Invoiceit_s__Configuration__c(Name = 'ORDER_PAGE_2', invoiceit_s__String_Value__c = 'createjobstep2');
        Invoiceit_s__Configuration__c c16 = new Invoiceit_s__Configuration__c(Name = 'CHARGE_STATUS_FOR_INVOICING', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define the Order Line status that determines if the Order Line has to be picked up for invoicing',invoiceit_s__Picklist_Indicator__c ='listORPCStatus',invoiceit_s__Category__c ='Order',invoiceit_s__Quick_Screen_Id__c ='4',invoiceit_s__Sequence__c = 4);
        Invoiceit_s__Configuration__c c17 = new Invoiceit_s__Configuration__c(Name = 'INVOICE_NO_OF_DAYS_TILL_DUE_DATE', invoiceit_s__NUMBER_VALUE__C = 15, invoiceit_s__Field_Type__c = 'Number', invoiceit_s__Description__c = 'The default number of days when an invoice is due from the invoice date',invoiceit_s__Category__c ='Invoice',invoiceit_s__Sequence__c = 1);
        Invoiceit_s__Configuration__c c18 = new Invoiceit_s__Configuration__c(Name = 'TAX_CALCULATION_BASED_ON', invoiceit_s__String_Value__c = 'Account Billing Address', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define whether the Tax and/or VAT is calculated based on the Shipping Contact Address, Billing Contact Address or the Account Billing Address',invoiceit_s__Picklist_Indicator__c ='listTaxCalculationBasedOn',invoiceit_s__Category__c ='General',invoiceit_s__Quick_Screen_Id__c ='3',invoiceit_s__Sequence__c = 5);
        Invoiceit_s__Configuration__c c19 = new Invoiceit_s__Configuration__c(Name = 'USE_SERVICE_START_DATE_FOR_INVOICE', invoiceit_s__Field_Type__c = 'Boolean', invoiceit_s__Description__c = 'Align the Order service start date to Order date. Leave this un-checked if normally your Order service start dates are different to the order date', invoiceit_s__Boolean_Value__c = True,invoiceit_s__Category__c ='Order',invoiceit_s__Quick_Screen_Id__c ='4',invoiceit_s__Sequence__c = 5);
        Invoiceit_s__Configuration__c c20 = new Invoiceit_s__Configuration__c(Name = 'DISCOUNT_BY_VALUE_OR_PERCENTAGE', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Enable discounts by percentage(%) or by value', invoiceit_s__String_Value__c = 'APPLY_DISCOUNT_BY_PERCENTAGE',invoiceit_s__Picklist_Indicator__c ='listApplyDiscounts',invoiceit_s__Category__c ='General',invoiceit_s__Quick_Screen_Id__c ='3',invoiceit_s__Sequence__c = 6);
        Invoiceit_s__Configuration__c c21 = new Invoiceit_s__Configuration__c(Name = 'AUTOMATE_PAYMENT_ALLOCATION', invoiceit_s__Field_Type__c = 'Boolean', invoiceit_s__Description__c = 'Should payments be allocated against pending invoices automatically', invoiceit_s__Boolean_Value__c = False,invoiceit_s__Category__c ='Invoice',invoiceit_s__Quick_Screen_Id__c ='4',invoiceit_s__Sequence__c = 9);
        Invoiceit_s__Configuration__c c22 = new Invoiceit_s__Configuration__c(Name = 'ORDER_DISCOUNT_CODE_FIELD', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define the field on the Order object that stores the discount code', invoiceit_s__String_Value__c = 'Discount_Code__c',invoiceit_s__Picklist_Indicator__c ='listOrderFieldsForDiscountCode',invoiceit_s__Category__c ='Order',invoiceit_s__Sequence__c = 1);
        Invoiceit_s__Configuration__c c23 = new Invoiceit_s__Configuration__c(Name = 'QUOTE_DISCOUNT_CODE_FIELD', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define the field on the Quote object that stores the discount code', invoiceit_s__String_Value__c = 'Discount_Code__c',invoiceit_s__Picklist_Indicator__c ='listQuoteFieldsForDiscountCode',invoiceit_s__Category__c ='Quote',invoiceit_s__Sequence__c = 4);
        Invoiceit_s__Configuration__c c24 = new Invoiceit_s__Configuration__c(Name = 'DEFAULT_PAYMENT_TERMS', invoiceit_s__Field_Type__c = 'String', invoiceit_s__String_Value__c = 'Due On Receipt', invoiceit_s__Description__c = 'Set the global payment terms value for Invoice IT',invoiceit_s__Picklist_Indicator__c ='listDefaultPaymentTerms',invoiceit_s__Category__c ='General',invoiceit_s__Quick_Screen_Id__c ='3',invoiceit_s__Sequence__c = 7);
        Invoiceit_s__Configuration__c c25 = new Invoiceit_s__Configuration__c(Name = 'ALIGN_DATES_OF_ORDER_TO_PRODUCTS', invoiceit_s__Description__c = 'Align the service start dates of the order lines to the service start dates of the order', invoiceit_s__Field_Type__c = 'Boolean', invoiceit_s__Boolean_Value__c = True,invoiceit_s__Category__c ='Order',invoiceit_s__Quick_Screen_Id__c ='4',invoiceit_s__Sequence__c = 6);
        Invoiceit_s__Configuration__c c26 = new Invoiceit_s__Configuration__c(Name = 'CAN_REFUND_CHARGES_DURING_ADJUSTMENTS', invoiceit_s__Field_Type__c = 'Boolean', invoiceit_s__Description__c = 'Define whether you want to provide a refund for services that are paid for but cancelled mid-term', invoiceit_s__Boolean_Value__c = False,invoiceit_s__Category__c ='Invoice',invoiceit_s__Quick_Screen_Id__c ='4',invoiceit_s__Sequence__c = 10);
        Invoiceit_s__Configuration__c c27 = new Invoiceit_s__Configuration__c(Name = 'DEFAULT_QUANTITY_IN_WIZARDS', invoiceit_s__Field_Type__c = 'Number', invoiceit_s__Description__c = 'Set the global default quantity of product line items if the default quantity value has not been specified in the product catalogue', invoiceit_s__NUMBER_VALUE__C = 1,invoiceit_s__Category__c ='General',invoiceit_s__Sequence__c = 10);
        Invoiceit_s__Configuration__c c28 = new Invoiceit_s__Configuration__c(Name = 'IS_ORDER_FROM_CLOSED_WON_OPP', invoiceit_s__Field_Type__c = 'Boolean', invoiceit_s__Description__c = 'Automatically generate an Order when an Opportunity is set to Closed Won', invoiceit_s__Boolean_Value__c = True,invoiceit_s__Category__c ='Opportunity',invoiceit_s__Quick_Screen_Id__c ='5',invoiceit_s__Sequence__c = 4);
        Invoiceit_s__Configuration__c c29 = new Invoiceit_s__Configuration__c(Name = 'POPULATE_OPPORTUNITY_AMOUNT_FROM', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Which total field should automatically populate the Opportunity "Amount" field', invoiceit_s__String_Value__c = 'NETTOTAL',invoiceit_s__Picklist_Indicator__c ='listProductValueToRollUp',invoiceit_s__Category__c ='Opportunity',invoiceit_s__Quick_Screen_Id__c ='5',invoiceit_s__Sequence__c = 5);
        Invoiceit_s__Configuration__c c30 = new Invoiceit_s__Configuration__c(Name = 'OPPLINE_STATUS_FOR_ORDER_CONVERSION', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define the status of the Opportunity line items that determines whether they should be selected for auto-conversion into an Order', invoiceit_s__String_Value__c ='Active',invoiceit_s__Picklist_Indicator__c ='listOpportunityCharges1',invoiceit_s__Category__c ='Opportunity',invoiceit_s__Quick_Screen_Id__c ='5',invoiceit_s__Sequence__c = 2);
        Invoiceit_s__Configuration__c c31 = new Invoiceit_s__Configuration__c(Name = 'OPPLINE_STATUS_AFTER_ORDER_CONVERSION', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'What should be the status of opportunity lines after they are automatically converted to order lines', invoiceit_s__String_Value__c ='Converted',invoiceit_s__Picklist_Indicator__c ='listOpportunityCharges',invoiceit_s__Category__c ='Opportunity',invoiceit_s__Quick_Screen_Id__c ='5',invoiceit_s__Sequence__c = 1);  
        Invoiceit_s__Configuration__c c32 = new Invoiceit_s__Configuration__c(Name = 'QUOTE_LEGAL_ENTITY_FIELD_NAME', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'The field on the Quote object where the legal entity information is stored. This will override the Account legal entity setting',invoiceit_s__Picklist_Indicator__c ='listQuoteFields',invoiceit_s__Category__c ='Quote',invoiceit_s__Sequence__c = 4);
        Invoiceit_s__Configuration__c c33 = new Invoiceit_s__Configuration__c(Name = 'ORDER_LEGAL_ENTITY_FIELD_NAME', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'The field on the Order object where the legal entity information is stored. This will override the Account legal entity setting',invoiceit_s__Picklist_Indicator__c ='listOrderFields',invoiceit_s__Category__c ='Order',invoiceit_s__Sequence__c = 2);
        Invoiceit_s__Configuration__c c34 = new Invoiceit_s__Configuration__c(Name = 'ACCOUNT_LEGAL_ENTITY_FIELD_NAME', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'The field on the Account object where the legal entity information is stored',invoiceit_s__Picklist_Indicator__c ='listAccountFields',invoiceit_s__Category__c ='General',invoiceit_s__Sequence__c = 11);
        Invoiceit_s__Configuration__c c35 = new Invoiceit_s__Configuration__c(Name = 'SAVE_CREDIT_CARD_ON_PAYMENT_PAGE', invoiceit_s__Field_Type__c = 'Boolean', invoiceit_s__Description__c = 'Define whether customers are prompted to save their Credit Card information on the payment page',invoiceit_s__Category__c ='Invoice',invoiceit_s__Sequence__c = 3);
        Invoiceit_s__Configuration__c C36 = new Invoiceit_s__Configuration__c(Name = 'INVOICE_RUN_BATCH_SIZE', invoiceit_s__Field_Type__c = 'Number', invoiceit_s__Description__c = 'How many records should be processed in each batch during an invoice scheduler run', invoiceit_s__NUMBER_VALUE__C = 10,invoiceit_s__Category__c ='Invoice',invoiceit_s__Sequence__c = 4);
        Invoiceit_s__Configuration__c c37 = new Invoiceit_s__Configuration__c(Name = 'BILL_ONETIME_CHARGES_BASED_ON_DATES', invoiceit_s__Field_Type__c = 'Boolean', invoiceit_s__Description__c = 'Define whether one-time charges are only billed on or after the service start date. This means that one-time charges will not be billed prior to the service start date', invoiceit_s__Boolean_Value__c = false,invoiceit_s__Category__c ='Invoice',invoiceit_s__Sequence__c = 5);
        Invoiceit_s__Configuration__c c38 = new Invoiceit_s__Configuration__c(Name = 'CLONEED_OPPORTUNITY_STAGE', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define the default opportunity stage when an Opportunity is cloned',invoiceit_s__Picklist_Indicator__c ='listOpportunityStage',invoiceit_s__Category__c ='Opportunity',invoiceit_s__Quick_Screen_Id__c ='5',invoiceit_s__Sequence__c = 6);
        Invoiceit_s__Configuration__c c39 = new Invoiceit_s__Configuration__c(Name = 'INVOICE_TO_BE_CHARGED_ON', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define whether the Payment Scheduler should pickup unpaid invoices on or after the invoice date or on or after the invoice due date', invoiceit_s__String_Value__c = 'Due Date',invoiceit_s__Picklist_Indicator__c ='listPaymentSchedulerDates',invoiceit_s__Category__c ='Invoice',invoiceit_s__Quick_Screen_Id__c ='4',invoiceit_s__Sequence__c = 11);
        Invoiceit_s__Configuration__c c40 = new Invoiceit_s__Configuration__c(Name = 'DEFAULT_PAYMENT_TERMS_TO_BE_USED_FROM', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define whether the global payment terms should be overridden by the payment terms on Account or at the Order level', invoiceit_s__String_Value__c = 'ACCOUNT',invoiceit_s__Picklist_Indicator__c ='listPaymentTerms',invoiceit_s__Category__c ='General',invoiceit_s__Quick_Screen_Id__c ='3',invoiceit_s__Sequence__c = 8);
        Invoiceit_s__Configuration__c c42 = new Invoiceit_s__Configuration__c(Name = 'AUTOMATIC_ALLOCATEDTOFUTURE_INVOICES', invoiceit_s__Field_Type__c = 'Boolean', invoiceit_s__Description__c = 'Allow over payments to be automatically allocated to new invoices', invoiceit_s__Boolean_Value__c = false,invoiceit_s__Category__c ='Invoice',invoiceit_s__Quick_Screen_Id__c ='4',invoiceit_s__Sequence__c = 12);
        Invoiceit_s__Configuration__c c43 = new Invoiceit_s__Configuration__c(Name = 'MANUAL_INVOICE_GENERATION_STATUS', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define the default invoice status when an invoice is generated manually', invoiceit_s__String_Value__c = 'Draft',invoiceit_s__Picklist_Indicator__c ='listInvoiceStatus',invoiceit_s__Category__c ='Invoice',invoiceit_s__Quick_Screen_Id__c ='4',invoiceit_s__Sequence__c = 13);
        Invoiceit_s__Configuration__c c44 = new Invoiceit_s__Configuration__c(Name = 'NAVIGATION_FOR_PRODUCTRATEPLAN', invoiceit_s__Field_Type__c = 'Number', invoiceit_s__Description__c = 'Define the default number of Rate Plans that should be displayed on the Invoice IT Product page', invoiceit_s__NUMBER_VALUE__C = 40,invoiceit_s__Category__c ='General',invoiceit_s__Sequence__c = 12);
        Invoiceit_s__Configuration__c c45 = new Invoiceit_s__Configuration__c(Name = 'NAVIGATION_FOR_PRODUCTCHARGE', invoiceit_s__Field_Type__c = 'Number', invoiceit_s__Description__c = 'Define the default number of Rate Plan Charges that should be displayed on the Invoice IT Product page', invoiceit_s__NUMBER_VALUE__C = 40,invoiceit_s__Category__c ='General',invoiceit_s__Sequence__c = 13);
        Invoiceit_s__Configuration__c c46 = new Invoiceit_s__Configuration__c(Name = 'CHARGENAME_TEXTBOX_WIDTH', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Enter the width for the Charge Name text box while creating order and quote and opportunity Products ex :- width:200px', invoiceit_s__String_Value__c = 'width:150px',invoiceit_s__Picklist_Indicator__c ='listChargeNameWidth',invoiceit_s__Category__c ='General',invoiceit_s__Sequence__c = 14);
        Invoiceit_s__Configuration__c c47 = new Invoiceit_s__Configuration__c(Name = 'PRODUCTNAME_TEXTBOX_WIDTH', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Enter the width for the Product Name text box while creating order and quote and opportunity Products ex :- width:200px', invoiceit_s__String_Value__c = 'width:150px',invoiceit_s__Picklist_Indicator__c ='listProductNameWidth',invoiceit_s__Category__c ='General',invoiceit_s__Sequence__c = 15);
        Invoiceit_s__Configuration__c c48 = new Invoiceit_s__Configuration__c(Name = 'INVOICEIT_HOME_POPUP' ,invoiceit_s__Boolean_Value__c = false, invoiceit_s__Field_Type__c = 'Boolean', invoiceit_s__Description__c = 'This is for Invoice IT home Pop up');
        Invoiceit_s__Configuration__c c49 = new Invoiceit_s__Configuration__c(Name = 'DISPLAY_PRODUCT_CHARGE_POP_UP' ,invoiceit_s__Boolean_Value__c = false, invoiceit_s__Field_Type__c = 'Boolean', invoiceit_s__Description__c = 'Enhanced advance Product Charge selection in the wizards',invoiceit_s__Category__c ='General',invoiceit_s__Quick_Screen_Id__c ='3',invoiceit_s__Sequence__c = 16);
        Invoiceit_s__Configuration__c c50 = new Invoiceit_s__Configuration__c(Name = 'DISPLAY_PRODUCT_RELATED_LIST' ,invoiceit_s__Boolean_Value__c = false, invoiceit_s__Field_Type__c = 'Boolean', invoiceit_s__Description__c = 'This is for displaying product realted list(New Product Page)');
        Invoiceit_s__Configuration__c c51 = new Invoiceit_s__Configuration__c(Name = 'DISPLAY_PRODUCT_BUNDLES_SEARCH' ,invoiceit_s__Boolean_Value__c = false, invoiceit_s__Field_Type__c = 'Boolean', invoiceit_s__Description__c = 'Define the product bundle search on step wizard pages',invoiceit_s__Category__c ='General',invoiceit_s__Quick_Screen_Id__c ='3');
        Invoiceit_s__Configuration__c c52 = new Invoiceit_s__Configuration__c(Name = 'PRODUCTBUNDLE_SEARCHFIELDS' ,invoiceit_s__String_Value__c = 'Name', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define the Product Bundle fields that can be searched for in the instant product bundle search',invoiceit_s__Picklist_Indicator__c ='listProductBundleFields',invoiceit_s__Category__c ='General',invoiceit_s__Sequence__c = 21);
        Invoiceit_s__Configuration__c c53 = new Invoiceit_s__Configuration__c(Name = 'PRODUCTBUNDLE_ORDERFIELD', invoiceit_s__String_Value__c = 'Name', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define the order in which the Product Bundle fields are displayed in the instant product bundle search results',invoiceit_s__Picklist_Indicator__c ='listProductBundleFields2',invoiceit_s__Category__c ='General',invoiceit_s__Sequence__c = 22);
        Invoiceit_s__Configuration__c c54 = new Invoiceit_s__Configuration__c(Name = 'PRODUCTBUNDLE_DISPLAYFIELDS', invoiceit_s__String_Value__c = '', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define the Product Bundle fields that are displayed in the instant product bundle search results',invoiceit_s__Picklist_Indicator__c ='listProductBundleFields1',invoiceit_s__Category__c ='General',invoiceit_s__Sequence__c = 20);
        Invoiceit_s__Configuration__c c55 = new Invoiceit_s__Configuration__c(Name = 'ENABLE_STATE_AND_COUNTRY_PICKLIST' ,invoiceit_s__Boolean_Value__c = false, invoiceit_s__Field_Type__c = 'Boolean', invoiceit_s__Description__c = 'Define the state and country picklist in Site Page and Virtual Terminal',invoiceit_s__Category__c ='General',invoiceit_s__Quick_Screen_Id__c ='3');
        Invoiceit_s__Configuration__c c56 = new Invoiceit_s__Configuration__c(Name = 'NO_OF_DAYS_FOR_AUTO_RENEWAL' ,invoiceit_s__Field_Type__c = 'Number', invoiceit_s__Description__c = 'Number of days before Order Expires',invoiceit_s__Category__c ='Order',invoiceit_s__Sequence__c = 8, invoiceit_s__NUMBER_VALUE__C = 30);
        Invoiceit_s__Configuration__c c57 = new Invoiceit_s__Configuration__c(Name = 'INVOICEIT_BATCH_JOBS_TO_PROCESS', invoiceit_s__String_Value__c = '', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define the batches for processing',invoiceit_s__Picklist_Indicator__c ='listBatchJobs',invoiceit_s__Category__c ='General',invoiceit_s__Sequence__c = 23);


        Invoiceit_s__Configuration__c c58 = new Invoiceit_s__Configuration__c(Name = 'EXCHANGERATE_ACCESSTOKEN', invoiceit_s__Field_Type__c = 'String',invoiceit_s__String_Value__c = 'kicbus');
        Invoiceit_s__Configuration__c c59 = new Invoiceit_s__Configuration__c(Name = 'ADVANCED_BILLING_RULE', invoiceit_s__Field_Type__c = 'String',invoiceit_s__String_Value__c = 'BILLINGCONTACT_ACCOUNT' );
        Invoiceit_s__Configuration__c c60 = new Invoiceit_s__Configuration__c(Name = 'EXCHANGERATE_ENDPOINTURL', invoiceit_s__Field_Type__c = 'String',invoiceit_s__String_Value__c = 'https://test-xlr-currencies.eu.cloudhub.io/api/exchangerate/xlr/');
        Invoiceit_s__Configuration__c c67 =  new Invoiceit_s__Configuration__c(Name = 'ADVANCE_USAGE_BILLLING', invoiceit_s__Description__c = 'Enable Advance Usage Billing ?', invoiceit_s__Field_Type__c = 'Boolean', invoiceit_s__Boolean_Value__c = false, invoiceit_s__Category__c ='Order',invoiceit_s__Quick_Screen_Id__c ='4',invoiceit_s__Sequence__c = 10);
        Invoiceit_s__Configuration__c c68 =  new Invoiceit_s__Configuration__c(Name = 'ALIGN_DATES_OF_Quote_TO_PRODUCTS', invoiceit_s__Description__c = 'copy prod to order', invoiceit_s__Field_Type__c = 'Boolean', invoiceit_s__Boolean_Value__c = false, invoiceit_s__Category__c ='Order',invoiceit_s__Quick_Screen_Id__c ='4',invoiceit_s__Sequence__c = 20);
        objects.add((Invoiceit_s__Configuration__c) c68);     
        objects.add((Invoiceit_s__Configuration__c) c67);  
        objects.add((Invoiceit_s__Configuration__c) c58);
        objects.add((Invoiceit_s__Configuration__c) c59);
        objects.add((Invoiceit_s__Configuration__c) c60);
        objects.add((Invoiceit_s__Configuration__c) c1);
        objects.add((Invoiceit_s__Configuration__c) c2);
        objects.add((Invoiceit_s__Configuration__c) c3);
        objects.add((Invoiceit_s__Configuration__c) c4);
        objects.add((Invoiceit_s__Configuration__c) c5);
        objects.add((Invoiceit_s__Configuration__c) c6);
        objects.add((Invoiceit_s__Configuration__c) c7);
        objects.add((Invoiceit_s__Configuration__c) c8);
        objects.add((Invoiceit_s__Configuration__c) c9);
        objects.add((Invoiceit_s__Configuration__c) c10);
        objects.add((Invoiceit_s__Configuration__c) c11);
        objects.add((Invoiceit_s__Configuration__c) c12);
        objects.add((Invoiceit_s__Configuration__c) c13);
        objects.add((Invoiceit_s__Configuration__c) c14);
        objects.add((Invoiceit_s__Configuration__c) c15);
        objects.add((Invoiceit_s__Configuration__c) c16);
        objects.add((Invoiceit_s__Configuration__c) c17);
        objects.add((Invoiceit_s__Configuration__c) c18);
        objects.add((Invoiceit_s__Configuration__c) c19);
        objects.add((Invoiceit_s__Configuration__c) c20);
        objects.add((Invoiceit_s__Configuration__c) c21);
        objects.add((Invoiceit_s__Configuration__c) c22);
        objects.add((Invoiceit_s__Configuration__c) c23);
        objects.add((Invoiceit_s__Configuration__c) c24);
        objects.add((Invoiceit_s__Configuration__c) c25);
        objects.add((Invoiceit_s__Configuration__c) c26);
        objects.add((Invoiceit_s__Configuration__c) c27);
        objects.add((Invoiceit_s__Configuration__c) c28);
        objects.add((Invoiceit_s__Configuration__c) c29);
        objects.add((Invoiceit_s__Configuration__c) c30);
        objects.add((Invoiceit_s__Configuration__c) c31);
        objects.add((Invoiceit_s__Configuration__c) c32);
        objects.add((Invoiceit_s__Configuration__c) c33);
        objects.add((Invoiceit_s__Configuration__c) c34);
        objects.add((Invoiceit_s__Configuration__c) c35);
        objects.add((Invoiceit_s__Configuration__c) c36);
        objects.add((Invoiceit_s__Configuration__c) c37);
        objects.add((Invoiceit_s__Configuration__c) c38);
        objects.add((Invoiceit_s__Configuration__c) c39);
        objects.add((Invoiceit_s__Configuration__c) c40);
        objects.add((Invoiceit_s__Configuration__c) c42);
        objects.add((Invoiceit_s__Configuration__c) c43);
        objects.add((Invoiceit_s__Configuration__c) c44);
        objects.add((Invoiceit_s__Configuration__c) c45);
        objects.add((Invoiceit_s__Configuration__c) c46);
        objects.add((Invoiceit_s__Configuration__c) c47);
        objects.add((Invoiceit_s__Configuration__c) c48);
        objects.add((Invoiceit_s__Configuration__c) c49);
        objects.add((Invoiceit_s__Configuration__c) c50);
        objects.add((Invoiceit_s__Configuration__c) c51);
        objects.add((Invoiceit_s__Configuration__c) c52);
        objects.add((Invoiceit_s__Configuration__c) c53);
        objects.add((Invoiceit_s__Configuration__c) c54);
        objects.add((Invoiceit_s__Configuration__c) c55);
        objects.add((Invoiceit_s__Configuration__c) c56);
        objects.add((Invoiceit_s__Configuration__c) c57);
        Invoiceit_s__Configuration__c invoiceEmailTemplate = new Invoiceit_s__Configuration__c(Name = 'INVOICE_EMAIL_TEMPLATE', invoiceit_s__String_Value__c = 'Enter Template Id', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'The Salesforce Id of the Invoice Email template that is used when sending an Invoice via email',invoiceit_s__Picklist_Indicator__c ='listInvoiceTemplate',invoiceit_s__Category__c ='Invoice',invoiceit_s__Sequence__c = 5);
        Invoiceit_s__Configuration__c quoteEmailTemplate = new Invoiceit_s__Configuration__c(Name = 'QUOTE_EMAIL_TEMPLATE', invoiceit_s__String_Value__c = 'Enter Template Id', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'The Salesforce Id of the Quote Email template that is used when sending a Quote via email',invoiceit_s__Picklist_Indicator__c ='listQuoteEmailTemplate',invoiceit_s__Category__c ='Quote',invoiceit_s__Sequence__c = 5);
        objects.add(quoteEmailTemplate);
        objects.add(invoiceEmailTemplate);

        Invoiceit_s__Configuration__c companyLogo = new Invoiceit_s__Configuration__c(Name = 'COMPANY_LOGO' ,invoiceit_s__String_Value__c = 'https://c.na12.content.force.com/servlet/servlet.ImageServer?id=015U00000000fGG&oid=00DU0000000HSiW', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Default image for Visualforce Quote and Invoice templates',invoiceit_s__Picklist_Indicator__c ='listCompanyLogo',invoiceit_s__Category__c ='Quote',invoiceit_s__Sequence__c = 6);                                                                 
        objects.add(companyLogo);
        objects.add(new Invoiceit_s__Configuration__c(Name = 'PRODUCT_SEARCHFIELDS' ,invoiceit_s__String_Value__c = 'Name,invoiceit_s__Product_Code__c', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define the Invoice IT Product fields that can be searched for in the instant product search',invoiceit_s__Picklist_Indicator__c ='listProductFields',invoiceit_s__Category__c ='General',invoiceit_s__Quick_Screen_Id__c ='3',invoiceit_s__Sequence__c = 9));
        objects.add(new Invoiceit_s__Configuration__c(Name = 'SUPPORT_PAGE_URL' ,invoiceit_s__String_Value__c = 'http://www.weinvoiceit.com/support/'));
        objects.add(new Invoiceit_s__Configuration__c(Name = 'ORDER_STATUS_VALUES_TO_ROLLUP', invoiceit_s__String_Value__c = 'In Progress,Ready to be Invoiced,Invoiced', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define the Order status values for which the total values are rolled up to the account/opportunity',invoiceit_s__Picklist_Indicator__c ='listOrderStatusfields1',invoiceit_s__Category__c ='Order',invoiceit_s__Quick_Screen_Id__c ='4',invoiceit_s__Sequence__c = 7));
        objects.add(new Invoiceit_s__Configuration__c(Name = 'QUOTE_STATUS_VALUES_TO_ROLLUP', invoiceit_s__String_Value__c = 'Active,Converted', invoiceit_s__Field_Type__c = 'String', invoiceit_s__Description__c = 'Define the Quote status values for which the total values are rolled up to the account/opportunity',invoiceit_s__Picklist_Indicator__c ='listQuoteStatusfields1',invoiceit_s__Category__c ='Quote',invoiceit_s__Quick_Screen_Id__c ='4',invoiceit_s__Sequence__c = 1));
        objects.add(new Invoiceit_s__Configuration__c(Name = 'UPDATE_AMOUNT_FIELD_IN_OPPORTUNITY', invoiceit_s__Field_Type__c = 'Boolean', invoiceit_s__Description__c = 'Define whether the Amount field on opportunities should be updated with the total quote value',invoiceit_s__Category__c ='Opportunity',invoiceit_s__Quick_Screen_Id__c ='5',invoiceit_s__Sequence__c = 3));
        
        objects.add(new Invoiceit_s__Configuration__c(Name = 'DISPLAY_DISCOUNT', Invoiceit_s__Boolean_Value__c = true, Invoiceit_s__Field_Type__c = 'Boolean', Invoiceit_s__Description__c = 'Show Discount in Quote/Order/Opportunity Wizard', Invoiceit_s__Category__c ='General',Invoiceit_s__Sequence__c = 6));
        objects.add(new Invoiceit_s__Configuration__c(Name = 'DISPLAY_TAX', Invoiceit_s__Boolean_Value__c = true, Invoiceit_s__Field_Type__c = 'Boolean', Invoiceit_s__Description__c = 'Show TAX in Quote/Order/Opportunity Wizard', Invoiceit_s__Category__c ='General',Invoiceit_s__Sequence__c = 4));
        objects.add(new Invoiceit_s__Configuration__c(Name = 'DISPLAY_VAT', Invoiceit_s__Boolean_Value__c = true, Invoiceit_s__Field_Type__c = 'Boolean', Invoiceit_s__Description__c = 'Show VAT in Quote/Order/Opportunity Wizard', Invoiceit_s__Category__c ='General',Invoiceit_s__Sequence__c = 5));
        
        insert objects;
    }

    @isTest static void test_method_three() {

        // insert the custom settings
        insertCustomSettings();

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
        insert job;

        invoiceit_s__Job_Product__c  jobProduct= new invoiceit_s__Job_Product__c(invoiceit_s__Product__c = invoiceItProduct.Id, Name = 'jobProduct',invoiceit_s__Job__c = job.Id);
        insert jobProduct;

        invoiceit_s__Job_Rate_Plan__c jobRP = new invoiceit_s__Job_Rate_Plan__c(invoiceit_s__Product_Rate_Plan__c = ratePlan.Id, Name = 'JobRP',invoiceit_s__Job_Product__c =jobProduct.Id);
        insert jobRP;

        invoiceit_s__Job_Rate_Plan_Charge__c charge = new invoiceit_s__Job_Rate_Plan_Charge__c(invoiceit_s__Product_Rate_Plan_Charge__c = productCharge.Id);
        charge.Name = 'jobRPC';
        charge.invoiceit_s__Order__c = job.Id;
        charge.invoiceit_s__Job_Rate_Plan__c =jobRP.Id;
        charge.invoiceit_s__Status__c = 'Ready to be Invoiced';
        charge.invoiceit_s__Quantity__c = 12;
        charge.invoiceit_s__Price_Type__c = 'One Time';
        charge.invoiceit_s__Accounting_Code__c = '12345';
        charge.invoiceit_s__Charge_Date__c = system.today();
        charge.invoiceit_s__Unit_Price__c = 12;
        insert charge;
        test.StartTest();
        job.IITIntended_Use__c = 'LOCAL EU WATERS';
        upsert job;

        set<Id> orderIds = new set<Id>();
        orderIds.add(job.Id);
        IITBatchProcessForRecalculateOrder batch = new IITBatchProcessForRecalculateOrder(orderIds);
        database.executebatch(batch);
        test.StopTest();
    }
}