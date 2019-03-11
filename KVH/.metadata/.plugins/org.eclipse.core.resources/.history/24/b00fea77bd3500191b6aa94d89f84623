public class SvcByPortBeforeDeleteTriggerHandler extends TriggerHandlerBase{
	public override void mainEntry(TriggerParameters tp) {
		process((List<Services_by_Port__c>)tp.oldList);						// In a before delete trigger, the trigger accesses the records that will be
																// deleted with the Trigger.old list.
	}
	
	private static void process(List<Services_by_Port__c> listDeletedPorts) {
	List<myKVH_Deleted_Records__c> DeletesToCreate = new List<myKVH_Deleted_Records__c>();
		system.debug(listDeletedPorts.size());												//how big is the list from the trigger?
		for (Services_by_Port__c p : listDeletedPorts){										//Loop through the triggered Assets...
			myKVH_Deleted_Records__c DEL_Obj = new myKVH_Deleted_Records__c();				//and we need an instance of a single Deleted Object....
			DEL_Obj.Object_Type__c = 'Services_by_Port__c';									//Use API Name for SvcBy Ports rather than the myKVH Object type...
			DEL_Obj.Name = p.name;															//populate the rest of the record...
			DEL_Obj.Deleted_Record_ID__c = p.Id;											//(This is an important foreign key)
			DeletesToCreate.Add(DEL_Obj);													//....and add it to a list.
		}
	insert DeletesToCreate;																	//insert the Deleted Records, Workflow sends outbound messages
	}
	
	public override void inProgressEntry(TriggerParameters tp) {
		System.debug('This is an example for reentrant code...');
	}
}