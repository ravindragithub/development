trigger IITTriggerOnJobRatePlanCharges_KVH on invoiceit_s__Job_Rate_Plan_Charge__c (before insert, before update, after insert, after delete) {
    
    public static integer i;
    system.debug('IITTriggerOnJobRatePlanCharges_KVH ' + IITClassAfterOnOrderRatePlanCharges.ExecuteTrigger);
    if(IITClassAfterOnOrderRatePlanCharges.ExecuteTrigger == true) {
        
        system.debug('i value is ' + i);
        
        if(i == null) {
            i = 1;
        }
            
        if(i <= 8) {
            system.debug('i executing trigger logic' + i);

            IITClassAfterOnOrderRatePlanCharges handler = new IITClassAfterOnOrderRatePlanCharges();

            if(trigger.isBefore) {
                handler.handleBeforeOnOrderCharge(trigger.newMap, trigger.oldMap, trigger.New);    
            } else if( (trigger.isInsert || trigger.isDelete) && trigger.isAfter) {
                //handler.handleAfterOnOrderCharge(trigger.newMap, trigger.oldMap, trigger.New);      
            }   
                  
            ++i;
        }
    }   
}