global class AccountShare_PortalContact_Batch implements Database.Batchable<sObject>,Database.Stateful{
    global List<AccountShare> limitExceedsASDML = New List<AccountShare>();
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        //find all the top accounts
        String tmpQuery = 'Select Id, name, Apply_Custom_Sharing__c, parent.Apply_Custom_Sharing__c From Account where parent.apply_custom_sharing__c = false and Apply_Custom_Sharing__c = true ORDER BY Id';
        //String tmpQuery = 'Select Id, name, Apply_Custom_Sharing__c, parent.Apply_Custom_Sharing__c From Account where parent.apply_custom_sharing__c = false and Apply_Custom_Sharing__c = true AND Id =: tempSet ORDER BY Id';
        return Database.getQueryLocator(tmpQuery);
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        set <id> accountIds = new set <id>();
        for(sObject so : scope) {
            Account a = (Account)so;
            accountIds.add(a.id);  
        }
        List<AccountShare> limitExceedsCount = New List<AccountShare>();
        //Call the helper class of each account and return the list Account Share records
        limitExceedsCount = AccountShare_PortalContact_BatchUtility.createAccountShare(accountIds);
        if(limitExceedsCount !=null && limitExceedsCount.size()>0){
            limitExceedsASDML.addAll(limitExceedsCount);
        }    
        
    }
    global void finish(Database.BatchableContext BC){
        system.debug(limitExceedsASDML.size()+'===limitExceedsASDML=='+limitExceedsASDML);
        if(limitExceedsASDML.size()> 0){
            AccountShareDML b = new AccountShareDML(limitExceedsASDML);
            database.executebatch(b,2000);
        }
    }
}