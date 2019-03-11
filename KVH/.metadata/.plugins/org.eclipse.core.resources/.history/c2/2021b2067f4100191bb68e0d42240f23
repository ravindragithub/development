public with sharing class MediaServerTriggerHandler {
//HINT: replace "sObject" with the name of the Salesforce sObject the trigger is to act upon (e.g. Lead, Beam__c....)
 
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
 
    //Contstructor, requires Boolean to help control recurrence, and batch size from Trigger
    public MediaServerTriggerHandler(boolean isExecuting, Integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
 	/* Don't need this context....
    public void OnBeforeInsert(Media_Server_Configuration__c[] newObjects){
        // EXECUTE BEFORE INSERT LOGIC
    }
	*/
    public void OnAfterInsert(Media_Server_Configuration__c[] newObjects){
        // EXECUTE AFTER INSERT LOGIC.... instanciate Utility Class
        AssetUtilities au = new AssetUtilities();
        List<Asset> returnList = new List<Asset>();					//not returning anything!
        returnList = au.CreateMediaServerAssets(newObjects);		//Hand off the Media Servers...
        system.debug(returnList.size());
    }
	/* Don't need any of these contexts....
    public void OnBeforeUpdate(Media_Server_Configuration__c[] oldObjects, Media_Server_Configuration__c[] updatedObjects, Map<Id, Media_Server_Configuration__c> ObjectMap){
        // BEFORE UPDATE LOGIC
    }
 
    public void OnAfterUpdate(Media_Server_Configuration__c[] oldObjects, Media_Server_Configuration__c[] updatedObjects, Map<Id, Media_Server_Configuration__c> ObjectMap){
        // AFTER UPDATE LOGIC
    }
 
    public void OnBeforeDelete(Media_Server_Configuration__c[] ObjectsToDelete, Map<Id, Media_Server_Configuration__c> ObjectMap){
        // BEFORE DELETE LOGIC
    }
 
    public void OnAfterDelete(Media_Server_Configuration__c[] deletedObjects, Map<Id, Media_Server_Configuration__c> ObjectMap){
        // AFTER DELETE LOGIC
    }
 
    public void OnUndelete(Media_Server_Configuration__c[] restoredObjects){
        // AFTER UNDELETE LOGIC
    }
	*/
    public boolean IsTriggerContext{
        get{ return m_isExecuting;}
    }
}