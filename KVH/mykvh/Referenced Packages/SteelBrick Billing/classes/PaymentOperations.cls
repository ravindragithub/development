/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class PaymentOperations {
    global PaymentOperations() {

    }
    webService static invoiceit_s.PaymentOperations.PaymentResult authorize(Id invoiceId, String invoiceName, Decimal amount) {
        return null;
    }
    webService static invoiceit_s.PaymentOperations.PaymentResult authorizeAndCharge(Id invoiceId, String invoiceName, Decimal amount) {
        return null;
    }
    webService static invoiceit_s.PaymentSiteOperation.GenericPaymentResult authorizeAndChargePaymentPlanInstalments(Id invoiceId, Id paymentMethodId, Decimal amount) {
        return null;
    }
    webService static invoiceit_s.PaymentOperations.PaymentResult refund(Id invoiceId, String invoiceName, Decimal amount) {
        return null;
    }
    webService static invoiceit_s.PaymentOperations.PaymentResult transactionRefund(Id transactionId) {
        return null;
    }
    webService static invoiceit_s.PaymentOperations.PaymentResult transactionVoid(Id transactionId) {
        return null;
    }
    webService static invoiceit_s.PaymentOperations.PaymentResult void(Id invoiceId) {
        return null;
    }
global class PaymentResult {
    @WebService
    webService String message;
    @WebService
    webService Boolean reloadPage;
    @WebService
    webService invoiceit_s__Transaction__c transactionObj;
    global PaymentResult() {

    }
}
}
