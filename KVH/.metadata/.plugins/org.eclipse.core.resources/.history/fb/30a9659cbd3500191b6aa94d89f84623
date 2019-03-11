trigger subscriptionTrigger on SBQQ__Subscription__c ( after insert,after update)
{

    SubscriptionTriggerHandler handler = new SubscriptionTriggerHandler();
    if( Trigger.isInsert ){
        if(Trigger.isAfter)
        {
            handler.OnAfterInsertUpdate(trigger.New);
        }
    }
    else if ( Trigger.isUpdate ){
        if(Trigger.isAfter)
        {
            handler.OnAfterInsertUpdate(trigger.New);
        }
    }
}