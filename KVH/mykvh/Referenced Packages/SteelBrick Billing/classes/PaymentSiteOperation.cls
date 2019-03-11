/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class PaymentSiteOperation {
    global PaymentSiteOperation() {

    }
    global invoiceit_s.PaymentSiteOperation.GenericPaymentResult processGenericPayment(invoiceit_s.PaymentSiteOperation.GenericPaymentParameters genericPaymentParameters) {
        return null;
    }
    global String processPayment(invoiceit_s__Invoice__c invoice, invoiceit_s__Payment_Method__c paymentMethod, Id dummyPaymentMethodID, Decimal accountAdvanceRequestedAmount, Account account, Boolean isSaveCardDetails) {
        return null;
    }
    global String processPayment(invoiceit_s__Gateway__c gateWay, invoiceit_s__Invoice__c invoice, invoiceit_s__Payment_Method__c paymentMethod, Id dummyPaymentMethodID, Decimal accountAdvanceRequestedAmount, Account account, Boolean isSaveCardDetails, Id currencyId) {
        return null;
    }
global class GenericPaymentParameters {
    @WebService
    webService Account account;
    @WebService
    webService Decimal amountToProcess;
    @WebService
    webService String currencyISOCode;
    @WebService
    webService invoiceit_s__Gateway__c gateway;
    @WebService
    webService invoiceit_s__Invoice__c invoiceObj;
    @WebService
    webService invoiceit_s__Payment_Method__c paymentMethod;
    @WebService
    webService Boolean shouldTokenizeCard;
    global GenericPaymentParameters() {

    }
}
global class GenericPaymentResult {
    @WebService
    webService Boolean isSuccess;
    @WebService
    webService String message;
    @WebService
    webService String profileID;
    @WebService
    webService Boolean reloadPage;
    @WebService
    webService invoiceit_s__Transaction__c transactionObj;
    global GenericPaymentResult() {

    }
}
}
