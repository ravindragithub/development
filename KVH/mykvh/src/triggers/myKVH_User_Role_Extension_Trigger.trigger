trigger myKVH_User_Role_Extension_Trigger on myKVH_User_Role_Extension__c (after insert, before delete) {
	// This is the only line of code that is required to use the Trigger Architecture package
	//TriggerFactory.createTriggerDispatcher(myKVH_User_Role_Extension__c.sObjectType); 
	myKVH_User_Role_Extension_Utilities util = new myKVH_User_Role_Extension_Utilities();
	if(Trigger.isInsert){
		util.SendTomyKVH(Trigger.new);
	}
	if(Trigger.isDelete){
		util.SendTomyKVH(Trigger.old);
	}
}