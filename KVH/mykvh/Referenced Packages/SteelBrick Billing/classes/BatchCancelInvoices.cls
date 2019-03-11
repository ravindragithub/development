/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class BatchCancelInvoices implements Database.Batchable<SObject>, Database.Stateful {
    global String query;
    global Set<Id> setOfInvoicesId;
    global BatchCancelInvoices(Set<Id> setOfInvoicesId) {

    }
    global void execute(Database.BatchableContext BC, List<invoiceit_s__Invoice__c> scope) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return null;
    }
}
