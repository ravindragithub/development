public with sharing class IITClassRunUnpaidInvoices {
    
    public invoiceit_s__Invoice__c invoice {get;set;}
    public string legalEntity {get;set;}
    public string name {get;set;}
    string constructedLegalEntity;
    
    public IITClassRunUnpaidInvoices() {
        invoice = new invoiceit_s__Invoice__c();     
    }
    
    public void runUnpaidInvoices() {
        try {
            if(legalEntity == 'VMI') {
                constructedLegalEntity = ' Legal_Entity__c = \'' + 'VMI' + '\'';
            }

            if(legalEntity == 'VMA') {
                constructedLegalEntity = ' Legal_Entity__c = \'' + 'VMA' + '\'';
            }

            if(legalEntity == 'Both') {
                constructedLegalEntity = ' Legal_Entity__c != null';
            }


            // true indicates use the query which is present in the batch
            IITBatchARUnpaidInvoices batchJobinvoices = new IITBatchARUnpaidInvoices(invoice.invoiceit_s__Invoice_Date__c, null, true, constructedLegalEntity);
            Database.executeBatch(batchJobinvoices);   

            // true indicates use the query which is present in the batch
            IITBatchARUnAllocatedPayments batchJobPayments = new IITBatchARUnAllocatedPayments(invoice.invoiceit_s__Invoice_Date__c, null, true, constructedLegalEntity);
            Database.executeBatch(batchJobPayments);  
                   
            Apexpages.Message errorMessage = new Apexpages.Message(ApexPages.Severity.Info, 'Batch Process have been initiated.');
            Apexpages.addMessage(errorMessage);
        } catch(Exception ex) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'An Exception has occured : ' + ex.getMessage()));
        }
    }

    public void runRealTimeData() {
        try {
            if(legalEntity == 'VMI') {
                constructedLegalEntity = ' Legal_Entity__c = \'' + 'VMI' + '\'';
            }

            if(legalEntity == 'VMA') {
                constructedLegalEntity = ' Legal_Entity__c = \'' + 'VMA' + '\'';
            }

            if(legalEntity == 'Both') {
                constructedLegalEntity = ' Legal_Entity__c != null';
            }

            DateTime dtm = DateTime.now();
            String formattedDt = dtm.format('yyyy-MM-dd');
            DateTime startDate = Datetime.newInstance(system.today().year(), system.today().month(), 01);
            String formattedStartDt = startDate.format('yyyy-MM-dd');
            DateTime endDate = startDate.addDays(Date.daysInMonth(startDate.year(), startDate.month()) - 1);
            String formattedEndDt = endDate.format('yyyy-MM-dd');

            string invoiceQuery = 'SELECT (SELECT invoiceit_s__Deferred_Balance__c FROM invoiceit_s__Revenue_Transaction_Invoice__r WHERE invoiceit_s__Revenue_Period_Start_Date__c >= ' + formattedStartDt +' AND invoiceit_s__Revenue_Period_End_Date__c <= ' + formattedEndDt + ' ), invoiceit_s__Invoice_Date__c, invoiceit_s__Account__c, invoiceit_s__Paid_Amount__c,invoiceit_s__Total_Invoice_Value__c,invoiceit_s__Unpaid_Amount__c,Unpaid_Amount_0_30_Days__c,Unpaid_Amount_31_60_Days__c,Unpaid_Amount_61_90_Days__c,Unpaid_Amount_91_120_Days__c,Unpaid_Amount_121_180_Days__c,Unpaid_Amount_180_Days__c FROM invoiceit_s__Invoice__c WHERE invoiceit_s__Invoice_Status__c = \'' + 'Posted' + '\' AND invoiceit_s__Unpaid_Amount__c != 0 AND invoiceit_s__Invoice_Date__c <= ' + formattedDt + ' AND ' + constructedLegalEntity;  
            string paymentQuery = 'SELECT invoiceit_s__Account__c, invoiceit_s__Allocated_Amount__c, invoiceit_s__Amount__c,invoiceit_s__Payment_Date__c,invoiceit_s__Status__c, invoiceit_s__Unallocated_Amount__c, UnAllocated_Amount_180_Days__c, UnAllocated_Amount_0_30_Days__c, UnAllocated_Amount_121_180_Days__c, UnAllocated_Amount_31_60_Days__c, UnAllocated_Amount_61_90_Days__c, UnAllocated_Amount_91_120_Days__c FROM invoiceit_s__Payment__c WHERE invoiceit_s__Status__c = \'' + 'Completed' + '\' AND invoiceit_s__Unallocated_Amount__c != 0 AND invoiceit_s__Payment_Date__c <= ' + formattedDt + ' AND ' + constructedLegalEntity;  
            
            system.debug('invoiceQuery is ' + invoiceQuery);
            system.debug('paymentQuery is ' + paymentQuery);

            // false indicates use the query which is passed to the batch
            IITBatchARUnpaidInvoices batchJobinvoices = new IITBatchARUnpaidInvoices(system.today(), invoiceQuery, false, constructedLegalEntity);
            Database.executeBatch(batchJobinvoices);   

            // false indicates use the query which is passed to the batch
            IITBatchARUnAllocatedPayments batchJobPayments = new IITBatchARUnAllocatedPayments(system.today(), paymentQuery, false, constructedLegalEntity);
            Database.executeBatch(batchJobPayments);  
                   
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, 'Batch Process has been initiated.'));
        } catch(Exception ex) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'An Exception has occured : ' + ex.getMessage()));
        }
    }

    public void deleteARRecords() {
        try {
            if(name == null || name == '') {
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, 'Name cannot be blank'));
                return;
            }

            if(legalEntity == 'VMI') {
                constructedLegalEntity = ' Legal_Entity__c = \'' + 'VMI' + '\' LIMIT 10000 ';
            }

            if(legalEntity == 'VMA') {
                constructedLegalEntity = ' Legal_Entity__c = \'' + 'VMA' + '\' LIMIT 10000';
            }

            if(legalEntity == 'Both') {
                constructedLegalEntity = ' Legal_Entity__c != null LIMIT 10000';
            }

            string sQuery = 'SELECT Id FROM AR_Snapshot__c WHERE Name = \'' + name + '\' AND ' + constructedLegalEntity;
            System.debug('sQuery is : ' + sQuery);

            delete database.query(sQuery);
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, 'Deleted Successfully'));
        } catch(Exception ex) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'An Exception has occured : ' + ex.getMessage()));
        }
    }

    public void count() {
        if(name == null || name == '') {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, 'Name cannot be blank'));
            return;
        }

        if(legalEntity == 'VMI') {
            constructedLegalEntity = ' Legal_Entity__c = \'' + 'VMI' + '\' GROUP BY Name LIMIT 50000 ';
        }

        if(legalEntity == 'VMA') {
            constructedLegalEntity = ' Legal_Entity__c = \'' + 'VMA' + '\' GROUP BY Name LIMIT 50000';
        }

        if(legalEntity == 'Both') {
            constructedLegalEntity = ' Legal_Entity__c != null GROUP BY Name LIMIT 50000';
        }

        string sQuery = 'SELECT Count(Id) result FROM AR_Snapshot__c WHERE Name = \'' + name + '\' AND ' + constructedLegalEntity;
        System.debug('sQuery is : ' + sQuery);
        list<AggregateResult> aggResults = Database.query(sQuery); 

        if(aggResults.size() == 0) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, 'No Records Fetched'));
            return;
        }

        System.debug('No of ids are: ' + aggResults[0].get('result'));
        
        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, 'Count is : ' + aggResults[0].get('result')));
    }
}