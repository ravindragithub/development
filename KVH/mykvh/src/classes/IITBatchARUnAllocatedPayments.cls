// this batch will export all the unpaid invoices present in the system based on the date and will stamp the values in AR Object
// UnAllocated amount > 0
// Status should be completed
// Payment date
global class IITBatchARUnAllocatedPayments implements Database.Batchable<sObject>, Database.Stateful {
	
	global String query;
    global Date endDate;
    global Date startDate;
    global string legalEntity;
    global string errorLog = null;
    invoiceit_s__Batch_Jobs__c batchJob;
    string currentBatchDetails = '';
    string realTime = '';
	
	global IITBatchARUnAllocatedPayments(Date endDate, String query, boolean useInternalQuery, string legalEntity) {
		//
        if(useInternalQuery == true || useInternalQuery == null) {
            system.debug('endDate==== ' + endDate);
            this.endDate = endDate;
            startDate = Date.newInstance(endDate.year(), endDate.month(), 1);
            this.query = 'SELECT invoiceit_s__Account__c, invoiceit_s__Allocated_Amount__c, invoiceit_s__Amount__c,invoiceit_s__Payment_Date__c,invoiceit_s__Status__c, invoiceit_s__Unallocated_Amount__c, UnAllocated_Amount_180_Days__c, UnAllocated_Amount_0_30_Days__c, UnAllocated_Amount_121_180_Days__c, UnAllocated_Amount_31_60_Days__c, UnAllocated_Amount_61_90_Days__c, UnAllocated_Amount_91_120_Days__c FROM invoiceit_s__Payment__c WHERE invoiceit_s__Status__c = \'' + 'Completed' + '\' AND invoiceit_s__Unallocated_Amount__c != 0 AND invoiceit_s__Payment_Date__c <=: endDate' + ' AND ' + legalEntity;  
            this.legalEntity = legalEntity;
        } else {
            this.query = query; 
            this.endDate = endDate;
            this.realTime = '-' + string.valueOf(system.today().day()) + '-RealTime';
        }  

        batchJob = new invoiceit_s__Batch_Jobs__c(Name = 'BatchARUnAllocatedPayments - ' + system.today(), invoiceit_s__Type__c = 'BatchARUnAllocatedPayments', invoiceit_s__Start_Date_and_Time__c = system.now(), invoiceit_s__Status__c = 'Processing');
        insert batchJob;  	
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		system.debug('query==== ' + query);
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		try {
            list<invoiceit_s__Payment__c> unAllocatedPayments = scope;
            list<AR_Snapshot__c> snapshotRecordsToInsert = new list<AR_Snapshot__c>();
            string s = string.valueOf(endDate.year()) + string.valueOf(endDate.month()) + realTime;
            
            currentBatchDetails = '\n' + '\n' + '\n';
            for(invoiceit_s__Payment__c payment : unAllocatedPayments) {
                currentBatchDetails = currentBatchDetails + payment.Id + '\n';
            }

            // call the util method to populate the values
            snapshotRecordsToInsert = IITARUtilClass.populateARUnAllocatedPayments(unAllocatedPayments, s, endDate);  
            
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