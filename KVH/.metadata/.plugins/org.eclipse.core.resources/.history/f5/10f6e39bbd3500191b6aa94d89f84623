trigger OpportunityTrigger on Opportunity (after insert,after update) {
    Set<Id> oppIds = new Set<Id>();
    for(Opportunity opp : trigger.new){
        if(trigger.isInsert && opp.Notify_Application_Engineering__c){
            oppIds.add(opp.Id);
        }else if(trigger.isUpdate && opp.Notify_Application_Engineering__c && trigger.oldMap.get(opp.Id).Notify_Application_Engineering__c == false){
            oppIds.add(opp.Id);
        }
    }
    
    // call create application engineering create method from helper class
    if(oppIds.size() > 0)
        OpportunityTriggerHelper.createApplicationEngineeringCase(oppIds);
}