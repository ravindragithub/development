/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class BatchTransactions implements Database.AllowsCallouts, Database.Batchable<SObject>, Database.Stateful {
    global String errorLog;
    global List<invoiceit_s__Invoice__c> listOfInvoicesToUpdate;
    global List<invoiceit_s__Transaction__c> listOfTransactionsToUpdate;
    global Decimal noOfDaysBetweenRetries;
    global Integer noOfFailedTransaction;
    global Integer noOfInvoicesProcessed;
    global Integer noOfSuccesfullTransaction;
    global invoiceit_s__Payment_Run__c paymentRun;
    global invoiceit_s__Payment_Scheduler__c paymentScheduler;
    global String query;
    global Decimal totalTransactionsValue;
    global BatchTransactions(String query, invoiceit_s__Payment_Scheduler__c paymentScheduler) {

    }
    global void execute(Database.BatchableContext BC, List<SObject> scope) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return null;
    }
}
