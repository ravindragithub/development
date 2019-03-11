/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class BatchInvoiceGeneration implements Database.Batchable<invoiceit_s__Job__c>, Database.Stateful {
    global invoiceit_s__Invoice_Run__c invoiceRun;
    global Integer noOfAccountsProcessed;
    global Integer noOfCreditNotesGenerated;
    global Integer noOfDaysToDueDate;
    global Integer noOfInvoicesGenerated;
    global Integer noOfJobsProcessed;
    global Double totalInvoiceValue;
    global BatchInvoiceGeneration() {

    }
    global void execute(Database.BatchableContext BC, List<invoiceit_s__Job__c> scope) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global System.Iterable start(Database.BatchableContext BC) {
        return null;
    }
}
