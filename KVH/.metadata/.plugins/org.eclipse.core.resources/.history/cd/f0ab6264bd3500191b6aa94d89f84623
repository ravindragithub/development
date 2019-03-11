@isTest
public class IITTestClassForAR {

    public static Account createAccount() {
        Id kvaccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('KV Platform').getRecordTypeId();

        // don't change the billing country field as VAT will be calculated based on this
        Account acc = new Account(Name = 'Test Account', BillingCountry = 'United Kingdom', recordtypeID = kvaccountRecordTypeId);
        insert acc;
        
        return  acc;   
    }

    public static invoiceit_s__Currency__c createCurrency() {
        invoiceit_s__Currency__c currency1 = new invoiceit_s__Currency__c(Name = 'EUR', invoiceit_s__Symbol__c = '£');
        insert currency1;       
        
        return  currency1;   
    }

    public static invoiceit_s__Job__c createOrder(Account acc, invoiceit_s__Currency__c currency1) {
        // this will cover the IITClassAfterOnOrderRatePlanCharges
        invoiceit_s__Job__c job = new invoiceit_s__Job__c(invoiceit_s__Account__c = acc.id, invoiceit_s__Sub_Total__c = 100, invoiceit_s__Discount_Value__c = 0, invoiceit_s__CurrencyL__c = currency1.Id);
        job.invoiceit_s__Account__c = acc.Id;
        job.Shipping_Account__c = acc.Id;
        job.IITIntended_Use__c = 'LOCAL UK WATERS';
        job.Withholding_Tax_Percentage__c = 10;
        insert job;     
        
        return  job;   
    }

    public static invoiceit_s__Invoice__c createInvoice(Account acc, invoiceit_s__Job__c job, invoiceit_s__Currency__c currency1) {
        invoiceit_s__Invoice__c invoice = new invoiceit_s__Invoice__c(invoiceit_s__Account__c = acc.id,
                invoiceit_s__CurrencyL__c = currency1.Id, invoiceit_s__Target_Date__c = Date.today(), invoiceit_s__Delivery_Type__c = 'Both', invoiceit_s__Invoice_Status__c = 'Posted'
                    ,invoiceit_s__Invoice_Date__c = System.today(), Legal_Entity__c = 'VMA'
        );
        insert invoice;    
        
        return  invoice;   
    }

    public static list<invoiceit_s__Invoice_Lines__c> createInvoiceLines(Account acc, invoiceit_s__Job__c job, invoiceit_s__Currency__c currency1, invoiceit_s__Invoice__c invoice) {
        list<invoiceit_s__Invoice_Lines__c> listInvoiceLines = new list<invoiceit_s__Invoice_Lines__c>();
        listInvoiceLines.add(new invoiceit_s__Invoice_Lines__c(invoiceit_s__Invoice__c = invoice.id, invoiceit_s__Line_Name__c = 'Broadband Installation For L',invoiceit_s__Quantity__c = 1,invoiceit_s__Unit_Price__c = 40.00,invoiceit_s__VAT__c = 8.00,invoiceit_s__Line_Amount__c = 40.00,invoiceit_s__Job__c = job.Id));
        listInvoiceLines.add(new invoiceit_s__Invoice_Lines__c(invoiceit_s__Invoice__c = invoice.id, invoiceit_s__Line_Name__c = 'Broadband Installation For X',invoiceit_s__Quantity__c = 1,invoiceit_s__Unit_Price__c = 40.00,invoiceit_s__VAT__c = 8.00,invoiceit_s__Line_Amount__c = 40.00,invoiceit_s__Job__c = job.Id));
        listInvoiceLines.add(new invoiceit_s__Invoice_Lines__c(invoiceit_s__Invoice__c = invoice.id, invoiceit_s__Line_Name__c = 'Broadband Installation For M',invoiceit_s__Quantity__c = 1,invoiceit_s__Unit_Price__c = 40.00,invoiceit_s__VAT__c = 8.00,invoiceit_s__Line_Amount__c = 40.00,invoiceit_s__Job__c = job.Id));
        listInvoiceLines.add(new invoiceit_s__Invoice_Lines__c(invoiceit_s__Invoice__c = invoice.id, invoiceit_s__Line_Name__c = 'Broadband Installation For L',invoiceit_s__Quantity__c = 1,invoiceit_s__Unit_Price__c = 40.00,invoiceit_s__VAT__c = 8.00,invoiceit_s__Line_Amount__c = 40.00,invoiceit_s__Job__c = job.Id));
        listInvoiceLines.add(new invoiceit_s__Invoice_Lines__c(invoiceit_s__Invoice__c = invoice.id, invoiceit_s__Line_Name__c = 'Broadband Installation For X',invoiceit_s__Quantity__c = 1,invoiceit_s__Unit_Price__c = 40.00,invoiceit_s__VAT__c = 8.00,invoiceit_s__Line_Amount__c = 40.00,invoiceit_s__Job__c = job.Id));
        insert listInvoiceLines;    
        return  listInvoiceLines;   
    }

    public static invoiceit_s__Payment__c createPayment(Account acc, invoiceit_s__Currency__c currency1) {
        invoiceit_s__Payment__c payment = new invoiceit_s__Payment__c(Legal_Entity__c = 'VMA', invoiceit_s__Status__c = 'Completed', invoiceit_s__Account__c =acc.id,invoiceit_s__Amount__c = 10000, invoiceit_s__Currency__c = currency1.Id, invoiceit_s__Payment_Type__c = 'Cash', invoiceit_s__Payment_Date__c = system.today());
        insert payment;
        return payment;
    }

