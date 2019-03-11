trigger ProductAttributesTrigger on Product_Attribute__c(  before insert,before update){
    ProductAttributesTriggerHandler handler = new ProductAttributesTriggerHandler(Trigger.isExecuting, Trigger.size);
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