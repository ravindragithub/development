/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class BatchChargePaymentPlanInstallmentProcess implements Database.AllowsCallouts, Database.Batchable<SObject>, Database.Stateful {
    global invoiceit_s__Batch_Jobs__c batchJobsObj;
    global String errorLog;
    global List<invoiceit_s__Payment_Plan_Installment__c> listOfPaymentInstalmentsToUpdate;
    global List<invoiceit_s__Payment__c> listOfPayments;
    global Decimal nofOfDaysBetweenRetries;
    global Decimal noOfMaxDaysBetweenRetries;
    global Decimal noOfMaxRetries;
    global Date processDate;
    global BatchChargePaymentPlanInstallmentProcess(Date processDate) {

    }
    global void execute(Database.BatchableContext BC, List<invoiceit_s__Payment_Plan_Installment__c> scope) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return null;
    }
}
