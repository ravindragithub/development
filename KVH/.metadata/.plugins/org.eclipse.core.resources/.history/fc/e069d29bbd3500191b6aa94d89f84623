trigger Media_Server_Configuration_Trigger on Media_Server_Configuration__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
//HINT: replace "sObject" with the name of the Salesforce sObject the trigger is to act upon (e.g. Lead, Beam__c....)
//Unused Context handler calls commented out
    //Instantiate the handler using the constructor and two trigger context variables
    MediaServerTriggerHandler handler = new MediaServerTriggerHandler(Trigger.isExecuting, Trigger.size);
	// Before Insert
    if(Trigger.isInsert && Trigger.isBefore){
        //handler.OnBeforeInsert(Trigger.new);
    }
    // After Insert
    else if(Trigger.isInsert && Trigger.isAfter){
        handler.OnAfterInsert(Trigger.new);
    } /* Don't need these contexts....
    // Before Update
    else if(Trigger.isUpdate && Trigger.isBefore){
        //handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.newMap);
    }
    // After Update
    else if(Trigger.isUpdate && Trigger.isAfter){
        //handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap);
    }
    // Before Delete
    else if(Trigger.isDelete && Trigger.isBefore){
        //handler.OnBeforeDelete(Trigger.old, Trigger.oldMap);
    }
    // After Delete
    else if(Trigger.isDelete && Trigger.isAfter){
        //handler.OnAfterDelete(Trigger.old, Trigger.oldMap);
    }
    // After Undelete
    else if(Trigger.isUnDelete){
        //handler.OnUndelete(Trigger.new);
    } */
}