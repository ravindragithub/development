/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class BatchForPostingInvoices implements Database.AllowsCallouts, Database.Batchable<SObject>, Database.Stateful {
    global invoiceit_s__Batch_Jobs__c batchJob;
    global String errorLog;
    global String InvoiceStatus;
    global static Boolean isExecuteAvaTax;
    global Boolean isPostInvoice;
    global String sQuery;
    global BatchForPostingInvoices(String query) {

    }
    global BatchForPostingInvoices(String query, Boolean isExecute) {

    }
    global void execute(Database.BatchableContext BC, List<invoiceit_s__Invoice__c> scope) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return null;
    }
}
