// this batch will export all the unpaid invoices present in the system based on the date and will stamp the values in AR Object
// Unpaid amount > 0
// Status should be posted
// Invoice date
global with sharing class IITBatchARUnpaidInvoices implements Database.Batchable<sObject>,Database.Stateful {
    global String query;
    global Date endDate;
    global Date startDate;
    global string errorLog = null;
    invoiceit_s__Batch_Jobs__c batchJob;
    string currentBatchDetails = '';
    global string legalEntity;
    string realTime = '';
    
    global IITBatchARUnpaidInvoices(Date endDate, String query, boolean useInternalQuery, string legalEntity) {
        //
        if(useInternalQuery == true || useInternalQuery == null) {
            system.debug('endDate==== ' + endDate);
            this.endDate = endDate;
            startDate = Date.newInstance(endDate.year(), endDate.month(), 1);
            this.query = 'SELECT (SELECT invoiceit_s__Deferred_Balance__c FROM invoiceit_s__Revenue_Transaction_Invoice__r WHERE invoiceit_s__Revenue_Period_Start_Date__c >=: startDate  AND invoiceit_s__Revenue_Period_End_Date__c <=: endDate), invoiceit_s__Invoice_Date__c, invoiceit_s__Account__c, invoiceit_s__Paid_Amount__c,invoiceit_s__Total_Invoice_Value__c,invoiceit_s__Unpaid_Amount__c,Unpaid_Amount_0_30_Days__c,Unpaid_Amount_31_60_Days__c,Unpaid_Amount_61_90_Days__c,Unpaid_Amount_91_120_Days__c,Unpaid_Amount_121_180_Days__c,Unpaid_Amount_180_Days__c FROM invoiceit_s__Invoice__c WHERE invoiceit_s__Invoice_Status__c = \'' + 'Posted' + '\' AND invoiceit_s__Unpaid_Amount__c != 0 AND invoiceit_s__Invoice_Date__c <=: endDate' + ' AND ' + legalEntity;  
            this.legalEntity = legalEntity;
        } else {
            this.query = query; 
            this.endDate = endDate;
            this.realTime = '-' + string.valueOf(system.today().day()) + '-RealTime';
        }  

        batchJob = new invoiceit_s__Batch_Jobs__c(Name = 'BatchARUnpaidInvoices - ' + system.today(), invoiceit_s__Type__c = 'BatchARUnpaidInvoices', invoiceit_s__Start_Date_and_Time__c = system.now(), invoiceit_s__Status__c = 'Processing');
        insert batchJob;  
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        system.debug('query==== ' + query);
        return Database.getQueryLocator(query);
    }
    
     global void execute(Database.BatchableContext BC, list<sObject> scope) {
        try {
            list<invoiceit_s__Invoice__c> unpaidInvoices = scope;
            list<AR_Snapshot__c> snapshotRecordsToInsert = new list<AR_Snapshot__c>();
            string s = string.valueOf(endDate.year()) + string.valueOf(endDate.month()) + realTime;
            
            currentBatchDetails = '\n' + '\n' + '\n';
            for(invoiceit_s__Invoice__c unpaidInvoice : unpaidInvoices) {
                currentBatchDetails = currentBatchDetails + unpaidInvoice.Id + '\n';
            }

            // call the util method to populate the values
            snapshotRecordsToInsert = IITARUtilClass.populateARUnpaidInvoices(unpaidInvoices, s, endDate); 
            
            insert snapshotRecordsToInsert; 

            currentBatchDetails = '';
            
        } catch(exception ex) {
            system.debug('exception getMessage is : ' + ex.getTypeName() + ':'+ex.getMessage() + ':' + ex.getLineNumber() + ':' + ex.getStackTraceString() );
            
            errorLog += '\n' + 'An exception has occured, exception type is ' + ex.getTypeName() + ':'+ex.getMessage() + ':' + ex.getLineNumber() + ':' + ex.getStackTraceString() + '\n';
            errorLog += ': ' + currentBatchDetails; 
        }  
    }
    
    global void finish(Database.BatchableContext BC) {
        batchJob.invoiceit_s__Completed_Date_and_Time__c = system.now();

        if(errorLog == null) {
            batchJob.invoiceit_s__Status__c = 'Completed';
        } else {
            batchJob.invoiceit_s__Status__c = 'Completed with Errors';
            
            if(errorLog.Length() < 32768) {
                batchJob.invoiceit_s__Exception_Log__c = errorLog; 
            } else {
                Attachment attachment = new Attachment();
                attachment.Body = Blob.valueOf(errorLog);
                attachment.Name = 'ErrorLog.txt';
                attachment.ParentId = batchJob.Id; 
                insert attachment;  
                
                batchJob.invoiceit_s__Exception_Log__c = 'Error log is attached and the same can be found attachement releated list';
            }
        }

        update batchJob;
    }        
}