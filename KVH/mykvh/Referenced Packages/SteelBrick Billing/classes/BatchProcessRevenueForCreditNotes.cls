/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class BatchProcessRevenueForCreditNotes implements Database.AllowsCallouts, Database.Batchable<SObject>, Database.Stateful {
    global invoiceit_s__Batch_Jobs__c batchJobsObj;
    global String errorLog;
    global List<Id> listOfCreditNoteIds;
    global BatchProcessRevenueForCreditNotes(List<Id> creditNoteIds) {

    }
    global void execute(Database.BatchableContext BC, List<invoiceit_s__Credit_Line__c> listOfCreditLines) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return null;
    }
}
