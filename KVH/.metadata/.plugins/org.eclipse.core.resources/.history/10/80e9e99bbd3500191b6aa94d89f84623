trigger OrderCommisionTrigger on Order_Commissions__c (before insert,before update) {
    //Auto Populate CommisionRate Values
    if(Trigger.IsUpdate){
        OrderCommisionTriggerHandlerClass.AutoPopulateCommisionValues(Trigger.New,Trigger.NewMap,Trigger.OldMap,'Update');
    }
    
    if(Trigger.IsInsert){
        OrderCommisionTriggerHandlerClass.AutoPopulateCommisionValues(Trigger.New,Trigger.NewMap,null,'Insert');
    }
}