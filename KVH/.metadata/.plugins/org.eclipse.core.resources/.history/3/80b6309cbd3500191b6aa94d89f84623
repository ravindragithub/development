trigger UserTrigger on User (after insert, after update, before insert, before update) {
	// This is the only line of code that is required to use the Trigger Architecture package
	TriggerFactory.createTriggerDispatcher(User.sObjectType); 
}