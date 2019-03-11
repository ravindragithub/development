/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class Authorize_API_callouts {
    global String refId;
    global String validationMode;
    global Authorize_API_callouts() {

    }
    global System.HttpResponse authenticate() {
        return null;
    }
    global System.HttpResponse createCustomerPaymentProfileRequest(String refIdString, String validationModeString, String customerProfileIdString, hvk.Authorize_API_callouts.paymentProfile paymentProfileDetails) {
        return null;
    }
    global System.HttpResponse createCustomerProfileRequest(String refIdString, String validationModeString, hvk.Authorize_API_callouts.customerProfile custProfile, List<hvk.Authorize_API_callouts.paymentProfile> paymentProfileList) {
        return null;
    }
    global System.HttpResponse updateCustomerProfileRequest(String refIdString, hvk.Authorize_API_callouts.customerProfile custProfile) {
        return null;
    }
global class bankAccount {
    global String accountNumber;
    global String accountType;
    global String bankName;
    global String echeckType;
    global String nameOnAccount;
    global String routingNumber;
    global bankAccount() {

    }
}
global class billTo {
    global String faxNumber;
    global billTo() {

    }
    global void setAddress(String a) {

    }
    global void setCity(String ct) {

    }
    global void setCompany(String c) {

    }
    global void setCountry(String co) {

    }
    global void setFaxNumber(String fx) {

    }
    global void setFirstName(String fn) {

    }
    global void setLastName(String ln) {

    }
    global void setPhoneNumber(String ph) {

    }
    global void setState(String st) {

    }
    global void setZip(String z) {

    }
}
global class creditCard {
    global creditCard() {

    }
    global void setCardCode(String cvv) {

    }
    global void setCardNumber(String cc) {

    }
    global void setExpirationDate(String ed) {

    }
}
global class customerProfile {
    global customerProfile() {

    }
    global void setCustomerProfileId(String p) {

    }
    global void setDescription(String d) {

    }
    global void setEmail(String e) {

    }
    global void setmerchantCustomerId(String id) {

    }
}
global class payment {
    global hvk.Authorize_API_callouts.bankAccount bankAccount;
    global hvk.Authorize_API_callouts.creditCard creditCard;
    global payment() {

    }
}
global class paymentProfile {
    global hvk.Authorize_API_callouts.billTo billTo;
    global hvk.Authorize_API_callouts.payment payment;
    global paymentProfile() {

    }
    global void setCustomerType(String ct) {

    }
}
}
