trigger IITTriggerOnQuoteRatePlanCharges_KVH on invoiceit_s__Quote_Rate_Plan_Charge__c (before insert, before update) {
    
    IITClassAfterOnQuoteRatePlanCharges handler = new IITClassAfterOnQuoteRatePlanCharges();
    
    if(trigger.isBefore) {
        handler.handleBeforeOnQuoteCharge(trigger.newMap, trigger.oldMap, trigger.New);    
    }
}