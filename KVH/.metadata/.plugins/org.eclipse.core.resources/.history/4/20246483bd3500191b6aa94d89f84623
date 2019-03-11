public with sharing class myKVH_Role_TriggerHandler {
//HINT: replace "sObject" with the name of the Salesforce sObject the trigger is to act upon (e.g. Lead, Beam__c....)
 
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
 
    //Contstructor, requires Boolean to help control recurrence, and batch size from Trigger
    public myKVH_Role_TriggerHandler(boolean isExecuting, Integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
 
    public void OnBeforeInsert(myKVH_Role__c[] newObjects){
        // EXECUTE BEFORE INSERT LOGIC
    }
 
    public void OnAfterInsert(myKVH_Role__c[] newObjects){
        // EXECUTE AFTER INSERT LOGIC
    }
 
    public void OnBeforeUpdate(myKVH_Role__c[] oldObjects, myKVH_Role__c[] updatedObjects, Map<Id, myKVH_Role__c> ObjectMap){
        // BEFORE UPDATE LOGIC
    }
 
    public void OnAfterUpdate(myKVH_Role__c[] oldObjects, myKVH_Role__c[] updatedObjects, Map<Id, myKVH_Role__c> ObjectMap){
        // AFTER UPDATE LOGIC
    }
 
    public void OnBeforeDelete(myKVH_Role__c[] ObjectsToDelete, Map<Id, myKVH_Role__c> ObjectMap){
        // BEFORE DELETE LOGIC
    }
 
    public void OnAfterDelete(myKVH_Role__c[] deletedObjects, Map<Id, myKVH_Role__c> ObjectMap){
        // AFTER DELETE LOGIC
		system.debug('entering on after delete handler...');
		// ALL of the deleted myKVH_Field_Permissions__c need to have deleted records created...
		List<myKVH_Deleted_Records__c> DEL_List = new List<myKVH_Deleted_Records__c>();	// create a list of deleted records to create...

		for (myKVH_Role__c fp : deletedObjects) {			//Loop through the trigger records, onverting each to a myKVH Deleted Record type
			myKVH_Deleted_Records__c DEL_rec = new myKVH_Deleted_Records__c();
			DEL_rec.Deleted_Record_ID__c = fp.Id;					//(preserve record ID)
			DEL_rec.Name = fp.Name;									//(copy name)
			DEL_rec.Object_Type__c = 'myKVH_Role__c';					//(this is a constant based on the sObject tyep)
			DEL_List.add(DEL_rec);									//and add each conversion to the list of deleted records to create...
		}
		insert DEL_List;		// then insert the list...
    }
 
    public void OnUndelete(myKVH_Role__c[] restoredObjects){
        // AFTER UNDELETE LOGIC
    }
 
    public boolean IsTriggerContext{
        get{ return m_isExecuting;}
    }
}