/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ClassforCalculatingTax {
    global ClassforCalculatingTax() {

    }
    global static invoiceit_s.ClassforCalculatingTax.ClassTaxParameters cancelTaxForInvoice(invoiceit_s__Tax_Integration__c taxIntegration, invoiceit_s__Invoice__c invoice) {
        return null;
    }
    global static invoiceit_s.ClassforCalculatingTax.ClassTaxParameters getTaxForInvoice(invoiceit_s__Tax_Integration__c taxIntegration, String sObjectId) {
        return null;
    }
    global static invoiceit_s.ClassforCalculatingTax.ClassTaxParameters getTaxForOrder(invoiceit_s__Tax_Integration__c taxIntegration, String sObjectId) {
        return null;
    }
    global static invoiceit_s.ClassforCalculatingTax.ClassTaxParameters postTaxForInvoice(invoiceit_s__Tax_Integration__c taxIntegration, invoiceit_s__Invoice__c invoice, Decimal taxamount) {
        return null;
    }
global class ClassBaseAddress {
    global String sAddressCode;
    global String scity;
    global String sCountry;
    global String sLine1;
    global String sLine2;
    global String sPostalCode;
    global String sRegion;
    global String sTaxRegionId;
    global ClassBaseAddress() {

    }
}
global class ClassLines {
    global Boolean bDiscounted;
    global Decimal dAmount;
    global Decimal dQty;
    global String sDescription;
    global String sDestinationCode;
    global String sItemCode;
    global String sLineNo;
    global String sOriginCode;
    global String sTaxCode;
    global ClassLines() {

    }
}
global class ClassTaxParameters {
    global Decimal calculatedTax;
    global Decimal dDiscount;
    global Decimal dExchangeRate;
    global Decimal dTotalAmount;
    global Decimal dTotalTax;
    global Boolean isSuccess;
    global List<invoiceit_s.ClassforCalculatingTax.ClassBaseAddress> listofClassBaseAddress;
    global List<invoiceit_s.ClassforCalculatingTax.ClassLines> listofClassLines;
    global String sAdapter;
    global String sCancelCode;
    global String sCurrencyCode;
    global String sCustomerCode;
    global String sDestinationCode;
    global String sDetails;
    global String sDocCode;
    global String sDocDate;
    global String sDocId;
    global String sDocStatus;
    global String sDocType;
    global String sExchangeRateEffDate;
    global String sMessage;
    global String sOriginCode;
    global String sPaymentDate;
    global String sSummary;
    global String sTaxType;
    global String sTransactionId;
    global invoiceit_s__Tax_Integration__c taxIntegrationObj;
    global ClassTaxParameters() {

    }
}
}
