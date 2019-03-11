trigger PlatformShareTrigger on myKVH_Shared_Platforms__c (after insert, after update, before delete) {
	// This is the only line of code that is required to use the Trigger Architecture package
	//TriggerFactory.createTriggerDispatcher(Asset.sObjectType); 
	//need to invoke PlatformShareUtilities which will result in an OB message to myKVH
	myKVH_Shared_Platforms_Utilities util = new myKVH_Shared_Platforms_Utilities();
	if(Trigger.isInsert){
		util.SendTomyKVH(Trigger.new);
	}
	if(Trigger.isUpdate){
		util.SendTomyKVH(Trigger.new);
	}
	if(Trigger.isDelete){
		util.SendTomyKVH(Trigger.old);
	}
}