trigger SvcByPortTrigger on Services_by_Port__c (after insert, after update, before delete, before insert, before update) {
	// This is the only line of code that is required.
	TriggerFactory.createTriggerDispatcher(Services_by_Port__c.sObjectType);
}