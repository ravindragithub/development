trigger IITTriggerOnInvoiceLine on invoiceit_s__Invoice_Lines__c (before insert, after insert,after update) {
    // Revenue_Recognition_Rule__c and date should inherit from ORPC
    // Recognition End Date = revenue recognition date + no of days between invoiceLine.charge start date and invoiceLine.charge end date
    
    /**************************************************************************/
    
    
    IITClassAfterOInvoiceLine classObject = new IITClassAfterOInvoiceLine();
    
    if(trigger.isBefore) {
        classObject.handleBeforeOnInvoiceLine(trigger.newMap, trigger.oldMap, trigger.New);        
    } else {
        classObject.handleAfterOnInvoiceLine(trigger.newMap, trigger.oldMap);
    }
    
    
    /*********************ABOVE CODE FROM IIT Team****************************************************/   
    
    
    /********************Creating New Invoice line commision record with ordercommision partner agent-- Following code From JKT-team***********/
    
    if(trigger.isAfter && trigger.isInsert){
        InvoiceLineObjectTrigger.CreatingInvoiceLineCommision(Trigger.new,'insert','notused');
    }  
    
    if(trigger.isAfter && trigger.isUpdate){
        InvoiceLineObjectTrigger.CreatingInvoiceLineCommision(Trigger.new,'update','notused');
    }
}