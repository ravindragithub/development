public with sharing class IITClassAfterOnInvoice {

    public static void handleBeforeOnInvoice(map<Id,invoiceit_s__Invoice__c> newMap, map<Id,invoiceit_s__Invoice__c> oldMap) {
    
        map<Id, invoiceit_s__Invoice__c> newMapInvoice = newMap;
        map<Id, invoiceit_s__Invoice__c> oldMapInvoice = oldMap;
        invoiceit_s__Invoice__c oldInvoice;
        boolean isLegalEntityExist = false;
        map<String, Legal_Entity__c> mapOfLegalEntityToUpdate  = new map<String, Legal_Entity__c>();
        mapOfLegalEntityToUpdate = Legal_Entity__c.getAll().deepClone();
        string invoiceNumber = '';
        Legal_Entity__c sequenceNumber;
        
        for(invoiceit_s__Invoice__c invoice :  newMapInvoice.values()) {
                oldInvoice = oldMapInvoice.get(invoice.Id);
            
            if(invoice.invoiceit_s__Invoice_Reference__c == null && invoice.Legal_Entity__c != null && invoice.Legal_Entity__c != oldInvoice.Legal_Entity__c && mapOfLegalEntityToUpdate.containsKey(invoice.Legal_Entity__c)) {
                isLegalEntityExist = true;
                invoiceNumber = '';
                sequenceNumber = mapOfLegalEntityToUpdate.get(invoice.Legal_Entity__c);
                // enter only if the next invoice next number is not null
                if(sequenceNumber.Invoice_Next_Number__c != null) {
                    if(sequenceNumber.Invoice_Prefix__c != null) {
                        invoiceNumber = sequenceNumber.Invoice_Prefix__c;
                    }
                    invoiceNumber = invoiceNumber + string.ValueOf(Integer.ValueOf(sequenceNumber.Invoice_Next_Number__c));
                    ++sequenceNumber.Invoice_Next_Number__c;
                    mapOfLegalEntityToUpdate.put(invoice.Legal_Entity__c, sequenceNumber);
                    invoice.invoiceit_s__Invoice_Reference__c = invoiceNumber;
                }
            }
        }
        
        if(isLegalEntityExist) {
            update mapOfLegalEntityToUpdate.values();
        }
    
    }
}