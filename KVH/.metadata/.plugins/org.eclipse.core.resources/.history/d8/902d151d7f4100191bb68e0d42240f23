global class UAccountShareBatch implements Database.Batchable<sObject>,Database.Stateful{
    //Variable Declartion
    global List<AccountShare> limitExceedsASDML = New List<AccountShare>();
    global final String Query; 
    global set <id> convQueues = new set <id>();
    
    public UAccountShareBatch (boolean isTest){
        //find all the top accounts
        String tmpQuery = 'Select Id, name, Apply_Custom_Sharing__c, parent.Apply_Custom_Sharing__c From Account where parent.apply_custom_sharing__c = false and Apply_Custom_Sharing__c = true ORDER BY Id';
        if(isTest == true){
            tmpQuery = tmpQuery + ' LIMIT 1';
        }  
        Query = tmpQuery;
    }
    global Database.QueryLocator start(Database.BatchableContext BC){   
        return Database.getQueryLocator(Query);
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        set <id> accountIds = new set <id>();
        for(sObject so : scope) 
        {
            Account a = (Account)so;
            accountIds.add(a.id);  
        }
        List<AccountShare> limitExceedsCount = New List<AccountShare>();
        //Call the helper class of each account and return the list Account Share records
        limitExceedsCount = UAccountShareJKT.createAccountShare(accountIds,true);
        if(limitExceedsCount !=null && limitExceedsCount.size()>0){
            limitExceedsASDML.addAll(limitExceedsCount);
        }    
    }
    global void finish(Database.BatchableContext BC){
        if(limitExceedsASDML.size()> 0){
            AccountShareDML b = new AccountShareDML(limitExceedsASDML);
            database.executebatch(b,4000);
        }
    }
}