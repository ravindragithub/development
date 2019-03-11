/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class BatchRenewOrders implements Database.Batchable<SObject>, Database.Stateful {
    global Date advanceProcessDate;
    global invoiceit_s__Batch_Jobs__c batchJobsObj;
    global String errorLog;
    global Integer iAdvanceNotice;
    global Boolean isBatchJobsExecuting;
    global Date renewProcessDate;
    global String sPrefix;
    global String squery;
    global String sSelectedBatches;
    global BatchRenewOrders(Boolean isExecuting) {

    }
    global void execute(Database.BatchableContext BC, List<invoiceit_s__Job__c> scope) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return null;
    }
}