    @isTest static void customerStatements() {
        IITTestClassForPhase1.insertCustomSettings();

        Account acc = IITTestClassForAR.createAccount();

        invoiceit_s__Currency__c currency1 = IITTestClassForAR.createCurrency();

        invoiceit_s__Job__c job = IITTestClassForAR.createOrder(acc, currency1);
        
        invoiceit_s__Invoice__c invoice = IITTestClassForAR.createInvoice(acc, job, currency1);
        
        list<invoiceit_s__Invoice_Lines__c> listInvoiceLines = IITTestClassForAR.createInvoiceLines(acc, job, currency1, invoice);
        
        invoiceit_s__Payment__c payment = IITTestClassForAR.createPayment(acc, currency1);
        
        test.startTest();
            ApexPages.StandardController stdController = new ApexPages.StandardController(acc);
            IITCustomerStatements iITCustomerStatementsObj = new IITCustomerStatements(stdController);

            IITCustomerStatements.generateRealTimeStatement(acc.Id);
            IITCustomerStatements.generateHistoricStatement(acc.Id, 'Name');
        test.stopTest();
    }

    @isTest static void arRealTime() {
        IITTestClassForPhase1.insertCustomSettings();

        Account acc = IITTestClassForAR.createAccount();

        invoiceit_s__Currency__c currency1 = IITTestClassForAR.createCurrency();

        invoiceit_s__Job__c job = IITTestClassForAR.createOrder(acc, currency1);
        
        invoiceit_s__Invoice__c invoice = IITTestClassForAR.createInvoice(acc, job, currency1);
        
        list<invoiceit_s__Invoice_Lines__c> listInvoiceLines = IITTestClassForAR.createInvoiceLines(acc, job, currency1, invoice);
        
        invoiceit_s__Payment__c payment = IITTestClassForAR.createPayment(acc, currency1);
        
        test.startTest();
            IITClassRunUnpaidInvoices unPaidInvoices = new IITClassRunUnpaidInvoices();
            unPaidInvoices.invoice.invoiceit_s__Invoice_Date__c = system.today();
            unPaidInvoices.legalEntity = 'Both';
            unPaidInvoices.runUnpaidInvoices();
            unPaidInvoices.runRealTimeData();
            
            // this will cover the exception block
            unPaidInvoices = new IITClassRunUnpaidInvoices();
            unPaidInvoices.runUnpaidInvoices();

            // this will say name is missing
            unPaidInvoices.count();

            // this will say name is missing
            unPaidInvoices.deleteARRecords();

            // this will give the count of records for VMA & VMI
            unPaidInvoices.legalEntity = 'Both';
            unPaidInvoices.name = '222';
            unPaidInvoices.count();
            unPaidInvoices.deleteARRecords();

            // this will give the count of records for VMA
            unPaidInvoices.legalEntity = 'VMA';
            unPaidInvoices.name = '222';
            unPaidInvoices.count();
            unPaidInvoices.deleteARRecords();

            // this will give the count of records for VMI
            unPaidInvoices.legalEntity = 'VMI';
            unPaidInvoices.name = '222';
            unPaidInvoices.count();
            unPaidInvoices.deleteARRecords();

            list<invoiceit_s__Invoice__c> invoices = new list<invoiceit_s__Invoice__c>();
            invoices.add(invoice);
            IITARUtilClass.populateARUnpaidInvoices(invoices, 'aaa', system.today().addDays(25));
            IITARUtilClass.populateARUnpaidInvoices(invoices, 'aaa', system.today().addDays(50));
            IITARUtilClass.populateARUnpaidInvoices(invoices, 'aaa', system.today().addDays(75));
            IITARUtilClass.populateARUnpaidInvoices(invoices, 'aaa', system.today().addDays(100));
            IITARUtilClass.populateARUnpaidInvoices(invoices, 'aaa', system.today().addDays(118));
            IITARUtilClass.populateARUnpaidInvoices(invoices, 'aaa', system.today().addDays(125));
            IITARUtilClass.populateARUnpaidInvoices(invoices, 'aaa', system.today().addDays(190));

            list<invoiceit_s__Payment__c> payments = new list<invoiceit_s__Payment__c>();
            payments.add([SELECT invoiceit_s__Account__c, invoiceit_s__Amount__c, invoiceit_s__Allocated_Amount__c, invoiceit_s__Payment_Date__c, invoiceit_s__Unallocated_Amount__c FROM invoiceit_s__Payment__c WHERE Id =: payment.Id]);
            IITARUtilClass.populateARUnAllocatedPayments(payments, 'aaa', system.today().addDays(25));
            IITARUtilClass.populateARUnAllocatedPayments(payments, 'aaa', system.today().addDays(50));
            IITARUtilClass.populateARUnAllocatedPayments(payments, 'aaa', system.today().addDays(75));
            IITARUtilClass.populateARUnAllocatedPayments(payments, 'aaa', system.today().addDays(100));
            IITARUtilClass.populateARUnAllocatedPayments(payments, 'aaa', system.today().addDays(118));
            IITARUtilClass.populateARUnAllocatedPayments(payments, 'aaa', system.today().addDays(125));
            IITARUtilClass.populateARUnAllocatedPayments(payments, 'aaa', system.today().addDays(190));
        test.stopTest();
    }   
}