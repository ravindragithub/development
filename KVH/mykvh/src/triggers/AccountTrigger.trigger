trigger AccountTrigger on Account (before insert, before update, before delete,
                                    after insert, after update, after delete) 
{
    /*Added following constructor for AccountTriggerHandler 2/14/2013 jthom */
    AccountTriggerHandler handler = new AccountTriggerHandler(Trigger.isExecuting, Trigger.size);
        
    List<Account> records = trigger.isDelete ? trigger.old : trigger.new;
    
    if(Trigger.isBefore == true)
    {
        if(Trigger.isInsert == true)
        {
              UAccount.setApplyCustomSharingonReparent(records, trigger.oldMap);
              /*Added Following Line to Support creation of "Platform Accounts" while
              maintaining respect for required fields, Main Country and Main State 
              2/14/2013 jthom*/
              system.debug('Before Insert Context');
              handler.OnBeforeInsert(records);
        }
        else if(trigger.isUpdate == true)
        {
              UAccount.setApplyCustomSharingonReparent(records, trigger.oldMap);
        }
        else if(trigger.isDelete == true)
        {
            /*This context of the Trigger will create a new record
            in the myKVH deletedRecords object, which in turn will
            initiate a workflow rule and outbound message to myKVH
            9/23/13 jthom*/
            system.debug('Before Delete Context');
            handler.OnBeforeDelete(records, trigger.oldMap);
        }
    }
    else if(Trigger.isAfter == true)
    {
        if(Trigger.isInsert == true)
        {
            UAccount.UpdateParentAccountText(records, trigger.oldMap);  
            UAccount.setApplyCustomSharing(records, trigger.oldMap); 
        }
        else if(trigger.isUpdate == true)
        {
            UAccount.UpdateParentAccountText(records, trigger.oldMap);  
            UAccount.UpdateCaseAssetAccountName(records, trigger.oldMap);
            UAccount.setApplyCustomSharing(records, trigger.oldMap); 
        }
        
        else if(trigger.isDelete == true)
        {
            system.debug('After Delete Context');
            //handler.OnAfterDelete(records, trigger.oldMap);
        }
        else if(trigger.isUndelete == true)
        {
              
        }
    }
}