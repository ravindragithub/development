trigger ProductFeatureTrigger on SBQQ__ProductFeature__c(  before insert,before update, after update,before delete){
    ProductFeatureTriggerHandler handler = new ProductFeatureTriggerHandler(Trigger.isExecuting, Trigger.size);
    if( Trigger.isInsert ){
        if(Trigger.isBefore){
            handler.OnBeforeInsert(trigger.new);
        }
    }
    else if ( Trigger.isUpdate ){
        if(Trigger.isBefore){
            handler.OnBeforeUpdate(trigger.New ,trigger.Old,Trigger.NewMap,Trigger.OldMap);
        }
        else{
            handler.OnAfterUpdate(trigger.New ,trigger.Old,Trigger.NewMap,Trigger.OldMap);
        }
    }
    else if ( Trigger.isDelete ){
        if(Trigger.isBefore){
            handler.OnBeforeDelete(Trigger.OldMap);
        }
    }
}