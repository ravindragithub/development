trigger IITTriggerOnInvoice on invoiceit_s__Invoice__c (before update) {
    IITClassAfterOnInvoice.handleBeforeOnInvoice(trigger.newMap, trigger.oldMap);
}