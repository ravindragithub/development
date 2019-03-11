/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class BatchInvoiceGeneration1 implements Database.Batchable<SObject>, Database.Stateful {
    global Boolean automaticallyPostInvoices;
    global Id currencyId;
    global String currentChargeDetails;
    global SObject datedConversionRate;
    global String errorLog;
    global Date invoiceDate;
    global invoiceit_s__Invoice_Run__c invoiceRun;
    global String INVOICING_GROUP_BY;
    global Map<String,invoiceit_s__Sequence_Number__c> mapOfSequenceNumbersToUpdate;
    global Map<String,invoiceit_s__Payment_Terms__c> mapPaymentTerms;
    global Integer noOfAccountsProcessed;
    global Integer noOfCreditNotesGenerated;
    global Integer noOfDaysToDueDate;
    global Integer noOfInvoicesGenerated;
    global Integer noOfJobsProcessed;
    global String query;
    global Id schedulerId;
    global String schedulerName;
    global Set<Id> setOfAllAccountIdsProcessed;
    global Boolean shouldBillUsages;
    global Date targetDate;
    global Double totalInvoiceValue;
    global BatchInvoiceGeneration1(String query, String groupby, Date invoiceDate, Date targetDate, Id currencyId, String schedulerName, Id schedulerId) {

    }
    global void execute(Database.BatchableContext BC, List<SObject> scope) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return null;
    }
}
