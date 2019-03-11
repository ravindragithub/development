global class AccountShareDML implements Database.Batchable<sObject>,Database.Stateful{
    Global List<AccountShare> collectingHere = New List<AccountShare>();
    public Integer failurecount;
    public Integer successCount;
    public List<UAccountShareJKT_Utility.wrapAccountError> failedAccountShareRecords = New List<UAccountShareJKT_Utility.wrapAccountError>();
    global AccountShareDML(List<AccountShare> collectShares){
        failurecount = 0;
        successCount= 0;
        collectingHere = collectShares;
    }
    global List<AccountShare> start(Database.BatchableContext BC){
        return collectingHere;
    }
    global void execute(Database.BatchableContext BC, List<AccountShare> scope){
        Database.SaveResult[] lsr = Database.insert(scope,false);
        Integer recordid2 = 0;
        set<Id> userId = new Set<Id>();
        for (Database.SaveResult SR : lsr) {
            recordid2++;
            if (!SR.isSuccess()) {
                userId.add(scope[recordid2].UserOrGroupId);
            }
        }
        Map<Id,User> mapUserIdProfile = new Map<Id,User>();     
        for(User usrList : [select id,Name,Profile.Name from User where Id IN: userId]){
            mapUserIdProfile.put(usrList.Id,usrList);
        }
        Integer recordid = 0;
        for (Database.SaveResult SR : lsr) {
            recordid++;
            if (!SR.isSuccess()) {
                failedAccountShareRecords.add(new UAccountShareJKT_Utility.wrapAccountError(mapUserIdProfile.get(scope[recordid].UserOrGroupId).Name,mapUserIdProfile.get(scope[recordid].UserOrGroupId).Profile.Name,scope[recordid].AccountId,scope[recordid].AccountAccessLevel,scope[recordid].OpportunityAccessLevel ,scope[recordid].CaseAccessLevel ,string.Valueof(SR.getErrors())));
                failurecount++;
                system.debug(failedAccountShareRecords+'===failedAccountShareRecords==');
            } 
            else
                successCount++;
        }
        system.debug(failurecount +'@@==failurecount==@@'+successCount);
    }
    global void finish(Database.BatchableContext BC){
        //Code to send the Enhance report to running User
        system.debug(failurecount +'==failurecount =='+successCount);
        if(failurecount > 0 ){
            UAccountShareJKT_Utility.sendEnhanceReport(failedAccountShareRecords,BC.getJobId(),failurecount,successCount);
        }
    }
}