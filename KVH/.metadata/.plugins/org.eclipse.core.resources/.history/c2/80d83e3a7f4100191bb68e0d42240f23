trigger Product2Trigger on Product2 ( after insert,after update,before delete){
    Product2TriggerHandler handler = new Product2TriggerHandler (Trigger.isExecuting, Trigger.size);
    
    if( Trigger.isInsert ){
        if(Trigger.isAfter){
            handler.OnAfterInsert(trigger.new);
        }
    }
    else if( Trigger.isUpdate ){
        if(Trigger.isAfter){
            handler.OnAfterUpdate(trigger.New ,trigger.Old,Trigger.NewMap,Trigger.OldMap);
        }
    }
    else if ( Trigger.isDelete ){
        if(Trigger.isBefore){
            handler.OnBeforeDelete(Trigger.OldMap);
        }
    }
    
}