/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class EmailStorageDetailPageLiteEditController {
    global EmailStorageDetailPageLiteEditController() {

    }
    @RemoteAction
    global static String deleteEmailMessage(String message_id) {
        return null;
    }
    @RemoteAction
    global static String forward(String message_id) {
        return null;
    }
    global static List<Attachment> getAllMessageAttachments(String message_id) {
        return null;
    }
    global static List<SObject> getAllMessageFiles(String message_id) {
        return null;
    }
    @RemoteAction
    global static ortoo_e2a.EmailStorageDetailPageLiteEditController.DetailPageItem getEmailMessage(String message_id) {
        return null;
    }
    global static List<ortoo_e2a__EmailMessage__c> getEmailMessageOnId(String message_id) {
        return null;
    }
    global static String getParentRecordId(String message_id, String owner_object_prefix) {
        return null;
    }
    @RemoteAction
    global static String reply(String message_id) {
        return null;
    }
    @RemoteAction
    global static String replyAll(String message_id) {
        return null;
    }
    @Deprecated
    global static Boolean saveEmailMessage(String message_id, String email_from, String email_subject, String email_body, String email_to, String email_cc, String email_bcc) {
        return null;
    }
    @RemoteAction
    global static Boolean saveMessage(String message_id, String email_from, String email_subject, String email_body, String is_rich_text, String email_to, String email_cc, String email_bcc) {
        return null;
    }
global class DetailPageItem {
    global String attachmentType {
        get;
        set;
    }
    global String emailBcc {
        get;
        set;
    }
    global String emailBody {
        get;
        set;
    }
    global String emailCc {
        get;
        set;
    }
    global String emailDate {
        get;
        set;
    }
    global String emailFrom {
        get;
        set;
    }
    global String emailSubject {
        get;
        set;
    }
    global String emailTo {
        get;
        set;
    }
    global String isRichText {
        get;
        set;
    }
    global List<ortoo_e2a.EmailStorageDetailPageLiteEditController.MessageAttachment> messageAttachment {
        get;
        set;
    }
    global String noLinkForOwnerObject {
        get;
        set;
    }
    global String ownerObjectId {
        get;
        set;
    }
    global String ownerObjectRecordName {
        get;
        set;
    }
    global DetailPageItem() {

    }
}
global class MessageAttachment {
    global String attachmentId {
        get;
        set;
    }
    global String attachmentName {
        get;
        set;
    }
    global String attachmentType {
        get;
        set;
    }
    global MessageAttachment() {

    }
}
}
