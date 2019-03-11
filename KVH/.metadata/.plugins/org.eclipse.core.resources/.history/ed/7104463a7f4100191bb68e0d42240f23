trigger ProductOptionsTrigger on SBQQ__ProductOption__c(  before insert,before update){
    ProductOptionsTriggerHandler handler = new ProductOptionsTriggerHandler(Trigger.isExecuting, Trigger.size);
    if( Trigger.isInsert ){
        if(Trigger.isBefore){
            handler.OnBeforeInsert(trigger.new);
        }
    }
    else if ( Trigger.isUpdate ){
        if(Trigger.isBefore){
            handler.OnBeforeUpdate(trigger.New ,trigger.Old,Trigger.NewMap,Trigger.OldMap);
        }
    }
}