trigger AssetTrigger_V2 on Asset (after delete, after insert, after update, before delete, before insert, before update) {
	// This is the only line of code that is required to use the Trigger Architecture package
	TriggerFactory.createTriggerDispatcher(Asset.sObjectType); 
}