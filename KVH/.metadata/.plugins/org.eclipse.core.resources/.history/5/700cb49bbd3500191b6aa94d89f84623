trigger IITTriggerOnOpptyRatePlanCharges_KVH on invoiceit_crmx__Opportunity_Rate_Plan_Charge__c (before insert, before update) {
    
    IITClassAfterOnOpptyRatePlanCharges handler = new IITClassAfterOnOpptyRatePlanCharges();
    
    if(trigger.isBefore) {
        handler.handleBeforeOnOpptyCharge(trigger.newMap, trigger.oldMap, trigger.New);    
    } 
}