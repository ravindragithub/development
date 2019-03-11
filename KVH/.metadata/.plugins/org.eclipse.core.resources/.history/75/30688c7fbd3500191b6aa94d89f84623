Public Class UtilityCaseTrigger{
   
    public static Map<ID,ID> findPlatformParentAccIds(Set<Id> collectPlatformAccIds){
        
        Map<ID,ID> returnAccParentIds = new Map<ID,ID>();
        List<Account> findParentAccount = [Select id,ParentID from Account where id=:collectPlatformAccIds];
        
        for(Account acc:findParentAccount){
            if(acc.parentId!=null){
                returnAccParentIds.Put(acc.id,acc.parentId);
            }
        }
        
        return returnAccParentIds;
    }
    
}